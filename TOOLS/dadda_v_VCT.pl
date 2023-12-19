eval 'exec /usr/local/bin/perl $0 ${1+"${@}"}'
    if 0;

# perl script to generate a truncated Dadda tree multiplier (variable correction)
# Last update: 08/23/02

use Getopt::Std;

# options are
#       -x <bits> the number of x bits
#       -y <bits> the number of y bits
#       -z <bits> the number of output bits
#       -k <int> number of columns to keep
#       -m <string> module name

getopts('x:y:z:k:m:');

$XBITS=$opt_x;
$YBITS=$opt_y;
$ZBITS=$opt_z;
$K=$opt_k;
$MODULE=$opt_m;

if($XBITS<=0 || $YBITS<=0 || $ZBITS<=0 || $K<0){
    print("Input parameters:\n");
    print("    -x <bits> the number of x bits\n");
    print("    -y <bits> the number of y bits\n");
    print("    -z <bits> the number of output bits\n");
    print("    -k <int> number of columns to keep\n");
    print("    -m <string> module name (optional)\n");
    exit(1);
}

if($ZBITS+$K>$XBITS+$YBITS) {    
    print("Error: z+k must be smaller than or equal to x+y\n\n");
    exit(1);
}

$instcnt=1;
$pp_label=1;
$ha_label=1;
$fa_label=1;
$cpa_label=1;

if(length($MODULE)==0){
    printf ("module VCTdadda%s_%s_%s_%s (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS, $K);
}
else{
    printf("module $MODULE (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS, $K);
}
printf ("\t\n");
printf ("\tinput [%s:0] Y;\n",$YBITS-1);
printf ("\tinput [%s:0] X;\n",$XBITS-1);
printf ("\toutput [%s:0] Z;\n",$ZBITS-1);
printf ("\t\n");
printf ("\twire [%s:0] S;\n",$ZBITS+$K-1);
printf ("\twire [%s:0] C;\n",$ZBITS+$K-1);
printf ("\twire [%s:0] carry;\n",$ZBITS+$K-2);
printf ("\t\n");

# Calculation of the maximum height
# ---------------------------------
# define an array to hold matrix heights and seed the value of the matrix 0
@marray;
$totalmatrixcnt=1;
# Define the height of the matrix => size of mutliplier
# Number of bits in column $XBITS+$YBITS-$ZBITS-$K + $XBITS+$YBITS-$ZBITS-$K-1
$nbitsvar=0;
$ylast=0;
@harray;
for($y=0;$y<$YBITS;$y++) {
    for($x=0;$x<$XBITS;$x++) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            @harray[$x+$y]=$y if($y>@harray[$x+$y]);
        }
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K){
            $ylast=$y if($y>$ylast);
        }
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K-1){
            $nbitsvar++;
        }
    }
}
for($x=$XBITS+$YBITS-$ZBITS-$K;$x<$XBITS+$YBITS-1;$x++){
    @harray[$x]++;
}

# Rounding correction
for($x=$XBITS+$YBITS-$ZBITS-$K;$x<$XBITS+$YBITS-$ZBITS-1;$x++){
    @harray[$x]++;
}
# Number of bits of the variable correction that will not be added
$bitnum=0;
for($y=0;$y<$YBITS;$y++) {
    for($x=0;$x<$XBITS;$x++) {
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K-1){
            if(($bitnum<2 && $YBITS>=$ZBITS+$K) || ($bitnum<1 && $YBITS<$ZBITS+$K)){
                $bitnum++;
            }
        }
    }
}
@harray[$XBITS+$YBITS-$ZBITS-$K] += $nbitsvar - $bitnum;
# Calculation of the maximum height
for($x=$XBITS+$YBITS-$ZBITS-$K;$x<$XBITS+$YBITS-1;$x++){
    $h_of_matrix = @harray[$x] if($h_of_matrix < @harray[$x]);
}
@marray[0]=$h_of_matrix;

