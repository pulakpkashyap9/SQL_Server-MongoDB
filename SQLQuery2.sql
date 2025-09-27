-- DDL (DATA DEFINITION LANGUAGE) ---> CREATE, ALTER, DROP 


-- Creating a Database with the name of Sequel
CREATE database Sequel


-- Accessing the Database
USE Sequel


-- Creating a Table Object in the Sequel Database
CREATE TABLE Friends
(ID char(5), Name varchar(40), Contact char(12), City varchar(30), DOB date)


-- Checking the structure of the newly created table by retrieving all records in all columns(no records till now)
SELECT * FROM Friends


-- Altering the Contact column in the above Table to hold 13 characters
ALTER TABLE Friends
ALTER COLUMN Contact TO Contacts


-- Add a column Email to the Table
ALTER TABLE	Friends
ADD Email varchar(50)




-- DML (DATA MANIPULATION LANGUAGE) ---> INSERT, UPDATE, DELETE, TRUNCATE


-- Inserting a row to a Table
INSERT INTO Friends
VALUES ('AB005', 'Jyotishman Baruah', 'Un-Available', 'Jyotia', '1995-03-25')

INSERT INTO Friends
VALUES ('AB006', 'Rejuwan Hussain', 'Un-Available', 'Shantipur', '1992-Feb-21')


-- Inserting multiple records into a table with a single Insert keyword (values for each row are in () and separated by a comma)
INSERT INTO Friends
VALUES ('BA007', 'Madhurjya Sutradhar', 'Un-Available', 'Kharguli', '1993-03-15'),
('BA008', 'Prabal Mazumdar', 'Un-Available', 'Islampur', '1991-03-25'),
('BA009', 'Kaushik Goswami', 'Un-Available', 'Silpukhuri', '1993-July-21'),
('BA010', 'Rikkhon Konwar', 'Un-Available', 'Chandmari', '1993-Aug-26')


INSERT INTO Friends (ID, Name, City, DOB)
VALUES ('BA011', 'Nabarun Bordoloi', 'Six Mile', '1992-Nov-19')


-- Updating the records in a table for an entire column
UPDATE Friends set Contact = NULL


-- Updating a single value in a column of a single record
UPDATE Friends set City = 'Panbazar'
WHERE ID = 'AB003'

UPDATE Friends set DOB = '1995-03-05'
WHERE DOB = '1995-03-25'


-- Delete a specific record/row from a table
DELETE FROM Friends
WHERE ID = 'BA011'

-- To delete all rows from a table without deleting the table structure like columns and datatypes and their limits
DELETE FROM Friends


-- To delete all the rows permanently (faster) we use TRUNCATE and it doesnot support WHERE Clause
TRUNCATE TABLE Friends



-- DQL (DATA QUERY LANGUAGE) ---> SELECT


-- Select all records from only a few columns from a table
SELECT ID, NAME FROM Friends


-- Select all records from all the columns in a table
SELECT * FROM Friends
 


-- FILTRATION CLAUSES ---> WHERE, TOP, GROUPBY, ORDERBY, JOINS
SELECT * FROM Friends
WHERE  City = 'Silpukhuri'

-- LIKE CLAUSE IN SQL IS USED WITH WHERE CLAUSE TO DEFINE PATTERNS WITH WILDCARDS TO RETRIEVE VARIOUS RECORDS AS NEEDED
-- WILDCARDS IN SQL ARE %, _, [], [^], [-]

SELECT * FROM Friends
WHERE City Like 'S%'

SELECT * FROM Friends
WHERE City like '%r'

SELECT * FROM Friends
WHERE City like '%a%'

SELECT * FROM Friends
WHERE City like '__a%'

SELECT * FROM Friends
WHERE City Like 'J_____'

SELECT * FROM Friends
Where City like '[sp]%'

Select * From Friends
Where City like '[p-s]%'

Select * From Friends
Where City like '[^p-s]%' -- SAME AS THE USE OF NOT LIKE [P-S]%


-- Fetching the first few records as needed (Same as df.head())

Select * From Friends

-- Starting a New Database for the rest of the concepts

Create Database LearnBay_SQL

Use LearnBay_SQL

