class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.4.2/commandbox-bin-5.4.2.zip"
  sha256 "88de96d481d32fd8e42b18e12492d1d1cf6cb70a8a1368d192ba7e8f3da9829a"
  license "LGPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "164fa28157354df34e3a320e4546f9be68cd3e94167e1aa819f5ff8d6192bfb7" # linuxbrew-core
  end

  # not yet compatible with Java 17 on ARM
  depends_on "openjdk@11"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.4.2/commandbox-apidocs-5.4.2.zip"
    sha256 "66c040230f3a2e2d3b03023d895416b271e62a7da264f25e3df02040099e67fc"
  end

  def install
    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env("11")
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
