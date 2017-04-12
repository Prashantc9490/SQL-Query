/*
	Commond to save output in text file.
*/

--Open Command Promant Run Below query

BCP Database-name.dbo.TableName OUT D:\FileName.txt -S[ServerName] -T -c 
--DATABASEName-AsbetaDB
--Table Name ProcNewhires
--ServerName-Enwisen2k8\SQL2012
-- -T trusted Connection

BCP Database-name.dbo.TableName OUT D:\FileName.txt -S[ServerName] -Usa -PTest_1234 -c 
-- -UUserName
-- -P password

