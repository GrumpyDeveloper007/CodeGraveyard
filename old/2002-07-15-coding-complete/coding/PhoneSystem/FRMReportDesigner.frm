VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#5.0#0"; "TXTBOX.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DATECONTROL.OCX"
Begin VB.Form FRMReportDesigner 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Report Designer"
   ClientHeight    =   6960
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6960
   ScaleWidth      =   11685
   Begin VB.CheckBox CHKAutoPreview 
      Caption         =   "Auto Preview"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   2640
      TabIndex        =   44
      Top             =   6600
      Width           =   1575
   End
   Begin VB.CheckBox CHKWeek 
      Caption         =   "Week"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   9240
      TabIndex        =   36
      Top             =   660
      Width           =   975
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5355
      Left            =   0
      TabIndex        =   10
      Top             =   1140
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   9446
      _Version        =   393216
      TabHeight       =   520
      TabCaption(0)   =   "Data Selection"
      TabPicture(0)   =   "FRMReportDesigner.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "LBLZ1(1)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "LBLZ1(2)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "LBLZ1(6)"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "LBLZ1(7)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "LBLZ1(3)"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "LBLZ1(4)"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "LBLZ1(12)"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "TXTDayModulo"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).Control(8)=   "TXTDays"
      Tab(0).Control(8).Enabled=   0   'False
      Tab(0).Control(9)=   "CBODirection"
      Tab(0).Control(9).Enabled=   0   'False
      Tab(0).Control(10)=   "CBOYContext"
      Tab(0).Control(10).Enabled=   0   'False
      Tab(0).Control(11)=   "CBOZGroup"
      Tab(0).Control(11).Enabled=   0   'False
      Tab(0).Control(12)=   "CBOStartHour"
      Tab(0).Control(12).Enabled=   0   'False
      Tab(0).Control(13)=   "CBOFinishHour"
      Tab(0).Control(13).Enabled=   0   'False
      Tab(0).Control(14)=   "CMDDaysLeft"
      Tab(0).Control(14).Enabled=   0   'False
      Tab(0).Control(15)=   "CMDDaysRight"
      Tab(0).Control(15).Enabled=   0   'False
      Tab(0).Control(16)=   "CMDDayModuloLeft"
      Tab(0).Control(16).Enabled=   0   'False
      Tab(0).Control(17)=   "CMDDayModuloRight"
      Tab(0).Control(17).Enabled=   0   'False
      Tab(0).ControlCount=   18
      TabCaption(1)   =   "Graph Layout"
      TabPicture(1)   =   "FRMReportDesigner.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "CHKShowAvailible"
      Tab(1).Control(1)=   "CHKShowYScale"
      Tab(1).Control(2)=   "CBOReportType"
      Tab(1).Control(3)=   "CHKNoColour"
      Tab(1).Control(4)=   "CMDUnitHeightRight"
      Tab(1).Control(5)=   "CMDUnitHeightLeft"
      Tab(1).Control(6)=   "CHKShortDate"
      Tab(1).Control(7)=   "CHKShowDateInHeadings"
      Tab(1).Control(8)=   "CMDHeightBarFrequencyRight"
      Tab(1).Control(9)=   "CMDHeightBarFrequencyLeft"
      Tab(1).Control(10)=   "CMDMinutePerLineRight"
      Tab(1).Control(11)=   "CMDMinutePerLineLeft"
      Tab(1).Control(12)=   "CHKShowDayInLineName"
      Tab(1).Control(13)=   "CHKShowHeadingsOncePerGroup"
      Tab(1).Control(14)=   "CHKShowDateInLineName"
      Tab(1).Control(15)=   "CHKTotals"
      Tab(1).Control(16)=   "CHKShowHeightBars"
      Tab(1).Control(17)=   "CHKShowHours"
      Tab(1).Control(18)=   "CHKSeperateGroups"
      Tab(1).Control(19)=   "CBOGraphType"
      Tab(1).Control(20)=   "TXTHeightBarFrequency"
      Tab(1).Control(21)=   "TXTMinuteLine"
      Tab(1).Control(22)=   "TXTUnitHeight"
      Tab(1).Control(23)=   "LBLZ1(16)"
      Tab(1).Control(24)=   "LBLZ1(15)"
      Tab(1).Control(25)=   "LBLZ1(8)"
      Tab(1).Control(26)=   "LBLZ1(9)"
      Tab(1).Control(27)=   "LBLZ1(5)"
      Tab(1).ControlCount=   28
      TabCaption(2)   =   "Data Filtering"
      TabPicture(2)   =   "FRMReportDesigner.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "CHKUseYStartEnd"
      Tab(2).Control(1)=   "CMDYEndRight"
      Tab(2).Control(2)=   "TXTYStartRight"
      Tab(2).Control(3)=   "TXTYEndLeft"
      Tab(2).Control(4)=   "CMDYStartLeft"
      Tab(2).Control(5)=   "LSTYGroup"
      Tab(2).Control(6)=   "TXTYStart"
      Tab(2).Control(7)=   "TXTYEnd"
      Tab(2).Control(8)=   "LBLZ1(14)"
      Tab(2).Control(9)=   "LBLZ1(13)"
      Tab(2).Control(10)=   "LBLZ1(11)"
      Tab(2).ControlCount=   11
      Begin VB.CheckBox CHKShowAvailible 
         Caption         =   "Show Availible"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -71520
         TabIndex        =   70
         Top             =   4800
         Width           =   1695
      End
      Begin VB.CheckBox CHKShowYScale 
         Caption         =   "Show Y Scale"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -71520
         TabIndex        =   69
         Top             =   5040
         Width           =   1695
      End
      Begin VB.ComboBox CBOReportType 
         Height          =   315
         Left            =   -73440
         Style           =   2  'Dropdown List
         TabIndex        =   67
         Top             =   360
         Width           =   2295
      End
      Begin VB.CheckBox CHKNoColour 
         Caption         =   "No Colour"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   66
         Top             =   4380
         Width           =   1335
      End
      Begin VB.CommandButton CMDUnitHeightRight 
         Caption         =   ">"
         Height          =   315
         Left            =   -72000
         TabIndex        =   62
         Top             =   4680
         Width           =   255
      End
      Begin VB.CommandButton CMDUnitHeightLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   -72240
         TabIndex        =   63
         Top             =   4680
         Width           =   255
      End
      Begin VB.CheckBox CHKUseYStartEnd 
         Caption         =   "Use Y Start / End"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73560
         TabIndex        =   61
         Top             =   2160
         Width           =   1935
      End
      Begin VB.CommandButton CMDYEndRight 
         Caption         =   ">"
         Height          =   315
         Left            =   -72480
         TabIndex        =   57
         Top             =   2880
         Width           =   255
      End
      Begin VB.CommandButton TXTYStartRight 
         Caption         =   ">"
         Height          =   315
         Left            =   -72480
         TabIndex        =   53
         Top             =   2460
         Width           =   255
      End
      Begin VB.CommandButton TXTYEndLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   -72720
         TabIndex        =   58
         Top             =   2880
         Width           =   255
      End
      Begin VB.CommandButton CMDYStartLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   -72720
         TabIndex        =   54
         Top             =   2460
         Width           =   255
      End
      Begin VB.CommandButton CMDDayModuloRight 
         Caption         =   ">"
         Height          =   315
         Left            =   2880
         TabIndex        =   49
         Top             =   2100
         Width           =   255
      End
      Begin VB.CommandButton CMDDayModuloLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   2640
         TabIndex        =   50
         Top             =   2100
         Width           =   255
      End
      Begin VB.CheckBox CHKShortDate 
         Caption         =   "Short Date"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73440
         TabIndex        =   48
         Top             =   4080
         Width           =   1335
      End
      Begin VB.CheckBox CHKShowDateInHeadings 
         Caption         =   "Show Date In Headings"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   47
         Top             =   1980
         Width           =   2415
      End
      Begin VB.ListBox LSTYGroup 
         Height          =   1635
         Left            =   -73560
         Style           =   1  'Checkbox
         TabIndex        =   45
         Top             =   420
         Width           =   3855
      End
      Begin VB.CommandButton CMDHeightBarFrequencyRight 
         Caption         =   ">"
         Height          =   315
         Left            =   -70440
         TabIndex        =   42
         Top             =   1560
         Width           =   255
      End
      Begin VB.CommandButton CMDHeightBarFrequencyLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   -70680
         TabIndex        =   43
         Top             =   1560
         Width           =   255
      End
      Begin VB.CommandButton CMDMinutePerLineRight 
         Caption         =   ">"
         Height          =   315
         Left            =   -70440
         TabIndex        =   41
         Top             =   1200
         Width           =   255
      End
      Begin VB.CommandButton CMDMinutePerLineLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   -70680
         TabIndex        =   40
         Top             =   1200
         Width           =   255
      End
      Begin VB.CommandButton CMDDaysRight 
         Caption         =   ">"
         Height          =   315
         Left            =   2880
         TabIndex        =   39
         Top             =   1680
         Width           =   255
      End
      Begin VB.CommandButton CMDDaysLeft 
         Caption         =   "<"
         Height          =   315
         Left            =   2640
         TabIndex        =   38
         Top             =   1680
         Width           =   255
      End
      Begin VB.CheckBox CHKShowDayInLineName 
         Caption         =   "Show Day In Line Name"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73560
         TabIndex        =   35
         Top             =   3780
         Width           =   2535
      End
      Begin VB.CheckBox CHKShowHeadingsOncePerGroup 
         Caption         =   "Show Headings Once Per Group"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   34
         Top             =   2820
         Width           =   3375
      End
      Begin VB.CheckBox CHKShowDateInLineName 
         Caption         =   "Show Date In Line Name"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   33
         Top             =   3480
         Width           =   2535
      End
      Begin VB.CheckBox CHKTotals 
         Caption         =   "Totals"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   32
         Top             =   5040
         Width           =   975
      End
      Begin VB.CheckBox CHKShowHeightBars 
         Caption         =   "Show Height Bars"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   31
         Top             =   2340
         Width           =   1935
      End
      Begin VB.CheckBox CHKShowHours 
         Caption         =   "Show Hours(Headings)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   30
         Top             =   2580
         Width           =   2415
      End
      Begin VB.CheckBox CHKSeperateGroups 
         Caption         =   "Seperate Groups"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   -73680
         TabIndex        =   29
         Top             =   3180
         Width           =   1815
      End
      Begin VB.ComboBox CBOFinishHour 
         Height          =   315
         Left            =   1800
         Style           =   2  'Dropdown List
         TabIndex        =   26
         Top             =   2880
         Width           =   1455
      End
      Begin VB.ComboBox CBOStartHour 
         Height          =   315
         Left            =   1800
         Style           =   2  'Dropdown List
         TabIndex        =   25
         Top             =   2520
         Width           =   1455
      End
      Begin VB.ComboBox CBOGraphType 
         Height          =   315
         Left            =   -73440
         Style           =   2  'Dropdown List
         TabIndex        =   19
         Top             =   780
         Width           =   2655
      End
      Begin VB.ComboBox CBOZGroup 
         Height          =   315
         Left            =   1800
         Style           =   2  'Dropdown List
         TabIndex        =   13
         Top             =   1140
         Width           =   1575
      End
      Begin VB.ComboBox CBOYContext 
         Height          =   315
         Left            =   1800
         Style           =   2  'Dropdown List
         TabIndex        =   12
         Top             =   780
         Width           =   2295
      End
      Begin VB.ComboBox CBODirection 
         Height          =   315
         Left            =   1800
         Style           =   2  'Dropdown List
         TabIndex        =   11
         Top             =   420
         Width           =   2295
      End
      Begin ELFTxtBox.TxtBox1 TXTDays 
         Height          =   285
         Left            =   1800
         TabIndex        =   17
         Top             =   1680
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTHeightBarFrequency 
         Height          =   285
         Left            =   -71520
         TabIndex        =   21
         Top             =   1560
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTMinuteLine 
         Height          =   285
         Left            =   -71520
         TabIndex        =   22
         Top             =   1200
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTDayModulo 
         Height          =   285
         Left            =   1800
         TabIndex        =   51
         Top             =   2100
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTYStart 
         Height          =   285
         Left            =   -73560
         TabIndex        =   55
         Top             =   2460
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTYEnd 
         Height          =   285
         Left            =   -73560
         TabIndex        =   59
         Top             =   2880
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTUnitHeight 
         Height          =   285
         Left            =   -73080
         TabIndex        =   64
         Top             =   4680
         Width           =   735
         _ExtentX        =   1296
         _ExtentY        =   503
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
         Text            =   ""
         NavigationMode  =   0
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Report Type"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   16
         Left            =   -74760
         TabIndex        =   68
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Unit Height"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   15
         Left            =   -74160
         TabIndex        =   65
         Top             =   4680
         Width           =   975
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Y End"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   14
         Left            =   -74400
         TabIndex        =   60
         Top             =   2880
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Y Start"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   13
         Left            =   -74520
         TabIndex        =   56
         Top             =   2460
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Day Modulo"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   12
         Left            =   480
         TabIndex        =   52
         Top             =   2100
         Width           =   1215
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Y Group"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   11
         Left            =   -74760
         TabIndex        =   46
         Top             =   420
         Width           =   1095
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Finish Hour"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   4
         Left            =   600
         TabIndex        =   28
         Top             =   2880
         Width           =   1095
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Start Hour"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   3
         Left            =   720
         TabIndex        =   27
         Top             =   2520
         Width           =   975
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Height Bar Frequency(minutes)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   8
         Left            =   -74400
         TabIndex        =   24
         Top             =   1560
         Width           =   2775
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Minute Per Line"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   9
         Left            =   -73200
         TabIndex        =   23
         Top             =   1200
         Width           =   1575
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Graph Type"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   5
         Left            =   -74640
         TabIndex        =   20
         Top             =   780
         Width           =   1095
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Days"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   7
         Left            =   1200
         TabIndex        =   18
         Top             =   1680
         Width           =   495
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Z Group"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   6
         Left            =   840
         TabIndex        =   16
         Top             =   1140
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Y Group"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   600
         TabIndex        =   15
         Top             =   780
         Width           =   1095
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Direction"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   720
         TabIndex        =   14
         Top             =   420
         Width           =   975
      End
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   195
      Left            =   9240
      Max             =   23
      TabIndex        =   9
      Top             =   900
      Visible         =   0   'False
      Width           =   1455
   End
   Begin Threed.SSCommand CMDCreate 
      Height          =   375
      Left            =   0
      TabIndex        =   8
      Top             =   6540
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "<Create>"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin VB.ComboBox CBOreportname 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      ItemData        =   "FRMReportDesigner.frx":0054
      Left            =   3000
      List            =   "FRMReportDesigner.frx":0056
      TabIndex        =   4
      Text            =   "CBOreportname"
      ToolTipText     =   "Select report type to be printed."
      Top             =   0
      Width           =   6615
   End
   Begin VB.PictureBox Picture1 
      AutoRedraw      =   -1  'True
      BackColor       =   &H80000005&
      BeginProperty Font 
         Name            =   "Arial Narrow"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   5355
      Left            =   5520
      ScaleHeight     =   353
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   405
      TabIndex        =   3
      Top             =   1140
      Width           =   6135
   End
   Begin VB.CheckBox CHKBothGraphTypes 
      Caption         =   "Both Graph Types"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   9240
      TabIndex        =   0
      Top             =   420
      Width           =   1935
   End
   Begin ELFDateControl.DateControl TXTCallDate 
      Height          =   615
      Left            =   1320
      TabIndex        =   1
      Top             =   360
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin Threed.SSCommand CMDPreview 
      Height          =   375
      Left            =   1440
      TabIndex        =   2
      Top             =   6540
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Preview"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   10560
      TabIndex        =   5
      Top             =   6540
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDPrint 
      Height          =   375
      Left            =   5520
      TabIndex        =   6
      Top             =   6540
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "&Print"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Report Name"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   10
      Left            =   1560
      TabIndex        =   37
      Top             =   0
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Call Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   660
      Width           =   1095
   End