-- FILTRATION CLAUSES ---> WHERE, TOP, GROUPBY, ORDERBY, JOINS
SELECT * FROM Friends
WHERE  City = 'Silpukhuri'

-- LIKE CLAUSE IN SQL IS USED WITH WHERE CLAUSE TO DEFINE PATTERNS WITH WILDCARDS TO RETRIEVE VARIOUS RECORDS AS NEEDED
-- WILDCARDS IN SQL ARE %, _, [], [^], [-]

SELECT * FROM Friends
WHERE City Like 'S%'

SELECT * FROM Friends
WHERE City like '%r'

SELECT * FROM Friends
WHERE City like '%a%'

SELECT * FROM Friends
WHERE City like '__a%'

SELECT * FROM Friends
WHERE City Like 'J_____'

SELECT * FROM Friends
Where City like '[sp]%'

Select * From Friends
Where City like '[p-s]%'

Select * From Friends
Where City like '[^p-s]%' -- SAME AS THE USE OF NOT LIKE [P-S]%


-- Fetching the first few records as needed (Same as df.head())

Select Top 5 * From Friends



-- To Fetch the top 5 records based on the salary (highest) sorted in a Descending order
Select Top 20 * From Emp_sal
Order By Salary Desc

Select Top 5 * From Emp_sal
Order By Salary -- The default sorting is done in a ascending order


-- Fetch the top 5 to top 15 salaries
Select * From Emp_sal
Order By Salary Desc
Offset 4 Rows -- Since we need from 5th, Offset = 5 - 1 = 4
Fetch First 11 Rows Only -- Since there are 11 valkues from 5 to 15 (or 15th value - offset rows)

Select * From Emp_sal
Order By Salary Desc
Offset 4 Rows
Fetch Next 11 Rows Only

-- Fetch the EIDs from E1005 to E1015
Select * From Emp
Order By EID -- Works with character datatypes too
Offset 4 Rows
Fetch Next 11 Rows Only

-- FETCH THE DISTINCT VALUES (MOSTLY IN A CATEGORICAL VALUE)

Select Distinct DESI From EMP_Sal

Select Distinct City From EMP



-- OPERATORS IN SQL ---> ARITHMETIC, BITWISE, COMPARISON, COMPOUND, LOGICAL

-- Arithmetic Operators (+, -, *, /, % (Modulo; same as Python))

Select 4+5 as 'Addition', 5-4 as 'Substraction', 2*5 as 'Multiplication', 8/4 as 'Division', 9/2 as 'Modulo Division'

-- We need to calculate 12% of the salary as EPF, 15% of salary as HRA and 24% as Special Allowance
Select *, Salary*.12 as 'EPF', Salary*.15 as 'HRA', Salary*.24 as 'Special Allowance' From EMP_Sal
-- (Selecting all the columns already in Table and adding these following columns to it as well)
-- (The Table is only displayed with the new columns but the original table structure remains unchanged)
Select * From EMP_Sal

Select *, Salary + 10000 as 'New_Salary'  From EMP_Sal
Where DESI like '%Manager%'

-- Making changes to the actual table
Update EMP_Sal Set Salary = Salary + 10000
Where DESI like '%Manager%'

Select * From EMP_Sal


-- Comparison Operators (=, !=, <>, >, <, <=, >=, !>, !<)

Select * From EMP_Sal
Where Salary > 200000

Select * From EMP_Sal
Where DESI != 'Manager'

Select * From EMP_Sal
Where DESI <> 'Manager'

Select * From EMP_Sal
Where Salary !> 200000



-- LOGICAL OPERATORS ----> AND, OR, NOT, BETWEEN, IN, EXISTS, LIKE, ANY, ALL, SOME

Select * From EMP
Where City = 'Delhi' Or City = 'NOIDA'

Select * From EMP
Where City = 'Delhi' And Addr2 like '%Dwarka%'

Select * From EMP
Where Not City = 'Delhi'
 
Select * From EMP_Sal
Where Salary between 100000 and 200000

Select * From EMP
Where Name Between 'A' And 'G' -- Works similar to Like Operator with [-] Wilcard


Select * From EMP
Where Name like '[A-G]%'

Select * From EMP
Where City in ('Delhi', 'Pune', 'NOIDA') -- Works similar to OR Operator 

