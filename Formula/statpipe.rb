class Statpipe < Formula
  desc "Swiss-knife statistics for logfiles and pipes"
  homepage "https://github.com/auduny/statpipe"
  url "https://github.com/auduny/statpipe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "013b2904071a50ab31bfb7593026dbe029119925a4f1a7246f3845540f17da53"
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
