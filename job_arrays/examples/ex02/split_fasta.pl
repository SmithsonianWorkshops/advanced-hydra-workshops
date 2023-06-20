#!/usr/bin/env perl

# This script is modified from http://archive.sysbio.harvard.edu/csb/resources/computational/scriptome/UNIX/Tools/Change.html#split_big_fasta_file_into_smaller_files__change_split_fasta_

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

my $inputfile;
my $split_seqs=10;
my $help = 0;

GetOptions ("length=i" => \$split_seqs,
            "help|?" => \$help)
    or pod2usage(2);

pod2usage({-exitval => 0}) if $help;
pod2usage({-exitval => 1}) unless (scalar @ARGV);

open INPUT, $ARGV[0] or die "File cannot be opened: $ARGV[0]";

warn "\nSplitting $ARGV[0] into files with $split_seqs sequences per file\n\n";


my $out_template="NUMBER.fasta";
my $count=0;
my $filenum=0;
my $len=0;
while (<INPUT>) {
    s/\r?\n//;
    if (/^>/) {
	if ($count % $split_seqs == 0) {
	    $filenum++;
	    if ($filenum > 1) {
    		close SHORT
	    }
	    open (SHORT, ">$filenum.fasta") or die $!;
	    
	}
	$count++;
	
    }
    else {
	$len += length($_)
    }
    print SHORT "$_\n";
}
close(SHORT);
warn "\nSplit $count FASTA records in $. lines, with total sequence length $len\nCreated $filenum files\n\n";


__END__
=head1 NAME

Splits a fasta file into smaller sequentially numbered fasta files

=head1 SYNOPSIS

split_fasta.pl [options] [FILE]

 Options:
   --length          Number of sequences per file (default 10)
   --help            brief help message
   FILE              input fasta file
   
=cut
