	select LastName, SSN, EmailAddress,BirthDate,* from T_cususer Where Accountid not Like 'ENW%'
	--UPDATE T_CUSUSER SET LastName = 'Test' , SSN = NULL ,EmailAddress = NULL, BirthDate  = NULL Where Accountid not Like 'ENW%'


	select EmailAddress from T_cususerlogin
	--UPDATE T_CUSUSERLOGIN SET EmailAddress = NULL


	select LastName,bankAccount1,bankAccount2,bankAccount3,birthDate,homeEmail,nationalID,* from  procnewhires
	--UPDATE PROCNEWHIRES SET LastName = 'Test' ,bankAccount1 = NULL, bankAccount2 = NULL,bankAccount3 = NULL,birthDate = NULL, homeEmail = NULL, nationalID = NULL

	select * from EnvWorkflowStageActions
	--update EnvWorkflowStageActions set emailTo = NULL

	select * from EnvUserWorkflowStageTracking
	--update EnvUserWorkflowStageTracking set emailTo = NULL

	– This is only for V4-3 and above clients
	select SuccessEmailTo,ErrorEmailTo,EmailFrom,EmailCC,TestModeEmail, testmode from envnotifications
	--update envnotifications set SuccessEmailTo = NULL,ErrorEmailTo = NULL,EmailFrom = NULL,EmailCC = NULL,TestModeEmail = NULL, testmode = 'Y'

	– This is only for V4-4 and above clients
	select SuccessEmailTo, ErrorEmailTo from EnvWorkflowTriggerTasks
	--update EnvWorkflowTriggerTasks set SuccessEmailTo = NULL, ErrorEmailTo = NULL