param n >= 1, integer;	# number of patient donor pairs

set DONORS	 := 1 .. n;	# set of donors
set PATIENTS := 1 .. n;	    # set of patients

param exchanges {DONORS, PATIENTS} >= 0; # values for entries of the matrix

var pair_exchanges {DONORS, PATIENTS} binary; # binary variable for whether a paired exchange exists

set VALID_CYCLES := {i in DONORS, j in DONORS, k in DONORS, l in DONORS: 
	i <> j and i <> k and i <> l and j <> k and j <> l and k <>l}; # set of valid exchanges

# maximizing total number of exchanges
maximize num_exchanges: sum {i in DONORS, j in PATIENTS} pair_exchanges[i,j];

# 
subject to DonorLimit {i in DONORS}: 
	sum{j in PATIENTS} pair_exchanges[i,j] <= 1;

subject to PatientLimit {j in PATIENTS}: 
	sum{i in DONORS} pair_exchanges[i,j] <= 1;

subject to GoldenRule {i in DONORS}: 
	sum{j in PATIENTS}pair_exchanges[i,j] = sum{k in PATIENTS}pair_exchanges[k,i];

subject to PairedExchange1 {i in DONORS, j in PATIENTS}:
	pair_exchanges[i,j] <= exchanges[i,j];

subject to PairedExchange2 {(i,j,k,l) in VALID_CYCLES}:
	pair_exchanges[i,j] + pair_exchanges[j,k] + pair_exchanges[k,l] <= 2;