-- Creating the Database'

Create Database Inventory_Management_System


-- Subscribing into The Database

Use Inventory_Management_System


-- Creating the Supplier Table with the necessary Constraints, dtypes and length limits

Create Table Supplier(
SID char(5) Not Null Primary Key, SNAME varchar(30) Not Null, SADDRESS varchar(80) Not Null, SCITY varchar(25) Default 'Delhi',
SPHONE char(13) Not Null Unique, EMAIL varchar(40) Check(Email like '%@yahoo%' or Email like '%@gmail%'))


--Adding the Check Constraint to the SID Column

Alter Table Supplier
Add Constraint CK_SuppSID Check(SID like 'S____')


-- Checking the Structure of the Table

Select * From Supplier



-- Creating the Table Product

Create Table Product(
PID char(5) Not Null Primary Key Check(PID like 'P____'), PDESCRIPTION varchar (200) Not Null, PRICE money Not Null Check(Price > 0),
CATEGORY char(2) Not Null Check(CATEGORY in ('IT', 'HA', 'HC')), SID char(5))


-- Altering the Table to add the Foreign Key Constraint to the SID Column and Not Null Constraint to the SID Column

Alter Table Product
Add Constraint FK_Prod Foreign Key(SID) References Supplier(SID) On Delete Cascade On Update Cascade


Alter Table Product
Alter Column SID char(5) Not Null

-- Checking the Structure of the Table 

Select * From Product



-- Creating the Table Customer

Create Table Customer(
CID char(5) Not Null Primary Key Check(CID like 'C____'), CNAME varchar(40) Not Null, ADDRESS varchar(100) Not Null, CITY varchar(30) Not Null,
PHONE char(13) Not Null, EMAIL varchar(35) Not Null Check(EMAIL Like '%@yahoo%' or EMAIL Like '%@gmail%'), DOB date Check(DOB < '2000-01-01'))


-- Checking the Structure of the Table

Select * From Customer



-- Creating the Table Orders

Create Table Orders(
OID char(5) Not Null Primary Key Check(OID like 'O____'), ODATE date Not Null, CID char(5) Not Null Foreign Key References Customer(CID)
On Update Cascade On Delete Cascade, PID char(5) Not Null Foreign Key References Product(PID) On Delete Cascade On Update Cascade,
OQTY smallint Not Null Check(OQTY >= 1))


-- Checking the Structure of the table

Select * From Orders



-- Creating the table Stock

Create Table Stock(
PID char(5) Not Null Foreign Key References Product(PID) On Update Cascade On Delete Cascade, SQTY smallint Check (Sqty >= 0),
ROL int Check(Rol >=0), MOQ int Check(MOQ >= 0))


-- Checking the Structure of the Table

Select * From Stock



-- Create Table Purchase

Create Table Purchase (PID char(5) Not Null Foreign Key References Product(PID) On Update Cascade On Delete Cascade,
SID char(5) Not Null Foreign Key References Supplier(SID), PQTY int Not Null check (PQTY > 0), DOP date Not Null)


-- Checking the Structure of the Table

Select * From Purchase



-- Creating the Table Bill

Create Table Bill (OID char(5) Foreign Key References Orders(OID) On Update Cascade On Delete Cascade, ODATE date, CNAME varchar(40),
ADDRESS varchar(100), PHONE char(13), PDESCRIPTION varchar(200), PRICE money, OQTY smallint, TOTAL_AMT money Not Null)


-- Checking the Structure of the Table

Select * From Bill



-- CREATING THE NECESSARY TRIGGERS


-- A. On INSERTION on ORDERS Triggering STOCK UPDATE

Create Trigger InsertOrders_StockUpdate
On Orders
For Insert
As
Begin
		Declare @AQ as int
		Declare @OQ as int


		Set @OQ = (Select OQTY From Inserted)
		Set @AQ = (Select SQTY From Stock Where PID = (Select PID From Inserted))

		If @AQ >= @OQ
				Begin
					Update Stock Set SQTY = SQTY - (Select OQTY From Inserted)
					Where PID = (Select PID From Inserted)
					print('Order Accepted')

				End

		Else
				Begin
					
					Throw 50002, 'Insufficient Stocks, Order NOT PLACED', 1
				
				End

End



-- B. On UPDATE ON ORDERS Triggering STOCK UPDATE

Create Trigger UpdateOrders_StockUpdate
On Orders
For Update
As
Begin
		Declare @OV as int
		Declare @NV as int
		Declare @QA as Int

		Set @OV = (Select OQTY from Deleted)
		Set @NV = (Select OQTY From Inserted)
		Set @QA = (Select SQTY From Stock Where PID = (Select PID From Inserted)) + @OV


		If @QA > @NV
		Begin
				Update Stock Set SQTY = SQTY + @OV - @NV
				Where PID = (Select PID From Inserted)
				print('Order Accepted')
		End
		Else
		Begin
		Throw 50001, 'Order NOT PLACED due to insufficient Stocks', 1
		End
