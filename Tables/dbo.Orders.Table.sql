USE [u_doncer]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[orderID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NULL,
	[employeeID] [int] NULL,
	[orderDate] [datetime] NOT NULL,
	[receiveDate] [date] NULL,
	[paid] [bit] NOT NULL,
	[discount] [int] NOT NULL,
	[invoiceID] [int] NULL,
 CONSTRAINT [Orders_pk] PRIMARY KEY CLUSTERED 
(
	[orderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_paid]  DEFAULT ((0)) FOR [paid]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_discount]  DEFAULT ((0)) FOR [discount]
GO
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_issuedInvoice]  DEFAULT ((0)) FOR [invoiceID]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customer1] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customers] ([customerID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customer1]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Employees] FOREIGN KEY([employeeID])
REFERENCES [dbo].[Employees] ([employeeID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Employees]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Invoices] FOREIGN KEY([invoiceID])
REFERENCES [dbo].[Invoices] ([invoiceID])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Invoices]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_Orders] CHECK  (([receiveDate]=CONVERT([date],getdate())))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [CK_Orders_1] CHECK  (([discount]>=(0) AND [discount]<=(100)))
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [CK_Orders_1]
GO
