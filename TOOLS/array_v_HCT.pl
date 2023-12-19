#!/bin/sh --# perl, to stop looping
eval 'exec /usr/local/bin/perl $0 ${1+"${@}"}'
    if 0;
  
# Perl script to generate truncated array multiplier (Hybrid Correction)
# Last update: 08/23/02

use Getopt::Std;
    
# options are
#       -x <bits> the number of x bits
#       -y <bits> the number of y bits
#       -z <bits> the number of output bits
#       -k <int> number of columns to keep
#       -r <float> percentage of variable correction to use
#       -m <string> module name

getopts('x:y:z:k:r:m:');

$XBITS=$opt_x;
$YBITS=$opt_y;
$ZBITS=$opt_z;
$K=$opt_k;
$RATIO=$opt_r;
$MODULE=$opt_m;

if($XBITS<=0 || $YBITS<=0 || $ZBITS<=0 || $K<0 || $RATIO<0 || $RATIO>1){
    print("Input parameters:\n");
    print("    -x <bits> the number of x bits\n");
    print("    -y <bits> the number of y bits\n");
    print("    -z <bits> the number of output bits\n");
    print("    -k <int> number of columns to keep\n");
    print("    -r <float> percentage of variable correction to use\n");
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

# Calculation of the number of bits required for the variable correction
# ----------------------------------------------------------------------
$nbitsvar=0;
for($y=0;$y<$YBITS;$y++) {
    for($x=0;$x<$XBITS;$x++) {
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K-1){
            $nbitsvar++;
        }
    }
}
$nbitsvar=&round($nbitsvar*$RATIO);

# Calculation of the correction constant
# --------------------------------------
$err_red = 0;
for($q = $ZBITS+$K+1; $q <= $XBITS+$YBITS; $q++) {
    $err_red += ($XBITS+$YBITS+1-$q)/&pow2($q);  # reduction error
}
$var_cor = 0.25 * $nbitsvar / &pow2($ZBITS+$K); # variable correction
$err_rnd = 1/pow2($ZBITS)*(1 - 1/&pow2($K));  # rounding error
$err_tot = 0.25*$err_red + 0.5*$err_rnd - $var_cor;
printf("\n// Correction constant value: %s (",$err_tot);

# Rounding of that constant
$err_tot_rnd = $err_tot * &pow2($ZBITS+$K);
$err_tot_rnd = &round_near($err_tot_rnd);
$err_tot_rnd = $err_tot_rnd / &pow2($ZBITS+$K);

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

# Display the value of the constant correction
for($j=$XBITS+$YBITS-1;$j>=$XBITS+$YBITS-$ZBITS-$K;$j--){
    printf("%s",@carray[$j]);
}
printf(")\n\n");

# Calculation of the number of bits required for the constant correction
# ----------------------------------------------------------------------
$nbitscon=0;
for($j=$XBITS+$YBITS-$ZBITS-$K;$j<$XBITS+$YBITS;$j++){
    $nbitscon += @carray[$j]*&pow2($j-($XBITS+$YBITS-$ZBITS-$K));
}

# Calculation of which partial products have to be generated
# (if it would have been only a variable correction)
# ----------------------------------------------------------
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

# Calculation of the number of bits available for correction
# (number of HA located on the diagonal and on the second line)
# -------------------------------------------------------------
$nha=0;
$nhadiag=0;
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            if($y==$YBITS-$y_pp_size+1){
                $nha++;
            }
        }
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K && $y>$YBITS-$y_pp_size+1){
            $nhadiag++;
        }
    }
}

# Check if the constant correction can be done
# --------------------------------------------
$sum_max=$nhadiag;
for($i=0;$i<$nha;$i++){
    $sum_max += &pow2($i);   
}
$sum_req=$nbitscon+$nbitsvar;
if($sum_req>$sum_max || ($XBITS+$YBITS==$ZBITS+$K && @carray[$XBITS+$YBITS-$ZBITS-$K]==1)){
    $optimize=0;
}
else{
    $optimize=1;
}

