class Statpipe < Formula
  desc "Swiss-knife statistics for logfiles and pipes"
  homepage "https://github.com/auduny/statpipe"
  url "https://github.com/auduny/statpipe/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "6f3d506a0598b9fdcb71286698f7d1395ebca543c528e0ee83154218c11985a9"
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
