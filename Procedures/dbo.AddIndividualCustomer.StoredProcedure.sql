USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddIndividualCustomer]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddIndividualCustomer] 
	-- Add the parameters for the stored procedure here
	@f_name varchar(30), 
	@l_name varchar(30),
	@street varchar(30),
	@city varchar(30),
	@postal_code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Customers]
          (                    
            street,
			city,
			postalCode
          ) 
     VALUES 
          ( 
            @street,
			@city,
			@postal_code
          ) 
	INSERT INTO [dbo].[Individual_Customers]
          (   
		    customerID,
            firstName,
			lastName
          ) 
     VALUES 
          ( 
			SCOPE_IDENTITY(),
            @f_name,
			@l_name
          ) 

	

END
GO
