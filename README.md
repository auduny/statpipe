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

- tail -f /var/log/httpd/access.log | pipestat -f 7

    I love norwegian country

- tail -f /var/log/httpd/access.log | pipestat -d \\" -f 2
- tail -f /var/log/httpd/access.log | pipestat jpe?g png gif
- tail -f /var/log/httpd/access.log | pipestat (jpe?g) png gif
- tail -f /var/log/httpd/access.log | pipestat (jpe?g) png gif
- tail -f /var/log/httpd/access.log | pipestat 'artid=(\\d+)' --maxtime=30 --limit 20 
