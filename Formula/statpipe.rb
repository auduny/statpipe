class Statpipe < Formula
  desc "Swiss-knife statistics for logfiles and pipes"
  homepage "https://github.com/auduny/statpipe"
  url "https://github.com/auduny/statpipe/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "8680414a024040d5bede12d28ed2b254bf8f2be3985849a42d0151e0b36d9a51"
  license "GPL-2.0-only"

  uses_from_macos "perl"

  def install
    bin.install "statpipe"
  end

  test do
    output = pipe_output("#{bin}/statpipe --nohits 'user=(\\w+)'", "user=alice\nuser=bob\nuser=alice\n")
    assert_match "alice", output
    assert_match "2/3", output
  end
end
