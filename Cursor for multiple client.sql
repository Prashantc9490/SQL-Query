/*
    Purpose : Execute Attachment Script for onborading 4.8.2.1 clients
    Author : Shraddha S
    Created Date : 11 /28/2016    
*/

DECLARE @CurrentDate AS nvarchar(50)
DECLARE @intErrorCode INT
DECLARE @MatchCode AS Nvarchar(100)

DECLARE @subscriberId int
	, @smartWareAreaId uniqueidentifier
	, @formTemplateId uniqueidentifier
	, @reportTemplateId uniqueidentifier
	, @portalId uniqueidentifier
	, @StepDescription NVARCHAR(MAX)
	
DECLARE @EnwisenAdminGroupID uniqueidentifier
DECLARE @BasicAccessGroupID uniqueidentifier
DECLARE @OBAdminAccessGroupID uniqueidentifier
DECLARE @OBManagerGroupID uniqueidentifier
DECLARE @OBRecruiterGroupID uniqueidentifier

DECLARE @TableName	NVARCHAR(200)
	, @ColumnName	NVARCHAR(200)
	, @DataType	NVARCHAR(200)
	, @MaxLength INT;
DECLARE @SubscriberDBName varchar(50)
DECLARE @sql varchar(8000)
DECLARE portalcursor CURSOR FAST_FORWARD READ_ONLY FOR
SELECT MatchCode+'DB' FROM [ASI2.0MasterDB_AA].DBO.T_cbeOrganization JOIN master.dbo.sysdatabases  d on d.name = MatchCode+'DB' where d.name='asbeta'
ORDER BY MatchCode
OPEN portalcursor
WHILE 1 = 1
BEGIN

BEGIN TRY
  FETCH NEXT FROM portalcursor INTO @SubscriberDBName
  IF @@FETCH_STATUS <> 0
    BREAK
  PRINT '----------------------------------------------------------------------------------------------------'
  PRINT 'Selecting FROM '+@SubscriberDBName 
 SET @sql ='
		IF EXISTS (SELECT COLUMN_NAME FROM ['+@SubscriberDBName+'].INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''ProcConfig'' ) 
		BEGIN		
		  If ((Select configValue from ['+@SubscriberDBName+'].dbo.ProcConfig where ConfigName = + ''OBVersion'') = ''4.8.2.1'')
			BEGIN
				-- Attachment code  

