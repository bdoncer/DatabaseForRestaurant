USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddMenu]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddMenu] 
    @startDate date,
    @endDate date,
    @productsID varchar(500),
    @productsPrice varchar(500)
AS
BEGIN
	IF (SELECT COUNT(*) FROM Menus WHERE  @startDate <= endDate AND @endDate >= startDate) != 0
		BEGIN
			ROLLBACK
			;THROW 52000, 'There cannot be two menus at the same time',1
			RETURN
		END

	BEGIN TRANSACTION
	--polowa rzeczy musi sie zmienic
	INSERT INTO [dbo].[Menus]
          (
            startDate,
            endDate
          ) 
     VALUES 
          ( 
            @startDate,
            @endDate
          ) 
    SET NOCOUNT ON;
    DECLARE @ctr AS int ;
    DECLARE @prID AS varchar(10);
    DECLARE @prPrice AS varchar(10);
	DECLARE @productID AS INT;
	DECLARE @productPrice AS INT;
	DECLARE @ident AS INT = SCOPE_IDENTITY();
	DECLARE @lastMenuID AS INT;
	DECLARE @howManyChanged AS INT = 0;
    SET @ctr = (SELECT COUNT(*) FROM STRING_SPLIT(@productsID,','));
	SET @ident = SCOPE_IDENTITY();
	SET @lastMenuID = (SELECT MenuID FROM Menus WHERE DATEDIFF(DAY,endDate,@startDate) = 1);
	IF (@ctr != (SELECT COUNT(*) FROM STRING_SPLIT(@productsPrice,',')))
		BEGIN
			ROLLBACK
			;THROW 52000, 'Length of productID list is different that length of prices list',1
			RETURN
		END
    WHILE @ctr >= 1
    BEGIN
        SET @prID = ((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@productsID,',')) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@productsID,','))as d));
        SET @prPrice =  ((SELECT TOP (@ctr) * FROM (SELECT value FROM STRING_SPLIT(@productsPrice,',')) as p) EXCEPT (SELECT TOP (@ctr-1) * FROM (SELECT value FROM STRING_SPLIT(@productsPrice,','))as d));
        SET @productID  = CAST(@prID AS INT);
		SET @productPrice = CAST(@prPrice AS INT);
		IF ((SELECT COUNT(*) FROM Products WHERE productID = @productID) < 1)
		BEGIN
			ROLLBACK
			DECLARE @msg NVARCHAR(2048) = 'Product with ID:' + CONVERT(varchar, @productID) + ' does not exist' ;   
			;THROW 52000, @msg,1
			RETURN
		END
		IF ((SELECT COUNT(*) FROM Products_In_Menu WHERE MenuID = @lastMenuID AND productID = @productID) = 0)
		BEGIN
			SET @howManyChanged = @howManyChanged + 1;
		END
		EXEC AddProductToMenu @productID ,@ident,@productPrice -- rollback inside if failed
        SET @ctr = @ctr-1
    END
    IF (@howManyChanged*2 < @ctr)
		BEGIN
			ROLLBACK
			;THROW 52000, 'At least half of the products must be new',1
			RETURN
		END
	COMMIT
END
GO
