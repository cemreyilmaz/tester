#' My Hello World Function
#'
#' @param x  The name of the person to say Hi
#'
#' @return The output from \code{\link{print}}
#' @export
#'
#' @examples
#' hello("Cemre")
hello <- function(x) {
  print(paste0("Hello ", x, ", this is the world!"))
}
