# PROscorerTools 0.0.4 (2023-10-17)

* Omitted some overzealous warnings for some of the functions (e.g., `rerange`)

* Tiny change to package overview documentation to align with CRAN policy. 

* Changed lists in package overview documentation to markdown format to fix CRAN note.


# PROscorerTools 0.0.2 (2022-03-07)

* Updates to fix CRAN check errors downstream in `PROscorer` package. 
  * `get_dfItemsrev`: edited to (hopefully) avoid CRAN check
  failure `length > 1 in coercion to logical`.
  * `scoreScale`: The argument-processing logic regarding whether to call
  `chkstop_revitems` was similarly revised to avoid the same CRAN check error.

* GitHub Actions added to automate package checks and coverage.

# PROscorerTools 0.0.1

* Initial release of package on CRAN.  
