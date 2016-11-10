# Statpipe

# NAME

statpipe - swiss knife statistics

# DESCRIPTION

statpipe is a excellent little tool to analyse logfiles, or any file
for that matter, and produce percentage of hits, hits per second and
other cool stuff in the terminal
It's supposed to be a better way of doing something similar to
tail -f | awk | cut| sort | unique  -c |sort -g | whatever.

# SYNOPSIS

tail -f some.log  | statpipe \[options\] \[regex\] ... \[regex\]

Regex is a perl regex, if the regex has a group 'something\\.(.\*)' the
match will be used as a key instead of the regexp itself.

If no regex and no --field argument is given. It will be as '^(.\*)$' was given.
Meaning that it will count all unique lines in the file/pipe.

    Options:
     --field|f         What field top use as key (default all fields)
     --delimiter|d     What delimiter to use for fields (spaces)
     --timefreq|-t     Frequency of output in seconds (5)
     --linefreq        Frequency of output in lines (none)
     --maxtime         Time before closing the pipe in seconds (60)
     --maxlines        Maximum numbers of lines to parse (unlimited)
     --multi|m         Match multiple times per line (no)
     --limit           Limit output of keys (30)
     --maxkeys         Max number of unique keys (50000)
     --not|n           Exclude lines with regex
     --case|s          Be casesensetive
     --clear           Clear screen between updates
     --relative|r      Show relative percentages (no)
     --keysize|k       Length of keys (output)
     --(no)hits        Show hits per second (yes)
     --help            Show help
     --version         Show version

# EXAMPLES

    #Show top 30 visited urls. Update it every 5 seconds for 60 seconds (default)
    $ tail -f /var/log/httpd/access.log | statpipe -f 7

    #Seperate fields by " and show field two
    $ tail -f /var/log/httpd/access.log | statpipe -d \" -f 2

    #Group jpeg and jpg differently
    $ tail -f /var/log/httpd/access.log | statpipe 'jpe?g' png gif

    #Group jpeg and jpg into one key
    $ tail -f /var/log/httpd/access.log | statpipe '(jpe?g)' png gif --not gift

    #Count all words in a file
    $ cat file | statpipe --multi '(\w)'

    #List top 20 articles the last 10 seconds
    $ tail -f /var/log/httpd/access.log | statpipe 'artid=(\d+)' --maxtime=10 --limit 20 --time=0



# BUGS

Probably plenty.

# TODO

TODO: Merge ($1) ($2) etc.
TODO: Name change: PMS? (Poor mans Splunk) (Pipe measure system), statpipe
TODO: Read defaultsfile from .statpipe?

# COPYRIGHT

Audun Ytterdal <audun@ytterdal.net>
http://github.com/auduny/statpipe/
