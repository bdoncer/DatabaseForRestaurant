USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddOrder]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
--dodanie stolikow to zamowienia, addtabletoroder
CREATE PROCEDURE [dbo].[AddOrder] 
	-- Add the parameters for the stored procedure here
	@seats varchar(500)='',
	@reservationFrom datetime = NULL,
	@productsID varchar(500) = '',
	@customer_id int = NULL,
	@employee_id int = NULL,
	@receiveDate date = NULL,
	@paid bit = 0,
	--discount percentage on the order
	@invoice_id int = NULL,
	--does client uses his one-time discount
	@choosesDiscount bit = 0,
	@output int output
AS
BEGIN
	SET NOCOUNT ON;
	--jesli wydane pieniadze przkroczą próg, dodaj zniżke do profilu klienta
	DECLARE @orderDate AS date ;
	DECLARE @discount as int;
	SET @discount = 0;
	SET @orderDate = GETDATE();

	IF ((SELECT COUNT(*) FROM Customers where customerID = @customer_id) < 1 AND @customer_id is not NULL)
    BEGIN
        DECLARE @msg NVARCHAR(2048) = 'Customer with ID:' + CONVERT(varchar, @customer_id) + ' does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
    END
	IF ((SELECT COUNT(*) FROM Employees where @employee_id = @employee_id) < 1 AND @employee_id is not NULL)
    BEGIN
        DECLARE @msg2 NVARCHAR(2048) = 'Employee with ID:' + CONVERT(varchar, @employee_id) + ' does not exist' ;   
		;THROW 52000, @msg2,1
		RETURN
    END

	BEGIN TRANSACTION

	EXEC AddDiscount @customer_id

	DECLARE @K1 as int = 30;
	DECLARE @Z1 as int = 3;
	DECLARE @R1 as int = 5;
	DECLARE @R2 as int = 10;

	IF(@customer_id) is not null
	BEGIN
		--add passive discount
		IF(SELECT COUNT(*) FROM Orders WHERE customerID = customerID AND dbo.GetOrderValue(orderID,discount) >= @K1) >= @Z1 
		BEGIN
			SET @discount = @R1;
		END
		IF(@choosesDiscount) = 1
		BEGIN
			--add one-time discount if there is any, and update the expireDate
			IF(SELECT [expireDate] FROM Discounts WHERE customerID = @customer_id AND [expireDate] >= @orderDate) is not null
			BEGIN
				SET @discount = @discount+@R2;
				SET ROWCOUNT 1
				UPDATE Discounts
				SET [expireDate] = @orderDate
				WHERE customerID = @customer_id
				SET ROWCOUNT 0
			END
		END
	END
	
    INSERT INTO [dbo].[Orders]
          (          
			customerID,
			employeeID,
			orderDate,
			receiveDate,
			paid,
			discount,
			invoiceID
          ) 
     VALUES 
          ( 
		    @customer_id,
			@employee_id,
			@orderDate,
			@receiveDate,
			@paid,
			@discount,
			@invoice_id
          ) 

	DECLARE @ctr AS int ;
	DECLARE @Tctr AS int ;
	DECLARE @singleTable AS int ;
	DECLARE @identity AS int ;
	DECLARE @reservationTO AS datetime ;

	SET @identity = SCOPE_IDENTITY()
	SET @output = @identity;
	DECLARE @tableSeats AS int ;
	SET @ctr = (SELECT COUNT(*) FROM STRING_SPLIT(@seats,','));
	IF(@reservationFrom is NULL)
	BEGIN
		SET @reservationFrom = @orderDate;
	END
	WHILE @ctr >= 1
	BEGIN
		SET @tableSeats = CAST(((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@seats,',') ) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@seats,','))as d))as INT);
		
		--SELECT tableID FROM [Table] WHERE seats >= @tableSeats ORDER BY seats --wszystkie stoli z dobra iloscia miejsc, sprawdz czy sa zarezerwowanie czy nie
		SET @Tctr = (SELECT COUNT(*) FROM [Tables] WHERE seats >= @tableSeats AND isWorking = 1)
		WHILE @Tctr >=1
		BEGIN
			SET @singleTable = ((SELECT TOP (@Tctr) * FROM (SELECT tableID FROM [Tables] WHERE seats >= @tableSeats AND isWorking = 1) as p) EXCEPT (SELECT TOP (@Tctr-1) * FROM (SELECT tableID FROM [Tables] WHERE seats >= @tableSeats AND isWorking = 1)as d));
			IF(SELECT tableID FROM Reservation_Tables WHERE @reservationFrom <= toTime AND DATEADD(HOUR, 3, @reservationFrom) >= fromTime AND tableID = @singleTable) is NULL
			BEGIN
				--ten stolik jest dobry, wyjdz z petli
				SET @reservationTO =DATEADD(HOUR, 3, @reservationFrom);
				EXEC AddTableToOrder @identity,@reservationFrom,@reservationTO,@singleTable; -- rollback inside if failed
				BREAK
			END
			SET @Tctr= @Tctr-1 ;
		END
		IF(@Tctr = 0)
		BEGIN
			ROLLBACK
			;THROW 52000, 'Could not find a valid table for reservation',1
			RETURN
		END
	
		SET @ctr = @ctr-1
	END
	
	DECLARE @prID as int;
	SET @ctr = (SELECT COUNT(*) FROM STRING_SPLIT(@productsID,','));
	WHILE @ctr >= 1
    BEGIN
        SET @prID = CAST(((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@productsID,',')) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@productsID,','))as d))as int);
		EXEC AddProductToOrder @identity,@prID; -- rollback inside if failed
		SET @ctr = @ctr-1;
	END
	COMMIT
END
GO
