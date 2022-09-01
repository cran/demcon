testthat::test_that("chsp_mult creates proper list", {
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

# the length of return list equals the length of dates
testthat::expect_length(balkans,length(dates))

# names of list elements equal the dates
testthat::expect_true(all(names(balkans)==dates))

# each element of cshp_mult list is ggplot device
testthat::expect_true(all(sapply(balkans,class)[2,]=="ggplot"))

# return object is of custom class `cshp_mult`
testthat::expect_s3_class(balkans, "cshp_mult")

})
