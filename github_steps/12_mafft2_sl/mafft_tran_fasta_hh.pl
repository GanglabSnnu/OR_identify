#!/usr/bin/perl -w
use strict;
use warnings;


my $foldername='/home/user_name/getOR/12_mafft2_sl/select';
opendir(FOLDER,"$foldername");
my @allspe = grep(/.fas$/,readdir(FOLDER)); 
close FOLDER;


foreach my $seq (@allspe){
	my @array = (); 
	my $species = '';
	my %sequences = ();
	open (FILE,"$foldername/$seq");
	 
    while( <FILE> )	{
		my $line=$_;
		chomp $line;
        if( $line =~ /^TITLE\s+(\w.+)/ ){
                $species = $1;
                $sequences{$species} = '';
				push(@array, $species) ;
            }
		elsif($line =~ /^LOCUS|^DEFINITION|^ORIGIN|\/\//){next;}
        else{$sequences{$species} .= $line;}
		}
	close FILE;
	
	my $out=substr($seq, 0, 7) . ".fas";
	
	open (OUT, ">$out");
	for my $name (@array){
		($sequences{$name})=~s/-|\d|\s//g;
		print OUT ">$name\n$sequences{$name}\n"
	}
	close OUT; 
}