End
Attribute VB_Name = "FRMReportDesigner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Designer Object
''
''

Private vIsLoaded As Boolean
Private vPragmaticChange As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub DisableAll()
'    LBLReportComments.Caption = ""
End Sub

''
Private Sub DrawGraph(pTarget As Object)
    Dim StartHour As Long
    Dim FinishHour As Long
    Dim ByColourGraph As Boolean
    Dim StartY As Long
    
    Static CallDate As Date
    Static Zgroup As String
    Static YContext As String
    Static Direction As String
    Static Days As Long
    Static DayModuloStore As Long
    
    Call HeightBarFrequency(Val(TXTHeightBarFrequency.Text))
    If (CallDate <> CDate(TXTCallDate.Text) Or Zgroup <> CBOZGroup.Text Or _
      YContext <> CBOYContext.List(CBOYContext.ListIndex) Or _
      Direction <> CBODirection.Text Or Days <> Val(TXTDays.Text) Or DayModuloStore <> Val(TXTDayModulo.Text)) Then
        CallDate = CDate(TXTCallDate.Text)
        Zgroup = CBOZGroup.Text
        YContext = CBOYContext.List(CBOYContext.ListIndex)
        Direction = CBODirection.Text
        Days = Val(TXTDays.Text)
        DayModuloStore = Val(TXTDayModulo.Text)
        Call SetScale(Val(TXTDays.Text))
        Call DayModulo(Val(TXTDayModulo.Text))
        Call UsageReportBuildAllData(TXTCallDate.Text, CBOZGroup.Text, CBOYContext.List(CBOYContext.ListIndex), CBODirection.Text)
        TXTYStart.Text = GetYStart()
        TXTYEnd.Text = GetYEnd()
        vPragmaticChange = True
        Call GetContextLST(LSTYGroup)
        vPragmaticChange = False
    End If
    Call YStart(Val(TXTYStart.Text))
    Call YEnd(Val(TXTYEnd.Text))
    
    Call UnitHeight(Val(TXTUnitHeight.Text))
    StartHour = Val(Left$(CBOStartHour.Text, 2))
    FinishHour = Val(Left$(CBOFinishHour.Text, 2))
    If (pTarget.hDC = Printer.hDC) Then
        pTarget.Orientation = vbPRORLandscape
        pTarget.ScaleMode = vbMillimeters
        pTarget.ScaleHeight = Picture1.ScaleHeight ' / 10
        pTarget.ScaleWidth = Picture1.ScaleWidth
    Else
        Call pTarget.Cls
    End If
    Picture1.ScaleMode = vbPixels
    If (CBOGraphType.Text = "Bar") Then
        ByColourGraph = False
    Else
        ByColourGraph = True
    End If
    StartY = 1
    If (CBOReportType.ListIndex = 0) Then
        Call ShowUsageReport(pTarget, StartHour * 60, FinishHour, Val(TXTDays.Text) * 24, StartY, ByColourGraph, CBOZGroup.Text, CBOGraphType.Text, Val(TXTMinuteLine.Text))
    Else
        Call ShowReport(Picture1, StartHour * 60, FinishHour, Val(TXTDays.Text) * 24, StartY)
    End If
    
    If (pTarget.hDC = Printer.hDC) Then
        Call pTarget.EndDoc
    Else
    End If
