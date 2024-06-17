CREATE DATABASE IF NOT EXISTS library;
USE library;

-- Table 1
CREATE TABLE borrower (
    borrower_CardNo INT PRIMARY KEY AUTO_INCREMENT,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress VARCHAR(255),
    borrower_BorrowerPhone VARCHAR(255)
);

-- Table 2
CREATE TABLE library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress VARCHAR(255)
);

-- Table 3
CREATE TABLE publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress VARCHAR(255),
    publisher_PublisherPhone VARCHAR(255)
);

-- Table 4
CREATE TABLE books (
    book_BookID INT PRIMARY KEY AUTO_INCREMENT,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName)
        REFERENCES publisher (publisher_PublisherName)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table 5
CREATE TABLE authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    FOREIGN KEY (book_authors_BookID)
        REFERENCES books (book_BookID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_authors_AuthorName VARCHAR(255)
);

-- Table 6
CREATE TABLE book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    FOREIGN KEY (book_copies_BookID)
        REFERENCES books (book_BookID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_copies_BranchID INT,
    FOREIGN KEY (book_copies_BranchID)
        REFERENCES library_branch (library_branch_BranchID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_copies_No_Of_Copies INT
);

-- Table 7
CREATE TABLE book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    FOREIGN KEY (book_loans_BookID)
        REFERENCES books (book_BookID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_loans_BranchID INT,
    FOREIGN KEY (book_loans_BranchID)
        REFERENCES library_branch (library_branch_BranchID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_loans_CardNo INT,
    FOREIGN KEY (book_loans_CardNo)
        REFERENCES borrower (borrower_CardNo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE
);

-- Reading the tables.
SELECT * FROM borrower;
SELECT * FROM library_branch;
SELECT * FROM publisher;
SELECT * FROM books;
SELECT * FROM authors;
SELECT * FROM book_copies;
SELECT * FROM book_loans;

    
-- Reading the tables.
    
SELECT 
    *
FROM
    borrower;
SELECT 
    *
FROM
    library_branch;
SELECT 
    *
FROM
    publisher;
SELECT 
    *
FROM
    books;
SELECT 
    *
FROM
    authors;
SELECT 
    *
FROM
    book_copies;
SELECT 
    *
FROM
    book_loans;

-- updation 

update book_loans set book_loans_DateOut = replace(book_loans_DateOut,"/","-");
update book_loans set book_loans_DateOut = str_to_date(book_loans_DateOut,"%m-%d-%y");

update book_loans set book_loans_DueDate = replace(book_loans_DueDate,"/","-");
update book_loans set book_loans_DueDate = str_to_date(book_loans_DueDate,"%m-%d-%y");

alter table book_loans modify book_loans_DueDate date;
alter table book_loans modify book_loans_DateOut date;
desc book_loans;




-- Queries from here.(questions and answers)
use library;

# 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT 
    book_BookID,
    book_Title,
    library_branch_BranchName,
    book_copies_No_of_Copies
FROM
    books b
        INNER JOIN
    book_copies bc ON b.book_BookID = bc.book_copies_BookID
        INNER JOIN
    library_branch lb ON lb.library_branch_BranchID = bc.book_copies_BranchID
WHERE
    book_Title = 'The Lost Tribe'
        AND library_branch_BranchName = 'Sharpstown';
        
        

# 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    book_BookID,
    book_Title,
    library_branch_BranchName,
    book_copies_No_of_Copies
FROM
    books b
        INNER JOIN
    book_copies bc ON b.book_BookID = bc.book_copies_BookID
        INNER JOIN
    library_branch lb ON lb.library_branch_BranchID = bc.book_copies_BranchID
WHERE
    book_Title = 'The Lost Tribe';

# 3.Retrieve the names of all borrowers who do not have any books checked out.

SELECT 
    *
FROM
    borrower b
WHERE
    borrower_CardNo NOT IN (SELECT 
            book_loans_CardNo
        FROM
            book_loans);

# 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
# retrieve the book title, the borrower's name, and the borrower's address. 
SELECT 
    book_Title,
    borrower_BorrowerName,
    borrower_BorrowerAddress,
    book_loans_DueDate
FROM
    books b
        INNER JOIN
    book_loans bl ON b.book_BookID = bl.book_loans_BookID
        INNER JOIN
    borrower br ON br.borrower_CardNo = bl.book_loans_CardNo
        INNER JOIN
    library_branch lb ON lb.library_branch_BranchID = bl.book_loans_BranchID
WHERE
    library_branch_BranchName = 'Sharpstown'
        AND book_loans_DueDate = '2/3/18';
 

# 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

SELECT 
    library_branch_BranchName,
    COUNT(book_loans_CardNo) AS books_loaned
FROM
    books b
        INNER JOIN
    book_loans bl ON b.book_BookID = bl.book_loans_BookID
        INNER JOIN
    library_branch lb ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY library_branch_BranchName
ORDER BY books_loaned DESC;

# 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
with cte1 as(select borrower_BorrowerName,borrower_BorrowerAddress,count(borrower_CardNo) as count_of_books from borrower br
inner join book_loans bl
on bl.book_loans_CardNo=br.borrower_CardNo
group by book_loans_CardNo)
select * from cte1 where count_of_books>5
order by count_of_books desc;

# 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT 
    book_authors_AuthorName,
    book_Title,
    library_branch_BranchName,
    book_copies_No_of_Copies
FROM
    authors a
        INNER JOIN
    books b ON b.book_BookID = a.book_authors_BookID
        INNER JOIN
    book_copies bc ON bc.book_copies_BookID = b.book_BookID
        INNER JOIN
    library_branch lb ON lb.library_branch_BranchID = bc.book_copies_BranchID
WHERE
    book_authors_AuthorName = 'Stephen King'
        AND library_branch_BranchName = 'Central';

-- ---------
/*

Creating the Statements through MySQL workbench for proper Reference cum Verification.

CREATE TABLE `authors` (
  `book_authors_AuthorID` tinyint NOT NULL AUTO_INCREMENT,
  `book_authors_BookID` tinyint DEFAULT NULL,
  `book_authors_AuthorName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`book_authors_AuthorID`),
  KEY `book_authors_BookID` (`book_authors_BookID`),
  CONSTRAINT `authors_ibfk_1` FOREIGN KEY (`book_authors_BookID`) REFERENCES `books` (`book_BookID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `book_copies` (
  `book_copies_CopiesID` tinyint NOT NULL AUTO_INCREMENT,
  `book_copies_BookID` tinyint DEFAULT NULL,
  `book_copies_BranchID` tinyint DEFAULT NULL,
  `book_copies_No_Of_Copies` tinyint DEFAULT NULL,
  PRIMARY KEY (`book_copies_CopiesID`),
  KEY `book_copies_BookID` (`book_copies_BookID`),
  KEY `book_copies_BranchID` (`book_copies_BranchID`),
  CONSTRAINT `book_copies_ibfk_1` FOREIGN KEY (`book_copies_BookID`) REFERENCES `books` (`book_BookID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_copies_ibfk_2` FOREIGN KEY (`book_copies_BranchID`) REFERENCES `library_branch` (`library_branch_BranchID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `book_loans` (
  `book_loans_LoansID` tinyint NOT NULL AUTO_INCREMENT,
  `book_loans_BookID` tinyint DEFAULT NULL,
  `book_loans_BranchID` tinyint DEFAULT NULL,
  `book_loans_CardNo` tinyint DEFAULT NULL,
  `book_loans_DateOut` varchar(255) DEFAULT NULL,
  `book_loans_DueDate` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`book_loans_LoansID`),
  KEY `book_loans_BookID` (`book_loans_BookID`),
  KEY `book_loans_BranchID` (`book_loans_BranchID`),
  KEY `book_loans_CardNo` (`book_loans_CardNo`),
  CONSTRAINT `book_loans_ibfk_1` FOREIGN KEY (`book_loans_BookID`) REFERENCES `books` (`book_BookID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_loans_ibfk_2` FOREIGN KEY (`book_loans_BranchID`) REFERENCES `library_branch` (`library_branch_BranchID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_loans_ibfk_3` FOREIGN KEY (`book_loans_CardNo`) REFERENCES `borrower` (`borrower_CardNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `books` (
  `book_BookID` tinyint NOT NULL AUTO_INCREMENT,
  `book_Title` varchar(255) DEFAULT NULL,
  `book_PublisherName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`book_BookID`),
  KEY `book_PublisherName` (`book_PublisherName`),
  CONSTRAINT `books_ibfk_1` FOREIGN KEY (`book_PublisherName`) REFERENCES `publisher` (`publisher_PublisherName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `borrower` (
  `borrower_CardNo` tinyint NOT NULL AUTO_INCREMENT,
  `borrower_BorrowerName` varchar(255) DEFAULT NULL,
  `borrower_BorrowerAddress` varchar(255) DEFAULT NULL,
  `borrower_BorrowerPhone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`borrower_CardNo`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `library_branch` (
  `library_branch_BranchID` tinyint NOT NULL AUTO_INCREMENT,
  `library_branch_BranchName` varchar(255) DEFAULT NULL,
  `library_branch_BranchAddress` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`library_branch_BranchID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `publisher` (
  `publisher_PublisherName` varchar(255) NOT NULL,
  `publisher_PublisherAddress` varchar(255) DEFAULT NULL,
  `publisher_PublisherPhone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`publisher_PublisherName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

*/

