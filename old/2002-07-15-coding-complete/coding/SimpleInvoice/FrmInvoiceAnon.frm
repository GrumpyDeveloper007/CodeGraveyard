VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FrmInvoiceAnon 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Invoice without customer details"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11700
   ControlBox      =   0   'False
   HelpContextID   =   29
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11700
   Begin VB.CommandButton CMDOK 
      Caption         =   "<OK>"
      Height          =   375
      Left            =   0
      TabIndex        =   100
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   9120
      TabIndex        =   99
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   10560
      TabIndex        =   98
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   7
      Left            =   8040
      TabIndex        =   89
      Top             =   4560
      Width           =   255
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   7
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   88
      Top             =   4560
      Width           =   3975
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   6
      Left            =   8040
      TabIndex        =   82
      Top             =   4260
      Width           =   255
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   6
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   81
      Top             =   4260
      Width           =   3975
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   5
      Left            =   8040
      TabIndex        =   75
      Top             =   3960
      Width           =   255
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   5
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   74
      Top             =   3960
      Width           =   3975
   End
   Begin VB.CheckBox CHKDontPrint 
      Caption         =   "Dont Print"
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
      Left            =   1320
      TabIndex        =   12
      Top             =   6900
      Width           =   1215
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   2415
      LargeChange     =   4
      Left            =   11445
      Max             =   195
      TabIndex        =   11
      Top             =   2460
      Width           =   230
   End
   Begin VB.TextBox TXTInvoiceComments 
      Height          =   1095
      Left            =   1560
      MultiLine       =   -1  'True
      ScrollBars      =   1  'Horizontal
      TabIndex        =   10
      ToolTipText     =   "Any Information entered here will be displayed on the bottom left part of the invoice"
      Top             =   5040
      Width           =   6495
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   0
      Left            =   8040
      TabIndex        =   9
      Top             =   2460
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   1
      Left            =   8040
      TabIndex        =   8
      Top             =   2760
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   2
      Left            =   8040
      TabIndex        =   7
      Top             =   3060
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   3
      Left            =   8040
      TabIndex        =   6
      Top             =   3360
      Width           =   255
   End
   Begin VB.CommandButton CMDDescriptionExpand 
      Caption         =   "..."
      Height          =   285
      Index           =   4
      Left            =   8040
      TabIndex        =   5
      Top             =   3660
      Width           =   255
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   0
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   4
      Top             =   2460
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   1
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   3
      Top             =   2760
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   2
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   3060
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   3
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   3360
      Width           =   3975
   End
   Begin VB.TextBox TXTDescription 
      Height          =   285
      Index           =   4
      Left            =   4080
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   3660
      Width           =   3975
   End
   Begin ELFDateControl.DateControl TXTInvoiceDate 
      Height          =   615
      Left            =   9600
      TabIndex        =   13
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
   Begin ELFTxtBox.TxtBox1 TXTGoodsTotal 
      Height          =   285
      Left            =   10560
      TabIndex        =   14
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
      TabIndex        =   15
      Top             =   5520
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
      TabIndex        =   16
      Top             =   5820
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
      TabIndex        =   17
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
      TabIndex        =   18
      Top             =   2460
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
      TabIndex        =   19
      ToolTipText     =   "A product must be entered"
      Top             =   2460
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   0
      Left            =   9360
      TabIndex        =   20
      Top             =   2460
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
   Begin ELFTxtBox.TxtBox1 TXTGrossAmount 
      Height          =   285
      Index           =   0
      Left            =   6120
      TabIndex        =   21
      Top             =   300
      Visible         =   0   'False
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
      TabIndex        =   22
      Top             =   2760
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
      TabIndex        =   23
      ToolTipText     =   "A product must be entered"
      Top             =   2760
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   1
      Left            =   9360
      TabIndex        =   24
      Top             =   2760
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
   Begin ELFTxtBox.TxtBox1 TXTGrossAmount 
      Height          =   285
      Index           =   1
      Left            =   6120
      TabIndex        =   25
      Top             =   600
      Visible         =   0   'False
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
      TabIndex        =   26
      Top             =   3060
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
      TabIndex        =   27
      ToolTipText     =   "A product must be entered"
      Top             =   3060
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   2
      Left            =   9360
      TabIndex        =   28
      Top             =   3060
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
   Begin ELFTxtBox.TxtBox1 TXTGrossAmount 
      Height          =   285
      Index           =   2
      Left            =   6120
      TabIndex        =   29
      Top             =   900
      Visible         =   0   'False
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
      TabIndex        =   30
      Top             =   3360
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
      TabIndex        =   31
      ToolTipText     =   "A product must be entered"
      Top             =   3360
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   3
      Left            =   9360
      TabIndex        =   32
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTGrossAmount 
      Height          =   285
      Index           =   3
      Left            =   6120
      TabIndex        =   33
      Top             =   1200
      Visible         =   0   'False
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
      TabIndex        =   34
      Top             =   3660
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
      TabIndex        =   35
      ToolTipText     =   "A product must be entered"
      Top             =   3660
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   4
      Left            =   9360
      TabIndex        =   36
      Top             =   3660
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
   Begin ELFTxtBox.TxtBox1 TXTGrossAmount 
      Height          =   285
      Index           =   4
      Left            =   6120
      TabIndex        =   37
      Top             =   1500
      Visible         =   0   'False
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
   Begin ELFTxtBox.TxtBox1 TXTAmountPaid 
      Height          =   285
      Left            =   10560
      TabIndex        =   38
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
      TabIndex        =   39
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
      TabIndex        =   40
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
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   0
      Left            =   840
      TabIndex        =   41
      Top             =   2460
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
      Index           =   1
      Left            =   840
      TabIndex        =   42
      Top             =   2760
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
      TabIndex        =   43
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   3
      Left            =   840
      TabIndex        =   44
      Top             =   3360
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
      TabIndex        =   45
      Top             =   3660
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
      TabIndex        =   46
      Top             =   2460
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
      TabIndex        =   47
      Top             =   2760
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
      TabIndex        =   48
      Top             =   3060
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
      TabIndex        =   49
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVAT 
      Height          =   285
      Index           =   4
      Left            =   10440
      TabIndex        =   50
      Top             =   3660
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
      TabIndex        =   51
      Top             =   2460
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
      TabIndex        =   52
      Top             =   2760
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
      TabIndex        =   53
      Top             =   3060
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
      TabIndex        =   54
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTUnitCost 
      Height          =   285
      Index           =   4
      Left            =   8400
      TabIndex        =   55
      Top             =   3660
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
      TabIndex        =   56
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
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   5
      Left            =   1560
      TabIndex        =   76
      ToolTipText     =   "A product must be entered"
      Top             =   3960
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   5
      Left            =   9360
      TabIndex        =   77
      Top             =   3960
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
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   5
      Left            =   840
      TabIndex        =   78
      Top             =   3960
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
      Index           =   5
      Left            =   10440
      TabIndex        =   79
      Top             =   3960
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
      Index           =   5
      Left            =   8400
      TabIndex        =   80
      Top             =   3960
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   6
      Left            =   1560
      TabIndex        =   83
      ToolTipText     =   "A product must be entered"
      Top             =   4260
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   6
      Left            =   9360
      TabIndex        =   84
      Top             =   4260
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
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   6
      Left            =   840
      TabIndex        =   85
      Top             =   4260
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
      Index           =   6
      Left            =   10440
      TabIndex        =   86
      Top             =   4260
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
      Index           =   6
      Left            =   8400
      TabIndex        =   87
      Top             =   4260
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
   Begin ELFTxtBox.TxtBox1 TXTProduct 
      Height          =   285
      Index           =   7
      Left            =   1560
      TabIndex        =   90
      ToolTipText     =   "A product must be entered"
      Top             =   4560
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
      NavigationMode  =   0
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTNetAmount 
      Height          =   285
      Index           =   7
      Left            =   9360
      TabIndex        =   91
      Top             =   4560
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
   Begin ELFTxtBox.TxtBox1 TXTQty 
      Height          =   285
      Index           =   7
      Left            =   840
      TabIndex        =   92
      Top             =   4560
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
      Index           =   7
      Left            =   10440
      TabIndex        =   93
      Top             =   4560
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
      Index           =   7
      Left            =   8400
      TabIndex        =   94
      Top             =   4560
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
      Index           =   5
      Left            =   120
      TabIndex        =   95
      Top             =   3960
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
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   6
      Left            =   120
      TabIndex        =   96
      Top             =   4260
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
   Begin ELFTxtBox.TxtBox1 TXTItemNumber 
      Height          =   285
      Index           =   7
      Left            =   120
      TabIndex        =   97
      Top             =   4560
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
      TabIndex        =   73
      Top             =   5220
      Width           =   1215
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
      TabIndex        =   72
      Top             =   5520
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
      TabIndex        =   71
      Top             =   5820
      Width           =   1815
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
      TabIndex        =   70
      Top             =   6120
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Item NO."
      Height          =   255
      Index           =   7
      Left            =   120
      TabIndex        =   69
      Top             =   2220
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Product "
      Height          =   255
      Index           =   8
      Left            =   1560
      TabIndex        =   68
      Top             =   2220
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Unit Cost"
      Height          =   255
      Index           =   9
      Left            =   8400
      TabIndex        =   67
      Top             =   2220
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Net Amount"
      Height          =   255
      Index           =   10
      Left            =   9360
      TabIndex        =   66
      Top             =   2220
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Description"
      Height          =   255
      Index           =   11
      Left            =   4080
      TabIndex        =   65
      Top             =   2220
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
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
      Index           =   12
      Left            =   8280
      TabIndex        =   64
      Top             =   1140
      Width           =   1215
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
      TabIndex        =   63
      Top             =   6480
      Width           =   1815
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
      Index           =   16
      Left            =   8760
      TabIndex        =   62
      Top             =   120
      Width           =   1455
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
      TabIndex        =   61
      Top             =   1800
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Qty"
      Height          =   255
      Index           =   18
      Left            =   840
      TabIndex        =   60
      Top             =   2220
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "VAT %"
      Height          =   255
      Index           =   19
      Left            =   10440
      TabIndex        =   59
      Top             =   2220
      Width           =   495
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
      TabIndex        =   58
      Top             =   5100
      Width           =   1215
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
      Left            =   8280
      TabIndex        =   57
      Top             =   480
      Width           =   1935
   End
