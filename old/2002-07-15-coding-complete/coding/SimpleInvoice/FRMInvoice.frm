VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMInvoice 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name>"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   ControlBox      =   0   'False
   HelpContextID   =   6
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin VB.ComboBox CBOCopies 
      Height          =   315
      Left            =   5880
      Style           =   2  'Dropdown List
      TabIndex        =   93
      Top             =   6900
      Width           =   615
   End
   Begin VB.ComboBox CBOAccount 
      Height          =   315
      Left            =   7320
      Style           =   2  'Dropdown List
      TabIndex        =   91
      Top             =   6480
      Width           =   1935
   End
   Begin VB.CommandButton CMDCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   7800
      TabIndex        =   90
      Top             =   6900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton CMDDeleteEstimate 
      Caption         =   "Delete"
      Height          =   375
      Left            =   6600
      TabIndex        =   89
      Top             =   6900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton CMDEstimate 
      Caption         =   "Estimate"
      Height          =   375
      Left            =   3720
      TabIndex        =   88
      Top             =   6900
      Width           =   1335
   End
   Begin VB.CommandButton CMDCustomerSearch 
      Caption         =   "Customer Search"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   1440
      TabIndex        =   87
      Top             =   6900
      Width           =   1935
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "<OK>"
      Height          =   375
      Left            =   0
      TabIndex        =   86
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   10560
      TabIndex        =   85
      Top             =   6900
      Width           =   1095
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   4
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   34
      Top             =   4500
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   3
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   28
      Top             =   4200
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   2
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   22
      Top             =   3900
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   1
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   16
      Top             =   3600
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   0
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   10
      Top             =   3300
      Width           =   3975
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   4
      Left            =   8040
      TabIndex        =   82
      Top             =   4500
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   3
      Left            =   8040
      TabIndex        =   81
      Top             =   4200
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   2
      Left            =   8040
      TabIndex        =   80
      Top             =   3900
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   1
      Left            =   8040
      TabIndex        =   79
      Top             =   3600
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   0
      Left            =   8040
      TabIndex        =   78
      Top             =   3300
      Width           =   255
   End
   Begin VB.TextBox TXTInvoiceComments 
      Height          =   1095
      Left            =   1560
      MultiLine       =   -1  'True
      ScrollBars      =   1  'Horizontal
      TabIndex        =   75
      ToolTipText     =   "Any Information entered here will be displayed on the bottom left part of the invoice"
      Top             =   5040
      Width           =   5295
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   1455
      LargeChange     =   4
      Left            =   11445
      Max             =   195
      TabIndex        =   73
      Top             =   3300
      Width           =   230
   End
   Begin ELFDateControl.DateControl TXTInvoiceDate 
      Height          =   615
      Left            =   9600
      TabIndex        =   59
      Top             =   840
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
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   315
      Left            =   2520
      TabIndex        =   0
      Top             =   360
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   556
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet1 
      Height          =   285
      Left            =   1440
      TabIndex        =   1
      Top             =   1020
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTown 
      Height          =   285
      Left            =   1440
      TabIndex        =   3
      Top             =   1620
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCounty 
      Height          =   285
      Left            =   1440
      TabIndex        =   4
      Top             =   1920
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet2 
      Height          =   285
      Left            =   1440
      TabIndex        =   2
      Top             =   1320
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPostcode 
      Height          =   285
      Left            =   1440
      TabIndex        =   6
      Top             =   2580
      Width           =   975
      _ExtentX        =   1720
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCountry 
      Height          =   285
      Left            =   1440
      TabIndex        =   5
      Top             =   2220
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTGoodsTotal 
      Height          =   285
      Left            =   10560
      TabIndex        =   42
      Top             =   5220
      Width           =   1095
      _ExtentX        =   1931
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
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVatTotal 
      Height          =   285
      Left            =   10560
      TabIndex        =   44
      Top             =   5820
      Width           =   1095
      _ExtentX        =   1931
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
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTHandling 
      Height          =   285
      Left            =   10560
      TabIndex        =   38
      Top             =   5520
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTGrandTotal 
      Height          =   285
      Left            =   10560
      TabIndex        =   47
      Top             =   6120
      Width           =   1095
      _ExtentX        =   1931
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
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   0
      Left            =   120
      TabIndex        =   53
      Top             =   3300
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   0
      Left            =   1560
      TabIndex        =   9
      ToolTipText     =   "A product must be entered"
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   0
      Left            =   9360
      TabIndex        =   12
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   1
      Left            =   120
      TabIndex        =   55
      Top             =   3600
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   1
      Left            =   1560
      TabIndex        =   15
      ToolTipText     =   "A product must be entered"
      Top             =   3600
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
      NavigationMode  =   1
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   1
      Left            =   9360
      TabIndex        =   18
      Top             =   3600
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   2
      Left            =   120
      TabIndex        =   56
      Top             =   3900
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   2
      Left            =   1560
      TabIndex        =   21
      ToolTipText     =   "A product must be entered"
      Top             =   3900
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
      NavigationMode  =   1
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   2
      Left            =   9360
      TabIndex        =   24
      Top             =   3900
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   3
      Left            =   120
      TabIndex        =   57
      Top             =   4200
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   3
      Left            =   1560
      TabIndex        =   27
      ToolTipText     =   "A product must be entered"
      Top             =   4200
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
      NavigationMode  =   1
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   3
      Left            =   9360
      TabIndex        =   30
      Top             =   4200
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   4
      Left            =   120
      TabIndex        =   58
      Top             =   4500
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   4
      Left            =   1560
      TabIndex        =   33
      ToolTipText     =   "A product must be entered"
      Top             =   4500
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
      NavigationMode  =   1
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   4
      Left            =   9360
      TabIndex        =   36
      Top             =   4500
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTHomeTelephoneNumber 
      Height          =   285
      Left            =   3840
      TabIndex        =   7
      Top             =   2580
      Width           =   1815
      _ExtentX        =   3201
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCustomerNumber 
      Height          =   285
      Left            =   1440
      TabIndex        =   62
      Top             =   0
      Width           =   1215
      _ExtentX        =   2143
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTAmountPaid 
      Height          =   285
      Left            =   10560
      TabIndex        =   64
      Top             =   6480
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTInvoiceNumber 
      Height          =   285
      Left            =   10320
      TabIndex        =   66
      Top             =   120
      Width           =   1335
      _ExtentX        =   2355
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
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFDateControl.DateControl TXTDueDate 
      Height          =   615
      Left            =   9600
      TabIndex        =   68
      Top             =   1500
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
   Begin ELFTxtBox.TxtBox1 TXTTitle 
      Height          =   315
      Left            =   1440
      TabIndex        =   70
      Top             =   360
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   556
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   0
      Left            =   840
      TabIndex        =   8
      Top             =   3300
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
      NavigationMode  =   1
      Mask            =   "########"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   1
      Left            =   840
      TabIndex        =   14
      Top             =   3600
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   2
      Left            =   840
      TabIndex        =   20
      Top             =   3900
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   3
      Left            =   840
      TabIndex        =   26
      Top             =   4200
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   4
      Left            =   840
      TabIndex        =   32
      Top             =   4500
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   0
      Left            =   10440
      TabIndex        =   13
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   1
      Left            =   10440
      TabIndex        =   19
      Top             =   3600
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   2
      Left            =   10440
      TabIndex        =   25
      Top             =   3900
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   3
      Left            =   10440
      TabIndex        =   31
      Top             =   4200
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   4
      Left            =   10440
      TabIndex        =   37
      Top             =   4500
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   0
      Left            =   8400
      TabIndex        =   11
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   1
      Left            =   8400
      TabIndex        =   17
      Top             =   3600
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   2
      Left            =   8400
      TabIndex        =   23
      Top             =   3900
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   3
      Left            =   8400
      TabIndex        =   29
      Top             =   4200
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   4
      Left            =   8400
      TabIndex        =   35
      Top             =   4500
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCustomerOrderNumber 
      Height          =   285
      Left            =   10320
      TabIndex        =   76
      Top             =   480
      Width           =   1335
      _ExtentX        =   2355
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCompanyName 
      Height          =   285
      Left            =   1440
      TabIndex        =   83
      Top             =   720
      Width           =   4215
      _ExtentX        =   7435
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
      NavigationMode  =   1
      Mask            =   "x"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Copies"
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
      Left            =   5160
      TabIndex        =   94
      Top             =   6930
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Account"
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
      Left            =   6240
      TabIndex        =   92
      Top             =   6510
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Company Name"
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
      Left            =   0
      TabIndex        =   84
      Top             =   750
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "PO Number"
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
      Index           =   21
      Left            =   9135
      TabIndex        =   77
      Top             =   510
      Width           =   1080
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
      Height          =   435
      Index           =   20
      Left            =   240
      TabIndex        =   74
      Top             =   5100
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "VAT %"
      Height          =   255
      Index           =   19
      Left            =   10440
      TabIndex        =   72
      Top             =   3090
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Qty"
      Height          =   255
      Index           =   18
      Left            =   840
      TabIndex        =   71
      Top             =   3090
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Due Date"
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
      Left            =   8520
      TabIndex        =   69
      Top             =   1830
      Width           =   975
   End
   Begin VB.Label LBLInvoiceNumber 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "<Invoice Number>"
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
      Left            =   8520
      TabIndex        =   67
      Top             =   150
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Amount Paid"
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
      Left            =   8640
      TabIndex        =   65
      Top             =   6510
      Width           =   1815
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Customer No."
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
      Left            =   0
      TabIndex        =   63
      Top             =   30
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Contact No."
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
      Left            =   2520
      TabIndex        =   61
      Top             =   2610
      Width           =   1215
   End
   Begin VB.Label LBLInvoiceDate 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "<Invoice Date>"
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
      Left            =   8040
      TabIndex        =   60
      Top             =   1170
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Description"
      Height          =   255
      Index           =   11
      Left            =   4080
      TabIndex        =   54
      Top             =   3090
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Net Amount"
      Height          =   255
      Index           =   10
      Left            =   9360
      TabIndex        =   52
      Top             =   3090
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Unit Cost"
      Height          =   255
      Index           =   9
      Left            =   8400
      TabIndex        =   51
      Top             =   3090
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Product "
      Height          =   255
      Index           =   8
      Left            =   1560
      TabIndex        =   50
      Top             =   3090
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Item NO."
      Height          =   255
      Index           =   7
      Left            =   120
      TabIndex        =   49
      Top             =   3090
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Grand Total"
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
      Left            =   9240
      TabIndex        =   48
      Top             =   6150
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Handling/Carriage"
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
      Left            =   8640
      TabIndex        =   46
      Top             =   5550
      Width           =   1815
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "VAT Total"
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
      Left            =   9240
      TabIndex        =   45
      Top             =   5850
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Goods Total"
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
      Left            =   9240
      TabIndex        =   43
      Top             =   5250
      Width           =   1215
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
      Left            =   360
      TabIndex        =   41
      Top             =   2610
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
      Left            =   600
      TabIndex        =   40
      Top             =   1050
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Contact Name"
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
      Left            =   0
      TabIndex        =   39
      Top             =   390
      Width           =   1335
   End