BEGIN		
            IF EXISTS (SELECT COLUMN_NAME FROM ['+@SubscriberDBName+'].INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''EnvUserAttachments'' ) 
			BEGIN
				PRINT ''Table EnvUserAttachments already exists''
			END
			ELSE
			BEGIN
				CREATE TABLE [dbo].[EnvUserAttachments](
					[ID] [int] IDENTITY(1,1) NOT NULL,
					[UserID] [nvarchar](100) NOT NULL,
					[UserProcessID] [int] NOT NULL,
					[AttachmentTitle] [nvarchar](200) NULL,
					[FileLocation] [nvarchar](200) NULL,
					[CreatedBy] [nvarchar](100) NULL,
					[CreatedDateTime] [datetime] NULL,
					[FileType] [varchar](6) NULL,
			PRIMARY KEY CLUSTERED 
			(
			[ID] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]
				PRINT ''EnvUserAttachments table created.''
			END


/******************* Register Patterns IN Library ********************************/
DECLARE @StepDescription NVARCHAR(MAX),
		@subscriberId int
	, @smartWareAreaId uniqueidentifier
	, @formTemplateId uniqueidentifier
	, @reportTemplateId uniqueidentifier
	, @portalId uniqueidentifier;
	


PRINT ''--------------------------------------------------------------------------------------------''
SELECT @StepDescription = ''Inserting Patterns in Index Table[IndexMode=0]''
PRINT @StepDescription 

SET @subscriberId = (SELECT top 1 RefId FROM ['+@SubscriberDBName+'].[dbo].T_cbeOrganization)
SET @smartWareAreaId = (SELECT TOP 1 ID FROM ['+@SubscriberDBName+'].[dbo].T_cplArea WHERE MatchCode = ''SmartWare'')
SET @portalId = (SELECT top 1 ID FROM ['+@SubscriberDBName+'].[dbo].T_cbePortal)
SET @reportTemplateId = (SELECT top 1 ID FROM ['+@SubscriberDBName+'].[dbo].T_cplTemplate WHERE TemplateName = ''Report'')
SET @formTemplateId = (SELECT top 1 ID FROM ['+@SubscriberDBName+'].[dbo].T_cplTemplate WHERE TemplateName = ''V2_Forms'')

INSERT INTO [dbo].[T_cplIndex] ([ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords])
SELECT [ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords] 
FROM (
	
	SELECT ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentMainConsole'' AS [PatternCode], ''Attachment main console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentMainConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-r-AttachmentReport'' AS [PatternCode], ''Attachment report tour level'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-r-attachmentReport.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]	UNION ALL
	SELECT ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentConsole'' AS [PatternCode], ''Attachment console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-Attachment'' AS [PatternCode], ''Attachment form'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-f-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-console-r-Attachment'' AS [PatternCode], ''Admin console report'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/AllConsoles/pf-console-r-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''80464BAA-A8B3-4E6A-B911-D60B65630FC7'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-DeleteFiles'' AS [PatternCode], ''Attachment Delete Files'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/V2-4-2/TourProcessor/pf-tour-f-DeleteFiles.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''pf-tour-f-DeleteFiles'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],0 AS [UseSSL], 0 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]
) OB
WHERE OB.[ID] NOT IN (SELECT [ID] FROM [T_cplIndex])

PRINT ''--------------------------------------------------------------------------------------------''
SELECT @StepDescription = ''Inserting Patterns IN Index Table[IndexMode=1]''
PRINT @StepDescription 

INSERT INTO [dbo].[T_cplIndex] ([ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords])
SELECT [ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords] 
FROM (
	
	SELECT ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentMainConsole'' AS [PatternCode], ''Attachment main console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentMainConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-r-AttachmentReport'' AS [PatternCode], ''Attachment report tour level'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-r-attachmentReport.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]	UNION ALL
	SELECT ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentConsole'' AS [PatternCode], ''Attachment console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-Attachment'' AS [PatternCode], ''Attachment form'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-f-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-console-r-Attachment'' AS [PatternCode], ''Admin console report'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/AllConsoles/pf-console-r-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''80464BAA-A8B3-4E6A-B911-D60B65630FC7'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-DeleteFiles'' AS [PatternCode], ''Attachment Delete Files'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/V2-4-2/TourProcessor/pf-tour-f-DeleteFiles.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''pf-tour-f-DeleteFiles'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],0 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]
) OB
WHERE OB.[ID] NOT IN (SELECT [ID] FROM [T_cplIndex])


PRINT ''--------------------------------------------------------------------------------------------''
SELECT @StepDescription = ''Inserting Patterns IN Index Table[IndexMode=1]''
PRINT @StepDescription 


INSERT INTO [dbo].[T_cplIndex] ([ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords])
SELECT [ID],[SubscriberID],[AliasName],[PatternCode],[PatternName],[PatternType],[PatternPath],[AreaName],[PlanTypeID],[PlanTypeName],[PlanID],[PlanName],[HomeTopicID],[CategoryID],[SubCategoryID],[Notes],[Description],[Creator],[ExpirationDate],[IsStatus],[SearchDirectory],[AreaID],[TemplateID],[LastEditDate],[PortalID],[ListingOrder],[OpenInNewWindow],[UseSSL],[IndexMode],[CreatedDateTime],[ExcludeFromBreadcrumb],[isCustom],[Version],[ExcludeFromSiteMap],[ExcludeFromSearch],[Keywords] 
FROM (
	
	SELECT ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentMainConsole'' AS [PatternCode], ''Attachment main console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentMainConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-r-AttachmentReport'' AS [PatternCode], ''Attachment report tour level'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-r-attachmentReport.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]	UNION ALL
	SELECT ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-c-AttachmentConsole'' AS [PatternCode], ''Attachment console'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-c-attachmentConsole.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-Attachment'' AS [PatternCode], ''Attachment form'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/TourProcessor/pf-tour-f-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-console-r-Attachment'' AS [PatternCode], ''Admin console report'' AS [PatternName], 3 AS [PatternType], ''/Patterns/ProcessFramework/v2-4-2/AllConsoles/pf-console-r-Attachment.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''ProcessFramework'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @reportTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],1 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords] UNION ALL
	SELECT ''80464BAA-A8B3-4E6A-B911-D60B65630FC7'' AS [ID], @subscriberId AS subscriberId, NULL AS [AliasName], ''pf-tour-f-DeleteFiles'' AS [PatternCode], ''Attachment Delete Files'' AS [PatternName], 2 AS [PatternType], ''/Patterns/ProcessFramework/V2-4-2/TourProcessor/pf-tour-f-DeleteFiles.xml'' AS [PatternPath], NULL AS [AreaName], 0 AS [PlanTypeID], NULL AS [PlanTypeName], 0 AS [PlanID], ''pf-tour-f-DeleteFiles'' AS [PlanName], 0 AS [HomeTopicID], 0 AS [CategoryID], 0 AS [SubCategoryID], NULL AS [NOTes], NULL AS [Description], NULL AS [Creator], NULL AS [ExpirationDate], 0 AS [IsStatus], ''D:\Search'' AS [SearchDirectory], @smartWareAreaId AS [AreaID], @formTemplateId AS [TemplateID], NULL AS [LastEditDate], @portalId AS [PortalID], 0 AS [ListingOrder], 0 AS [OpeninNewWindow],0 AS [UseSSL], 1 AS [indexMode], GETDATE() AS [createdDateTime], 0 AS [ExcludeFROMBreadcrumb], 0 AS [isCustom], NULL AS [Version], 0 AS [ExcludeFROMSiteMap], 0 AS [ExcludeFROMSearch], NULL AS [Keywords]
) OB
WHERE OB.[ID] NOT IN (SELECT [ID] FROM [T_cplIndex])

/***************************************************************************************************************************************************************************************************************************************
*	Insert Enwisen Group data into T_cbaAccessControlList for all patterns that were created new 
***************************************************************************************************************************************************************************************************************************************/
PRINT ''
PRINT ''--------------------------------------------------------------------------------------------''
PRINT ''Adding Enwisen group to T_cbaAccessControlList for certain new patterns (AS needed)''

INSERT INTO [T_cbaAccessControlList]([ID],[RequestingObjectClassID],[RequestingObjectID],[GrantingObjectClassID],[GrantingObjectID],[GrantedRights],[Namespace],[CreatedDateTime])
SELECT [ID],[RequestingObjectClassID],[RequestingObjectID],[GrantingObjectClassID],[GrantingObjectID],[GrantedRights],[Namespace],[CreatedDateTime]
FROM ( 
	/* Onboarding Attachment Console - pf-tour-c-AttachmentMainConsole */
	SELECT NEWID() AS [ID] , ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] , @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [GrantingObjectID], '''' AS [GrantedRights] , ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	SELECT NEWID() AS [ID] , ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] , @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [GrantingObjectID], '''' AS [GrantedRights] , ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	/* Onboarding Attachment Admin Console - pf-tour-r-AttachmentReport */
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	/* Onboarding Attachment Report - pf-tour-c-AttachmentConsole */
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	/* Onboarding Attachment Form - pf-tour-f-Attachment */
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	/* Onboarding Attachment Form - pf-console-r-Attachment */                                                                                                                                        
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]  UNION ALL

	/* Onboarding Attachment Form - pf-tour-f-DeleteFiles */
	SELECT NEWID() AS [ID], ''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID], @EnwisenAdminGroupID AS [RequestingObjectID], ''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''80464BAA-A8B3-4E6A-B911-D60B65630FC7'' AS [GrantingObjectID], '''' AS [GrantedRights], ''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]
	) newPatterns
WHERE newPatterns.[GrantingObjectID] NOT IN 
(
	SELECT [GrantingObjectID] FROM [T_cbaAccessControlList] WHERE RequestingObjectID = @EnwisenAdminGroupID
)

/***************************************************************************************************************************************************************************************************************************************
*	Insert Basic Access Group data into T_cbaAccessControlList for all patterns that were created new 
***************************************************************************************************************************************************************************************************************************************/
			
SET @BasicAccessGroupID = (SELECT ID FROM [dbo].T_cusGroup WHERE MatchCode LIKE ''BasicAccess'')
IF @BasicAccessGroupID IS NOT NULL
BEGIN
	PRINT ''
	PRINT ''--------------------------------------------------------------------------------------------''
	PRINT ''Adding Basic Access group to T_cbaAccessControlList for certain new patterns (AS needed)''
		
		
		INSERT INTO [dbo].[T_cbaAccessControlList]([ID] ,[RequestingObjectClassID],[RequestingObjectID],[GrantingObjectClassID],[GrantingObjectID],[GrantedRights],[Namespace],[CreatedDateTime])				
	SELECT [ID] ,[RequestingObjectClassID],[RequestingObjectID],[GrantingObjectClassID],[GrantingObjectID],[GrantedRights],[Namespace],[CreatedDateTime]
	FROM (
			/* Onboarding Attachment Console - pf-tour-c-AttachmentMainConsole */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			/* Onboarding Attachment Admin Console -  pf-tour-r-AttachmentReport */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			/* Onboarding Attachment Report - pf-tour-c-AttachmentConsole */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			/* Onboarding Attachment Form - pf-tour-f-Attachment */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			/* Onboarding Attachment Form - pf-console-r-Attachment */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL			
			/* Onboarding Attachment Form -  pf-tour-f-DeleteFiles */
			SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestingObjectClassID] ,@BasicAccessGroupID AS [RequestingObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantingObjectClassID], ''80464BAA-A8B3-4E6A-B911-D60B65630FC7'' AS [GrantingObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]
	
			) newPatterns
			WHERE newPatterns.[GrantingObjectID] NOT IN 
			(
				SELECT [GrantingObjectID] FROM [T_cbaAccessControlList] WHERE [RequestingObjectID] = @BasicAccessGroupID 
			)
END

SET @OBAdminAccessGroupID = (SELECT ID FROM [dbo].T_cusGroup WHERE MatchCode LIKE ''OBAdmin'')
IF @OBAdminAccessGroupID IS NOT null
BEGIN
/***************************************************************************************************************************************************************************************************************************************
*	Insert OBAdmin Group data INto T_cbaAccessControlList for all patterns that were created new 
***************************************************************************************************************************************************************************************************************************************/
PRINT ''
PRINT ''--------------------------------------------------------------------------------------------''
PRINT ''Adding OBAdmin group to T_cbaAccessControlList for certaIN new patterns (AS needed)''

INSERT INTO [dbo].[T_cbaAccessControlList]([ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime])				
SELECT [ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime]
FROM (
		/* OnboardINg Attachment Console - pf-tour-c-AttachmentMaINConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment AdmIN Console -  pf-tour-r-AttachmentReport */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Report - pf-tour-c-AttachmentConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-tour-f-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-console-r-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBAdminAccessGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]
		) newPatterns
		WHERE newPatterns.[GrantINgObjectID] NOT IN 
		(
			SELECT [GrantINgObjectID] FROM [T_cbaAccessControlList] WHERE [RequestINgObjectID] = @OBAdminAccessGroupID 
		)
END	


DECLARE @OBManagerGroupID uniqueidentifier
SET @OBManagerGroupID = (SELECT ID FROM [dbo].T_cusGroup WHERE MatchCode LIKE ''OBManager'')
IF @OBManagerGroupID IS NOT null
BEGIN
/***************************************************************************************************************************************************************************************************************************************
*	Insert OBManager Group data INto T_cbaAccessControlList for all patterns that were created new 
***************************************************************************************************************************************************************************************************************************************/
PRINT ''
PRINT ''--------------------------------------------------------------------------------------------''
PRINT ''Adding OBManager group to T_cbaAccessControlList for certaIN new patterns (AS needed)''
	

	INSERT INTO [dbo].[T_cbaAccessControlList]([ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime])				
SELECT [ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime]
FROM (
		/* OnboardINg Attachment Console - pf-tour-c-AttachmentMaINConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment AdmIN Console -  pf-tour-r-AttachmentReport */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Report - pf-tour-c-AttachmentConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-tour-f-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-console-r-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBManagerGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]
		) newPatterns
		WHERE newPatterns.[GrantINgObjectID] NOT IN 
		(
			SELECT [GrantINgObjectID] FROM [T_cbaAccessControlList] WHERE [RequestINgObjectID] = @OBManagerGroupID 
		)
END	

SET @OBRecruiterGroupID = (SELECT ID FROM [dbo].T_cusGroup WHERE MatchCode LIKE ''OBRecruiter'')
IF @OBRecruiterGroupID IS NOT null
BEGIN
/***************************************************************************************************************************************************************************************************************************************
*	Insert OBRecruiter Group data INto T_cbaAccessControlList for all patterns that were created new 
***************************************************************************************************************************************************************************************************************************************/
PRINT ''
PRINT ''--------------------------------------------------------------------------------------------''
PRINT ''Adding OBRecruiter group to T_cbaAccessControlList for certaIN new patterns (AS needed)''


INSERT INTO [dbo].[T_cbaAccessControlList]([ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime])				
SELECT [ID] ,[RequestINgObjectClassID],[RequestINgObjectID],[GrantINgObjectClassID],[GrantINgObjectID],[GrantedRights],[Namespace],[CreatedDateTime]
FROM (
		/* OnboardINg Attachment Console - pf-tour-c-AttachmentMaINConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7AB076D2-3163-459C-84DF-AF261A8C22A5'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''B604E39F-7BB6-4A18-99CD-4A2EB610143B'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment AdmIN Console -  pf-tour-r-AttachmentReport */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''63154189-6AD4-4B0E-95D3-3FD700667470'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''7233B320-077D-43D1-9535-A0B1E0934D88'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Report - pf-tour-c-AttachmentConsole */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''74165244-138A-4EF7-89B6-EABC6305ADFE'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''BF03E241-FD3A-4059-AAB2-74FD5BD64EBB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-tour-f-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''DA2D1A14-3067-45BE-8CCC-D5B39D83A27A'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''0683DA1E-5AE2-4F77-8A2A-6AE7527210DB'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		/* OnboardINg Attachment Form - pf-console-r-Attachment */
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940734'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime] UNION ALL
		SELECT NEWID() AS [ID] ,''5D431095-E733-4F42-A4CA-B8F6953C6C76'' AS [RequestINgObjectClassID] ,@OBRecruiterGroupID AS [RequestINgObjectID],''471E61DF-7B93-452C-BC94-7D96098AC007'' AS [GrantINgObjectClassID], ''048F616A-85E8-4AFF-83CF-6D6299940735'' AS [GrantINgObjectID],'''' AS [GrantedRights] ,''Default'' AS [Namespace],GETDATE() AS [CreatedDateTime]
		) newPatterns
		WHERE newPatterns.[GrantINgObjectID] NOT IN 
		(
			SELECT [GrantINgObjectID] FROM [T_cbaAccessControlList] WHERE [RequestINgObjectID] = @OBRecruiterGroupID 
		)
