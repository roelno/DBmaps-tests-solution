# hardpackage

An R package for merging data tables with advanced functionality.

## Installation

You can install the development version of hardpackage from GitHub:

```r
# install.packages("devtools")
devtools::install_github("roelno/DBmaps-tests-solution")
```

## Overview

`hardpackage` provides utilities for merging data tables, with a focus on multi-table merges. The package is built on top of the `data.table` package for high performance data manipulation.

### Main Functions

- `merge_three_tables()`: Merge three data tables with flexible join configurations
- `add_numbers()`: A simple utility function to add two numbers

## Usage Examples

### Basic Table Joins

To demonstrate basic table joins using the standard `merge()` function from `data.table`:

```r
library(data.table)

# Create sample data tables
students <- data.table(id = c("A", "B", "C", "D"), 
                       Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))

scores <- data.table(id = c("B", "C", "E"), 
                     homework = c(87, 94, 92), 
                     quiz = c(91, 90, 87))

# 1. Inner Join - only rows with matching keys in both tables
inner_join <- merge(students, scores, by = "id")
print("Inner Join:")
print(inner_join)
#>    id   Birthdate homework quiz
#> 1:  B 2002-04-28       87   91
#> 2:  C 2002-06-13       94   90

# 2. Left Join - all rows from the left table, matched rows from the right table
left_join <- merge(students, scores, by = "id", all.x = TRUE)
print("Left Join:")
print(left_join)
#>    id   Birthdate homework quiz
#> 1:  A 2001-08-04       NA   NA
#> 2:  B 2002-04-28       87   91
#> 3:  C 2002-06-13       94   90
#> 4:  D 2002-02-09       NA   NA

# 3. Right Join - all rows from the right table, matched rows from the left table
right_join <- merge(students, scores, by = "id", all.y = TRUE)
print("Right Join:")
print(right_join)
#>    id   Birthdate homework quiz
#> 1:  B 2002-04-28       87   91
#> 2:  C 2002-06-13       94   90
#> 3:  E       <NA>       92   87

# 4. Full Join - all rows from both tables
full_join <- merge(students, scores, by = "id", all = TRUE)
print("Full Join:")
print(full_join)
#>    id   Birthdate homework quiz
#> 1:  A 2001-08-04       NA   NA
#> 2:  B 2002-04-28       87   91
#> 3:  C 2002-06-13       94   90
#> 4:  D 2002-02-09       NA   NA
#> 5:  E       <NA>       92   87
```

### Merging Three Tables

The primary function of this package is `merge_three_tables()`, which allows you to merge three data tables with controlled join behavior:

```r
library(hardpackage)

# Create sample data tables
students <- data.table(id = c("A", "B", "C", "D"),
                       Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
scores <- data.table(id = c("B", "C", "E"),
                     homework = c(87, 94, 92),
                     quiz = c(91, 90, 87))
grades <- data.table(id = c("B", "C", "E", "F"),
                     final_grade = c("A", "B", "C", "D"))

# Full outer joins (default behavior)
merged_data <- merge_three_tables(students, scores, grades, by_xy = "id", by_xyz = "id")
print(merged_data)
#>    id   Birthdate homework quiz final_grade
#> 1:  A 2001-08-04       NA   NA        <NA>
#> 2:  B 2002-04-28       87   91           A
#> 3:  C 2002-06-13       94   90           B
#> 4:  D 2002-02-09       NA   NA        <NA>
#> 5:  E       <NA>       92   87           C
#> 6:  F       <NA>       NA   NA           D

# Inner joins
merged_data_inner <- merge_three_tables(students, scores, grades, 
                                       by_xy = "id", by_xyz = "id",
                                       all_xy = FALSE, all_xyz = FALSE)
print(merged_data_inner)
#>    id   Birthdate homework quiz final_grade
#> 1:  B 2002-04-28       87   91           A
#> 2:  C 2002-06-13       94   90           B

# Mixed join types - Left join first, then inner join
merged_data_left <- merge_three_tables(students, scores, grades, 
                                      by_xy = "id", by_xyz = "id",
                                      all_xy = TRUE, all_xyz = FALSE)
print(merged_data_left)
#>    id   Birthdate homework quiz final_grade
#> 1:  B 2002-04-28       87   91           A
#> 2:  C 2002-06-13       94   90           B
```

### Multi-column Joins

You can also perform joins on multiple columns:

```r
# Create sample data tables with multiple join columns
students_multi <- data.table(id = c("A", "B", "C", "D"),
                            section = c(1, 1, 2, 2),
                            Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))
scores_multi <- data.table(id = c("B", "C", "E"),
                          section = c(1, 2, 1),
                          homework = c(87, 94, 92),
                          quiz = c(91, 90, 87))
grades_multi <- data.table(id = c("B", "C", "E", "F"),
                          section = c(1, 2, 1, 3),
                          final_grade = c("A", "B", "C", "D"))

merged_data_multi <- merge_three_tables(students_multi, scores_multi, grades_multi, 
                                       by_xy = c("id", "section"), 
                                       by_xyz = c("id", "section"))
print(merged_data_multi)
```

## Error Handling

The function includes robust error handling for common issues:

```r
# Error when 'by_xy' columns are not found
tryCatch({
  merged_data_error <- merge_three_tables(students, scores, grades, 
                                         by_xy = "wrong_id", by_xyz = "id")
}, error = function(e) {
  cat("Error:", conditionMessage(e), "\n")
})
# Error: One or more 'by_xy' columns are not found in x and/or y.

# Error when 'by_xyz' columns are not found
grades_wrong <- data.table(wrong_id = c("B", "C", "E", "F"),
                          final_grade = c("A", "B", "C", "D"))
tryCatch({
  merged_data_error <- merge_three_tables(students, scores, grades_wrong, 
                                         by_xy = "id", by_xyz = "wrong_id")
}, error = function(e) {
  cat("Error:", conditionMessage(e), "\n")
})
# Error: One or more 'by_xyz' columns are not found in the merged xy table and/or z.
```

## Input Type Handling

The function automatically converts data frames to data.tables:

```r
# Convert a data.frame to data.table automatically
students_df <- data.frame(id = c("A", "B", "C", "D"),
                         Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))

merged_df_dt <- merge_three_tables(students_df, scores, grades, by_xy = "id", by_xyz = "id")
# Warning: Input 'x' was converted to a data.table.
```

## License

MIT
