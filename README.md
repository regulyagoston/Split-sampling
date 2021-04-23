# Split-sampling
This repository contains split sampling techniques for modelling with discretised continuous variables.

When a modeller uses a variable which is originally a continuous variable, but observed as an interval data (or through a ordered choice window), classical econometric tools does not work. In Chan-Matyas-Reguly (2020) and (2021), we propose methods to handle such variables, when it is on the right hand side (RHS - explanatory variable) or on the left hand side (LHS - dependent variable).

*Example:* Income is the continuous variable, but it is asked through a survey. Typically in a survey not the exact amount is asked (would yieald really low response rate), but given income categories (e.g. Choose from one of the following: '10,000-30,000$', '30,000-50,000$' or '50,000$ or more'). The modeller would like to understand customer behavior (e.g. willingness to pay for a product given on the income) -- refer to RHS model, or reveal potential income discrimination (e.g. are incomes are different from male and female?).