End



-- C. On INSERTION on ORDERS Triggering BILL INSERT

Create Trigger InsertOrders_BillInsert
On Orders
For Insert
As
Begin
		Declare @OID as char(5)
		Declare @ODATE as date
		Declare @CNAME as varchar(40)
		Declare @ADDRESS as varchar(100)
		Declare @PHONE as char(13)
		Declare @PDESCRIPTION as varchar(200)
		Declare @PRICE as Money
		Declare @OQTY as smallint
		Declare @AMT as money

		Set @OID = (Select OID From Inserted)
		Set @ODATE = (Select ODATE From Inserted)
		Set @CNAME = (Select CNAME From Customer Where CID = (Select CID From Inserted))
		Set @ADDRESS = (Select ADDRESS From Customer Where CID = (Select CID From Inserted))
		Set @PHONE = (Select PHONE From Customer Where CID = (Select CID From Inserted))
		Set @PDESCRIPTION = (Select PDESCRIPTION From Product Where PID = (Select PID From Inserted))
		Set @PRICE = (Select PRICE From Product Where PID = (Select PID From Inserted))
		Set @OQTY = (Select OQTY From Inserted)
		Set @AMT = @PRICE * @OQTY

		Insert Into Bill
		Values (@OID, @ODATE, @CNAME, @ADDRESS, @PHONE, @PDESCRIPTION, @PRICE, @OQTY, @AMT)

End


-- D. On UPDATING Orders Triggering BILL UPDATE

Create Trigger UpdateOrders_BillUpdate
On Orders
For Update
As
Begin
		Declare @NV as Int
		Declare @PRICE as Money
		Declare @AMT as money

		Set @NV = (Select OQTY From Inserted)
		Set @PRICE = (Select PRICE From Product Where PID = (Select PID From Inserted))
		Set @AMT = @PRICE * @NV

		Update Bill Set OQTY = @NV
		Where OID = (Select OID From Inserted)

		Update Bill Set TOTAL_AMT = @AMT
		Where OID = (Select OID From Inserted)
End


-- E. On UPDATING STOCK Triggering PURCHASE INSERT

Create Trigger UpdateStock_PurchaseInsert
On Stock
For Update
As
Begin	
		Declare @PID as char(5)
		Declare @SID as char(5)
		Declare @PQTY as int
		Declare @DOP as date
		Declare @ROL as Int
		Declare @SQTY as Int
		
		Set @PID = (Select PID From Inserted)
		Set @SID = (Select SID From Product Where PID = (Select PID From Inserted))
		Set @PQTY = (Select MOQ From Inserted)
		Set @DOP = (Select getdate())
		Set @ROL = (Select ROL From Inserted)
		Set @SQTY = (Select SQTY From Inserted)

		If @SQTY < @ROL
		Begin
			Insert Into Purchase
			Values (@PID, @SID, @PQTY, @DOP)
			print('Stock Refilled Due to Low Quantity in Warehouse')
		End
		Else
		Begin
			print('Sufficient Stock, Refill Not Needed')
		End
End



-- F. On INSERTION ON PURCHASE Triggering STOCK UPDATE

Create Trigger InsertPurchase_StockUpdate
On Purchase
For Insert
As
Begin
		Update Stock Set SQTY = SQTY + (Select PQTY From Inserted) 
		Where PID = (Select PID From Inserted)
End
 


-- INSERTING TO THE RESPECTIVE TABLES


-- INSERTION TO SUPPLIER (NO TRIGGERS)

