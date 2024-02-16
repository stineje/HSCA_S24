#!/bin/sh
vcd2saif -input $1.vcd -output $1.saif
rm -f $1.vcd


