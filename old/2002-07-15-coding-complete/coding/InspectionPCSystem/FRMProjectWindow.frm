VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMProjectWindow 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   486
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   779
   Begin VB.CommandButton Command4 
      Caption         =   "import jobs"
      Height          =   375
      Left            =   3600
      TabIndex        =   137
      Top             =   6000
      Width           =   1455
   End
   Begin VB.CommandButton Command3 
      Caption         =   "import vehicle"
      Height          =   375
      Left            =   2040
      TabIndex        =   136
      Top             =   6060
      Width           =   1455
   End
   Begin VB.CommandButton Command2 
      Caption         =   "import customer"
      Height          =   375
      Left            =   1800
      TabIndex        =   135
      Top             =   6900
      Width           =   1455
   End
   Begin VB.CommandButton Command1 
      Caption         =   "import rental"
      Height          =   375
      Left            =   360
      TabIndex        =   134
      Top             =   6900
      Width           =   1215
   End
   Begin VB.ListBox LSTDAYs 
      Height          =   450
      Left            =   3360
      TabIndex        =   133
      Top             =   6660
      Width           =   975
   End
   Begin VB.CommandButton CMDNext 
      Caption         =   ">"
      Height          =   315
      Left            =   3000
      TabIndex        =   47
      Top             =   60
      Width           =   255
   End
   Begin VB.ComboBox CBOEstimator 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   52
      Top             =   1080
      Width           =   2055
   End
   Begin VB.ComboBox CBOProjectSource 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   51
      Top             =   1860
      Width           =   2055
   End
   Begin VB.ComboBox CBOEngineer 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   49
      Top             =   1440
      Width           =   2055
   End
   Begin VB.CommandButton CMDPrev 
      Caption         =   "<"
      Height          =   315
      Left            =   2760
      TabIndex        =   48
      Top             =   60
      Width           =   255
   End
   Begin VB.Frame FRACustomerDetails 
      Caption         =   "Customer Details"
      Height          =   3015
      Left            =   7320
      TabIndex        =   26
      Top             =   0
      Width           =   4455
      Begin ELFTxtBox.TxtBox1 TXTCustCode 
         Height          =   285
         Left            =   1080
         TabIndex        =   27
         Top             =   180
         Width           =   855
         _ExtentX        =   1508
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
      Begin ELFTxtBox.TxtBox1 TXTShortName 
         Height          =   285
         Left            =   3600
         TabIndex        =   28
         Top             =   180
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
         Text            =   ""
         UpperCase       =   -1  'True
         AutoSelect      =   -1  'True
      End
      Begin ELFTxtBox.TxtBox1 TXTCustomerName 
         Height          =   285
         Left            =   1080
         TabIndex        =   29
         Top             =   480
         Width           =   3255
         _ExtentX        =   5741
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
      Begin ELFTxtBox.TxtBox1 TXTAddress1 
         Height          =   285
         Left            =   1080
         TabIndex        =   30
         Top             =   780
         Width           =   3255
         _ExtentX        =   5741
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
      Begin ELFTxtBox.TxtBox1 TXTAddress2 
         Height          =   285
         Left            =   1080
         TabIndex        =   31
         Top             =   1080
         Width           =   3255
         _ExtentX        =   5741
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
      Begin ELFTxtBox.TxtBox1 TXTTown 
         Height          =   285
         Left            =   1080
         TabIndex        =   32
         Top             =   1380
         Width           =   3255
         _ExtentX        =   5741
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
      Begin ELFTxtBox.TxtBox1 TXTCounty 
         Height          =   285
         Left            =   1080
         TabIndex        =   33
         Top             =   1680
         Width           =   3255
         _ExtentX        =   5741
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
      Begin ELFTxtBox.TxtBox1 TXTPostcode 
         Height          =   285
         Left            =   1080
         TabIndex        =   34
         Top             =   1980
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
      Begin ELFTxtBox.TxtBox1 TXTTelephone 
         Height          =   285
         Left            =   1080
         TabIndex        =   35
         Top             =   2340
         Width           =   1815
         _ExtentX        =   3201
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
      Begin ELFTxtBox.TxtBox1 TXTHomeTelephone 
         Height          =   285
         Left            =   1080
         TabIndex        =   36
         Top             =   2640
         Width           =   1815
         _ExtentX        =   3201
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
         Caption         =   "Home Tel"
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
         Index           =   19
         Left            =   120
         TabIndex        =   46
         Top             =   2640
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Tel"
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
         Index           =   18
         Left            =   600
         TabIndex        =   45
         Top             =   2340
         Width           =   375
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Postcode"
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
         Index           =   17
         Left            =   120
         TabIndex        =   44
         Top             =   1980
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "County"
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
         Left            =   360
         TabIndex        =   43
         Top             =   1680
         Width           =   615
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Town"
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
         Left            =   480
         TabIndex        =   42
         Top             =   1380
         Width           =   495
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Street 2"
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
         Left            =   240
         TabIndex        =   41
         Top             =   1080
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Street 1"
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
         Left            =   240
         TabIndex        =   40
         Top             =   780
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
         Index           =   12
         Left            =   360
         TabIndex        =   39
         Top             =   480
         Width           =   615
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Short Name"
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
         Left            =   2160
         TabIndex        =   38
         Top             =   180
         Width           =   1335
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Number"
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
         Left            =   240
         TabIndex        =   37
         Top             =   180
         Width           =   735
      End
   End
   Begin VB.Frame FRAInsuranceDetails 
      Caption         =   "Insurance Details"
      Height          =   1515
      Left            =   240
      TabIndex        =   17
      Top             =   2280
      Width           =   4095
      Begin VB.ComboBox CBOInsurer 
         Height          =   315
         Left            =   1200
         Style           =   2  'Dropdown List
         TabIndex        =   18
         Top             =   180
         Width           =   2055
      End
      Begin ELFTxtBox.TxtBox1 TXTInsurerShortName 
         Height          =   285
         Left            =   1200
         TabIndex        =   19
         Top             =   540
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
      Begin ELFTxtBox.TxtBox1 TXTDriver 
         Height          =   285
         Left            =   1200
         TabIndex        =   20
         Top             =   840
         Width           =   2775
         _ExtentX        =   4895
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
      Begin ELFTxtBox.TxtBox1 TXTBroker 
         Height          =   285
         Left            =   1200
         TabIndex        =   21
         Top             =   1140
         Width           =   1455
         _ExtentX        =   2566
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
         Caption         =   "Broker"
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
         Index           =   23
         Left            =   360
         TabIndex        =   25
         Top             =   1140
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Driver"
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
         Index           =   22
         Left            =   480
         TabIndex        =   24
         Top             =   840
         Width           =   615
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Short Name"
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
         Index           =   21
         Left            =   0
         TabIndex        =   23
         Top             =   540
         Width           =   1095
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Insurer"
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
         Index           =   20
         Left            =   360
         TabIndex        =   22
         Top             =   180
         Width           =   735
      End
   End
   Begin VB.Frame FRAClaimDetails 
      Caption         =   "Claim Details"
      Height          =   2715
      Left            =   7920
      TabIndex        =   0
      Top             =   4560
      Width           =   3855
      Begin ELFTxtBox.TxtBox1 TXTPolicyNo 
         Height          =   285
         Left            =   1560
         TabIndex        =   1
         Top             =   240
         Width           =   2055
         _ExtentX        =   3625
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
      Begin ELFTxtBox.TxtBox1 TXTClaimNo 
         Height          =   285
         Left            =   1560
         TabIndex        =   2
         Top             =   540
         Width           =   2055
         _ExtentX        =   3625
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
      Begin ELFTxtBox.TxtBox1 TXTClaimDate 
         Height          =   285
         Left            =   1560
         TabIndex        =   3
         Top             =   840
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
      Begin ELFTxtBox.TxtBox1 TXTExcess 
         Height          =   285
         Left            =   1560
         TabIndex        =   4
         Top             =   1140
         Width           =   1455
         _ExtentX        =   2566
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
      Begin ELFTxtBox.TxtBox1 TXTVATRegistered 
         Height          =   285
         Left            =   1560
         TabIndex        =   5
         Top             =   1440
         Width           =   1455
         _ExtentX        =   2566
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
      Begin ELFTxtBox.TxtBox1 TXTVehicleDateIn 
         Height          =   285
         Left            =   1560
         TabIndex        =   6
         Top             =   1740
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
      Begin ELFTxtBox.TxtBox1 TXTInspectionDate 
         Height          =   285
         Left            =   1560
         TabIndex        =   7
         Top             =   2040
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
      Begin ELFTxtBox.TxtBox1 TXTCourtesyCar 
         Height          =   285
         Left            =   1560
         TabIndex        =   8
         Top             =   2340
         Width           =   1455
         _ExtentX        =   2566
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
         Caption         =   "Courtesy Car"
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
         Index           =   58
         Left            =   240
         TabIndex        =   16
         Top             =   2340
         Width           =   1215
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Inspection Date"
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
         Index           =   57
         Left            =   0
         TabIndex        =   15
         Top             =   2040
         Width           =   1455
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Date In"
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
         Index           =   56
         Left            =   720
         TabIndex        =   14
         Top             =   1740
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Vat Registered"
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
         Index           =   55
         Left            =   120
         TabIndex        =   13
         Top             =   1440
         Width           =   1335
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Excess"
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
         Index           =   54
         Left            =   720
         TabIndex        =   12
         Top             =   1140
         Width           =   735
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Claim Date"
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
         Index           =   53
         Left            =   480
         TabIndex        =   11
         Top             =   840
         Width           =   975
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Claim No"
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
         Index           =   52
         Left            =   600
         TabIndex        =   10
         Top             =   540
         Width           =   855
      End
      Begin VB.Label LBLZ1 
         Alignment       =   1  'Right Justify
         BackStyle       =   0  'Transparent
         Caption         =   "Policy No"
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
         Index           =   51
         Left            =   600
         TabIndex        =   9
         Top             =   240
         Width           =   855
      End
   End
   Begin ELFDateControl.DateControl TXTProjectDate 
      Height          =   615
      Left            =   5160
      TabIndex        =   50
      Top             =   60
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
   Begin ELFTxtBox.TxtBox1 TXTProjectNumber 
      Height          =   285
      Left            =   1680
      TabIndex        =   53
      Top             =   60
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
   Begin ELFTxtBox.TxtBox1 TXTJobNumber 
      Height          =   285
      Left            =   1680
      TabIndex        =   54
      Top             =   360
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
   Begin ELFTxtBox.TxtBox1 TXTInvoiceNumber 
      Height          =   285
      Left            =   1680
      TabIndex        =   55
      Top             =   660
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTReference 
      Height          =   285
      Left            =   5640
      TabIndex        =   56
      Top             =   720
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTProjectStatus 
      Height          =   285
      Left            =   5640
      TabIndex        =   57
      Top             =   1020
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTProjectType 
      Height          =   285
      Left            =   5640
      TabIndex        =   58
      Top             =   1320
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTEstimatedLabour 
      Height          =   285
      Left            =   5640
      TabIndex        =   59
      Top             =   1680
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTSuppLabour 
      Height          =   285
      Left            =   5640
      TabIndex        =   60
      Top             =   1980
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTEngineer 
      Height          =   285
      Left            =   1200
      TabIndex        =   61
      Top             =   1440
      Width           =   375
      _ExtentX        =   661
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
   Begin ELFTxtBox.TxtBox1 TXTCategory 
      Height          =   285
      Left            =   9000
      TabIndex        =   62
      Top             =   3060
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTShortModel 
      Height          =   285
      Left            =   9000
      TabIndex        =   63
      Top             =   3960
      Width           =   375
      _ExtentX        =   661
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
   Begin ELFTxtBox.TxtBox1 TXTRegNumber 
      Height          =   285
      Left            =   9000
      TabIndex        =   64
      Top             =   3360
      Width           =   855
      _ExtentX        =   1508
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
   Begin ELFTxtBox.TxtBox1 TXTShortMake 
      Height          =   285
      Left            =   9000
      TabIndex        =   65
      Top             =   3660
      Width           =   375
      _ExtentX        =   661
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
   Begin ELFTxtBox.TxtBox1 TxtType 
      Height          =   285
      Left            =   9000
      TabIndex        =   66
      Top             =   4260
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTModel 
      Height          =   285
      Left            =   9480
      TabIndex        =   67
      Top             =   3960
      Width           =   2295
      _ExtentX        =   4048
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
   Begin ELFTxtBox.TxtBox1 TXTMake 
      Height          =   285
      Left            =   9480
      TabIndex        =   68
      Top             =   3660
      Width           =   1695
      _ExtentX        =   2990
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
   Begin ELFTxtBox.TxtBox1 TXTChassisNo 
      Height          =   285
      Left            =   1440
      TabIndex        =   69
      Top             =   3900
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTColour 
      Height          =   285
      Left            =   1440
      TabIndex        =   70
      Top             =   4200
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTColourCode 
      Height          =   285
      Left            =   1440
      TabIndex        =   71
      Top             =   4500
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
   Begin ELFTxtBox.TxtBox1 TXTMileage 
      Height          =   285
      Left            =   1440
      TabIndex        =   72
      Top             =   4800
      Width           =   855
      _ExtentX        =   1508
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
   Begin ELFTxtBox.TxtBox1 TXTTrimCode 
      Height          =   285
      Left            =   1440
      TabIndex        =   73
      Top             =   5100
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTEngineCode 
      Height          =   285
      Left            =   1440
      TabIndex        =   74
      Top             =   5400
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTSpecifications 
      Height          =   285
      Left            =   1440
      TabIndex        =   75
      Top             =   5700
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTYear 
      Height          =   285
      Left            =   1440
      TabIndex        =   76
      Top             =   6000
      Width           =   495
      _ExtentX        =   873
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
   Begin ELFTxtBox.TxtBox1 TXTPaintSystem 
      Height          =   285
      Left            =   1440
      TabIndex        =   77
      Top             =   6300
      Width           =   375
      _ExtentX        =   661
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
   Begin ELFTxtBox.TxtBox1 TXTlocation 
      Height          =   285
      Left            =   1440
      TabIndex        =   78
      Top             =   6600
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTRadioMakeCode 
      Height          =   285
      Left            =   5280
      TabIndex        =   79
      Top             =   3840
      Width           =   2175
      _ExtentX        =   3836
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
   Begin ELFTxtBox.TxtBox1 TXTAlarmMakeCode 
      Height          =   285
      Left            =   5280
      TabIndex        =   80
      Top             =   4140
      Width           =   2175
      _ExtentX        =   3836
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
   Begin ELFTxtBox.TxtBox1 TXTFuelLevel 
      Height          =   285
      Left            =   5280
      TabIndex        =   81
      Top             =   4500
      Width           =   495
      _ExtentX        =   873
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
   Begin ELFTxtBox.TxtBox1 TXTDateRegistered 
      Height          =   285
      Left            =   5280
      TabIndex        =   82
      Top             =   4800
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
   Begin ELFTxtBox.TxtBox1 TXTTaxDate 
      Height          =   285
      Left            =   5280
      TabIndex        =   83
      Top             =   5100
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
   Begin ELFTxtBox.TxtBox1 TXTLampType 
      Height          =   285
      Left            =   5280
      TabIndex        =   84
      Top             =   5400
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTDamageType 
      Height          =   285
      Left            =   5280
      TabIndex        =   85
      Top             =   5760
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTPointOfImpact 
      Height          =   285
      Left            =   5280
      TabIndex        =   86
      Top             =   6060
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTCondition 
      Height          =   285
      Left            =   5280
      TabIndex        =   87
      Top             =   6360
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTPreAccCondition 
      Height          =   285
      Left            =   5280
      TabIndex        =   88
      Top             =   6660
      Width           =   1455
      _ExtentX        =   2566
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
   Begin ELFTxtBox.TxtBox1 TXTPreAccDamage 
      Height          =   285
      Left            =   5280
      TabIndex        =   89
      Top             =   6960
      Width           =   1935
      _ExtentX        =   3413
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
   Begin ELFTxtBox.TxtBox1 TXTDateIN 
      Height          =   285
      Left            =   5400
      TabIndex        =   127
      Top             =   3060
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
   Begin ELFTxtBox.TxtBox1 TXTDateOut 
      Height          =   285
      Left            =   5400
      TabIndex        =   128
      Top             =   3360
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
   Begin ELFTxtBox.TxtBox1 TXTTimeOut 
      Height          =   285
      Left            =   6480
      TabIndex        =   131
      Top             =   3360
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
   Begin ELFTxtBox.TxtBox1 TXTDays 
      Height          =   285
      Left            =   6480
      TabIndex        =   132
      Top             =   3060
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
      Caption         =   "Date Out"
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
      Index           =   60
      Left            =   4440
      TabIndex        =   130
      Top             =   3360
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Date In"
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
      Index           =   59
      Left            =   4440
      TabIndex        =   129
      Top             =   3060
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Project Number"
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
      Left            =   240
      TabIndex        =   126
      Top             =   60
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Job Number"
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
      Left            =   240
      TabIndex        =   125
      Top             =   375
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Invoice Number"
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
      TabIndex        =   124
      Top             =   660
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Reference"
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
      Left            =   4560
      TabIndex        =   123
      Top             =   720
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Project Status"
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
      Left            =   4200
      TabIndex        =   122
      Top             =   1020
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Project Type"
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
      Left            =   4440
      TabIndex        =   121
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Estimated Labour"
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
      Left            =   3960
      TabIndex        =   120
      Top             =   1680
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Supp Labour"
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
      Left            =   3960
      TabIndex        =   119
      Top             =   1980
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Estimator"
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
      Left            =   600
      TabIndex        =   118
      Top             =   1080
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Project Source"
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
      Left            =   240
      TabIndex        =   117
      Top             =   1860
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Engineer"
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
      Index           =   24
      Left            =   240
      TabIndex        =   116
      Top             =   1440
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Category"
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
      Index           =   25
      Left            =   8040
      TabIndex        =   115
      Top             =   3060
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Model"
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
      Index           =   26
      Left            =   8280
      TabIndex        =   114
      Top             =   3960
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Reg Number"
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
      Index           =   27
      Left            =   7800
      TabIndex        =   113
      Top             =   3360
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Make"
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
      Index           =   28
      Left            =   8400
      TabIndex        =   112
      Top             =   3660
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Type"
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
      Index           =   29
      Left            =   8400
      TabIndex        =   111
      Top             =   4260
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Chassis No"
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
      Index           =   30
      Left            =   240
      TabIndex        =   110
      Top             =   3900
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Colour"
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
      Index           =   31
      Left            =   720
      TabIndex        =   109
      Top             =   4200
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Colour Code"
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
      Index           =   32
      Left            =   240
      TabIndex        =   108
      Top             =   4500
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Mileage"
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
      Index           =   33
      Left            =   600
      TabIndex        =   107
      Top             =   4800
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Trim Code"
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
      Index           =   34
      Left            =   360
      TabIndex        =   106
      Top             =   5100
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Engine Code"
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
      Index           =   35
      Left            =   120
      TabIndex        =   105
      Top             =   5400
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Specifications"
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
      Index           =   36
      Left            =   0
      TabIndex        =   104
      Top             =   5700
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Year"
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
      Index           =   37
      Left            =   840
      TabIndex        =   103
      Top             =   6000
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Paint System"
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
      Index           =   38
      Left            =   120
      TabIndex        =   102
      Top             =   6300
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Location"
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
      Index           =   39
      Left            =   480
      TabIndex        =   101
      Top             =   6600
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Radio make/code"
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
      Index           =   40
      Left            =   3600
      TabIndex        =   100
      Top             =   3840
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Alarm make/code"
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
      Index           =   41
      Left            =   3600
      TabIndex        =   99
      Top             =   4140
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Fuel Level"
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
      Index           =   42
      Left            =   4200
      TabIndex        =   98
      Top             =   4500
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Date Registered"
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
      Index           =   43
      Left            =   3720
      TabIndex        =   97
      Top             =   4800
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Tax Date"
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
      Index           =   44
      Left            =   4320
      TabIndex        =   96
      Top             =   5100
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Lamp Type"
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
      Index           =   45
      Left            =   4200
      TabIndex        =   95
      Top             =   5400
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Damage Type"
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
      Index           =   46
      Left            =   3960
      TabIndex        =   94
      Top             =   5760
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Point Of Impact"
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
      Index           =   47
      Left            =   3720
      TabIndex        =   93
      Top             =   6060
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Condition"
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
      Index           =   48
      Left            =   4320
      TabIndex        =   92
      Top             =   6360
      Width           =   855
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Pre acc Condition"
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
      Index           =   49
      Left            =   3600
      TabIndex        =   91
      Top             =   6660
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Pre acc Damage"
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
      Index           =   50
      Left            =   3720
      TabIndex        =   90
      Top             =   6960
      Width           =   1455
   End
