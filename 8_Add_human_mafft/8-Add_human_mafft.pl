#!/usr/bin/perl -w
use strict;
use warnings;


my $inpitfolder='/home/user_name/getOR/7_find_ORF/OR_ORF_find';
my $outputfolder='OR_mafftalign';

system ("mkdir -p $outputfolder");


opendir(FOLDER,$inpitfolder) or die print "can not find the file";
my @array = grep(/_AA.fas$/,readdir(FOLDER));
close FOLDER;

foreach my $input (@array)
{

#V1R_longThan_700_bp_Rhinopithecus_strykeri_V1R_nu_extend_300_AA.fas

my $spe_name=$input;      $spe_name=~s/.+_longThan_700_bp_//;  $spe_name=~s/_extend_300_AA.fas//;

my $add_7TM=$spe_name.'_add_human.fas';

system ("cat Human_OR2J3.fas  $inpitfolder/$input > $add_7TM");


   my $output=$add_7TM;  
   
   $output=~s/_add_human.fas$/_add_human_aligned\.fas/;

     system ("mafft  --globalpair --maxiterate 1000 --thread 64 --inputorder \"$add_7TM\" > \"$outputfolder\/$output\" ");
	 
	 system ("rm $add_7TM");


}
 
