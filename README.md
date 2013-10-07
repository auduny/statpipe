# Statpipe. The one and only cooltool

I like my tool


# NAME

statpipe - swiss knife statistics

# SYNOPSIS

tail -f some.log  | statpipe \[options\] \[regex\] ... \[regex\]

    Options:
     --timefreq|-t     Frequency of output in seconds (5)
     --linefreq        Frequency of output in lines (none)
     --maxtime         Time before closing the pipe in seconds (60)
     --maxlines        Maximum numbers of lines to parse (unlimited)
     --multi|m         Match multiple times per line (no)
     --field|f         What field top use as key
     --delimiter|d     What delimiter to use for fields (spaces)
     --limit           Limit output of keys (30)
     --maxkeys         Max number of unique keys (50000)
     --not|n           Exclude lines with regex
     --case|s          Be casesensetive
     --clear           Clear screen between updates
     --relative|r      Show relative percentages (no)
     --(no)hits        Show hits per second (yes)
     --help            Show help
     --version         Show version

If the regex has a grouping, the match will be used instead of the regex as a
key


# DESCRIPTION

statpipe is a excellent little tool to analyse logfiles, or any file
for that matter, and produce percentage of hits, hits per second and
other cool stuff.
It's supposed to be a better way of doing something similar to
tail -f | awk | cut| sort | unique  -c |sort -g | whatever.

# OPTIONS

    --timefreq|-t
    This changes the updateinterval of the statistics. Default is 5 seconds.
    Set it to 0 to turn it off.

    --linefreq|-t
    Same as above, just measured in number of lines parsed. Default is 0 (off)





# EXAMPLES

    Show top 30 visited urls. Update it every 5 seconds for 60 seconds (default)
    $ tail -f /var/log/httpd/access.log | statpipe -f 7

    Seperate fields by " and show field two
    $ tail -f /var/log/httpd/access.log | statpipe -d \\" -f 2

    Group jpeg and jpg differently
    $ tail -f /var/log/httpd/access.log | statpipe jpe?g png gif

    Group jpeg and jpg into one key
    $ tail -f /var/log/httpd/access.log | statpipe (jpe?g) png gif --not gift

    List top articles the last 10 seconds
    $ tail -f /var/log/httpd/access.log | statpipe 'artid=(\\d+)' --maxtime=10 --limit 20

TODO: Merge ($1) ($2) etc.
TODO: Switch to caculate percentage of hits instead of total
TODO: Name change: PMS? (Poor mans Splunk) (Pipe measure system), statpipe


