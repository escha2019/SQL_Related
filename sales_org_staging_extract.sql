/*
** run in seis732_team_01_sales_org. Create staging tables for sales_org etl
*/
-- 001_create_Stage_area/zone table
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_area_zone' AND type='U'))
	BEGIN
		DROP TABLE stage_area_zone;
	END;
GO
CREATE TABLE stage_area_zone
	([SOGR_Zone_Key]         numeric IDENTITY(1,1) not null,
	 [SORG_Zone_ID]          smallint not null,
	 [SORG_Zone_Name]        varchar(60) not null,
	 [SORG_Zone_Manager_Name] varchar(60),
	 [SORG_Domain_ID]         smallint not null,
	 CONSTRAINT pk_stage_area_zone PRIMARY KEY ([SOGR_Zone_Key])
	);
GO

-- 001_create_Stage_domain/district table
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_area_district' AND type='U'))
	BEGIN
		DROP TABLE stage_area_district;
	END;
GO
CREATE TABLE stage_area_district
	([useless_Key]         numeric IDENTITY(1,1) not null,
	 [SORG_Domain_ID]           smallint not null,
	 [SORG_Domain_Name]         varchar(60) not null,
	 [SORG_Domain_Manager_Name] varchar(60),
	 CONSTRAINT pk_stage_area_district PRIMARY KEY ([useless_Key])
	);
GO

-- 001_create_Stage_Region/territory
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_area_territory' AND type='U'))
	BEGIN
		DROP TABLE stage_area_territory;
	END;
GO
CREATE TABLE stage_area_territory
	([SORG_Region_Key]          numeric IDENTITY(1,1) not null,
	 [SORG_Region_ID]           smallint not null,
	 [SORG_Region_Name]         varchar(60) not null,
	 [SORG_Region_Manager_Name] varchar(60),
	 [SORG_Zone_ID]             smallint not null,
	 CONSTRAINT pk_stage_area_territory PRIMARY KEY ([SORG_Region_Key])
	);
GO

-- 001_create_Stage_area/zone view
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_area_zone' AND type='V'))
	BEGIN
		DROP VIEW extract_area_zone;
	END;
GO
CREATE VIEW extract_area_zone AS
SELECT sa.[SA_ID]   AS [SORG_Zone_ID],
	   sa.[SA_Name] AS [SORG_Zone_Name],
	   sa.[SD_ID]   AS [SORG_Domain_ID],
	   sm.MGR_First_Name + ' ' + sm.MGR_Last_Name AS [SORG_Zone_Manager_Name]  
FROM SEIS732_Team_01_Sales_Org.[dbo].[Sales_Area] sa
	  LEFT JOIN [SEIS732_Team_01_Sales_Org].[dbo].[Sales_Mgr] sm
	  ON sa.MGR_ID=sm.MGR_ID;
GO

-- 001_create_Stage_domain/district view
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_area_district' AND type='V'))
	BEGIN
		DROP VIEW extract_area_district;
	END;
GO
CREATE VIEW extract_area_district AS
SELECT  sa.[SD_ID]   AS [SORG_Domain_ID], 
        sa.[SD_Name] AS [SORG_Domain_Name],
		sm.MGR_First_Name + ' ' + sm.MGR_Last_Name AS [SORG_Domain_Manager_Name]  
FROM SEIS732_Team_01_Sales_Org.[dbo].[Sales_District] sa
		LEFT JOIN [SEIS732_Team_01_Sales_Org].[dbo].[Sales_Mgr] sm
	  ON sa.MGR_ID=sm.MGR_ID;
GO

-- 001_create_Stage_region/territory view
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_area_territory' AND type='V'))
	BEGIN
		DROP VIEW extract_area_territory;
	END;
GO
CREATE VIEW extract_area_territory AS
SELECT sa.[ST_ID]   AS [SORG_Region_ID],
	   sa.[ST_Name] AS [SORG_Region_Name],
	   sa.[SA_ID]   AS [SORG_Zone_ID],
	   sm.MGR_First_Name + ' ' + sm.MGR_Last_Name AS [SORG_Region_Manager_Name]  
FROM SEIS732_Team_01_Sales_Org.[dbo].[Sales_Territory] sa
	  LEFT JOIN [SEIS732_Team_01_Sales_Org].[dbo].[Sales_Mgr] sm
	  ON sa.MGR_ID=sm.MGR_ID;
GO