USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[GenerateSavedMoney]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateSavedMoney]
	-- Add the parameters for the stored procedure here
	@customerID int,
	@from_date datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF ((SELECT COUNT(*) FROM Customers where customerID = @customerID) < 1)
	BEGIN
		DECLARE @msg NVARCHAR(2048) = 'Customer with ID:' + CONVERT(varchar, @customerID) + ' does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
	END
	SELECT sum(quantity*price)*discount/100
	FROM ORDERS as O
	INNER JOIN Order_Details as OD ON O.orderID = OD.orderID
	INNER JOIN Products_In_Menu as PM ON PM.productID = OD.productID
	INNER JOIN Menus as M ON M.menuID = PM.menuID
	WHERE @customerID = customerID AND CONVERT(DATE, O.orderDate) BETWEEN M.startDate AND M.endDate AND CONVERT(DATE, receiveDate) BETWEEN @from_date AND DATEADD(DAY, 7, @from_date)
	GROUP BY O.orderID, discount
	
END
GO