End
Attribute VB_Name = "FRMProjectWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub ClearDetails()
    Dim BlankString As String
    BlankString = "XXXX"
'    TXTProjectNumber.Text = BlankString
    TXTJobNumber.Text = BlankString
    TXTProjectDate.Text = 0 'rsCal.FieldDate("project_Date")
    TXTReference.Text = BlankString
    TXTProjectStatus.Text = BlankString
    TXTProjectType.Text = BlankString
    TXTEstimatedLabour.Text = BlankString
    TXTSuppLabour.Text = BlankString
'    CBOEstimator.Text=
'    cboprojectsource.Text
    TXTCustCode.Text = BlankString
    TXTShortName.Text = BlankString
    TXTCustomerName.Text = BlankString
    TXTAddress1.Text = BlankString
    TXTAddress2.Text = BlankString
    TXTTown.Text = BlankString
    TXTCounty.Text = BlankString
    TXTPostcode.Text = BlankString
    TXTTelephone.Text = BlankString
    TXTHomeTelephone.Text = BlankString

    'cboinsurer.Text
    TXTInsurerShortName.Text = BlankString
    TXTDriver.Text = BlankString
    TXTBroker.Text = BlankString
    TXTEngineer.Text = BlankString
    'cboengineer.Text
    
    TXTCategory.Text = BlankString
    TXTRegNumber.Text = BlankString
    TXTShortMake.Text = BlankString
    TXTMake.Text = BlankString
    TXTShortModel.Text = BlankString
    TXTModel.Text = BlankString
    TxtType.Text = BlankString
    
    TXTChassisNo.Text = BlankString
    TXTColour.Text = BlankString
    TXTColourCode.Text = BlankString
    TXTMileage.Text = BlankString
    TXTTrimCode.Text = BlankString
    TXTEngineCode.Text = BlankString
    TXTSpecifications.Text = BlankString
    TXTYear.Text = BlankString
    TXTPaintSystem.Text = BlankString
    TXTlocation.Text = BlankString
    
    TXTRadioMakeCode.Text = BlankString
    TXTAlarmMakeCode.Text = BlankString
    TXTFuelLevel.Text = BlankString
    TXTDateRegistered.Text = BlankString
    TXTTaxDate.Text = BlankString
    TXTLampType.Text = BlankString
    TXTDamageType.Text = BlankString
    TXTPointOfImpact.Text = BlankString
    TXTCondition.Text = BlankString
    TXTPreAccCondition.Text = BlankString
    TXTPreAccDamage.Text = BlankString
    
    TXTPolicyNo.Text = BlankString
    TXTClaimNo.Text = BlankString
    TXTClaimDate.Text = BlankString
    TXTExcess.Text = BlankString
    TXTVATRegistered.Text = BlankString
    TXTDateIN.Text = BlankString
    TXTInspectionDate.Text = BlankString
    TXTCourtesyCar.Text = BlankString
    
