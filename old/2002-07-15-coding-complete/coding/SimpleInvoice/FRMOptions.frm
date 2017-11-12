VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form FRMOptions 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Options"
   ClientHeight    =   7185
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10005
   ControlBox      =   0   'False
   HelpContextID   =   1
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7185
   ScaleWidth      =   10005
   Begin TabDlg.SSTab TABOptions 
      Height          =   4875
      Left            =   0
      TabIndex        =   6
      Top             =   840
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   8599
      _Version        =   393216
      Tabs            =   2
      TabsPerRow      =   2
      TabHeight       =   520
      TabCaption(0)   =   "Company Details"
      TabPicture(0)   =   "FRMOptions.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "LBLZ1(5)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "LBLZ1(3)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "LBLZ1(1)"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "LBLZ1(2)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "LBLZ1(13)"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "LBLZ1(12)"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "LBLZ1(10)"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "LBLZ1(0)"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).Control(8)=   "LBLZ1(4)"
      Tab(0).Control(8).Enabled=   0   'False
      Tab(0).Control(9)=   "LBLZ1(16)"
      Tab(0).Control(9).Enabled=   0   'False
      Tab(0).Control(10)=   "TXTNextStatement"
      Tab(0).Control(10).Enabled=   0   'False
      Tab(0).Control(11)=   "TXTFirstStatement"
      Tab(0).Control(11).Enabled=   0   'False
      Tab(0).Control(12)=   "TXTNextEstimateNumber"
      Tab(0).Control(12).Enabled=   0   'False
      Tab(0).Control(13)=   "TXTDefaultVATPercent"
      Tab(0).Control(13).Enabled=   0   'False
      Tab(0).Control(14)=   "TXTDefaultDuePeriod"
      Tab(0).Control(14).Enabled=   0   'False
      Tab(0).Control(15)=   "TXTDefaultHandlingCharge"
      Tab(0).Control(15).Enabled=   0   'False
      Tab(0).Control(16)=   "TXTVATNumber"
      Tab(0).Control(16).Enabled=   0   'False
      Tab(0).Control(17)=   "TXTCountry"
      Tab(0).Control(17).Enabled=   0   'False
      Tab(0).Control(18)=   "TXTPostcode"
      Tab(0).Control(18).Enabled=   0   'False
      Tab(0).Control(19)=   "TXTStreet2"
      Tab(0).Control(19).Enabled=   0   'False
      Tab(0).Control(20)=   "TXTCounty"
      Tab(0).Control(20).Enabled=   0   'False
      Tab(0).Control(21)=   "TXTTown"
      Tab(0).Control(21).Enabled=   0   'False
      Tab(0).Control(22)=   "TXTStreet1"
      Tab(0).Control(22).Enabled=   0   'False
      Tab(0).Control(23)=   "TXTName"
      Tab(0).Control(23).Enabled=   0   'False
      Tab(0).Control(24)=   "CHKUseProductDatabase"
      Tab(0).Control(24).Enabled=   0   'False
      Tab(0).Control(25)=   "FRAVATMethod"
      Tab(0).Control(25).Enabled=   0   'False
      Tab(0).Control(26)=   "FRMWorkstationSettings"
      Tab(0).Control(26).Enabled=   0   'False
      Tab(0).ControlCount=   27
      TabCaption(1)   =   "Invoice Layout"
      TabPicture(1)   =   "FRMOptions.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "FRAInvoiceExtraFields"
      Tab(1).Control(1)=   "CHKPrint2Copies"
      Tab(1).Control(2)=   "TXTInvoiceComments"
      Tab(1).Control(3)=   "TXTEstimateComments"
      Tab(1).Control(4)=   "LBLZ1(6)"
      Tab(1).Control(5)=   "LBLZ1(15)"
      Tab(1).ControlCount=   6
      Begin VB.Frame FRAInvoiceExtraFields 
         Caption         =   "Invoice Extra Fields"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1335
         Left            =   -74880
         TabIndex        =   43
         Top             =   3420
         Width           =   5175
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldA 
            Height          =   285
            Index           =   0
            Left            =   120
            TabIndex        =   44
            Top             =   240
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldB 
            Height          =   285
            Index           =   0
            Left            =   2640
            TabIndex        =   45
            Top             =   240
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldA 
            Height          =   285
            Index           =   1
            Left            =   120
            TabIndex        =   46
            Top             =   600
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldA 
            Height          =   285
            Index           =   2
            Left            =   120
            TabIndex        =   47
            Top             =   960
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldB 
            Height          =   285
            Index           =   1
            Left            =   2640
            TabIndex        =   48
            Top             =   600
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTExtraFieldB 
            Height          =   285
            Index           =   2
            Left            =   2640
            TabIndex        =   49
            Top             =   960
            Width           =   2415
            _ExtentX        =   4260
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoCase        =   -1  'True
            AutoSelect      =   -1  'True
         End
      End
      Begin VB.Frame FRMWorkstationSettings 
         Caption         =   "Workstation Settings"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1335
         Left            =   120
         TabIndex        =   36
         Top             =   3420
         Width           =   2895
         Begin ELFTxtBox.TxtBox1 TXTInvoiceNumberPreFix 
            Height          =   285
            Left            =   2160
            TabIndex        =   37
            Top             =   240
            Width           =   615
            _ExtentX        =   1085
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTWorkstationIndex 
            Height          =   285
            Left            =   2160
            TabIndex        =   38
            Top             =   600
            Width           =   615
            _ExtentX        =   1085
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
            Text            =   ""
            Mask            =   "###"
            UpperCase       =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin ELFTxtBox.TxtBox1 TXTNextInvoiceNumber 
            Height          =   285
            Left            =   2160
            TabIndex        =   39
            Top             =   960
            Width           =   615
            _ExtentX        =   1085
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
            Text            =   ""
            UpperCase       =   -1  'True
            AutoSelect      =   -1  'True
         End
         Begin VB.Label LBLZ1 
            Alignment       =   1  'Right Justify
            BackStyle       =   0  'Transparent
            Caption         =   "Invoice Number Pre-fix"
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
            Left            =   -240
            TabIndex        =   42
            Top             =   270
            Width           =   2295
         End
         Begin VB.Label LBLZ1 
            Alignment       =   1  'Right Justify
            BackStyle       =   0  'Transparent
            Caption         =   "Workstation Index"
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
            Left            =   360
            TabIndex        =   41
            Top             =   630
            Width           =   1695
         End
         Begin VB.Label LBLZ1 
            Alignment       =   1  'Right Justify
            BackStyle       =   0  'Transparent
            Caption         =   "Next Invoice Number"
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
            Left            =   120
            TabIndex        =   40
            Top             =   990
            Width           =   1935
         End
      End
      Begin VB.Frame FRAVATMethod 
         Caption         =   "VAT Method"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1335
         Left            =   3120
         TabIndex        =   33
         Top             =   3420
         Width           =   1695
         Begin VB.OptionButton OPTVATMethod 
            Caption         =   "Payment Date"
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
            TabIndex        =   35
            Top             =   240
            Width           =   1525
         End
         Begin VB.OptionButton OPTVATMethod 
            Caption         =   "Invoice Date"
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
            Left            =   120
            TabIndex        =   34
            Top             =   540
            Width           =   1455
         End
      End
      Begin VB.CheckBox CHKUseProductDatabase 
         Caption         =   "Use Product Database"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   5280
         TabIndex        =   32
         Top             =   1860
         Width           =   2535
      End
      Begin VB.CheckBox CHKPrint2Copies 
         Caption         =   "Print 2 Copies"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   -69240
         TabIndex        =   31
         Top             =   420
         Width           =   1575
      End
      Begin VB.TextBox TXTInvoiceComments 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1455
         Left            =   -73800
         MultiLine       =   -1  'True
         ScrollBars      =   1  'Horizontal
         TabIndex        =   20
         ToolTipText     =   "NOTE: Enter must be pressed to move text onto next line on printout"
         Top             =   420
         Width           =   4455
      End
      Begin VB.TextBox TXTEstimateComments 
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1455
         Left            =   -73800
         MultiLine       =   -1  'True
         ScrollBars      =   1  'Horizontal
         TabIndex        =   19
         ToolTipText     =   "NOTE: Enter must be pressed to move text onto next line on printout"
         Top             =   1920
         Width           =   4455
      End
      Begin ELFTxtBox.TxtBox1 TXTName 
         Height          =   285
         Left            =   1200
         TabIndex        =   7
         Top             =   435
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTStreet1 
         Height          =   285
         Left            =   1200
         TabIndex        =   8
         Top             =   795
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTTown 
         Height          =   285
         Left            =   1200
         TabIndex        =   9
         Top             =   1515
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTCounty 
         Height          =   285
         Left            =   1200
         TabIndex        =   10
         Top             =   1875
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTStreet2 
         Height          =   285
         Left            =   1200
         TabIndex        =   11
         Top             =   1155
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTPostcode 
         Height          =   285
         Left            =   1200
         TabIndex        =   12
         Top             =   2595
         Width           =   975
         _ExtentX        =   1720
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTCountry 
         Height          =   285
         Left            =   1200
         TabIndex        =   13
         Top             =   2235
         Width           =   3375
         _ExtentX        =   5953
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoCase        =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTVATNumber 
         Height          =   285
         Left            =   3480
         TabIndex        =   14
         Top             =   2595
         Width           =   1095
         _ExtentX        =   1931
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTDefaultHandlingCharge 
         Height          =   285
         Left            =   7320
         TabIndex        =   23
         Top             =   780
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTDefaultDuePeriod 
         Height          =   285
         Left            =   7320
         TabIndex        =   24
         Top             =   420
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTDefaultVATPercent 
         Height          =   285
         Left            =   7320
         TabIndex        =   25
         Top             =   1140
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTNextEstimateNumber 
         Height          =   285
         Left            =   7320
         TabIndex        =   26
         Top             =   1500
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         Mask            =   "##########"
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTFirstStatement 
         Height          =   285
         Left            =   7320
         TabIndex        =   50
         Top             =   2280
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         Mask            =   "##########"
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTNextStatement 
         Height          =   285
         Left            =   7320
         TabIndex        =   52
         Top             =   2640
         Width           =   1215
         _ExtentX        =   2143
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
         Text            =   ""
         Mask            =   "##########"
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Days before next statement"
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
         Left            =   4800
         TabIndex        =   53
         Top             =   2670
         Width           =   2415
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Days before first statement"
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
         Left            =   4800
         TabIndex        =   51
         Top             =   2310
         Width           =   2415
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Default Handling Charge"
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
         Left            =   4920
         TabIndex        =   30
         Top             =   810
         Width           =   2295
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Default Due Period(Days)"
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
         Left            =   4920
         TabIndex        =   29
         Top             =   450
         Width           =   2295
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Default VAT Percent"
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
         Left            =   4920
         TabIndex        =   28
         Top             =   1170
         Width           =   2295
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Next Estimate Number"
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
         Left            =   4920
         TabIndex        =   27
         Top             =   1530
         Width           =   2295
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Invoice Comments"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Index           =   6
         Left            =   -74880
         TabIndex        =   22
         Top             =   480
         Width           =   975
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Estimate Comments"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Index           =   15
         Left            =   -74760
         TabIndex        =   21
         Top             =   1920
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Post Code"
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
         Left            =   120
         TabIndex        =   18
         Top             =   2625
         Width           =   975
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Address"
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
         Left            =   360
         TabIndex        =   17
         Top             =   825
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Name"
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
         Left            =   360
         TabIndex        =   16
         Top             =   465
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "VAT Number"
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
         Left            =   2040
         TabIndex        =   15
         Top             =   2625
         Width           =   1335
      End
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   6780
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   8880
      TabIndex        =   5
      Top             =   6780
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTProductKey 
      Height          =   285
      Left            =   7200
      TabIndex        =   1
      Top             =   60
      Width           =   2535
      _ExtentX        =   4471
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTSerialNumber 
      Height          =   315
      Left            =   7200
      TabIndex        =   3
      Top             =   420
      Width           =   2535
      _ExtentX        =   4471
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Serial Number"
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
      Left            =   5880
      TabIndex        =   4
      Top             =   450
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Product Key"
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
      Left            =   5880
      TabIndex        =   2
      Top             =   90
      Width           =   1215
   End
