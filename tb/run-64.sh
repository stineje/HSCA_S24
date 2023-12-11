#!/bin/sh
vsim -do f64_add_rne.do -c
vsim -do f64_add_rz.do -c
vsim -do f64_add_ru.do -c
vsim -do f64_add_rd.do -c
vsim -do f64_sub_rne.do -c
vsim -do f64_sub_rz.do -c
vsim -do f64_sub_ru.do -c
vsim -do f64_sub_rd.do -c
