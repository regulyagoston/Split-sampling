** SIMULATION WITH ORDERED PROBIT MODEL

** Set the simulation file

program simul_LHS, rclass
	
	version 13 
	drop _all
	
	
	assert inlist("`1'","std-normal","normal-1-2","uniform","exponential-05","weibull-115","std-logistic","std-lognormal")
	assert inlist("`2'","oprobit","ologit","intreg","manski")
	assert inlist("`3'","M=3","M=5","M=7","M=10")
	assert inlist("`4'","symmetric","asymmetric")
	
	set obs `5'

	* Lower and upper bounds with regressor
	if ("`4'" == "symmetric"){
		* Lower and upper bounds 
		local a_l = -3
		local a_u =  3
		local eps_l = -2
		}
	else if ("`4'" == "asymmetric"){
		local a_l = -2
		local a_u = 4
		local eps_l = -1
		}
	* Generate X ~ tN(0,0.25,-1,1)
	gen x = .
	local N 0
	while `N' < `5' {
		cap drop z rho_z u
		gen z = 2*runiform()-1
		gen rho_z = 1/(0.5*sqrt(2*_pi))*exp(-0.5*(z/0.5)^2)
		gen u = runiform()
		quietly replace x = z if u <= rho_z & mi(x)
		qui cou if !mi(x)
		local N = r(N)
		}
	generate X = x
	drop z rho_z u x
	
	
	*********
	** Creating noise
	if ("`1'" == "std-normal" ){
		gen x = .
		local N 0
		while `N' < `5' {
			cap drop z rho_z u
			gen z = 4 * runiform() + `eps_l'
			gen rho_z = 1/sqrt(2*_pi)*exp(-0.5*z^2)
			gen u = runiform()
			quietly replace x = z if u <= rho_z & mi(x)
			qui cou if !mi(x)
			local N = r(N)
		}
		generate eps = x
		drop z rho_z u x
		}
	else if  ( "`1'" == "uniform" ) {
		generate eps = 4 * runiform() + `eps_l' 
	}
	else if ( "`1'" == "exponential-05" ){
		gen x = .
		local N 0
		while `N' < `5' {
			cap drop z rho_z u
			gen z = 4 * runiform()
			gen rho_z = 0.5 * exp( -z * 0.5 )
			gen u = runiform()
			quietly replace x = z if u <= rho_z & mi(x)
			qui cou if !mi(x)
			local N = r(N)
		}
		generate eps = x + `eps_l' 
		drop z rho_z u x
	}
	else if ( "`1'" == "weibull-115" ){
		gen x = .
		local N 0
		while `N' < `5' {
			cap drop z rho_z u
			gen z = 4*runiform()
			gen rho_z = 1.5*z^0.5*exp(-z^1.5)
			gen u = runiform()
			quietly replace x = z if u <= rho_z & mi(x)
			qui cou if !mi(x)
			local N = r(N)
		}
		generate eps = x + `eps_l'
		drop z rho_z u x
	}
	else if ( "`1'" == "std-logistic" ){
		gen x = .
		local N 0
		while `N' < `5' {
			cap drop z rho_z u
			gen z = 4*runiform()-1
			gen rho_z = exp(-z)/(1+exp(-z))^2
			gen u = runiform()
			quietly replace x = z if u <= rho_z & mi(x)
			qui cou if !mi(x)
			local N = r(N)
		}
		generate eps = x
		drop z rho_z u x
	}
	
	else if ( "`1'" == "std-lognormal" ){
		gen x = .
		local N 0
		while `N' < `5' {
			cap drop z rho_z u
			gen z = 4*runiform()
			gen rho_z = 1/(z*sqrt(2*_pi))*exp(-log(z)^2/2)
			gen u = runiform()
			quietly replace x = z if u <= rho_z & mi(x)
			qui cou if !mi(x)
			local N = r(N)
		}
		generate eps = x + `eps_l' 
		drop z rho_z u x
	}
	
	** Generating the unknown DGP	
	gen Y = 0.5*X + eps
	
	** Discretization
	if ("`3'" == "M=3"){
		local cm = (`a_u'-`a_l')/3
	}
	else if ("`3'" == "M=5"){
		local cm = (`a_u'-`a_l')/5
	}
	else if ("`3'" == "M=7"){
		local cm = (`a_u'-`a_l')/7
	}
	else if ("`3'" == "M=10"){
		local cm = (`a_u'-`a_l')/10
	}
	* create lower upper mid values and factors
	egen Yl = cut( Y ), at (`a_l'(`cm')`a_u')
	gen Yu = Yl + `cm'
	gen Ym = Yl + `cm'/2
	egen Yf = cut( Y ), at (`a_l'(`cm')`a_u') icodes

	** Estimation
	if ( "`2'" == "oprobit" ){
		oprobit Yf X
		margins, dydx(*) atmeans
		*return scalar conv = e(converged)
	}
	else if ( "`2'" == "ologit" ){
		ologit Yf X
		*return scalar conv = e(converged)
	}
	else if ( "`2'" == "intreg" ){
		intreg Yl Yu X
	}
	else if ( "`2'" == "manski" ){
		oneDproj Yl Yu X
	}
end


** Actual MC simulation
set seed 1234
if ( "`2'" == "manski" ){
	simulate lb=e(lb_1) ub=e(ub_1), reps(100): simul_LHS `1' `2' `3' `4' `5'
}
else {
	simulate _b _se conv=r(conv), reps(100): simul_LHS `1' `2' `3' `4' `5'
}

* get the bias of the beta parameter
if ( "`2'" == "manski" ){
	gen aY_l = ( lb - 0.5)
	gen aY_u = ( ub - 0.5)
}
else if ( "`2'" == "intreg" ){
	gen aY = ( model_b_X - 0.5)
}
else if ( "`2'" == "oprobit" | "`2'" == "ologit" ){
	gen aY = ( Yf_b_X - 0.5)
}
display ( "Simulation with " + "`1'" + " with model " + "`2'" + " with tuncation " + "`4'" + " with dicretization " + "`3'" )
display ( "Naive estimator's distortion" )
if ( "`2'" == "manski" ){
	summarize( aY_l )
	summarize( aY_u )
}
else {
	summarize( aY )
}

program drop simul_LHS


