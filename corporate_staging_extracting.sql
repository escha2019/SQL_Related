--001_Create_Extract_Branch.sql

if (exists(select name from sysobjects where name = 'Extract_Branch' and type = 'V'))
	begin
		drop view Extract_Branch;
	end;
go

create view Extract_Branch
as
	select
			BR_County	as DLR_County,
			BR_Country	as DLR_Country,
			BR_Address	as DLR_Address,
			BR_City		as DLR_City,
			BR_State	as DLR_State,
			BR_Zip		as DLR_Zip,
			BR_Phone	as DLR_Phone,
			BR_ID		as BR_ID
	from
			Branch		DEALER

go

--- 001_create_stage_branch

if (exists(select name from sysobjects where name = 'Stage_Branch' and type = 'U'))
	begin
		drop table Stage_Branch;
	end
go

create table Stage_Branch
	(
	BR_County	varchar(60)					not null,
	BR_Country	varchar(60)					not null,
	BR_Address	varchar(200)				not null,
	BR_City		varchar(60)					not null,
	BR_State	varchar(2)					not null,
	BR_Zip		varchar(10)					not null,
	BR_Phone	varchar(20)					not null,
	BR_ID		smallint	identity(1,1)	not null,
	CONSTRAINT PK_Stage_Branch PRIMARY KEY CLUSTERED (BR_ID ASC)
	);
go

--001_Create_Extract_corporate
if (exists(select name from sysobjects where name = 'Extract_Corporate' and type = 'V'))
	begin
		drop view Extract_Corporate;
	end;
go

create view Extract_Corporate
as
	select
			CD_Name		as DLR_Name,
			DLR_Type	as DLR_Independent_Or_Corporate,
			DLR_ID		as DLR_Code,
			DLR_Email	as DLR_Email_Address,
			DLR_Since	as DLR_Initiation_Date,
			BR_ID		as BR_ID,
			WEB_ID		as WEB_ID
			
	from
			Corporate		CORP
go

---create_stage_corporate

if (exists(select name from sysobjects where name = 'Stage_Corporate' and type = 'U'))
	begin
		drop table Stage_Corporate;
	end
go

create table Stage_Corporate
	(
	CD_Name		varchar(200)						not null,
	DLR_Type	varchar(1)							not null,
	DLR_ID		smallint		identity(1,1)		not null,
	DLR_Email	varchar(256)						not null,
	DLR_Since	datetime							not null,
	BR_ID		smallint							not null,
	WEB_ID		smallint							not null,
	CONSTRAINT PK_Stage_Corporate PRIMARY KEY CLUSTERED (DLR_ID ASC)
	);
go

---create_stage_website

if (exists(select name from sysobjects where name = 'Extract_Website' and type = 'V'))
	begin
		drop view Extract_Website;
	end;
go

create view Extract_Website
as
	select
			WEB_ID			as DLR_Official_Website_ID,
			WEB_URL			as DLR_Official_WebsiteURL,
			WEB_Admin		as DLR_Official_WebsiteAdministrator_Email,
			WEB_Start_Date	as DLR_Official_Website_Start_Date
			
	from
			Website		WEB
go

--create_stage_website

if (exists(select name from sysobjects where name = 'Stage_Website' and type = 'U'))
	begin
		drop table Stage_Website;
	end
go

create table Stage_Website
	(
	WEB_ID			smallint	identity(1,1)	not null,	
	WEB_URL			varchar(256)				not null,
	WEB_Admin		varchar(256)				not null,
	WEB_Start_Date	datetime					not null,
	CONSTRAINT PK_Stage_Website PRIMARY KEY CLUSTERED (WEB_ID ASC)
	);
go

---004_Create_Extract_Owner_Address.sql

if (exists(select name from sysobjects where name = 'Extract_Owner_Address' and type = 'V'))
	begin
		drop view Extract_Owner_Address;
	end;
go

create view Extract_Owner_Address
as
	select
			OADR_County 		as	DLR_County,
			OADR_Country		as	DLR_Country,
			OADR_Address		as	DLR_Address,
			OADR_City			as	DLR_City,
			OADR_State			as	DLR_State,
			OADR_Zip			as	DLR_Zip,
			OADR_Phone			as	DLR_Phone,
			OADR_ID				as	DLR_Code
	from
			Owner_Address		OADR
go

----004_Create_Stage_Owner_Address.sql

if (exists(select name from sysobjects where name = 'Stage_Owner_Address' and type = 'U'))
	begin
		drop table Stage_Owner_Address;
	end
go

create table Stage_Owner_Address
	(
	OADR_County		varchar(60)					not null,
	OADR_Country	varchar(60)					not null,
	OADR_Address	varchar(256)				not null,
	OADR_City		varchar(60)					not null,
	OADR_State		varchar(2)					not null,
	OADR_Zip		varchar(10)					not null,
	OADR_Phone		varchar(20)					not null,
	OADR_ID			smallint	identity(1,1)	not null,
	CONSTRAINT PK_Stage_Owner_Address PRIMARY KEY CLUSTERED (OADR_ID ASC)
	);
go

---005_Create_Extract_Independent.sql

if (exists(select name from sysobjects where name = 'Extract_Independent' and type = 'V'))
	begin
		drop view Extract_Independent;
	end;
go

create view Extract_Independent
as
	select
			ID_Name		as DLR_Name,
			DLR_Type	as DLR_Independent_Or_Corporate,
			DLR_ID		as DLR_Code,
			DLR_Email	as DLR_Email_Address,
			DLR_Since	as DLR_Initiation_Date,
			OADR_ID		as OADR_ID,
			WEB_ID		as WEB_ID
			
	from
			Independent		INDP
go

---005_Create_Stage_Independent.sql

if (exists(select name from sysobjects where name = 'Stage_Independent' and type = 'U'))
	begin
		drop table Stage_Independent;
	end
go

create table Stage_Independent
	(
	ID_Name			varchar(256)					not null,
	DLR_Type		varchar(1)						not null,
	DLR_ID			smallint		identity(1,1)	not null,
	DLR_Email		varchar(256)					not null,
	DLR_Since		datetime						not null,
	OADR_ID			smallint						not null,
	WEB_ID			smallint						not null,
	CONSTRAINT PK_Stage_Independent PRIMARY KEY CLUSTERED (DLR_ID ASC)
	);
go


