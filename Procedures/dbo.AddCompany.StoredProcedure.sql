USE [u_doncer]
GO
/****** Object:  StoredProcedure [dbo].[AddCompany]    Script Date: 18.03.2022 12:39:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[AddCompany]    Script Date: 2022-01-06 19:27:40 ******/

CREATE PROCEDURE [dbo].[AddCompany] 
	-- Add the parameters for the stored procedure here
	@company_name varchar(30), 
	@nip varchar(10),
	@street varchar(30),
	@city varchar(30),
	@postal_code int
AS
BEGIN
	SET NOCOUNT ON;
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
	--SET IDENTITY_INSERT [dbo].[Company] ON	
	INSERT INTO [dbo].[Companies]
          (   
		    customerID,
            companyName,
			nip
          ) 
     VALUES 
          ( 
			SCOPE_IDENTITY(),
            @company_name,
			@nip
          ) 
	--SET IDENTITY_INSERT [dbo].[Company] OFF
	
END
GO
