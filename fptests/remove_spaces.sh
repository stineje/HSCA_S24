#!/bin/sh
BUILD="../../addins/TestFloat-3e/build/Linux-x86_64-GCC"
OUTPUT="./vectors"
echo "Editing f32_div test vectors"
sed -i 's/ /_/g' $OUTPUT/f32_div_rne.tv
sed -i 's/ /_/g' $OUTPUT/f32_div_rz.tv
sed -i 's/ /_/g' $OUTPUT/f32_div_ru.tv
sed -i 's/ /_/g' $OUTPUT/f32_div_rd.tv
sed -i 's/ /_/g' $OUTPUT/f32_div_rnm.tv
sed -i 's/ /_/g' $OUTPUT/f32_div_odd.tv
echo "Editing f32_sqrt test vectors"
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_rne.tv
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_rz.tv
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_ru.tv
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_rd.tv
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_rnm.tv
sed -i 's/ /_/g' $OUTPUT/f32_sqrt_odd.tv