End Sub


Private Sub CMDNext_Click()
    TXTProjectNumber.Text = Val(TXTProjectNumber.Text) + 1
    Call TXTProjectNumber_Validate(False)
End Sub

Private Sub CMDPrev_Click()
    TXTProjectNumber.Text = Val(TXTProjectNumber.Text) - 1
    Call TXTProjectNumber_Validate(False)
End Sub

Private Sub Command1_Click()
    Dim rsrental As New RecordSetDat
    Dim rstemp As Recordset
    Dim rsCourtesy As Recordset
    
    If (OpenRecordset(rstemp, "SELECT * FROM CourtesyAllocate", dbOpenDynaset)) Then
        Call rsrental.ProcessSQL("SELECT * FROM Rental")
        'PROJECTNUMBER, Field2, DRIVER, DRIVINGLICENCE, DATEOUT, DATEIN,
        'MILEAGEIN, MILEAGEOUT, PETROLPRECENT, Reg, DETAILSOUT, DETAILSIN
        Do While (rsrental.EofRec = False)
            Call rstemp.AddNew
            ' getcourtesy carid
            If (OpenRecordset(rsCourtesy, "SELECT * FROM CourtesyCar WHERE reg='" & rsrental!Reg & "'", dbOpenSnapshot)) Then
                If (rsCourtesy.EOF = False) Then
                    rstemp!Courtesycarid = rsCourtesy!Uid
                End If
            End If
            
            rstemp!Jobid = rsrental!PROJECTNUMBER
