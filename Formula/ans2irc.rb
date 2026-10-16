class Ans2irc < Formula
  desc "Convert ANSI art to mIRC-coloured text that fits in IRC messages"
  homepage "https://github.com/mmoyles87/ans2irc"
  url "https://github.com/mmoyles87/ans2irc/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d5135fdb7cf904dab761cb7236b6c9b7fe4fd9852689541f1f83588ff3205086"
  license "GPL-3.0-or-later"
  head "https://github.com/mmoyles87/ans2irc.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/ans2irc.1"
  end

  test do
    assert_equal "\x034,1Hi\n", pipe_output(bin/"ans2irc", "\e[1;31mHi\e[0m")
    assert_match version.to_s, shell_output("#{bin}/ans2irc --version")
  end
end