End
Attribute VB_Name = "FrmInvoiceAnon"
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
'    VatType As Long
    grossAmount As Currency
    NetAmount As Currency
End Type


Private DataStore(cMaxInvoiceLines) As SaleLineTYPE
Private vPragmaticChange As Boolean

Private vIsLoaded As Boolean
Private vCustomerid As Long
Private vLastProductIndex As Long
Private vParent As Form



'' Child forms
Private vProduct As FRMuProductSearch       '' Search screen for products
Private vTexteditor As FRMuLargeTextEditor  '' Used for editing multiline text
Private vDescriptionIndex As Long
Private vSaleClass As New ClassSale

Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    If (vCurrentActiveChild.ChildType = ProductSearch) Then
        ' Product search callback
        TXTProduct(vLastProductIndex).Text = vProduct.ProductName
        TXTDescription(vLastProductIndex).Text = vProduct.ProductDescription
        If (vProduct.NetCost <> -1) Then
            TXTNetAmount(vLastProductIndex).Text = vProduct.NetCost
            If (vProduct.VatPercent <> -1) Then
                TXTVAT(vLastProductIndex).Text = "Z"
            End If
        Else
            TXTNetAmount(vLastProductIndex).Text = ""
            TXTVAT(vLastProductIndex).Text = ""
        End If
        DataStore(TXTItemNumber(vLastProductIndex).Text - 1).ProductID = vProduct.ProductID
        
        Call TXTDescription(vLastProductIndex).SetFocus
        Call CalculateTotals
    Else
        '' Customer search callback
        If (vCurrentActiveChild.ChildType = CustomerSearch) Then
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
Public Function Search(pInvoiceID As Long) As Boolean
    Dim rstemp As Recordset
    Dim i As Long
    If (pInvoiceID > 0) Then
        If (OpenRecordset(rstemp, "SELECT *,s.uid as salesid FROM (sale s INNER JOIN invoice i ON s.invoiceid=i.uid) INNER JOIN customer c ON s.customerid=c.uid WHERE i.uid=" & pInvoiceID, dbOpenSnapshot)) Then
            If (rstemp.EOF = False) Then
                Search = True
                Call Me.Show
                ' Load Details
                vSaleClass.Customer.Uid = rstemp!Customerid
                Call vSaleClass.Customer.ReadRecord
                Call LoadCustomerDetailsFromClass
    '            TXTTitle.Text = GlobalTitles.GetTitle(rstemp!TitleID)
                vSaleClass.Uid = rstemp!salesid
                Call vSaleClass.ReadRecord
                Call vSaleClass.Invoice.ReadRecord
                Call LoadSaleAndInvoiceDetailsFromClass
                
                Call LoadSaleLineDetails(rstemp!salesid)
            Else
                Search = False
            End If
        Else
            Search = False
        End If
    Else
        Call Me.Show
        Search = True
    End If
