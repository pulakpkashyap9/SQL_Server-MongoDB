-- A New Query Window for Sequence, Auto Identity Columns, Stored Procedures, Transactions, Triggers

Use Learnbay_SQL


-- AUTO IDENTITY COLUMNS IN SQL

-- It is a Table Object and is associated with a Single Table
-- It generates Sequenced values to a column automatically, the assigned inputs can be set by the User and are always Unique
-- If we try to pass explicit values to a Auto-Identity Column, it raises error as it generates its own values based on the sequence specified
-- It can only take Numeric Values
-- The Auto-Identity Column always has Non Null and Unique Values.
-- Thus it can later be made into a Primary Key column if needed as it fulfills both the requirements of the Primary Key Column

Create Table AutoIdent_EX (EID int Not Null Identity (1001, 1) Name varchar(40) Not Null, Salary int Not Null)

-- Adding Primary Key to the Auto-Identity Column
Alter Table AutoIdent_EX
Add Constraint PK_Auto Primary Key (EID)

Insert Into AutoIdent_Ex
Values ('PULAK PALLAB KASHYAP', 'GNOIDA', 275000), ('WASIMA SHAHREEN', 'GUWAHATI', 250000), ('MANASH MON GOSWAMI', 'BENGALURU', 200000),
('HRISHIKESH BASUMATARY', 'GUWAHATI', 200000), ('ANGSHUMAN SUCHEN', '', 200000)('MADHURYA DAS', 'GUWAHATI', 150000),
('ROHAN AHMED BARUA', 'GURUGRAM', 150000), ('JYOTISHMAN BARUAH', 'GURUGRAM', 150000), ('KAUSHIK GOSWAMI', 'LAKHIMPUR', 250000),
('MADHURJYA SUTRADHAR', 'GUWAHATI', 150000), ('PRABAL MAZUMDAR', 'GUWAHATI', 150000), ('JYOTISHMAN DAS', 'GUWAHATI', 150000),

SELECT * FROM AutoIdent_Ex

-- Assignment to Make the EIDs as E1001, 1002, 1003,...
Alter Table AutoIdent_EX
Add New_EID char(5) -- As we cannot change the dtype of a Auto-Identity Column to char/varchar. It can only have Integer Values

Update AutoIdent_Ex Set New_EID = concat('E', EID) -- We update the Values of the New_EID with the EiD column with the E in front of the values

Alter Table AutoIdent_EX
Drop Constraint PK_Auto -- We need to drop the Primary Key Constraint as we cannot drop a column with Primary Key from a Table

Alter Table AutiIdent_EX
Drop Column EID -- After the Primary Key Constraint is dropped we can drop the old EID column as its values are already copied to the New_EID

sp_rename 'AutoIdent_EX.New_EID', 'EID' -- We rename the New_EID Column to EID

Alter Table AutoIdent_EX
Add Constraint PK_Auto Primary Key(EID) -- We finally add the Primary Key Constraint to the EID column

-- Adding a New Column to AutoIdent_EX (Existing Table) with the Auto-Identity Column
Alter Table AutoIdent_EX
Add ID int Identity (1,1)

Select * From AutoIdent_Ex



-- SEQUENCES OR AUTO SEQUENCES IN SQL

-- They are Database Objects and generates a Series that is Numeric
-- They generate sequential numbers whose starting value, Increments, Max and Min Values we can specify
-- They can be cyclic in nature if so intended and we can generatecached values which makes them more efficient
-- The numbers generated are always Unique and we cannot pass explicit values to it
-- The next value in a Sequence is generated using the code: Next Value for SEQUENCE_NAME

Create Sequence testseq 
AS Int -- Specifies the dtype
Start With 1 -- Specifies the starting value
Increment by 1 -- The value by which the Sequnce Increments
MaxValue 10 -- Specifies the max Value upto which the sequence goes. ONLY NEEDED IF IT IS CYCLIC
MinValue 1 -- Specifies the Min Value with which the succeeding values of the Cycle begins. ONLY NEEDED IF IT IS CYCLIC
Cycle -- It Makes the Sequence Cyclic; When the Max Value is reached in the Sequence it restarts with the Min Value
Cache 5 --Stores the next 5 values in memory to generate the next values faster. It makes the Sequence more efficient

-- Calling the Next Value of a Sequence. IT IS ALSO CALLED THE COUNTER OF THE SEQUENCE
SELECT NEXT VALUE FOR testseq as 'Counter'

-- Dropping a Sequence
Drop Sequence testseq

