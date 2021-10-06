/*
** run in seis732_team_01_sales_org database. Create staging tables for sales_org etl
*/
IF (EXISTS(SELECT name FROM sysobjects WHERE name='extract_staged_sales_org' AND type='V'))
	BEGIN
		DROP VIEW extract_staged_sales_org;
	END;
GO
CREATE VIEW extract_staged_sales_org AS
SELECT  a.[SORG_Zone_ID],
	    a.[SORG_Zone_Name],
	    a.[SORG_Zone_Manager_Name],
	    a.[SORG_Zone_Key],
	    d.[SORG_Domain_ID],
	    d.[SORG_Domain_Name],
	    d.[SORG_Domain_Manager_Name],
	    t.[SORG_Region_ID],
	    t.[SORG_Region_Name],
	    t.[SORG_Region_Manager_Name],
	    t.[SORG_Region_Key],
	    '[' + d.[SORG_Domain_Name] + ']-(' + a.[SORG_Zone_Name] + ')/' + t.[SORG_Region_Name] AS [SORG_Full_Name]
FROM dbo.stage_area_territory t,
     dbo.stage_area_district d,
	 dbo.stage_area_zone a
WHERE a.[SOGR_Zone_ID] = t.[SOGR_Zone_ID]
	 AND a.[SORG_Domain_ID] = d.[SORG_Domain_ID];
GO