End
Attribute VB_Name = "FRMOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' System Details Object
''
'' Coded by Dale Pitman

Private vIsLoaded As Boolean

Private vCompanyName As String
Private vStreet1 As String
Private vStreet2 As String
Private vTown As String
Private vCounty As String
Private vCountry As String
Private vPostCode As String
Private vVATNumber As String
Private vInvoiceComments As String
Private vEstimateComments As String
Private vUseProductDatabase As Boolean
Private vInvoiceNumberPreFix As String
Private vDefaultDuePeriod As Long
Private vDefaultHandlingCharge As Currency
Private vWorkstationIndex As Long
Private vInvoiceCopies As Long
Private vUsePaymentDateForVAT As Boolean

Private vFirstStatement As Long
Private vNextStatement As Long


Private vInvoiceExtraFieldA(2) As String
Private vInvoiceExtraFieldB(2) As String

Private vDefaultVATPercent As Currency

Public Property Get CompanyName() As String
    CompanyName = vCompanyName
End Property

Public Property Get CompanyStreet1() As String
    CompanyStreet1 = vStreet1
End Property
Public Property Get CompanyStreet2() As String
    CompanyStreet2 = vStreet2
End Property
Public Property Get CompanyTown() As String
    CompanyTown = vTown
End Property
Public Property Get CompanyCounty() As String
    CompanyCounty = vCounty
