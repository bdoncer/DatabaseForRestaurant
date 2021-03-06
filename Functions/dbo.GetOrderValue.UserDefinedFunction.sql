USE [u_doncer]
GO
/****** Object:  UserDefinedFunction [dbo].[GetOrderValue]    Script Date: 18.03.2022 12:42:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetOrderValue] 
(	
	@orderID int,
	@discount int  = 0
)
RETURNS int
AS
BEGIN
	IF(@discount is null)
	BEGIN
		set @discount = 0
	END
	DECLARE @value int
	SET @value = (
	SELECT sum(quantity*price *(1-(@discount/100)))
	FROM ORDERS as O
	INNER JOIN Order_Details as OD ON O.orderID = OD.orderID
	INNER JOIN Products_In_Menu as PM ON PM.productID = OD.productID
	INNER JOIN Menus as M ON M.menuID = PM.menuID
	WHERE @orderID = O.orderID AND CONVERT(DATE, O.orderDate) BETWEEN M.startDate AND M.endDate
	GROUP BY O.orderID
	)
	RETURN @value
END
GO
