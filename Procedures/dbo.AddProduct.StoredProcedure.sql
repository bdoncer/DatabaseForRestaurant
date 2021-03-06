USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 2022-01-06 19:29:48 ******/
CREATE PROCEDURE [dbo].[AddProduct]
	-- Add the parameters for the stored procedure here
	@productName varchar(30), 
	@categoryID varchar(30),
	@discontinued bit = 1
AS
BEGIN
	SET NOCOUNT ON;
	IF ((SELECT COUNT(*) FROM Categories where categoryID = @categoryID) < 1)
	BEGIN
		DECLARE @msg NVARCHAR(2048) = 'Category with ID:' + CONVERT(varchar, @categoryID) + ' does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
	END
	INSERT INTO [dbo].[Products]
          (                    
		  	productName, 
			categoryID,
			discontinued
          ) 
     VALUES 
          ( 
			@productName, 
			@categoryID,
			@discontinued
          ) 
END
GO
