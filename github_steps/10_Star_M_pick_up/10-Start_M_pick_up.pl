#!/usr/bin/perl -w

my $inpitfolder='/home/user_name/getOR/9_OR_7TM_S_E/OR_7TM_check';
my $outputfolder='OR_M_picked';

system ("mkdir -p $outputfolder");

opendir(FOLDER,"$inpitfolder") or die print "can not find the file";
my @array = grep(/_7TM_Cool_checked_5_lim.fas$/,readdir(FOLDER));
close FOLDER;

#Cebus_albifrons_V1R_nu_extend_300_AA.fas_7TM_Cool_checked_5_lim.fas

foreach my $filename ( @array )
{

my $input=$filename;
my $output=$input;
   $output=~s/_7TM_Cool_checked_5_lim.fas$/_M_picked.fas/;

open (FILE,"$inpitfolder/$input");

open (OUT, ">$outputfolder/$output");

my @array; 

     my $species;
     my %sequences;
	
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
	
	
	
################################################################################
my @TM_region=(29,52,60,82,104,123,143,161,199,222,240,263,276,295);

my @bond;

	my $length1=length($sequences{'Human_OR2J3'});
	my $caculator;
	for my $i (0..($length1-1)){
	my $a=substr($sequences{'Human_OR2J3'}, $i, 1);
	if ($a ne '-') {
	$caculator++; # print $caculator;
	foreach my $j(@TM_region){
	 if ($caculator == $j) {push (@bond, $i+1); last;}
	  }
	 }
	}
	
	
my $S_1=$bond[0]; my $E_1=$bond[1];


my $first_tm=$S_1;

################################################################################

	
	
	
	
	foreach my $name( @array)
	{ 
	    my $lengthall=length($sequences{$name});
         
		my $part2=substr($sequences{$name}, ($first_tm-1), ($lengthall-$first_tm+1));
           $part2=~s/-//g;		
	
	    my $Nsite=substr($sequences{$name}, 0, ($first_tm-1)); #N端长度 第一个跨膜区之前的位置
		$Nsite=~s/-//g;
		$Nsite=~s/\n//g;
		
		if ($Nsite){
		
		my $length=length($Nsite);
		my @array35; my @array2034; my @array21;
		my $loc=0;
				
		for (my $i=($length-1); $i>=0; $i--){
		$loc++;
		my $aa=substr($Nsite, $i, 1); # print OUT $aa,"\n"; aa是从最后一个氨基酸开始赋值
		if ($aa=~/M/){
		if (($loc>20) and ($loc<35)) {push (@array2034,$loc)}
		if ($loc>=35) {push (@array35, $loc)}
		if ($loc<=20) {push (@array21, $loc)}
		            }	#给每个M设置了位置信息
        					
		}
		
		my $best_start;#最佳的M
		
		#print OUT @array2034,"\n";
		#print OUT @array35,"\n";
		#print OUT @array21,"\n";
		print OUT ">$name\n";		
		#print OUT $Nsite,"------------------\n";
		#print OUT $part2,"\n";
				
		if (@array2034)  {
		$best_start=min(@array2034);
		my $Nsequence=substr($Nsite, ($length-$best_start), $best_start);
		print OUT $Nsequence, "\n";
		print OUT $part2,"\n\n";
		#print OUT $best_start, "===============================================\n\n\n";
		next;}
		
		elsif (@array35)  {
		$best_start=min(@array35);
		my $Nsequence=substr($Nsite, ($length-$best_start), $best_start);
		print OUT $Nsequence, "\n";
		print OUT $part2,"\n\n";
		#print OUT $best_start, "===============================================\n\n\n"; 
		next;}
		
		elsif (@array21)  {
		$best_start=max(@array21);
		my $Nsequence=substr($Nsite, ($length-$best_start), $best_start);
		print OUT $Nsequence, "\n";
		print OUT $part2,"\n\n";
		#print OUT $best_start, "===============================================\n\n\n"; 
		next;}
		
	 }
        
	}
}

#2034优先35优先21
	
	
	
		  #自己写的max和min子程序
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