End
Attribute VB_Name = "FRMInvoice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Invoice Object
''
'' Coded by Dale Pitman

Private Const cMaxInvoiceLines As Long = 100

Private Type SaleLineTYPE
    ProductID As Long
    Product As String
    Description As String
    UnitCost As String
    Qty As String
    VAT As String       ' %VAT
    NetAmount As Currency
    SalesLineID As Long
End Type


Private vFormMode As FormModeENUM

Private DataStore(cMaxInvoiceLines) As SaleLineTYPE     '' Used to store sale items
Private vPragmaticChange As Boolean         '' Flag to stop recursive updates

Private vIsLoaded As Boolean
Private vLastProductIndex As Long
Private vParent As Form

'' Child forms
Private vProduct As FRMuProductSearch       '' Search screen for products
Private vCustomer As FrmuCustomerSearch
Private vTexteditor As FRMuLargeTextEditor  '' Used for editing multiline text
Private vDescriptionIndex As Long
Private vSaleClass As New ClassSale
Private vTempCustomerClass As New ClassCustomer

Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one

''
Public Function GetSaleClass() As ClassSale
    Set GetSaleClass = vSaleClass
End Function

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    If (vCurrentActiveChild.ChildType = ProductSearch) Then
        Call LogEvent("Invoice Screen, SendCInactive (ProductSearch)")
        ' Product search callback
        TXTProduct(vLastProductIndex).Text = vProduct.ProductName
        TXTDescription(vLastProductIndex).Text = vProduct.ProductDescription
        If (vProduct.NetCost <> -1) Then
            If (vProduct.VatPercent <> -1) Then
                TXTVAT(vLastProductIndex).Text = vProduct.VatPercent
            Else
                TXTVAT(vLastProductIndex).Text = "Z"
            End If
            TXTUnitCost(vLastProductIndex).Text = vProduct.NetCost
            TXTUnitCost(vLastProductIndex).Text = FormatCurrency(vProduct.NetCost)
        Else
            TXTUnitCost(vLastProductIndex).Text = ""
            TXTVAT(vLastProductIndex).Text = ""
        End If
        DataStore(TXTItemNumber(vLastProductIndex).Text - 1).ProductID = vProduct.ProductID
        
        Call TXTDescription(vLastProductIndex).SetFocus
        Call CalculateTotals
    Else
        '' Customer search callback
        If (vCurrentActiveChild.ChildType = CustomerSearch) Then
            Call LogEvent("Invoice Screen, SendCInactive (CustomerSearch)")
            If (vSaleClass.Customer.HasData = True) Then
                'load Details
                Call LogEvent("Invoice Screen, SendCInactive (ReadCustomerClass) -" & vSaleClass.Customer.CompanyName)
                Call LoadCustomerDetailsFromClass(vSaleClass.Customer)
                If (vCustomer.SaleID > 0) Then
                    ' Load previous invoice/estimate
                    vSaleClass.Uid = vCustomer.SaleID
                    Call vSaleClass.ReadRecord
                    Call vSaleClass.Invoice.ReadRecord
                    '''
                    vTempCustomerClass.Uid = vSaleClass.Invoice.InvoiceCustomerID
                    If (vTempCustomerClass.ReadRecord(True)) Then
                        Call LoadCustomerDetailsFromClass(vTempCustomerClass)
                    End If
                    '''
                    Call ClearDataStore
                    Call LoadSaleAndInvoiceDetailsFromClass
                    Call LoadSaleLineDetails(vSaleClass.Uid)
                    
                    If (vSaleClass.Invoice.Invoicetype = 0) Then
                        ' invoice
                        CMDEstimate.Enabled = False
                        
                    Else
                        If (vSaleClass.Invoice.Invoicetype = 1) Then
                        ' estimate
                        End If
                    End If
                Else
                    Call vSaleClass.ClearDetails
                    Call vSaleClass.Invoice.ClearDetails
                    CMDOK.Caption = "&OK"
                End If
                Call TXTQty(0).SetFocus
            Else
                ' close form ?
                Call Unload(Me)
            End If
        Else
            If (vCurrentActiveChild.ChildType = TextEditor) Then
                TXTDescription(vDescriptionIndex).Text = vTexteditor.Text
            Else
            End If
        End If
    End If
