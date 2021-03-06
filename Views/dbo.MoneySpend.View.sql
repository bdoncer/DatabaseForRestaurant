USE [u_doncer]
GO
/****** Object:  View [dbo].[MoneySpend]    Script Date: 18.03.2022 12:41:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MoneySpend]
AS SELECT Customers.customerID,(IC.firstName+' '+IC.lastName) as customer_name, C.companyName,sum(quantity*price)*(1-discount/100) as sum
    FROM Orders as O
	JOIN Customers ON Customers.customerID = O.customerID
    JOIN Order_Details as OD ON O.orderID = OD.orderID
    JOIN Products_In_Menu as PM ON PM.productID = OD.productID
    JOIN Menus as M ON M.menuID = PM.menuID
	LEFT OUTER JOIN Individual_Customers as IC ON IC.customerID = Customers.customerID
	LEFT OUTER JOIN Companies as C ON C.customerID = Customers.customerID
    GROUP BY O.orderID, discount,Customers.customerID,IC.firstName,IC.lastName, C.companyName

GO