End Sub

Private Sub UpdateValue(pReportID As Long, pName As String, pValue As String)
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM ReportDetails WHERE ReportID=" & pReportID & " AND Name=" & Chr$(34) & pName & Chr$(34), dbOpenDynaset)) Then
        If (rstemp.EOF = False) Then
            Call rstemp.Edit
        Else
            Call rstemp.AddNew
        End If
        rstemp!Name = pName
        rstemp!Value = pValue
        Call rstemp.Update
    End If
End Sub

''
Private Sub CreateValue(prstemp As Recordset, pReportID As Long, pName As String, pValue As String)
    Call prstemp.AddNew
    prstemp!ReportID = pReportID
    prstemp!Name = pName
    prstemp!Value = pValue
    Call prstemp.Update
End Sub

''
Private Sub UpdateScrollBar()
    Dim StartHour As Long
    Dim FinishHour As Long
    Dim dx As Long
    If (CBOStartHour.Text <> "" And CBOFinishHour.Text <> "") Then
        StartHour = Left$(CBOStartHour.Text, 2)
        FinishHour = Left$(CBOFinishHour.Text, 2)
        dx = (FinishHour - StartHour)
        HScroll1.Max = dx
    End If
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

Private Sub CBODirection_Click()
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

''
Private Sub CBOFinishHour_Click()
    Call UpdateScrollBar
    TXTMinuteLine.Text = (Val(CBOFinishHour.Text) - Val(CBOStartHour.Text)) * 60
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CBOGraphType_Click()
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