'            rsrental!Field2
'            rsrental!DRIVER
'            rsrental!DRIVINGLICENCE
            rstemp!Startdate = rsrental.FieldDate("DATEOUT")
            rstemp!enddate = rsrental.FieldDate("datein")
            rstemp!MILEAGEIN = Val(rsrental!MILEAGEIN)
            rstemp!MILEAGEOUT = Val(rsrental!MILEAGEOUT)
'            rsrental!PETROLPRECENT
'            rsrental!Reg
'            rsrental!DETAILSOUT
'            rsrental!DETAILSIN
            Call rstemp.Update
            Call rsrental.MoveNext
            TXTRegNumber.Text = rsrental!Reg
            DoEvents
        Loop
    End If
End Sub

Private Sub Command2_Click()
    Dim rsCustomerDat As New RecordSetDat
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim BlackTitleID As Long
    
    Call Execute("INSERT INTO Title (Title) VALUES ('')", True)
    Call Execute("INSERT INTO Title (Title) VALUES ('MR')", True)
    Call Execute("INSERT INTO Title (Title) VALUES ('MS')", True)
    Call Execute("INSERT INTO Title (Title) VALUES ('MISS')", True)
    Call Execute("INSERT INTO Title (Title) VALUES ('MRS')", True)
    Call Execute("INSERT INTO Title (Title) VALUES ('DR')", True)
    If (OpenRecordset(rstemp2, "SELECT * FROM Title ", dbOpenDynaset)) Then
        If (rstemp2.EOF = False) Then
            BlackTitleID = rstemp2!Uid
        End If
    End If
    
    If (OpenRecordset(rstemp, "SELECT * FROM Customer", dbOpenDynaset)) Then
        Call rsCustomerDat.ProcessSQL("SELECT * FROM Calc")
        'PROJECTNUMBER, Field2, DRIVER, DRIVINGLICENCE, DATEOUT, DATEIN,
        'MILEAGEIN, MILEAGEOUT, PETROLPRECENT, Reg, DETAILSOUT, DETAILSIN
        Do While (rsCustomerDat.EofRec = False)
            Call rstemp.AddNew
            ' getcourtesy carid
            
        
