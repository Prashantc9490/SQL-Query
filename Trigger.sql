USE AMS
IF EXISTS (select * from sys.triggers where name = 'update_User_table')
BEGIN
	DROP TRIGGER update_User_table
END
GO
CREATE TRIGGER update_User_table ON Staff
AFTER INSERT
AS
BEGIN
    INSERT INTO 
    Users
    (
      [UserName],[Passward],[FullName],[StaffID],[IsAdmin],[IsEnabled],[CreatedBy]
      ,[CreatedOn],[ModifiedBy],[ModifiedOn]
    )
    SELECT top 1
        [StaffName],[SectionPID],[StaffName],[StaffID],0,[IsActive],[CreatedBy],[CreatedOn]
		,[ModifiedBy],[ModifiedOn]		
    FROM 
        Staff order by CreatedOn desc		
END 
GO