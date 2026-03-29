#!/usr/bin/perl
use strict;
use warnings;

my @SI_NAMES  = ('kB',  'MB',  'GB',  'TB');
my @SI_MULT   = (1e3,   1e6,   1e9,   1e12);
my @BIN_NAMES = ('KiB', 'MiB', 'GiB', 'TiB');
my @BIN_MULT  = (1024, 1024**2, 1024**3, 1024**4);
my %EXP       = (k => 1, m => 2, g => 3, t => 4);

sub commify {
    my $n = sprintf("%.0f", shift);
    $n =~ s/(\d)(?=(\d{3})+(?!\d))/$1,/g;
    return $n;
}

sub fmt_num {
    my $n = shift;
    return "0" if $n == 0;
    return commify($n) if $n >= 1 && $n == int($n);
    return sprintf("%.8g", $n);
}

# Convert a string with unit (e.g. "10GB", "26GiB", "10gb") to bytes.
#   Uppercase letter  => binary (base-1024)
#   Lowercase letter  => SI    (base-1000)
#   'i'/'I' suffix    => always binary (base-1024)
sub to_bytes {
    my $input = shift;
    $input =~ /^(\d+(?:\.\d+)?)([kmgtKMGT](?:[Ii][Bb]?|[Bb])?)$/
        or die "Cannot parse unit expression: '$input'\n";
    my ($num, $unit_str) = ($1, $2);
    my $letter = substr($unit_str, 0, 1);
    my $binary = ($unit_str =~ /[Ii]/) || ($letter =~ /[A-Z]/);
    my $exp    = $EXP{lc $letter};
    my $bytes  = $num * ($binary ? 1024**$exp : 1000**$exp);
    my $kind   = $binary ? 'binary, base-1024' : 'SI, base-1000';
    my $plain  = sprintf("%.0f", $bytes);

    printf "%s %s = %s bytes  (%s)\n", $num, $unit_str, $plain, $kind;
    printf "%s %s = %s bytes  (%s)\n", $num, $unit_str, commify($bytes), $kind;
}

# Convert a plain number (bytes) to all SI and binary units at once.
sub from_bytes {
    my $num = 0 + shift;

    printf "%s bytes\n", commify($num);

    print "\nSI (base-1000):\n";
    for my $i (0 .. $#SI_NAMES) {
        printf "  %-5s %s\n", "$SI_NAMES[$i]:", fmt_num($num / $SI_MULT[$i]);
    }

    print "\nBinary (base-1024):\n";
    for my $i (0 .. $#BIN_NAMES) {
        printf "  %-5s %s\n", "$BIN_NAMES[$i]:", fmt_num($num / $BIN_MULT[$i]);
    }
}

(my $prog = $0) =~ s{.*/}{};

if (@ARGV && $ARGV[0] =~ /^(-h|--help)$/) {
    print STDERR "Usage: $prog <number>[unit] ...\n";
    print STDERR "  $prog 1000000      show all SI and binary unit conversions\n";
    print STDERR "  $prog 10GB         to bytes  (uppercase letter = binary, base-1024)\n";
    print STDERR "  $prog 10gb         to bytes  (lowercase letter = SI, base-1000)\n";
    print STDERR "  $prog 26GiB        to bytes  (iB/ib suffix = binary, base-1024)\n";
    print STDERR "  echo 1073741824 | $prog\n";
    exit 1;
}

if (!@ARGV && -t STDIN) {
    print STDERR "Usage: $prog <number>[unit] ...\n";
    print STDERR "  $prog 1000000      show all SI and binary unit conversions\n";
    print STDERR "  $prog 10GB         to bytes  (uppercase letter = binary, base-1024)\n";
    print STDERR "  $prog 10gb         to bytes  (lowercase letter = SI, base-1000)\n";
    print STDERR "  $prog 26GiB        to bytes  (iB/ib suffix = binary, base-1024)\n";
    print STDERR "  echo 1073741824 | $prog\n";
    exit 1;
}

my @inputs = @ARGV ? @ARGV : map { chomp; $_ } <STDIN>;

for my $i (0 .. $#inputs) {
    print "\n" . "-" x 40 . "\n" if $i > 0;
    my $arg = $inputs[$i];
    next unless $arg =~ /\S/;
    if ($arg =~ /^\d+(?:\.\d+)?$/) {
        from_bytes($arg);
    } else {
        to_bytes($arg);
    }
}
