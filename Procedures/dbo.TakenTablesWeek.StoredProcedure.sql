USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[TakenTablesWeek]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[TakenTablesWeek] 
	-- Add the parameters for the stored procedure here
	@from_date date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @total int;

	SET @total = 0;

	SELECT COUNT(*) FROM Reservation_Tables
	WHERE CONVERT(DATE, fromTime) BETWEEN @from_date AND DATEADD(DAY, 7, @from_date)
END
GO
