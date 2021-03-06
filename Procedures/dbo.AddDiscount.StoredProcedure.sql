USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddDiscount]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddDiscount] 
    @customerID int,
    @K2 int = 1000,
    @R2 int = 5,
    @D1 int = 7
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @from_date date = NULL;
	
	SELECT @from_date = MAX(expireDate) FROM Discounts
	WHERE expireDate< CONVERT(DATE,GETDATE())

	IF(@from_date) is not null
	BEGIN
		IF(SELECT sum(quantity*price)*(1-discount/100)
			FROM ORDERS as O
			INNER JOIN Order_Details as OD ON O.orderID = OD.orderID
			INNER JOIN Products_In_Menu as PM ON PM.productID = OD.productID
			INNER JOIN Menus as M ON M.menuID = PM.menuID
			WHERE O.customerID = @customerID AND CONVERT(DATE, O.orderDate) BETWEEN M.startDate AND M.endDate 
			GROUP BY O.orderID, discount) >= @K2
		BEGIN
			INSERT INTO [dbo].[Discounts]
			(                    
            customerID,
			expireDate
			) 
		VALUES 
			( 
            @customerID,
			DATEADD(DAY, @D1,GETDATE())
			) 
		END
	END
END
GO
