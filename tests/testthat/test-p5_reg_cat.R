testthat::test_that("polity_regime_category input is validated", {

  testthat::expect_error(
    demcon::p5_reg_cat(c(1), c(1, 1))
  )

  # parcom and exrec are switched (parcomp can be 5 at most)
  testthat::expect_error(
    demcon::p5_reg_cat(1, 6),
    "switched"
  )


})

testthat::test_that("polity_regime_category doesn't miss any combinations", {
  exrec <- c(-88, -77, -66, 1, 2, 3, 4, 5, 6, 7, 8)
  parcomp <- c(-88, -77, -66, 0, 1, 2, 3, 4, 5)

  all_combs <- expand.grid(exrec = exrec, parcomp = parcomp)
  # if exrect is special code, parcomp is also special code, so filter out those
  no_sc <- all_combs$exrec > 0 & all_combs$parcomp > 0
  sc <- all_combs$exrec==all_combs$parcomp & all_combs$exrec < 0
  all_combs <- all_combs[no_sc | sc, ]

  out <- demcon::p5_reg_cat(all_combs$exrec, all_combs$parcomp)

  testthat::expect_false("" %in% out)
  testthat::expect_false(NA %in% out)

})
