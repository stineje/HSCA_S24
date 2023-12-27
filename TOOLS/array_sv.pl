eval 'exec /usr/bin/perl $0 ${1+"${@}"}'
    if 0;

# Perl script to generate truncated array multiplier (CSAM)
# Last update: 08/23/02

use Getopt::Std;

# options are
#       -x <bits> the number of x bits
#       -y <bits> the number of y bits
#       -m <string> module name

getopts('x:y:m:');

$XBITS=$opt_x;
$YBITS=$opt_y;
$MODULE=$opt_m;

if($XBITS<=0 || $YBITS<=0){
    print("Input parameters:\n");
    print("    -x <bits> the number of x bits\n");
    print("    -y <bits> the number of y bits\n");
    print("    -m <string> module name (optional)\n");
    exit(1);
}

$ZBITS=($XBITS+$YBITS);

$pp_label=1;
$ha_label=1;
$fa_label=1;
$cpa_label=1;

$instcnt=1;

# Conversion into binary format
@carray;
$rem = $err_tot_rnd;
for($j=1;$j<=$ZBITS+$K;$j++){
    $mod = $rem *  &pow2($j);
    if($mod>=1){
        $rem = $rem - 1/&pow2($j);
        @carray[$XBITS+$YBITS-$j] = 1;
    }
    else{
        @carray[$XBITS+$YBITS-$j] = 0;
    }
}

# Calculation of the number of bits required for the constant correction
# ----------------------------------------------------------------------
$nbitscon=0;
for($j=$XBITS+$YBITS-$ZBITS;$j<$XBITS+$YBITS;$j++){
    $nbitscon += @carray[$j]*&pow2($j-($XBITS+$YBITS-$ZBITS));
}

# calculation of which partial products have to be generated
# ----------------------------------------------------------
if($XBITS<$ZBITS){
    $x_pp_size=$XBITS;
    $h_pp_size=$ZBITS-$XBITS;
}
else{
    $x_pp_size=$ZBITS;
    $h_pp_size=0;
}
if($YBITS<=$ZBITS){
    $y_pp_size=$YBITS;
}
else{
    $y_pp_size=$ZBITS-1;
}

# Calculation of the number of bits available for correction
# (number of HA located on the diagonal and on the second line)
# -------------------------------------------------------------
$nha=0;
$nhadiag=0;
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS){
            if($y==$YBITS-$y_pp_size+1){
                $nha++;
            }
        }
        if($x+$y==$XBITS+$YBITS-$ZBITS && $y>$YBITS-$y_pp_size+1){
            $nhadiag++;
        }
    }
}

# Write the header of the verilog file (variables definition)
# -----------------------------------------------------------
if(length($MODULE)==0){
    printf("module CSAM_%s_%s_%s (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS);
}
else{
    printf("module $MODULE (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS);
}
printf("\t\n");
printf("\tinput logic [%s:0] Y;\n",$YBITS-1);
printf("\tinput logic [%s:0] X;\n",$XBITS-1);
printf("\toutput logic [%s:0] Z;\n",$ZBITS-1);
printf("\n\n");
for($y=0; $y < $YBITS ; $y++) {
    printf("\tlogic [%s:0] P%s;\n", $XBITS-1, $y);
    printf("\tlogic [%s:0] carry%s;\n", $XBITS-1, $y+1);
    printf("\tlogic [%s:0] sum%s;\n", $XBITS-1, $y+1);
}
printf("\tlogic [%s:0] carry%s;\n",$ZBITS-2,$YBITS+1);

print "\n\n";

# Generate the partial products
# -----------------------------
print "\t// generate the partial products.\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-1; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS){
	    if($y>$YBITS-$y_pp_size && $x==$XBITS-1) {
	        printf ("\tand pp%s(sum%s[%s], X[%s], Y[%s]);\n", 
			$pp_label, $y, $x, $x, $y);
	        $pp_label++;
	    }
	    else {
	        printf ("\tand pp%s(P%s[%s], X[%s], Y[%s]);\n", 
			$pp_label, $y, $x, $x, $y);
	        $pp_label++;
	    }
	}
    }
}
print "\n";

# Array Reduction
# ---------------
print "\t// Array Reduction\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS){
            if($y==$YBITS-$y_pp_size+1){
	        printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",
		       $ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
	        $ha_label++;
	    }
	    if($y>$YBITS-$y_pp_size+1){
                if($x+$y==$XBITS+$YBITS-$ZBITS){
	            printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s]);\n",
			   $ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
	            $ha_label++;
		}	    
	        else{
	            printf("\tfull_adder  FA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",
			   $fa_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
	            $fa_label++;
	        }
	    }
	}
    }
}


print "\n";
# Generate lower order product
print "\t// Generate lower product bits YBITS \n";
$Zpin=0;
if($ZBITS>$XBITS){
    for($y=$YBITS-$ZBITS+$XBITS; $y < $YBITS ; $y++){
	if($y==0){
	    printf("\tbuf b1(Z[0], P0[0]);\n");
	    $Zpin++;
	}
	else{
	    printf ("\tassign Z[%s] = sum%s[0];\n",$Zpin,$y);
	    $Zpin++;
	}
    }
}
print "\n";
# Generate higher order product
print "\t// Final Carry Propagate Addition\n";
$nhop=$XBITS;
$xstart=0;
for($x=$xstart; $x < $XBITS ; $x++) {
    if($x==$xstart) {
	if($x==$XBITS-$nhop){
	    printf("\thalf_adder CPA%s(carry%s[%s],Z[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS-1,$x+1);
	    $cpa_label++;
	    $Zpin++;
	}
	else{
	    printf("\tassign carry%s[%s] = carry%s[%s] & sum%s[%s];\n",$YBITS,$x,$YBITS-1,$x,$YBITS-1,$x+1);
	}
    }
    else{
	if($x==$XBITS-2) {
	    printf("\tfull_adder CPA%s(Z[%s],Z[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$Zpin+1,$Zpin,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
	    $cpa_label++;
	    $Zpin++;
	}
	else{		
	    if($x>=$XBITS-$nhop && $x<$XBITS-2) {
		printf("\tfull_adder CPA%s(carry%s[%s],Z[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
		$cpa_label++;
		$Zpin++;
	    }
	    if($x<$XBITS-$nhop && $x>$xstart && $x<$XBITS-2){
		printf("\treduced_full_adder CPA%s(carry%s[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
		$cpa_label++;      
	    }
	}
    }
}

print "\nendmodule\n";

sub pow2 {
    ($p) = @_;
    $res = 1;
    for($i=1;$i<=$p;$i++){
        $res = $res * 2;
    }
    return($res);
}

sub round_near {
    ($num) = @_;
    $rnd = 0;
    while($num>$rnd+0.5){
        $rnd = $rnd + 1;
    }
    return($rnd);
}



