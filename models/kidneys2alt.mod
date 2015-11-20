param n >= 1, integer;	# number of patient donor pairs

set DONORS	 := 1 .. n;	# set of donors
set PATIENTS := 1 .. n;	    # set of patients

param exchanges {DONORS, PATIENTS} >= 0; # values for entries of the matrix

var pair_exchanges {DONORS, PATIENTS} binary; # binary variable for whether a paired exchange exists
var two_cycle {DONORS, PATIENTS} binary;
var three_cycle {DONORS, PATIENTS, PATIENTS} binary;

# maximizing total number of exchanges
maximize num_exchanges: sum {i in DONORS, j in PATIENTS} two_cycle[i,j] + sum {i in DONORS, j in PATIENTS, k in PATIENTS} three_cycle[i,j,k];

# 
subject to DonorLimit {i in DONORS, j in PATIENTS}: 
	pair_exchanges[i,j] <= pair_exchanges[j,i]+1-two_cycle[i,j];

subject to PatientLimit {i in DONORS, j in PATIENTS, k in PATIENTS}: 
	pair_exchanges[i,j] <= (pair_exchanges[j,k]+pair_exchanges[k,i])/2+1-three_cycle[i,j,k];

subject to GoldenRule {i in DONORS}: 
	sum{j in PATIENTS} pair_exchanges[i,j] = sum{k in DONORS} pair_exchanges[k,i];

subject to KidneyLimit {j in PATIENTS}: 
	sum{i in DONORS} pair_exchanges[i,j] <= 1;

subject to TwoCycle {i in DONORS, j in PATIENTS}:
	two_cycle[i,j] = two_cycle[j,i];

subject to TwoCycleLimit {i in DONORS, j in PATIENTS}:
	two_cycle[i,j] <= exchanges[i,j];

subject to ThreeCycle {i in DONORS, j in PATIENTS, k in PATIENTS}:
	three_cycle[i,j,k]=three_cycle[j,k,i];

subject to ThreeCycleLimit {i in DONORS, j in PATIENTS, k in PATIENTS}:
	three_cycle[i,j,k] <= (exchanges[i,j]+exchanges[j,k]+exchanges[k,i])/3;

subject to BothLimit {i in DONORS, j in PATIENTS}:
	two_cycle[i,j]+sum{k in PATIENTS} three_cycle[i,j,k]<=1;

subject to another1 {i in DONORS, j in PATIENTS}:
	pair_exchanges[i,j]>=two_cycle[i,j];

subject to another2 {i in DONORS, j in PATIENTS, k in PATIENTS}:
	pair_exchanges[i,j]+pair_exchanges[j,k]+pair_exchanges[k,i]>=three_cycle[i,j,k];