End Function

''
Private Sub LoadCustomerDetailsFromClass()
    TXTDueDate.Text = Format(DateAdd("d", vSaleClass.Customer.DueDatePeriod, Now), "dd/mm/yyyy")
'    TXTInvoiceDate.Text = rstemp!invoiceDate
'    TXTHandling.Text = FormatCurrency(rstemp!handlingtotal)
'    TXTAmountPaid.Text = FormatCurrency(rstemp!amountpaid)
'    TXTInvoiceNumber.Text = rstemp!InvoiceNumber
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
                CMDOK.Caption = "Update"
                CMDOK.Enabled = True
            End If
        End If
    End If
    
    TXTDueDate.Text = Format(vSaleClass.Invoice.Duedate, "dd/mm/yyyy")
    TXTInvoiceDate.Text = Format(vSaleClass.Invoice.Invoicedate, "dd/mm/yyyy")
    TXTHandling.Text = FormatCurrency(vSaleClass.Invoice.Handlingtotal)
    TXTAmountPaid.Text = FormatCurrency(vSaleClass.Invoice.Amountpaid)
    TXTInvoiceNumber.Text = vSaleClass.Invoice.Invoicenumber
End Sub

''
Private Sub LoadSaleLineDetails(pSaleID As Long)
    Dim rsSaleLine As Recordset
    Dim i As Long
    vPragmaticChange = True
    If (OpenRecordset(rsSaleLine, "SELECT * FROM saleLine WHERE saleid=" & pSaleID, dbOpenSnapshot)) Then
        i = 0
        Do While (rsSaleLine.EOF = False)
            DataStore(i).Product = AutoCase(rsSaleLine!Product, True)
            DataStore(i).Description = AutoCase(rsSaleLine!Description, True)
            DataStore(i).NetAmount = FormatCurrency(rsSaleLine!NetAmount)
            DataStore(i).grossAmount = FormatCurrency(rsSaleLine!NetAmount + rsSaleLine!VatAmount)
            
            If (rsSaleLine!Qty > 0) Then
                DataStore(i).UnitCost = DataStore(i).grossAmount / rsSaleLine!Qty
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
'            Select Case rsSaleLine!VatType
'                Case 0
'                    DataStore(i).VAT = rsSaleLine!VatPercent
'                Case 1
'                    DataStore(i).VAT = 0
'                Case 2
'                    DataStore(i).VAT = "Z"
'                Case Else
'            End Select
            
            Call rsSaleLine.MoveNext
            i = i + 1
        Loop
        Call VScroll1_Change
    End If
    vPragmaticChange = False
    Call CalculateTotals
