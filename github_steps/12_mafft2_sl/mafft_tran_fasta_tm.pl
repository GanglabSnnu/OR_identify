#!/usr/bin/perl
use strict;
use warnings;

open (OUT, ">Human_OR.fas");

my @array; 

     my $species;
     my %sequences;

open (FILE,"Hum_genome_OR_aligned2_sl.fas");
	 
        while( <FILE> )	{
		    my $line=$_;  chomp $line;
                if( $line =~ /^TITLE\s+(\w.+)/ ){
                        $species = $1;
                        $sequences{$species} = '';  push(@array, $species) ;
                }
				elsif($line =~ /^LOCUS|^DEFINITION|^ORIGIN|\/\//){next;}
                else{
                            $sequences{$species} .= $line;                      
                   }

	 }
		close FILE;


	for my $name (@array){
	($sequences{$name})=~s/-|\d|\s//g;
	  print OUT ">$name\n$sequences{$name}\n"
	  }
	 close OUT; 