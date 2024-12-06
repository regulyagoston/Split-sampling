** Baseline
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 10000
		if ("`k'" == "manski"){
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("Base") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			quietly summarize( aY_l )
			putexcel B`j' = (r(mean))
			putexcel C`j' = (r(sd))
			quietly summarize( aY_u )
			putexcel D`j' = (r(mean))
			putexcel E`j' = (r(sd))
		}
		else{
			quietly summarize( aY )
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("Base") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

** N=1000
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 1000
		if ("`k'" == "manski"){
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_vlhs" , sheet("N1000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			quietly summarize( aY_l )
			putexcel B`j' = (r(mean))
			putexcel C`j' = (r(sd))
			quietly summarize( aY_u )
			putexcel D`j' = (r(mean))
			putexcel E`j' = (r(sd))
		}
		else{
			quietly summarize( aY )
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("N1000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

** symmetric
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "symmetric" 10000
		if ("`k'" == "manski"){
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("symmetric") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			quietly summarize( aY_l )
			putexcel B`j' = (r(mean))
			putexcel C`j' = (r(sd))
			quietly summarize( aY_u )
			putexcel D`j' = (r(mean))
			putexcel E`j' = (r(sd))
		}
		else{
			quietly summarize( aY )
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("symmetric") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

** M=3
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=3" "asymmetric" 10000
		if ("`k'" == "manski"){
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("M3") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			quietly summarize( aY_l )
			putexcel B`j' = (r(mean))
			putexcel C`j' = (r(sd))
			quietly summarize( aY_u )
			putexcel D`j' = (r(mean))
			putexcel E`j' = (r(sd))
		}
		else{
			quietly summarize( aY )
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("M3") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

** N10000
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 100000
		if ("`k'" == "manski"){
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("N100000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			quietly summarize( aY_l )
			putexcel B`j' = (r(mean))
			putexcel C`j' = (r(sd))
			quietly summarize( aY_u )
			putexcel D`j' = (r(mean))
			putexcel E`j' = (r(sd))
		}
		else{
			quietly summarize( aY )
			putexcel set "/Users/areguly6/Documents/Research/Split_sampling/res_lhs" , sheet("N100000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}
