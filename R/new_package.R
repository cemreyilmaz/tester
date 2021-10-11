# creting a package in R - guideline
# ---------------------------------------------------------------------------- #
# required packages
install.packages(c("available",
                   "devtools",
                   "roxygen2",
                   "usethis",
                   "testthat",
                   "knitr",
                   "rmarkdown"))
# check if everything is ready to develop a package
devtools::has_devel()
# ---------------------------------------------------------------------------- #
# check if the name you've chosen is available
available::available("mypackage")
# ---------------------------------------------------------------------------- #
#' open a new project
#' File --> New Project --> New Directory --> R Package
#' Customize DESCRIPTION
#' Create your first functions
#' Build --> Configure Build Tools
#'     Check "Generate documentation with Roxygen"
#'     "Check Package - R CMD check additional options": --as-cran
# ---------------------------------------------------------------------------- #
# create a readme file
usethis::use_readme_rmd()
# ---------------------------------------------------------------------------- #
# create vignette
usethis::use_vignette("myvignette")
# ---------------------------------------------------------------------------- #
# recreate NAMESPACE to adfd new function (first, delete it)
devtools::document()
# ---------------------------------------------------------------------------- #
# add imported libraries to the DESCRIPTION
usethis::use_package("tidyr", type = "Imports")
usethis::use_package("xlsx", type = "Suggests")
# ---------------------------------------------------------------------------- #
# set up github repo
# if this is first time, download git <http://git-scm.com/download/win>
usethis::use_github(protocol = "https", private = F)
# ---------------------------------------------------------------------------- #
# check your help in devtools
help(package = "mypackage")
