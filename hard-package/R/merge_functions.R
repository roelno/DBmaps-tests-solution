#' Merge Three Data Tables
#'
#' This function takes three data tables (or data frames) and performs two
#' sequential merge operations.
#'
#' @param x The first data table.
#' @param y The second data table.
#' @param z The third data table.
#' @param by_xy A character vector specifying the column(s) to use for merging
#'   `x` and `y`.
#' @param by_xyz A character vector specifying the column(s) to use for merging
#'   the result of `(x, y)` with `z`.
#' @param all_xy A logical value indicating whether to perform a full outer join
#'   for the first merge (x and y).  Defaults to TRUE.
#' @param all_xyz A logical value indicating whether to perform a full outer
#'   join for the second merge (xy_merged and z). Defaults to TRUE.
#'
#' @return A merged data table resulting from the two merge operations.
#'
#' @examples
#' # Create sample data tables
#' students <- data.table::data.table(id = c("A", "B", "C", "D"),
#'                        Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
#' scores <- data.table::data.table(id = c("B", "C", "E"),
#'                      homework = c(87, 94, 92),
#'                      quiz = c(91, 90, 87))
#' grades <- data.table::data.table(id = c("B", "C", "E", "F"),
#'                      final_grade = c("A", "B", "C", "D"))
#'
#' # Perform the merge
#' merged_data <- merge_three_tables(students, scores, grades, by_xy = "id", by_xyz = "id")
#' print(merged_data)
#'
#' # Example with different join types
#' merged_data_inner <- merge_three_tables(students, scores, grades,
#'                                        by_xy = "id", by_xyz = "id",
#'                                        all_xy = FALSE, all_xyz = FALSE)
#' print(merged_data_inner)
#'
#' @import data.table
#' @export
merge_three_tables <- function(x, y, z, by_xy, by_xyz, all_xy = TRUE, all_xyz = TRUE) {
    # --- Input Type Conversion and Checking ---
    if (!data.table::is.data.table(x)) {
        x <- data.table::as.data.table(x)
        warning("Input 'x' was converted to a data.table.")
    }
    if (!data.table::is.data.table(y)) {
        y <- data.table::as.data.table(y)
        warning("Input 'y' was converted to a data.table.")
    }
    if (!data.table::is.data.table(z)) {
        z <- data.table::as.data.table(z)
        warning("Input 'z' was converted to a data.table.")
    }

    # --- Check 'by_xy' columns ---
    if (!all(by_xy %in% names(x)) || !all(by_xy %in% names(y))) {
        stop("One or more 'by_xy' columns are not found in x and/or y.")
    }

    # --- First Merge (x and y) ---
    xy_merged <- merge(x, y, by = by_xy, all = all_xy)

    # --- Check 'by_xyz' columns AFTER the first merge ---
    if (!all(by_xyz %in% names(xy_merged)) || !all(by_xyz %in% names(z))) {
        stop("One or more 'by_xyz' columns are not found in the merged xy table and/or z.")
    }


    # --- Second Merge (xy_merged and z) ---
    xyz_merged <- merge(xy_merged, z, by = by_xyz, all = all_xyz)

    return(xyz_merged)
}


#' Calculate the sum of two numbers
#'
#' @param a first number
#' @param b second number
#'
#' @return The sum of a and b
#' @export
#'
#' @examples
#' add_numbers(5, 3) # Returns 8
add_numbers <- function(a, b) {
  return(a + b)
}
