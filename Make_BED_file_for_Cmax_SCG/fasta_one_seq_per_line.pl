#!/usr/bin/perl

#removes line breaks in fasta files so that the header and sequence are on a single line

@FILES=<*fa>;
$count=0;
foreach $f (@FILES)
{
open FH, "<$f" or die $!;
open OUT, ">test$count.fasta";


	while (<FH>)
	{
                $count++;
		if (/^(\>\S+)/)
		{
			print OUT "\n$1\t";
		}
		elsif (/^(\w+)\n/)
		{
			print OUT "$1";
		}
		 
	}
	

close FH;
}
