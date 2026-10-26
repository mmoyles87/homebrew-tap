class Jotmail < Formula
  desc "Notes from your IMAP mailbox (Apple Notes, Fastmail), in a terminal"
  homepage "https://github.com/mmoyles87/jotmail"
  url "https://github.com/mmoyles87/jotmail/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1f71ab7514b012a3ec62df8b5c6b1875efb698f6f4c9b847983a1722e5aecade"
  license "GPL-3.0-or-later"
  head "https://github.com/mmoyles87/jotmail.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "webp"

  uses_from_macos "zlib"

  resource "ftxui" do
    url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v7.0.3.tar.gz"
    sha256 "e7c62ffe19009759821b4f0f8df7f2a6fb83784c3a9f1477d81f56d3ee723c88"
  end

  resource "tomlplusplus" do
    url "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz"
    sha256 "8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155"
  end

  resource "stb" do
    url "https://github.com/nothings/stb/archive/2c980bb59875b0d32144a71867fbdebb2f77cd20.tar.gz"
    sha256 "9a955b1b49a4410088a2e0ee2a9c057c3c907d0c1d75454144cb980aca0ba515"
  end

  resource "vmime" do
    url "https://github.com/kisli/vmime/archive/63ddb3b378487e7209ec3390cb33c6cde9bdec0a.tar.gz"
    sha256 "1ddaeef647ad2919e1a901f4aa2427c722515d66c66e7ca9d704a91d46c3e30b"
  end

  def install
    deps = %w[ftxui tomlplusplus stb vmime].map do |name|
      (buildpath/"deps"/name).install resource(name)
      "-DFETCHCONTENT_SOURCE_DIR_#{name.upcase}=#{buildpath}/deps/#{name}"
    end
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
           "-DJOTMAIL_TESTS=OFF",
           "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
           "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
           *deps, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jotmail --version")
    ENV["XDG_CONFIG_HOME"] = testpath
    assert_match "no config", shell_output("#{bin}/jotmail list 2>&1", 1)
  end
end
