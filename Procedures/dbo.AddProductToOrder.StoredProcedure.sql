USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddProductToOrder]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddProductToOrder] 
	@orderID int,
	@productID int
AS
BEGIN
	BEGIN TRANSACTION
	SET NOCOUNT ON;
	--IF ((SELECT COUNT(*) FROM Orders 
	--JOIN Order_Details ON Orders.orderID = Order_Details.orderID 
	--JOIN Products ON Order_Details.productID = Products.productID
	--JOIN Products_In_Menu ON Products.productID = Products_in_menu.productID
	--JOIN Menus ON Products_in_menu.menuID = Menus.menuID
	--WHERE Menus.startDate <= Orders.receiveDate AND Menus.endDate >= Orders.receiveDate AND Products_in_menu.productID = @productID)= 0)
	DECLARE @productGaveDate date
	DECLARE @fromTime date = (SELECT top 1 fromTime FROM Reservation_Tables where orderID = @orderID)
	IF @fromTime is null
	BEGIN
	SET @productGaveDate = (SELECT orderDate FROM Orders where orderID = @orderID)
	END
	ELSE
	BEGIN
	SET @productGaveDate = @fromTime
	END
	IF (SELECT COUNT(*) FROM Products_In_Menu 
	inner join Menus on Products_In_Menu.menuID = Menus.menuID
	where Products_In_Menu.productID = @productID and Menus.startDate <= @productGaveDate and @productGaveDate <= Menus.endDate) = 0
		BEGIN
			ROLLBACK
			DECLARE @msg NVARCHAR(2048) = 'Product with ID:' + CONVERT(varchar, @productID) + ' is not avaiable in the menu at this time' ;   
			;THROW 52000, @msg,1
			RETURN
		END
	IF ((SELECT COUNT(*) FROM Products WHERE productID = @productID)= 0)
		BEGIN
			ROLLBACK
			DECLARE @msg2 NVARCHAR(2048) = 'Product with ID:' + CONVERT(varchar, @productID) + ' does not exist' ;   
			;THROW 52000, @msg2,1
			RETURN
		END
	IF(SELECT quantity FROM Order_Details WHERE orderID = @orderID AND productID = @productID) is not null
	BEGIN
		UPDATE [Order_Details]
		SET quantity = quantity+1
		WHERE orderID = @orderID AND productID = @productID
		COMMIT
		RETURN
	END
	INSERT INTO [dbo].[Order_Details]
          (                    
            orderID,
			productID,
			quantity
          ) 
     VALUES 
          ( 
            @orderID,
			@productID,
			1
          ) 
	COMMIT
END
GO
