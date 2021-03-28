# ---------------------------------------------------------------------------- #
# fars functions
# ---------------------------------------------------------------------------- #
#' Reads .csv file as table
#'
#' This is a simple function to read a csv file. First, it checks if the given
#' filename exists. If it exists, it reads it. Then it converts the resulting
#' data frame to table.
#'
#' @note If the file for the given year does not exist, it turns
#' into a warning.
#'
#' @import readr dplyr
#'
#' @param filename A character string giving the file name to be read
#'
#' @return This function returns to a table frame including the info from the
#' given filename.
#'
#' @examples
#' \dontrun{
#' tbl_data <- fars_read('accident_2013.csv.bz2')
#'}
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}
#' Create a string for the file name from year
#'
#' This function creates the file name as string with a format of .csv.bz2. The
#' file name is defined as e.g. accident_2020.csv.bz2.
#'
#' @param year The numeric input for year
#'
#' @return A character string of file name
#'
#' @examples
#' \dontrun{
#' make_filename(2013)
#'}
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}
#' Extract month list for the selected years from data
#'
#' This function creates a character string of the file name for the given year
#' with \link{make_filename}. Then, it reads that file with \link{fars_read}. It
#' adds the year as and additional field to the table frame. Finally it selects
#' month and year from data. This function can handle this process with multiple
#' inputs.
#'
#' @note Also, it turns into a warning message if any error occurs. It means
#' the given year is not valid.
#'
#' @import dplyr
#'
#' @param years The numeric array for years
#'
#' @return The table frame including months for the given years from the data
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013:2015)
#'}
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}
#' Summarizes the given year
#'
#' This function selects the monthly data for the selected years with
#' \link{fars_read_years} and groups the data by year and month. Then, it
#' summarize data and spread the year.
#'
#' @import dplyr tidyr
#'
#' @param years The numeric array for years
#'
#' @return The summary of data of month for the given years
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013:2015)
#'}
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}
#' Visualizes the data of the given state and year
#'
#' This function defines the file name with \link{make_filename}, and reads it
#' with \link{fars_read}. Then, extract the rows when the state label is the
#' given state number. It removes the data for the longitude more than 900 and
#' the latitude more than 90 since they would be false data. Finally it visualize
#' data on a plot.
#'
#' @note It runs into a warning if there is no data for the defined
#'
#' @import dplyr maps graphics
#'
#' @param state.num  The numeric input for state number to filter data
#' @param year       The numeric input for year
#'
#' @return           The plot of the filtered data
#'
#' @examples
#' \dontrun{
#' fars_map_state(1,2013)
#'}
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