End Property
Public Property Get CompanyCountry() As String
    CompanyCountry = vCountry
End Property
Public Property Get CompanyPostCode() As String
    CompanyPostCode = vPostCode
End Property

Public Property Get CompanyVATNumber() As String
    CompanyVATNumber = vVATNumber
End Property

Public Property Get InvoiceComments() As String
    InvoiceComments = vInvoiceComments
End Property

Public Property Get EstimateComments() As String
    EstimateComments = vEstimateComments
End Property

Public Property Get UseProductDatabase() As Boolean
    UseProductDatabase = vUseProductDatabase
End Property

Public Property Get InvoiceNumberPreFix() As String
    InvoiceNumberPreFix = vInvoiceNumberPreFix
End Property

Public Property Get DefaultDuePeriod() As Long
    DefaultDuePeriod = vDefaultDuePeriod
End Property

Public Property Get DefaultHandlingCharge() As Currency
    DefaultHandlingCharge = vDefaultHandlingCharge
End Property

Public Property Get WorkstationIndex() As Long
    WorkstationIndex = vWorkstationIndex
End Property

Public Property Get InvoiceExtraFieldA(index As Long) As String
    InvoiceExtraFieldA = vInvoiceExtraFieldA(index)
End Property

Public Property Get InvoiceExtraFieldB(index As Long) As String
    InvoiceExtraFieldB = vInvoiceExtraFieldB(index)
