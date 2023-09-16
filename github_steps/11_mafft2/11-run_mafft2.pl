#!/usr/bin/perl -w
use strict;
use warnings;

my $inpitfolder='/home/user_name/getOR/10_Star_M_pick_up/OR_M_picked';
my $outputfolder='OR_mafft_align2';

system ("mkdir -p $outputfolder");

opendir(FOLDER,$inpitfolder) or die print "can not find the file";
my @array = grep(/_M_picked.fas$/,readdir(FOLDER));
close FOLDER;

foreach my $filename ( @array )
{
   my $input=$filename;
   
   my $output=$input;  
   $output=~s/(\S+)_M.+/$1_aligned2\.fas/;
     #system ("mafft --localpair  --thread 16 --inputorder \"$input\" > \"$output\" ");
   
   system ("mafft --globalpair --maxiterate 1000 --thread 32  --inputorder \"$inpitfolder\/$input\" > \"$outputfolder\/$output\" ");

}


 
