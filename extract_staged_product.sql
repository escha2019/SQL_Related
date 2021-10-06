--- staged_extract_Table
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_staged_product_table' AND type='U'))
	BEGIN
		DROP TABLE extract_staged_product_table;
	END;
GO
CREATE TABLE extract_staged_product_table 
(       [PRD_Key]                   numeric IDENTITY(1,1) not null
	   ,[PRD_Make_Key]              smallint not null
	   ,[PRD_Make_Name]				varchar(40) not null
	   ,[PRD_Make_Description]      varchar(256) not null
	   ,[PRD_Model_Key]				smallint not null
	   ,[PRD_Model_Name]			varchar(40) not null
	   ,[PRD_Model_Description]     varchar(256) not null
	   ,[PRD_Class_Key]				smallint not null
	   ,[PRD_Class_Name]			varchar(40) not null
	   ,[PRD_Class_Description]     varchar(256) not null
	   ,[PRD_Color_Key]             smallint not null
	   ,[PRD_Color_ID]				bigint not null
	   ,[PRD_Color_Name]            varchar(40) not null
	   ,[PRD_Color_Description]     varchar(256) not null
	   ,[PRD_Model_Year]            varchar(10) not null
	   ,[PRD_VehicleType_ID]		bigint not null
	   ,[PRD_Manufacturer_Suggested_Retail_Price]  money not null
	   ,[PRD_Wholesale_Price]					   money not null
	   ,[PRD_MMC_ID]							   smallint not null,         
	 CONSTRAINT pk_extract_staged_product PRIMARY KEY ([PRD_Key])
	);
GO

--- staged_extract_product_view
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_staged_product' AND type='V'))
	BEGIN
		DROP VIEW extract_staged_product;
	END;
GO
CREATE VIEW extract_staged_product AS 
SELECT  [PRD_Make_Key]
	   ,[PRD_Make_Name]
	   ,[PRD_Make_Description]
	   ,[PRD_Model_Key]
	   ,[PRD_Model_Name]
	   ,[PRD_Model_Description]
	   ,[PRD_Class_Key]
	   ,[PRD_Class_Name]
	   ,[PRD_Class_Description]
	   ,[PRD_Color_Key]
	   ,Stage_Products_Color.[PRD_Color_ID]
	   ,[PRD_Color_Name]
	   ,[PRD_Color_Description]
	   ,[PRD_Model_Year]
	   ,Stage_Products_Vehicle_Type.[PRD_VehicleType_ID]
	   ,[PRD_Manufacturer_Suggested_Retail_Price]
	   ,[PRD_Wholesale_Price]
	   ,stage_mmc_model.[PRD_MMC_ID]
FROM stage_mmc_class, stage_mmc_model, 
     stage_mmc_make, Stage_Products_Color, 
	 Stage_Products_VT_CLR_ID, Stage_Products_Vehicle_Type
WHERE stage_mmc_class.[PRD_MMC_ID]=stage_mmc_model.[PRD_MMC_ID]
    AND stage_mmc_class.[PRD_MMC_ID]=stage_mmc_make.[PRD_MMC_ID]
	AND Stage_Products_VT_CLR_ID.PRD_VehicleType_ID = Stage_Products_Vehicle_Type.PRD_VehicleType_ID
	AND Stage_Products_VT_CLR_ID.PRD_Color_ID=Stage_Products_Color.PRD_Color_ID
	;
GO
