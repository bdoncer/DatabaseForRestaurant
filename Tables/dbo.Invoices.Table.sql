USE [u_doncer]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[invoiceID] [int] IDENTITY(1,1) NOT NULL,
	[issueDate] [date] NOT NULL,
	[companyName] [varchar](10) NULL,
	[street] [varchar](10) NOT NULL,
	[city] [varchar](10) NOT NULL,
	[postalCode] [varchar](30) NOT NULL,
	[firstName] [varchar](30) NULL,
	[lastName] [varchar](30) NULL,
 CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED 
(
	[invoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
