USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[ModifyOrder]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ModifyOrder]
	-- Add the parameters for the stored procedure here
	@orderID int,
	@productsID varchar(500) = NULL,
	@employee_id int = NULL,
	@receiveDate date = NULL,
	@paid bit = NULL,
	@discount int = NULL,
	@invoice_id int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF (@employee_id is not null)
	BEGIN
		IF ((SELECT COUNT(*) FROM Employees where employeeID = @employee_id) < 1)
		BEGIN
			DECLARE @msg NVARCHAR(2048) = 'Employee with ID:' + CONVERT(varchar, @employee_id) + ' does not exist' ;   
			;THROW 52000, @msg,1
			RETURN
		END
		UPDATE Orders
		SET employeeID = @employee_id
		WHERE orderID = @orderID
	END
	IF (@receiveDate is not null)
	BEGIN
		UPDATE Orders
		SET receiveDate = @receiveDate
		WHERE orderID = @orderID
	END
	IF (@paid is not null)
	BEGIN
		UPDATE Orders
		SET paid = @paid
		WHERE orderID = @orderID
	END
	IF (@invoice_id is not null)
	BEGIN
		UPDATE Orders
		SET invoiceID = @invoice_id
		WHERE orderID = @orderID
	END
	IF (@discount is not null)
	BEGIN
		UPDATE Orders
		SET discount = @discount
		WHERE orderID = @orderID
	END
	IF (@productsID is not null)
	BEGIN
		BEGIN TRANSACTION
		DECLARE @prID as int;
		DECLARE @ctr as int;
		SET @ctr = (SELECT COUNT(*) FROM STRING_SPLIT(@productsID,','));
		WHILE @ctr >= 1
		BEGIN
			SET @prID = CAST(((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@productsID,',')) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@productsID,','))as d))as int);
			EXEC AddProductToOrder @orderID, @prID; -- rollback inside if failed
			SET @ctr = @ctr-1;
		END
		COMMIT
	END
END
GO
