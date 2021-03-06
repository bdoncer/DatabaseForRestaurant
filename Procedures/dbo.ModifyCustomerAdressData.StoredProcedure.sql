USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[ModifyCustomerAdressData]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ModifyCustomerAdressData]
	-- Add the parameters for the stored procedure here
	@customerID int,
	@city varchar(30), 
	@street varchar(30),
	@postalCode int
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
	UPDATE Customers
	SET city = @city, street = @street, postalCode = @postalCode
	WHERE customerID = @customerID
END
GO
