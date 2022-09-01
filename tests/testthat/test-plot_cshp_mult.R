testthat::test_that("plot.chsp_mult produces same plot", {
  testthat::skip_on_ci()
  rlang::check_installed("vdiffr", reason = "required for test")

  dates = c(
    as.Date("1989-1-1"),
    as.Date("1992-5-1"),
    as.Date("1993-5-1"),
    as.Date("2006-7-1"),
    as.Date("2008-3-1")
  )
  cow_codes = list(345,
                   c(344, 346, 349),
                   343,
                   341,
                   347)

  bb<-c(xmin=13,ymin=40,xmax=24,ymax=47)

  balkans <-
    demcon::cshp_mult(
      dates = dates,
      cowcodes = cow_codes,
      bb = bb,
      jitter_labs = FALSE
    )

  vdiffr::expect_doppelganger("Blakans secession plot", plot(balkans))

  # test another to be safe

  dates = c(
    as.Date("1946-10-01"),
    as.Date("1967-12-1"),
    as.Date("1990-6-1")
  )

  cow_codes = c(list(c(678)),
                list(c(680)),
                list(c(679)))

  bb<-c(xmin=40,ymin=9,xmax=55,ymax=22)

  yemens <-
    demcon::cshp_mult(
      dates = dates,
      cowcodes = cow_codes,
      bb = bb,
      jitter_labs = FALSE
    )

  vdiffr::expect_doppelganger("Yemens secession plot", plot(yemens))

})
