
--    ** SQL PROJECT **   --
--    Library Database Analysis   --

--------------------------------------------------------------------------------
-- Creating the tables based on given Data Model.
--------------------------------------------------------------------------------

create database Books;
use Books;

create table publisher (publisher_name varchar(255) primary key,
						publisher_address varchar(255),
                        publisher_phone char(16));
select * from publisher;
---------------------------------------------------------------------------------
create table borrower (borrower_card_no tinyint auto_increment primary key,
					   borrower_name varchar (255),
                       borrower_address varchar(255),
                       borrower_phone char(16));
select * from borrower;
--------------------------------------------------------------------------------
create table library_branch (branch_id tinyint auto_increment primary key,
							 branch_name varchar(255),
                             branch_address varchar(255));
select * from library_branch;
-------------------------------------------------------------------------------
create table Book ( Book_id tinyint auto_increment primary key,
					Book_title Varchar(255),
                    publisher_name varchar(255),FOREIGN KEY (publisher_name) REFERENCES publisher(publisher_name));
select * from Book;

-----------------------------------------------------------------------------
create table Book_authors (aurhor_id tinyint auto_increment primary key,
                            book_authors_AuthorName varchar(255),
                            Book_id tinyint ,FOREIGN KEY (book_id) REFERENCES book(book_id));
select * from book_authors;

---------------------------------------------------------------------------------
Create table book_copies (Copies_id tinyint auto_increment primary key,
						  Book_id tinyint, FOREIGN KEY (book_id) REFERENCES book(book_id),
                          Branch_id tinyint,FOREIGN KEY (Branch_id) REFERENCES library_branch(Branch_id),
                          No_of_copies tinyint);
select * from book_copies;
----------------------------------------------------------------------------------------

create table book_loans(loan_id tinyint auto_increment primary key,
						Book_id tinyint, FOREIGN KEY (book_id) REFERENCES book(book_id),
                        Branch_id tinyint,FOREIGN KEY (Branch_id) REFERENCES library_branch(Branch_id),
                        borrower_card_no tinyint, FOREIGN KEY (borrower_card_no) REFERENCES borrower(borrower_card_no),
                        loans_dateout date,
                        loans_DueDate date);
select * from book_loans;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

------------------------------
-- Task Quations.
------------------------------


-- 1.  How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bk.book_title,bc.no_of_copies,lb.branch_name from book bk
join book_copies bc  on bk.book_id=bc.book_id
join library_branch lb on lb.branch_id=bc.branch_id
where branch_name="Sharpstown" and book_title="The Lost Tribe";

------------------------------------------------------------------------------------------------------------------------

-- 2.  How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select bk.book_title,bc.no_of_copies,lb.branch_name from book bk
join book_copies bc on bk.book_id=bc.book_id
join library_branch lb on lb.branch_id=bc.branch_id
where book_title="The Lost Tribe";

-------------------------------------------------------------------------------------------------------------------------

-- 3.  Retrieve the names of all borrowers who do not have any books checked out.

select * from borrower
left join book_loans on borrower.borrower_card_no=book_loans.borrower_card_no
where book_loans.borrower_card_no is null;

----------------------------------------------------------------------------------------------------------------------------

-- 4.  For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.

select bk.book_title,b.borrower_name,b.borrower_address from book bk
join book_loans bl
on bk.book_id=bl.book_id
join  library_branch lb
on bl.branch_id=lb.branch_id
join borrower b
on b.borrower_card_no=bl.borrower_card_no
where branch_name="Sharpstown" and loans_DueDate ='2/3/18';

-----------------------------------------------------------------------------------------------------------------------------------

-- 5.  For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select lb.branch_Name, count(bl.book_id) as TotalBooksLoaned
from library_branch lb
join book_loans bl on lb.branch_id = bl.branch_id
group by lb.Branch_Name; 

---------------------------------------------------------------------------------------------------------------------------------

-- 6.  Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select b.borrower_name, b.borrower_address, COUNT(bl.book_ID) as No_Of_Books_CheckedOut
from borrower b
join book_loans bl on b.borrower_Card_No = bl.borrower_Card_No
group by b.borrower_Card_No, b.borrower_Name, b.borrower_Address
having count(bl.Book_ID) > 5;

---------------------------------------------------------------------------------------------------------------------------------

-- 7.  For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

select  bk.book_title , bc.no_of_copies from library_branch lb
join book_copies bc on lb.branch_id=bc.branch_id
join book bk on bc.book_id=bk.book_id
join book_authors ba on bk.book_id=ba.book_id
where ba.book_authors_AuthorName="Stephen King" and lb.branch_name ="Central";

----------------------------------------------------------------------------------------------------------------------------------
--- --------------------------------------------------------**Done** -------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



                            
                            