# print("NBITSVAR: $nbitsvar  NBITSCON: $nbitscon\n");
# printf("NHA: $nha  NFAD: $nhadiag\n");
# printf("SUMMAX: $sum_max  SUMREQ: $sum_req\n");

# Write the header of the verilog file (variables definition)
# -----------------------------------------------------------
if(length($MODULE)==0){
    printf("module HCTarray%s_%s_%s_%s (Z, X, Y);\n", $XBITS, $YBITS, $ZBITS, $K);
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

# Generate the partial products
# -----------------------------
print "\t// generate the partial products.\n";
$nbitsvarused=0;
$varonlastrow=0;
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-1; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            if($y>$YBITS-$y_pp_size && $x==$XBITS-1) {
                printf ("\tand pp%s(sum%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
                $pp_label++;
            }
            else{
                printf ("\tand pp%s(P%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
                $pp_label++;
            }
        }
        if($x+$y==$XBITS+$YBITS-$ZBITS-$K-1 && $y>$YBITS-$y_pp_size && $nbitsvarused<$nbitsvar){
            printf ("\tand pp%s(carry%s[%s], X[%s], Y[%s]);\n", $pp_label, $y, $x, $x, $y);
            $nbitsvarused++;
            $pp_label++;
            if($y==$YBITS-1){ # Check if there is one partial product of the variable correction in the last row
                $varonlastrow=1;
            }
        }
    }
}     
print "\n";

# $optimize=0;
if($optimize==0 || $XBITS+$YBITS==$ZBITS){
    goto NO_OPTIMIZE;
}

