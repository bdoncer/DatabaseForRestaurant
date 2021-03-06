USE [u_doncer]
GO
/****** Object:  Table [dbo].[Products_In_Menu]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products_In_Menu](
	[productID] [int] NOT NULL,
	[menuID] [int] NOT NULL,
	[price] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Products_In_Menu]  WITH CHECK ADD  CONSTRAINT [FK_Products_In_Menu_MenuID1] FOREIGN KEY([menuID])
REFERENCES [dbo].[Menus] ([menuID])
GO
ALTER TABLE [dbo].[Products_In_Menu] CHECK CONSTRAINT [FK_Products_In_Menu_MenuID1]
GO
ALTER TABLE [dbo].[Products_In_Menu]  WITH CHECK ADD  CONSTRAINT [FK_Products_In_Menu_Products1] FOREIGN KEY([productID])
REFERENCES [dbo].[Products] ([productID])
GO
ALTER TABLE [dbo].[Products_In_Menu] CHECK CONSTRAINT [FK_Products_In_Menu_Products1]
GO
ALTER TABLE [dbo].[Products_In_Menu]  WITH CHECK ADD  CONSTRAINT [CK_Products_In_Menu] CHECK  (([price]>(0)))
GO
ALTER TABLE [dbo].[Products_In_Menu] CHECK CONSTRAINT [CK_Products_In_Menu]
GO
