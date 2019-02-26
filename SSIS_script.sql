/*
https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-help-job-transact-sql?view=sql-server-2017

To Check SSIS Job Details
*/

use PSRepositorydb
DROP TABLE IF EXISTS ImportExport.RunInstanceLog;
DROP TABLE IF EXISTS ImportExport.RunInstanceLog;
DROP TABLE IF EXISTS MigrationTaskLog;
DROP TABLE IF EXISTS [SSIS Configurations];

/*
To Check SSIS Job Details
*/
USE msdb ;  
GO  
  
EXEC dbo.sp_help_job  
    @job_name = N'ENW_SYS Configuration Deployment';    
GO  

/*
 sp to delete SSIS Job
*/
USE msdb ;  
GO  

EXEC sp_delete_job  
    @job_name = N'DynamicConnection' ;  
GO

/* 
Script to delete Project
*/

use SSISDB
Exec catalog.delete_project @folder_name='SSIS_HRT', @project_name='ConfigurationDatabaseMigration'

Exec Catalog.delete_environment @folder_name='SampleApplication' , @environment_Name =N'Env2';