# Array Reduction
# ---------------
$nbitsvarused=0;
$nbitsconused=0;
print "\t// Array Reduction\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            if($y==$YBITS-$y_pp_size+1){
                if($nbitsconused+&pow2($x-($XBITS+$YBITS-$ZBITS-$K-$y))<=$nbitscon){
                    if($K>=2 && $x==0){
                        printf("\tassign carry%s[%s] = P%s[%s] & P%s[%s];\n",$y,$x,$y,$x,$y-1,$x+1);
                        $nbitsconused++;
                    }
                    else{
                        printf("\tspecialized_half_adder  SHA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",$sha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                        $sha_label++;
                        $nbitsconused += &pow2($x-($XBITS+$YBITS-$ZBITS-$K-$y));
                    }
                }
                else{
                    if($K>=2 && $x==0){
                        printf("\tassign carry%s[%s] = P%s[%s] | P%s[%s];\n",$y,$x,$y,$x,$y-1,$x+1);
                    }
                    else{
                        printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",$ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                        $ha_label++;
                    }
                }
            }
            if($y>$YBITS-$y_pp_size+1){
                if($y>$YBITS-$y_pp_size && $nbitsvarused<$nbitsvar && $x+$y==$XBITS+$YBITS-$ZBITS-$K){
                    $nbitsvarused++;
                    if($x==0 && $y<$YBITS-$h_pp_size+$K){
                        printf("\treduced_full_adder  RFA%s(carry%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$rfa_label,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
                        $rfa_label++;
                    }
                    else{
                        printf("\tfull_adder  FA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$fa_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
                        $fa_label++;
                    }
                }
                else{
                    if($x+$y==$XBITS+$YBITS-$ZBITS-$K){
                        if($nbitsconused<$nbitscon){
                            if($x==0 && $y<$YBITS-$h_pp_size+$K){
                                printf("\tassign carry%s[%s] = P%s[%s] | sum%s[%s];\n",$y,$x,$y,$x,$y-1,$x+1);
                                $nbitsconused++;
                            }
                            else{
                                printf("\tspecialized_half_adder  SHA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s]);\n",$sha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                                $sha_label++;
                                $nbitsconused++;
                            }
                        }
                        else{
                            if($x==0 && $y<$YBITS-$h_pp_size+$K){
                                printf("\tassign carry%s[%s] = P%s[%s] & sum%s[%s];\n",$y,$x,$y,$x,$y-1,$x+1);
                            }
                            else{
                                printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s]);\n",$ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                                $ha_label++;
                            }
                        }
                    }       
                    else{
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
    }
}
print "\n";
# Generate lower order product
print "\t// Generate lower product bits YBITS \n";
$Zpin=0;
if($ZBITS>$XBITS){
    for($y=$YBITS+$XBITS-$ZBITS; $y < $YBITS ; $y++){
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
if($ZBITS+$K>$XBITS){
    $xstart=0;
}
else{
    $xstart=$XBITS-$ZBITS-$K;;
}
for($x=$xstart; $x < $XBITS ; $x++) {
    if($x==$xstart) {
        if($x==$XBITS-$nhop){
            if($ZBITS+$K>$XBITS || $varonlastrow){
                printf("\thalf_adder CPA%s(carry%s[%s],Z[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS-1,$x+1);
                $cpa_label++;
            }
            else{
                printf("\tassign carry%s[%s] = 0;\n",$YBITS,$x);
                printf("\tassign Z[%s] = sum%s[%s];\n",$Zpin,$YBITS-1,$x+1);
            }
            $Zpin++;
        }
        else{
            if($ZBITS+$K>$XBITS || $varonlastrow){
                printf("\tassign carry%s[%s] = carry%s[%s] & sum%s[%s];\n",$YBITS,$x,$YBITS-1,$x,$YBITS-1,$x+1);
            }
            else{
                printf("\tassign carry%s[%s] = 0;\n",$YBITS,$x);
            }
        }                 
    }
    else{
        if($x==$XBITS-2) {
            printf("\tfull_adder CPA%s(Z[%s],Z[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$Zpin+1,$Zpin,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
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
goto END;

NO_OPTIMIZE: printf("// FAILED TO OPTIMIZE THE CORRECTION!\n");
# Array Reduction
# ---------------
$nbitsvarused=0;
print "\t// Array Reduction\n";
for($y=$YBITS-$y_pp_size; $y < $YBITS ; $y++) {
    for($x=$XBITS-2; $x >= $XBITS-$x_pp_size; $x--) {
        if($x+$y>=$XBITS+$YBITS-$ZBITS-$K){
            if($y==$YBITS-$y_pp_size+1){
                printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],P%s[%s]);\n",$ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                $ha_label++;
            }
            if($y>$YBITS-$y_pp_size+1){
                if($nbitsvarused<$nbitsvar && $x+$y==$XBITS+$YBITS-$ZBITS-$K){
                    $nbitsvarused++;
                    printf("\tfull_adder  FA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$fa_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
                    $fa_label++;
                }
                else{
                    if($x+$y==$XBITS+$YBITS-$ZBITS-$K){
                        printf("\thalf_adder  HA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s]);\n",$ha_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1);
                        $ha_label++;
                    }       
                    else{
                        printf("\tfull_adder  FA%s(carry%s[%s],sum%s[%s],P%s[%s],sum%s[%s],carry%s[%s]);\n",$fa_label,$y,$x,$y,$x,$y,$x,$y-1,$x+1,$y-1,$x);
                        $fa_label++;
                    }
                }
            }
        }
    }
}
print "\n";

if($XBITS+$YBITS>$ZBITS){
    printf("\twire [%s:0] carry%s;\n",$ZBITS+$K-2,$YBITS+1);
    printf("\twire [%s:0] Z2;\n",$ZBITS+$K-1);
    # Generate lower order product
    print "\t// Generate lower product bits YBITS \n";
    $Zpin=0;
    if($ZBITS+$K>$XBITS){
        for($y=$YBITS+$XBITS-$ZBITS-$K; $y < $YBITS ; $y++){
            if($y==0){
                printf("\tbuf b1(Z2[0], P0[0]);\n");
                $Zpin++;
            }
            else{
                printf ("\tassign Z2[%s] = sum%s[0];\n",$Zpin,$y);
                $Zpin++;
            }
        }
    }
    print "\n";
    # Generate higher order product
    print "\t// Final Carry Propagate Addition\n";
    print "\t//   Generate higher product bits\n";
    if($ZBITS+$K>$XBITS){
        $nhop=$XBITS;
    }
    else{
        $nhop=$ZBITS+$K;
    }
    for($x=$XBITS-$nhop; $x < $XBITS ; $x++) {
        if($x==$XBITS-$nhop) {
            if($ZBITS+$K>$XBITS || $varonlastrow){
                printf("\thalf_adder CPA%s(carry%s[%s],Z2[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS-1,$x+1);
            }
            else{
                printf("\tassign carry%s[%s] = 0;\n",$YBITS,$x);
                printf("\tassign Z2[%s] = sum%s[%s];\n",$Zpin,$YBITS-1,$x+1);
            }
            $cpa_label++;
            $Zpin++;
        }
        if($x==$XBITS-2) {
            printf("\tfull_adder CPA%s(Z2[%s],Z2[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$Zpin+1,$Zpin,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
            $cpa_label++;
            $Zpin++;
        }                       
        if($x>$XBITS-$nhop && $x<$XBITS-2) {
            printf("\tfull_adder CPA%s(carry%s[%s],Z2[%s],carry%s[%s],carry%s[%s],sum%s[%s]);\n",$cpa_label,$YBITS,$x,$Zpin,$YBITS-1,$x,$YBITS,$x-1,$YBITS-1,$x+1);
            $cpa_label++;
            $Zpin++;    
        }
    }
    print "\n";
    # Add the constant to the sum previously calculated
    print "\t// Add the constant\n";
    for($x=0;$x<$ZBITS+$K;$x++){
        if($x==0) {
            if(@carray[$XBITS+$YBITS-$ZBITS-$K+$x]==0){
                if($K==0){
                    printf("\tassign Z[%s] = Z2[%s];\n",$x,$x);
                }
                printf("\tassign carry%s[%s] = 0;\n",$YBITS+1,$x);
            }
            else{
                if($K==0){
                    printf("\tassign Z[%s] = !Z2[%s];\n",$x,$x);
                }
                printf("\tassign carry%s[%s] = Z2[%s];\n",$YBITS+1,$x,$x);
            }
        }
        if($x==$ZBITS+$K-1) {
            printf("\tassign Z[%s] = Z2[%s] ^ carry%s[%s];\n",$x-$K,$x,$YBITS+1,$x-1);
        }                       
        if($x>0 && $x<$ZBITS+$K-1) {
            if($x>=$K){
                if(@carray[$XBITS+$YBITS-$ZBITS-$K+$x]==0){
                    printf("\thalf_adder CPA%s(carry%s[%s],Z[%s],Z2[%s],carry%s[%s]);\n",$cpa_label,$YBITS+1,$x,$x-$K,$x,$YBITS+1,$x-1);
                }
                else{
                    printf("\tspecialized_half_adder CPA%s(carry%s[%s],Z[%s],Z2[%s],carry%s[%s]);\n",$cpa_label,$YBITS+1,$x,$x-$K,$x,$YBITS+1,$x-1);            
                }
            }
            else{
                if(@carray[$XBITS+$YBITS-$ZBITS-$K+$x]==0){
                    printf("\tand CPA%s(carry%s[%s],Z2[%s],carry%s[%s]);\n",$cpa_label,$YBITS+1,$x,$x,$YBITS+1,$x-1);
                }
                else{
                    printf("\tor CPA%s(carry%s[%s],Z2[%s],carry%s[%s]);\n",$cpa_label,$YBITS+1,$x,$x,$YBITS+1,$x-1);
                }
            }
            $cpa_label++;
        }
    }
}

else{   # if $XBITS+$YBITS=$ZBITS (no truncation)
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
}

END: print "endmodule";

sub pow2 {
    ($p) = @_;
    $res = 1;
    for($ipow=1;$ipow<=$p;$ipow++){
        $res = $res * 2;
    }
    return($res);
}

sub round {
    ($num) = @_;
    $rnd = 1;
    while($num>=$rnd){
        $rnd = $rnd + 1;
    }
    return($rnd-1);
}

sub round_near {
    ($num) = @_;
    $rnd = 0;
    while($num>$rnd+0.5){
        $rnd = $rnd + 1;
    }
    return($rnd);
}
