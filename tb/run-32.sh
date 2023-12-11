#!/bin/sh
vsim -do f32_add_rne.do -c
vsim -do f32_add_rz.do -c
vsim -do f32_add_ru.do -c
vsim -do f32_add_rd.do -c
vsim -do f32_sub_rne.do -c
vsim -do f32_sub_rz.do -c
vsim -do f32_sub_ru.do -c
vsim -do f32_sub_rd.do -c