Insert Into Supplier
Values ('S0001', 'WASIMA SHAHREEN', 'NOTBOMA, HATIGAON', 'GUWAHATI', '+919957715142', 'WASIMASHAHREEN0786@GMAIL.COM'),
('S0002', 'RIKKHON KONWAR', 'AEI, CHANDMARI', 'GUWAHATI', '+919577367599', 'RIKKHONKONWAR268@GMAIL.COM'),
('S0003', 'RISHIRAJ BORAH', 'AT ROAD, BHARALUMUKH', 'GUWAHATI', '+917007473854', 'RISHIRAJBORAH776@GMAIL.COM'),
('S0004', 'MADHURJYA MAI SUTRADHAR', 'BIHUTOLI, KHARGULI', 'GUWAHATI', '+918763543662', 'MADURJYAMAISUTRA257@GMAIL.COM'),
('S0005', 'MADHURYA DAS', 'NAGKATA PUKHURI, PANBAZAR', 'GUWAHATI', '+918876488347', 'PETLAMADARCHOD@GMAIL.COM'),
('S0006', 'ABDUL WAAHID', 'AEI, CHANDMARI', 'GUWAHATI', '+918976547653', 'HAFLONGADHAMIYA@GMAIL.COM'),
('S0007', 'JYOTISHMAN BARUAH', 'JYOTIA, KAHILIPARA', 'GUWAHATI', '+917766554433', 'GATHIYAPUWALI@GMAIL.COM'),
('S0008', 'JYOTISHMAN DAS', 'SIX MILE, RUKMINIGAON', 'GUWAHATI', '+919988776655', 'CHOTUGADHACHODA@GMAIL.COM'),
('S0009', 'ANGSHUMAN THAKURIA', 'GANDHIBASTI, BILLASIPARA', 'GUWAHATI', '+918877665544', 'PETLAGANDU@GMAIL.COM'),
('S0010', 'PULAK PALLAB KASHYAP', 'RANIBARI, PANBAZAR', 'GUWAHATI', '+919977553311', 'PULAKPALLABK@GMAIL.COM')

SELECT * FROM Supplier

Update Supplier Set SID = 'S0011'
Where SName = 'Angshuman Thakuria' -- Update in SID leads to update in SID in Products as well (On Update Cascade is working fine)

Delete From Supplier
Where SID = 'S0010' -- On Delete Cascade working fine for Product, Orders and Purchase Tables with SID as FK



-- INSERTION INTO PRODUCT (NO TRIGGER)

 INSERT INTO Product
 VALUES ('P0001', 'MSI HX750 LAPTOP', 215000, 'IT', 'S0010'), ('P0002', 'APPLE MACBOOK M4 PRO', 300000, 'IT', 'S0010'),
 ('P0003', 'THINKPAD AZ1000 LAPTOP', 100000, 'IT', 'S0010'), ('P0004', 'DELL X1090 LAPTOP', 150000, 'IT', 'S0010'),
 ('P0005', 'ASUS R558UQ LAPTOP', 50000, 'IT', 'S0010'), ('P0006', 'HP ULTRA 15X LAPTOP', 75000, 'IT', 'S0010'),
 ('P0007', 'LG COOLZ25 REFRIGERATOR', 25000, 'HA', 'S0009'), ('P0008', 'PANASONIC ZS100 MICROWAVE', 10000, 'HA', 'S0008'),
 ('P0009', 'NILKAMAL 4X4 TEAKWOOD SOFA SET', 45000, 'HC', 'S0007'), ('P0010', 'KING SIZE INDIADESIGNS BED', 55000, 'HC', 'S0007'),
 ('P0011', 'BPL MONITORS FOR PC ULTRA HD', 15000, 'IT', 'S0006'), ('P0012', 'MICROWAVE BAJAJ PL2805', 8000, 'HA', 'S0005'),
 ('P0013', 'SAMSUNG TV QUAD HD LT00Q8', 75000, 'IT', 'S0004'), ('P0014', 'SONY BRAVIA ULTRA HD Q2425 TV', 45000, 'IT', 'S0004'),
 ('P0015', 'NILKAMAL PLASTIC CHAIRS', 5000, 'HC', 'S0003'), ('P0016', 'NILKAMAL SANDALWOOD DINING TABLE', 25000, 'HC', 'S0002'),
 ('P0017', 'DAIKIN AIRCONDITIONER WB22RQ 1.5 TON', 75000, 'HA', 'S0001'),
 ('P0018', 'GODREJ AIRCONDITIONER GJ770PB 2 TON', 90000, 'HA', 'S0001'),
 ('P0019', 'APPLE ASSEMBLED PC XZ110K', 225000, 'IT', 'S0001'),
 ('P0020', 'YAMAHA RZ 350 ULTRA', 250000, 'HA', 'S0001')

SELECT * FROM Product

Update Product Set PID = 'P0021'
Where SID = 'S0011'  -- Change in PID leads to change of PID in Stock (On Update Cascade working fine in Stock Table)

Update Product Set PID = 'P0022'
Where PDESCRIPTION Like 'SAMSUNG%' -- Change in PID leads to change in Stock, Purchase and Orders Table (On Update Cascade works fine for all FK)

Delete From Product
Where PID = 'P0006'-- On Delete Cascade working fine for Stock, Orders and Purchase Tables with PID as FK



-- INSERTION INTO STOCK (NO TRIGGER)