End Sub

''
Private Sub ClearDetails()
    Dim i As Long
    
    vPragmaticChange = True
    TXTInvoiceNumber.Text = ""
    TXTCustomerOrderNumber.Text = ""
    vCustomerid = 0
    
    For i = 0 To TXTProduct.Count - 1
        TXTItemNumber(i).Text = i + 1
        TXTProduct(i).Text = ""
        TXTDescription(i).Text = ""
        TXTUnitCost(i).Text = ""
        TXTQty(i).Text = ""
        TXTVAT(i).Text = ""
        TXTNetAmount(i).Text = FormatCurrency(0)
        TXTGrossAmount(i).Text = FormatCurrency(0)
    Next
    
    TXTGoodsTotal.Text = FormatCurrency(0)
    TXTVatTotal.Text = FormatCurrency(0)
    TXTHandling.Text = FormatCurrency(FRMOptions.DefaultHandlingCharge)
    TXTGrandTotal.Text = FormatCurrency(0)
    TXTAmountPaid.Text = FormatCurrency(0)
    TXTInvoiceComments.Text = FRMOptions.InvoiceComments
'    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer", dbOpenSnapshot)) Then
'        If (rstemp.EOF = False) Then
'            TXTInvoiceComments.Text = rstemp!Message & ""
'        End If
'    End If
    
