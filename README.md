# NAME

Pipestat - swiss knife statistics

# SYNOPSIS

tail -f some.log  | pipestat \[options\] \[regex\] ... \[regex\]

    Options:
     --timefreq|-t     Frequency of output in seconds (5)
     --linefreq        Frequency of output in lines (none)
     --maxtime|-m      Time before closing the pipe in seconds (60)
     --maxlines        Maximum numbers of lines to parse (unlimited)
     --field|f         What field top use as key
     --delimiter|d     What delimiter to use for fields (spaces)
     --limit           Limit output of keys (30)
     --maxkeys         Max number of unique keys (50000)
     --not|n           Exclude lines with regex
     --case|s          Be casesensetive
     --hits            Show hits per second (yes)
     --help            Show help
     --version         Show version

# DESCRIPTION

Pipestat is a excellent little tool to analyse logfiles, or any file for that matter, and produce percentage of hits, hits per second and other cool stuff.
It's supposed to be a better way of doin tail -f | awk | cut| unique  |sort |uniqeue | whaterver. Or as a poor mans splunk

# EXAMPLES

    Show field two
    $ tail -f /var/log/httpd/access.log | pipestat -f 7

    Seperate fields by " and show field two
    $ tail -f /var/log/httpd/access.log | pipestat -d \\" -f 2

    Group jpeg and jpg differently
    $ tail -f /var/log/httpd/access.log | pipestat jpe?g png gif

    Group jpeg and jpg into one key
    $ tail -f /var/log/httpd/access.log | pipestat (jpe?g) png gif --not gift

    List top articles the last 10 seconds
    $ tail -f /var/log/httpd/access.log | pipestat 'artid=(\\d+)' --maxtime=10 --limit 20 