# Compute the subsequent matrix heights until just two are left
# Based on Dadda recursive equation
# -------------------------------------------------------------
while( $h_of_matrix > 2) {
    
    # next, loop from 0 to $h_of_matrix -1	
    $x=2;
    $grow_h=1;
    while($grow_h) {
	if( int($x * 1.5) >= $h_of_matrix) {
	    $grow_h=0;
	    @marray[$totalmatrixcnt]=$x;
	    $h_of_matrix=$x;
	    $totalmatrixcnt++;
	}
	$x++;
    }	
}
$finalmatrixcnt=$totalmatrixcnt-1;

# Generate the partial products
# -----------------------------
if($YBITS<$ZBITS+$K){
    $y_pp_size=$YBITS;
}
else{
    $y_pp_size=$ZBITS+$K-1;
}
print "\t// generate the partial products.\n";
for($y=0;$y<$YBITS;$y++) {
    for($x=0;$x<$XBITS;$x++) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            $signalarray[0][$y][$x+$y]=1;
	    $signalcolumn[$x+$y]++;
	    printf("\twire N0_%s_%s;\n",$y,$x+$y);
	    printf("\tand pp$pp_label(N0_%s_%s, X[%s], Y[%s]);\n",$y, $x+$y, $x, $y);
	    $pp_label++;		
	    $instcnt++;
	}
    }
}
# Add the bits of the variable constant
$bitnum=0;
$nvar=0;
for($y=0;$y<$YBITS;$y++) {
    for($x=0;$x<$XBITS;$x++) {
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K-1){
            if(($bitnum<2 && $YBITS>=$ZBITS+$K) || ($bitnum<1 && $YBITS<$ZBITS+$K)){
                $bitnum++;
            }
            else{
                $nvar++;
                $signalarray[0][$nvar+$ylast][$x+$y+1]=1;
	        $signalcolumn[$x+$y+1]++;
	        printf("\twire N0_%s_%s;\n",$nvar+$ylast,$x+$y+1);
	        printf("\tand pp$pp_label(N0_%s_%s, X[%s], Y[%s]);\n",$nvar+$ylast, $x+$y+1, $x, $y);
	        $pp_label++;		
	        $instcnt++;
	    }
        }
    }
}
# Add the bits for the rounding correction
for($x=$XBITS+$YBITS-$ZBITS-$K;$x<$XBITS+$YBITS-$ZBITS-1;$x++){
    $signalarray[0][@harray[$x]-1][$x]=2;
    $signalcolumn[$x]++;	
}

#for($y=0;$y<3*$YBITS;$y++) {
#    for($x=$XBITS+$YBITS-1;$x>=0;$x--) {
#        if($signalarray[0][$y][$x]==1){
#            print "1";
#        }
#        elsif($signalarray[0][$y][$x]==2){
#            print "2";
#        }
#        else{
#            print "0";
#        }
#    }
#    print "\n";
#}
#printf("height: %s\n",@marray[0]);        