-- Insert values to a Column using Sequence
 Alter Table SubQuery_EX
 Add Serial_NO int

 Insert Into Tab_Name
 Values (Next Value for testseq, 'A') -- We will have to do it one at a time


 -- ASSIGNMENT: CREATE A FUNCTION TO ADD EID TO A TABLE WITH VALUES OF E0001, E0002,...

 Create Function Uniq_ID(@Var1 as varchar(5), @Var2 as Int)
 Returns Varchar(9)
 As
 Begin
		Declare @Result as varchar(9)
		Set @Result = Case
					When @Var2 Between 1 and 9 Then concat(@Var1, '000', @Var2)
					When @Var2 Between 10 and 99 Then concat(@Var1, '00', @Var2)
					When @Var2 Between 100 and 999 Then concat(@Var1, '0', @Var2)
					When @Var2 Between 1000 and 9999 Then concat(@Var1, @Var2)
					Else 'NA' End
		Return @Result
End

drop function dbo.uniq_id

Select dbo.Uniq_ID ('OPS', 2107)



-- PROCEDURE OR STORED PROCEDURES IN SQL

-- It is a Database Object which holds a code or a Query which we can use frequently in a Database
-- It is more advanced and dynamic than a function
-- It can store any SQL Query or Code
-- We can execute functions using it
-- We can perform multiple tasks inside a Procedure
-- It can be used for Data Manipulation
-- It can update the Child and Parent Tables together
-- A special Kind of Procedures give access to the activation of automated tasks (called a Trigger)
-- It can be used to switch between the variopus Tables in a Database
-- From the User's perspective it is easier to use than a compiled Function
-- It is a precompiled Function


-- First Example: Non-Parameterized ---> Works like a View (In this Case)
Create Procedure Procedure_View
As
Begin
	Select E.EID, Name, City, DOJ, Dept, Desi, Salary From EMP as E
	Inner Join EMP_Sal as ES
	On E.EID = ES.EID
	Where City = 'Delhi'
End

-- Calling a Procedure: THREE WAYS
execute Procedure_View

exec Procedure_View

Procedure_View

--Dropping a Procedure:
drop Procedure Procedure_View


-- Next Examples: Parameterized ---> Works like TVF (In this Case)
Create Procedure Procedure_TVF @City as varchar(20)
As
Begin
	Select E.EID, Name, Doj, Dept, Desi, Salary From EMP as E
	Inner Join EMP_Sal as ES
	On E.EID = ES.EID
	Where City = @City
END

Procedure_TVF 'Delhi' -- Calling the Procedure

Drop Procedure Proc_Name


-- Next Example: We want to display the Various Tables as well
Create Procedure tab_view @table as varchar(max)
As
Begin
	Exec ('Select * From ' + @Table)
End

tab_view 'EMP_Sal'

tab_view 'Self_Join_Example'


-- Next Example: Procedure used for Insertion
Create Procedure Procedure_Insert @Var1 as char(5), @Var2 as varchar(25), @Var3 as varchar(40), @Var4 as char(5), @Var5 as int
As
Begin
	Insert Into Self_Join_Example -- DML
	values (@Var1, @Var2, @Var3, @Var4, @Var5)

	Select * From Self_Join_Example --DQL
	Where ID = @Var1
End

Procedure_Insert 'D1025', 'Mridutpal Sikdar', 'Designing', 'C1005', 150000


-- Checking Output of Procedure (If it works for both 2 Named Employees and 3 Named Employees)

Procedure_Email 'Wasima Shahreen', 'B1002'


-- Function for the above problem
Create Function Function_Email (@Var1 as varchar(40), @Var2 as char(5))
Returns varchar(50)
As
Begin
	Declare @Result as varchar(50)
	Declare @Second as varchar(40)
	Declare @Third as varchar(30)

	Set @Second = substring(@Var1, charindex(' ', @Var1)+1, len(@Var1) - charindex(' ', @Var1))
	Set @Third = substring(@Second, charindex(' ', @Second)+1, len(@Second) -charindex(' ', @Second))

	Set @Result = Case
					  When charindex(' ', @Second) != 0 Then concat(substring(@Var1, 1,1), substring(@Second,1,1), @Third, substring(@Var2, 3,3), '@learnbay.co')
				  Else concat(left(@Var1,1), @Second, substring(@Var2, 3, 3), '@learnbay.co') End

	Return @Result

End


-- Checking the Conditions (RoughWork):
Select substring('Wasima Shahreen', charindex(' ', 'Wasima Shahreen')+1, len('Wasima Shahreen') - charindex(' ', 'Wasima Shahreen'))

