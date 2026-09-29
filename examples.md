# EXAMPLES

    # Show the most visited urls in a logfile
    $ cat testfiles/access.log | statpipe -f 7

    # Most active ip's that are not 10.84.X.X
    $ varnishncsa |statpipe -f 7 --limit 15 --not 10.84 '^([^\?]+)\??'

    # Separate fields by " and show field two
    $ tail -f /var/log/httpd/access.log | statpipe -d \" -f 2

    # Group jpeg and jpg differently
    $ tail -f /var/log/httpd/access.log | statpipe 'jpe?g' png gif

    # Group jpeg and jpg into one key
    $ tail -f /var/log/httpd/access.log | statpipe '(jpe?g)' png gif --not gift

    # Count all letters in a file
    $ cat testfiles/words.txt | statpipe --multi '(\w)'

    # List top 20 articles the last 10 seconds
    $ tail -f /var/log/httpd/access.log | statpipe 'artid=(\d+)' --maxtime=10 --limit 20 --time=0
