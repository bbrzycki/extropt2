param n >= 1, integer;	# number of patient donor pairs

set DONORS	 := 1 .. n;	# set of donors
set PATIENTS := 1 .. n;	    # set of patients

param exchanges {DONORS, PATIENTS} >= 0; # values for entries of the matrix

set VALID_EXCHANGES := {i in DONORS, j in PATIENTS: exchanges[i,j] > 0}; # set of valid exchanges

var pair_exchanges {DONORS, PATIENTS} binary; # binary variable for whether a paired exchange exists

# maximizing total number of exchanges
maximize num_exchanges: sum {(i,j) in VALID_EXCHANGES} pair_exchanges[i,j];

# 
subject to DonorLimit {i in DONORS}: 
	sum{j in PATIENTS} pair_exchanges[i,j] <= 1;

subject to PatientLimit {j in PATIENTS}: 
	sum{i in DONORS} pair_exchanges[i,j] <= 1;

subject to PairedExchange {(i,j) in VALID_EXCHANGES}:
	pair_exchanges[i,j] * exchanges[i,j] = pair_exchanges[j,i] * exchanges[j,i];