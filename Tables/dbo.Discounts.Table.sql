USE [u_doncer]
GO
/****** Object:  Table [dbo].[Discounts]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discounts](
	[discountID] [int] NOT NULL,
	[customerID] [int] NOT NULL,
	[expireDate] [date] NULL,
 CONSTRAINT [Discounts_pk] PRIMARY KEY CLUSTERED 
(
	[discountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [FK_Discounts_Invidual_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Individual_Customers] ([customerID])
GO
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [FK_Discounts_Invidual_Customer]
GO
ALTER TABLE [dbo].[Discounts]  WITH CHECK ADD  CONSTRAINT [CK_Discounts] CHECK  (([expireDate]>=getdate()))
GO
ALTER TABLE [dbo].[Discounts] CHECK CONSTRAINT [CK_Discounts]
GO
