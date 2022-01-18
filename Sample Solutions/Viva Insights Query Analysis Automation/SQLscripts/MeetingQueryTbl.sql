SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[viva_insights_meeting]
( 
	[MeetingId] [nvarchar](4000)  NOT NULL,
	[StartTimestampUTC] [datetime2](7)  NOT NULL,
	[EndTimestampUTC] [datetime2](7)  NOT NULL,
	[Organizer_PersonId] [nvarchar](4000)  NOT NULL,
	[Organizer_Organization] [nvarchar](4000)  NULL,
	[Organizer_LevelDesignation] [nvarchar](4000)  NULL,
	[Organizer_IsInternal] [bit]  NULL,
	[Attendees] [int]  NULL,
	[Attendees_with_conflicting_meetings] [int]  NULL,
	[Invitees] [int]  NULL,
	[Emails_sent_during_meetings] [int]  NULL,
	[Instant_messages_sent_during_meetings] [int]  NULL,
	[Attendees_multitasking] [int]  NULL,
	[Attendee_meeting_hours] [float]  NULL,
	[Redundant_attendees] [int]  NULL,
	[Total_meeting_cost] [float]  NULL,
	[Total_redundant_hours] [int]  NULL,
	[IsCancelled] [bit]  NULL,
	[DurationHours] [float]  NULL,
	[IsRecurring] [bit]  NULL,
	[Subject] [nvarchar](4000)  NULL,
	[TotalAccept] [int]  NULL,
	[TotalNoResponse] [int]  NULL,
	[TotalDecline] [int]  NULL,
	[TotalNoEmailsDuringMeeting] [int]  NULL,
	[TotalNoDoubleBooked] [int]  NULL,
	[TotalNoAttendees] [int]  NULL,
	[MeetingResources] [nvarchar](4000)  NULL,
	[BusinessProcesses] [nvarchar](4000)  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO