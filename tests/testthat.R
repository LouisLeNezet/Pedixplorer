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
library(R.devices)
library(shiny)

all_dev <- dev.list()
for (devi in all_dev) {
    dev.off(devi)
}

par_lst <- list(
    "pin" = c(8, 8), "cex" = 1, "mai" = c(1, 1, 1, 1),
    "fin" = c(6, 6), "bg" = "white", "family" = "HersheySans",
    "usr" = c(0, 1, 0, 1), xaxp = c(0, 1, 5), yaxp = c(0, 1, 5),
    "fig" = c(0, 1, 0, 1), "mar" = c(1, 1, 1, 1), xpd = TRUE
)
R.devices::devNew("pdf",  width = 10, height = 10, par = par_lst)
plot.new()

withr::local_options(width = 150, digits = 8, browser = "mozilla")
withr::local_options(width = 150, digits = 8, browser = "google-chrome")
options(shiny.testmode = TRUE)
Sys.setenv("R_TESTS" = "")
test_check("Pedixplorer")
TRUE

dev.off()
