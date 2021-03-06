USE [u_doncer]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[street] [varchar](30) NOT NULL,
	[city] [varchar](30) NOT NULL,
	[postalCode] [int] NOT NULL,
 CONSTRAINT [Customer_pk] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [CK_Customer] CHECK  ((len([postalCode])=(5)))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Customer]
GO
