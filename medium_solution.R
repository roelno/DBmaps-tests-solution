library(data.table)

merge_three_tables <- function(x, y, z, by_xy, by_xyz, all_xy = TRUE, all_xyz = TRUE) {
  # --- Input Type Conversion and Checking ---
  if (!is.data.table(x)) {
    x <- as.data.table(x)
    warning("Input 'x' was converted to a data.table.")
  }
  if (!is.data.table(y)) {
    y <- as.data.table(y)
    warning("Input 'y' was converted to a data.table.")
  }
  if (!is.data.table(z)) {
    z <- as.data.table(z)
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


# --- Example Usage (with various scenarios) ---

# 1. Original Scenario
students <- data.table(id = c("A", "B", "C", "D"),
                       Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
scores <- data.table(id = c("B", "C", "E"),
                     homework = c(87, 94, 92),
                     quiz = c(91, 90, 87))
grades <- data.table(id = c("B", "C", "E", "F"),  # Now 'id' is consistent
                     final_grade = c("A", "B", "C", "D"))

merged_data <- merge_three_tables(students, scores, grades, by_xy = "id", by_xyz = "id")
print("Scenario 1 (Corrected):")
print(merged_data)


# 2. Different 'by' columns in the second merge
grades2 <- data.table(student_id = c("B", "C", "E", "F"),  # Different column name
                      final_grade = c("A", "B", "C", "D"))

merged_data2 <- merge_three_tables(students, scores, grades2, by_xy = "id", by_xyz = "student_id")
print("\nScenario 2 (Different 'by_xyz'):")
print(merged_data2)

#3.  Error Handling (by_xyz not present in merged table)

grades_wrong <- data.table(wrong_id = c("B", "C", "E", "F"),
                           final_grade = c("A","B", "C", "D"))

print("\nScenario 3 (Error Handling - by_xyz):")
tryCatch({
  merged_data_error <- merge_three_tables(students, scores, grades_wrong, by_xy = "id", by_xyz = "wrong_id")
}, error = function(e) {
  cat("Error:", conditionMessage(e), "\n")
})

#4.  Different join types (all_xy, all_xyz)

merged_data_inner <- merge_three_tables(students, scores, grades, by_xy="id", by_xyz = "id", all_xy=FALSE, all_xyz = FALSE) #Inner Join
print("\nScenario 4 (Inner Joins):")
print(merged_data_inner)

merged_data_left <- merge_three_tables(students, scores, grades, by_xy="id", by_xyz="id", all_xy = TRUE, all_xyz = FALSE) #Left join for the first, inner for the second
print("\nScenario 5 (Left and Inner Join):")
print(merged_data_left)

#5. Multiple Join Columns
students_multi <- data.table(id = c("A", "B", "C", "D"),
                             section = c(1,1,2,2),
                             Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
scores_multi <- data.table(id = c("B", "C", "E"),
                           section = c(1,2,1),
                           homework = c(87, 94, 92),
                           quiz = c(91, 90, 87))
grades_multi <- data.table(id = c("B", "C", "E", "F"),
                           section = c(1,2,1,3),
                           final_grade = c("A", "B", "C", "D"))

merged_data_multi <- merge_three_tables(students_multi, scores_multi, grades_multi, by_xy=c("id", "section"), by_xyz = c("id", "section"))
print("\nScenario 6 (Multiple Join Columns):")
print(merged_data_multi)

#6.  by_xy column not present
print("\nScenario 7 (Error Handling - by_xy):")
tryCatch({
  merged_data_error2 <- merge_three_tables(students, scores, grades, by_xy = "wrong_id", by_xyz = "id")
}, error = function(e) {
  cat("Error:", conditionMessage(e), "\n")
})

#7.  by_xyz not present in Z
grades_wrong2 <- data.table(wrong_id = c("B", "C", "E", "F"),
                            final_grade = c("A","B", "C", "D"))
print("\nScenario 8 (Error Handling - by_xyz in z):")
tryCatch({
  merged_data_error3 <- merge_three_tables(students, scores, grades_wrong2, by_xy = "id", by_xyz = c("id", "wrong_id"))
}, error = function(e) {
  cat("Error:", conditionMessage(e), "\n")
})