#!/bin/sh --# perl, to stop looping
eval 'exec /usr/local/bin/perl $0 ${1+"${@}"}'
    if 0;
  
# Perl script to generate truncated array multiplier (Variable Correction)
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

$pp_label=1;
$ha_label=1;
$fa_label=1;
$cpa_label=1;
$sha_label=1;
$rfa_label=1;
       
$instcnt=1;

if(length($MODULE)==0){
    printf("module VCTarray%s_%s_%s_%s (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS, $K);
}
else{
    printf("module $MODULE (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS, $K);
}
printf("\t\n");
printf("\tinput [%s:0] Y;\n",$YBITS-1);
printf("\tinput [%s:0] X;\n",$XBITS-1);
printf("\toutput [%s:0] Z;\n",$ZBITS-1);
printf("\t\n\n");
for($y=0; $y < $YBITS ; $y++) {
    printf("\twire [%s:0] P%s;\n", $XBITS-1, $y);
    printf("\twire [%s:0] carry%s;\n", $XBITS-1, $y+1);
    printf("\twire [%s:0] sum%s;\n", $XBITS-1, $y+1);
}
print "\n\n";


# calculation of which partial products have to be generated
if($XBITS<$ZBITS+$K){
    $x_pp_size=$XBITS;
    $h_pp_size=$K+$ZBITS-$XBITS;
}
else{
    $x_pp_size=$ZBITS+$K;
    $h_pp_size=2;
}
if($YBITS<$ZBITS+$K){
    $y_pp_size=$YBITS;
}
else{
    $y_pp_size=$ZBITS+$K-1;
}

print "\t// generate the partial products.\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-1; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K-1 && !($y==$YBITS-$y_pp_size && $x+$y==$XBITS+$YBITS-$ZBITS-$K-1)){
	    if($y>$YBITS-$y_pp_size && $x==$XBITS-1) {
	        printf ("\tand pp%s(sum%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
	        $pp_label++;
            }
            elsif($y>$YBITS-$y_pp_size && $x+$y==$XBITS+$YBITS-$ZBITS-$K-1){
	        printf ("\tand pp%s(carry%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
	        $pp_label++;            
            }
	    else {
	        printf ("\tand pp%s(P%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
	        $pp_label++;
	    }
	}
    }
}
	
print "\n";
# Array Reduction
print "\t// Array Reduction\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            if($y==$YBITS-$y_pp_size+1){
                if($x>=$XBITS+$YBITS-$ZBITS-$y-1){
	            printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",$ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
	            $ha_label++;
	        }
                else{
                    if($K>=2 && $x==0){
                        printf("\tassign carry%s[%s] = P%s[%s] | P%s[%s];\n",$y,$x,$y,$x,$y-1,$x+1);
                    }
                    else{
                        printf("\tspecialized_half_adder  SHA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",$sha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                        $sha_label++;
                    }
		}
	    }
	    if($y>$YBITS-$y_pp_size+1){
                if($x==0 && $y<$YBITS-$h_pp_size+$K){
	            printf("\treduced_full_adder  RFA%s(carry%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$rfa_label,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
	            $rfa_label++;
		}
                else{
	            printf("\tfull_adder  FA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$fa_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
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
print "\t//   Generate higher product bits\n";
if($ZBITS>$XBITS){
    $nhop=$XBITS;
}
else{
    $nhop=$ZBITS;
}
if($XBITS-$ZBITS-$K>0){
    $xstart=$XBITS-$ZBITS-$K;
}
else{
    $xstart=0;
}
for($x=$xstart; $x < $XBITS ; $x++) {
    if($x==$xstart) {
        if($x==$XBITS-$nhop){
	    printf("\thalf_adder CPA%s(carry%s[%s],Z[%s],carry%s[%s],sum%s[%s]);\n",
	        $cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS-1,$x+1);
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

print "endmodule";
