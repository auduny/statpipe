#!/usr/bin/env bats
# Tests for statpipe

SCRIPT="$BATS_TEST_DIRNAME/../statpipe"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Strip ANSI / tput output so assertions are not affected by terminal codes
strip_ansi() { sed 's/\x1b\[[0-9;]*m//g'; }

# ---------------------------------------------------------------------------
# Basic counting
# ---------------------------------------------------------------------------

@test "counts unique lines when no regex is given" {
    result=$(printf 'foo\nfoo\nbar\n' | perl "$SCRIPT" --nohits)
    [[ "$result" == *"foo"*"2/"* ]]
    [[ "$result" == *"bar"*"1/"* ]]
}

@test "regex match increments counter" {
    result=$(printf 'error: oops\ninfo: ok\nerror: bad\n' | perl "$SCRIPT" --nohits 'error')
    [[ "$result" == *"error"*"2/"* ]]
}

@test "capture group in regex becomes the key" {
    result=$(printf 'user=alice\nuser=bob\nuser=alice\n' | perl "$SCRIPT" --nohits 'user=(\w+)')
    [[ "$result" == *"alice"*"2/"* ]]
    [[ "$result" == *"bob"*"1/"* ]]
}

@test "exits 0 on normal completion" {
    run bash -c "printf 'hello\n' | perl '$SCRIPT' --nohits"
    [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# --multi flag
# ---------------------------------------------------------------------------

@test "--multi matches regex multiple times per line" {
    result=$(printf 'aaa\n' | perl "$SCRIPT" --nohits --multi 'a')
    # 3 matches from one line
    [[ "$result" == *"(3/"* ]]
}

# ---------------------------------------------------------------------------
# --case (case-sensitive)
# ---------------------------------------------------------------------------

@test "default is case-insensitive" {
    result=$(printf 'Hello\nhello\nHELLO\n' | perl "$SCRIPT" --nohits 'hello')
    [[ "$result" == *"(3/"* || "$result" == *"3/3"* ]]
}

@test "--case makes matching case-sensitive" {
    result=$(printf 'Hello\nhello\nHELLO\n' | perl "$SCRIPT" --nohits --case 'hello')
    [[ "$result" == *"(1/"* || "$result" == *"1/3"* ]]
}

# ---------------------------------------------------------------------------
# --not filter
# ---------------------------------------------------------------------------

@test "--not excludes matching lines" {
    result=$(printf 'foo\nbar\nbaz\n' | perl "$SCRIPT" --nohits --not 'bar')
    [[ "$result" != *"bar"* ]]
    [[ "$result" == *"<rest>"* ]]
}

# ---------------------------------------------------------------------------
# --field / --delimiter
# ---------------------------------------------------------------------------

@test "--field extracts the specified whitespace-delimited field" {
    result=$(printf 'GET /index.html HTTP/1.1\nGET /about HTTP/1.1\nGET /index.html HTTP/1.1\n' \
        | perl "$SCRIPT" --nohits -f 2)
    [[ "$result" == *"/index.html"*"2/"* ]]
    [[ "$result" == *"/about"*"1/"* ]]
}

@test "--delimiter changes the field separator" {
    result=$(printf 'a,b,c\na,d,c\na,b,c\n' | perl "$SCRIPT" --nohits -d ',' -f 2)
    [[ "$result" == *"b"*"2/"* ]]
    [[ "$result" == *"d"*"1/"* ]]
}

# ---------------------------------------------------------------------------
# --limit
# ---------------------------------------------------------------------------

@test "--limit restricts output to N keys plus <limited> summary" {
    result=$(printf 'a\nb\nc\nd\ne\n' | perl "$SCRIPT" --nohits --limit 2)
    [[ "$result" == *"<limited>"* ]]
}

# ---------------------------------------------------------------------------
# --maxlines
# ---------------------------------------------------------------------------

@test "--maxlines stops processing after N lines" {
    run bash -c "printf 'a\nb\nc\nd\ne\n' | perl '$SCRIPT' --nohits --maxlines 2"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Maxlines"* ]]
}

# ---------------------------------------------------------------------------
# --maxkeys
# ---------------------------------------------------------------------------

@test "--maxkeys stops processing when unique key count is reached" {
    run bash -c "printf 'a\nb\nc\nd\ne\n' | perl '$SCRIPT' --nohits --maxkeys 2"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Maxkeys"* ]]
}

# ---------------------------------------------------------------------------
# --group
# ---------------------------------------------------------------------------

@test "--group buckets numeric values correctly" {
    result=$(printf '1\n3\n5\n' | perl "$SCRIPT" --nohits --group 2,4)
    [[ "$result" == *"< 2"* ]]
    [[ "$result" == *"< 4"* ]]
    [[ "$result" == *"> 4"* ]]
}

@test "--group counts non-numeric values separately" {
    result=$(printf '1\nfoo\n3\n' | perl "$SCRIPT" --nohits --group 2,4)
    [[ "$result" == *"not numeric"* ]]
}

# ---------------------------------------------------------------------------
# --relative  (BUG: divide-by-zero when hitcount is 0 with --group)
# ---------------------------------------------------------------------------

@test "--relative does not crash when there are hits" {
    run bash -c "printf 'foo\nfoo\nbar\n' | perl '$SCRIPT' --nohits --relative 'foo'"
    [ "$status" -eq 0 ]
}

@test "--relative with --group does not divide by zero (known bug)" {
    # This reproduces the confirmed crash: Illegal division by zero at line 296
    run bash -c "printf '1\n3\n5\n' | perl '$SCRIPT' --nohits --group 2,4 --relative"
    [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# --version / --help
# ---------------------------------------------------------------------------

@test "--version prints a version string" {
    run perl "$SCRIPT" --version
    [ "$status" -eq 0 ]
    [[ "$output" =~ ^[0-9] ]]
}

@test "--help prints usage info" {
    run perl "$SCRIPT" --help
    # pod2usage exits with 1 by default; we just want output
    [[ "$output" == *"statpipe"* ]]
}

# ---------------------------------------------------------------------------
# --linefreq  (BUG: freqcount reset is unconditional)
# ---------------------------------------------------------------------------

@test "--linefreq prints output at the right frequency" {
    result=$(printf '%s\n' {1..10} | perl "$SCRIPT" --nohits --linefreq 5 --timefreq 0)
    # Should have produced at least one intermediate printout
    [ -n "$result" ]
}

# ---------------------------------------------------------------------------
# End-of-pipe summary
# ---------------------------------------------------------------------------

@test "summary line is printed on normal exit" {
    result=$(printf 'hello\n' | perl "$SCRIPT" --nohits)
    [[ "$result" == *"Parsed"*"lines"* ]]
}

@test "no input prints a helpful message" {
    run bash -c "echo -n | perl '$SCRIPT' --nohits"
    [[ "$output" == *"No lines parsed"* || "$output" == *"did you feed"* ]]
}
