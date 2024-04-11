Synthesis for RISC-V Microprocessor System-on-Chip Design

This subdirectory contains synthesis scripts for use with Synopsys
(snps) Design Compiler (DC).  Synthesis commands are found in
scripts/synth.tcl.

Example Usage
make synth 

environment variables

DESIGN
        Design provides the name of the output log.  Default is synth.

FREQ
        Frequency in MHz.  Default is 500

SAIFPOWER
        Controls if power analysis is driven by switching factor or
	RTL modelsim simulation. When enabled requires a saif file
	named power.saif.  The default is 0.
        0: switching factor power analysis
        1: RTL simulation driven power analysis.

