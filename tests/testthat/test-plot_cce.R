testthat::test_that("plot.cce works same as last test", {

  cce<-demcon::get_cce()

  cce<-demcon::prep_cce(cce, evnttype_fix = TRUE)

  rlang::check_installed("vdiffr", reason = "required for test")

  p <- plot(cce, cntry = "France")
  vdiffr::expect_doppelganger("France cce plot", p)


  testthat::expect_silent(plot(cce, cntry = "Mexico", years = c(1950,2021)))
  testthat::expect_silent(plot(cce, cntry = 70, years = c(1950,2021)))


  character<-plot(cce, cntry = "Mexico", years = c(1950,2021))
  numeric<-plot(cce, cntry = 70, years = c(1950,2021))
  testthat::expect_true(compare::compare(character, numeric)$result)


  testthat::expect_error(plot(cce, cntry = 22222))
  testthat::expect_error(plot(cce, cntry = "Canadaa"))


  # detailed_lab
  det_lab<-plot(cce, cntry = "Nepal", years = c(1950,2021), detailed_lab = TRUE)
  reg_lab<-plot(cce, cntry = "Nepal", years = c(1950,2021), detailed_lab = FALSE)
  testthat::expect_false(compare::compare(det_lab, reg_lab)$result)

  #years
  default_years<-plot(cce, cntry = "Albania")
  custom_years<-plot(cce, cntry = "Albania", years = c(1950,2021))
  testthat::expect_false(compare::compare(default_years, custom_years)$result)

  # text adj
  default_adj<-plot(cce, cntry = "Spain")
  custom_adj<-plot(cce, cntry = "Spain", lab_adj = 0.5)
  testthat::expect_false(compare::compare(default_adj, custom_adj)$result)
})