Select substring('Shahreen', charindex(' ', 'Shahreen')+1, len('Shahreen') - charindex(' ', 'Shahreen'))


Select charindex(' ', 'Shahreen')

Select dbo.Function_Email ('Bhargav Goswami', 'D1026')


-- Using the Function to add the Company Emails to the Employees
Alter Table Self_Join_Example
Add Comp_Email varchar(60)

Update Self_Join_Example Set Comp_Email = dbo.Function_Email(Name, ID)

Select * From Self_Join_Example


-- Next Example: To Make the Company Email for Employees Using First letter of First Name , Second Name and the last 3 digits of ID

Create Procedure Procedure_Email @Table as varchar(50), @ID as char(5), @Name as varchar(40), @Desig as varchar(35), @Team_Lead as char(5),
									@Salary as int
As
Begin
	Declare @Email as varchar(50)

	Set @Email = (Select dbo.Function_Email(@Name, @ID)) -- Using the function above in the Procedure

	Exec  ('Insert Into ' +@table+ ' Values (''' +@ID+''','''+@Name+''','''+@Desig+''','''+@Team_Lead+''','+@salary+','''+@Email+''')' )

	Exec ('Select * From ' + @Table + ' Where ID = ''' + @ID+'''')
End

Select * From Self_Join_Example

Procedure_Email 'Self_Join_Example', 'D1026', 'Bhargav Goswami', 'Consultant', 'C1007', 200000

drop Procedure Procedure_Email


-- Above Problem can also be done as:(Less Dynamic)
create table training
(Eid char(5),Name varchar(50), Cmail varchar(100))

create PROCEDURE Ins_trn @I as char(5), @N as varchar(50)
as
BEGIN
		Declare @email as varchar(100)
		Declare @Domain as varchar(50)

		Set @Domain='@learnbay.co'
		Set @email=(Select dbo.cmail(@I,@N,@Domain)) /* we are using the function for generating the Emailid*/

		Insert into training
		values(@I,@N,@Email),(@I,@N,@Email)

		select * from training
		where EID=@I
End

drop PROCEDURE Ins_trn
ins_trn 'E0003' ,'Raman Gupta'


select * from training


-- Update the Child and Parent Tables Together

Create Procedure ParChlUpd_Procedure @ID as char(5), @N as varchar(50), @A1 as varchar(40), @A2 as varchar(40),
				@C as varchar(30), @P as varchar(20), @E as varchar(30), @Db as date, @Dj as date, @Dp as varchar(30), @Ds as varchar(40), @S as int
As
Begin
	Insert Into EMP
	Values (@ID, @N, @A1, @A2, @C, @P, @E, @Db, @Dj)

	Insert Into EMP_Sal
	Values (@ID, @Dp, @Ds, @S)

	Select * From EMP
	Where EID = @ID

	Select * From EMP_Sal
	Where Eid = @ID
End

drop Procedure ParChlUpd_Procedure

Parchlupd_Procedure 'E1215','Pulak Pallab Kashyap','Kaliram Medhi Road','Ranibari, Panbazar','Guwahati','8876825397','ulakpulak@gmail.com',
'1993-12-20','2025-06-18', 'IT','Executive',254150

select * From EMP



-- TRANSACTIONS IN SQL

-- It follows certain properties (ACID Properties)

-- A: ATOMICITY: The property by which if any part of the transaction is not completed then the entire transaction is reverted back to the original
 -- state before the transaction was started

-- C:CONSISTENCY: When multiple users are part of the many transactions at the same time or in case there are parallel transactions then the
-- changes in the database are visible to all in real time or updated for every user for the sake of consistency

-- I: ISOLATION: It isolates every transaction and they are considered as separate units. The failure or closure of any other transactiom
-- is not dependent on other transactions and are not subjected to other transactions conditions

-- D: DURABILITY: Once a transaction with the entirety of its steps are completed, the changes are permanently saved to the database

-- STRUCTURE OF TRANSACTIONS:

 -- BEGIN TRANSACTION: It initiates the transaction

 -- SAVE TRANSACTION: Provides a Checkpoint for the Transaction and if any of the latter stages fail, the transaction can reinitialize
 -- from this point without having to start from the actual beginning

 -- ROLLBACK: It is used to rollback the transaction to the start or to a Saved Checkpoint if any conditions are unmatched or the transaction
 -- needs to be disapproved

 -- COMMIT: The changes are saved to the Database and the changes are permanent after which point the changes are updated or
 -- visible to everyone in the system (for consistency)


Begin Transaction --The Transaction begins; Makes the usage of other Transaction Commands like Save Transaction, Rollback and Commit possible

Delete From EMP
where EID = 'E1009' -- Deletes the Row from the Table


Rollback -- The row reappears in the Table (We revert back to the stage before the beginning of the Transaction)

Select * From EMP



Begin Transaction

Delete From EMP
Where EID = 'E1009'

Save Transaction T1

Rollback -- We revert back to the stage before the start of the Transaction

Select * From EMP



Begin Transaction

Delete From EMP
Where EID = 'E1005'

Save Transaction T1

Delete From EMP
Where EID = 'E1001'

Save Transaction T2

Delete From EMP
Where EID = 'E1002'

Save Transaction T3

Delete From EMP
Where EID = 'E1003'

Save Transaction T4

Rollback Transaction T3 -- The Transaction is rolled back till the checkpoint T3

Select * From EMP -- We have E1003 in the Table

Rollback Transaction T1 -- The Transaction is rolled back till the T1 Checkpoint

Select * From EMP -- All the rows except E1005 is in the Table

Rollback -- All the steps are rolled back to the stage from before the start of the Transaction

Select * From EMP -- The Table is exactly the same like it was before the Transaction started



Begin Transaction

Delete From EMP
Where EID = 'E1007'

Commit -- Makes the changes permanent and the updates are visisble to all the users for consistency

Rollback -- No rolebacks possible as the Transaction is saved in the database permanently and the update is visible to all the users

Select * From EMP



-- PIVOT IN SQL

-- Transfers the row values into column for Aggregation
-- We use it in Categorical Columns where the number of distinct values are just a handful
-- We use CTEs to return multiple Pivot Tables with one Query
-- It is advisable to use only one aggregation in one pivot Table, if we need multiple Aggregation we should use multiple pivot Tables using CTEs


Select Desi, OPS, Temp, HR, IT, Mis, Admin from 
(Select DESI, Dept, Salary From EMP_Sal) as Main_Table
Pivot(sum(Salary) for Dept in (Ops, IT, Temp, MIS, HR, ADMIN)) as Pvt_Table


--SubQuery (The Columns to be used for Pivoting, Aggregation from the Main Table)
Select DESI, Dept, Salary From EMP_Sal

--Pivot Table (Pivoting done based on aggregation on Which Columns)
Pivot(sum(Salary) for Dept in (Ops, IT, Temp, MIS, HR, ADMIN)) as Pvt_Table

-- Main Table (The Columns to be retrieved from the Table)
Select Desi, OPS, Temp, HR, IT, Mis, Admin from 
(Select DESI, Dept, Salary From EMP_Sal) as Main_Table


-- Another Example
Select Year, OPS, MIS, IT, HR, ADMIN, TEMP From
(Select E.Eid, Year(DOJ) as Year, Dept, Salary From EMP as E
Inner Join EMP_Sal as ES on E.EID = ES.EID) as Main_tab
Pivot (avg(Salary) for Dept in (OPS, IT, HR, ADMIN, MIS, TEMP)) as Pivot_Tab


-- Another Example
 With CTE AS (Select year([Order date]) as 'year' , 'Q' +Cast(Datepart(Quarter,[Order date]) as Varchar(40)) as Quarter, sales
 from Orders)
		
Select Distinct Quarter from CTE


--- 

Create table Monthlysalesd
(year int, Month varchar(10), Sales int)

insert into Monthlysalesd
values(2023,'jan',2010),(2023,'Feb',2000),(2023,'Mar',3000),(2023,'Apr',2000),(2023,'May',2000)
,(2023,'jun',2080),(2023,'jul',2050),(2023,'Aug',2000),(2023,'Sept',2110),(2023,'Oct',2700),
(2023,'Nov',1000),(2023,'Dec',2300)

select * from Monthlysalesd

Select [jan],[feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[sepT],[oct],[Nov],[dec]
from (Select Year,Month,Sales from Monthlysalesd) as Main_tabl

Pivot ( sum(sales) for month in ([jan],[feb],[Mar],[Apr],[May],[Jun],[Jul],[Aug],[sept],[oct],[Nov],[dec]) ) as Pv_table



-- TRIGGERS IN SQL

-- It is a Special kind of Procedure which is used to maintain automated DML events (Insert, Delete, Update)

-- For Insertion
Insert Into Orders
Values('O0001','C0001','P0005', 10)

Update Stocks Set SQty = SQty - 10
Where PID = 'P0005'
-- The above is done in a Manual Way, Below the same process is done with Triggers
-- which automatically updates the Stocks Table when we insert into Orders

Create Trigger order_insert
on Orders -- This is the Event Table: Where the actual values are changed or inserted, updated or deleted by the user
for Insert -- This is the Trigger (It can be for all DML commands: Insert, Update or Delete)
as
Begin
	Update Stocks set SQty = SQty - (Select OQty from inserted)
	Where PID = (Select PID From inserted)
End

-- For Deletion
Delete From Products
Where PID = 'P0009'

Delete From Stocks
Where PID = 'P0009'
-- The above is done in a Manual Way, Below the same process is done with Triggers
-- which automatically updates the Stocks Table when we insert into Orders

Create Trigger Product_Delete
on Product
for Delete
As
Begin
	Delete From Stocks
	Where PID = (Select PID From Deleted)
End


-- For Updatation
Insert Into Orders
Values ('O0003', 'C0002', 'P0008', 2)

-- Customer wants to update the Order Value

Update Orders Set OQty = 4
Where OID = 'O0003'

Update Stocks Set SQty = Sqty - 2 -- Amount of change in Order (here 2)
Where PID = (Select PID From Orders Where OID = 'O0003')
-- The above is done in a Manual Way, Below the same process is done with Triggers
-- which automatically updates the Stocks Table when we insert into Orders

-- When Update takes place, both Delete and Insert takes place together
-- In this Case: Old_Order_NO = 2, New_Order_NO = 4, Stock_left_After_Updatation = Balance after Insertion Trigger + Old_Order_NO - New_Order_NO
Create Trigger Order_Update
On Orders
For Update
As
Begin
		Declare @OQ as Int
		Declare @NQ as Int

		Set @OQ = (Select OQty From Deleted)
		Set @NQ = (Select OQty From Inserted)

		Update Stocks Set SQty = SQty + @OQ - @NQ
		Where PID = (Select PID From Inserted)

End

Update Orders Set OQty = 4
Where PID = 'P0009'


-- Now we See that that an Order can have more quantities than there are stocks present, In which case the Order should not accepted
-- We can Solve that issue by using a Trigger in the Inserted Quatity (in Orders Table with respect to Quantites available in Stocks Table)

Drop Trigger Order_Insert

Create Trigger Order_Insert
On Orders
For Insert
As
Begin
		Declare @OA as Int
		Declare @OR as Int

		Set @OR = (Select OQty from Inserted)
		Set @OR = (Select SQty From Stocks Where PID = (Select PID From Inserted))


		If @OA >= @OR
		Begin
			Update Stocks Set SQty = SQty - (Select OQty From Inserted)
			Where PID = (Select PID From Inserted)
			Print('Order Accepted')
		End
		Else
			Begin
			Rollback
			Print('Order Stock Insufficient in Warehouse, Order is NOT PLACED')
			End
End

Insert Into Orders
values ('O0005', 'C0004', 'P0008', 5)

Insert Into Orders
values ('O0005', 'C0004', 'P0008', 1)



-- CASE WHEN

-- It is a similar command as that of If and Else Statement
-- It is a conditional method to run the aggregation, label the values, sort the values with any condition
-- They can be used with logical cocepts like Functions, Procedures etc
-- It is a conditional Statement which can be used with Select,Order By,Having or Where & is an ANSI Standard that is applicable across all RDBMS
-- When evaluating multiple Conditions it is more efficient and readable than a nested if...Else Statement
-- Case When primarily returns a single value and is used within a Query

-- If... Else Statement are mostly found in Procedures, Triggers, Transactions and Functions to control the flow of the program
-- They allow for multi-step logic within its blocks or a series of statements

Select * from EMp

-- create a salary segment with the emp details
-- High, Mid_Sal, Low_Sal
-- >200000 is high, between 100000 and 200000 is mid
-- <100000 is low

Select E.EID, name, City, DOJ, Dept, Desi, Salary, Case when Salary>200000 then 'High_sal'
														when salary between 100000 and 200000 then 'Mid_sal'
														Else 'Low_sal' end as 'Sal_segment'
from emp E
inner join Emp_sal Es
on E.Eid=Es.EID
order by Salary desc


-- Another Example: Conditional Aggregation

Select Dept, coalesce(Sum(case when Desi='manager' then salary end),0) as total_man_sal from Emp_sal /* coelasce handle the null values
and converting into 0 (here))*/
group by DEPT


-- Another Example

Select Dept, Desi, Salary
from Emp_sal
order by Case
				When Dept='Temp' then 1
				When Dept='OPS' Then 2
				When Dept='HR' then 3
				When Dept='MIS' then 4
				Else 5
				END