End Property

Public Property Get InvoiceCopies() As Long
    InvoiceCopies = vInvoiceCopies
End Property

Public Property Get DefaultVATPercent() As Currency
    DefaultVATPercent = vDefaultVATPercent
End Property

Public Property Get UsePaymentDateForVAT() As Boolean
    UsePaymentDateForVAT = vUsePaymentDateForVAT
End Property

Public Property Get FirstStatement() As Long
    FirstStatement = vFirstStatement
End Property
Public Property Get NextStatement() As Long
    NextStatement = vNextStatement
End Property


''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Private Sub CMDOK_Click()
    Dim rstemp As Recordset
    Dim i As Long
    If (Val(TXTWorkstationIndex.Text) = 1) Then
        Call Messagebox("WARNING: Workstation Index must not be 1", vbInformation)
    Else
        Call SetServerSetting("DEFAULTHANDLING", TXTDefaultHandlingCharge.Text)
    
        Call SetServerSetting("COMPANYNAME", TXTName.Text)
        Call SetServerSetting("COMPANYSTREET2", TXTStreet1.Text)
        Call SetServerSetting("COMPANYSTREET1", TXTStreet2.Text)
        Call SetServerSetting("COMPANYTOWN", TXTTown.Text)
        Call SetServerSetting("COMPANYCOUNTY", TXTCounty.Text)
        Call SetServerSetting("COMPANYCOUNTRY", TXTCountry.Text)
        Call SetServerSetting("COMPANYPOSTCODE", TXTPostcode.Text)
        Call SetServerSetting("COMPANYVATNUMBER", TXTVATNumber.Text)
    '    Call SetServerSetting("INVOICECOMMENTS", TXTInvoiceComments.Text)
        If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE message='" & TXTInvoiceComments.Text & "'", dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                
            Else
                Call rstemp.AddNew
            End If
            rstemp!Message = TXTInvoiceComments.Text
            Call SetServerSetting("DEFAULTDISCLAIMERID", rstemp!Uid)
            Call rstemp.Update
        End If
        
        If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE message='" & TXTEstimateComments.Text & "'", dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                
            Else
                Call rstemp.AddNew
            End If
            rstemp!Message = TXTEstimateComments.Text
            Call SetServerSetting("DEFAULTESTIMATEDISCLAIMERID", rstemp!Uid)
            Call rstemp.Update
        End If
        
        Call SetServerSetting("SERIALNUMBER", TXTSerialNumber.Text)
        Call SetWorkstationSetting("INVOICENUMBERPREFIX", TXTInvoiceNumberPreFix.Text)
        Call SetServerSetting("DEFAULTDUEPERIOD", TXTDefaultDuePeriod.Text)
        If (CHKUseProductDatabase.Value = vbChecked) Then
            Call SetServerSetting("USEPRODUCTDATABASE", True)
            vUseProductDatabase = True
        Else
            Call SetServerSetting("USEPRODUCTDATABASE", False)
            vUseProductDatabase = False
        End If
        
        If (CHKPrint2Copies.Value = vbChecked) Then
            Call SetServerSetting("INVOICECOPIES", True)
            vInvoiceCopies = 1
        Else
            Call SetServerSetting("INVOICECOPIES", False)
            vInvoiceCopies = 0
        End If
        Call SetWorkstationSetting("WORKSTATIONINDEX", TXTWorkstationIndex.Text)
        
        For i = 0 To 2
            Call SetServerSetting("INVOICEEXTRAFIELDA" & i, TXTExtraFieldA(i).Text)
            Call SetServerSetting("INVOICEEXTRAFIELDB" & i, TXTExtraFieldB(i).Text)
            vInvoiceExtraFieldA(i) = TXTExtraFieldA(i).Text
            vInvoiceExtraFieldB(i) = TXTExtraFieldB(i).Text
        Next
        Call SetServerSetting("DEFAULTVATPERCENT", TXTDefaultVATPercent.Text)
        Call SetServerSetting("NEXTESTIMATENUMBER", Val(TXTNextEstimateNumber.Text))
        
        Call SetServerSetting("NEXTINVOICENUMBER-" & TXTInvoiceNumberPreFix.Text, Val(TXTNextInvoiceNumber.Text))
        
        If (OPTVATMethod(0).Value = True) Then
            vUsePaymentDateForVAT = True
            Call SetServerSetting("USEPAYMENTDATEFORVAT", True)
        Else
            vUsePaymentDateForVAT = False
            Call SetServerSetting("USEPAYMENTDATEFORVAT", False)
        End If
    
        Call SetServerSetting("FIRSTSTATEMENT", Val(TXTFirstStatement.Text))
        Call SetServerSetting("NEXTSTATEMENT", Val(TXTNextStatement.Text))
        
        vCompanyName = TXTName.Text
        vStreet1 = TXTStreet1.Text
        vStreet2 = TXTStreet2.Text
        vTown = TXTTown.Text
        vCounty = TXTCounty.Text
        vCountry = TXTCountry.Text
        vPostCode = TXTPostcode.Text
        vVATNumber = TXTVATNumber.Text
        vInvoiceComments = TXTInvoiceComments.Text
        vEstimateComments = TXTEstimateComments.Text
        vDefaultHandlingCharge = Val(RemoveNonNumericCharacters(TXTDefaultHandlingCharge.Text))
        vDefaultVATPercent = Val(RemoveNonNumericCharacters(TXTDefaultVATPercent.Text))
        
        vFirstStatement = Val(TXTFirstStatement.Text)
        vNextStatement = Val(TXTNextStatement.Text)
        
        TXTProductKey.Text = GenerateProductKey