End Sub

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

'' Function used to correctly trigger and load all details for this screen
Public Function Search(pInvoiceID As Long, pFormMode As FormModeENUM) As Boolean
    Dim rstemp As Recordset
    Dim i As Long
    vFormMode = pFormMode
    
    If (vFormMode = Estmaite) Then
        Me.Caption = "Estimate"
    Else
        Me.Caption = "Invoice"
    End If
    
    Call LogEvent("Invoice Screen, Search()")
    If (pInvoiceID > 0) Then
        If (OpenRecordset(rstemp, "SELECT *,s.uid as salesid FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid WHERE i.uid=" & pInvoiceID, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                Search = True
                Call Me.Show
                Call ClearDetails
                ' Load Details
                vSaleClass.Customer.Uid = rstemp!Customerid
                Call vSaleClass.Customer.ReadRecord(False)
                Call LoadCustomerDetailsFromClass(vSaleClass.Customer)
                vSaleClass.Uid = rstemp!salesid
                Call vSaleClass.ReadRecord
                Call vSaleClass.Invoice.ReadRecord
                vTempCustomerClass.Uid = vSaleClass.Invoice.InvoiceCustomerID
                Call vTempCustomerClass.ReadRecord(True)
                Call LoadCustomerDetailsFromClass(vTempCustomerClass)
                
                Call LoadSaleAndInvoiceDetailsFromClass
                
                Call LoadSaleLineDetails(rstemp!salesid)
            Else
                Search = False
            End If
        Else
            Search = False
        End If
    Else
        Set vParent = Nothing
        Call ClearDetails
        Call Me.Show
        Call CMDCustomerSearch_Click
        Search = True
    End If
End Function

''
Private Sub LoadCustomerDetailsFromClass(pCustomerClass As ClassCustomer)
    Dim Tempstring As String
    TXTTitle.Text = AutoCase(pCustomerClass.Title, True)
    TXTName.Text = AutoCase(pCustomerClass.Name, True)
    TXTCompanyName.Text = AutoCase(pCustomerClass.CompanyName, True)
    TXTStreet1.Text = AutoCase(pCustomerClass.Street1, True)
    TXTStreet2.Text = AutoCase(pCustomerClass.Street2, True)
    TXTTown.Text = AutoCase(pCustomerClass.Town, True)
    TXTCounty.Text = AutoCase(pCustomerClass.County, True)
    TXTCountry.Text = AutoCase(pCustomerClass.Country, True)
    TXTHomeTelephoneNumber.Text = pCustomerClass.ContactTelephoneNumber
    
    Tempstring = ValidatePostcode(pCustomerClass.postcode)
    If (Left$(Tempstring, 5) = "ERROR") Then
        TXTPostcode.Text = ""
    Else
        TXTPostcode.Text = Tempstring
    End If

    TXTDueDate.Text = Format(DateAdd("d", pCustomerClass.DueDatePeriod, Now), "dd/mm/yyyy")
End Sub

''
Private Sub LoadSaleAndInvoiceDetailsFromClass()
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE Uid=" & vSaleClass.DisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            TXTInvoiceComments.Text = rstemp!Message & ""
        Else
            TXTInvoiceComments.Text = ""
        End If
        Call rstemp.Close
    End If
    
    ' Check for Vat Processing Flag, Check for credit notes made aganist this invoice
    CMDOK.Caption = "N/A"
    CMDOK.Enabled = False
    If (vSaleClass.Invoice.Vatbatchnumber > 0) Then
    
    Else
        If (OpenRecordset(rstemp, "SELECT * FROM CreditNote WHERE InvoiceID=" & vSaleClass.Invoice.Uid, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
            Else
                ' All is ok, this invoice can be edited
                If (vSaleClass.Invoice.Invoicetype = 1) Then
                    ' estimate
                    CMDOK.Caption = "Invoice"
                Else
                    CMDOK.Caption = "Update"
                End If
                If (vFormMode = dual Or vFormMode = Invoice) Then
                    CMDOK.Enabled = True
                End If
            End If
        End If
    End If
    
    TXTDueDate.Text = Format(vSaleClass.Invoice.Duedate, "dd/mm/yyyy")
    TXTHandling.Text = FormatCurrency(vSaleClass.Invoice.Handlingtotal)
    TXTAmountPaid.Text = FormatCurrency(vSaleClass.Invoice.Amountpaid)
    If (vSaleClass.Invoice.Invoicetype = 1) Then
        ' estimate
        TXTInvoiceDate.Text = Format(Now, "dd/mm/yyyy")
        LBLInvoiceDate.Caption = "Estimate Date"
        LBLInvoiceNumber.Caption = "Estimate Number"
    Else
        ' Invoice
        TXTInvoiceDate.Text = Format(vSaleClass.Invoice.Invoicedate, "dd/mm/yyyy")
        LBLInvoiceDate.Caption = "Invoice Date"
        LBLInvoiceNumber.Caption = "Invoice Number"
    End If
    TXTInvoiceNumber.Text = vSaleClass.Invoice.InvoiceNumber
End Sub

'' Load details from class to screen
Private Sub LoadSaleLineDetails(pSaleID As Long)
    Dim rsSaleLine As Recordset
    Dim i As Long
    vPragmaticChange = True
    If (OpenRecordset(rsSaleLine, "SELECT * FROM saleLine WHERE saleid=" & pSaleID, dbOpenSnapshot)) Then
        i = 0
        Do While (rsSaleLine.EOF = False)
            DataStore(i).SalesLineID = rsSaleLine!Uid
            
            DataStore(i).Product = AutoCase(rsSaleLine!Product, True)
            DataStore(i).Description = AutoCase(rsSaleLine!Description, True)
            DataStore(i).NetAmount = FormatCurrency(rsSaleLine!NetAmount)
            
            If (rsSaleLine!Qty > 0) Then
                DataStore(i).UnitCost = DataStore(i).NetAmount / rsSaleLine!Qty
                DataStore(i).Qty = rsSaleLine!Qty
            Else
                DataStore(i).UnitCost = ""
                DataStore(i).Qty = ""
            End If
            If (rsSaleLine!VatPercent = -1) Then
                DataStore(i).VAT = "Z"
            Else
                DataStore(i).VAT = rsSaleLine!VatPercent
            End If
            
            Call rsSaleLine.MoveNext
            i = i + 1
        Loop
        Call VScroll1_Change
    End If
    vPragmaticChange = False
    Call CalculateTotals
End Sub

''
Private Sub ClearDataStore()
    Dim i As Long
    For i = 0 To cMaxInvoiceLines
        DataStore(i).Description = ""
        DataStore(i).NetAmount = 0
        DataStore(i).Product = ""
        DataStore(i).ProductID = 0
        DataStore(i).Qty = 0
        DataStore(i).UnitCost = 0
        DataStore(i).VAT = 0
        DataStore(i).SalesLineID = 0
    Next
End Sub

''
Private Sub ClearDetails()
    Dim i As Long
    
    vPragmaticChange = True
    TXTTitle.Text = ""
    TXTName.Text = ""
    TXTCompanyName.Text = ""
    TXTStreet1.Text = ""
    TXTStreet2.Text = ""
    TXTTown.Text = ""
    TXTCounty.Text = ""
    TXTCountry.Text = ""
    TXTPostcode.Text = ""
    TXTHomeTelephoneNumber.Text = ""
    TXTInvoiceNumber.Text = ""
    TXTCustomerOrderNumber.Text = ""

    For i = 0 To FRMOptions.InvoiceCopies + 1
        Call CBOCopies.AddItem(i)
        CBOCopies.ItemData(CBOCopies.ListCount - 1) = i
    Next
    If (CBOCopies.ListCount - 1 > 0) Then
        CBOCopies.ListIndex = CBOCopies.ListCount - 1
    End If
    
    ' set in loadSaveAndInvoiceDetails
    LBLInvoiceNumber.Caption = "Invoice Number"
    LBLInvoiceDate.Caption = "Invoice Date"
    
    For i = 0 To TXTProduct.Count - 1
        TXTItemNumber(i).Text = i + 1
    Next
    
    For i = 0 To TXTProduct.Count - 1
        TXTProduct(i).Text = ""
        TXTDescription(i).Text = ""
        TXTUnitCost(i).Text = ""
        TXTQty(i).Text = ""
        TXTVAT(i).Text = ""
        TXTNetAmount(i).Text = FormatCurrency(0)
    Next
    
    TXTGoodsTotal.Text = FormatCurrency(0)
    TXTVatTotal.Text = FormatCurrency(0)
    TXTHandling.Text = FormatCurrency(FRMOptions.DefaultHandlingCharge)
    TXTGrandTotal.Text = FormatCurrency(0)
    TXTAmountPaid.Text = FormatCurrency(0)
    TXTInvoiceComments.Text = FRMOptions.InvoiceComments

    Call ClearDataStore

    VScroll1.Value = 0
    
    CMDDeleteEstimate.Visible = False
    If (vFormMode = dual Or vFormMode = Estmaite) Then
        CMDEstimate.Enabled = True
    Else
        CMDEstimate.Enabled = False
    End If
    
    vPragmaticChange = False
    
    CMDOK.Caption = "&OK"
    If (vFormMode = dual Or vFormMode = Invoice) Then
        CMDOK.Enabled = True
    Else
        CMDOK.Enabled = False
    End If
    Call vCustomer.ResetForm
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long

    If (OpenRecordset(rstemp, "saleline", dbOpenTable)) Then
        For i = 0 To TXTProduct.Count - 1
            TXTProduct(i).MaxLength = GetFieldSize(rstemp, "product")
            TXTDescription(i).MaxLength = GetFieldSize(rstemp, "description")
        Next
    End If
End Sub

''
Private Sub CalculateTotals()
    Dim i As Long
    Dim Goodstotal As Currency
    Dim GoodsTotalItem As Currency
    Dim Vattotal As Currency
    Dim VatPercent As Double
    
    ' Sync Screen data
    If (vPragmaticChange = False) Then
        vPragmaticChange = True
        
        For i = 0 To TXTNetAmount.Count - 1
            If (TXTVAT(i).Text = "Z") Then
                VatPercent = 0
            Else
                 VatPercent = Val(TXTVAT(i).Text)
            End If
        
            If (Val(TXTQty(i).Text) > 0) Then
                ' Calculate from unit cost
                GoodsTotalItem = Val(RemoveNonNumericCharacters(TXTUnitCost(i).Text)) * Val(TXTQty(i).Text)
                TXTNetAmount(i).Text = FormatCurrency(GoodsTotalItem)
            Else
                ' calcluate from net
                GoodsTotalItem = Val(RemoveNonNumericCharacters(TXTNetAmount(i).Text))
                '* Val(TXTQty(i).Text)
            End If
            
            Vattotal = Vattotal + Val(RemoveNonNumericCharacters(TXTNetAmount(i).Text)) / 100 * VatPercent
            Goodstotal = Goodstotal + GoodsTotalItem
            
            ' Sync with datastore
            DataStore(TXTItemNumber(i).Text - 1).Product = TXTProduct(i).Text
            DataStore(TXTItemNumber(i).Text - 1).Description = TXTDescription(i).Text
            If (TXTUnitCost(i).Text = "") Then
                DataStore(TXTItemNumber(i).Text - 1).UnitCost = ""
            Else
                DataStore(TXTItemNumber(i).Text - 1).UnitCost = RemoveNonNumericCharacters(TXTUnitCost(i).Text)
            End If
            DataStore(TXTItemNumber(i).Text - 1).Qty = TXTQty(i).Text
            DataStore(TXTItemNumber(i).Text - 1).VAT = TXTVAT(i).Text
            DataStore(TXTItemNumber(i).Text - 1).NetAmount = Val(RemoveNonNumericCharacters(TXTNetAmount(i).Text))
        Next
        
        Vattotal = 0
        Goodstotal = 0
        For i = 0 To cMaxInvoiceLines
            If (DataStore(i).VAT = "Z") Then
                VatPercent = 0
            Else
                VatPercent = Val(DataStore(i).VAT)
            End If
            Vattotal = Vattotal + DataStore(i).NetAmount / 100 * VatPercent
            GoodsTotalItem = DataStore(i).NetAmount '/ (100 + VatPercent) * 100
            Goodstotal = Goodstotal + GoodsTotalItem
        Next
        
        
        Vattotal = Vattotal + Val(RemoveNonNumericCharacters(TXTHandling.Text)) / 100 * FormatPercent(FRMOptions.DefaultVATPercent)
        
        TXTGoodsTotal.Text = FormatCurrency(Goodstotal)
        TXTVatTotal.Text = FormatCurrency(Vattotal) 'FormatCurrency(GoodsTotal / 100 * cVAT)
        TXTGrandTotal.Text = FormatCurrency(Goodstotal + RemoveNonNumericCharacters(TXTVatTotal.Text) + Val(RemoveNonNumericCharacters(TXTHandling.Text)))
        vPragmaticChange = False
    End If
End Sub

''
Private Sub CreateInvoice(pInvoiceType As Long)
    Dim rsInvoice As Recordset
    Dim rsSaleLine As Recordset
    Dim rsDisclaimer As Recordset
    Dim PaymentClass As New ClassPayment
    Dim OldPaymentTotal As Currency
    Dim Invoiceid As Long
    Dim SaleID As Long
    Dim DisclaimerID As Long
    Dim i As Long
    Dim InvoiceNumber As Long
    Dim Sql As String
    
    If (vSaleClass.Uid > 0 And vSaleClass.Invoice.Invoicetype = 0) Then
        ' Amend invoice
    Else
        If (pInvoiceType <> 1) Then
            ' Create invoice
            InvoiceNumber = Val(GetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, True))
            vSaleClass.Invoice.InvoiceNumber = FRMOptions.InvoiceNumberPreFix & InvoiceNumber
            Call SetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, InvoiceNumber + 1)
        Else
            ' estimate
            TXTInvoiceComments.Text = FRMOptions.EstimateComments
            InvoiceNumber = Val(GetServerSetting("NEXTESTIMATENUMBER", True))
            vSaleClass.Invoice.InvoiceNumber = "E" & InvoiceNumber
            Call SetServerSetting("NEXTESTIMATENUMBER", InvoiceNumber + 1)
        End If
    End If
    
    Call LogEvent("Invoice Screen, Create Invoice")
    vSaleClass.Invoice.Goodstotal = RemoveNonNumericCharacters(TXTGoodsTotal.Text)
    vSaleClass.Invoice.Vattotal = RemoveNonNumericCharacters(TXTVatTotal.Text)
    vSaleClass.Invoice.Handlingtotal = RemoveNonNumericCharacters(TXTHandling.Text)
    vSaleClass.Invoice.Invoicedate = CDate(TXTInvoiceDate.Text)
    OldPaymentTotal = vSaleClass.Invoice.Amountpaid
    vSaleClass.Invoice.Amountpaid = RemoveNonNumericCharacters(TXTAmountPaid.Text)
    
    vSaleClass.Invoice.Duedate = CDate(TXTDueDate.Text)
    vSaleClass.Invoice.Invoicetype = pInvoiceType
    
    Call vSaleClass.Customer.SyncRecord
    vSaleClass.Customerid = vSaleClass.Customer.Uid
    
    ' Only update address information if invoice is re-printed
    If (vSaleClass.Invoice.InvoiceCustomerID <= 0 Or CBOCopies.ItemData(CBOCopies.ListIndex) > 0) Then
    'CHKDontPrint.Value = vbUnchecked) Then
        Call vSaleClass.Customer.CreateRecord(True)
        vSaleClass.Invoice.InvoiceCustomerID = vSaleClass.Customer.Uid
    End If
    Call vSaleClass.Invoice.SyncRecord
    
    ' IF a payment has been made, log it
    If (vSaleClass.Invoice.Amountpaid > OldPaymentTotal) Then
        ' Log payment
        vSaleClass.Invoice.Paymentdate = Now
        
        PaymentClass.Amountpaid = vSaleClass.Invoice.Amountpaid - OldPaymentTotal
        PaymentClass.Paymentdate = Now 'CDate(TXTInvoiceDate.Text)
        PaymentClass.Invoiceid = vSaleClass.Invoice.Uid
        PaymentClass.AccountID = CBOAccount.ItemData(CBOAccount.ListIndex)
        Call PaymentClass.CreateRecord
    End If
            
    If (OpenRecordset(rsDisclaimer, "SELECT * FROM Disclaimer WHERE message=" & cTextField & TXTInvoiceComments.Text & cTextField, dbOpenDynaset)) Then
        If (rsDisclaimer.EOF = False) Then
        Else
            Call rsDisclaimer.AddNew
        End If
        DisclaimerID = rsDisclaimer!Uid
        rsDisclaimer!Message = TXTInvoiceComments.Text
        Call rsDisclaimer.Update
    End If
    
    vSaleClass.DisclaimerID = DisclaimerID
    vSaleClass.Invoiceid = vSaleClass.Invoice.Uid
    vSaleClass.CustomerOrderNumber = TXTCustomerOrderNumber.Text
    
    Call vSaleClass.SyncRecord
    SaleID = vSaleClass.Uid
    
    For i = 0 To cMaxInvoiceLines
        If (Len(Trim$(DataStore(i).Product)) > 0 Or Len(Trim$(DataStore(i).Description)) > 0) Then
            If (DataStore(i).SalesLineID > 0) Then ' If editing an invoice line
                Sql = "SELECT * FROM SaleLine WHERE SaleID=" & SaleID & " AND UID=" & DataStore(i).SalesLineID
            Else ' Allways create record
                Sql = "SELECT * FROM SaleLine WHERE SaleID=-1"
            End If
            If (OpenRecordset(rsSaleLine, Sql, dbOpenDynaset)) Then
                If (rsSaleLine.EOF = False) Then
                Else
                    Call rsSaleLine.AddNew
                End If
                rsSaleLine!SaleID = SaleID
                rsSaleLine!Product = Trim$(UCase$(DataStore(i).Product))
                rsSaleLine!ProductID = DataStore(i).ProductID
                rsSaleLine!Description = Trim$(UCase$(DataStore(i).Description))
                rsSaleLine!NetAmount = DataStore(i).NetAmount
                rsSaleLine!VatAmount = DataStore(i).NetAmount / 100 * Val(DataStore(i).VAT)
                If (DataStore(i).VAT = "Z") Then
                    rsSaleLine!VatPercent = -1
                Else
                    rsSaleLine!VatPercent = Val(DataStore(i).VAT)
                End If
                If (DataStore(i).Qty = "") Then
                    rsSaleLine!Qty = -1
                Else
                    rsSaleLine!Qty = DataStore(i).Qty
                End If
                Call rsSaleLine.Update
            End If
            Call rsSaleLine.Close
        Else
            ' May have to remove saleid, if editing an invoice
            If (DataStore(i).SalesLineID > 0) Then ' If editing an invoice line
                Call Execute("DELETE FROM SaleLine WHERE UID=" & DataStore(i).SalesLineID, True)
            End If
        End If
    Next
    
    Call LogEvent("Invoice Screen, CreateInvoice,Print")
    
'    If (CHKDontPrint.Value = vbUnchecked) Then
    If (CBOCopies.ItemData(CBOCopies.ListIndex) > 0) Then
        If (pInvoiceType = 0) Then
            
            Call PrintInvoice("INVOICE", vSaleClass, False)
            
            For i = 0 To CBOCopies.ItemData(CBOCopies.ListIndex) - 2
'            For i = 0 To FRMOptions.InvoiceCopies - 1
                Call PrintInvoice("INVOICE COPY", vSaleClass, False)
            Next
        Else
            Call PrintInvoice("QUOTATION", vSaleClass, True)
'            For i = 0 To FRMOptions.InvoiceCopies - 1
'                Call PrintInvoice("QUOTATION COPY", vSaleClass)
'            Next
        End If
    End If
    
    Call LogEvent("Invoice Screen, CreateInvoice,End")
            
    Call ClearDetails
    Call CMDCustomerSearch_Click
End Sub

''
Private Sub CMDCustomerSearch_Click()
    Call LogEvent("Invoice Screen, CustomerSearch Click")
    If (vParent Is Nothing) Then
        Set vCurrentActiveChild = vCustomer
        Me.Enabled = False
        Call vCustomer.Search
    Else
        Me.Visible = False
        Call vParent.SendChildInactive
    End If
End Sub

'' Show big text box, for entering long descriptions
Private Sub CMDDescriptionExpand_Click(index As Integer)
    vDescriptionIndex = index
    vTexteditor.Text = TXTDescription(index).Text
    Set vCurrentActiveChild = vTexteditor
    Me.Enabled = False
    Call vTexteditor.Search
End Sub

''
Private Sub CMDEstimate_Click()
    Call CreateInvoice(1)
End Sub

''
Private Sub CMDExit_Click()
    Call LogEvent("Invoice Screen, Exit Click")
    Call ClearDetails
    Call CMDCustomerSearch_Click
End Sub

''
Private Sub CMDOK_Click()
    Dim Continue As Boolean
    CMDOK.Enabled = False ' Disable button to aviod double click's
    Continue = False
    
    If (RemoveNonNumericCharacters(TXTGrandTotal.Text) = 0) Then
        If (Messagebox("WARNING: Invoice has no value, continue?", vbQuestion + vbYesNo) = vbYes) Then
            Continue = True
        End If
    Else
        Continue = True
    End If
    
    If (Continue = True) Then
        If (vSaleClass.Uid > 0 And vSaleClass.Invoice.Invoicetype = 1) Then
            If (Messagebox("Create invoice from estimate, Are you sure ?", vbQuestion + vbYesNo) = vbYes) Then
            
'                Continue = True
            Else
                Continue = False
            End If
        End If
    End If
    
    If (Continue = True) Then
        Call CreateInvoice(FRMOptions.WorkstationIndex)
    End If
    CMDOK.Enabled = True
End Sub

''
Private Sub Form_Load()
    Call LogEvent("Invoice Screen, Load")
    vIsLoaded = True
    vPragmaticChange = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)
    VScroll1.Max = cMaxInvoiceLines - TXTItemNumber.Count

    TXTInvoiceDate.Text = Format(Now, "dd/mm/yyyy")
    TXTDueDate.Text = Format(DateAdd("d", FRMOptions.DefaultDuePeriod, Now), "dd/mm/yyyy")
    TXTHandling.Text = GetServerSetting("DEFAULTHANDLING", False)

    Set vCustomer = New FrmuCustomerSearch
    Set vProduct = New FRMuProductSearch
    Set vTexteditor = New FRMuLargeTextEditor
    Call vCustomer.SetParent(Me)
    Call vCustomer.SetCustomerClass(vSaleClass.Customer)
    Call vProduct.SetParent(Me)
    Call vTexteditor.SetParent(Me)
    Call LoadListCBO(CBOAccount, "Account", "Name", "UID", False, True)
    If (CBOAccount.ListCount > 2) Then
        CBOAccount.ListIndex = 1
    End If
    
    vTexteditor.TextFontName = "Arial"
    vTexteditor.TextFontSize = 10
    Call SetupFieldSizes
'    Call ClearDetails
    vPragmaticChange = False
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    If (vParent Is Nothing) Then
    Else
        Call vParent.SendChildInactive
    End If
End Sub

''
Private Sub TXTAmountPaid_Change()
    Call CalculateTotals
End Sub

''
Private Sub TXTAmountPaid_GotFocus()
    TXTAmountPaid.Text = Replace(TXTAmountPaid.Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTAmountPaid_LostFocus()
    TXTAmountPaid.Text = FormatCurrency(TXTAmountPaid.Text)
End Sub

''
Private Sub TXTDescription_Change(index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTDescription_KeyPress(index As Integer, KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
        KeyAscii = 0
    End If
End Sub

''
Private Sub TXTDescription_LostFocus(index As Integer)
    TXTDescription(index).Text = TXTDescription(index).Text 'AutoCase(, True)
End Sub


''
Private Sub TXTHandling_Change()
    Call CalculateTotals
End Sub

''
Private Sub TXTHandling_GotFocus()
    TXTHandling.Text = Replace(TXTHandling.Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTHandling_LostFocus()
    TXTHandling.Text = FormatCurrency(RemoveNonNumericCharacters(TXTHandling.Text))
End Sub

''
Private Sub TXTHandling_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button = 2 And FRMContextMenu.ShowHandlingPopupMenu = True) Then
        Call PopupMenu(FRMContextMenu.MNUHandlingMenu)
    End If
End Sub

''
Private Sub TXTNetAmount_Change(index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTNetAmount_GotFocus(index As Integer)
    TXTNetAmount(index).Text = Replace(TXTNetAmount(index).Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTNetAmount_KeyDown(index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And index > 0) Then 'up
        Call TXTNetAmount(index - 1).SetFocus
    End If
    If (KeyCode = 40 And index < TXTNetAmount.Count - 1) Then 'down
'        Call TXTNetAmount(index + 1).SetFocus
        Call TXTQty(index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTNetAmount_LostFocus(index As Integer)
    TXTNetAmount(index).Text = FormatCurrency(RemoveNonNumericCharacters(TXTNetAmount(index).Text))
End Sub

Private Sub TXTNetAmount_MouseDown(index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button = 2) Then
        FRMContextMenu.vDiscountIndex = index
        FRMContextMenu.vUseUnitCost = False
        Call PopupMenu(FRMContextMenu.MNUDiscountMenu)
    End If
End Sub

''
Private Sub TXTProduct_Change(index As Integer)
    Call CalculateTotals
End Sub

Private Sub TXTProduct_DblClick(index As Integer)
    TXTProduct(index).Text = " "
    Call TXTProduct_Validate(index, False)
End Sub

''
Private Sub TXTProduct_KeyDown(index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And index > 0) Then 'up
        Call TXTProduct(index - 1).SetFocus
    End If
    If (KeyCode = 40 And index < TXTProduct.Count - 1) Then 'down
        Call TXTQty(index + 1).SetFocus
'        Call TXTProduct(index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTProduct_KeyPress(index As Integer, KeyAscii As Integer)
    If (TXTVAT(index).Text = "") Then
        TXTVAT(index).Text = FormatPercent(FRMOptions.DefaultVATPercent)
    End If
End Sub

Private Sub TXTProduct_Validate(index As Integer, Cancel As Boolean)
    If (TXTProduct(index).Text <> "") Then
        If (FRMOptions.UseProductDatabase = True) Then
            Set vCurrentActiveChild = vProduct
            vLastProductIndex = index
            vProduct.ProductName = TXTProduct(index).Text
            Me.Enabled = False
            If (vProduct.Search()) Then
            Else
                Me.Enabled = True
                Call TXTDescription(index).SetFocus
            End If
        Else
            Call TXTDescription(index).SetFocus
        End If
    Else
        Call TXTDescription(index).SetFocus
    End If
End Sub

''
Private Sub TXTQty_Change(index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTQty_KeyDown(index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And index > 0) Then 'up
        Call TXTQty(index - 1).SetFocus
    End If
    If (KeyCode = 40 And index < TXTQty.Count - 1) Then 'down
        Call TXTQty(index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTUnitCost_Change(index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTUnitCost_GotFocus(index As Integer)
    TXTUnitCost(index).Text = Replace(TXTUnitCost(index).Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTUnitCost_KeyDown(index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And index > 0) Then 'up
        Call TXTUnitCost(index - 1).SetFocus
    End If
    If (KeyCode = 40 And index < TXTUnitCost.Count - 1) Then 'down
        Call TXTQty(index + 1).SetFocus
'        Call TXTUnitCost(index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTUnitCost_LostFocus(index As Integer)
    If (TXTUnitCost(index).Text <> "") Then
        TXTUnitCost(index).Text = FormatCurrency(RemoveNonNumericCharacters(TXTUnitCost(index).Text))
    Else
    End If
End Sub

Private Sub TXTUnitCost_MouseDown(index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button = 2) Then
        FRMContextMenu.vDiscountIndex = index
        FRMContextMenu.vUseUnitCost = True
        Call PopupMenu(FRMContextMenu.MNUDiscountMenu)
    End If
End Sub

''
Private Sub TXTVAT_Change(index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTVAT_KeyDown(index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And index > 0) Then 'up
        Call TXTVAT(index - 1).SetFocus
    End If
    If (KeyCode = 40 And index < TXTVAT.Count - 1) Then 'down
        Call TXTQty(index + 1).SetFocus
'        Call TXTVAT(index + 1).SetFocus
    End If
End Sub

''
Private Sub VScroll1_Change()
    Dim i As Long
    vPragmaticChange = True
    For i = 0 To 4
        ' Sync with datastore
        TXTItemNumber(i).Text = i + VScroll1.Value + 1
        TXTProduct(i).Text = DataStore(i + VScroll1.Value).Product
        TXTDescription(i).Text = DataStore(i + VScroll1.Value).Description
        TXTUnitCost(i).Text = FormatCurrency(Val(DataStore(i + VScroll1.Value).UnitCost))
        TXTQty(i).Text = DataStore(i + VScroll1.Value).Qty
        If (DataStore(i + VScroll1.Value).VAT <> "") Then
            TXTVAT(i).Text = DataStore(i + VScroll1.Value).VAT
        Else
            TXTVAT(i).Text = ""
        End If
        TXTNetAmount(i).Text = FormatCurrency(DataStore(i + VScroll1.Value).NetAmount)
    Next
    vPragmaticChange = False
End Sub
