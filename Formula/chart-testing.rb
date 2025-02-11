class ChartTesting < Formula
  desc "Testing and linting Helm charts"
  homepage "https://github.com/helm/chart-testing"
  url "https://github.com/helm/chart-testing.git",
      tag:      "v3.4.0",
      revision: "68a43ac09699ef9473266457e893a7ddd7ef6b5b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/helm/chart-testing.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66bd1f0419bfcf97ce06a3a91f107735563ee94e1e5953bcad7e48d5f1a31e9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6179e0090f93f5bf67f92cd13fa391f898496211f7e1b58a1d3989f9b37b22c"
    sha256 cellar: :any_skip_relocation, catalina:      "556430cab62f842bfdcac97db34b96448bad3588a359aec2e2f9f21c5339f363"
    sha256 cellar: :any_skip_relocation, mojave:        "65760b4336f5f2005cdb7d001d3902c16530ed0dd6eeb68bdaab2d6389f63d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0acfbc95ad8b6e092a149692c43e1cb0401d10d741ce194c7083bc0d5b3465" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "helm" => :test
  depends_on "yamllint" => :test

  def install
    # Fix default search path for configuration files, needed for ARM
    inreplace "pkg/config/config.go", "/usr/local/etc", etc
    ldflags = %W[
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.Version=#{version}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.GitCommit=#{Utils.git_head}
      -X github.com/helm/chart-testing/v#{version.major}/ct/cmd.BuildDate=#{time.strftime("%F")}
    ].join(" ")
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"ct", "./ct/main.go"
    etc.install "etc" => "ct"
  end

  test do
    assert_match "Lint and test", shell_output("#{bin}/ct --help")
    assert_match(/Version:\s+#{version}/, shell_output("#{bin}/ct version"))

    # Lint an empty Helm chart that we create with `helm create`
    system "helm", "create", "testchart"
    output = shell_output("#{bin}/ct lint --charts ./testchart --validate-chart-schema=false" \
                          " --validate-maintainers=false").lines.last.chomp
    assert_match "All charts linted successfully", output
  end
end
