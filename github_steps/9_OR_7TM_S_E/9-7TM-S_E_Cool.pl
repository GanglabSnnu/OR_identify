#!/usr/bin/perl
use strict;
use warnings;

my $inpitfolder='/home/user_name/getOR/8_Add_human_mafft/OR_mafftalign';
my $outputfolder='OR_7TM_check';

system ("mkdir -p $outputfolder");


opendir(FOLDER,"$inpitfolder") or die print "can not find the file";
my @array = grep(/_add_human_aligned.fas$/,readdir(FOLDER));
close FOLDER;

# Cercopithecus_mona_V1R_nu_extend_300_AA.fas_add_human_aligned1.fas

foreach my $faspath (@array){

my @TM_region=(29,52,60,82,104,123,143,161,199,222,240,263,276,295);

my @bond;


my $limitaion=5;  my $Cool_limitaion=1;
	
my $output=$faspath;
   $output=~s/_add_human_aligned.fas$/_7TM_Cool_checked_$limitaion\_lim\.fas/;


open (OUT, ">$outputfolder/$output");

my @array; 

     my $species;
     my %sequences;

open (FILE,"$inpitfolder/$faspath");
	 
        while( <FILE> )	{
		    my $line=$_;  chomp $line;
                if( $line =~ /^>(.+)/ ){
                        $species = $1;
                        $sequences{$species} = '';  push(@array, $species) ;
                }
                else{
                            $sequences{$species} .= $line;                      
                   }

	 }
	close FILE;

	
	my $length1=length($sequences{'Human_OR2J3'});
	my $caculator;
	for my $i (0..($length1-1)){
	my $a=substr($sequences{'Human_OR2J3'}, $i, 1);#ref_or的每个氨基酸
	if ($a ne '-') {#ne = not equal = ！=
	$caculator++; # print $caculator;
	foreach my $j(@TM_region){
	 if ($caculator == $j) {push (@bond, $i+1); last;}
	  }
	 }
	}
	
	#比对后的文件不对齐，有--，@TM_region里的是比对之前的位置，@bond里的位点是比对之后的跨膜区的位置
	
	
	
	# foreach (@bond)  {print "$_\n"}  
	# exit;


my $S_1=$bond[0]; my $E_1=$bond[1];
my $S_2=$bond[2]; my $E_2=$bond[3];
my $S_3=$bond[4]; my $E_3=$bond[5];
my $S_4=$bond[6]; my $E_4=$bond[7];
my $S_5=$bond[8]; my $E_5=$bond[9];
my $S_6=$bond[10]; my $E_6=$bond[11];
my $S_7=$bond[12]; my $E_7=$bond[13];
# my $C_1=$bond[14]; my $C_2=$bond[15];
	
	
		my $align_gap_1;
		my $align_gap_2;
		my $align_gap_3;
		my $align_gap_4;
		my $align_gap_5;
		my $align_gap_6;
		my $align_gap_7;		
		# my $align_gap_8;		
	
	my $count;
	
	foreach my $name( @array)
	{ 
	    $count++;
		
	    my $lengthall=length($sequences{$name});
         
	    my $Nsite=substr($sequences{$name}, 0, ($S_1-2));
		$Nsite=~s/-//g;
		
		
	    my $Csite=substr($sequences{$name}, $E_7, ($lengthall-$E_7));
		$Csite=~s/-//g;
		
		
		my $TM_1=substr($sequences{$name}, ($S_1-1), ($E_1-$S_1+1));
		my $TM_2=substr($sequences{$name}, ($S_2-1), ($E_2-$S_2+1));
	    my $TM_3=substr($sequences{$name}, ($S_3-1), ($E_3-$S_3+1));	
		my $TM_4=substr($sequences{$name}, ($S_4-1), ($E_4-$S_4+1));
		my $TM_5=substr($sequences{$name}, ($S_5-1), ($E_5-$S_5+1));
	    my $TM_6=substr($sequences{$name}, ($S_6-1), ($E_6-$S_6+1));	
	    my $TM_7=substr($sequences{$name}, ($S_7-1), ($E_7-$S_7+1));	
	    # my $Cool=substr($sequences{$name}, ($C_1-1), ($C_2-$C_1+1));	#$C_1=$bond[14]; my $C_2=$bond[15];
		

		my $gap_1=$TM_1=~s/\-/\-/g;  unless ($gap_1) {$gap_1=0}  #$gap_1=$TM_1=~s/\-/\-/g 连等$gap_1返回的是匹配的个数
		my $gap_2=$TM_2=~s/\-/\-/g;  unless ($gap_2) {$gap_2=0}
		my $gap_3=$TM_3=~s/\-/\-/g;  unless ($gap_3) {$gap_3=0}
		my $gap_4=$TM_4=~s/\-/\-/g;  unless ($gap_4) {$gap_4=0}
		my $gap_5=$TM_5=~s/\-/\-/g;  unless ($gap_5) {$gap_5=0}
		my $gap_6=$TM_6=~s/\-/\-/g;  unless ($gap_6) {$gap_6=0}
		my $gap_7=$TM_7=~s/\-/\-/g;  unless ($gap_7) {$gap_7=0}
		# my $gap_8=$Cool=~s/\-/\-/g;  unless ($gap_8) {$gap_8=0}
		
		
		if ($count==1){		      
		 $align_gap_1=$gap_1;
		 $align_gap_2=$gap_2;
		 $align_gap_3=$gap_3;
		 $align_gap_4=$gap_4;
		 $align_gap_5=$gap_5;
		 $align_gap_6=$gap_6;
		 $align_gap_7=$gap_7;	
		 # $align_gap_8=$gap_8;	
		 }
		
		
		
	
		
		if ($Nsite and $Csite){
		      if (($gap_1 >= ($align_gap_1-$limitaion)) and ($gap_1 <= ($align_gap_1+$limitaion))){
			      if (($gap_2 >= ($align_gap_2-$limitaion)) and ($gap_2 <= ($align_gap_2+$limitaion))){ 
			          if (($gap_3 >= ($align_gap_3-$limitaion)) and ($gap_3 <= ($align_gap_3+$limitaion))){
			               if (($gap_4 >= ($align_gap_4-$limitaion)) and ($gap_4 <= ($align_gap_4+$limitaion))){
			                   if (($gap_5 >= ($align_gap_5-$limitaion)) and ($gap_5 <= ($align_gap_5+$limitaion))){
			                        if (($gap_6 >= ($align_gap_6-$limitaion)) and ($gap_6 <= ($align_gap_6+$limitaion))){
		                                  if (($gap_7 >= ($align_gap_7-$limitaion)) and ($gap_7 <= ($align_gap_7+$limitaion))){
		                                     # if (($gap_8 >= ($align_gap_8-$Cool_limitaion)) and ($gap_8 <= ($align_gap_8+$Cool_limitaion))){
		   		print OUT ">$name\n$sequences{$name}\n";}}}}}}}
				# }
		}
        
	}
	
	# exit;
}	
	

################################################################以下内容没啥用	
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
		


