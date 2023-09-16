#!/usr/bin/perl -w
use strict;
use warnings;    

my $foldername="/home/user_name/getOR/2_genome_100_per_line";

opendir(FOLDER,"$foldername") or die print "can not find the file";
my @array = grep(/.fa$/,readdir(FOLDER));
close FOLDER;

my $outfolder='genome_100_per_line';

system ("mkdir -p $outfolder");

foreach my $filename ( @array )
{


open (FILE,"$foldername/$filename");

       my $species;
       my %sequences;
	 my $cont=0;
        while( <FILE> )
	{          
		    my $line=$_;  chomp $line;     
                if( $line =~ /^>(\S+)/ )
                {
                        $species = $1;
                        $sequences{$species} = '';
                        $cont++;
                }
                else
                   {
                            $sequences{$species} .= $line;                      
                   }

	 }
	close FILE;
	

      open (OUT, ">>$outfolder/$filename");


      foreach my $name (keys %sequences){
	  
	              $sequences{$name}=~s/(\w{100})/$1\n/ig;		

                  print OUT ">$name\n";
                  print OUT "$sequences{$name}\n";
                    
        }



   print "$filename---------done\n";
   
   close OUT;
  

 
 }
  
