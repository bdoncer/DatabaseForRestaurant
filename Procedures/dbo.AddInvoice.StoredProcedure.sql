USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddInvoice]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddInvoice] 
	@customerID int,
	@fromDate date,
	@toDate date,
	@companyName varchar(30),
	@street varchar(30),
	@city varchar(30),
	@postalCode varchar(30),
	@firstName varchar(30),
	@lastName varchar(30)
AS
BEGIN
	SET NOCOUNT ON;
	IF ((SELECT COUNT(*) FROM Customers where customerID = @customerID) < 1)
	BEGIN
		DECLARE @msg NVARCHAR(2048) = 'The customer with ID:' + CONVERT(varchar, @customerID) + 'does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
	END
	INSERT INTO [dbo].[Invoices]
          (                    
            issueDate,
			companyName,
			street,
			city,
			postalCode,
			firstName,
			lastName
          ) 
     VALUES 
          ( 
            CONVERT(DATE,GETDATE()),
			@companyName,
			@street,
			@city,
			@postalCode,
			@firstName,
			@lastName
          ) 
	UPDATE Orders
	SET invoiceID = SCOPE_IDENTITY()
	WHERE receiveDate >= @fromDate AND receiveDate <= @toDate AND @customerID = customerID
END
GO
