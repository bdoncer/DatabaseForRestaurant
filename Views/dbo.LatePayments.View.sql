USE [u_doncer]
GO
/****** Object:  View [dbo].[LatePayments]    Script Date: 18.03.2022 12:41:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[LatePayments]
AS SELECT Customers.customerID, (IC.firstName+' '+IC.lastName) as customer_name, C.companyName, SUM(dbo.GetOrderValue(Orders.orderID, discount)) as to_pay
FROM Customers
JOIN Orders ON Customers.customerID = Orders.customerID
LEFT OUTER JOIN Individual_Customers as IC ON IC.customerID = Customers.customerID
LEFT OUTER JOIN Companies as C ON C.customerID = Customers.customerID
WHERE paid = 0
GROUP BY Customers.customerID, IC.firstName, IC.lastName, C.companyName
GO
