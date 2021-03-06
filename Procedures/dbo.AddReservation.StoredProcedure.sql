USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddReservation]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddReservation] 
	-- Add the parameters for the stored procedure here
	@seats varchar(500),
	@reservationFrom datetime,
	@productsID varchar(500) = NULL,
	@employee_id int, 
	@onName varchar(100) = NULL,
	@customer_id int = NULL,
	@o_employee_id int = NULL,
	@receiveDate date = NULL,
	@paid bit = 0,
	@invoice_id int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF (SELECT COUNT(*) FROM Employees WHERE @employee_id = employeeID) = 0
	BEGIN
		DECLARE @msg NVARCHAR(2048) = 'Employee with ID:' + CONVERT(varchar, @employee_id) + ' does not exist' ;   
		;THROW 52000, @msg,1
		RETURN
	END

	--minimalna wartość zamówienia wymagana do złożenia rezerwacji
	DECLARE @WZ as int = 50;
	--ilość poprzednich zamówień wymagana do złożenia rezerwacji
	DECLARE @WK as int = 5;

	--sprawdzenie czy indywidualny klient spełnia warunki do rezerwacji
	--IF(SELECT COUNT(*) FROM Individual_Customers WHERE @customer_id = customerID) =1
		--IF(SELECT SUM(price)
			--FROM Products_In_Menu
			--JOIN Products ON Products_in_menu.productID = Products.productID
			--JOIN Menus ON Products_In_Menu.menuID = Menus.menuID
			--WHERE Menus.startDate <= GETDATE() AND Menus.endDate >= GETDATE() AND (Products_in_menu.productID IN (SELECT value FROM STRING_SPLIT(@productsID,',')))) <@WZ
		--BEGIN
		--	;THROW 52000, 'The reservation value is too low',1
			--RETURN
		--END
		--IF(SELECT COUNT(*) FROM Orders WHERE @customer_id = customerID) < @WK
		--BEGIN
			--;THROW 52000, 'Client does not have required amount of orders',1
			--RETURN
		--END
	--END




	DECLARE @prID as int;
	DECLARE @ctr as int;
	SET @ctr = (SELECT COUNT(*) FROM STRING_SPLIT(@productsID,','));
	WHILE @ctr >= 1
    BEGIN
        SET @prID = CAST(((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@productsID,',')) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@productsID,','))as d))as int);
		IF(SELECT categoryID FROM Products WHERE productID = @prID)=6
		BEGIN
			IF(NOT((DATEPART(WEEKDAY,CONVERT(DATE, @reservationFrom)) = 3 OR DATEPART(WEEKDAY,CONVERT(DATE,@reservationFrom)) = 4 OR DATEPART(WEEKDAY,CONVERT(DATE,@reservationFrom)) = 5) OR DATEDIFF(DAY,CONVERT(DATE,GETDATE()),CONVERT(DATE,@reservationFrom))>=DATEPART(WEEKDAY,CONVERT(DATE,@reservationFrom))))
			BEGIN
				;THROW 52000, 'Seafood needs to be ordered in advance and only at set days!',1
				RETURN
			END
		END
		SET @ctr = @ctr-1;
	END

	BEGIN TRANSACTION

	DECLARE @getIdentity int;
	EXEC AddOrder @seats, @reservationFrom,@productsID,@customer_id, @o_employee_id, @receiveDate,@paid,@invoice_id,0, @output = @getIdentity output -- rollback inside if failed
    -- Insert statements for procedure here
	--
	IF(SELECT COUNT(*) FROM Individual_Customers WHERE @customer_id = customerID) = 1
	BEGIN
	DECLARE @productGaveDate date
	DECLARE @fromTime date = (SELECT top 1 fromTime FROM Reservation_Tables where orderID = @getIdentity)
	IF @fromTime is null
	BEGIN
	SET @productGaveDate = (SELECT orderDate FROM Orders where orderID = @getIdentity)
	END
	ELSE
	BEGIN
	SET @productGaveDate = @fromTime
	END
		IF(SELECT SUM(price)
			FROM Products_In_Menu
			JOIN Products ON Products_in_menu.productID = Products.productID
			JOIN Menus ON Products_In_Menu.menuID = Menus.menuID
			WHERE Menus.startDate <= @productGaveDate AND Menus.endDate >= @productGaveDate AND (Products_in_menu.productID IN (SELECT value FROM STRING_SPLIT(@productsID,',')))) <@WZ
		BEGIN
			ROLLBACK
			;THROW 52000, 'The reservation value is too low',1
			RETURN
		END
		IF(SELECT COUNT(*) FROM Orders WHERE @customer_id = customerID) < @WK
		BEGIN
			ROLLBACK
			;THROW 52000, 'Client does not have required amount of orders',1
			RETURN
		END
	END
	--
	INSERT INTO [dbo].[Reservations]
          (   
			reservationID,
            employeeID,
			onName
          ) 
     VALUES 
          ( 
			@getIdentity,
            @employee_id,
			@onName
          ) 
	
	COMMIT
	RETURN;
END
GO
