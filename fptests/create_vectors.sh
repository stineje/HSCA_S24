#!/bin/sh
BUILD="../addins/TestFloat-3ed/build/Linux-x86_64-GCC"
OUTPUT="./vectors"
echo "Creating f32_div vectors"
$BUILD/testfloat_gen -tininessafter -level 1 -rnear_even f32_div > $OUTPUT/f32_div_rne.tv
$BUILD/testfloat_gen -tininessafter -level 1 -rminMag f32_div > $OUTPUT/f32_div_rz.tv
$BUILD/testfloat_gen -tininessafter -level 1 -rmax f32_div > $OUTPUT/f32_div_ru.tv
$BUILD/testfloat_gen -tininessafter -level 1 -rmin f32_div > $OUTPUT/f32_div_rd.tv
$BUILD/testfloat_gen -tininessafter -level 1 -rnear_maxMag f32_div > $OUTPUT/f32_div_rnm.tv
$BUILD/testfloat_gen -tininessafter -level 1 -rodd f32_div > $OUTPUT/f32_div_odd.tv
echo "Creating f32_sqrt vectors"
$BUILD/testfloat_gen -tininessafter -level 2 -rnear_even f32_sqrt > $OUTPUT/f32_sqrt_rne.tv
$BUILD/testfloat_gen -tininessafter -level 2 -rminMag f32_sqrt > $OUTPUT/f32_sqrt_rz.tv
$BUILD/testfloat_gen -tininessafter -level 2 -rmax f32_sqrt > $OUTPUT/f32_sqrt_ru.tv
$BUILD/testfloat_gen -tininessafter -level 2 -rmin f32_sqrt > $OUTPUT/f32_sqrt_rd.tv
$BUILD/testfloat_gen -tininessafter -level 2 -rnear_maxMag f32_sqrt > $OUTPUT/f32_sqrt_rnm.t
$BUILD/testfloat_gen -tininessafter -level 2 -rodd f32_sqrt > $OUTPUT/f32_sqrt_odd.tv
