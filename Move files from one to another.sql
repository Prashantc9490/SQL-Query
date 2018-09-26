 --Let's check physical location for the database:
 
 SELECT * FROM TESTLDB.sys.database_files

--TestLDB	C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER2016\MSSQL\DATA\TestLDB.mdf
--TestLDB_log	C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER2016\MSSQL\DATA\TestLDB_log.ldf

--Next process is to make database Offline:

Alter Database TESTLDB  set OFFLINE;

--Move files to new location
--1) Go to the default location, Cut those files and paste it in the destinaltion.
--2) Suppose i need to move my files from C to E in the Testdb folder
--3) Alter database and modify their path

Alter Database TestLDB Modify File ( Name ='TestLDB' ,FileName = 'E:\testdb\TestLDB.mdf')

Go


Alter Database TestLDB Modify File ( Name ='TestLDB_log' ,FileName = 'E:\testdb\TestLDB_log.ldf')

Go

--Start the database:

Alter database TestLDB set ONLINE;

Go

--If you face following error: Unable to open the physical file . Operating system error 5: "5(Access is denied.)".
--Just check whether you have right to modify mdf and ldf, if not them give permission to your account.
-- Try to make your db online.