'rstemp!titleid
    If (rsCustomerDat!custname <> "" And InStr(Trim$(rsCustomerDat!custname), " ") > 0) Then
        If (OpenRecordset(rstemp2, "SELECT * FROM Title WHERE Title='" & Left$(Trim$(rsCustomerDat!custname), InStr(Trim$(rsCustomerDat!custname), " ") - 1) & "'", dbOpenDynaset)) Then
            If (rstemp2.EOF = False) Then
                rstemp!TitleID = rstemp2!Uid
            Else
                rstemp!TitleID = BlackTitleID 'rstemp2!Uid
            End If
        End If
    Else
        rstemp!TitleID = BlackTitleID
    End If
    rstemp!CompanyName = ""
If (rstemp!TitleID <> BlackTitleID) Then
    rstemp!Name = Trim$(Mid$(rsCustomerDat!custname, InStr(Trim$(rsCustomerDat!custname), " ")))
Else
    rstemp!Name = Trim$(rsCustomerDat!custname)
End If
rstemp!Street1 = Trim$(rsCustomerDat!CUSTADDRESS1)
rstemp!Street2 = Trim$(rsCustomerDat!CUSTADDRESS2)
rstemp!Town = Trim$(rsCustomerDat!CUSTADDRESS3)
rstemp!County = Trim$(rsCustomerDat!CUSTADDRESS4)
rstemp!Country = "" 'rsCustomerDat!
rstemp!Postcode = Left$(Replace(rsCustomerDat!CUSTPOSTCODE, " ", ""), 7)
rstemp!ContactTelephoneNumber = Left$(Replace(rsCustomerDat!TEL, " ", ""), 13)
rstemp!Faxnumber = "" 'rsCustomerDat!
rstemp!Contactmobilenumber = "" 'rsCustomerDat!
rstemp!Contactprivatenumber = Left$(Replace(rsCustomerDat!TELHOME, " ", ""), 13)
rstemp!Emailaddress = rsCustomerDat!PROJECTNO
rstemp!Drivinglicencenumber = "" 'rsCustomerDat!
rstemp!Createdate = rsCustomerDat.FieldDate("PROJECTDATE")


'PROJECTNO   0   8   Text    8
'PROJECTDATE 8   16  Text    8
'JOBNUMBER   24  32  Text    8
'JOBDATE 32  40  Text    8
'INVOICENO   40  48  Text    8
'INVOICEDATE 48  56  Text    8
'INVOICEPREFIX   56  65  Text    9
'PROJECTTYPE 65  66  Text    1
'DATEIN  68  76  Text    8
'DATEOUT 76  84  Text    8
'TIMEOUT 84  90  Text    6
'ESTIMATOR   104 106 Text    2
'CUSTCODE    199 207 Text    8
'SHORTCUSTNAME   207 213 Text    6
'CUSTNAME    213 253 Text    40
'CUSTADDRESS1    253 283 Text    30
'CUSTADDRESS2    283 313 Text    30
'CUSTPOSTCODE    313 321 Text    8
'CUSTADDRESS3    321 351 Text    30
'CUSTADDRESS4    351 381 Text    30
'TEL 381 400 Text    19
'TELHOME 400 422 Text    22
'Field15 422 429 Text    7
'DRIVERNAME  429 469 Text    40
'Field17 469 631 Text    185
'VEHICLE_REG 631 638 Text    7
'VEHICLE_YEAR    638 643 Text    5
'VEHICLE_DATEREGISTERED  643 651 Text    8
'MAKESHORT   651 653 Text    2
'MAKE    653 673 Text    20
'MODELSHORT  673 675 Text    2
'MODEL   675 695 Text    20
'CLAIMNO 973 995 Text    22
'VEHICLE_CLAIMDATE   995 1004    Text    9
'EXCESS  1004    1015    Text    11
'VEHICLE_DAMAGETYPE  1015    1030    Text    15
'VEHICLE_POINTOFIMPACT   1030    1057    Text    27
'VEHICLE_LOCATION    1057    1069    Text    12
'VECHICLECATAGORY    1241    1242    Text    1
'INSURERNO   1243    1251    Text    8
'INSURERSHORTNAME    1251    1264    Text    13
'LABOURAGREED    1264    1271    Text    7
'LABOURAGREED2   1271    1282    Text    11
'VATPERCENT  1282    1299    Text    17
'BETTERMENT  1299    1310    Text    11
'CONTRIBUTION    1310    1321    Text    11
'LABOURESTIMATED 1343    1354    Text    11
'PROJECTSOURCE   1365    1367    Text    2
'BETTERMENT_ON   1368    1398    Text    30
'CONTRIBUTION2   1407    1436    Text    29
'REFERENCE   1447    1461    Text    14
            
            
            
            Call rstemp.Update
            Call rsCustomerDat.MoveNext
            TXTRegNumber.Text = rsCustomerDat!custname
            DoEvents
        Loop
    End If
End Sub

Private Sub Command3_Click()
    Dim rsCustomerDat As New RecordSetDat
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim makeid As Long
    
    If (OpenRecordset(rstemp, "SELECT * FROM vehicle", dbOpenDynaset)) Then
        Call rsCustomerDat.ProcessSQL("SELECT * FROM Calc")
        Do While (rsCustomerDat.EofRec = False)
            Call rstemp.AddNew
            
            
rstemp!Reg = rsCustomerDat!VEHICLE_REG
'rstemp!Colourid = rsCustomerDat!
    If (Trim$(rsCustomerDat!VEHICLE_COLOUR) <> "") Then
        If (OpenRecordset(rstemp2, "SELECT * FROM Colour WHERE Name=" & Chr$(34) & Trim$(rsCustomerDat!VEHICLE_COLOUR) & Chr$(34), dbOpenDynaset)) Then
            If (rstemp2.EOF = False) Then
                rstemp!Colourid = rstemp2!Uid
            Else
                rstemp2.AddNew
                rstemp2!Name = rsCustomerDat!VEHICLE_COLOUR
                rstemp!Colourid = rstemp2!Uid
                Call rstemp2.Update
            End If
        End If
    End If

'rstemp!Vehicleconditiontypeid = rsCustomerDat!

'rstemp!Customerid = rsCustomerDat!
    If (OpenRecordset(rstemp2, "SELECT * FROM Customer WHERE EmailAddress='" & Trim$(rsCustomerDat!PROJECTNO) & "'", dbOpenSnapshot)) Then
        If (rstemp2.EOF = False) Then
            rstemp!Customerid = rstemp2!Uid
        Else
            rstemp!Customerid = -1
        End If
    End If

