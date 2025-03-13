library(testthat)
library(hardpackage)
library(data.table)


test_that("merge_three_tables works correctly with basic example", {
  students <- data.table(id = c("A", "B", "C", "D"),
                         Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
  scores <- data.table(id = c("B", "C", "E"),
                       homework = c(87, 94, 92),
                       quiz = c(91, 90, 87))
  grades <- data.table(id = c("B", "C", "E", "F"),
                       final_grade = c("A", "B", "C", "D"))

  merged_data <- merge_three_tables(students, scores, grades, by_xy = "id", by_xyz = "id")

  expect_true(is.data.table(merged_data))
  expect_equal(nrow(merged_data), 6)  # Expected number of rows for full outer join
  expect_equal(ncol(merged_data), 5)  # Expected number of columns
  expect_true("Birthdate" %in% names(merged_data)) #check presence of columns.
  expect_true("final_grade" %in% names(merged_data))
})

test_that("merge_three_tables handles different 'by' columns", {
    students <- data.table(id = c("A", "B", "C", "D"),
                           Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
    scores <- data.table(id = c("B", "C", "E"),
                         homework = c(87, 94, 92),
                         quiz = c(91, 90, 87))
    grades2 <- data.table(student_id = c("B", "C", "E", "F"),  # Different column name
                          final_grade = c("A", "B", "C", "D"))

    expect_error(merge_three_tables(students, scores, grades2, by_xy = "id", by_xyz = "student_id"),
                 "One or more 'by_xyz' columns are not found in the merged xy table and/or z.")
})


test_that("merge_three_tables throws error for missing 'by_xy' columns", {
  students <- data.table(id = c("A", "B", "C", "D"),
                         Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
  scores <- data.table(id = c("B", "C", "E"),
                       homework = c(87, 94, 92),
                       quiz = c(91, 90, 87))
  grades <- data.table(id = c("B", "C", "E", "F"),
                       final_grade = c("A", "B", "C", "D"))

  expect_error(merge_three_tables(students, scores, grades, by_xy = "wrong_id", by_xyz = "id"),
               "One or more 'by_xy' columns are not found in x and/or y.")
})

test_that("merge_three_tables throws error for missing 'by_xyz' columns", {
    students <- data.table(id = c("A", "B", "C", "D"),
                           Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
    scores <- data.table(id = c("B", "C", "E"),
                         homework = c(87, 94, 92),
                         quiz = c(91, 90, 87))
  grades_wrong <- data.table(wrong_id = c("B", "C", "E", "F"),
                             final_grade = c("A","B", "C", "D"))

    expect_error(merge_three_tables(students, scores, grades_wrong, by_xy = "id", by_xyz = "wrong_id"),
                 "One or more 'by_xyz' columns are not found in the merged xy table and/or z.")
})

test_that("merge_three_tables handles data.frame inputs", {
    students_df <- data.frame(id = c("A", "B", "C", "D"),
                             Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
    scores <- data.table(id = c("B", "C", "E"),
                         homework = c(87, 94, 92),
                         quiz = c(91, 90, 87))
    grades <- data.table(id = c("B", "C", "E", "F"),
                         final_grade = c("A", "B", "C", "D"))

    expect_warning(merged_df_dt <- merge_three_tables(students_df, scores, grades, by_xy = "id", by_xyz="id"),
                   "Input 'x' was converted to a data.table.")
    expect_true(is.data.table(merged_df_dt))
})


test_that("add_numbers works correctly", {
  expect_equal(add_numbers(2, 3), 5)
  expect_equal(add_numbers(-1, 1), 0)
  expect_equal(add_numbers(0, 0), 0)
})

