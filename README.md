# Statpipe

# INSTALL

## Homebrew

    brew tap auduny/statpipe https://github.com/auduny/statpipe
    brew install auduny/statpipe/statpipe

## Manual

statpipe is a single perl script with no dependencies beyond perl's
core modules. Copy it somewhere in your PATH:

    curl -L -o /usr/local/bin/statpipe https://raw.githubusercontent.com/auduny/statpipe/master/statpipe
    chmod +x /usr/local/bin/statpipe

# NAME

statpipe - swiss knife statistics

# DESCRIPTION

statpipe is an excellent little tool to analyse logfiles, or any file
for that matter, grep for stuff and produce percentage of hits,
hits per second and other cool stuff.
It's supposed to be a better way of doing something similar to
tail -f | awk | cut | sort | unique  -c |sort -g | whatever.

# SYNOPSIS

tail -f some.log  | statpipe \[options\] \[regex\] ... \[regex\]

Regex is a perl regex, if the regex has a group 'something\\.(.\*)' the
match will be used as a key instead of the regexp itself.

If no regex and no --field argument is given. It will be as '^(.\*)$' was given.
Meaning that it will count all unique lines in the file/pipe.

    Options:
     --field|f         What field to use as key (default all fields)
     --delimiter|d     What delimiter to use for fields (spaces)
     --timefreq|-t     Frequency of output in seconds (1 second)
     --linefreq        Frequency of output in lines (none)
     --maxtime         Time before closing the pipe in seconds (unlimited)
     --maxlines        Maximum numbers of lines to parse (unlimited)
     --multi|m         Match multiple times per line (no)
     --limit           Limit output of keys (0)
     --maxkeys         Max number of unique keys (50000)
     --not|n           Exclude lines with regex
     --group|g         Group numeric input into buckets (comma separated limits)
                       Only used when no regex is given
     --case|i          Be case sensitive
     --clear           Clear screen between updates
     --relative|r      Show relative percentages (no)
     --keysize|k       Length of keys (output)
     --(no)hits        Show hits per second (yes)
     --title           Optional title
     --help            Show help
     --version         Show version

# EXAMPLES

    #Show the most visited urls in a logfile
    $ tail -f /var/log/httpd/access.log | statpipe -f 7

    #Separate fields by " and show field two
    $ tail -f /var/log/httpd/access.log | statpipe -d \" -f 2

    #Group jpeg and jpg differently
    $ tail -f /var/log/httpd/access.log | statpipe 'jpe?g' png gif

    #Group jpeg and jpg into one key
    $ tail -f /var/log/httpd/access.log | statpipe '(jpe?g)' png gif --not gift

    #Count all words in a file
    $ cat file | statpipe --multi '(\w)'

    #List top 20 articles the last 10 seconds
    $ tail -f /var/log/httpd/access.log | statpipe 'artid=(\d+)' --maxtime=10 --limit 20 --time=0

    # Group numeric values into buckets, e.g. response times
    $ cat response-times.log | statpipe --group 10,50,100,500



# BUGS

Probably plenty.

# TODO

TODO: Merge ($1) ($2) etc.
TODO: Name change: PMS? (Poor mans Splunk) (Pipe measure system), statpipe
TODO: Read defaultsfile from .statpipe?
TODO: Rare, reverse list
TODO: Threads (use threads) for output
TODO: Freqreset. REset numbers every X secons
TODO: Scriptfilter on output (geoip etc)
TODO: Fields in the form of -f-1 or -f2,

# PACKAGES (deb / rpm)

Prebuilt .deb and .rpm packages are attached to each
[release](https://github.com/auduny/statpipe/releases). They are
architecture independent and only need perl installed:

    sudo dpkg -i statpipe_*_all.deb      # Debian, Ubuntu, ...
    sudo dnf install statpipe-*.noarch.rpm  # Fedora, RHEL, ...

Both install /usr/bin/statpipe and a man page. The packages are
built by the packages.yml GitHub Action whenever a release is
published.

# COPYRIGHT

Audun Ytterdal <audun@ytterdal.net>
http://github.com/auduny/statpipe/
