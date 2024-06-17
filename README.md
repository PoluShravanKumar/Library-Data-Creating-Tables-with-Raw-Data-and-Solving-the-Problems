# Library-Data-Creating-Tables-with-Raw-Data-and-Solving-the-Problems

1. Database Creation and Table Definitions.
 Your table creation statements are almost correct but have minor issues that need addressing:
2. Table Naming Conventions:
- It's common practice to use lowercase letters and underscores to separate words in table names, e.g., publisher, borrower, library_branch.
3. Data Types and Constraints:
- Use INT instead of TINYINT for primary keys if you expect the number of records to exceed 255.
- Ensure all foreign keys have corresponding primary key references.
4. Consistency in Foreign Key References:
- Make sure that the referenced tables and columns exist before creating foreign keys.
5. Auto-Increment Fields:
- AUTO_INCREMENT is suitable for primary keys but ensure they are of type INT or BIGINT.
