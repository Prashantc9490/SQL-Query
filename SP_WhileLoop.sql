use TestMagic
DECLARE @LoopCounter INT , @MaxEmployeeId INT, 
        @EmployeeName NVARCHAR(100),@DestinationP NVARCHAR(100),@DestinationSP NVARCHAR(100),@SourceP NVARCHAR(100),@SourceSP NVARCHAR(100)

SET @DestinationP ='Sample'
SET @DestinationSP='Oct2019'
SET @SourceP='Sample'
SET @SourceSP='Sample'

SELECT @LoopCounter = min(Id) , @MaxEmployeeId = max(Id) 
FROM Suite where project=@SourceP and SubProject=@SourceSP
WHILE(@LoopCounter IS NOT NULL AND @LoopCounter <= @MaxEmployeeId)	  
	BEGIN
		declare @NewlyGeneratedID table (New_ID int)
	    Insert INTO Suite(Execute$ ,UserId ,TestDescription ,MainBatchPath ,Priority ,Language ,Module ,Build ,TestCycle ,TestEnv ,Impact ,SpecialData ,ScheduleTime ,Remarks ,Project ,SubProject ,PFBuild ,MaxExecTime ,TakeScreenShot ,SeqNo ,TestData ,BrowserName ,MobileDeviceName ,PerformanceTestingScriptFlag ,IsSecurityEnabled ,FeatureFileName ,FailOverFlag ,ProcessOwner)	
		OutPut inserted.Id into @NewlyGeneratedID
		SELECT Execute$ ,UserId ,TestDescription ,MainBatchPath ,Priority ,Language ,Module ,Build ,TestCycle ,TestEnv ,Impact ,SpecialData ,ScheduleTime ,Remarks ,@DestinationP, @DestinationSP ,PFBuild ,MaxExecTime ,TakeScreenShot ,SeqNo ,TestData ,BrowserName ,MobileDeviceName ,PerformanceTestingScriptFlag ,IsSecurityEnabled ,FeatureFileName ,FailOverFlag ,ProcessOwner FROM Suite WHERE Project = @SourceP AND SubProject = @SourceSP and Id = @LoopCounter;
	    insert into SuiteMainBatch(SuiteId,MainBatchName,isSkip)
		Select (Select Max(New_ID) from @NewlyGeneratedID),MainBatchName,isSkip from SuiteMainBatch Where SuiteID=@LoopCounter
		SELECT @LoopCounter  = min(Id) FROM Suite WHERE Id > @LoopCounter and project=@SourceP and Subproject=@SourceSP    
	END
	
	
	
