library(data.table)

students <- data.table(id = c("A", "B", "C", "D"), Birthdate = c("2001-08-04", "2002-04-28", "2002-06-13", "2002-02-09"))

scores <- data.table(id = c("B", "C", "E"), homework = c(87,94,92), quiz = c(91, 90, 87))

# 1. Inner Join
inner_join <- merge(students, scores, by = "id")
print("Inner Join:")
print(inner_join)

# 2. Left Join
left_join <- merge(students, scores, by = "id", all.x = TRUE)
print("\nLeft Join:")
print(left_join)

# 3. Right Join
right_join <- merge(students, scores, by = "id", all.y = TRUE)
print("\nRight Join:")
print(right_join)

# 4. Full Join
full_join <- merge(students, scores, by = "id", all = TRUE)
print("\nFull Join:")
print(full_join)