'        TXTSerialNumber.Text = GenerateSerialNumber(TXTProductKey.Text)
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    Dim DefaultDisclaimerID As Long
    Dim rstemp As Recordset
    Dim i As Long
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)

    TXTDefaultHandlingCharge.Text = GetServerSetting("DEFAULTHANDLING", False)
    TXTName.Text = GetServerSetting("COMPANYNAME", False)
    TXTStreet1.Text = GetServerSetting("COMPANYSTREET2", False)
    TXTStreet2.Text = GetServerSetting("COMPANYSTREET1", False)
    TXTTown.Text = GetServerSetting("COMPANYTOWN", False)
    TXTCounty.Text = GetServerSetting("COMPANYCOUNTY", False)
    TXTCountry.Text = GetServerSetting("COMPANYCOUNTRY", False)
    TXTPostcode.Text = GetServerSetting("COMPANYPOSTCODE", False)
    TXTVATNumber.Text = GetServerSetting("COMPANYVATNUMBER", False)
    
    
    DefaultDisclaimerID = Val(GetServerSetting("DEFAULTDISCLAIMERID", False))
    If (DefaultDisclaimerID = 0) Then
        DefaultDisclaimerID = 1
    End If
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE UID=" & DefaultDisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            TXTInvoiceComments.Text = rstemp!Message & ""
        End If
    End If
    
    DefaultDisclaimerID = Val(GetServerSetting("DEFAULTESTIMATEDISCLAIMERID", False))
    If (DefaultDisclaimerID = 0) Then
        DefaultDisclaimerID = -1
    End If
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE UID=" & DefaultDisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            TXTEstimateComments.Text = rstemp!Message & ""
        Else
            TXTEstimateComments.Text = ""
        End If
    End If
