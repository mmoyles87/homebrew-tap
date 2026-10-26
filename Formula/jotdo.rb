class Jotdo < Formula
  desc "Reminders from your CalDAV server (Nextcloud, Apple Reminders), in a terminal"
  homepage "https://github.com/mmoyles87/jotdo"
  url "https://github.com/mmoyles87/jotdo/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f695bb71f57e5e654b683d01bd3699f394a408fee8b22c81842ba85eb4217826"
  license "GPL-3.0-or-later"
  head "https://github.com/mmoyles87/jotdo.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libical"
  depends_on "pugixml"

  uses_from_macos "curl"

  resource "ftxui" do
    url "https://github.com/ArthurSonzogni/FTXUI/archive/refs/tags/v7.0.3.tar.gz"
    sha256 "e7c62ffe19009759821b4f0f8df7f2a6fb83784c3a9f1477d81f56d3ee723c88"
  end

  resource "tomlplusplus" do
    url "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz"
    sha256 "8517f65938a4faae9ccf8ebb36631a38c1cadfb5efa85d9a72e15b9e97d25155"
  end

  def install
    deps = %w[ftxui tomlplusplus].map do |name|
      (buildpath/"deps"/name).install resource(name)
      "-DFETCHCONTENT_SOURCE_DIR_#{name.upcase}=#{buildpath}/deps/#{name}"
    end
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
           "-DJOTDO_TESTS=OFF",
           "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
           *deps, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jotdo --version")
    ENV["XDG_CONFIG_HOME"] = testpath
    assert_match "no config", shell_output("#{bin}/jotdo list 2>&1", 1)
  end
end
