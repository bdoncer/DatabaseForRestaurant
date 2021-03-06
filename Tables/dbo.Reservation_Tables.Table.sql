USE [u_doncer]
GO
/****** Object:  Table [dbo].[Reservation_Tables]    Script Date: 18.03.2022 12:38:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_Tables](
	[tableID] [int] NULL,
	[fromTime] [datetime] NULL,
	[toTime] [datetime] NULL,
	[orderID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reservation_Tables]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Tables_Orders] FOREIGN KEY([orderID])
REFERENCES [dbo].[Orders] ([orderID])
GO
ALTER TABLE [dbo].[Reservation_Tables] CHECK CONSTRAINT [FK_Reservation_Tables_Orders]
GO
ALTER TABLE [dbo].[Reservation_Tables]  WITH CHECK ADD  CONSTRAINT [FK_Reservation_Tables_Table] FOREIGN KEY([tableID])
REFERENCES [dbo].[Tables] ([tableID])
GO
ALTER TABLE [dbo].[Reservation_Tables] CHECK CONSTRAINT [FK_Reservation_Tables_Table]
GO
ALTER TABLE [dbo].[Reservation_Tables]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_Tables] CHECK  ((datepart(hour,[fromTime])>=(8) AND datepart(hour,[fromTime])<=(23)))
GO
ALTER TABLE [dbo].[Reservation_Tables] CHECK CONSTRAINT [CK_Reservation_Tables]
GO
ALTER TABLE [dbo].[Reservation_Tables]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_Tables_1] CHECK  ((datepart(hour,[toTime])>=(8) AND datepart(hour,[toTime])<=(23)))
GO
ALTER TABLE [dbo].[Reservation_Tables] CHECK CONSTRAINT [CK_Reservation_Tables_1]
GO
ALTER TABLE [dbo].[Reservation_Tables]  WITH CHECK ADD  CONSTRAINT [CK_Reservation_Tables_2] CHECK  (([toTime]>[fromTime]))
GO
ALTER TABLE [dbo].[Reservation_Tables] CHECK CONSTRAINT [CK_Reservation_Tables_2]
GO