'    TXTInvoiceComments.Text = GetServerSetting("INVOICECOMMENTS")
    TXTSerialNumber.Text = GetServerSetting("SERIALNUMBER", False)
    TXTInvoiceNumberPreFix.Text = GetWorkstationSetting("INVOICENUMBERPREFIX")
    TXTDefaultDuePeriod.Text = GetServerSetting("DEFAULTDUEPERIOD", False)
    If (GetServerSetting("USEPRODUCTDATABASE", False) = "True") Then
        CHKUseProductDatabase.Value = vbChecked
    Else
        CHKUseProductDatabase.Value = vbUnchecked
    End If
    If (GetServerSetting("INVOICECOPIES", False) = "True") Then
        CHKPrint2Copies.Value = vbChecked
        vInvoiceCopies = 1
    Else
        CHKPrint2Copies.Value = vbUnchecked
        vInvoiceCopies = 0
    End If
    TXTWorkstationIndex.Text = GetWorkstationSetting("WORKSTATIONINDEX")
        
    For i = 0 To 2
        TXTExtraFieldA(i).Text = GetServerSetting("INVOICEEXTRAFIELDA" & i, False)
        TXTExtraFieldB(i).Text = GetServerSetting("INVOICEEXTRAFIELDB" & i, False)
    Next
    TXTDefaultVATPercent.Text = GetServerSetting("DEFAULTVATPERCENT", False)
    
    TXTNextEstimateNumber.Text = GetServerSetting("NEXTESTIMATENUMBER", False)
    
    TXTNextInvoiceNumber.Text = GetServerSetting("NEXTINVOICENUMBER-" & TXTInvoiceNumberPreFix.Text, False)

    If (GetServerSetting("USEPAYMENTDATEFORVAT", True) = "True") Then
        vUsePaymentDateForVAT = True
    Else
        vUsePaymentDateForVAT = False
    End If
    If (vUsePaymentDateForVAT = True) Then
        OPTVATMethod(0).Value = True
    Else
        OPTVATMethod(1).Value = True
    End If

    TXTFirstStatement.Text = GetServerSetting("FIRSTSTATEMENT", False)
    TXTNextStatement.Text = GetServerSetting("NEXTSTATEMENT", False)
End Sub

''
Public Sub LoadSettings()
    Dim DefaultDisclaimerID As Long
    Dim rstemp As Recordset
    Dim i As Long
    vDefaultHandlingCharge = Val(GetServerSetting("DEFAULTHANDLING", False))
    vCompanyName = GetServerSetting("COMPANYNAME", False)
    vStreet1 = GetServerSetting("COMPANYSTREET2", False)
    vStreet2 = GetServerSetting("COMPANYSTREET1", False)
    vTown = GetServerSetting("COMPANYTOWN", False)
    vCounty = GetServerSetting("COMPANYCOUNTY", False)
    vCountry = GetServerSetting("COMPANYCOUNTRY", False)
    vPostCode = GetServerSetting("COMPANYPOSTCODE", False)
    vVATNumber = GetServerSetting("COMPANYVATNUMBER", False)
