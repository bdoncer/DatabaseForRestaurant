USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[OrdersInfoMonth]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--generowanie ile zamowien i za jaka kwote zlozyl dany klient (tydzień/miesiąc)_+_+-
CREATE PROCEDURE [dbo].[OrdersInfoMonth] 
	-- Add the parameters for the stored procedure here
	@customer_id int,
	@from_date date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF ((SELECT COUNT(*) FROM Customers where customerID = @customer_id) < 1)
	BEGIN
		DECLARE @msg NVARCHAR(2048) = 'Customer with ID:' + CONVERT(varchar, @customer_id) + ' does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
	END
    DECLARE @count int;

	SET @count = 0;

	SELECT @count=@count+1 FROM Orders
	WHERE customerID = @customer_id AND CONVERT(DATE, orderDate) BETWEEN @from_date AND DATEADD(MONTH, 1, @from_date)

	SELECT sum(quantity*price)*(1-discount/100)
    FROM ORDERS as O
    INNER JOIN Order_Details as OD ON O.orderID = OD.orderID
    INNER JOIN Products_In_Menu as PM ON PM.productID = OD.productID
    INNER JOIN Menus as M ON M.menuID = PM.menuID
    WHERE CONVERT(DATE, O.orderDate) BETWEEN M.startDate AND M.endDate AND CONVERT(DATE, receiveDate) BETWEEN @from_date AND DATEADD(MONTH, 1, @from_date) AND o.customerID = @customer_id
    GROUP BY O.orderID, discount

	--PRINT @count
END
GO
