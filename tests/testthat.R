# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/tests.html
# * https://testthat.r-lib.org/reference/test_package.html#special-files

library(withr)
library(testthat)
library(Pedixplorer)
library(vdiffr)
library(shinytest2)

withr::local_options(width = 150)
Sys.setenv("R_TESTS" = "")
test_check("Pedixplorer")
TRUE