'rstemp!Modelid = rsCustomerDat!
    If (OpenRecordset(rstemp2, "SELECT * FROM Make WHERE ShortName='" & Trim$(rsCustomerDat!MAKESHORT) & "'", dbOpenSnapshot)) Then
        If (rstemp2.EOF = False) Then
            makeid = rstemp2!Uid
        Else
            makeid = -1
        End If
    End If
    If (OpenRecordset(rstemp2, "SELECT * FROM Model WHERE MakeID= " & makeid & " AND ShortName='" & Trim$(rsCustomerDat!ModelSHORT) & "'", dbOpenSnapshot)) Then
        If (rstemp2.EOF = False) Then
            rstemp!Modelid = rstemp2!Uid
        Else
            rstemp!Modelid = -1
        End If
    End If
rstemp!LocationID = 1 'rsCustomerDat!
'rstemp!Lastinspectiondate = rsCustomerDat!
rstemp!Year = Val(rsCustomerDat!VEHICLE_YEAR)
rstemp!ChassisNumber = rsCustomerDat!VEHICLE_CHASSISNO
rstemp!Mileage = Val(rsCustomerDat!VEHICLE_MILEAGE)
'rstemp!Vin = rsCustomerDat!
rstemp!Lampnumber = rsCustomerDat!VEHICLE_LAMPTYPE
rstemp!EngineCode = rsCustomerDat!VEHICLE_ENGINECODE
rstemp!Radiocode = rsCustomerDat!VEHICLE_RADIOCODE
rstemp!AlarmCode = rsCustomerDat!VEHICLE_ALARMCODE
rstemp!Colourcode = rsCustomerDat!VEHICLE_COLCODE
'rstemp!Driveable = rsCustomerDat!
rstemp!Specifications = rsCustomerDat!VEHICLE_SPECIFICATIONS
rstemp!Trimcode = rsCustomerDat!VEHICLE_TRIMCODE
rstemp!Paintsystem = rsCustomerDat!VEHICLE_PAINTSYSTEM
rstemp!Registereddate = rsCustomerDat.FieldDate("VEHICLE_DATEREGISTERED")
rstemp!TaxDate = rsCustomerDat.FieldDate("VEHICLE_TAXDATE")
'rstemp!Motdate = rsCustomerDat!
rstemp!FuelLevel = Val(rsCustomerDat!VEHICLE_FUELLEVEL)


'PROJECTNO   0   8   Text    8
'PROJECTDATE 8   16  Text    8
'JOBNUMBER   24  32  Text    8
'JOBDATE 32  40  Text    8
'INVOICENO   40  48  Text    8
'INVOICEDATE 48  56  Text    8
'INVOICEPREFIX   56  65  Text    9
'PROJECTTYPE 65  66  Text    1
'DATEIN  68  76  Text    8
'DATEOUT 76  84  Text    8
'TIMEOUT 84  90  Text    6
'ESTIMATOR   104 106 Text    2
'CUSTCODE    199 207 Text    8
'SHORTCUSTNAME   207 213 Text    6
'CUSTNAME    213 253 Text    40
'CUSTADDRESS1    253 283 Text    30
'CUSTADDRESS2    283 313 Text    30
'CUSTPOSTCODE    313 321 Text    8
'CUSTADDRESS3    321 351 Text    30
'CUSTADDRESS4    351 381 Text    30
'TEL 381 400 Text    19
'TELHOME 400 422 Text    22
'DRIVERNAME  429 469 Text    40
'Field17 469 631 Text    185
'VEHICLE_REG 631 638 Text    7
'VEHICLE_YEAR    638 643 Text    5
'VEHICLE_DATEREGISTERED  643 651 Text    8
'MAKESHORT   651 653 Text    2
'MAKE    653 673 Text    20
'MODELSHORT  673 675 Text    2
'MODEL   675 695 Text    20
'VEHICLE_TYPE    695 717 Text    22
'VEHICLE_SPECIFICATIONS  717 737 Text    20
'VEHICLE_PAINTSYSTEM 737 739 Text    2
'VEHICLE_COLOUR  739 753 Text    14
'VEHICLE_COLCODE 753 761 Text    8
'VEHICLE_TRIMCODE    761 781 Text    20
'VEHICLE_ENGINECODE  781 801 Text    20
'VEHICLE_LAMPTYPE    801 821 Text    20
'VEHICLE_MILEAGE 821 828 Text    7
'VEHICLE_CHASSISNO   828 853 Text    25
'VEHICLE_FUELLEVEL   853 856 Text    3
'VEHICLE_RADIOCODE   856 878 Text    22
'VEHICLE_ALARMCODE   878 900 Text    22
'VEHICLE_TAXDATE 900 908 Text    8
'VEHICLE_CONDITION   908 918 Text    10
'VEHICLE_PREACCCONDITION 918 928 Text    10
'VEHICLE_PREACCDAMAGE    928 943 Text    15
'VEHICLE_INSPECTIONDATE  943 951 Text    8
'VEHICLE_POLICYNO    951 973 Text    22
'CLAIMNO 973 995 Text    22
'VEHICLE_CLAIMDATE   995 1004    Text    9
'EXCESS  1004    1015    Text    11
'VEHICLE_DAMAGETYPE  1015    1030    Text    15
'VEHICLE_POINTOFIMPACT   1030    1057    Text    27
'VEHICLE_LOCATION    1057    1069    Text    12
'VECHICLECATAGORY    1241    1242    Text    1
'INSURERNO   1243    1251    Text    8
'INSURERSHORTNAME    1251    1264    Text    13
'LABOURAGREED    1264    1271    Text    7
'LABOURAGREED2   1271    1282    Text    11
'VATPERCENT  1282    1299    Text    17
'BETTERMENT  1299    1310    Text    11
'CONTRIBUTION    1310    1321    Text    11
'LABOURESTIMATED 1343    1354    Text    11
'PROJECTSOURCE   1365    1367    Text    2
'BETTERMENT_ON   1368    1398    Text    30
'CONTRIBUTION2   1407    1436    Text    29
'REFERENCE   1447    1461    Text    14

            
            
            Call rstemp.Update
            Call rsCustomerDat.MoveNext
            TXTRegNumber.Text = rsCustomerDat!custname
            DoEvents
        Loop
    End If

End Sub

Private Sub Command4_Click()
    Dim rsDat As New RecordSetDat
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim makeid As Long
    
    If (OpenRecordset(rstemp, "SELECT * FROM job", dbOpenDynaset)) Then
        Call rsDat.ProcessSQL("SELECT * FROM Calc")
        Do While (rsDat.EofRec = False)
            Call rstemp.AddNew
            
            