'    vCustomer.ResetForm
    VScroll1.Value = 0
    vPragmaticChange = False
    
    CMDOK.Caption = "&OK"
    CMDOK.Enabled = True
End Sub

''
Private Function FormatField(pLength As Long) As String
    Dim i As Long
    For i = 0 To pLength
        FormatField = FormatField & "&"
    Next
End Function

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
'                VatPercent = Val(Left$(TXTVAT(i).Text, Len(TXTVAT(i).Text) - 1))
                 VatPercent = Val(TXTVAT(i).Text)
            End If
        
            If (Left$(TXTNetAmount(i).Text, Len(cCurrencySymbol)) = cCurrencySymbol) Then
                If (TXTUnitCost(i).Text <> "" And Left$(TXTGrossAmount(i).Text, Len(cCurrencySymbol)) = cCurrencySymbol) Then
                    ' Calculate from unit cost
                    GoodsTotalItem = RemoveNonNumericCharacters(TXTUnitCost(i).Text) * Val(TXTQty(i).Text)
                    TXTGrossAmount(i).Text = FormatCurrency(GoodsTotalItem / (100) * (100 + VatPercent))
                    TXTNetAmount(i).Text = FormatCurrency(GoodsTotalItem)
                Else
                    ' calculate from gross
                    GoodsTotalItem = RemoveNonNumericCharacters(TXTGrossAmount(i).Text) / (100 + VatPercent) * 100
                    TXTNetAmount(i).Text = FormatCurrency(GoodsTotalItem)
                End If
            Else
                ' calcluate from net
                GoodsTotalItem = RemoveNonNumericCharacters(TXTNetAmount(i).Text) '* Val(TXTQty(i).Text)
                TXTGrossAmount(i).Text = FormatCurrency(GoodsTotalItem / (100) * (100 + VatPercent))
            End If
            
            If (Left$(TXTUnitCost(i).Text, Len(cCurrencySymbol)) = cCurrencySymbol) Then
                If (Val(TXTQty(i).Text) > 0) Then
                    TXTUnitCost(i).Text = FormatCurrency(GoodsTotalItem / Val(TXTQty(i).Text))
                Else
                    TXTUnitCost(i).Text = ""
                End If
            End If
            
            Vattotal = Vattotal + RemoveNonNumericCharacters(TXTNetAmount(i).Text) / 100 * VatPercent
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
            DataStore(TXTItemNumber(i).Text - 1).grossAmount = RemoveNonNumericCharacters(TXTGrossAmount(i).Text)
            DataStore(TXTItemNumber(i).Text - 1).NetAmount = RemoveNonNumericCharacters(TXTNetAmount(i).Text)
'            If (Val(RemoveNonNumericCharacters(TXTVAT(i).Text)) > 0) Then
'                DataStore(TXTItemNumber(i).Text - 1).VatType = 0
'            Else
'                If (TXTVAT(i).Text = "Z") Then
'                    DataStore(TXTItemNumber(i).Text - 1).VatType = 2
'                Else
'                    DataStore(TXTItemNumber(i).Text - 1).VatType = 1
'                End If
'            End If
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
            GoodsTotalItem = DataStore(i).grossAmount / (100 + VatPercent) * 100
            Goodstotal = Goodstotal + GoodsTotalItem
        
        Next
        TXTGoodsTotal.Text = FormatCurrency(Goodstotal)
        TXTVatTotal.Text = FormatCurrency(Vattotal) 'FormatCurrency(GoodsTotal / 100 * cVAT)
        TXTGrandTotal.Text = FormatCurrency(Goodstotal + RemoveNonNumericCharacters(TXTVatTotal.Text) + RemoveNonNumericCharacters(TXTHandling.Text))
        vPragmaticChange = False
    End If