END	


SET @ColumnName = NULL
SET @MaxLength = NULL
SELECT @ColumnName = COLUMN_NAME, @MaxLength = CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = ''EnvProcesses'' AND COLUMN_NAME = ''IsAttachmentEnable''
IF @ColumnName IS NULL 
BEGIN
	ALTER TABLE EnvProcesses ADD IsAttachmentEnable BIT NULL
	PRINT ''IsAttachmentEnable column Added''
END
ELSE PRINT ''IsAttachmentEnable Column already exists''


	
SET @ColumnName = NULL
SET @MaxLength = NULL
SELECT @ColumnName = COLUMN_NAME, @MaxLength = CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_NAME = ''EnvProcesses'' AND COLUMN_NAME = ''MaxNumberOfAttachments''
IF @ColumnName IS NULL 
BEGIN
	ALTER TABLE EnvProcesses ADD MaxNumberOfAttachments INT
	PRINT ''MaxNumberOfAttachments column Added''
END
ELSE PRINT ''MaxNumberOfAttachments Column already exists''

IF Exists(SELECT 1 FROM ProcConfig WHERE ConfigName = ''AttachmentMaxFileSize'')	
	PRINT ''AttachmentMaxFileSize record already exists''	
ELSE
BEGIN 
	INSERT INTO ProcConfig (ConfigName,ConfigDesc,configValue)
	VALUES(''AttachmentMaxFileSize'',''Allowed maximum size in KB for a single attachment. You must have Infor Cloud team approval to Increase size.'',''5000'')
	PRINT ''Inserted AttachmentMaxFileSize record in the ProcConfig table''
