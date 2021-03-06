USE [u_doncer]
GO
/****** Object:  Table [dbo].[Individual_Customers]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Individual_Customers](
	[customerID] [int] NOT NULL,
	[firstName] [varchar](30) NOT NULL,
	[lastName] [varchar](30) NOT NULL,
 CONSTRAINT [Invidual_Customer_pk] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Individual_Customers]  WITH CHECK ADD  CONSTRAINT [FK_Invidual_Customer_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customers] ([customerID])
GO
ALTER TABLE [dbo].[Individual_Customers] CHECK CONSTRAINT [FK_Invidual_Customer_Customer]
GO
