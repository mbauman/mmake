#!/usr/bin/perl

foreach $i (0 .. $#ARGV) {
    $f = @ARGV[$i];
    if ((stat($f))[0]) {
        # File exists, just update the timestamp
        $atime = $mtime = time;
        utime $atime, $mtime, $f;
    } else {
        open $fh, '>', $f;
        close $fh;
    }
}
