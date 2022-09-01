#' Plot A cshapes Multiple
#'
#' @param x A list of class `chsp_mult` with multiple cshapes
#'   [ggplot2::ggplot()] devices produced by [demcon::cshp_mult()].
#' @param y ignored.
#' @param ... Additional arguments to be passed to the plotting device.
#'
#' @return A single [ggplot2::ggplot()] device.
#' @method plot cshp_mult
#' @export
#'
#' @examples
#' \donttest{
#' if(requireNamespace("cshapes")){
#' dates = c(
#' as.Date("1989-1-1"),
#' as.Date("1992-5-1"),
#' as.Date("1993-5-1"),
#' as.Date("2006-7-1"),
#' as.Date("2008-3-1"))
#'
#' cow_codes = list(345,
#'                  c(344, 346, 349),
#'                  343,
#'                  341,
#'                  347)
#'
#' bb<-c(xmin=13,ymin=40,xmax=24,ymax=47)
#'
#' balkans<-cshp_mult(dates = dates, cowcodes = cow_codes,
#'                    bb = bb,jitter_labs = FALSE)
#'
#' plot(balkans)
#' }}
plot.cshp_mult<-function(x, y, ...){

  rlang::check_installed(c("ggplot2"), "required for plotting function")

  stopifnot("Object x must be of class 'cshp_mult'."="cshp_mult" %in% class(x))

  mult_n<-length(x)

if (mult_n == 2) {

  chsp_mult_plot<-
  ggplot2::ggplot() +
    ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 3),
                         expand = FALSE) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[1]]),
                          xmin = 0, xmax = 3,
                          ymin = 0, ymax = 3) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[2]]),
                          xmin = 3, xmax = 6,
                          ymin = 0, ymax = 3) +
    ggplot2::theme_void()}

if (mult_n == 3) {

  chsp_mult_plot<-
  ggplot2::ggplot() +
    ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 6),
                         expand = FALSE) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[1]]),
                          xmin = 1.25, xmax = 4.75,
                          ymin = 2.75, ymax = 6) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[2]]),
                          xmin = 0, xmax = 3,
                          ymin = 0, ymax = 3) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[3]]),
                          xmin = 3, xmax = 6,
                          ymin = 0, ymax = 3) +
    ggplot2::theme_void()}


if (mult_n == 4) {

  chsp_mult_plot<-
  ggplot2::ggplot() +
    ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 6),
                         expand = FALSE) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[1]]),
                          xmin = 0, xmax = 3,
                          ymin = 2.75, ymax = 6) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[2]]),
                          xmin = 3, xmax = 6,
                          ymin = 2.75, ymax = 6) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[3]]),
                          xmin = 0, xmax = 3,
                          ymin = 0, ymax = 3) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[4]]),
                          xmin = 3, xmax = 6,
                          ymin = 0, ymax = 3) +
    ggplot2::theme_void()}

if(mult_n==5){

  chsp_mult_plot<-
  ggplot2::ggplot() +
    ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 9),
                         expand = FALSE) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[1]]),
                          xmin = 1.25, xmax = 4.75,
                          ymin = 5.75, ymax = 9) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[2]]),
                          xmin = 0, xmax = 3,
                          ymin = 2.75, ymax = 6) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[3]]),
                          xmin = 3, xmax = 6,
                          ymin = 2.75, ymax = 6) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[4]]),
                          xmin = 0, xmax = 3,
                          ymin = 0, ymax = 3) +
    ggplot2::annotation_custom(
      ggplot2::ggplotGrob(x[[5]]),
                          xmin = 3, xmax = 6,
                          ymin = 0, ymax = 3)+
    ggplot2::theme_void()
}

  if(mult_n==6){

    chsp_mult_plot<-
    ggplot2::ggplot() +
      ggplot2::coord_equal(xlim = c(0, 6), ylim = c(0, 9),
                           expand = FALSE) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[1]]),
        xmin = 0, xmax = 3,
        ymin = 5.75, ymax = 9) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[2]]),
        xmin = 3, xmax = 6,
        ymin = 5.75, ymax = 9) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[3]]),
        xmin = 0, xmax = 3,
        ymin = 2.75, ymax = 6) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[4]]),
        xmin = 3, xmax = 6,
        ymin = 2.75, ymax = 6) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[5]]),
        xmin = 0, xmax = 3,
        ymin = 0, ymax = 3) +
      ggplot2::annotation_custom(
        ggplot2::ggplotGrob(x[[6]]),
        xmin = 3, xmax = 6,
        ymin = 0, ymax = 3)+
      ggplot2::theme_void()
  }

  suppressWarnings(chsp_mult_plot)

}