INSERT INTO Stock
VALUES ('P0001', 20, 5, 18), ('P0002', 15, 5, 12), ('P0003', 30, 10, 25), ('P0004', 25, 5, 18), ('P0005', 50, 20, 35), ('P0006', 40, 15, 28),
('P0007', 50, 15, 40), ('P0008', 80, 30, 60), ('P0009', 30, 10, 25), ('P0010', 25, 10, 20), ('P0011', 50, 20, 35), ('P0012', 80, 30, 60),
('P0013', 30, 10, 25), ('P0014', 50, 20, 35), ('P0015', 120, 40, 100), ('P0016', 50, 20, 35), ('P0017', 40, 15, 30), ('P0018', 30, 10, 25),
('P0019', 20, 5, 18), ('P0020', 20, 5, 20)

SELECT * FROM Stock



-- INSERTION INTO CUSTOMER (NO TRIGGERS)

INSERT INTO Customer
VALUES ('C0001', 'PULAK PALLAB KASHYAP', 'HN: 29, RANIBARI, PANBAZAR', 'GUWAHATI', '+918876825397', 'PULAKPALLABK@GMAIL.COM', '1993-12-20'),
('C0002', 'WASIMA SHAHREEN', 'HOUSEFED COMPLEX, NOTBOMA, HATIGAON', 'GUWAHATI', '+919957715142', 'WASIMASAHIN0786@GMAIL.COM', '1999-02-28'),
('C0003', 'PRABAL MAZUMDAR', 'B.BAROOAH ROAD, ISLAMPUR, ULUBARI', 'GUWAHATI', '+918876834567', 'PRABALBEARDED@GMAIL.COM', '1991-03-01'),
('C0004', 'NABARUN BORDOLOI', 'NAGALAND HOUSE ROAD, SIX MILE', 'GUWAHATI', '+917002365748', 'NABARUNTHEBRO@GMAIL.COM', '1992-11-19'),
('C0005', 'KAUSHIK GOSWAMI', 'GOSWAMI SERVICE, SILPUKHURI', 'GUWAHATI', '+918876486324', 'BOGABINDI@GMAIL.COM', '1993-07-24'),
('C0006', 'ROHAN AHMED BARUA', 'ZOO ROAD, BEHIND ZOO', 'GUWAHATI', '+918812888774', 'ROHANCHUTIYA@GMAIL.COM', '1994-04-04'),
('C0007', 'HRISHIKESH BASUMATARY', 'NEAR HOLY CHILD SCHOOL, CHANDMARI', 'GUWAHATI', '+918876297531', 'MUMUPETUWA@GMAIL.COM', '1993-09-24'),
('C0008', 'MANASH GOSWAMI', 'OPP MAHARISHI VIDYA MANDIR SCHOOL, SILPUKHURI', 'GUWAHATI', '+918876428128', 'MMGOSWAMI@GMAIL.COM', '1995-06-08'),
('C0009', 'SAUVEEK DEY', 'LACHIT NAGAR, BIRUBARI', 'GUWAHATI', '+918856475568', 'SAUVEEKACHHIMA@GMAIL.COM', '1992-10-24'),
('C0010', 'NISHANT DAS', 'NIZARAPAR, SILPUKHURI', 'GUWAHATI', '+919988772211', 'KOKAELTORRE@gMAIL.COM', '1993-04-24')

SELECT * FROM Customer

Update Customer Set CID = 'C0011'
Where CNAME = 'NISHANT DAS' -- Change in CID changes CID in Orders Table and On Update Cascade in working fine for Orders Table

Delete From Customer
Where CID = 'C0011' -- On Delete Cascade has worked well for Orders Table



-- INSERTION INTO ORDERS (TRIGGERS BILL INSERTION AND STOCK UPDATE)

INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0001', GETDATE(), 'P0001', 'C0006', 3)


INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0002', '2026-01-20', 'P0006', 'C0009', 20)


INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0003', GETDATE(), 'P0017', 'C0010', 15)


INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0004', '2026-02-28', 'P0019', 'C0008', 5)


INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0005', '2026-08-21', 'P0009', 'C0007', 10)

INSERT INTO Orders (OID, ODATE, PID, CID, OQTY)
VALUES  ('O0006', '2026-12-20', 'P0013', 'C0005', 20)


Select * From Orders

Select * From Stock

Select * From Bill

Select * From Purchase

Update Orders Set OQTY = 8
Where PID = 'P0001'

Update Orders Set OQTY = 22
Where PID = 'P0013'

Insert Into Orders
Values ('O0007', getdate(), 'C0003', 'P0001', 13)

Insert Into Orders
Values ('O0007', getdate(), 'C0004', 'P0018', 22)

Update Orders Set OID = 'O0010'
Where PID = 'P0006'

Delete From Orders
Where OID = 'O0006'

Delete From Orders
Where OID = 'O0007'



-- NEED TO LEARN HOW TO INSERT MULTIPLE ROWS TO ORDERS WITH THE TRIGGERS WORKING FINE
-- THAT IS ALL FOLKS, AUF WIEDERSEHEN!!