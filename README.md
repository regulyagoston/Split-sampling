# Split sampling

This repository contains replication codes for simulations and empirical results from [Chan, Mátyás, Reguly (2024): Modelling with Discretized Variables](). 

Codes have been run with MatLab version 2023b on a MacBook with OS Version 14.2.1 and an Apple M1 Max chip. The simulations are parallelized; we used 10 workers. Results may slightly change if different numbers of workers are used due to randomization. One can get rid of parallelization by changing the `parfor` loop to `for` in [codes/@splitsampling/estimate_DOC.m](codes/@splitsampling/estimate_DOC.m), line 60. The codes for the empirical application are shared; however, the data from the Australian Tax Office (ATO) cannot be made public unless one applies to get the data from the ATO.

## About the problem

We deal with econometric models in which the dependent variable, some explanatory variables, or both are observed as censored interval data. This discretization often happens due to confidentiality of `sensitive’ variables like income. Models using these variables cannot point identify regression parameters as the conditional moments are unknown, which led the literature to use interval estimates (see, e.g., Manski and Tamer, 2002). Here, we propose a discretization method through which the regression parameters can be point identified while preserving data confidentiality. We demonstrate the asymptotic properties of the OLS estimator for the parameters in multivariate linear regressions for cross-sectional data. The theoretical findings are supported by Monte Carlo experiments and illustrated with an application to the Australian gender wage gap.

*Example:* In many cases, income data cannot be shared in its original form. Typically, the shared (or surveyed) data contains income categories (e.g., '10,000-30,000$', '30,000-50,000$' or '50,000$ or more'). The modeler would like to understand customer behavior (elasticities); however, due to discretization, the parameters cannot be point identified in general. Using the proposed split sampling, we create multiple discretization schemes for the sensitive or surveyed income variable. Then we use a *synthetic* variable to calculate appropriate conditional expectations that allows to point identify the parameter of interest.