'rstemp!Reg = rsDat!VEHICLE_REG
'rstemp!Colourid = rsCustomerDat!
    If (Trim$(rsDat!INSURERSHORTNAME) <> "") Then
        If (OpenRecordset(rstemp2, "SELECT * FROM InsuranceCompany WHERE Name=" & Chr$(34) & Trim$(rsDat!INSURERSHORTNAME) & Chr$(34), dbOpenDynaset)) Then
            If (rstemp2.EOF = False) Then
                rstemp!Insurnacecompanyid = rstemp2!Uid
            Else
                rstemp2.AddNew
                rstemp2!Name = rsDat!INSURERSHORTNAME
                rstemp!Insurnacecompanyid = rstemp2!Uid
                Call rstemp2.Update
            End If
        End If
    End If

    If (Trim$(rsDat!VEHICLE_POINTOFIMPACT) <> "") Then
        If (OpenRecordset(rstemp2, "SELECT * FROM JobPointOfInpact WHERE Name=" & Chr$(34) & Trim$(rsDat!VEHICLE_POINTOFIMPACT) & Chr$(34), dbOpenDynaset)) Then
            If (rstemp2.EOF = False) Then
                rstemp!JobPointOfImpactID = rstemp2!Uid
            Else
                rstemp2.AddNew
                rstemp2!Name = rsDat!VEHICLE_POINTOFIMPACT
                rstemp!JobPointOfImpactID = rstemp2!Uid
                Call rstemp2.Update
            End If
        End If
    End If

    If (Trim$(rsDat!PROJECTSOURCE) <> "") Then
        If (OpenRecordset(rstemp2, "SELECT * FROM JobSource WHERE ShortName=" & Chr$(34) & Trim$(rsDat!PROJECTSOURCE) & Chr$(34), dbOpenDynaset)) Then
            If (rstemp2.EOF = False) Then
                rstemp!Jobsourceid = rstemp2!Uid
            Else
'                rstemp2.AddNew
'                rstemp2!Name = rsDat!PROJECTSOURCE
'                rstemp!InsuranceCompanyid = rstemp2!Uid
'                Call rstemp2.Update
            End If
        End If
    End If

'rstemp!Vehicleconditiontypeid = rsCustomerDat!

'rstemp!Customerid = rsCustomerDat!
    If (OpenRecordset(rstemp2, "SELECT * FROM Vehicle WHERE reg='" & Trim$(rsDat!VEHICLE_REG) & "'", dbOpenSnapshot)) Then
        If (rstemp2.EOF = False) Then
            rstemp!Vehicleid = rstemp2!Uid
        Else
            rstemp!Vehicleid = -1
        End If
    End If

    If (OpenRecordset(rstemp2, "SELECT * FROM Employee WHERE shortname='" & Trim$(rsDat!ESTIMATOR) & "'", dbOpenSnapshot)) Then
        If (rstemp2.EOF = False) Then
            rstemp!Estimatorid = rstemp2!Uid
        Else
            rstemp!Estimatorid = -1
        End If
    End If
    
    
'rstemp!Modelid = rsCustomerDat!
'rstemp!Engineerid
rstemp!Startdate = rsDat.FieldDate("PROJECTDATE")
rstemp!Completedate = rsDat.FieldDate("DATEOUT")
'rstemp!Estimatedcompletedate = rsDat!
'rstemp!Comment = rsDat!
rstemp!Insurancerefernece = rsDat!CLAIMNO
rstemp!Insurancepolicynumber = rsDat!INSURERNO
'rstemp!Finalinspectiondate = rsDat!
'rstemp!Status = rsDat!
rstemp!EstimatedLabour = Val(rsDat!LABOURESTIMATED)
rstemp!Agreedlabour = Val(rsDat!LABOURAGREED)
'rstemp!SuppLabour = rsDat!
rstemp!Excess = Val(rsDat!Excess)
rstemp!Contribution = Val(rsDat!Contribution)
rstemp!Betterment = rsDat!BETTERMENT_ON
'rstemp!Excesspaid = rsDat!
rstemp!DamageType = rsDat!VEHICLE_DAMAGETYPE
rstemp!Condition = rsDat!VEHICLE_CONDITION
rstemp!PreAccessmentCondition = rsDat!VEHICLE_PREACCCONDITION
rstemp!PreAccessmentDamage = rsDat!VEHICLE_PREACCDAMAGE
rstemp!ClaimDate = rsDat.FieldDate("VEHICLE_CLAIMDATE")


'PROJECTNO   0   8   Text    8
'PROJECTDATE 8   16  Text    8
'JOBNUMBER   24  32  Text    8
'JOBDATE 32  40  Text    8
'INVOICENO   40  48  Text    8
'INVOICEDATE 48  56  Text    8
'INVOICEPREFIX   56  65  Text    9
'PROJECTTYPE 65  66  Text    1
'DATEIN  68  76  Text    8
'DATEOUT 76  84  Text    8
'TIMEOUT 84  90  Text    6
'ESTIMATOR   104 106 Text    2
'CUSTCODE    199 207 Text    8
'SHORTCUSTNAME   207 213 Text    6
'CUSTNAME    213 253 Text    40
'CUSTADDRESS1    253 283 Text    30
'CUSTADDRESS2    283 313 Text    30
'CUSTPOSTCODE    313 321 Text    8
'CUSTADDRESS3    321 351 Text    30
'CUSTADDRESS4    351 381 Text    30
'TEL 381 400 Text    19
'TELHOME 400 422 Text    22
'DRIVERNAME  429 469 Text    40
'Field17 469 631 Text    185
'VEHICLE_REG 631 638 Text    7
'VEHICLE_YEAR    638 643 Text    5
'VEHICLE_DATEREGISTERED  643 651 Text    8
'MAKESHORT   651 653 Text    2
'MAKE    653 673 Text    20
'MODELSHORT  673 675 Text    2
'MODEL   675 695 Text    20
'VEHICLE_TYPE    695 717 Text    22
'VEHICLE_SPECIFICATIONS  717 737 Text    20
'VEHICLE_PAINTSYSTEM 737 739 Text    2
'VEHICLE_COLOUR  739 753 Text    14
'VEHICLE_COLCODE 753 761 Text    8
'VEHICLE_TRIMCODE    761 781 Text    20
'VEHICLE_ENGINECODE  781 801 Text    20
'VEHICLE_LAMPTYPE    801 821 Text    20
'VEHICLE_MILEAGE 821 828 Text    7
'VEHICLE_CHASSISNO   828 853 Text    25
'VEHICLE_FUELLEVEL   853 856 Text    3
'VEHICLE_RADIOCODE   856 878 Text    22
'VEHICLE_ALARMCODE   878 900 Text    22
'VEHICLE_TAXDATE 900 908 Text    8
'VEHICLE_CONDITION   908 918 Text    10
'VEHICLE_PREACCCONDITION 918 928 Text    10
'VEHICLE_PREACCDAMAGE    928 943 Text    15
'VEHICLE_INSPECTIONDATE  943 951 Text    8
'VEHICLE_POLICYNO    951 973 Text    22
'CLAIMNO 973 995 Text    22
'VEHICLE_CLAIMDATE   995 1004    Text    9
'EXCESS  1004    1015    Text    11
'VEHICLE_DAMAGETYPE  1015    1030    Text    15
'VEHICLE_POINTOFIMPACT   1030    1057    Text    27
'VEHICLE_LOCATION    1057    1069    Text    12
'VECHICLECATAGORY    1241    1242    Text    1
'INSURERNO   1243    1251    Text    8
'INSURERSHORTNAME    1251    1264    Text    13
'LABOURAGREED    1264    1271    Text    7
'LABOURAGREED2   1271    1282    Text    11
'VATPERCENT  1282    1299    Text    17
'BETTERMENT  1299    1310    Text    11
'CONTRIBUTION    1310    1321    Text    11
'LABOURESTIMATED 1343    1354    Text    11
'PROJECTSOURCE   1365    1367    Text    2
'BETTERMENT_ON   1368    1398    Text    30
'CONTRIBUTION2   1407    1436    Text    29
'REFERENCE   1447    1461    Text    14

            
            
            Call rstemp.Update
            Call rsDat.MoveNext
            TXTRegNumber.Text = rsDat!PROJECTNO
            DoEvents
        Loop
    End If
