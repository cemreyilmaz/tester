#' My Printer Function
#'
#' @param r
#' @param x
#' @param y
#'
#' @return The output from \code{\link{print}} to print the value of X
#' @export
#'
#' @examples
#' printer(1, "Cemre", "Yilmaz")
printer <- function(r, x, y){
  print(paste0('x = ', x))
}
