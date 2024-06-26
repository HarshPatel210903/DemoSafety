USE [master]
GO
/****** Object:  Database [DemoSafety]    Script Date: 27-05-2024 18:51:35 ******/
CREATE DATABASE [DemoSafety]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DemoSafety', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\DemoSafety.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DemoSafety_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\DemoSafety_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DemoSafety] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DemoSafety].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DemoSafety] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DemoSafety] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DemoSafety] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DemoSafety] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DemoSafety] SET ARITHABORT OFF 
GO
ALTER DATABASE [DemoSafety] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DemoSafety] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DemoSafety] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DemoSafety] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DemoSafety] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DemoSafety] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DemoSafety] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DemoSafety] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DemoSafety] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DemoSafety] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DemoSafety] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DemoSafety] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DemoSafety] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DemoSafety] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DemoSafety] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DemoSafety] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DemoSafety] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DemoSafety] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DemoSafety] SET  MULTI_USER 
GO
ALTER DATABASE [DemoSafety] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DemoSafety] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DemoSafety] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DemoSafety] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [DemoSafety] SET DELAYED_DURABILITY = DISABLED 
GO
USE [DemoSafety]
GO
/****** Object:  UserDefinedFunction [dbo].[fGetApproverID]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fGetApproverID](@StageID BIGINT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @ApproverID BIGINT;

    SELECT @ApproverID = sr.UserID
    FROM dbo.tStageRoles sr
    WHERE sr.StageID = @StageID;

    RETURN @ApproverID;
END

GO
/****** Object:  UserDefinedFunction [dbo].[fGetNextStageID]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fGetNextStageID] (@CurrentStageID BIGINT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @NextStageID BIGINT;
    
    SELECT @NextStageID = StageID
    FROM dbo.tStage
    WHERE [Order] = (
        SELECT [Order] + 1
        FROM dbo.tStage
        WHERE StageID = @CurrentStageID
    );

    RETURN @NextStageID;
END

GO
/****** Object:  UserDefinedFunction [dbo].[fGetPreviousStageID]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fGetPreviousStageID] (@CurrentStageID BIGINT)
RETURNS BIGINT
AS
BEGIN
    DECLARE @PreviousStageID BIGINT;

    -- Determine the previous stage based on stage order
    SELECT @PreviousStageID = StageID
    FROM dbo.tStage
    WHERE [Order] = (
        SELECT [Order] - 1
        FROM dbo.tStage
        WHERE StageID = @CurrentStageID
    );

    RETURN @PreviousStageID;
END

GO
/****** Object:  Table [dbo].[tCertificate]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCertificate](
	[CertificateID] [bigint] IDENTITY(1,1) NOT NULL,
	[StudentName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DateIssued] [date] NULL,
	[Status] [nvarchar](max) NULL,
	[CurrentStageID] [bigint] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NOT NULL,
	[LastUpdated] [datetime] NOT NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[CertificateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tCertificateLog]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCertificateLog](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CertificateID] [bigint] NOT NULL,
	[StageID] [bigint] NOT NULL,
	[ApproverID] [bigint] NOT NULL,
	[ApprovalStatus] [nvarchar](50) NOT NULL,
	[DateApproved] [datetime] NULL,
	[Comments] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRoles]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRoles](
	[RoleID] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[RoleType] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tRoleType]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tRoleType](
	[Id] [bigint] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tStage]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tStage](
	[StageID] [bigint] IDENTITY(1,1) NOT NULL,
	[StageName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Order] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tStageRoles]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tStageRoles](
	[StageRoleID] [bigint] IDENTITY(1,1) NOT NULL,
	[StageID] [bigint] NOT NULL,
	[AlertDays] [int] NOT NULL,
	[UserId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StageRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tUsers]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUsers](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Role] [bigint] NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Password] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[tCertificate] ON 

INSERT [dbo].[tCertificate] ([CertificateID], [StudentName], [Description], [DateIssued], [Status], [CurrentStageID], [Comments], [CreatedBy], [LastUpdated]) VALUES (1, N'Harsh Patel', N'qwert', CAST(N'2024-05-24' AS Date), N'Approved', 6, NULL, 1, CAST(N'2024-05-24 15:15:02.010' AS DateTime))
SET IDENTITY_INSERT [dbo].[tCertificate] OFF
SET IDENTITY_INSERT [dbo].[tCertificateLog] ON 

INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (1, 1, 1, 1, N'Created', CAST(N'2024-05-24 15:01:57.420' AS DateTime), N'Initial creation by principal')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (2, 1, 2, 2, N'Approved', CAST(N'2024-05-24 15:02:09.570' AS DateTime), N'looks good')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (3, 1, 3, 3, N'Approved', CAST(N'2024-05-24 15:12:54.420' AS DateTime), N'ok')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (4, 1, 4, 4, N'Approved', CAST(N'2024-05-24 15:13:07.777' AS DateTime), N'looks good')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (5, 1, 5, 5, N'Rejected', CAST(N'2024-05-24 15:13:23.650' AS DateTime), N'asd')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (6, 1, 4, 4, N'Rejected', CAST(N'2024-05-24 15:13:30.160' AS DateTime), N'asd')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (7, 1, 3, 3, N'Rejected', CAST(N'2024-05-24 15:13:37.220' AS DateTime), N'asd')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (8, 1, 2, 2, N'Approved', CAST(N'2024-05-24 15:14:43.227' AS DateTime), N'looks good')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (9, 1, 3, 3, N'Approved', CAST(N'2024-05-24 15:14:49.697' AS DateTime), N'ok')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (10, 1, 4, 4, N'Approved', CAST(N'2024-05-24 15:14:55.713' AS DateTime), N'looks good')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (11, 1, 5, 5, N'Approved', CAST(N'2024-05-24 15:15:02.010' AS DateTime), N'looks good')
INSERT [dbo].[tCertificateLog] ([ID], [CertificateID], [StageID], [ApproverID], [ApprovalStatus], [DateApproved], [Comments]) VALUES (12, 1, 6, 1, N'Received', CAST(N'2024-05-24 15:15:02.010' AS DateTime), N'Fully approved and completed')
SET IDENTITY_INSERT [dbo].[tCertificateLog] OFF
SET IDENTITY_INSERT [dbo].[tRoles] ON 

INSERT [dbo].[tRoles] ([RoleID], [RoleName], [Description], [RoleType]) VALUES (1, N'Principal', NULL, 1)
INSERT [dbo].[tRoles] ([RoleID], [RoleName], [Description], [RoleType]) VALUES (2, N'Admin', NULL, 2)
INSERT [dbo].[tRoles] ([RoleID], [RoleName], [Description], [RoleType]) VALUES (3, N'HR', NULL, 2)
INSERT [dbo].[tRoles] ([RoleID], [RoleName], [Description], [RoleType]) VALUES (4, N'Team Lead', NULL, 2)
INSERT [dbo].[tRoles] ([RoleID], [RoleName], [Description], [RoleType]) VALUES (5, N'Manager', NULL, 2)
SET IDENTITY_INSERT [dbo].[tRoles] OFF
INSERT [dbo].[tRoleType] ([Id], [Type]) VALUES (1, N'college')
INSERT [dbo].[tRoleType] ([Id], [Type]) VALUES (2, N'company')
SET IDENTITY_INSERT [dbo].[tStage] ON 

INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (1, N'Initiation', N'principal will fill out the certificate', 1)
INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (2, N'approvalByEmp', N'some employee will review the certificate', 2)
INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (3, N'approvalByTL', N'TL will review the certificate', 3)
INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (4, N'approvalByHR', N'HR will review the certificate', 4)
INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (5, N'approvalByManager', N'Manager will review the certificate', 5)
INSERT [dbo].[tStage] ([StageID], [StageName], [Description], [Order]) VALUES (6, N'approved', N'the principal will recieve the approved certificate', 6)
SET IDENTITY_INSERT [dbo].[tStage] OFF
SET IDENTITY_INSERT [dbo].[tStageRoles] ON 

INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (1, 1, 0, 1)
INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (2, 2, 2, 2)
INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (3, 3, 2, 3)
INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (4, 4, 2, 4)
INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (5, 5, 2, 5)
INSERT [dbo].[tStageRoles] ([StageRoleID], [StageID], [AlertDays], [UserId]) VALUES (6, 6, 0, 1)
SET IDENTITY_INSERT [dbo].[tStageRoles] OFF
SET IDENTITY_INSERT [dbo].[tUsers] ON 

INSERT [dbo].[tUsers] ([UserID], [Name], [Role], [Email], [Password]) VALUES (1, N'Princy Patel', 1, N'princypatel@gmail.com', N'qq11QQ!!')
INSERT [dbo].[tUsers] ([UserID], [Name], [Role], [Email], [Password]) VALUES (2, N'Aditya Mehta', 2, N'adityamehta@gmail.com', N'qq11QQ!!')
INSERT [dbo].[tUsers] ([UserID], [Name], [Role], [Email], [Password]) VALUES (3, N'Hitesh Roy', 3, N'hiteshroy@gmail.com', N'qq11QQ!!')
INSERT [dbo].[tUsers] ([UserID], [Name], [Role], [Email], [Password]) VALUES (4, N'Tanmay Lohia', 4, N'tanmaylohia@gmail.com', N'qq11QQ!!')
INSERT [dbo].[tUsers] ([UserID], [Name], [Role], [Email], [Password]) VALUES (5, N'Manish Gupta', 5, N'manishgupta@gmail.com', N'qq11QQ!!')
SET IDENTITY_INSERT [dbo].[tUsers] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__tUsers__A9D10534FD28B29B]    Script Date: 27-05-2024 18:51:35 ******/
ALTER TABLE [dbo].[tUsers] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tCertificate]  WITH CHECK ADD FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tUsers] ([UserID])
GO
ALTER TABLE [dbo].[tCertificate]  WITH CHECK ADD FOREIGN KEY([CurrentStageID])
REFERENCES [dbo].[tStage] ([StageID])
GO
ALTER TABLE [dbo].[tCertificateLog]  WITH CHECK ADD FOREIGN KEY([ApproverID])
REFERENCES [dbo].[tUsers] ([UserID])
GO
ALTER TABLE [dbo].[tCertificateLog]  WITH CHECK ADD FOREIGN KEY([CertificateID])
REFERENCES [dbo].[tCertificate] ([CertificateID])
GO
ALTER TABLE [dbo].[tCertificateLog]  WITH CHECK ADD FOREIGN KEY([StageID])
REFERENCES [dbo].[tStage] ([StageID])
GO
ALTER TABLE [dbo].[tRoles]  WITH CHECK ADD FOREIGN KEY([RoleType])
REFERENCES [dbo].[tRoleType] ([Id])
GO
ALTER TABLE [dbo].[tStageRoles]  WITH CHECK ADD FOREIGN KEY([StageID])
REFERENCES [dbo].[tStage] ([StageID])
GO
ALTER TABLE [dbo].[tStageRoles]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[tUsers] ([UserID])
GO
ALTER TABLE [dbo].[tUsers]  WITH CHECK ADD FOREIGN KEY([Role])
REFERENCES [dbo].[tRoles] ([RoleID])
GO
/****** Object:  StoredProcedure [dbo].[pApproveCertificate]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pApproveCertificate]
    @CertificateID BIGINT,
    @ApproverID BIGINT,
    @Comments NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStageID BIGINT, @NextStageID BIGINT, @CurrentDate DATETIME;

    -- Get the current date
    SET @CurrentDate = GETDATE();
    
    -- Get the current stage of the certificate
    SELECT @CurrentStageID = CurrentStageID
    FROM dbo.tCertificate
    WHERE CertificateID = @CertificateID;

    -- Get the next stage ID
    SET @NextStageID = dbo.fGetNextStageID(@CurrentStageID);

    -- Update the approval log for the current stage
    UPDATE dbo.tCertificateLog
    SET ApprovalStatus = 'Approved',
        DateApproved = @CurrentDate,
        Comments = @Comments
    WHERE CertificateID = @CertificateID AND StageID = @CurrentStageID and ApprovalStatus='Pending';

    -- Check if the next stage is the last stage
    IF NOT EXISTS (SELECT 1 FROM dbo.tStage WHERE [Order] > (SELECT [Order] FROM dbo.tStage WHERE StageID = @NextStageID))
    BEGIN
        -- The next stage is the last stage
        UPDATE dbo.tCertificate
        SET CurrentStageID = @NextStageID,
            Status = 'Approved',
            LastUpdated = @CurrentDate
        WHERE CertificateID = @CertificateID;

        -- Log the final stage approval
        INSERT INTO dbo.tCertificateLog (CertificateID, StageID, ApproverID, ApprovalStatus, DateApproved, Comments)
        VALUES (@CertificateID, @NextStageID, [dbo].[fGetApproverID](@NextStageID), 'Received', @CurrentDate, 'Fully approved and completed');
    END
    ELSE
    BEGIN
        -- The next stage is not the last stage
        -- Update the certificate to the next stage
        UPDATE dbo.tCertificate
        SET CurrentStageID = @NextStageID,
            LastUpdated = @CurrentDate
        WHERE CertificateID = @CertificateID;

        -- Log the new stage (if it exists)
        IF @NextStageID IS NOT NULL
        BEGIN
            INSERT INTO dbo.tCertificateLog (CertificateID, StageID, ApproverID, ApprovalStatus, DateApproved, Comments)
            VALUES (@CertificateID, @NextStageID, [dbo].[fGetApproverID](@NextStageID), 'Pending', NULL, 'Awaiting review');
        END
    END
END


GO
/****** Object:  StoredProcedure [dbo].[pCreateCertificate]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pCreateCertificate]
    @StudentName NVARCHAR(150),
    @Description NVARCHAR(MAX),
    @CreatedBy BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CertificateID BIGINT, @InitialStageID BIGINT, @NextStageID BIGINT, @ApproverID BIGINT, @CurrentDate DATETIME;
    
    -- Get the current date
    SET @CurrentDate = GETDATE();
    
    -- Get the initial stage ID 
    SELECT @InitialStageID = StageID FROM dbo.tStage WHERE [Order] = 1;
    
    -- Insert the new certificate
    INSERT INTO dbo.tCertificate (StudentName, Description, DateIssued, Status, CurrentStageID, Comments, CreatedBy, LastUpdated)
    VALUES (@StudentName, @Description, @CurrentDate, 'Under review', @InitialStageID, NULL, @CreatedBy, @CurrentDate);
    
    -- Get the CertificateID of the newly inserted certificate
    SET @CertificateID = SCOPE_IDENTITY();
    
    -- Insert into the certificate log to record the creation
    INSERT INTO dbo.tCertificateLog (CertificateID, StageID, ApproverID, ApprovalStatus, DateApproved, Comments)
    VALUES (@CertificateID, @InitialStageID, @CreatedBy, 'Created', @CurrentDate, 'Initial creation by principal');
    
    -- Get the next stage ID
    SELECT @NextStageID = StageID FROM dbo.tStage WHERE [Order] = [dbo].fGetNextStageID(@InitialStageID);
    
    -- Get the user ID who will approve the next stage
    SELECT @ApproverID = dbo.fGetApproverID(@NextStageID);
    
    -- Update the certificate to the next stage
    UPDATE dbo.tCertificate
    SET CurrentStageID = @NextStageID
    WHERE CertificateID = @CertificateID;
    
    -- Insert into the certificate log to record the stage change
    INSERT INTO dbo.tCertificateLog (CertificateID, StageID, ApproverID, ApprovalStatus, DateApproved, Comments)
    VALUES (@CertificateID, @NextStageID, @ApproverID, 'Pending', NULL, 'Awaiting admin review');
    
END

GO
/****** Object:  StoredProcedure [dbo].[pGetCertificatesForPrincipal]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pGetCertificatesForPrincipal]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CertificateID, 
        StudentName, 
        Description, 
        DateIssued, 
        Status, 
        LastUpdated
    FROM 
        dbo.tCertificate;
END

GO
/****** Object:  StoredProcedure [dbo].[pGetCertificatesForReviewer]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pGetCertificatesForReviewer] 
    @reviewerID BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    -- Select all certificates for the given reviewer with a status of 'Pending'
    SELECT 
        c.CertificateID, 
        c.StudentName, 
        c.Description, 
        c.DateIssued
    FROM 
        dbo.tCertificate c
    INNER JOIN 
        dbo.tCertificateLog cl ON c.CertificateID = cl.CertificateID
    WHERE 
        cl.ApproverID = @reviewerID 
        AND cl.ApprovalStatus = 'Pending';
END;

GO
/****** Object:  StoredProcedure [dbo].[pRejectCertificate]    Script Date: 27-05-2024 18:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pRejectCertificate]
    @CertificateID BIGINT,
    @ApproverID BIGINT,
    @Comments NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentStageID BIGINT, @PreviousStageID BIGINT, @CurrentDate DATETIME;

    -- Get the current date
    SET @CurrentDate = GETDATE();
    
    -- Get the current stage of the certificate
    SELECT @CurrentStageID = CurrentStageID
    FROM dbo.tCertificate
    WHERE CertificateID = @CertificateID;

    -- Get the previous stage ID (assuming there is a function or logic to determine this)
    SET @PreviousStageID = dbo.fGetPreviousStageID(@CurrentStageID);

    -- Update the rejection log for the current stage
    UPDATE dbo.tCertificateLog
    SET ApprovalStatus = 'Rejected',
        DateApproved = @CurrentDate,
        Comments = @Comments
    WHERE CertificateID = @CertificateID AND StageID = @CurrentStageID and ApprovalStatus = 'Pending';

    
    BEGIN
        -- Update the certificate to the previous stage
        UPDATE dbo.tCertificate
        SET CurrentStageID = @PreviousStageID,
            LastUpdated = @CurrentDate
        WHERE CertificateID = @CertificateID;

        -- Log the rejection and sending back to previous stage
        INSERT INTO dbo.tCertificateLog (CertificateID, StageID, ApproverID, ApprovalStatus, DateApproved, Comments)
        VALUES (@CertificateID, @PreviousStageID, dbo.fGetApproverID(@PreviousStageID), 'Pending', NULL, 'Sent back to previous stage due to rejection');
    END
END
GO
USE [master]
GO
ALTER DATABASE [DemoSafety] SET  READ_WRITE 
GO
