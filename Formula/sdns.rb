class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.8.tar.gz"
  sha256 "5ffc8a72be67c3f9ce7200fd638ade6435ae177b09eda5eb149daadc66955ba6"
  license "MIT"
  revision 1
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ae97f45caa3d41c8061ac0564b7259a61677514313ded603164d969a82d9524"
    sha256 cellar: :any_skip_relocation, big_sur:       "9661ca9da8b66089c00952c5549cb2bdf79350a48c77f6fd4ea71a54dbb03469"
    sha256 cellar: :any_skip_relocation, catalina:      "2ae8cb3d2dc990880d4d743bf60054c8f671ee2ac887beb469cf141870a6ebd2"
    sha256 cellar: :any_skip_relocation, mojave:        "aaf89563a2012060701b1ac14de25f2f656bb38def9379a4c10e766a75866a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05cdf8398a13880ff8e0a3a52220341c1401692b70e210eccc0acff70b718e60" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/sdns</string>
            <string>-config</string>
            <string>#{etc}/sdns.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
