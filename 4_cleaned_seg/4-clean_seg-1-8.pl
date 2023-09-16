#!/usr/bin/perl

use strict;
use warnings;

my $inpitfolder='/home/user_name/getOR/3_tblastn';
my $outputfolder='cleaned_seg';

system ("mkdir -p $outputfolder");

opendir(FOLDER,"/home/user_name/getOR/3_tblastn") or die print "can not find the file";
my @array = grep(/._1e-10.sum/,readdir(FOLDER));
close FOLDER;

foreach my $filename (@array){

my $input=$filename;
my $output=$filename; $output=~s/_1e-10.sum$/_1e-10_cleaned.txt/;

open(FILE,"$inpitfolder/$input") or die print 'can not open file1';


 my %chr;

while (my $line= <FILE>)

  {   
     $line=~s/ //g;
	 if ($line=~/\S+\/\S+\/(\S+)\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\d+\/\S+\n/)   # Query/Query_length/Hit/Hit_length/E-value/Bit score/Percent_identity/Number_indentity/Query_Start/Query_End/Hit_Start/Hit_END/Query_strand/Hit_strand
                                    
             {    my $chrnumber=$1; 
                 $chr{$chrnumber}.=$line;
             }
 }

   close FILE;    


#open(OUT,">>test.txt") or die print 'can not open file1';
#print OUT "Query\/Query_length\/Hit\/Hit_length\/E-value\/Bit score\/Percent_identity\/Number_indentity\/Query_Start\/Query_End\/Hit_Start\/Hit_END\/Query_strand\/Hit_strand\n";
#   /\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\n/
		  
#foreach my $ss(keys %chr)
#  {  print OUT $chr{$ss},"\n\n";  }
#close OUT;
  

 open(OUT,">$outputfolder/$output") or die print 'can not open file1';

 print OUT "Query\/Query_length\/Hit\/Hit_length\/E-value\/Bit score\/Percent_identity\/Number_indentity\/Query_Start\/Query_End\/Hit_Start\/Hit_END\/Query_strand\/Hit_strand\n";
          #   /\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\n/

  
foreach my $name (keys %chr)
    {
	  my @array=split(/\n/, $chr{$name});
	  my @min_max;  my %block;
      for (my $i=0; $i<@array; $i++)
         {  if  ($array[$i]=~/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/(\d+)\/(\d+)\/\S+\/\S+$/)	  
               {my $hitstart=$1;  my $hitend=$2;   my $length=$hitend-$hitstart;
			      
			    #print OUT $hitstart,"\n";
			    if ($block{$hitstart})
				  { if ($block{$hitstart}=~/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/(\d+)\/(\d+)\/\S+\/\S+/)
				      { my $old_length=$2-$1;
					    if ($old_length < $length) {$block{$hitstart}=$array[$i]."\n";}
				      }
				  }
				  else {$block{$hitstart}=$array[$i]."\n";  push (@min_max, $hitstart)}
			   }
	     }
		 #   foreach  my $key (@min_max)
	     #   { print OUT $block{$key};}
         #  print OUT "\n\n";  	
	  
   
	
       my @out_order=sort {$a <=> $b} @min_max;
	   
	 #  foreach  my $key (@out_order)
	 #    { print OUT $block{$key};}
     #  print OUT "\n\n";  	
	 # exit;
	 
	 my %hit_block;  my $count1;
      
	  my $laststart=-2000;
	   foreach  my $key (@out_order)
	 {
	   my @array2=split(/\n/, $block{$key});
	     for (my $i=0; $i<@array2; $i++)
             {   
               if  ($array2[$i]=~/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/(\d+)\/(\d+)\/\S+\/\S+$/)	 
                 {   my $start=$1;
				     my $def=$start-$laststart;
                     if ($def >=  1000) 
					 {
					  $count1++;
					  $hit_block{$count1}.=$array2[$i]."\n";
					  $laststart=$start;
					 }				 
	                  else {$hit_block{$count1}.=$array2[$i]."\n";
					         $laststart=$start;
						    }
                 }   
            }
	}
	
	
	foreach  my $number (keys %hit_block){
	
	my $max_length=0;  my $longesthit;
	
	my @array3=split(/\n/, $hit_block{$number});
	for (my $i=0; $i<@array3; $i++) {
	                 if  ($array3[$i]=~/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/\S+\/(\d+)\/(\d+)\/\S+\/\S+$/)	 
                 { 
             				 my $length=$2-$1;
				     if ($length > $max_length) {
                                    $longesthit=$array3[$i];   $max_length=$length;
									}
							}
					}
	
	print OUT $longesthit, "\n";
	
	#print OUT "\n\n";
		
	}	
}
  close OUT;
     
      
}	  
	  
	  
	  sub max {
   my($max_so_far) = shift @_;
   foreach (@_){                         
      if($_>$max_so_far){                  
           $max_so_far=$_;
      }
   }
   return $max_so_far;                      
}

   

sub min {
   my($min_so_far) = shift @_;
   foreach (@_){                         
      if($_<$min_so_far){                  
           $min_so_far=$_;
      }
   }
   return $min_so_far;                      
}