Select * From EMP
Where City = 'Delhi' Or City = 'Pune' Or City = 'NOIDA'


-- CONSTRAINTS ---> PRIMARY KEY, FOREIGN KEY, AUTO INCREMENT, CREATE INDEX, UNIQUE, NOT NULL, CHECK, DEFAULT

-- Any Column for it to be a Primary Key should have Unique Values and and not any Null Values, usually a Auto Incremented Field
-- Create a Primary Key (One Allowed in a Table at Max)

Alter Table EMP
Add Constraint PK_EID Primary Key(EID)

-- Validating the above theories

Insert Into EMP
Values ('E1001', 'Pulak Kashyap', 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', 'pulakballack@gmail.com','1993-12-20', '2026-01-15')

Insert Into EMP
Values (NULL, 'Pulak Kashyap', 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', 'pulakballack@gmail.com','1993-12-20', '2026-01-15')

-- Unique Constraint only accept Unique Values and will take only 1 NULL Value

Alter Table EMP
Add Constraint UC_EMail Unique(Email, Phone)

-- Validating the above theories

Insert Into EMP
Values ('E1201', 'Pulak Kashyap', 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', 'pulakballack@gmail.com','1993-12-20', '2026-01-15')



--  DEFAULT ---> THE DEFAULT VALUE IN SQL IS NULL BUT WE CAN SET A DIFFERENT VALUE AS PER NEED USING THE DEFAULT CONSTRAINT

Alter Table Emp_Sal
Add Constraint D_City Default 'TEMP' for DEPT

-- Validation

Insert Into EMP_Sal (EID, DESI, SALARY)
values('E1200', 'POLITICS', '250000')



-- NOT NULL BY DEFAULT ALL COLUMNS IN A TABLE ARE NULLABLE COLUMNS. A COLUMN WITH ANY NULL VALUE CANNOT BE A PRIMARY KEY AND 1 NULL VALUE FOR UNIQUE COLUMNS
-- WE CAN CHANGE A COLUMN TO BE A NON NULLABLE COLUMN BY USING THE NOT NULL CONSTRAINT

Alter Table EMP_Sal
Alter Column DEPT nvarchar(50) NOT NULL



-- CHECK CONSTRAINT IS THE ONLY CONSTRAINT THAT ALLOWS USER DEFINED CONSTRAINT AS PER USER NEEDS OR DYNAMIC ACCESS

Alter Table EMP_Sal
Add Constraint C_Sal Check(Salary < 200000) -- Creates a conflict, so it is not executed

Alter Table EMP_Sal
Add Constraint C_Sal Check(Salary < 550000) -- No conflicts so it is executed and will be applied for future inserts (of rows) to the data (table)

-- Validation

Insert Into EMP_Sal (EID, DESI, SALARY)
values('E1202', 'POLITICS', '560000') -- Doesnot allow as there is a conflict

Insert Into EMP_Sal (EID, DESI, SALARY)
values('E1202', 'POLITICS', '560000')

-- By using this we can make sure that the column EID has the E as prefix in every entry but it will still accept values like E1 or ' '**
-- or a constant value like Company = 'Amazon'

Alter Table EMP
Add Constraint C_EID Check(EID like 'E____' and EID != ' ') -- Solves the problem of adding values like E1 or ' ' to the EID Column

-- Validation

Insert Into EMP
Values ('E1200', 'Wasima Shahreen', 'Notboma', 'Hatigaon', 'Guwahati', '9957715142', 'wasimashahin0786@gmail.com','1998-02-28', '2025-10-15')

Insert Into EMP
Values ('S1200', 'Wasima Shahreen', 'Notboma', 'Hatigaon', 'Guwahati', '9957715143', 'wasimashahin421@gmail.com','1998-02-28', '2025-10-15')

Insert Into EMP
Values ('E120', 'Wasima Shahreen2', 'Nottboma', 'Hatigaon', 'Guwahatii', '9957717142', 'wasimashahi7n0786@gmail.com','1998-02-18', '2025-10-15')

-- FOREIGN KEY ---> IT IS A CONNECTION BET6WEEN THE PARENT TABLE (WITH PRIMARY KEY) AND THE CHILD TABLE (FOREIGN KEY)
-- THE FOREIGN KEY REFERENCES TO THE SAME PRIMARY KEY IN THE PARENT TABLE AND DOES KEEPS A VALID CONNECTION BETWEEN THE TWO TABLES

Alter Table EMP_Sal
Add Constraint FK_EMPSal Foreign Key(EID) references EMP(EID) -- The refernces should be to Parentable Table and its Unique or Primary Key Column

Insert Into EMP_Sal
values ('E1302', 'Ops', 'Manager', 500000)

-- Deleting the Constraint to add Cascading in it

Alter Table Emp_Sal
Drop Constraint FK_EMPSal

-- Creating the Constraint with Cascading in it i.e When a record in the Parent Table is deleted or updated the same would reflect in the Child Table

Alter Table EMP_Sal
Add Constraint FK_EMP_Sal Foreign Key (EID) References EMP(EID)
On Delete Cascade
On Update Cascade

-- Validation

Delete From Emp
Where EID = 'E1008' -- The record is deleted from the Child Table as well

Update EMP set EID = 'E1008'
Where EID = 'E1200'



-- CLAUSES ---> GROUP BY

-- GROUP BY ---> OFTEN USED WITH AGGREGATE FUNCTIONS LIKE AVG, MIN, MAX, COUNT, SUM

Select Distinct (City) from EMP

Select City, Count(City) as 'No_Of_EMP' From EMP
Group By City
Order By No_Of_EMP desc

Select DEPT, DESI, Avg(Salary) as 'No_Of_EMP' From EMP_Sal -- The selected columns should be either a part of the aggregate function or the Group by Clause
Group By DEPT
Order By No_Of_EMP desc

Select DEPT, Desi, Count(EID) as 'No_Of_EMP' From EMP_Sal -- The selected columns should be either a part of the aggregate function or the Group by Clause
Group By DEPT, DESI
Order By No_Of_EMP desc


-- Group By Uding the Having Clause, since Where Doesnot work with the Group by Clause, we use the Having Clause to filter the output values

Select Dept, Count(EID) as 'No_Of_EMP' FROM EMP_Sal
Group By Dept
Having Count(EID) > 4
Order By 'No_Of_EMP' Desc

Select Desi, Dept, Count(EID) as 'No_Of_EMP' FROM EMP_Sal
Group By Desi, Dept
Having Count(EID) > 4
Order By 'No_Of_EMP' Desc

Select Top 5 Desi, Dept, Count(EID) as 'No_Of_EMP', Sum(Salary) as 'Total_Salary' FROM EMP_Sal
Group By Desi, Dept
Having Count(EID) > 2 and sum(Salary) > 500000
Order By 'Total_Salary' Desc

-- The order of the Commands should be the same (from the user)---> Order is: Select --> Top --> AggregationFunc --> From (Join) --> Where -->
-- Group By --> Having--> Order By

-- But execution iof the query by the DB Engine is in the following order: From(Join) --> Where --> Group By --> Having --> Select -->
-- Order By --> Top/Other Clauses

-- JOINS IN SQL ---> WHEN WE NEED THE DATA FROM MULTIPLE TABLES

-- Fetching the data from both the EMP Table and EMP_Sal Table --> EID, Name, City, Phone, DOJ, DEPT, DESI, Salary, EPF(12%), HRA(15%)

-- INNER JOIN

Select EMP.EID, NAME, CITY, PHONE, DOJ DEPT, DESI, SALARY, Salary * .12 as 'EPF', Salary * .15 as 'HRA' From EMP
Inner Join EMP_Sal
on EMP.EID = EMP_Sal.EID

-- LEFT JOIN

Select EMP.EID, EMP_Sal.EID, NAME, CITY, PHONE, DOJ DEPT, DESI, SALARY, Salary * .12 as 'EPF', Salary * .15 as 'HRA' From EMP
Left Join EMP_Sal
on EMP.EID = EMP_Sal.EID


Select EMP.EID, EMP_Sal.EID, NAME, CITY, PHONE, DOJ DEPT, DESI, SALARY, Salary * .12 as 'EPF', Salary * .15 as 'HRA' From EMP
Left Join EMP_Sal
on EMP.EID = EMP_Sal.EID
Where Salary is Null


Select EMP.EID, EMP_Sal.EID, NAME, CITY, PHONE, DOJ DEPT, DESI, SALARY, Salary * .12 as 'EPF', Salary * .15 as 'HRA' From EMP
Right Join EMP_Sal
on EMP.EID = EMP_Sal.EID

-- FULL JOIN

Select EMP.EID, EMP_Sal.EID, NAME, CITY, PHONE, DOJ DEPT, DESI, SALARY, Salary * .12 as 'EPF', Salary * .15 as 'HRA' From EMP
Full Join EMP_Sal
on EMP.EID = EMP_Sal.EID

-- CROSS JOIN or Cartesian Join (CROSS MULTIPLICATION JOIN)
-- Used to have a cross product of all records in Table 1 with all records of Table 2. 
-- Total rows in a Cross Join Table = Total rows in Table 1 * Total rows in Table 2

Select * From EMP, EMP_Sal -- Syntax 1

Select * From EMP
Cross Join EMP_Sal -- Syntax 2

-- When we apply a Cross Join on a Common COlumn between the two Tables, it returns a INNER JOIN as only those records are generated which have
-- their values in both the tables in their respective common columns

Select * From EMP, EMP_Sal
Where EMP.EID = EMP_Sal.EID -- Syntax 1

Select * From EMP
Cross Join EMP_Sal
Where EMP.EID = EMP_Sal.EID


-- SELF JOIN --> Used when we have the information needed to join the table is in the table itself

Drop Table Self_Join_Example

Create Table Self_Join_Example (
ID char(5) Not Null Unique, Name varchar(30) Not Null, Designation varchar(30) Not Null, Team_Lead_ID char(5) Default 'A1001', Salary money)

Insert Into Self_Join_Example
Values ('A1001', 'Pulak Pallab Kashyap', 'CEO', NULL, 500000), ('B1002', 'Wasima Shahreen', 'Operations', 'A1001', 400000),
('B1003', 'Hrishikesh Basumatary', 'Management Head', 'B1002', 300000), ('B1004', 'Manash Goswami','Finance Head','B1002', 300000),
('C1005', 'Madhurya Das', 'Marketing Head', 'B1003', 2500000), ('C1006', 'Jyotishman Baruah', 'Consultancy Head','B1003', 250000),
('C1007', 'Rohan Ahmed Baruah', 'Public Relations Head', 'B1003', 250000), ('C1008', 'Kaushik Goswami', 'Human Resource Head','B1004', 250000),
('C1009', 'Rejuwan Hussain', 'Sales Head','B1004', 250000), ('C1010', 'Rikkhon Konwar', 'Advertising Head', 'B1004', 250000),
('D1011', 'Madhurjya Sutradhar', 'Software Development Engineer','C1005', 200000), ('D1012', 'Jyotishman Das', 'Data Analyst', 'C1006', 200000),
('D1013', 'Abdul Waahid', 'Digital Marketing Executive', 'C1007', 200000), ('D1014', 'Nishant Barua', 'Recruitment Officer', 'C1008', 200000),
('D1015', 'Prabal Mazumdar', 'Sales Executive','C1009', 200000), ('D1016', 'Nabarun Bordoloi', 'Media Officer', 'C1010', 200000)

Insert Into Self_Join_Example(ID, Name, Designation, Salary)
Values ('D1017', 'Ashim Pathak', 'Financial Advisor', 150000)

Update Self_Join_Example Set Salary = 250000
Where ID = 'C1005'

Select * From Self_Join_Example

Select sj.ID, sj.Name, sj.Designation, sj.Team_Lead_ID, sj2.Name as Manager_Name, sj.Salary From Self_Join_Example as sj
Left Join Self_Join_Example as sj2
on sj.Team_Lead_ID = sj2.ID



-- SET OPERATORS ---> UNION, UNION ALL, INTERSECT, EXCEPT(MINUS)
-- For set operators we need an equal number of expressions in the Target list (Second Select Statement)

-- UNION --> Here all the rows are merged row by row, and any duplicate rows are automatically removed. It is slower in execution

Create Table Union_Example(
ID char(5) Not Null Unique, Name varchar(30) Not Null, Designation varchar(30) Not Null, Team_Lead_ID char(5) Default 'A1001', Salary money)


Insert Into Union_Example
Values ('D1018', 'Tanmoy Sagar', 'Backend Engineer','C1005', 200000), ('D1019', 'Gaurav Dewan', 'Data Scientist', 'C1006', 200000),
('D1020', 'Angshuman Suchen', 'Digital Marketing Associate', 'C1007', 200000), ('D1021', 'Abinash Das', 'Recruitment Associate', 'C1008', 200000),
('D1022', 'Sauveek Dey', 'Sales Associate','C1009', 200000), ('D1023', 'Rishiraj Borah', 'Event Organiser', 'C1010', 200000)

Insert Into Union_Example Values
('C1005', 'Madhurya Das', 'Marketing Head', 'B1003', 2500000), ('C1006', 'Jyotishman Baruah', 'Consultancy Head','B1003', 250000),
('C1007', 'Rohan Ahmed Baruah', 'Public Relations Head', 'B1003', 250000), ('C1008', 'Kaushik Goswami', 'Human Resource Head','B1004', 250000)

Select * From Union_Example


Select * From Self_Join_Example
Union 
Select * From Union_Example


-- UNION ALL --> Here the rows are copied from the Table2 to Table1 together, without the removal of duplicate records. It is faster in execution

Select * From Self_Join_Example
UNION ALL
Select * From Union_Example



-- INTERSECT ---> Here the rows or records that are common in both the tables are retrieved

Select * From Self_Join_Example
Intersect
Select * From Union_Example

-- Here Madhurya Das is not retieved as its salary is different in each table. 
-- Despite all other data being the smae, it is not considered as common record as one data is different in one field

-- EXCEPT --> It will Minus/Extract those records that are not in the Target Statement (Second Select Statement)

-- It removes all the common records from Table 1 that are also in Table 2 and returns the records in Table 1 with no duplicates in Table 2

Select * From Union_Example
EXCEPT
Select * From Self_Join_Example



-- INDEXING ---> helps in retrieving searches and filter operations faster. It is specially important in large datasets.

-- If we create indexes the filtration operations perform index-scan, otherwise it performs a Table-scan which is much slower
-- In Large datasets, A Balanced-Tree (B-Tree) Structure is formed to retrieve the queries faster
-- Indexing can be both Single (On Single Column) or Composite (Multiple Level Indexing on Multiple Columns)
-- In Composite indexing we use two or more columns which are likely to be used together in filtering queries


-- SINGLE INDEXING
Create Index CI_Emp1 on EMP(City)


-- Validation
Select * From EMP
Where City = 'Delhi'


-- COMPOSITE INDEXING
Create Index CK_Emp2 on EMP(Addr2, Addr1)


-- Validation
Select * From EMP
Where ADDR2 like '%dwarka%' and ADDR1 like '%Sector%'


Showplan_all on / off -- Use to check execution plan and what indexing is used and how it optimizes the filtertion or queries



-- VIEWS ---> these are Database Objects called Virtual Tables that can be created on Queries

-- They are often used to restrict access for certain users to the whole Table but give them access to a part of it
-- They do not need/create any space to hold the data and views can be used for Data Manipulation when it is structured using one Table
-- They can have certain limitations based on the query that was used to create them
-- The Views are Read Only when we use Distinct/ Group By Clause, aggregation functions, Pivot/UnPivot Operators in the query to create the view
-- The View is also Read Only when we use Joins/ Unions in the query to Create the View (since the data of the View are derived from two tables)

Create View View_EX as
Select E.EID, NAME, DEPT, DESI, SALARY, ADDR1, ADDR2, CITY, PHONE, DOB, DOJ From EMP as E
Inner Join EMP_Sal as ES
On E.EID = ES.EID

Insert Into View_EX
values ('E1207', 'Pulak Pallab Kashyap', 'Ops', 'Associate Manager', 400000, 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', '1993-12-20',
'2026-01-15')

-- Does not work as the query with which the View was Created used Multiple Base Tables

Create View View_EX2 As
Select * From EMP
Where CITY = 'Delhi'

Insert Into View_EX2
values ('E1207', 'Pulak Pallab Kashyap', 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', 'pulakpkashayp9@gmail.com','1993-12-20',
'2026-01-15')

-- Changes in a View results in the Changes in the Base Table from where the View is Extracted as Shown below:

Select * From EMP


Delete From EMP
where EID = 'E1207'



-- Insertion/Updatation/Deletion possible in this case as the view is created using a query that involves only 1 base Table and does not have any
-- Distinct/Group By Clause, Pivot/ Unpivot Operators or any Aggregation Functions
-- But here the Insertion/deletion/Updatation is not restricted to the condition in the WHERE Clause. To make it so we use with Check Option
-- We can Alter a View using the following SYNTAX:


Alter View View_EX2 As
Select * From EMP
Where CITY = 'Delhi'
With Check Option

Insert Into View_EX2
values ('E1207', 'Pulak Pallab Kashyap', 'Ranibari', 'Panbazar', 'Guwahati', '8876825397', 'pulakpkashayp9@gmail.com','1993-12-20',
'2026-01-15')

-- This does not work as the With Check Option introduces a CHECK Constraint based on the Condition in the Where Clause
-- And here only those data or records could be updated, inserted or deleted which satisfy the condition in the Where Clause

-- SQL FUNCTIONS (IMPORTANT) --> Pre-Defined Functions (PDF) and User-Defined Functions (UDF)

-- UDFis further divided into two categories, namely --> Scalar Functions and Table Value Functions

-- PRED-DEFINED FUNCTIONS(PDF) ---> Aggregation Funcs, String Funcs, Window Funcs, Date Funcs, Numeric Functions
-- Agrregation Functions --> Count, Min, Max, Sum, Avg

-- Count ---> Counts the number of rows; row indexes in SQL start from 1 (unlike in Python)

Select Count(*) From EMP_Sal -- Counts all the rows as no row has all column values as Null


Select Count(Salary) From EMP_Sal -- Counts only the rows where Salary Column has a Not Null value

Select Count(Salary) From EMP_Sal
Where Desi like '%Manager%' -- Counts the Number of rows which are not null in Salary Coolumn where the DESI is any type of Manager

Select Dept, count(EID) From EMP_Sal
Group By DEPT

Select count(*) -- Since counting starts from 1 in an empty Table it is still 1 (as it starts counting), hence it returns 1

Select count(*) + count(*) *2 -- 1+1*2 = 3


-- SUM ---> Used to get the aggregate total of a Numeric Column; returns a scalar value (one value)

Select sum(Salary) From EMP_Sal -- Total Sum of the Salaries of all the Employees in the OPS Department
Where DEPT = 'Ops'

Select Sum(Salary) From EMP_Sal -- Total Sum of all the Employees' Salary

Select DEPT, COUNT(SALARY), SUM(Salary) From EMP_Sal
Group By DEPT


-- MIN/MAX --> Finds the min and max values in Numerical Columns based on certain groupings/Partitions or groupings; Works with Char columns too

Select min(Salary), max(Salary) From EMP_Sal

Select min(Salary), max(Salary) From EMP_Sal
Where DEPT = 'Ops'

Select DEPT, min(Salary), max(Salary) From EMP_Sal
Group By DEPT

Select CITY, min(Name), max(Name) From EMP
Group By CITY


-- AVG --> Returns the average of a numeric column based on partitions/ groupings/ conditions. Does not work with Character Columns

Select avg(Salary) From EMP_Sal

Select avg(Salary) From EMP_Sal
Where DEPT = 'Ops'

Select DEPT, avg(Salary) From EMP_Sal
Group By DEPT

Select CITY, avg(Name), From EMP
Group By CITY


-- SQUARE, SQRT --> Finds the Squares and Square Roots from Numeric Values or Numeric Columns; Does not work with Character Columns

Select square(Salary), sqrt(Salary) From EMP_Sal

Select square(Salary), sqrt(Salary) From EMP_Sal
Where DEPT = 'Ops'

Select DEPT, square(min(Salary)), sqrt(sum(Salary)) From EMP_Sal
Group By DEPT

Select square(3), sqrt(121)


-- RAND() --> Used to generate randomized numbers, by default range is between 0 to 1

Select rand()

Select rand() *100


-- CONCAT ---> Concatenates Two or more Columns --> Can be used with both Numeric and Char Columns

Select *, Concat(Addr1,' ', Addr2, ' ', City) as FULL_ADDRESS From EMP

Select *, Concat(Addr1, ', ', Addr2, ', ', City) as FULL_ADDRESS From EMP

Select *, Concat(Salary, ' ', EID) From EMP_Sal

Select Concat('Pulak', ' ', 'Kashyap')


-- STRING FUNCTIONS OR STRING MANIPULATION FUNCTIONS

-- ASCII gives the ASCII value of any printable or unprintable characters.
-- They help the system to recognise characters by translating them to numbers

Select ASCII('}')

Select ASCII('}pulak') -- It only gives the Ascii value of one character at a time

Select ASCII('\n')

-- CHAR ---> It is the Opposite of the ASCII() Function and returns the character associated with ASCII Number (1 to 255)

Select CHAR(3)

Select CHAR(69)

Select CHAR(255)

Select Char(256)



-- LEFT ---> It takes two arguments: Expression (String or Column) and Number (Index up to where the Expression is to be Extracted)

-- It extracts the characters from the Left end of the Expression up to the specified index

Select Left('Pulak Pallab Kashyap lives in Guwahati', 5)



-- RIGHT ---> It takes two arguments: Expression (String or Column) and Number (Index up to where the Expression is to be Extracted)

-- It extracts the characters from the Right end of the Expression up to the specified index

Select Right('Pulak Pallab Kashyap lives in Guwahati', 8)



-- SUBSTRING ---> It takes three arguments: Expression (String or Column), Start Position
-- and Number ([Length of substring to be extracted)

-- It extracts the characters from the specified starting poistion to the specified Number of Index

Select SUBSTRING('Pulak Pallab Kashyap lives in Guwahati', 7, 14)



-- UPPER and LOWER ---> Converts the expression or Column Strings inside the functions to Uppercase or Lowercase respectively

Select Upper('Pulak'), Lower('Kashyap')



-- LEN ---> Returns the length of the Expression (column or String)

Select len(ADDR2) From EMP

Select len('Pulak Pallab Kashyap')



-- CHARINDEX --> Finds the inex position of the specified character(s) in the first occurence

Select CHARINDEX('Sector', concat(ADDR1, ' ', ADDR2, ' ', CITY)) From EMP
Where CITY = 'Delhi'

Select CHARINDEX('PAL', 'Pulak Pallab Kashyap')

Select CHARINDEX('k', 'Pulak Pallab Kashyap')



-- Checking Some uses of the above functions

-- Extract the first character of the name column for all workers
Select NAME, Left(NAME, 1) From EMP

-- Extract the first character of the last name

Select NAME, Substring(NAME, Charindex(' ', NAME)+1, 1) From EMP

Select NAME, left(right(Name, len(Name) - charindex(' ', Name)), 1) From EMP

-- Extract the Four characters from right to left of EID

Select EID, left(substring(EID, 2, 4), 4) From EMP

Select *, right(EID, 4) From EMP

-- Create Official EmailID which will be the combination of first letter of first name, first Letter of Last name, 4 char from right end of EID
-- and with the learnbay.co ip address

Select Name, EID, concat(left(Name, 1), substring(Name, charindex(' ', Name)+1, 1), left(substring(EID, 2, 4),4), '@learnbay.co') From EMP

Select Name, EID, concat(left(Name, 1), substring(Name, charindex(' ', Name)+1, 1), right(EID,4), '@learnbay.com') From EMP



-- REPLACE --> It is used to replace some character(s) in an Expression (Column or String)

Select Replace(NAME, 'Wasima', 'Bubuma') From EMP

Select Replace('Pulak lives in India', 'India', 'Netherlands')



-- REVERSE --> It reverses a given string

Select Reverse(NAME) From EMP

Select Reverse('Pulak Pallab Kashyap')



-- STUFF ---> It is used to stuff the Expression from a particular index with a new string
-- It takes four arguments: Expression, Position, Number of Character, New_Value

Select STUFF('Pulak Pallab Kashyap is a Data Scientist', 6, 7, '')

Select STUFF('lIEYFGIndia is my Motherland', 1, 6, 'I live in the Netherlands, but ')

Select STUFF('Pulak Kashyap is a Data Scientist', 6, 0, ' Pallab')

Select Stuff(EMAIL, 7, 6, 'shahreen') From EMP
Where EID = 'E1008'
