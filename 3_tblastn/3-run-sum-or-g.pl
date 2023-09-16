#!/usr/bin/perl -w
use strict;
use warnings;    
use Bio::SearchIO;
use Bio::Seq;
use Bio::Tools::Run::StandAloneBlast;


my $foldername='/home/user_name/getOR/2_genome_100_per_line/genome_100_per_line';
   opendir(FOLDER,"$foldername");
    my @allspe = grep(/.fa$/,readdir(FOLDER)); 
close FOLDER;
      

foreach my $data ( @allspe ){

my $query="query.fas";
my $e="1e-10";
my $out=$query;   $out=~s/\.fas/_blast_$data\_$e\.out/g; 
my $pro="tblastn";
my $db = $data;
$data =~ /(.*)\.fa/;
my $db_name = $1;

system ("mkdir -p 'db'");
system ("makeblastdb -in $foldername/$data -dbtype nucl -out db/$db_name/$db_name");

  #  system ("formatdb -i $data -p F");

	my %Finished; my $outfolder='./';    #Mesoplodon_bidens_loc.txt
    opendir(DONE,"$outfolder");
    my @array_d = grep(/\.out$/,readdir(DONE));   #GCA_000331955.2_Oorc_1.1_genomic_RM.fa.nin
    close DONE;
	foreach (@array_d)  {$Finished{$_}++}
	if (defined ($Finished{$out}))    {next;}
#¼ì²âÖØ¸´

#system ("blastall -p $pro -e $e -i $query -d $foldername/$data -o $out -b 200000 -v 200000 ");s
 system ("tblastn -evalue $e -query $query -db db/$db_name/$db_name -out $out -num_alignments 200000 -num_descriptions 200000 -num_threads 32");
 
 # exit;


my $input=$out;
my $output=$input;
   $output=~s/\.out/\.sum/;


  # my $cutoff = '0.001';
  my $file = $input;
  my $in = new Bio::SearchIO(-format =>'blast',
                             -file =>$file);
  my $num = $in->result_count;  


  open (OUT, ">>$output");

  print OUT "Query\/Query_length\/Hit\/Hit_length\/E-value\/Bit score\/Percent_identity\/Number_indentity\/Query_Start\/Query_End\/Hit_Start\/Hit_END\/Query_strand\/Hit_strand\n";

     while( my $r = $in->next_result )
   { 
     
     while( my $h = $r->next_hit ) 
     { 
      # last if $h->significance > $cutoff;
   
         while( my $hsp = $h->next_hsp ) 
                 {
                      my $queryname=$r->query_name;
                       $queryname=~s/\|/\//g;
                       print OUT $queryname,";", " ", $r->query_description,"\/"," ",$r->query_length,"\/";

                       print OUT $h->name, "\/"; 
                       print OUT $hsp->length('total'),"\/", " ",  $hsp->evalue,"\/", $hsp->score, "\/",$hsp->percent_identity ,"\/",$hsp->num_identical,"\/",$hsp->query->start,"\/", " ", $hsp->query->end,"\/"," ", $hsp->hit->start,"\/", " ", $hsp->hit->end,"\/", " ", $hsp->query->strand,"\/", " ",$hsp->hit->strand,"\n";

                 }
                           

      }
    # print OUT "------------------------------------------\n\n";
  }



}


