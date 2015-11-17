param n >= 1, integer;	# number of patient donor pairs

set DONORS	 := 1 .. n;	# set of donors
set PATIENTS := 1 .. n;	    # set of patients

param exchanges {DONORS, PATIENTS} >= 0; # values for entries of the matrix

var two_var {DONORS, DONORS} binary; # binary if 2 cycle included
var three_var {DONORS, DONORS, DONORS} binary; #binary if 3 cycle included
# var visualization_aid {DONORS, DONORS}; #purely exists for MATLAB visualization, slows down process

set TWO_CYCLES := {i in DONORS, j in DONORS: exchanges[i,j] > 0 and exchanges[j,i] > 0 and i < j}; # set of valid exchanges, inequalities to restrict sets
set THREE_CYCLES := {i in DONORS, j in DONORS, k in DONORS: exchanges[i,j] > 0 and exchanges[j,k] > 0 and exchanges[k,i] >0 and i < j and 
	k > i and j<>k}; # set of valid exchanges

set TWO_CYCLE_NUM {d in DONORS} := {(i,j) in TWO_CYCLES: i=d or j=d};
set THREE_CYCLE_NUM {d in DONORS} := {(i,j,k) in THREE_CYCLES: i=d or j=d or k = d};

# maximizing total number of exchanges
maximize num_exchanges: sum {(i,j) in TWO_CYCLES} (2* two_var[i,j]) + sum {(i,j,k) in THREE_CYCLES} (3 * three_var[i,j,k]);

subject to ExclusiveNumUse{d in DONORS}:
	sum {(i,j) in TWO_CYCLE_NUM[d]} two_var[i,j] + sum {(i,j,k) in THREE_CYCLE_NUM[d]} three_var[i,j,k]<= 1;

#subject to VizHelper {i in DONORS, j in DONORS}: #purely for visualization, slows down process
#	visualization_aid[i,j] = two_var[i,j] + two_var[j,i] + sum{k in DONORS}(three_var[i,j,k]+three_var[k,i,j]+three_var[j,k,i]);