End Sub

Private Sub Form_Load()
    Dim rscal As New RecordSetDat
'    Call rscal.ProcessSQL("SELECT * FROM Calc ")
'    Do While (rscal.EofRec = False)
'        If (IsDate(rscal.FieldDateString("DateIN")) And rscal.FieldDateString("DateOUT") <> "") Then
'            LSTDAYs.AddItem (DateDiff("d", rscal.FieldDateString("DateIN"), rscal.FieldDateString("DateOUT")))
'        End If
'        Call rscal.MoveNext
'    Loop
    TXTProjectNumber.Text = "00021579"
    Call TXTProjectNumber_Validate(False)
End Sub

Private Sub TXTProjectNumber_Validate(Cancel As Boolean)
    Dim rscal As New RecordSetDat
    '00097923
    TXTProjectNumber.Text = Format(TXTProjectNumber.Text, "00000000")
    
    Call rscal.ProcessSQL("SELECT * FROM Calc WHERE PROJECTNO='" & TXTProjectNumber.Text & "'")
    If (rscal.EofRec = False) Then
        Call ClearDetails
        TXTProjectNumber.Text = rscal!PROJECTNO
        TXTJobNumber.Text = rscal!JobNumber
        TXTProjectDate.Text = rscal.FieldDateString("project_Date")
        TXTReference.Text = rscal!REFERENCE
'        TXTProjectStatus.Text = rsCal!projectStatus
        TXTProjectType.Text = rscal!PROJECTTYPE
        TXTEstimatedLabour.Text = rscal!LABOURESTIMATED
'        TXTSuppLabour.Text = rsCal!supplabour
'        CBOEstimator.Text = rsCal!ESTIMATOR
        TXTCustCode.Text = rscal!CUSTCODE
        TXTShortName.Text = rscal!SHORTCUSTNAME
        TXTCustomerName.Text = rscal!custname
        TXTAddress1.Text = rscal!CUSTADDRESS1
        TXTAddress2.Text = rscal!CUSTADDRESS2
        TXTTown.Text = rscal!CUSTADDRESS3
        TXTCounty.Text = rscal!CUSTADDRESS4
        TXTPostcode.Text = rscal!CUSTPOSTCODE
        TXTTelephone.Text = rscal!TEL
        TXTHomeTelephone.Text = rscal!TELHOME
        
        TXTDateIN.Text = rscal.FieldDateString("DateIN")
        TXTDateOut.Text = rscal.FieldDateString("DateOUT")
        TXTTimeOut.Text = rscal!TIMEOUT
        If (rscal.FieldDateString("DateIN") <> "" And rscal.FieldDateString("DateOUT") <> "") Then
            TXTDays.Text = DateDiff("d", rscal.FieldDateString("DateIN"), rscal.FieldDateString("DateOUT"))
        Else
            TXTDays.Text = ""
        End If
        'vehicle
        'cboinsurer
        TXTInsurerShortName.Text = rscal!INSURERSHORTNAME
        TXTDriver.Text = rscal!DriverName
'        TXTBroker.Text = rsCal!tel
        'TXTEngineer.Text = engineer
        'cboengineer.Text
        
        TXTCategory.Text = rscal!VECHICLECATAGORY
        TXTRegNumber.Text = rscal!VEHICLE_REG
        TXTShortMake.Text = rscal!MAKESHORT
        TXTShortModel.Text = rscal!ModelSHORT
        TXTMake.Text = rscal!Make
        TXTModel.Text = rscal!Model
        'TxtType.Text = rsCal!te
        
        TXTChassisNo.Text = rscal!VEHICLE_CHASSISNO
        TXTColour.Text = rscal!VEHICLE_COLOUR
        TXTColourCode.Text = rscal!VEHICLE_COLCODE
        TXTMileage.Text = rscal!VEHICLE_MILEAGE
        TXTTrimCode.Text = rscal!VEHICLE_TRIMCODE
        TXTEngineCode.Text = rscal!VEHICLE_ENGINECODE
        TXTSpecifications.Text = rscal!VEHICLE_SPECIFICATIONS
        TXTYear.Text = rscal!VEHICLE_YEAR
        TXTPaintSystem.Text = rscal!VEHICLE_PAINTSYSTEM
        TXTlocation.Text = rscal!VEHICLE_LOCATION
        
        TXTRadioMakeCode.Text = rscal!VEHICLE_RADIOCODE
        TXTAlarmMakeCode.Text = rscal!VEHICLE_ALARMCODE
        TXTFuelLevel.Text = rscal!VEHICLE_FUELLEVEL
        TXTDateRegistered.Text = rscal.FieldDateString("VEHICLE_DATEREGISTERED")
        TXTTaxDate.Text = rscal.FieldDateString("VEHICLE_TAXDATE")
        TXTLampType.Text = rscal!VEHICLE_LAMPTYPE
        TXTDamageType.Text = rscal!VEHICLE_DAMAGETYPE
        TXTPointOfImpact.Text = rscal!VEHICLE_POINTOFIMPACT
        TXTCondition.Text = rscal!VEHICLE_CONDITION
        TXTPreAccCondition.Text = rscal!VEHICLE_PREACCCONDITION
        TXTPreAccDamage.Text = rscal!VEHICLE_PREACCDAMAGE
        
        TXTPolicyNo.Text = rscal!VEHICLE_POLICYNO
        TXTClaimNo.Text = rscal!CLAIMNO
        TXTClaimDate.Text = rscal.FieldDateString("VEHICLE_CLAIMDATE")
        TXTExcess.Text = rscal!Excess
        TXTVATRegistered.Text = rscal!VatPercent
        TXTVehicleDateIn.Text = rscal.FieldDateString("DATEIN")
        TXTInspectionDate.Text = rscal.FieldDateString("VEHICLE_INSPECTIONDATE")
'        TXTCourtesyCar.Text = rsCal!
        
    Else
        ' clear
        Call ClearDetails
        Call TXTProjectNumber.SetFocus
    End If

End Sub