--------------------------------------------
-- SP_
--------------------------------------------
USE [TestMagic]
GO
/****** Object:  StoredProcedure [dbo].[uspCopySubProjectDetails]    Script Date: 10/11/2019 5:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[uspCopySubProjectDetails] (@SourceP nvarchar(30), @SourceSP nvarchar(30),@DestinationP nvarchar(30),@DestinationSP nvarchar(30),@TotalTableCopied INT OUTPUT)
AS
Begin
SET NOCOUNT ON;

	DECLARE @createdDateTime DateTime;
	DECLARE @TableName nvarchar(max); 
	DECLARE @LoopCounter INT;
	DECLARE @MaxCounter INT;
	
	SET @createdDateTime = GETDATE();
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Suite] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		SELECT @LoopCounter = min(Id) , @MaxCounter = max(Id) FROM Suite where project=@SourceP and SubProject=@SourceSP
			WHILE(@LoopCounter IS NOT NULL AND @LoopCounter <= @MaxCounter)	  
			BEGIN
				declare @NewlyGeneratedID table (New_ID int)
			    Insert INTO Suite(Execute$ ,UserId ,TestDescription ,MainBatchPath ,Priority ,Language ,Module ,Build ,TestCycle ,TestEnv ,Impact ,SpecialData ,ScheduleTime ,Remarks ,Project ,SubProject ,PFBuild ,MaxExecTime ,TakeScreenShot ,SeqNo ,TestData ,BrowserName ,MobileDeviceName ,PerformanceTestingScriptFlag ,IsSecurityEnabled ,FeatureFileName ,FailOverFlag ,ProcessOwner)	
				OutPut inserted.Id into @NewlyGeneratedID
				SELECT Execute$ ,UserId ,TestDescription ,MainBatchPath ,Priority ,Language ,Module ,Build ,TestCycle ,TestEnv ,Impact ,SpecialData ,ScheduleTime ,Remarks ,@DestinationP, @DestinationSP ,PFBuild ,MaxExecTime ,TakeScreenShot ,SeqNo ,TestData ,BrowserName ,MobileDeviceName ,PerformanceTestingScriptFlag ,IsSecurityEnabled ,FeatureFileName ,FailOverFlag ,ProcessOwner FROM Suite WHERE Project = @SourceP AND SubProject = @SourceSP and Id = @LoopCounter;
			    insert into SuiteMainBatch(SuiteId,MainBatchName,isSkip)
				Select (Select Max(New_ID) from @NewlyGeneratedID),MainBatchName,isSkip from SuiteMainBatch Where SuiteID=@LoopCounter
				SELECT @LoopCounter  = min(Id) FROM Suite WHERE Id > @LoopCounter and project=@SourceP and Subproject=@SourceSP 
			END
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Module] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO Module (Project,SubProject,ModuleName)
		Select @DestinationP, @DestinationSP, ModuleName from Module where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in Module table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[PFBuild] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO PFBuild (Project,SubProject,PFBuild)
		Select @DestinationP,@DestinationSP,PFBuild from PFBuild where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in PFBuild table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[CommonVariableData] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO CommonVariableData (ScenarioName ,MainBatchName ,Variable ,Value ,French ,Dutch ,Italian ,Remarks ,Project ,SubProject ,EnvDBQuery ,French_EnvDBQuery ,Dutch_EnvDBQuery ,Italian_EnvDBQuery)
		Select ScenarioName ,MainBatchName ,Variable ,Value ,French ,Dutch ,Italian ,Remarks ,@DestinationP,@DestinationSP ,EnvDBQuery ,French_EnvDBQuery ,Dutch_EnvDBQuery ,Italian_EnvDBQuery from CommonVariableData where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in CommonVariableData table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[KeywordData] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO KeywordData (Name ,ObjectName ,InputValue ,ExpectedValue ,Action ,WindowType ,Step_Descriptions ,Remarks ,Project ,SubProject ,PreferenceSearch ,CreateReport ,StepScreenshot)
		Select Name ,ObjectName ,InputValue ,ExpectedValue ,Action ,WindowType ,Step_Descriptions ,Remarks ,@DestinationP,@DestinationSP ,PreferenceSearch ,CreateReport ,StepScreenshot from KeywordData where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in KeywordData table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[KeyWordInfo] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO KeyWordInfo (Name ,Project ,SubProject ,Status ,ReadOnly ,FolderName ,IsCompilerError ,CurrentUser ,Max_Version)
		Select Name ,@DestinationP,@DestinationSP ,Status ,ReadOnly ,FolderName ,IsCompilerError ,CurrentUser ,Max_Version from KeyWordInfo where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in KeyWordInfo table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[MainBatchData] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO MainBatchData (Name ,KeywordDrivenTestDataPath ,IterationCountForSameData ,IterationCountForDifferentData ,Project ,SubProject ,isSkip ,Remarks ,ReadOnly ,SeqNo ,isLooped ,IsBCParallel ,IsLoginAuthenticated)
		Select Name ,KeywordDrivenTestDataPath ,IterationCountForSameData ,IterationCountForDifferentData ,@DestinationP,@DestinationSP ,isSkip ,Remarks ,ReadOnly ,SeqNo ,isLooped ,IsBCParallel ,IsLoginAuthenticated from MainBatchData where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in MainBatchData table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[ProjectConfig] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO ProjectConfig (Project ,SubProject ,Url ,VerificationEmailFlag ,VerificationEmailId ,ErrorEmailId ,EmailSubject ,VerificationMsg ,ErrorMsg ,CreatedDate ,ModifiedDate ,CitrixFlag ,DefectCustomizeFields)
		Select @DestinationP,@DestinationSP ,Url ,VerificationEmailFlag ,VerificationEmailId ,ErrorEmailId ,EmailSubject ,VerificationMsg ,ErrorMsg ,CreatedDate ,ModifiedDate ,CitrixFlag ,DefectCustomizeFields from ProjectConfig where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in ProjectConfig table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[Requirement] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO Requirement (ReqNo, ReqName ,ReqSummary ,ReqDesc ,Author ,Priority ,Type ,Version ,Remarks ,CreatDateTime ,Project ,SubProject ,UpdateLog)
		Select ReqNo,ReqName ,ReqSummary ,ReqDesc ,Author ,Priority ,Type ,Version ,Remarks ,CreatDateTime ,@DestinationP,@DestinationSP ,UpdateLog from Requirement where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in Requirement table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[RequirementAttach] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO RequirementAttach (Version ,Project ,SubProject ,Attachment ,FileExtension)
		Select Version ,@DestinationP,@DestinationSP ,Attachment ,FileExtension from RequirementAttach where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in RequirementAttach table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[RestService] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO RestService (ServiceUrl ,ResourceUrl ,UrlParameter ,PacketFormat ,Method ,ServiceUserName ,ServicePassword ,ProxyServer ,ProxyPort ,ProxyUser ,ProxyPassword ,RequestParameters ,RequestPacket ,ResponsePacket ,ResponseHeaders ,WebServiceName ,BusinessComponentName ,Project ,SubProject ,IsResposeCompare ,ResponseInVariable ,JsonExtractorQuery ,JsonExtractorFilePath ,AuthorizationType ,AuthorizationName)
		SELECT ServiceUrl ,ResourceUrl ,UrlParameter ,PacketFormat ,Method ,ServiceUserName ,ServicePassword ,ProxyServer ,ProxyPort ,ProxyUser ,ProxyPassword ,RequestParameters ,RequestPacket ,ResponsePacket ,ResponseHeaders ,WebServiceName ,BusinessComponentName ,@DestinationP,@DestinationSP ,IsResposeCompare ,ResponseInVariable ,JsonExtractorQuery ,JsonExtractorFilePath ,AuthorizationType ,AuthorizationName From RestService where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in RestService table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[RestServiceHistory] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO RestServiceHistory (ServiceUrl ,ResourceUrl ,UrlParameter ,PacketFormat ,Method ,ServiceUserName ,ServicePassword ,ProxyServer ,ProxyPort ,ProxyUser ,ProxyPassword ,RequestParameters ,RequestPacket ,ResponsePacket ,ResponseHeaders ,WebServiceName ,BusinessComponentName ,Project ,SubProject ,IsResposeCompare ,ResponseInVariable ,WSVersion)
		SELECT ServiceUrl ,ResourceUrl ,UrlParameter ,PacketFormat ,Method ,ServiceUserName ,ServicePassword ,ProxyServer ,ProxyPort ,ProxyUser ,ProxyPassword ,RequestParameters ,RequestPacket ,ResponsePacket ,ResponseHeaders ,WebServiceName ,BusinessComponentName ,@DestinationP,@DestinationSP ,IsResposeCompare ,ResponseInVariable ,WSVersion From RestServiceHistory where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in RestServiceHistory table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[RestServiceVersionMapping] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO RestServiceVersionMapping (Project ,SubProject ,ServiceName ,BusinessCompName ,WSVersion ,BCVersion)
		SELECT @DestinationP,@DestinationSP ,ServiceName ,BusinessCompName ,WSVersion ,BCVersion From RestServiceVersionMapping where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in RestServiceVersionMapping table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[TestEnvSkip] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO TestEnvSkip (BusinessCompID ,MainBatchName ,isSkip ,IterationCountForSameData ,IterationCountForDifferentData ,Project ,SubProject ,isLooped)
		SELECT BusinessCompID ,MainBatchName ,isSkip ,IterationCountForSameData ,IterationCountForDifferentData ,@DestinationP,@DestinationSP ,isLooped From TestEnvSkip where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in TestEnvSkip table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[UserInfo] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO UserInfo (UserID ,Passwd ,Role ,Tool ,Email ,Project ,SubProject ,Project_ID ,Remarks ,AdminReadOnlyPassword ,ReadOnlyPrivileges ,DeletePrivileges ,PowerTesterPrivileges)
		SELECT UserID ,Passwd ,Role ,Tool ,Email ,@DestinationP,@DestinationSP ,Project_ID ,Remarks ,AdminReadOnlyPassword ,ReadOnlyPrivileges ,DeletePrivileges ,PowerTesterPrivileges From UserInfo where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in UserInfo table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[WebService] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO WebService (Url ,Username ,Password ,RequestPacket ,ResponsePacket ,IsXmlTemplate ,IsArbitary ,IsParallel ,Project ,SubProject ,ServiceName ,BusinessCompName ,FinalResponse ,MethodName ,ProxyServer ,ProxyPort ,AuthUsername ,AuthPassword ,Headers ,TemplateFilePath ,IsResposeCompare ,EndPointUrl ,WSSPasswordType ,ResponseHeader ,ResponseInVariable ,WSSHeader ,WSSMustUnderstand ,Encoding ,Binding ,IsMQ ,QueueManager ,InputQueue ,OutputQueue ,MQTemplateFilePath ,ChannelInfo ,OutputQueueManager ,IsRemote ,IsDB ,DatasetLocation ,BPWName ,DatasetNumber ,IsExcel ,DatasetPath ,ExcelSheetName ,VariableRowNum ,ValueRowNum ,IsNone ,ResponseXmlTemplate ,IsResponseTemplate ,ReadType ,IsFileAttachment ,AttachedFilePath)
		SELECT Url ,Username ,Password ,RequestPacket ,ResponsePacket ,IsXmlTemplate ,IsArbitary ,IsParallel ,@DestinationP,@DestinationSP ,ServiceName ,BusinessCompName ,FinalResponse ,MethodName ,ProxyServer ,ProxyPort ,AuthUsername ,AuthPassword ,Headers ,TemplateFilePath ,IsResposeCompare ,EndPointUrl ,WSSPasswordType ,ResponseHeader ,ResponseInVariable ,WSSHeader ,WSSMustUnderstand ,Encoding ,Binding ,IsMQ ,QueueManager ,InputQueue ,OutputQueue ,MQTemplateFilePath ,ChannelInfo ,OutputQueueManager ,IsRemote ,IsDB ,DatasetLocation ,BPWName ,DatasetNumber ,IsExcel ,DatasetPath ,ExcelSheetName ,VariableRowNum ,ValueRowNum ,IsNone ,ResponseXmlTemplate ,IsResponseTemplate ,ReadType ,IsFileAttachment ,AttachedFilePath From WebService where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in WebService table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[WebServiceVersionMapping] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO WebServiceVersionMapping (Project ,SubProject ,ServiceName ,BusinessCompName ,WSVersion ,BCVersion)
		SELECT @DestinationP,@DestinationSP ,ServiceName ,BusinessCompName ,WSVersion ,BCVersion From WebServiceVersionMapping where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in WebServiceVersionMapping table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	IF NOT EXISTS (SELECT 1 FROM [dbo].[WSAuth2Token] WHERE Project = @DestinationP AND SubProject = @DestinationSP)
	Begin
		Insert INTO WSAuth2Token (TokenName ,CallbackURL ,AuthURL ,AccessTokenURL ,ClientID ,ClientSecret ,Scope ,GrantType ,Project ,SubProject ,ResponseValues)
		SELECT TokenName ,CallbackURL ,AuthURL ,AccessTokenURL ,ClientID ,ClientSecret ,Scope ,GrantType ,Project ,SubProject ,ResponseValues From WSAuth2Token where Project=@SourceP and SubProject=@SourceSP
		IF @@ROWCOUNT=  0
	        PRINT 'No data found in WSAuth2Token table with Project '+ @SourceP +'and Subproject'+ @SourceSP;	
	End
	
	SELECT @TotalTableCopied = @@ROWCOUNT;

End