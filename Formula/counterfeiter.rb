class Counterfeiter < Formula
  desc "Tool for generating self-contained, type-safe test doubles in go"
  homepage "https://github.com/maxbrunsfeld/counterfeiter"
  url "https://github.com/maxbrunsfeld/counterfeiter/archive/v6.4.1.tar.gz"
  sha256 "bd51c80ad44881ae2008e50540fcb95a3f8e84104ee230aee86acf78c2c24bf6"
  license "MIT"
  head "https://github.com/maxbrunsfeld/counterfeiter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9cdad6769afe63f7dfdaaac7758e0bf6cc5d8265a4ab274d2f008b36ee201eb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, catalina:      "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, mojave:        "400bb2b8fded512c283254548bea1e294b61649ec8a84218966e8a710117ecba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff94534be49dfa6c15d759ba6bf7ea7697dcff89c3d3d201f8353f253c8b8f6" # linuxbrew-core
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GOROOT"] = Formula["go"].opt_libexec

    output = shell_output("#{bin}/counterfeiter -p os 2>&1")
    assert_predicate testpath/"osshim", :exist?
    assert_match "Writing `Os` to `osshim/os.go`...", output

    output = shell_output("#{bin}/counterfeiter -generate 2>&1", 1)
    assert_match "no buildable Go source files", output
  end
end
