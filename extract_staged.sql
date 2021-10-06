/*
** run in seis732_team_01_sales_org database. Create staging tables for sales_org etl
*/
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_staged_sales_org' AND type='V'))
	BEGIN
		DROP VIEW extract_staged_sales_org;
	END;
GO
CREATE VIEW extract_staged_sales_org AS
SELECT  [SORG_Zone_ID],
	    [SORG_Zone_Name],
	    [SORG_Zone_Manager_Name],
		[SOGR_Zone_Key],
        [SORG_Domain_ID], 
        [SORG_Domain_Name],
	    [SORG_Domain_Manager_Name],
		[SORG_Zone_ID],
	    [SORG_Zone_Name],
	    [SORG_Zone_Manager_Name],
		[SORG_Region_Key]
FROM extract_area_territory t,
     extract_area_district d,
	 extract_area_zone z
WHERE [SOGR_Zone_Key]=
	  ON sa.MGR_ID=sm.MGR_ID;
GO
