** This script replicates the results in 
* Chan-Matyas-Reguly (2021): Modelling with Discretized Ordered Choice Models
*
* The script only reproduces results for the following models:
* 	- Ordered probit (oprobit)
*   - Ordered logit  (ologit)
*   - Interval regression (intreg)
*	- Set identification (manski) 
*			- !!! TO BE ABLE TO RUN THIS MAKE SURE YOU DOWNLOADED AND ATTACHED THE PACKAGE !!! from: https://molinari.economics.cornell.edu/programs.html

*
* The script saves the results into an excel file:
* Make sure you have 'results.xls' file in the folder
local path = "/Stata/results"

* Table 1
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 10000
		if ("`k'" == "manski"){
			putexcel set `path' , sheet("Base") modify
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
			putexcel set `path' , sheet("Base") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}


* Table 1 from Online Appendix
* N = 1,000
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 1000
		if ("`k'" == "manski"){
			putexcel set `path' , sheet("N1000") modify
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
			putexcel set `path' , sheet("N1000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

* Table 2 from Online Appendix
** Symmetric case
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "symmetric" 10000
		if ("`k'" == "manski"){
			putexcel set `path' , sheet("symmetric") modify
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
			putexcel set `path' , sheet("symmetric") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

* Table 3 from Online Appendix
** M=3
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" "uniform" "exponential-05" "weibull-115" "std-logistic" "std-lognormal" {
		do simul_overallLHS.do "`i'" "`k'" "M=3" "asymmetric" 10000
		if ("`k'" == "manski"){
			putexcel set `path' , sheet("M3") modify
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
			putexcel set `path' , sheet("M3") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}

* Remaining estimation for Table 4 in Online Appendix
** N=10,000
clear
local j = 1
foreach k in "oprobit" "ologit" "intreg" "manski" {
	foreach i in "std-normal" {
		do simul_overallLHS.do "`i'" "`k'" "M=5" "asymmetric" 100000
		if ("`k'" == "manski"){
			putexcel set `path' , sheet("N100000") modify
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
			putexcel set `path' , sheet("N100000") modify
			putexcel A`j' = ( "`i'" + " with " + "`k'" )
			putexcel B`j' = (r(mean)) C`j' = (r(sd))
		}
		local ++j
	}
}
