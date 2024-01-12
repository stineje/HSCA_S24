#!/bin/sh
sed -i 's/8192/32767/g' *.c
make
./random_int8 > random_int8.tv
./random_int16 > random_int16.tv
./random_int32 > random_int32.tv
./random_int64 > random_int64.tv
./random_int128 > random_int128.tv
