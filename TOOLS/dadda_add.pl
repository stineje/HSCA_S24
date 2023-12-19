eval 'exec /usr/bin/perl $0 ${1+"${@}"}'
    if 0;

use Getopt::Std;

getopts('x:h:');

$XBITS=$opt_x;
$YBITS=$XBITS;
$ZBITS=$XBITS;
$height = $opt_h;
$extra_bits = ceiling(log($height)/log(2.0));

$K=$opt_k;
$instcnt=1;
$pp_label=1;
$ha_label=1;
$fa_label=1;
$cpa_label=1;

printf("module dadda_add%s_%s (", $XBITS, $height);
for ($x=0; $x < $height; $x++) {
    printf("In%s, ", $x);
}
printf("S, C);\n\n");
for ($x=0; $x < $height; $x++) {
    printf("\tinput logic [%s:0] In%s;\n", $XBITS-1, $x);
}
printf("\toutput logic[%s:0] S;\n", $XBITS+$extra_bits-2);
printf("\toutput logic[%s:0] C;\n", $XBITS+$extra_bits-2);
printf "\n";

# Maximum height = floor(tallest column 1.5x)
# Define the height of the matrix => size of mutliplier
$h_of_matrix=$height;

# define an array to hold matrix heights and seed the value of the matrix 0
@marray;
@marray[0]=$XBITS;
$totalmatrixcnt=1;

# Compute the subsequent matrix heights until just two are left
while( $h_of_matrix > 2){
    
    # next, loop from 0 to $h_of_matrix -1	
    $x=2;
    $grow_h=1;
    while($grow_h){
	if( int($x * 1.5) >= $h_of_matrix){
	    $grow_h=0;
	    @marray[$totalmatrixcnt]=$x;
	    $h_of_matrix=$x;
	    $totalmatrixcnt++;
	}
	$x++;
    }	
}
$finalmatrixcnt=$totalmatrixcnt-1;

for($z=0;$z<$height;$z++){
    for($y=0;$y<$YBITS;$y++){
	
	$signalarray[0][$z][$y]=1;
	$signalcolumn[$y]++;
	printf("\tlogic N0_%s_%s;\n",$z,$y);
    }

}
print "\n";

for($z=0;$z<$height;$z++){
    for($y=0;$y<$YBITS;$y++){
	printf("\tassign N0_%s_%s = In%s[%s];\n",$z,$y,$z,$y);
    }

}

