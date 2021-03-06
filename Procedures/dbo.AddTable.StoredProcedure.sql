USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddTable]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddTable] 
	-- Add the parameters for the stored procedure here
	@seats int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Tables]
          (                    
            seats,
			isWorking
          ) 
     VALUES 
          ( 
            @seats,
			1
          ) 
END
GO