End Sub

''
Private Sub CreateInvoice(pInvoiceType As Long)
    Dim rsInvoice As Recordset
    Dim rsSaleLine As Recordset
'    Dim rsProduct As Recordset
    Dim rsDisclaimer As Recordset
    Dim PaymentClass As New ClassPayment
    Dim OldPaymentTotal As Currency
    Dim Invoiceid As Long
    Dim SaleID As Long
'    Dim TitleID As Long
    Dim DisclaimerID As Long
    Dim i As Long
    Dim Invoicenumber As Long
'    Dim Sql As String
    
    If (vSaleClass.Uid > 0 And vSaleClass.Invoice.Invoicetype = 0) Then
        ' Amend invoice
        
    Else
        If (pInvoiceType <> 1) Then
        
            Invoicenumber = Val(GetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, True))
            vSaleClass.Invoice.Invoicenumber = FRMOptions.InvoiceNumberPreFix & Invoicenumber
            Call SetServerSetting("NEXTINVOICENUMBER-" & FRMOptions.InvoiceNumberPreFix, Invoicenumber + 1)
            
'            If (OpenRecordset(rsInvoice, "SELECT Max(invoicenumber) as test FROM Invoice WHERE InvoiceType=" & pInvoiceType, dbOpenSnapshot)) Then
'                If (rsInvoice.EOF = False) Then
'                    Invoicenumber = Val(RemoveNonNumericCharacters(rsInvoice!test & "")) + 1
'                Else
'                    Invoicenumber = 1
'                End If
'                Call rsInvoice.Close
'            End If
        Else
            ' estimate
            Invoicenumber = Val(GetServerSetting("NEXTESTIMATENUMBER", True))
            vSaleClass.Invoice.Invoicenumber = "E" & Invoicenumber
            Call SetServerSetting("NEXTESTIMATENUMBER", Invoicenumber + 1)
        End If
    End If
    
    vSaleClass.Invoice.Goodstotal = RemoveNonNumericCharacters(TXTGoodsTotal.Text)
    vSaleClass.Invoice.Vattotal = RemoveNonNumericCharacters(TXTVatTotal.Text)
    vSaleClass.Invoice.Handlingtotal = RemoveNonNumericCharacters(TXTHandling.Text)
    vSaleClass.Invoice.Invoicedate = CDate(TXTInvoiceDate.Text)
    OldPaymentTotal = vSaleClass.Invoice.Amountpaid
    vSaleClass.Invoice.Amountpaid = RemoveNonNumericCharacters(TXTAmountPaid.Text)
    
    vSaleClass.Invoice.Duedate = TXTDueDate.Text
    vSaleClass.Invoice.Invoicetype = pInvoiceType
    
    Call vSaleClass.Invoice.SyncRecord
    
    ' IF a payment has been made, log it
    If (vSaleClass.Invoice.Amountpaid > OldPaymentTotal) Then
        ' Log payment
        PaymentClass.Amountpaid = vSaleClass.Invoice.Amountpaid - OldPaymentTotal
        PaymentClass.Paymentdate = CDate(TXTInvoiceDate.Text)
        PaymentClass.Invoiceid = vSaleClass.Invoice.Uid
        Call PaymentClass.CreateRecord
    End If
            
    Call vSaleClass.Customer.SyncRecord
    
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
    vSaleClass.Customerid = vSaleClass.Customer.Uid
    vSaleClass.CustomerOrderNumber = TXTCustomerOrderNumber.Text
    Call vSaleClass.SyncRecord
    SaleID = vSaleClass.Uid
    
    For i = 0 To cMaxInvoiceLines
        If (Len(Trim$(DataStore(i).Product)) > 0) Then
            If (OpenRecordset(rsSaleLine, "SELECT * FROM SaleLine WHERE SaleID=" & SaleID & " AND Product=" & cTextField & Trim$(UCase$(DataStore(i).Product)) & cTextField, dbOpenDynaset)) Then
                If (rsSaleLine.EOF = False) Then
                    'Call rsSaleLine.Edit
                Else
                    Call rsSaleLine.AddNew
                End If
                rsSaleLine!SaleID = SaleID
                rsSaleLine!Product = Trim$(UCase$(DataStore(i).Product))
                rsSaleLine!ProductID = DataStore(i).ProductID
                rsSaleLine!Description = Trim$(UCase$(DataStore(i).Description))
                rsSaleLine!NetAmount = DataStore(i).NetAmount
                rsSaleLine!VatAmount = DataStore(i).grossAmount - DataStore(i).NetAmount
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
'                rsSaleLine!VatType = DataStore(i).VatType
                
                Call rsSaleLine.Update
            End If
            Call rsSaleLine.Close
        End If
    Next
    
    If (CHKDontPrint.Value = vbUnchecked) Then
        Call PrintInvoice("INVOICE", vSaleClass)
        For i = 0 To FRMOptions.InvoiceCopies - 1
            Call PrintInvoice("INVOICE COPY", vSaleClass)
        Next
    End If
            
    Call ClearDetails
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDescriptionExpand_Click(Index As Integer)
    vDescriptionIndex = Index
    vTexteditor.Text = TXTDescription(Index).Text
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
    Call Unload(Me)
