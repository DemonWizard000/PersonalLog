USE MASTER
GO
DROP DATABASE IF EXISTS [WorkLog.Data]

CREATE DATABASE [WorkLog.Data];

USE [WorkLog.Data]

CREATE TABLE [dbo].[Channels] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [TenantId]      BIGINT         NOT NULL,
    [Manager_email] NVARCHAR (MAX) NOT NULL,
    [Name]          NVARCHAR (MAX) NOT NULL,
    [Questions]     NVARCHAR (MAX) NOT NULL,
    [Description]     NVARCHAR (MAX) NOT NULL,
    [CreatedDate]   DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Channels] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[ChannelUsers] (
    [Id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [ChannelId] BIGINT         NOT NULL,
    [UserEmail] NVARCHAR (MAX) NOT NULL,
    [State]     INT            NOT NULL,
    CONSTRAINT [PK_ChannelUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[Groups] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ChannelId]      BIGINT         NOT NULL,
    [TenantId]      BIGINT         NOT NULL,
    [Manager_email] NVARCHAR (MAX) NOT NULL,
    [Name]          NVARCHAR (MAX) NOT NULL,
    [Description]     NVARCHAR (MAX) NOT NULL,
    [CreatedDate]   DATETIME2 (7)  NOT NULL,
    CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[GroupUsers] (
    [Id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [GroupId] BIGINT         NOT NULL,
    [UserEmail] NVARCHAR (MAX) NOT NULL,
    [State]     INT            NOT NULL,
    CONSTRAINT [PK_GroupUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[Comments] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [GroupId] BIGINT         NOT NULL,
    [To_Email] NVARCHAR (MAX) NOT NULL,
    [Log_Date]   DATETIME2 (7)  NOT NULL,
    [From_Email] NVARCHAR (MAX) NOT NULL,
    [From_Name] NVARCHAR (MAX) NOT NULL,
    [Message] NVARCHAR (MAX) NOT NULL,
    [Commented_Date]   DATETIME2 (7)  NOT NULL,
    [Parent_Comment_Id]     INT            NOT NULL,
    CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[UnreadComments] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [CommentId] BIGINT         NOT NULL,
    [UserEmail] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_UnreadComments] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[Tenants] (
    [id]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [URL]              NVARCHAR (MAX) NOT NULL,
    [PageName]         NVARCHAR (MAX) NOT NULL,
    [Title]            NVARCHAR (MAX) NOT NULL,
    [Name]             NVARCHAR (MAX) NOT NULL,
    [Description]      NVARCHAR (MAX) NOT NULL,
    [CustomCSSURL]     NVARCHAR (MAX) NOT NULL,
    [CustomSettingURL]     NVARCHAR (MAX) NOT NULL,
    [NavigationLabels] NVARCHAR (MAX) NOT NULL,
    [DefaultQuestions] NVARCHAR (MAX) NOT NULL,
    [IsReady]          BIT            NOT NULL,
    [Home_Page_Content] NVARCHAR (MAX) NOT NULL,
    [About_Page_Content] NVARCHAR (MAX) NOT NULL,
    [How_To_Page_Content] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Tenants] PRIMARY KEY CLUSTERED ([id] ASC)
);

INSERT INTO dbo.Tenants
  (URL, PageName, Title, Name, Description, CustomCSSURL, CustomSettingURL, NavigationLabels, DefaultQuestions, IsReady, Home_Page_Content, About_Page_Content, How_To_Page_Content)
VALUES
  ('localhost:7291',
   'WorkLog',
   'WorkLog',
   'WorkLog',
   'WorkLog',
   'WorkLog/styles.css',
   'WorkLog/setting.js',
   'Home,#About,#How to,#Contact us,#Performance Insights,#Feedback',
   'How do you feel?,#What are 5 things I accomplished yesterday?,#What are 5 things I didn''t completed yesterday?,#What are 5 things I can do differently today?,#What are 5 things I want to accomplish today?,#What are 5 things that might get in my way today?,#What is my commitment today?',
   1,
   'Work Log provides a guided reflection of your daily work habits.<br/> Over time, patterns will emerge and you will find opportunities to improve your work and work experience.',
   'Self-reflection leads to greater life satisfaction and personal growth.<br/>Myworklog.net provides a guided path to reviewing your work day and reflecting on your thoughts and performance.<br/>This can lead to increased self-awareness and a better understanding of one\''s strengths and weaknesses.<br/>In turn, this self-reflection can lead to improved decision-making and a more fulfilling work life (Baumeister, 2018). Research has shown that guided logs and journals can be an effective tool for self-reflection and personal growth. In a study by Baumeister et al. (2018), participants who completed a guided self-reflection exercise showed improvements in self-awareness, goal clarity, and life satisfaction.',
   '1. Follow the question prompts.<br/> 2.Spend a few moments on the Summary View when you are done.<br/> 3. After a 10 visits, you may use the Insight Options.'
);

CREATE TABLE [dbo].[WorkLog] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [QuestionId] INT            NOT NULL,
    [Answer]     NVARCHAR (MAX) NULL,
    [AnswerId]   INT            NOT NULL,
    [Email]      NVARCHAR (MAX) NOT NULL,
    [ChannelId]  INT            NOT NULL,
    [Feeling]    INT            NOT NULL,
    [Date]       DATETIME2 (7)  NULL,
    CONSTRAINT [PK_WorkLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[WordClouds] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [Word]       NVARCHAR (MAX) NULL,
    [Count]      INT            NOT NULL,
    [Email]      NVARCHAR (MAX) NOT NULL,
    [ChannelId]  INT            NOT NULL,
    [LogDate]       DATETIME2 (7)  NULL,
    CONSTRAINT [PK_WordCloud] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [dbo].[Settings] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [UserEmail]       NVARCHAR (MAX) NOT NULL,
    [Min_Freq]  INT            NOT NULL,
    [WeightFactor] INT            NOT NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([Id] ASC)
);

INSERT INTO dbo.Settings
  (UserEmail, Min_Freq, WeightFactor)
VALUES
  ('1-administrator@stephen.com',
  0,
  20);

CREATE TABLE [dbo].[Questions] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [QuestionId]       INT            NOT NULL,
    [QuestionText]      NVARCHAR (MAX) NOT NULL,
    [Variation]  INT            NOT NULL,
    [TenantId] BIGINT NOT NULL,
    CONSTRAINT [PK_Questions] PRIMARY KEY CLUSTERED ([Id] ASC)
);

CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [TenantId] bigint NOT NULL,
    [HitCount] int NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;

INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('2270e283-9ea9-47d8-a191-20136eba5e6a',
   'Administrator',
   'ADMINISTRATOR',
   NULL);

INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('05a45176-e33b-4531-a575-b10065db67f5',
   'GroupMember',
   'GROUPMEMBER',
   NULL);

INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('673af9d8-f64a-461c-bcbc-d8821bb3f053',
   'GroupOwner',
   'GROUPOWNER',
   NULL);

INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('a60101ea-c211-4606-a32f-5a0a01847adf',
   'ChannelOwner',
   'CHANNELOWNER',
   NULL);


INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('d4527c20-9162-4091-8058-79604959b0bb',
   'ChannelMember',
   'CHANNELMEMBER',
   NULL);

INSERT INTO dbo.AspNetRoles
  (Id, Name, NormalizedName, ConcurrencyStamp)
VALUES
  ('f1a6593a-c297-4fee-8a96-eb3166165b80',
   'User',
   'USER',
   NULL);

INSERT INTO dbo.AspNetUsers
  (Id, TenantId, HitCount, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnd, LockoutEnabled, AccessFailedCount)
VALUES
  ('dbee36c2-8d2d-4c81-9301-c664f4f1aaa7',
   '1',
   0,
   '1-Administrator',
   '1-ADMINISTRATOR',
   '1-administrator@stephen.com',
   '1-ADMINISTRATOR@STEPHEN.COM',
   0,
   'AQAAAAIAAYagAAAAEBPY70wSUxPTavrJwlrzJrVbvSiFLSvSRj6P8uWYugJva4gvNxhZn/Spb5tNvJE9rw==',
   'A4BDV6B3M74HZKYVMLFPI7IV3DYGWLFG',
   'c4f863e9-ea49-4fd0-9fc7-7f371b4f7cb5',
   NULL,
   0,
   0,
   NULL,
   1,
   0);

INSERT INTO dbo.AspNetUserRoles
  (UserId, RoleId)
VALUES
  ('dbee36c2-8d2d-4c81-9301-c664f4f1aaa7',
  '2270e283-9ea9-47d8-a191-20136eba5e6a');

INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (0, 1, N'How do you feel?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (0, 1, N'What is your mood? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (0, 1, N'How would you describe your emotional state?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (1, 1, N'What are 5 things I accomplished yesterday?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (1, 1, N'What are 5 things I achieved yesterday? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (1, 1, N'What were your successes yesterday?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (2, 1, N'What are 5 things I didn''t complete yesterday?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (2, 1, N'What are 5 things I didn''t finish yesterday? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (2, 1, N'What are 5 things I did not get done yesterday?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (3, 1, N'What are 5 things I can do differently today?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (3, 1, N'What are 5 changes I can make today? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (3, 1, N'What are 5 ways I can change my approach today?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (4, 1, N'What are 5 things I want to accomplish today?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (4, 1, N'What are 5 things I want to achieve today? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (4, 1, N'What are 5 things I have for goals for today?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (5, 1, N'What are 5 things that might get in my way today?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (5, 1, N'What are 5  obstacles I might face today? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (5, 1, N'What are 5 challenges that might come up today?', 2)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (6, 1, N'What is my commitment today?', 0)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (6, 1, N'What am I committed to today? ', 1)
INSERT INTO [dbo].[Questions] ([QuestionId], [TenantId], [QuestionText], [Variation]) VALUES (6, 1, N'What is my commit?', 2)