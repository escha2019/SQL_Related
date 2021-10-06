if (exists(select name from sysobjects where name = 'Create_Extract_Staged_dealer_view' and type = 'V'))
	begin
		drop view Create_Extract_Staged_dealer_view;
	end;
go

create view Create_Extract_Staged_dealer_view
as
	select  [DLR_Key] 
			,[DLR_Code] 									
			,[DLR_Name]                                  
			,[DLR_Address] 								
			,[DLR_City]    								
			,[DLR_County]  								
			,[DLR_State]   								
			,[DLR_Country]								
			,[DLR_Zip]									
			,[DLR_Authorized_Makes]
			,[DLR_Independent_Or_Corporate]
			,[DLR_Email_Address]
			,[DLR_Email_Address]
			,[DLR_Initiation_Date]
			,[DLR_Phone_Number]
			,[DLR_Official_Website_ID]
			,[DLR_Official_WebsiteURL]
			,[DLR_Official_WebsiteAdministrator_Email]
			,[DLR_Official_Website_Start_Date]

	from 
			Branch		DEALER

go