END	


/***************************************************************************************************************************************************************************************************************************************
*	Insert pattern parent app data into [t_utilSwAppPatterns] for all patterns which were created new with this version
***************************************************************************************************************************************************************************************************************************************/
	PRINT ''
	PRINT ''--------------------------------------------------------------------------------------------''
	PRINT ''updating pattern to app assignments (AS needed)''
	INSERT INTO [dbo].[t_utilSwAppPatterns] ([AppID],[PatternCode],[CreatedDateTime])
	SELECT [AppID],[PatternCode],[CreatedDateTime]
	FROM (
	    -- Tour Processor
		SELECT ''1C157D91-B042-409F-A20F-4C097A412481'' AS AppId, ''pf-tour-c-AttachmentMainConsole'' AS PatternCode, GETDATE()  AS CreatedDateTime UNION ALL
		SELECT ''1C157D91-B042-409F-A20F-4C097A412481'' AS AppId, ''pf-tour-r-AttachmentReport'' AS PatternCode, GETDATE()  AS CreatedDateTime UNION ALL
		SELECT ''1C157D91-B042-409F-A20F-4C097A412481'' AS AppId, ''pf-tour-c-AttachmentConsole'' AS PatternCode, GETDATE()  AS CreatedDateTime UNION ALL
		SELECT ''1C157D91-B042-409F-A20F-4C097A412481'' AS AppId, ''pf-tour-f-Attachment'' AS PatternCode, GETDATE()  AS CreatedDateTime 	Union All
		-- All Consoles 
		SELECT ''13065226-BDA9-4DCC-8D84-769BD8846D73'' AS AppId, ''pf-console-r-Attachment'' AS PatternCode, GETDATE()  AS CreatedDateTime

	) newPatterns	 
	WHERE newPatterns.patternCode NOT IN (SELECT patternCode FROM [t_utilSwAppPatterns])		
END	
PRINT ''------------------------------------------''    
				print ''procconfig present''


			END
		End
		Else
		BEGIN
			Print ''procconfig not present''
		End'				
  print(@sql)  		
END TRY    

BEGIN CATCH
	PRINT CHAR(13)
	PRINT 'Exception occurred while Executing Attachment Scripts:-'
	PRINT 'Error Number:   ' + CAST(ERROR_NUMBER() AS VARCHAR(10))
	PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
	PRINT 'Error Message:  ' + ERROR_MESSAGE()
	PRINT '--------------------------------------------------'
END CATCH   
END
CLOSE portalcursor
DEALLOCATE portalcursor