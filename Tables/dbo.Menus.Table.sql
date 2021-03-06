USE [u_doncer]
GO
/****** Object:  Table [dbo].[Menus]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menus](
	[menuID] [int] IDENTITY(1,1) NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NOT NULL,
 CONSTRAINT [PK_MenuID] PRIMARY KEY CLUSTERED 
(
	[menuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Menus]  WITH CHECK ADD  CONSTRAINT [CK_MenuID] CHECK  (([endDate]>getdate() AND [endDate]>[startDate]))
GO
ALTER TABLE [dbo].[Menus] CHECK CONSTRAINT [CK_MenuID]
GO
ALTER TABLE [dbo].[Menus]  WITH CHECK ADD  CONSTRAINT [CK_MenuID_1] CHECK  (([startDate]>=getdate()))
GO
ALTER TABLE [dbo].[Menus] CHECK CONSTRAINT [CK_MenuID_1]
GO