End Sub

''
Private Sub CMDOK_Click()
    Call CreateInvoice(FRMOptions.WorkstationIndex)
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    vPragmaticChange = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)
    VScroll1.Max = cMaxInvoiceLines - TXTItemNumber.Count

    TXTInvoiceDate.Text = Format(Now, "dd/mm/yyyy")
    TXTDueDate.Text = Format(DateAdd("d", FRMOptions.DefaultDuePeriod, Now), "dd/mm/yyyy")
    TXTHandling.Text = GetServerSetting("DEFAULTHANDLING", False)
'    Call LoadListCBO(CBOTitle, "SELECT * FROM Title", "title", "UID")

    Set vProduct = New FRMuProductSearch
    Set vTexteditor = New FRMuLargeTextEditor
    Call vProduct.SetParent(Me)
    Call vTexteditor.SetParent(Me)
    vTexteditor.TextFontName = "Arial"
    vTexteditor.TextFontSize = 10
    Call SetupFieldSizes
    Call ClearDetails
    vPragmaticChange = False
    ' Auto show customer search screen
'    Call CMDCustomerSearch_Click
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    If (vParent Is Nothing) Then
    Else
        vParent.Enabled = True
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
Private Sub TXTDescription_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTDescription_KeyPress(Index As Integer, KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
        KeyAscii = 0
    End If
End Sub

''
Private Sub TXTDescription_LostFocus(Index As Integer)
    TXTDescription(Index).Text = AutoCase(TXTDescription(Index).Text, True)
End Sub

''
Private Sub TXTGrossAmount_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTGrossAmount_GotFocus(Index As Integer)
    TXTGrossAmount(Index).Text = Replace(TXTGrossAmount(Index).Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTGrossAmount_LostFocus(Index As Integer)
    TXTGrossAmount(Index).Text = FormatCurrency(TXTGrossAmount(Index).Text)
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
    TXTHandling.Text = FormatCurrency(TXTHandling.Text)
End Sub

Private Sub TXTHandling_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button = 2 And FRMContextMenu.ShowHandlingPopupMenu = True) Then
        Call PopupMenu(FRMContextMenu.MNUHandlingMenu)
    End If
End Sub

''
Private Sub TXTNetAmount_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTNetAmount_GotFocus(Index As Integer)
    TXTNetAmount(Index).Text = Replace(TXTNetAmount(Index).Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTNetAmount_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And Index > 0) Then 'up
        Call TXTNetAmount(Index - 1).SetFocus
    End If
    If (KeyCode = 40 And Index < TXTNetAmount.Count - 1) Then 'down
        Call TXTNetAmount(Index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTNetAmount_LostFocus(Index As Integer)
    TXTNetAmount(Index).Text = FormatCurrency(TXTNetAmount(Index).Text)
End Sub

''
Private Sub TXTProduct_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTProduct_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And Index > 0) Then 'up
        Call TXTProduct(Index - 1).SetFocus
    End If
    If (KeyCode = 40 And Index < TXTProduct.Count - 1) Then 'down
        Call TXTProduct(Index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTProduct_KeyPress(Index As Integer, KeyAscii As Integer)
    If (KeyAscii = 13) Then
        If (Trim$(TXTProduct(Index).Text) <> "") Then
            If (FRMOptions.UseProductDatabase = True) Then
                Set vCurrentActiveChild = vProduct
                vLastProductIndex = Index
                vProduct.ProductName = TXTProduct(Index).Text
                Me.Enabled = False
                If (vProduct.Search()) Then
                    'vNewProduct(Index) = False
                Else
        '            Call Messagebox("Product not found.", vbInformation)
    '                vNewProduct(Index) = True
                    Me.Enabled = True
                    Call TXTDescription(Index).SetFocus
                End If
            Else
                Call TXTDescription(Index).SetFocus
            End If
        Else
            Call TXTDescription(Index).SetFocus
        End If
        KeyAscii = 0
    Else
        If (TXTVAT(Index).Text = "") Then
            TXTVAT(Index).Text = FormatPercent(FRMOptions.DefaultVATPercent)
        End If
    End If
End Sub

''
Private Sub TXTQty_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTQty_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And Index > 0) Then 'up
        Call TXTQty(Index - 1).SetFocus
    End If
    If (KeyCode = 40 And Index < TXTQty.Count - 1) Then 'down
        Call TXTQty(Index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTUnitCost_Change(Index As Integer)
'    If (TXTUnitCost(Index).Text <> "") Then
'        TXTQty(Index).Text = 1
'    End If
    Call CalculateTotals
End Sub

''
Private Sub TXTUnitCost_GotFocus(Index As Integer)
    TXTUnitCost(Index).Text = Replace(TXTUnitCost(Index).Text, cCurrencySymbol, "")
End Sub

''
Private Sub TXTUnitCost_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And Index > 0) Then 'up
        Call TXTUnitCost(Index - 1).SetFocus
    End If
    If (KeyCode = 40 And Index < TXTUnitCost.Count - 1) Then 'down
        Call TXTUnitCost(Index + 1).SetFocus
    End If
End Sub

''
Private Sub TXTUnitCost_LostFocus(Index As Integer)
    If (TXTUnitCost(Index).Text <> "") Then
        TXTUnitCost(Index).Text = FormatCurrency(TXTUnitCost(Index).Text)
    Else
    End If
End Sub

''
Private Sub TXTVAT_Change(Index As Integer)
    Call CalculateTotals
End Sub

''
Private Sub TXTVAT_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 And Index > 0) Then 'up
        Call TXTVAT(Index - 1).SetFocus
    End If
    If (KeyCode = 40 And Index < TXTVAT.Count - 1) Then 'down
        Call TXTVAT(Index + 1).SetFocus
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
        If (DataStore(i + VScroll1.Value).UnitCost <> "") Then
            TXTUnitCost(i).Text = FormatCurrency(Val(DataStore(i + VScroll1.Value).UnitCost))
        Else
            DataStore(i + VScroll1.Value).UnitCost = ""
        End If
        TXTQty(i).Text = DataStore(i + VScroll1.Value).Qty
        If (DataStore(i + VScroll1.Value).VAT <> "") Then
            TXTVAT(i).Text = DataStore(i + VScroll1.Value).VAT
        Else
            TXTVAT(i).Text = ""
        End If
        TXTGrossAmount(i).Text = FormatCurrency(DataStore(i + VScroll1.Value).grossAmount)
        TXTNetAmount(i).Text = FormatCurrency(DataStore(i + VScroll1.Value).NetAmount)
    Next
    vPragmaticChange = False
End Sub