print "\n";
print "\t// Reduction\n";
$matrixcnt=0;
foreach $matrix (@marray){
    
    printf("\t// Elements from matrix %s \n",$matrixcnt);
    for($x=0;$x<($XBITS+$extra_bits);$x++){
	
	# maintain count of new signals for next matrix
	$newsignalcnt=0;
	
	# loop while thge number of signals is greater than allowed for matrix
	while($signalcolumn[$x] > @marray[$matrixcnt]){
	    
	    # if signal column is only greater than 1, use (2,2) counter (Half Adder)
	    if( $signalcolumn[$x] == @marray[$matrixcnt] +1  ){
		print "\t// In matrix $matrixcnt adding HA to column $x \n";
		$signalcolumn[$x] = $signalcolumn[$x] -1;
		$signalcolumn[$x+1] = $signalcolumn[$x+1] +1;
		$signalarray[$matrixcnt+1][$newsignalcnt][$x]=1;
		$signalarray[$matrixcnt+1][$newsignalcnt+1][$x+1]=1;
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt,$x,2,*signalarray);

		printf("\tlogic N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt,$x);
		printf("\tlogic N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1);
		printf("\thalf_adder HA$ha_label (N%s_%s_%s, N%s_%s_%s, %s, %s);\n",$matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[1]);
		$ha_label++;
		$instcnt++;
		$newsignalcnt++;
		$newsignalcnt++;
	    }
	    
	    #if signal column is greater than 1, use (3,2) counter 
	    elsif( $signalcolumn[$x] > @marray[$matrixcnt] +1  ){
		print "\t// In matrix $matrixcnt adding FA to column $x \n";
		$signalcolumn[$x] = $signalcolumn[$x] -2;
		$signalcolumn[$x+1] = $signalcolumn[$x+1] +1;
		$signalarray[$matrixcnt+1][$newsignalcnt][$x]=1;
		$signalarray[$matrixcnt+1][$newsignalcnt+1][$x+1]=1;		
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt,$x,3,*signalarray);

		printf("\tlogic N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt,$x);
		printf("\tlogic N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1);
		printf("\tfull_adder FA$fa_label (N%s_%s_%s, N%s_%s_%s, %s, %s, %s);\n",$matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[1],@signals[2]);
		$fa_label++;
		$instcnt++;
		$newsignalcnt++;
		$newsignalcnt++;
	    }
	    
	}
    }
    $matrixcnt++;
}


$matrixcnt=0;
foreach $matrix (@marray){
    
    for($x=0;$x< $XBITS+$extra_bits;$x++){
	
	# maintain count of new signals for next matrix
	$newsignalcnt=0;
	
	# loop while the number of signals is greater than allowed for matrix
	while($signalcolumn[$x] > 0){
	    if($signalcolumn[$x] == 1){
		push @PP0, "1'b0";
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt+1,$x,1,*signalarray);
		@PP1[$x]=@signals[0];
		$signalcolumn[$x] = $signalcolumn[$x] -1;
	    }
	    elsif($signalcolumn[$x] == 2){		
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt+1,$x,2,*signalarray);
		push @PP0, @signals[0];
		push @PP1, @signals[1];
		$signalcolumn[$x] = $signalcolumn[$x] -2;
	    }
	    else{
		print STDERR "Error: too many signals in column $x\n";
	    }
	}
    }
    
}

print "\n";
print "\t// generate the Carry-Save Vectors\n";

$p0=");";
$pp0cnt=0;
foreach $pp0 (@PP0){
    $p0= "," . $pp0 . $p0;
    print "\tassign S[$pp0cnt] = $pp0;\n";
    $pp0cnt++;
}
$p0 =~ s/^,//g;

$p1=");";
$pp1cnt=0;
foreach $pp1 (@PP1){
    $p1= "," . $pp1 . $p1;
    print "\tassign C[$pp1cnt] = $pp1;\n";
    $pp1cnt++;
}
$p1 =~ s/^,//g;
$p1 = "PP1=cat(" . $p1;
print "\n";
    
print "endmodule\n";

sub GetSignal {
    
    local($mtrxnum,$xbits,$ybits,$nummatrix,$columnnum,$numsignals,*signalarray)=@_;
    
    my @returnarray;
    my $signalcnt;
    my $matrixnum;
    $signalcnt=0;
    
    for($matrixnum=0;$matrixnum<=$nummatrix;$matrixnum++){
	for($y=0;$y<$ybits*2;$y++){
	    
	    #if we are in the correct column, and still need signals
	    if($signalcnt < $numsignals){		
		if($signalarray[$matrixnum][$y][$columnnum] ==1){
		    $signname = "N" . $matrixnum . "_" . $y . "_" . $columnnum;
		    $signalarray[$matrixnum][$y][$columnnum]=-1;
		    push @returnarray, $signname;
		    $signalcnt++;
		}
	    }
	}
    }
    
    return @returnarray;
}


sub string2array {
    
    local($input,*array)=@_;
    
    my @tarray;
    
    while( length($input) > 0){
	
	if($input =~ /.*1$/){
	    push @tarray, "1";
	    chop $input;
	}
	elsif($input =~ /.*0$/){
	    push  @tarray, "0";
	    chop $input;
	}
	else{
	    print STDERR "Invalid input to string2array.\n";
	    return -1;
	}
    }
    while(@tarray){
	$x= pop @tarray;
	push @array, $x;
    }
}

sub ceiling {
    
    local($ceil_operand)=@_;

    my $ceil_output;
    
    if ($ceil_operand > int($ceil_operand)){
	$ceil_output = int($ceil_operand)+1;
    }
    else {
	$ceil_output = int($ceil_operand);
    }

    return $ceil_output;
}