# PP reduction
# ------------
print "\n";
print "\t// PP Reduction\n";
$matrixcnt=0;
foreach $matrix (@marray) {
    
    printf("\t// Elements from matrix %s \n",$matrixcnt);
    for($x=$XBITS+$YBITS-$ZBITS-$K;$x<($XBITS+$YBITS)-1;$x++) {
	
	# maintain count of new signals for next matrix
	$newsignalcnt=0;
	
	# loop while thge number of signals is greater than allowed for matrix
	while($signalcolumn[$x] > @marray[$matrixcnt]) {
	    
	    # if signal column is only greater than 1, 
	    #   use (2,2) counter (Half Adder or Specialized Half Adder)
	    if( $signalcolumn[$x] == @marray[$matrixcnt] +1  ) {
		$signalcolumn[$x] = $signalcolumn[$x] -1;
		$signalcolumn[$x+1] = $signalcolumn[$x+1] +1;
		$signalarray[$matrixcnt+1][$newsignalcnt][$x]=1;
		$signalarray[$matrixcnt+1][$newsignalcnt+1][$x+1]=1;
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt,$x,2,*signalarray);
		# Carry, Sum in terms of order
                print "\t// In matrix $matrixcnt adding HA to column $x \n";
		printf("\twire N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt,$x);
		printf("\twire N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1);
                if(@signals[0]=="1"){
                    printf("\tassign N%s_%s_%s = %s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1,@signals[1]);
                    printf("\tassign N%s_%s_%s = !%s;\n",$matrixcnt+1,$newsignalcnt,$x,@signals[1]);
                }
                elsif(@signals[1]=="1"){
                    printf("\tassign N%s_%s_%s = %s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1,@signals[0]);
                    printf("\tassign N%s_%s_%s = !%s;\n",$matrixcnt+1,$newsignalcnt,$x,@signals[0]);
                }
                else{
		    printf("\thalf_adder HA$ha_label(N%s_%s_%s, N%s_%s_%s, %s, %s);\n",$matrixcnt+1,$newsignalcnt+1
                        ,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[1],);
	            $ha_label++;
	        }
		$instcnt++;
		$newsignalcnt++;
		$newsignalcnt++;
	    }
	    
	    #if signal column is greater than 1, use (3,2) counter
	    elsif( $signalcolumn[$x] > @marray[$matrixcnt] +1  ) {
		print "\t// In matrix $matrixcnt adding FA to column $x \n";
		$signalcolumn[$x] = $signalcolumn[$x] -2;
		$signalcolumn[$x+1] = $signalcolumn[$x+1] +1;
		$signalarray[$matrixcnt+1][$newsignalcnt][$x]=1;
		$signalarray[$matrixcnt+1][$newsignalcnt+1][$x+1]=1;	
		@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt,$x,3,*signalarray);
		printf("\twire N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt,$x);
		printf("\twire N%s_%s_%s;\n",$matrixcnt+1,$newsignalcnt+1,$x+1);
		# Carry, Sum in terms of order
		if(@signals[0]=="1"){
		    printf("\tspecialized_half_adder SHA$sha_label(N%s_%s_%s, N%s_%s_%s, %s, %s);\n",
		       $matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[1],@signals[2]);
		    $sha_label++;		
		}
		elsif(@signals[1]=="1"){
		    printf("\tspecialized_half_adder SHA$sha_label(N%s_%s_%s, N%s_%s_%s, %s, %s);\n",
		       $matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[2]);
		    $sha_label++;		
		}
		elsif(@signals[2]=="1"){
		    printf("\tspecialized_half_adder SHA$sha_label(N%s_%s_%s, N%s_%s_%s, %s, %s);\n",
		       $matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[1]);
		    $sha_label++;		
		}
		else{
		    printf("\tfull_adder FA$fa_label(N%s_%s_%s, N%s_%s_%s, %s, %s, %s);\n",
		       $matrixcnt+1,$newsignalcnt+1,$x+1,$matrixcnt+1,$newsignalcnt,$x,@signals[0],@signals[1],@signals[2]);
		    $fa_label++;
		}
		$instcnt++;
		$newsignalcnt++;
		$newsignalcnt++;
	    }
	}
    }
    $matrixcnt++;
}

for($x=$XBITS+$YBITS-$ZBITS-$K;$x<$XBITS+$YBITS;$x++) {
    if($signalcolumn[$x] != 0){
        $adlimit=$x;
    }
}

# Define the wires of the two remaining rows
# ------------------------------------------
for($x=$XBITS+$YBITS-$ZBITS-$K;$x<=$adlimit;$x++) {
    if($signalcolumn[$x] == 1) {
        push @PP0, "1'b0";
	@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt+1,$x,1,*signalarray);
	push @PP1, @signals[0];
	$signalcolumn[$x] = $signalcolumn[$x] -1;
    }
    elsif($signalcolumn[$x] == 2) {		
	@signals=GetSignal($matrixcnt,$XBITS,$YBITS,$finalmatrixcnt+1,$x,2,*signalarray);
	push @PP0, @signals[0];
	push @PP1, @signals[1];
	$signalcolumn[$x] = $signalcolumn[$x] -2;
    }
    else {
	print STDERR "Error: too many signals in column $x\n";
    }
}
print "\n";

$p0=");";
$pp0cnt=0;
foreach $pp0 (@PP0) {
    $p0= "," . $pp0 . $p0;
    print "\tbuf bufC$pp0cnt(C[$pp0cnt], $pp0);\n";
    $pp0cnt++;
}
$p0 =~ s/^,//g;

$p1=");";
$pp1cnt=0;
foreach $pp1 (@PP1) {
    $p1= "," . $pp1 . $p1;
    print "\tbuf bufS$pp1cnt(S[$pp1cnt], $pp1);\n";
    $pp1cnt++;
}
$p1 =~ s/^,//g;
$p1 = "PP1=cat(" . $p1;
print "\n";
    
# Addition of the two last rows
# -----------------------------
for($x=0; $x <= $adlimit-($XBITS+$YBITS-$ZBITS-$K) ; $x++) {
    if($x==$0) {
        if($K!=0) {
	    printf("\tand CPA%s(carry[%s],C[%s],S[%s]);\n",$cpa_label,$x,$x,$x);
        }
        else{
	    printf("\thalf_adder CPA%s(carry[%s],Z[%s],C[%s],S[%s]);\n",$cpa_label,$x,$x,$x,$x);
        }
        $cpa_label++;
    }
    if($x>0 && $x<$adlimit-($XBITS+$YBITS-$ZBITS-$K)) {
        if($x>=$K) {
	    printf("\tfull_adder CPA%s(carry[%s],Z[%s],carry[%s],C[%s],S[%s]);\n",$cpa_label,$x,$x-$K,$x-1,$x,$x);
	}
        else{
	    printf("\treduced_full_adder CPA%s(carry[%s],carry[%s],C[%s],S[%s]);\n",$cpa_label,$x,$x-1,$x,$x);
        }
        $cpa_label++;
    }
    if($x==$adlimit-($XBITS+$YBITS-$ZBITS-$K)) {
        if($x==$ZBITS+$K-1){
	    printf("\tassign Z[%s] = carry[%s] ^ C[%s] ^ S[%s];\n",$x-$K,$x-1,$x,$x);        
        }
        else{
	    printf("\tfull_adder CPA%s(Z[%s],Z[%s],carry[%s],C[%s],S[%s]);\n",$cpa_label,$x-$K+1,$x-$K,$x-1,$x,$x);
	}
	$cpa_label++;
    }			
}
    
print "endmodule\n";

sub GetSignal {    

    # xbits and ybits are self explanatory
    # nummatrix indicates the number of possible matrixes to search for signals
    # columnnum is the number of the column which contains the signal
    # numsignals number of needed signals
    # signalarray is the array containing the signals
    
    local($mtrxnum,$xbits,$ybits,$nummatrix,$columnnum,$numsignals,*signalarray)=@_;
    my @returnarray;
    my $signalcnt;
    my $matrixnum;
    $signalcnt=0;
    
    for($matrixnum=0;$matrixnum<=$nummatrix;$matrixnum++) {
	for($y=0;$y<=@marray[0];$y++) {
	    #if we are in the correct column, and still need signals
	    if($signalcnt < $numsignals){		
		if($signalarray[$matrixnum][$y][$columnnum] ==1) {
		    $signname = "N" . $matrixnum . "_" . $y . "_" . $columnnum;
		    $signalarray[$matrixnum][$y][$columnnum]=-1;
		    push @returnarray, $signname;
		    $signalcnt++;
		}
		if($signalarray[$matrixnum][$y][$columnnum] ==2) {
		    $signname = "1";
		    $signalarray[$matrixnum][$y][$columnnum]=-1;
		    push @returnarray, $signname;
		    $signalcnt++;
		}
	    }
	}
    }
    return @returnarray;
}


