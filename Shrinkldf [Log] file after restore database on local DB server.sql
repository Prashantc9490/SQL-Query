/*

We can avoid insufficient memory issue for “Enwisen2k8”  local DB server ,  Shrink .ldf  [Log] file after restore database on local DB server.
*/

USE [Database_Name]; 
GO 
-- Truncate the log by changing the database recovery model to SIMPLE. 

ALTER DATABASE [Database_Name] SET RECOVERY SIMPLE; 

GO -- Shrink the truncated log file to 1 MB. 
DBCC SHRINKFILE (Database_Name _log', 1);

GO -- Reset the database recovery model. 
 ALTER DATABASE [Database_Name] SET RECOVERY FULL;
GO
