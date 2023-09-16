
#!/usr/bin/perl

use strict;
use warnings;

my $cleanfolder='/home/user_name/getOR/4_cleaned_seg/cleaned_seg';

my $ext=300; 

my $outputfolder='OR_get_genome_seq';

system ("mkdir -p $outputfolder");


opendir(FOLDER,"$cleanfolder") or die print "can not find the file";
my @array = grep(/cleaned.txt/,readdir(FOLDER));
close FOLDER;

foreach my $sumname (@array)
{

my $input=$sumname; #All_query_blast_Ajin.genome.f_1e-10_cleaned.txt

my $chromosomefolder=$input;
   $chromosomefolder=~s/query_blast_//;
   $chromosomefolder=~s/\.fa_1e-10_cleaned.txt//;
   
my $species=$chromosomefolder;  # Hoolock_hoolock_chr   
   
   $chromosomefolder.='_config';

my $output="$species\_OR_extend_$ext.fas";  


open(FILE,"$cleanfolder/$input") or die print 'can not open file1';
open (OUT, ">$outputfolder/$output");

my $count;
  
while (my $line= <FILE>)

  {   
     $line=~s/\s//g;
	    my @array_2=split(/\//,$line);
          if ($array_2[10]=~/\d+/){

# BotaORs4786.1_CladeA;/309/ctg32/257/1e-30/319/32.6848249027237/84/2/235/5464344/5465108/0/-1

             
            my $query_len=$array_2[1];  my $chr=$array_2[2]; my $hit_length=$array_2[3]; my $start=$array_2[10];  my $end=$array_2[11]; my  $string=$array_2[13];  
            my $query_start= $array_2[8];   my $query_end= $array_2[9];
          
              if ($query_len == $hit_length)   {
                           if ($string eq 1)   { $end=$end+3} 
                           if ($string ne 1)   { $start=$start-3}

                            }

             else {
                    if ($string eq 1){ 
                     if ($query_end ne $query_len) { $end=$end+($query_len-$query_end)*3+3 }
                     if ($query_start ne 1)  { $start=$start-($query_start-1)*3 ; $end=$end+3 }
                     }
                 if ($string ne 1){ 
                     if ($query_start ne 1) { $end=$end+($query_start-1)*3; $start=$start-3 }
                     if ($query_end ne $query_len)  { $start=$start-($query_len-$query_end)*3-3;  }
                     }

                  }  
              
              my $filename="/home/user_name/getOR/5_separate_genome/$chromosomefolder/$chr".'.fas';
              my $seq=findesequence($chr,$start,$end,$string,$filename);
              my $seqlength=$end-$start;
            
             print OUT ">$species\_$chr\_$start\_$end\_$string\n";  
	     print OUT "$seq\n\n";

          }
      $count++;  print "$count----seq-----done\n";

}


close FILE;

close OUT;

# exit;

}

# close ALL;


sub findesequence
{

                 my $chromsome=shift; my $begin=shift; my $end=shift; my $direction=shift; 
                 my $filename=shift;    my $lind_length=100; 
                    $begin=$begin-$ext;   $end=$end+$ext;
                 open (SFILE, "$filename") or die print "can not open the file2";
                  
                   #   if ($begin%$lind_length==0) {$begin--;}
                   #   if ($end%$lind_length==0)   {$end++;}                     

                        my $begin1=int($begin/$lind_length);   my $end1=int($end/$lind_length); 
                        my $sequence;
                        my $i;
                        my $begin_Modulus=$begin%$lind_length;   my $end_Modulus=$end%$lind_length;
                         
                          
                      while (my $line =<SFILE>)
                          {   
                               chomp $line;
                               if( $line =~ />(.+)/ )
                                    {   next; }
                                else
                                    {     
                                         if ($line)
                                             {    $i++;
                                                  if (($i==$begin1) and ($begin_Modulus==0) ) {  $sequence.=substr($line, ($lind_length-1), 1); }

                                                  elsif ($i==($begin1+1)){ 
                                                          
                                                             if ($begin_Modulus > 0) {my $j=$begin_Modulus;  $sequence.=substr($line, ($j-1), ($lind_length-$j+1));} 
                                                             if ($begin_Modulus == 0) { $sequence.=$line}
                                                                          }

                                                  elsif (($i>$begin1+1) and ($i<=$end1)) { $sequence.=$line;}

                                                  elsif ($i==($end1+1))  {
                                                               if ($end_Modulus > 0)  { my $k=$end_Modulus;  $sequence.=substr($line, 0, $k);} 
                                                                        }         
                                                 
                                                     elsif ($i>$end1+1) {goto NEXTFILE;}
                                             }
                                         
                                    }
                          }

                        close SFILE;

                        NEXTFILE:
 
                         close SFILE;
                       
                   if ($direction==-1)
                     {
                              $sequence=&revdnacomp($sequence);
                     }
          return $sequence;
}



sub revdnacomp 
{
  # my $dna = @_;  
  # the above means $dna gets the number of 
  # arguments in @_, since it's a scalar context!

  my $dna = shift; # or   my $dna = shift @_;
  # ah, scalar context of scalar gives expected results.
  # my ($dna) = @_; # would work, too

  my $revcomp = reverse($dna);
  $revcomp =~ tr/ACGTacgt/TGCAtgca/;
  return $revcomp;
}

