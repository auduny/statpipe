class Statpipe < Formula
  desc "swiss knife statistics"
  homepage "https://github.com/auduny/statpipe"
  head "https://github.com/auduny/statpipe.git"

  depends_on "perl"

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "statpipe"
  end
end
