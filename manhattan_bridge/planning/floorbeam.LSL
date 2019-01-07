 ____________________________________________ 
*Solution commenced on 05/12/2018 at 12:13:01 
  
 Strand7 [2.4.6][Solver Build: 24141222] (32-Bit) 
  
 ANALYSIS TYPE               : LINEAR STATIC 
  
 COMPUTER NAME               : JBB-LAPTOP 
 USER LOGON NAME             : John 
 CPU                         : Intel(R) Core(TM) i7-4600U CPU @ 2.10GHz 
 USABLE PHYSICAL MEMORY      : 4.0 GB 
 USABLE VIRTUAL MEMORY       : 3.0 GB 
  
 MODEL FILE                  : "C:\Users\John\Projects_Git\rutgers_misc\manhattan_bridge\planning\floorbeam.st7" 
 RESULT FILE                 : "C:\Users\John\Projects_Git\rutgers_misc\manhattan_bridge\planning\floorbeam.LSA" 
 SCRATCH PATH                : "C:\Users\John\Strand7\Tmp\" 
  
 TOTALS 
 Nodes                       : 9 
 Beams                       : 8 
 Plates                      : 0 
 Bricks                      : 0 
 Links                       : 0 
  
 SOLVER UNITS 
 Length                      : in 
 Mass                        : lbm 
 Force                       : lbf 
 Stress                      : psi 
  
 FREEDOM CASE                : "Freedom Case 1" 
  
 LOAD CASES                  : "Load Case 1" 
                             : "Load Case 2" 
  
 STORAGE SCHEME              : Sparse  
 SORTING METHOD              : AMD  
 SOLUTION TYPE               : Direct  
  
 NUMBER OF EQUATIONS         : 24 
 MATRIX FILL-IN              : 0.0% 
 [K] MATRIX SIZE             : < 1 KB 
 OPTIMUM RAM NEEDED          : 64.0 KB 
 FREE SCRATCH SPACE          : 18.3 GB 
  
*WARNING[237]:Default freedom conditions appear to be over-constrained - one or more elements may require additional freedom. 
  
 SUMMATION OF APPLIED LOADS  
          Case        FX           FY           FZ           MX           MY           MZ        Name 
 Nodes      1     0.00000E+00 -2.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 1" 
            2     0.00000E+00 -4.20000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 2" 
 Beams      1     0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 1" 
            2     0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 2" 
 Total      1     0.00000E+00 -2.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 1" 
            2     0.00000E+00 -4.20000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 2" 
 Vector     1     0.00000E+00 -2.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 1" 
            2     0.00000E+00 -4.20000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00   "Load Case 2" 
  
 SUMMATION OF MOMENTS OF APPLIED LOADS ABOUT THE ORIGIN [Load Vector] 
          Case        MXo          MYo          MZo       Name 
            1     0.00000E+00  0.00000E+00 -9.00000E+02   "Load Case 1" 
            2     0.00000E+00  0.00000E+00 -1.29000E+03   "Load Case 2" 
  
 Reducing 24 Equations (Using 64.0 KB RAM)... 
  
 MAXIMUM PIVOT               : 4.712051E+09 (Node 6 RZ) 
 MINIMUM PIVOT               : 4.181313E+05 (Node 7 DY) 
  
 Results for 2 Load Cases... 
  
 MAXIMUM DISPLACEMENT MAGNITUDES 
   Case        DX           DY           DZ           RX           RY           RZ       Name 
     1     0.00000E+00  7.56073E-05  0.00000E+00  0.00000E+00  0.00000E+00  4.53883E-07  "Load Case 1" 
     2     0.00000E+00  1.58775E-04  0.00000E+00  0.00000E+00  0.00000E+00  8.44222E-07  "Load Case 2" 
  
 DIRECT SUMMATION OF NODE REACTION FORCES 
   Case        FX           FY           FZ           MX           MY           MZ       Name 
     1     0.00000E+00  2.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00 -3.55271E-13  "Load Case 1" 
     2     0.00000E+00  4.20000E+00  0.00000E+00  0.00000E+00  0.00000E+00 -2.24532E-12  "Load Case 2" 
  
 TOTAL CPU TIME              : 0.438 Seconds 
  
*Solution completed on 05/12/2018 at 12:13:01 
*Solution time: 0 Seconds 
  
 
*SUMMARY OF MESSAGES
*Number of Notes    : 0
*Number of Warnings : 1
*Number of Errors   : 0
 
