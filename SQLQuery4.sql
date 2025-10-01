-- A New Query Window for for the Window Functions and Date Functions and other concepts

Use LearnBay_SQL



-- WINDOW FUNCTIONS
-- They perform row wise operations on the Table and can retrieve running or cummulative aggregations unlike the usual functions


-- WINDOW AGGREGATE FUNCTIONS


-- SUM(): Gives the Cummulative Sum after adding the values of each row for Numeric Columns

-- ORDER BY sorts column in ascending or descending order before it performs the row-wise aggregation functions; as shown below:
Select *, SUM(Salary) Over (Order By EID) From EMP_Sal

-- PARTITION BY works similar to Group By and finds the Aggregation rowwise for each category in the specified Column; as shown below in details:
Select *, SUM(Salary) Over (Partition By DEPT Order By Salary DESC) From EMP_Sal
-- Similar to:
Select *, Sum(Salary)Over (Order By Salary DESC) From EMP_Sal
Where Dept = 'ADMIN'
-- Similar to:
Select Dept, Sum(Salary) From EMP_Sal
Group By DEPT


-- AVG(): Gives the Moving average per row for Numeric Columns

Select *, AVG(Salary) Over (Order By EID) From EMP_Sal
-- Moving Average per Department:
Select *, AVG(Salary) Over (Partition By DEPT Order By Salary Desc) From EMP_Sal
-- Similar to:
Select *, AVG(Salary) Over (Order By EID) From EMP_Sal
Where Dept = 'ADMIN'
-- Similar to:
Select Dept, AVG(Salary) From EMP_Sal
Group By DEPT


-- WINDOWS NUMBERING FUNCTIONS
-- They help in ranking or numbering the value in the rows for Numeric Columns


-- RANK(): Helps in positioning or ranking as per a specified Numeric column
-- It gives same ranking to ties but skips the gap for the next rank

Select EID, Salary, Rank() Over (Order By Salary DESC) From EMP_Sal
-- Same as:
Select * From EMP_Sal
Order By SALARY DESC
-- Rank per Department:
Select EID, DEPT, Salary, Rank() Over (Partition By DEPT Order By Salary DESC) From EMP_Sal


-- DENSE_RANK():

Select EID, Salary, Rank() Over (Order By Salary DESC),
Dense_Rank() Over (Order By Salary DESC) From EMP_Sal
-- Same as:
Select * From EMP_Sal
Order By SALARY DESC
-- Rank per Department:
Select EID, DEPT, Salary, Rank() Over (Partition By DEPT Order By Salary DESC),
Dense_Rank() Over (Partition By DEPT Order By Salary DESC) From EMP_Sal


-- ROW_NUMBER(): It checks how many rows have the same columns value specied in the Partition Column
-- It is usually important to check duplicate values using Subqueries and Common Table Expressions (CTE)
-- Order by column is useless here?

