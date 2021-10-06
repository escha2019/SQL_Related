/*
** run in seis732_team_01_products. Create staging tables for products etl
*/
-- 001_create_Stage_mmc_make
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_mmc_make' AND type='U'))
	BEGIN
		DROP TABLE stage_mmc_make;
	END;
GO
CREATE TABLE stage_mmc_make
	([PRD_Make_Key]          numeric IDENTITY(1,1) not null,
	 [PRD_MMC_ID]            smallint not null,
	 [PRD_Make_Name]         varchar(40) not null,
	 [PRD_Make_Description]  varchar(256) not null,
	 CONSTRAINT pk_stage_mmc_make PRIMARY KEY ([PRD_Make_Key])
	);
GO

-- 001_create_Stage_mmc_model
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_mmc_model' AND type='U'))
	BEGIN
		DROP TABLE stage_mmc_model;
	END;
GO
CREATE TABLE stage_mmc_model
	([PRD_Model_Key]         numeric IDENTITY(1,1) not null,
	 [PRD_MMC_ID]            smallint not null,
	 [PRD_Model_Name]        varchar(40) not null,
	 [PRD_Model_Description] varchar(256) not null,
    CONSTRAINT pk_stage_mmc_model PRIMARY KEY ([PRD_Model_Key])
	);
GO

-- 001_create_Stage_mmc_class
IF (EXISTS(SELECT name FROM sysobjects WHERE name='stage_mmc_class' AND type='U'))
	BEGIN
		DROP TABLE stage_mmc_class;
	END;
GO
CREATE TABLE stage_mmc_class
	([PRD_Class_Key]         numeric IDENTITY(1,1) not null,
	 [PRD_MMC_ID]            smallint not null,
	 [PRD_Class_Name]        varchar(40) not null,
	 [PRD_Class_Description] varchar(256) not null,
    CONSTRAINT pk_stage_mmc_class PRIMARY KEY ([PRD_Class_Key])
	);
GO

-- 003_Create_Extract_View_Make
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_mmc_make' AND type='V'))
	BEGIN
		DROP VIEW extract_mmc_make;
	END;
GO
CREATE VIEW extract_mmc_make AS 
SELECT [MMC_ID]         AS [PRD_MMC_ID],
       [MMC_Make_Name]  AS [PRD_Make_Name],
	   [MMC_Make_Desc]  AS [PRD_Make_Description]
FROM SEIS732_Team_01_Products.[dbo].[MMC];
GO

-- 003_Create_Extract_View_Model
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_mmc_model' AND type='V'))
	BEGIN
		DROP VIEW extract_mmc_model;
	END;
GO
CREATE VIEW extract_mmc_model AS
SELECT [MMC_ID]         AS [PRD_MMC_ID],
	   [MMC_Model_Name] AS [PRD_Model_Name],
	   [MMC_Model_Desc] AS [PRD_Model_Description]
FROM SEIS732_Team_01_Products.[dbo].[MMC];
GO

-- 003_Create_Extract_View_Class
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_mmc_class' AND type='V'))
	BEGIN
		DROP VIEW extract_mmc_class;
	END;
GO
CREATE VIEW extract_mmc_class AS 
SELECT [MMC_ID]         AS [PRD_MMC_ID],
	   [MMC_Class_Name] AS [PRD_Class_Name],
	   [MMC_Class_Desc] AS [PRD_Class_Description]
FROM SEIS732_Team_01_Products.[dbo].[MMC];
GO
