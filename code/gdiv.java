import java.text.*;
import java.math.*;
import java.io.*;

public class gdiv {

    public static double rne (double x, double precision) {
	double scale;
	double x_round;
	scale = Math.pow(2.0, precision);
	x_round = Math.rint (x * scale) / scale;
	return x_round;
    }

    public static double flr (double x, double precision) {
	double scale;
	double x_round;
	scale = Math.pow(2.0, precision);
	x_round = Math.floor (x * scale) / scale;
	return x_round;
    }	 

    public static void disp_bin (double x, int bits_to_left, int bits_to_right) {
	double diff;
	int i;
	if (Math.abs(x) <  Math.pow (2.0, -bits_to_right)) {
	    for (i = -bits_to_left + 1; i <= bits_to_right; i++) {
		System.out.print("0");
	    }
	    return;
	}
	if (x < 0.0) {
	    x = Math.pow(2.0, ((double) bits_to_left)) + x;
	}
	for (i = -bits_to_left + 1; i <= bits_to_right; i++) {
	    diff = Math.pow(2.0, -i);
	    if (x < diff) {
		System.out.print("0");
	    }
	    else {
		System.out.print("1");
		x -= diff;
	    }
	    if (i == 0) {
		System.out.print(".");
	    }
	}
    }

    public static void main (String [] args) {

	double N = 1.7612245799747974;
	double D = 1.90303390403;
	double R = 0.75;
	int num_iter = 6;
	int iprec = 32;
	int iprec_f = 24;
	double Q;
	double RQ;
	double RD;
	double REM;
	double RREM;
	int i;

	
	N = rne (N, (double) iprec_f);
	D = rne (D, (double) iprec_f);
	Q = N/D;
	System.out.println("---------------------------");
	System.out.println("Inputs");
	System.out.println("---------------------------");
	System.out.print("N = ");
	disp_bin (N, 2, iprec_f);
	System.out.println("");
	System.out.print("D = ");
	disp_bin (D, 2, iprec_f);
	System.out.println("");
	System.out.println("---------------------------");
	System.out.println("Computation");
	System.out.println("---------------------------");

	for (i = 0; i < num_iter; i++) {
	    N = rne (N*R, iprec);
	    D = rne (D*R, iprec);
	    R = rne (2 - D, iprec);
	    System.out.println ("i = " + i + ", N = " + N + ", R = " + R); 
	    System.out.print ("i = " + i + ", N = ");
	    disp_bin (N, 2, iprec);
	    System.out.print(", ");
	    System.out.print ("R = ");
	    disp_bin (D, 2, iprec);
	    System.out.println("");	
	    System.out.println("");	
	}

	RQ = rne (Q, iprec_f);
	RD = rne (N, iprec_f);

	System.out.println("---------------------------");
	System.out.println("Actual Answer");
	System.out.print("RQ = " + RQ + ", ");
	disp_bin(RQ, 2, iprec_f);
	System.out.println("");
	System.out.println("---------------------------");
	System.out.println("GDIV Answer");
	System.out.print("RD = " + RD + ", ");
	disp_bin(RD, 2, iprec_f);
	System.out.println("");
	System.out.println("---------------------------");
	System.out.println("Error Analysis");
	System.out.println("Error " + Math.abs(RQ - RD));
	System.out.println("#bits " + Math.log((RQ - RD)/Math.log(2.0)));
	System.out.println("---------------------------");

    }
}
