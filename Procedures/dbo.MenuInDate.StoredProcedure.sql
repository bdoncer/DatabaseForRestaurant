USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[MenuInDate]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[MenuInDate]    Script Date: 2022-01-06 19:27:40 ******/

CREATE PROCEDURE [dbo].[MenuInDate] 
	@date date = NULL
AS
BEGIN
	IF (@date = NULL)
	BEGIN
		;THROW 52000, 'No date',1
		RETURN
	END
	SET NOCOUNT ON;
	
	SELECT Products_In_Menu.menuID,Products_In_Menu.productID,productName, price
	FROM Products_In_Menu
	JOIN Products ON Products_in_menu.productID = Products.productID
	JOIN Menus ON Products_In_Menu.menuID = Menus.menuID
	WHERE Menus.startDate <= @date AND Menus.endDate >= @date
END
GO
