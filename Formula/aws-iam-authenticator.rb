class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.3",
      revision: "a0516fb9ace571024263424f1770e6d861e65d09"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30639bda3ecb72388aeabc0f3e6587f58bc9867dc6b3a9f3046e9d0ef659f122"
    sha256 cellar: :any_skip_relocation, big_sur:       "a161d4ea3ef00ab85c8f0cea198e0dafde39cd3a76359b75ea22521c35eac7d6"
    sha256 cellar: :any_skip_relocation, catalina:      "192ace97a0c76ed0aceda060290db6abcde5af8ad7dfc30faaf5f4ed4ae92b6a"
    sha256 cellar: :any_skip_relocation, mojave:        "c7f23ccd6bdd852a7c1928df437381204aa9da22a2f41eb3a5776864838f39db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4f5af9a91eda6c629d9fd98e098bdd27e3683a8ca9c2fff19a500edc721fb9" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end
