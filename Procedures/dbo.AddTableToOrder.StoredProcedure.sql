USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddTableToOrder]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddTableToOrder] 
	@orderID int,
	@fromTime datetime,
	@toTime datetime,
	@tableID int

AS
BEGIN
	BEGIN TRANSACTION
	SET NOCOUNT ON;
	--czy jest stolik zarezerwowany w tym czasie
	IF(SELECT tableID FROM Reservation_Tables WHERE @fromTime <= toTime AND @toTime >= fromTime AND tableID = @tableID) is not NULL
	BEGIN
		ROLLBACK
		DECLARE @msg NVARCHAR(2048) = 'Table with ID:' + CONVERT(varchar, @tableID) + ' is already reserved at this time' ;   
		;THROW 52000, @msg,1
		RETURN
	END
	BEGIN
		INSERT INTO [dbo].[Reservation_Tables]
			  (                    
				orderID,
				fromTime,
				toTime,
				tableID 
			  ) 
		 VALUES 
			  ( 
				@orderID,
				@fromTime,
				@toTime,
				@tableID
			  ) 
	END
	COMMIT
END
GO
