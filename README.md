# Split sampling

This repository contains replication codes for simulations and empirical results from [Chan, Mátyás, Reguly (2024): Modelling with Sensitive Variables]() and its [online supplement](). 

Codes have been run with MatLab version 2023b on a MacBook with OS Version 14.2.1 and an Apple M1 Max chip. The simulations are parallelized; we used 10 workers. Results may slightly change if different numbers of workers are used due to randomization. One can get rid of parallelization by changing the `parfor` loop to `for` in [codes/@splitsampling/estimate_DOC.m](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/@splitsampling/estimate_DOC.m), line 60. In case of discretization happens with the outcome variable, we have used StataMP 13 and run the referred codes on the same laptop. The codes for the empirical application are shared; however, the data from the Australian Tax Office (ATO) cannot be made public unless one applies to get the data from the ATO.

## About the problem

We deal with econometric models in which the dependent variable, some explanatory variables, or both are observed as censored interval data. This discretization often happens due to confidentiality of `sensitive’ variables like income. Models using these variables cannot point identify regression parameters as the conditional moments are unknown, which led the literature to use interval estimates (see, e.g., Manski and Tamer, 2002). Here, we propose a discretization method through which the regression parameters can be point identified while preserving data confidentiality. We demonstrate the asymptotic properties of the OLS estimator for the parameters in multivariate linear regressions for cross-sectional data. The theoretical findings are supported by Monte Carlo experiments and illustrated with an application to the Australian gender wage gap.

*Example:* In many cases, income data cannot be shared in its original form. Typically, the shared (or surveyed) data contains income categories (e.g., '10,000-30,000$', '30,000-50,000$' or '50,000$ or more'). The modeler would like to understand customer behavior (elasticities); however, due to discretization, the parameters cannot be point identified in general. Using the proposed split sampling, we create multiple discretization schemes for the sensitive or surveyed income variable. Then we use a *synthetic* variable to calculate appropriate conditional expectations that allows to point identify the parameter of interest.

## Replications

To replicate our results, one needs to add to path the folder of [`codes/estimations`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/estimations) and [`codes/@splitsampling`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/@splitsampling). The latter is automatic in MatLab.

- [`codes/simulations/sim_results_RHS.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/sim_results_RHS.m) replicates: Table 1 and Tables A1-A3.
- [`codes/simulations/convergence_RHS.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/convergence_RHS.m) replicates: Table A4.
- [`codes/simulations/sim_results_LHS.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/sim_results_LHS.m) replicates mid-point regressions and shifting for Table 2 and Tables A5-A7.
- [`codes/simulations/convergence_LHS.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/convergence_LHS.m) replicates mid-point regressions and shifting for Tables A8.
- [`codes/simulations/LHS_stata/save_results.do`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/LHS_stata/save_results.do) replicates Set identification, Ordered probit, Ordered logit and Interval regressions for Table 2 and Tables A5-A8 and saves to an excel. One need to change the path in the code. To be able to run the stata script one needs to
  - add [`codes/simulations/LHS_stata/simul_overallLHS.do`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/LHS_stata/simul_overallLHS.do) to path.
  - inport the [STATA Software for Best Linear Prediction with Interval Outcome Data](https://molinari.economics.cornell.edu/programs/Stata_SetBLP.zip) provided and documented by Arie Beresteanu, Francesca Molinari and Darcy Steeg Morris (2010): "Asymptotics for Partially Identified Models in STATA
- [`codes/simulations/sim_results_both.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/sim_results_both.m) replicates Table 3 and Tables A9-A11.
- [`codes/simulations/convergence_both.m`](https://github.com/regulyagoston/Split-sampling/blob/master/Codes/simulations/congergence_both.m) replicates: Table A12.
    
