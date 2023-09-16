#!/usr/bin/perl -w
use strict;
use warnings;

my $fas_foldername='/home/user_name/getOR/2_genome_100_per_line/genome_100_per_line';


opendir(FOLDER,"$fas_foldername") or die print "can not find the file";
my @array = grep(/.fa$/,readdir(FOLDER));
close FOLDER;

foreach my $filename ( @array )
{

   my $foldname=$filename.'_'.'config';
      $foldname=~s/\.fa//;

    my $input=$filename;

open(FILE,"$fas_foldername/$input") or die print 'can not open file1';

system ("mkdir -p $foldname");

my $cont=0;
my $sequence;
while (my $line= <FILE>)
  
{     
      if ($line=~/>(\S+)/)    #ctg1len=68549736.fas
         
        {    my $fasname;  $fasname=$1.'.fas';  $fasname=~s/\n//g; 
             if ($cont==0) 
                {
                $sequence='';
                open (OUT, ">>./$foldname/$fasname");
                print OUT $line;
                $cont++;
                 }
              else
                 {
                 print OUT $sequence;  close OUT;
                 $sequence=''; 
                 open (OUT, ">>./$foldname/$fasname");
                 print OUT $line;
                 $cont++;
                 }
        }
        else 
        {  $sequence.=$line;}
}

print OUT $sequence; close OUT;

print "Number of genescaffold= $cont\n";

     }        
