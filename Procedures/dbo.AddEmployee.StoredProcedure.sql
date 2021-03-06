USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddEmployee]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddEmployee] 
	-- Add the parameters for the stored procedure here
	@f_name varchar(30), 
	@l_name varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT @f_name, @l_name
	INSERT INTO [dbo].[Employees]
          (                    
            firstName                     ,
            lastName                          
          ) 
     VALUES 
          ( 
            @f_name,
            @l_name
          ) 

END
GO
