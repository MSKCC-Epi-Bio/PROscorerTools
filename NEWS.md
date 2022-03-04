# PROscorerTools 0.0.2 (2022-03-04)

* Updates to fix CRAN check errors downstream in `PROscorer` package. 
  * `get_dfItemsrev`: edited to (hopefully) avoid CRAN check
  failure `length > 1 in coercion to logical`.
  * `scoreScale`: The argument-processing logic regarding whether to call
  `chkstop_revitems` was similarly revised to avoid the same CRAN check error.

* GitHub Actions added to automate package checks and coverage.

# PROscorerTools 0.0.1

* Initial release of package on CRAN.  
