class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.3.0.tar.gz"
  sha256 "2786c0e7ebe138de3a05320525eba4d4b718d36ea7557a9b0e2009f18b59a43b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "597d988f4aeac426ecaebdc534b3c03a675a2853bc0127b3656b5842ceff8644"
    sha256 cellar: :any_skip_relocation, big_sur:       "29aa78a8155cfd349cc51df530c6f1678411e42cd490349e8beed100244d001e"
    sha256 cellar: :any_skip_relocation, catalina:      "861d1048b9716f92236be766bdd9d98ced3596f368e2be76b74bbe923618af42"
    sha256 cellar: :any_skip_relocation, mojave:        "73f1c7ed5340c70681205550b9a3f44c2f7e2c55cc72c6a03a7e2a44425b5750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb2338c4f102a671e7ad16b98d6287643c43f0b40e022a039af5c72293ce0cd" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