'    vInvoiceComments = GetServerSetting("INVOICECOMMENTS")
    
    DefaultDisclaimerID = Val(GetServerSetting("DEFAULTDISCLAIMERID", False))
    If (DefaultDisclaimerID = 0) Then
        DefaultDisclaimerID = 1
    End If
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE UID=" & DefaultDisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            vInvoiceComments = rstemp!Message & ""
        End If
    End If
    
    DefaultDisclaimerID = Val(GetServerSetting("DEFAULTESTIMATEDISCLAIMERID", False))
    If (DefaultDisclaimerID = 0) Then
        DefaultDisclaimerID = -1
    End If
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE UID=" & DefaultDisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            vEstimateComments = rstemp!Message & ""
        End If
    End If
    
    vInvoiceNumberPreFix = GetWorkstationSetting("INVOICENUMBERPREFIX")
    vDefaultDuePeriod = Val(GetServerSetting("DEFAULTDUEPERIOD", False))
    If (GetServerSetting("USEPRODUCTDATABASE", False) = "True") Then
        vUseProductDatabase = True
    Else
        vUseProductDatabase = False
    End If
    If (GetServerSetting("INVOICECOPIES", False) = "True") Then
        vInvoiceCopies = 1
    Else
        vInvoiceCopies = 0
    End If
    vWorkstationIndex = Val(GetWorkstationSetting("WORKSTATIONINDEX"))
    For i = 0 To 2
        vInvoiceExtraFieldA(i) = GetServerSetting("INVOICEEXTRAFIELDA" & i, False)
        vInvoiceExtraFieldB(i) = GetServerSetting("INVOICEEXTRAFIELDB" & i, False)
    Next
    vDefaultVATPercent = Val(GetServerSetting("DEFAULTVATPERCENT", False))
    If (GetServerSetting("USEPAYMENTDATEFORVAT", True) = "True") Then
        vUsePaymentDateForVAT = True
    Else
        vUsePaymentDateForVAT = False
    End If
    
    vFirstStatement = Val(GetServerSetting("FIRSTSTATEMENT", False))
    vNextStatement = Val(GetServerSetting("NEXTSTATEMENT", False))
    
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

Private Sub TXTInvoiceComments_Validate(Cancel As Boolean)
    TXTInvoiceComments.Text = TXTInvoiceComments.Text
    'AutoCase(TXTInvoiceComments.Text, False)
End Sub

''
Private Sub TXTPostcode_LostFocus()
    Dim Tempstring As String
    Tempstring = ValidatePostcode(TXTPostcode.Text)
    If (Left$(Tempstring, 5) = "ERROR") Then
        Call Messagebox(Tempstring, vbInformation)
    Else
        TXTPostcode.Text = Tempstring
    End If
End Sub


''
Private Sub TXTSerialNumber_GotFocus()
    TXTProductKey.Text = GenerateProductKey
End Sub
''
Public Function GenerateProductKey() As String
    Dim key As Long
    Dim key2 As Long
    Dim key3 As Long
    key = SumString(TXTName.Text)
    key = key + SumString(TXTStreet1.Text)
    key = key + SumString(TXTStreet2.Text)
    key = key + SumString(TXTTown.Text)
    key = key + SumString(TXTCounty.Text)
    key = key + SumString(TXTCountry.Text)
    key = key + SumString(TXTPostcode.Text)
    key2 = SumString(TXTVATNumber.Text)
    key3 = SumString(TXTVATNumber.Text) + SumString(TXTPostcode.Text) + SumString(TXTName.Text)
    GenerateProductKey = key & "-" & key2 & "-" & key3 & "-" & Rotate(TXTVATNumber.Text)
End Function

''
Public Function GenerateProductKeyFromLocal() As String
    Dim key As Long
    Dim key2 As Long
    Dim key3 As Long
    key = SumString(vCompanyName)
    key = key + SumString(vStreet1)
    key = key + SumString(vStreet2)
    key = key + SumString(vTown)
    key = key + SumString(vCounty)
    key = key + SumString(vCountry)
    key = key + SumString(vPostCode)
    key2 = SumString(vVATNumber)
    key3 = SumString(vVATNumber) + SumString(vPostCode) + SumString(vCompanyName)
    GenerateProductKeyFromLocal = key & "-" & key2 & "-" & key3 & "-" & Rotate(vVATNumber)
End Function
