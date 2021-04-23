# Split-sampling
This repository contains split sampling techniques such as magnifying or shifting methods for modelling with discretised continuous variables.  

When a modeller uses a variable which is originally a continuous variable, but observed as an interval data (through a ordered choice window), classical econometric tools does not work. In Chan-Matyas-Reguly (2020) and (2021), we propose methods to handle such variables, when it is on the right hand side (RHS - explanatory variable, see: *[Chan-Matyas-Reguly (2020): Modelling with Discretized Ordered Choice Covariate](https://github.com/regulyagoston/Split-sampling/blob/master/Modelling_with_DOC_covariates.pdf)* ) or on the left hand side (LHS - dependent variable, see: *[Chan-Matyas-Reguly (2021): Modelling with Discretized Continuous Dependent Variable](https://github.com/regulyagoston/Split-sampling/blob/master/Modelling_with_DOC_Dependent_Variable.pdf)*).

*Example:* Income is the continuous variable, but it is asked through a survey. Typically in a survey not the exact amount is asked (would yieald really low response rate), but given income categories (e.g. Choose from one of the following: '10,000-30,000$', '30,000-50,000$' or '50,000$ or more'). The modeller would like to understand customer behavior (e.g. willingness to pay for a product given on the income) -- refer to RHS model, or reveal potential income discrimination (e.g. are incomes are different from male and female?).

## About the problem
In case of a variable is continuous but cannot be observed directly only through intervals or 'discretized  ordered  choice  windows', Manski  and  Tamer  (2002) show  that  the  parameters  in  the  conditional  expectation  cannot  be  point-identified in general. This is due to the information loss in the method as the data is collected.  *Split sampling* is a new sampling design, which makes the point-identification of the parameters in regression models feasible, through the way information is collected. 