-- Below it is Partitioned by DEPT and the number of times a DEPT has come up is shown in the new column;
Select *, Row_Number() Over (Partition By Dept Order By Salary DESC) From EMP_Sal
-- Below it is Partitioned by Salary column and it shows how often a certain salary amount has come up in the Salary Column
Select *, Row_Number() Over (Partition By Salary Order By Dept) From EMP_Sal
-- Without the Order By Clause which is a necessity. Else it does not work
Select *, Row_Number() Over (Partition By Salary) From EMP_Sal
-- With the Same partition By and Order By column
Select *, Row_Number() Over (Partition By Salary Order By Salary) From EMP_Sal
-- With ORDER BY and without PARTITION BY (Doesn't work as intended without the Partition By Clause)
Select *, Row_Number() Over (Order By Salary) From EMP_Sal


-- WINDOWS NAVIGATION FUNCTIONS

-- LAG(): It provides the value in the preceeding row in a given Column

Select *, Lag(Salary) Over (Order By EID) From EMP_Sal

Select *, Lag(Salary,3) Over (Order By EID) From EMP_Sal

Select *, Lag(Salary) Over (Partition By DEPT Order By EID) From EMP_Sal


-- LEAD(: It provides the Value in the subsequent row of a given column

Select *, Lead(Salary) Over (Order By EID) From EMP_Sal

Select *, Lead(Salary,2) Over (Order By EID) From EMP_Sal

Select *, LEAD(Salary) Over (Partition By DEPT Order By EID) From EMP_Sal


-- COMBINING BOTH LAG() AND LEAD()

Select *, Lag(Salary) Over (Order By EID), Lead(Salary) Over (Order By EID) From EMP_Sal


-- Variance in Salary (Very important to determine or analyse sales changes over time)

Select *, Lag(Salary) Over (Order By EID), Salary - (Lag(Salary) Over (Order By EID)) From EMP_Sal


-- DATE FUNCTIONS OR TIME INTELLIGENCE FUNCTIONS
-- They fetch the date or time components from date or datetime columns


-- GETDATE(): Fetches the current datetime from the system/server
-- Datetime format is YYYY-MM-DD HH:MM:SS.MS

Select getdate()


-- DATEADD(): Takes three arguments: Datepart, Value(Based on Datepart), Date/Datecolumn/Datefunction
-- Datetime Format: YYYY-MM(Quarter)-DD(Week) HH:MM:SS.MS
-- Output: Date (By using this function we are adding a date into a date and getting a date)

-- Finding the date in 100 days from now
Select DATEADD(day, 100, '2025-09-27')

Select DATEADD(day, 100, getdate())
-- Date after 2 years
Select DATEADD(year, 2, getdate())
-- Date after 3 months
Select DATEADD(Month, 3, '2025-09-27')
-- Date before 100 days
Select Dateadd(day, -100, getdate())
-- Date before 3 months
Select DATEADD(Month, -3, '2025-09-27')
-- Hour after 12 hours
Select DATEADD(HOUR, 12, getdate())

-- Lets say every employee has a Probation Period of 90 days. Find their confirmation date
Select *, dateadd(Day, 90, DOJ) as 'Confirmation_Date' From EMP


-- DATEDIFF(): Finds the difference in dates and gives the output as an Integer

--Checks how mny days old I am:
Select Datediff(Day, '1993-08-21', getdate())
-- Using in a Table:
Select DATEDIFF(Year, DOB, DOJ) From EMP
-- Checking desired date from now:
Select DATEDIFF(Day, getdate(), '2026-07-01')
-- Checking how long workers are working the company in Years
Select *, Datediff(Year, DOJ, getdate()) as Tenure From EMP
Order By Tenure
-- We can find the months and Years as well
Select *, Datediff(Year, DOJ, getdate()) as Years, Datediff(Month, DOJ, getdate())%12 as Months From EMP
Order By Years DESC
-- Conactenating both Years and Months together
Select *, concat(Datediff(Year, DOJ, getdate()),' Years ', Datediff(Month, DOJ, getdate())%12, ' Months') as Tenure From EMP
Order By DOJ DESC


-- DATE(): It retrieves the specified datepart from a given date/datetime

Select Datepart(DAY, getdate())

Select Datepart(Month, '2025-09-28')

Select *, Datepart(Year, DOJ) From EMP


-- YEAR(), MONTH(), DAY(): Extracts the year, month and day respectively from a date/date column/ date function
-- We can also use them with the Where Caluse

Select Year(DOJ), Month(DOB), day('2025-09-28'), Year(getdate()) From EMP

Select * From EMP
Where Year(DOB) >= '1997' and Month(DOB) <= '05'

Select * From EMP
Where Year(DOB) between '1997' and '2001' and Month(DOB) <= '05'


-- DATENAME(): It extracts the name of the day from a date/ date column/ datefunction. Focuses on the name of the datepart

Select *, DATENAME(WEEKDAY, DOB) From EMP
Where DATENAME(WEEKDAY, DOB) = 'Saturday'

Select *, DATENAME(WEEK, DOJ) FROM EMP

Select *, DATENAME(MONTH, DOJ) As JoiningMonth FROM EMP
Where DATENAME(MONTH, DOJ) = 'January'


-- CONVERT(): It converts a date/date column or date function from the SQL format (YYYY-MM-DD) to a desired date format of our choice
-- It takes 3 arguments: dtype(limit) of new column/date format, date/date column/ date function, code for new format
-- The codes range from 100 to 113 and 115 returns all 0s and 23s the default
-- Used to convert unrecognised date formats to the default SQL format or others

Select Convert(varchar(30), getdate(), 100)

Select *, Convert(varchar(30), DOJ, 113) From EMP

Select Convert(varchar(30), '2025-09-28', 110) From EMP
-- How to convert a date to another format in a table
Alter Table EMP
Add New_DOJ varchar(30)

Update EMP set New_DOJ = convert(varchar(30), DOJ, 113)
Select * From EMP

Update EMP set New_DOJ = convert(varchar(30), DOJ, 103)

Select * From EMP
-- Let us say we have the date column in the above format and need to convert it to some other form (here actual date form of SQL)
Alter Table EMP
Alter Column New_DOJ date

Alter Table EMP
Drop Column New_DOJ



-- FORMAT(): It returns a date focusing on the Datepart specified or in a format specified from a date/ date column/ date function
-- Check all the different formats in google

Select format(getdate(), 'D')

Select format(getdate(), 'M')

Select format(getdate(), 'Y')

Select *, format(DOB, 'yyyy/MM') From EMP

Select *, format(DOB, 'MMMM yyyy') FROM EMP



-- USER-DEFINED FUNCTIONS (UDF)

-- Scalar Functions: Part A of UDF

-- SYNTAX:
/* Create Function Function_Name (@Var1 AS dtype, @Var2 AS dtype)
   Returns dtype
   As
   Begin
		declare @result_var as dtype
		Set @Result_var = @Var1 * @Var2 (Function logic)
		Return @Result_var
   END
*/


Create Function prodx (@Var1 AS Int, @Var2 AS Int)
Returns Int
AS
Begin
	Declare @Output AS Int
	Set @Output = @Var1 * @Var2
	Return @Output
End

Select dbo.prodx(7,9) -- Function Call


-- Create a function to check if a word is a Palindrome

Create Function PalinCheck (@Var1 AS varchar(100))
Returns varchar(100)
As
Begin
	Declare @rev AS varchar(100)
	Set @rev = reverse(@Var1)
	Return Case
		When @rev = @Var1 Then 'It is a Palindrome'
		Else 'It is not a Palindrome'
		End
End

Select dbo.palincheck('Pulak')

drop function dbo.palincheck



-- Create a function to calculate the Age of the employees

Create Function AgeCal (@Vardate as varchar(30))
Returns varchar(30)
As
Begin
	Declare @Result as Varchar(30)
	Set 	@Result = concat(Datediff(Year, @Vardate, getdate()), ' Years ', Datediff(Month, @Vardate, getdate())%12, ' Months')
	Return @Result
End

Select dbo.AgeCal('1993-08-21')

Select DOB, dbo.AgeCal(DOB) From EMP

Drop Function dbo.AgeCal



-- Create a Function to generate a Company EMAIL: FirstLetter of FirstName, SecondName, Three Last Digits from EID with a domain name of @Learnbay.com

Create Function EMAILID (@Name as varchar(50), @EID as char(5))
Returns varchar(50)
As
Begin
	Declare @Email as varchar(50)
	Set @Email = concat(left(@Name,1), substring(@Name, charindex(' ', @Name)+1, len(@Name)), substring(@EID,3, 3), '@learnbay.co')
	Return @Email
End

Select EID, Name, dbo.EMAILID (Name, EID) From EMP

-- Another method

create function corpemail (@Id as char(5), @name as varchar(30),@Dm as varchar(20))
returns varchar(100)
as
begin
	Declare @Email as varchar(100)

	Declare @Len as int
	Declare @Spc_pos as int
	Declare @LName as varchar(40)

	Set @len=len(@name)
	Set @Spc_pos=Charindex(' ',@name)
	Set @LName=Right(@name,@len-@Spc_pos)

	Set @Email=concat(left(@name,1),@lname,right(@id,3),@Dm)

	return @email
End

Select Name, EID, dbo.corpemail(Eid, Name, '@learnbay.co') From EMP

-- With both the Functions there is a shortcoming as People with 3 Names generate an invalid EMAILID (Make it better)



-- Table View Functions (TVF): Part B of UDF

/* SYNTAX:
   Create Function Function_Name (Parameters)
   Returns Table
   As
   Begin
   Return( Select Col1, Col2, Col3
			From Tab1
			Inner Join Tab2 on Tab1.ColA = Tab2.ColB
			Where Col1 = @Cond)
   End
*/

-- We can only pass scalar values as variable objects i.e not Columns and Tables  in TVF

Create Function emp_detail(@cond as varchar(50))
Returns Table
As
Return (Select EMP.EID, Name, DEPT, DESI, Salary From EMP
		Inner Join EMP_Sal on EMP.EID = EMP_Sal.EID
		Where DEPT = @cond
		)

Select * From dbo.emp_detail('TEMP')

-- We can use the Where clause in TVF
Select * From dbo.emp_detail('TEMP')
Where Name like '[A-G]%'

-- We can update/delete/insert into a TVF but again like Views only if it is extracted from 1 Base Table
Insert into dbo.Emp_detail('IT')
Values ('E1207', 'PULAK PALLAB KASHYAP', 'MANAGER', 200000)

-- READ ON DIFFERENCE BETWEEN TVF AND A VIEW. THERE IS NOT MUCH OF A DIFFERENCE



-- SUBQUERY IN SQL
-- It is a query inside a query or a nested query or an inner query
-- It is used when we need to extract the data from one table but need another table to filter out the data from it
-- In Joins, we need the data from two separate tables but here the data from the 2nd table is only required to filter the data from the first table

-- RULES IN SUBQUERY
-- The subquey needs to be inside the parenthesis ()
-- We need to use the In Operator to filter the data from the subquery
-- ORDER BY clause cannot be used in the Subquery but it can be used in the main query
-- Ony one column can be seeked from the subquery without using the EXISTS Operator
-- Subqueries can be used for Data Manipulation i.e. Insertion/Updatation/ Deletion of data from a Table

Select EID, Name, City From EMP
Where EID in (Select EID From EMP_Sal where Dept = 'Temp')
Order by Name
-- Here we are only extracting data from one table and we need the second table only to filter out the data from it; so Join is not needed here

/* Since we cannot use:
Select EID, Name, City from EMP
Where Dept = 'TEMP'
*/

Select * From EMP_Sal
Where Dept = 'TEMP'

-- Using Subquery to Insert Data into a Table
Create Table SubQuery_EX (EID char(5), Name varchar (50), City varchar (30))

Insert Into SubQuery_EX
Select EID, Name, City From EMP
Where EID in (Select EID From EMP_Sal Where DEPT = 'TEMP')

-- Deletion of Data from a Table using Subquery
Delete From SubQuery_EX
Where EID in (Select EID From EMP_Sal Where Desi like '%Manager%')

Select * From SubQuery_EX

Select * From EMP_Sal
Where DEPT = 'TEMP' and DESI not like '%Manager%'
Order By EID

-- Updatation Using Subquery
Update SubQuery_EX Set NAME = 'BUBUMA SHAHREEN'
Where EID in (Select EID From EMP_Sal Where Dept = 'TEMP' and DESI = 'POLITICS')

Select * From SubQuery_EX

-- CORRELATED SUBQUERIES (SYNCHRONISED SUBQUERIES)
-- It is amethod of using Multiple Subqueries in Correlated Tables or Fields to extract the desired Outcome/ Output

-- Find the Managers of Yogeswar Sharma and Kapil Sharma from the data

-- Here we will use multiple subqueries to reach the conclusion:

SELECT EID, NAME FROM EMP WHERE EID IN(
Select EID From EMP_sal Where DEPT in (
Select DEPT From EMP_Sal
Where EID in
(Select EID From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma')))

-- The Inner SubQueries are provided here to check their output (for understanding)
-- The Innermost SubQuery is:

Select EID From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma'

-- The Second Innermost Subquery is:

Select DEPT From EMP_Sal
Where EID in (Select EID From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma')

-- The Outermost Subquery is:

Select EID From EMP_sal Where DEPT in (
Select DEPT From EMP_Sal
Where EID in (Select EID From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma'))

-- It can be used with Joins as well, CHECK OUT MULTIPLE OR CORRELATED SUBQUERIES WITH JOINS


-- EXISTS OPERATOR: Subquery with EXISTS Operator checks the existence of Inner Result based on it runs the Outer or Main Query
-- If the Inner Query is True then it gives an Output else if False, it gives no Output

Select * From EMP_Sal
Where EXISTS (Select * From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma')


Select EID From EMP_sal Where EXISTS (
Select * From EMP_Sal
Where EXISTS (Select * From EMP Where Name = 'Yogeshwar Sharma' or Name = 'Kapil Sharma'))

-- As we can see from the above examples, it does not filter out any data
-- It only checks if the inner query returns any output and if it does it executes the outer query
-- It is more efficient as it only executes the outer query if the inner query returns an output



-- COMMON TABLE EXPRESSIONS (CTE) / SUBQUERY REFACTORING / WITH CLAUSE

-- It gives the subquery block a name, which returns a temporaray set of results with an Expression
-- The name of the Subquery onlty exists at the time of execution. This creates better readability of complex queries
-- We can use the derived column names as column names when we execute the query statement of this CTE

With temp_det as (Select E.EID, Name, City, Dept, Desi, Salary as Basic_Salary, Salary * .12 as EPF, Salary * .15 as HRA From EMP as E
					Inner Join EMP_Sal as ES on E.EID = ES.EID Where Salary <= 250000 and City like '[A-G]%')

Select * From temp_det

-- Multilevel CTE:
With temp_det2 as (Select E.EID as ID, Name, Dept, Desi, Salary as Basic_Salary, Salary * .12 as EPF, Salary * .15 as HRA From EMP as E
					Inner Join EMP_Sal as ES on E.EID = ES.EID Where Salary <= 250000 and City like '[A-G]%')

,Sal_Cal as (Select ID, NAME, DEPT, (Basic_Salary+EPF+HRA) as Gross_Salary, (Basic_Salary+EPF) as Accounted_Salary,
				(Basic_Salary+HRA) as Nett_Salary From temp_det2 Where Dept = 'TEMP')

Select * From Sal_Cal

-- A more complicated CTE than the above
With temp_det2 as (Select E.EID as ID, Name, Dept, Desi, Salary as Basic_Salary, Salary * .12 as EPF, Salary * .15 as HRA From EMP as E
					Inner Join EMP_Sal as ES on E.EID = ES.EID Where Salary <= 250000 and City like '[A-G]%')

,Sal_Cal as (Select E.EID, E.NAME, DEPT, (Basic_Salary+EPF+HRA) as Gross_Salary, (Basic_Salary+EPF) as Accounted_Salary,
				(Basic_Salary+HRA) as Nett_Salary From temp_det2 as td Full Join EMP as E on td.ID = E.EID)

Select * From Sal_Cal