''
Private Sub CBOreportname_Click()
    Dim rstemp As Recordset
    ' Hide all options here
'    Call DisableAll
    ' Load report details here
    If (OpenRecordset(rstemp, "SELECT * FROM reportDetails WHERE ReportID=" & CBOreportname.ItemData(CBOreportname.ListIndex), dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            CMDCreate.Caption = "Update"
            Do While (rstemp.EOF = False)
                Select Case rstemp!Name
                    Case "Direction"
                        Call SetByItemCBO(CBODirection, rstemp!Value)
                    Case "YContext"
                        Call SetByItemCBO(CBOYContext, rstemp!Value)
                    Case "GraphType"
                        Call SetByItemCBO(CBOGraphType, rstemp!Value)
                    Case "ZGroup"
                        Call SetByItemCBO(CBOZGroup, rstemp!Value)
                    Case "StartHour"
                        Call SetByItemCBO(CBOStartHour, rstemp!Value)
                    Case "FinishHour"
                        Call SetByItemCBO(CBOFinishHour, rstemp!Value)
                    Case "BothGraphTypes"
                        CHKBothGraphTypes.Value = rstemp!Value
                    Case "Totals"
                        CHKTotals.Value = rstemp!Value
                    Case "Week"
                        CHKWeek.Value = rstemp!Value
                        
                    Case Else
                End Select
                Call rstemp.MoveNext
            Loop
        End If
    End If
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
        Case 1
        Case 2
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
End Sub

Private Sub CBOReportType_Click()
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CBOStartHour_Click()
    Call UpdateScrollBar
    TXTMinuteLine.Text = (Val(CBOFinishHour.Text) - Val(CBOStartHour.Text)) * 60
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub



Private Sub CBOYContext_Click()
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub


Private Sub CBOZGroup_Click()
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKNoColour_Click()
    If (CHKNoColour.Value = vbChecked) Then
        Call NoColour(True)
    Else
        Call NoColour(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKSeperateGroups_Click()
    If (CHKSeperateGroups.Value = vbChecked) Then
        Call SeperateGroups(True)
    Else
        Call SeperateGroups(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShortDate_Click()
    If (CHKShortDate.Value = vbChecked) Then
        Call ShortDate(True)
    Else
        Call ShortDate(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowAvailible_Click()
    If (CHKShowAvailible.Value = vbChecked) Then
        Call ShowAvailible(True)
    Else
        Call ShowAvailible(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowDateInHeadings_Click()
    If (CHKShowDateInHeadings.Value = vbChecked) Then
        Call ShowDateInHeadings(True)
    Else
        Call ShowDateInHeadings(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowDateInLineName_Click()
    If (CHKShowDateInLineName.Value = vbChecked) Then
        Call ShowDateInLineName(True)
        CHKShowDayInLineName.Enabled = False
        CHKShowDayInLineName.Value = vbUnchecked
    Else
        Call ShowDateInLineName(False)
        CHKShowDayInLineName.Enabled = True
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowDayInLineName_Click()
    If (CHKShowDayInLineName.Value = vbChecked) Then
        Call ShowDayInLineName(True)
        CHKShortDate.Enabled = True
        CHKShortDate.Value = vbUnchecked
    Else
        Call ShowDayInLineName(False)
        CHKShortDate.Enabled = False
        CHKShortDate.Value = vbUnchecked
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowHeadingsOncePerGroup_Click()
    If (CHKShowHeadingsOncePerGroup.Value = vbChecked) Then
        Call ShowHeadingsOncePerGroup(True)
    Else
        Call ShowHeadingsOncePerGroup(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowHeightBars_Click()
    If (CHKShowHeightBars.Value = vbChecked) Then
        Call ShowHeightBars(True)
    Else
        Call ShowHeightBars(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowHours_Click()
    If (CHKShowHours.Value = vbChecked) Then
        Call ShowHours(True)
    Else
        Call ShowHours(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKShowYScale_Click()
    If (CHKShowYScale.Value = vbChecked) Then
        Call ShowYScale(True)
    Else
        Call ShowYScale(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKTotals_Click()
    If (CHKTotals.Value = vbChecked) Then
        Call TextTotals(True)
    Else
        Call TextTotals(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CHKUseYStartEnd_Click()
    If (CHKUseYStartEnd.Value = vbChecked) Then
        Call UseYStartEnd(True)
    Else
        Call UseYStartEnd(False)
    End If
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CMDCreate_Click()
    Dim ReportID As Long
    Dim rstemp As Recordset
    If (CMDCreate.Caption = "Create") Then
        ' Create
        If (OpenRecordset(rstemp, "SELECT * FROM Reports", dbOpenDynaset)) Then
            Call rstemp.AddNew
            ReportID = rstemp!Uid
            rstemp!Name = CBOreportname.Text
            Call rstemp.Update
            If (OpenRecordset(rstemp, "SELECT * FROM ReportDetails WHERE ReportID=" & ReportID, dbOpenDynaset)) Then
                Call CreateValue(rstemp, ReportID, "Direction", CBODirection.Text)
                Call CreateValue(rstemp, ReportID, "YContext", CBOYContext.Text)
                Call CreateValue(rstemp, ReportID, "GraphType", CBOGraphType.Text)
                Call CreateValue(rstemp, ReportID, "ZGroup", CBOZGroup.Text)
                Call CreateValue(rstemp, ReportID, "StartHour", CBOStartHour.Text)
                Call CreateValue(rstemp, ReportID, "FinishHour", CBOFinishHour.Text)
                Call CreateValue(rstemp, ReportID, "BothGraphTypes", CHKBothGraphTypes.Value)
                Call CreateValue(rstemp, ReportID, "Totals", CHKTotals.Value)
                Call CreateValue(rstemp, ReportID, "Week", CHKWeek.Value)
            End If
        End If
    Else
        ' update
        If (OpenRecordset(rstemp, "SELECT * FROM Reports WHERE UID=" & CBOreportname.ItemData(CBOreportname.ListIndex), dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                Call rstemp.Edit
                rstemp!Name = CBOreportname.Text
                ReportID = rstemp!Uid
                Call rstemp.Update
                Call UpdateValue(ReportID, "Direction", CBODirection.Text)
                Call UpdateValue(ReportID, "YContext", CBOYContext.Text)
                Call UpdateValue(ReportID, "GraphType", CBOGraphType.Text)
                Call UpdateValue(ReportID, "ZGroup", CBOZGroup.Text)
                Call UpdateValue(ReportID, "StartHour", CBOStartHour.Text)
                Call UpdateValue(ReportID, "FinishHour", CBOFinishHour.Text)
                Call UpdateValue(ReportID, "BothGraphTypes", CHKBothGraphTypes.Value)
                Call UpdateValue(ReportID, "Totals", CHKTotals.Value)
                Call UpdateValue(ReportID, "Week", CHKWeek.Value)
            End If
        End If
    End If
End Sub

Private Sub CMDDayModuloLeft_Click()
    If (Val(TXTDayModulo.Text) > 1) Then
        TXTDayModulo.Text = Val(TXTDayModulo.Text) - 1
        If (CHKAutoPreview.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub CMDDayModuloRight_Click()
    TXTDayModulo.Text = Val(TXTDayModulo.Text) + 1
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CMDDaysLeft_Click()
    If (Val(TXTDays.Text) > 1) Then
        TXTDays.Text = Val(TXTDays.Text) - 1
        If (CHKAutoPreview.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub CMDDaysRight_Click()
    TXTDays.Text = Val(TXTDays.Text) + 1
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub


Private Sub CMDHeightBarFrequencyLeft_Click()
    If (Val(TXTHeightBarFrequency.Text) >= 120) Then
        TXTHeightBarFrequency.Text = Val(TXTHeightBarFrequency.Text) - 60
        If (CHKAutoPreview.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub CMDHeightBarFrequencyRight_Click()
    TXTHeightBarFrequency.Text = Val(TXTHeightBarFrequency.Text) + 60
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CMDMinutePerLineLeft_Click()
    If (Val(TXTMinuteLine.Text) >= 120) Then
        TXTMinuteLine.Text = Val(TXTMinuteLine.Text) - 60
        If (CHKAutoPreview.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub CMDMinutePerLineRight_Click()
    TXTMinuteLine.Text = Val(TXTMinuteLine.Text) + 60
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

''
Private Sub CMDPrint_Click()
    Call DrawGraph(Printer)
'    Dim Startdate As String
'    Dim EndDate As String
'    Dim s As String
'    Dim StartY As Long
'    Dim Days As Long
'
'    Screen.MousePointer = vbHourglass
'
'    Dim StartHour As Long
'    Dim FinishHour As Long
'    Dim ByColourGraph As Boolean
'    StartHour = Val(Left$(CBOStartHour.Text, 2))
'    FinishHour = Val(Left$(CBOFinishHour.Text, 2))
'    Printer.Orientation = vbPRORLandscape
''    Call Picture1.Cls
'    Printer.ScaleMode = vbMillimeters
'    Printer.ScaleHeight = Picture1(0).Height / 10
'    Printer.ScaleWidth = Picture1(0).Width
'    If (CBOGraphType.Text = "Bar") Then
'        ByColourGraph = False
'    Else
'        ByColourGraph = True'
'    End If
'    If (CHKWeek.Value = vbChecked) Then
'        Days = 7
'    Else
'        Days = 1
'    End If
'    If (CHKBothGraphTypes.Value = vbChecked) Then
'        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, StartY, True, CBOZGroup.Text, CBOYContext.List(CBOYContext.ListIndex), CBOGraphType.Text, CBODirection.Text, Days)
'        StartY = StartY + 5
'        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, StartY, False, CBOZGroup.Text, CBOYContext.List(CBOYContext.ListIndex), CBOGraphType.Text, CBODirection.Text, Days)
'    Else
'        Call UsageReport(Printer, TXTCallDate.Text, StartHour, FinishHour, 1, ByColourGraph, CBOZGroup.Text, CBOYContext.List(CBOYContext.ListIndex), CBOGraphType.Text, CBODirection.Text, Days)
'    End If
'    If (CHKTotals.Value = vbChecked) Then
'        Call UsageReportTotals(Printer, TXTCallDate.Text, StartHour, FinishHour, StartY, ByColourGraph, CBOZGroup.Text, CBOYContext.List(CBOYContext.ListIndex), CBOGraphType.Text, CBODirection.Text)
'    End If
'    Call Printer.EndDoc''

'    Screen.MousePointer = vbDefault
End Sub

Private Sub CMDUnitHeightLeft_Click()
    If (Val(TXTUnitHeight.Text) > 1) Then
        TXTUnitHeight.Text = Val(TXTUnitHeight.Text) - 1
        If (CHKAutoPreview.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub CMDUnitHeightRight_Click()
    TXTUnitHeight.Text = Val(TXTUnitHeight.Text) + 1
    If (CHKAutoPreview.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CMDYEndRight_Click()
    TXTYEnd.Text = Val(TXTYEnd.Text) + 1
    If (CHKAutoPreview.Value = vbChecked And CHKUseYStartEnd.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub CMDYStartLeft_Click()
    If (Val(TXTYStart.Text) > 0) Then
        TXTYStart.Text = Val(TXTYStart.Text) - 1
        If (CHKAutoPreview.Value = vbChecked And CHKUseYStartEnd.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

''
Private Sub Form_Load()
'    i = Document1.Container.
    
    Dim i As Long
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    CMDCreate.Caption = "Create"
    
    TXTCallDate.Text = Format(Now, "dd/mm/yyyy")

    Call CBODirection.AddItem("ALL")
    Call CBODirection.AddItem("Incoming")
    Call CBODirection.AddItem("Outgoing")
    CBODirection.ListIndex = 0
    
    Call CBOReportType.AddItem("Graph")
    Call CBOReportType.AddItem("Text")
    CBOReportType.ListIndex = 0
    
    Call CBOYContext.AddItem("Line")
'    CBOYContext.ItemData(CBOYContext.ListCount - 1) = "Line"
    Call CBOYContext.AddItem("Extension")
    Call CBOYContext.AddItem("Groups")
'    CBOYContext.ItemData(CBOYContext.ListCount - 1) = "Extension"
    CBOYContext.ListIndex = GetSetting(cRegistoryName, "Misc", Me.Name & ".YGroup", 0)
    
    Call CBOStartHour.AddItem("00:00")
    Call CBOStartHour.AddItem("01:00")
    Call CBOStartHour.AddItem("02:00")
    Call CBOStartHour.AddItem("03:00")
    Call CBOStartHour.AddItem("04:00")
    Call CBOStartHour.AddItem("05:00")
    Call CBOStartHour.AddItem("06:00")
    Call CBOStartHour.AddItem("07:00")
    Call CBOStartHour.AddItem("08:00")
    Call CBOStartHour.AddItem("09:00")
    Call CBOStartHour.AddItem("10:00")
    Call CBOStartHour.AddItem("11:00")
    Call CBOStartHour.AddItem("12:00")
    Call CBOStartHour.AddItem("13:00")
    Call CBOStartHour.AddItem("14:00")
    Call CBOStartHour.AddItem("15:00")
    Call CBOStartHour.AddItem("16:00")
    Call CBOStartHour.AddItem("17:00")
    Call CBOStartHour.AddItem("18:00")
    Call CBOStartHour.AddItem("19:00")
    Call CBOStartHour.AddItem("20:00")
    Call CBOStartHour.AddItem("21:00")
    Call CBOStartHour.AddItem("22:00")
    Call CBOStartHour.AddItem("23:00")
    
    CBOStartHour.ListIndex = GetSetting(cRegistoryName, "Misc", Me.Name & ".StartTime", 0)
    
    Call CopyCBOCBO(CBOStartHour, CBOFinishHour)
    CBOFinishHour.ListIndex = GetSetting(cRegistoryName, "Misc", Me.Name & ".FinishTime", 23)
'    CBOFinishHour.ListIndex = 23

    Call CBOGraphType.AddItem("Colour")
    Call CBOGraphType.AddItem("Bar")
    CBOGraphType.ListIndex = GetSetting(cRegistoryName, "Misc", Me.Name & ".GraphType", 0)

    Call CBOZGroup.AddItem("Direction")
    Call CBOZGroup.AddItem("Usage")
    CBOZGroup.ListIndex = GetSetting(cRegistoryName, "Misc", Me.Name & ".ZGroup", 0)
    
    CBOreportname.Clear
    CBOreportname.Text = ""
    If (OpenRecordset(rstemp, "SELECT * FROM Reports", dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
            Call CBOreportname.AddItem(rstemp!Name)
            CBOreportname.ItemData(CBOreportname.ListCount - 1) = rstemp!Uid
            Call rstemp.MoveNext
        Loop
    End If
    CHKBothGraphTypes.Value = GetSetting(cRegistoryName, "Misc", Me.Name & ".BothGraphTypes", 0)
    CHKTotals.Value = vbUnchecked 'GetSetting(cRegistoryName, "Misc", Me.Name & ".Totals", 0)
    CHKWeek.Value = GetSetting(cRegistoryName, "Misc", Me.Name & ".Week", 0)
    Call ShowHeightBars(True)
    CHKShowHeightBars.Value = vbChecked
    CHKShowHours.Value = vbChecked
    Call ShowHours(True)
    Call HeightBarFrequency(60)
    TXTHeightBarFrequency.Text = "60"
    TXTDays.Text = "1"
    TXTMinuteLine.Text = 60 * 24
    Call SeperateGroups(True)
    CHKSeperateGroups.Value = vbChecked
    Call ShowHeadingsOncePerGroup(False)
    CHKShowHeadingsOncePerGroup.Value = vbUnchecked
    CHKShowDateInLineName.Value = vbUnchecked
    Call ShowDateInLineName(False)
    CHKShowDayInLineName.Value = vbUnchecked
    SSTab1.Tab = 0
    Call DayModulo(1)
    TXTDayModulo.Text = "1"
    TXTUnitHeight.Text = "10"
End Sub

Private Sub Form_Resize()
    If (Me.WindowState <> 1) Then
        CMDExit.Top = Me.ScaleHeight - (CMDExit.Height + 45)
        CMDPreview.Top = Me.ScaleHeight - CMDPreview.Height - 45
        CMDPrint.Top = Me.ScaleHeight - CMDPrint.Height - 45
        CMDCreate.Top = Me.ScaleHeight - CMDCreate.Height - 45
        
        If (Me.ScaleHeight - (CMDExit.Height + 45 + 45 + Picture1.Top) > 0) Then
            Picture1.Height = Me.ScaleHeight - (CMDExit.Height + 45 + 45 + Picture1.Top)
        End If
        If (Me.ScaleWidth - (Picture1.Left + 45) > 0) Then
            Picture1.Width = Me.ScaleWidth - (Picture1.Left + 45)
        End If
        If (Me.ScaleWidth - (HScroll1.Left + 45) > 0) Then
            HScroll1.Width = Me.ScaleWidth - (HScroll1.Left + 45)
        End If
        
        CMDExit.Left = Me.ScaleWidth - CMDExit.Width - 45
        
        CHKAutoPreview.Top = Me.ScaleHeight - (6960 - 6600)
    End If
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
    
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".StartTime", CBOStartHour.ListIndex)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".FinishTime", CBOFinishHour.ListIndex)
    
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".GraphType", CBOGraphType.ListIndex)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".ZGroup", CBOZGroup.ListIndex)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".YGroup", CBOYContext.ListIndex)
    
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".BothGraphTypes", CHKBothGraphTypes.Value)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".Totals", CHKTotals.Value)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".Week", CHKWeek.Value)
    
End Sub


''
Private Sub CMDPreview_Click()
    Call DrawGraph(Picture1)
End Sub


Private Sub LSTYGroup_Click()
    If (vPragmaticChange = False) Then
        If (LSTYGroup.ListIndex >= 0) Then
            If (LSTYGroup.Selected(LSTYGroup.ListIndex)) Then
                Call ChangeContextSelection(LSTYGroup.ListIndex, True)
            Else
                Call ChangeContextSelection(LSTYGroup.ListIndex, False)
            End If
            If (CHKAutoPreview.Value = vbChecked) Then
                Call CMDPreview_Click
            End If
        End If
    End If
End Sub

Private Sub Picture1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim StartHour As Long
    Dim FinishHour As Long
    Dim dx As Long
    StartHour = Left$(CBOStartHour.Text, 2)
    FinishHour = Left$(CBOFinishHour.Text, 2)
    dx = (FinishHour - StartHour) / 2
    If (dx = 0) Then
'        CBOStartHour.ListIndex = CBOStartHour.ListIndex + 1
        If (Button = 1) Then
'            CBOStartHour.ListIndex = CBOStartHour.ListIndex + dx / 2
'            CBOFinishHour.ListIndex = CBOFinishHour.ListIndex - dx / 2
        Else
            CBOStartHour.ListIndex = CBOStartHour.ListIndex - 1
            CBOFinishHour.ListIndex = CBOFinishHour.ListIndex + 1
        End If
    Else
        If (Button = 1) Then
            CBOStartHour.ListIndex = CBOStartHour.ListIndex + dx / 2
            CBOFinishHour.ListIndex = CBOFinishHour.ListIndex - dx / 2
        Else
            If (CBOStartHour.ListIndex - dx / 2 < 0) Then
                CBOStartHour.ListIndex = 0
            Else
                CBOStartHour.ListIndex = CBOStartHour.ListIndex - dx / 2
            End If
            If (CBOFinishHour.ListIndex + dx / 2 > 23) Then
                CBOFinishHour.ListIndex = 23
            Else
                CBOFinishHour.ListIndex = CBOFinishHour.ListIndex + dx / 2
            End If
        End If
    End If
    Call CMDPreview_Click
End Sub

Private Sub TXTDayModulo_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTDays_Change()
'    If (Val(TXTDays.Text) > 1) Then
'        CBOFinishHour.Enabled = False
'        CBOFinishHour.BackColor = &H8000000F
'    Else
        CBOFinishHour.Enabled = True
        CBOFinishHour.BackColor = &H80000005
'    End If
End Sub

Private Sub TXTDays_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTHeightBarFrequency_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTMinuteLine_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTUnitHeight_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTYEnd_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13 And CHKUseYStartEnd.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTYEndLeft_Click()
    If (Val(TXTYEnd.Text) > 1) Then
        TXTYEnd.Text = Val(TXTYEnd.Text) - 1
        If (CHKAutoPreview.Value = vbChecked And CHKUseYStartEnd.Value = vbChecked) Then
            Call CMDPreview_Click
        End If
    End If
End Sub

Private Sub TXTYStart_KeyPress(KeyAscii As Integer)
    If (CHKAutoPreview.Value = vbChecked And KeyAscii = 13 And CHKUseYStartEnd.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub

Private Sub TXTYStartRight_Click()
    TXTYStart.Text = Val(TXTYStart.Text) + 1
    If (CHKAutoPreview.Value = vbChecked And CHKUseYStartEnd.Value = vbChecked) Then
        Call CMDPreview_Click
    End If
End Sub
