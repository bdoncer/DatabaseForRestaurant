USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddProductToMenu]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddProductToMenu] 
	-- Add the parameters for the stored procedure here
	@product_id int, 
	@menu_id int,
	@price money
AS
BEGIN
	BEGIN TRANSACTION
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF ((SELECT COUNT(*) FROM Menus where menuID = @menu_id) < 1)
		BEGIN
			ROLLBACK
			DECLARE @msg NVARCHAR(2048) = 'Menu with ID:' + CONVERT(varchar, @menu_id) + ' does not exist' ;   
			;THROW 52000, @msg,1
			RETURN
		END
	IF ((SELECT COUNT(*) FROM Products WHERE productID = @product_id AND discontinued=1) > 0)
		BEGIN
			ROLLBACK
			DECLARE @msg2 NVARCHAR(2048) = 'You cannot add product with ID:' + CONVERT(varchar, @product_id) + ' to the menu' ;   
			;THROW 52000, @msg2,1
			RETURN
		END
    -- Insert statements for procedure here
	INSERT INTO [dbo].[Products_In_Menu]
          (          
			productID,
			menuID,
			price
          ) 
     VALUES 
          ( 
		    @product_id,
			@menu_id,
			@price
          ) 
	COMMIT
END
GO
