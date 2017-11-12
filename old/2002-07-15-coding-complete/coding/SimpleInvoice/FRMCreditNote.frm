VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TXTBOX.OCX"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "Flp32x20.ocx"
Begin VB.Form FRMCreditNote 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Credit Note"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   ControlBox      =   0   'False
   HelpContextID   =   9
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin LpLib.fpList GrdLine 
      Height          =   1755
      Left            =   120
      TabIndex        =   0
      ToolTipText     =   "Double click to edit qty"
      Top             =   2940
      Width           =   11535
      _Version        =   131073
      _ExtentX        =   20346
      _ExtentY        =   3096
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   6
      Sorted          =   0
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   1
      SearchMethod    =   0
      VirtualMode     =   0   'False
      VRowCount       =   0
      DataSync        =   3
      ThreeDInsideStyle=   1
      ThreeDInsideHighlightColor=   -2147483633
      ThreeDInsideShadowColor=   -2147483642
      ThreeDInsideWidth=   1
      ThreeDOutsideStyle=   1
      ThreeDOutsideHighlightColor=   16777215
      ThreeDOutsideShadowColor=   -2147483632
      ThreeDOutsideWidth=   1
      ThreeDFrameWidth=   0
      BorderStyle     =   0
      BorderColor     =   -2147483642
      BorderWidth     =   1
      ThreeDOnFocusInvert=   0   'False
      ThreeDFrameColor=   -2147483633
      Appearance      =   0
      BorderDropShadow=   0
      BorderDropShadowColor=   -2147483632
      BorderDropShadowWidth=   3
      ScrollHScale    =   2
      ScrollHInc      =   0
      ColsFrozen      =   0
      ScrollBarV      =   2
      NoIntegralHeight=   0   'False
      HighestPrecedence=   0
      AllowColResize  =   0
      AllowColDragDrop=   0
      ReadOnly        =   0   'False
      VScrollSpecial  =   0   'False
      VScrollSpecialType=   0
      EnableKeyEvents =   -1  'True
      EnableTopChangeEvent=   -1  'True
      DataAutoHeadings=   -1  'True
      DataAutoSizeCols=   2
      SearchIgnoreCase=   -1  'True
      ColDesigner     =   "FRMCreditNote.frx":0000
      ScrollBarH      =   3
      DataFieldList   =   ""
      ColumnEdit      =   0
      ColumnBound     =   0
      Style           =   0
      MaxDrop         =   0
      ListWidth       =   0
      EditHeight      =   0
      GrayAreaColor   =   0
      ListLeftOffset  =   0
      ComboGap        =   0
      MaxEditLen      =   0
      VirtualPageSize =   0
      VirtualPagesAhead=   0
      ExtendCol       =   0
      ColumnLevels    =   1
      ListGrayAreaColor=   -2147483637
      GroupHeaderHeight=   -1
      GroupHeaderShow =   -1  'True
      AllowGrpResize  =   0
      AllowGrpDragDrop=   0
      MergeAdjustView =   0   'False
      ColumnHeaderShow=   -1  'True
      ColumnHeaderHeight=   -1
      GrpsFrozen      =   0
      BorderGrayAreaColor=   -2147483637
      ExtendRow       =   0
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   10560
      TabIndex        =   41
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   9120
      TabIndex        =   40
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDDeleteItem 
      Caption         =   "Delete Item"
      Height          =   315
      Left            =   10080
      TabIndex        =   39
      Top             =   4740
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Customer Search"
      Height          =   375
      Left            =   1440
      TabIndex        =   38
      Top             =   6900
      Width           =   1935
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "<OK>"
      Height          =   375
      Left            =   0
      TabIndex        =   37
      Top             =   6900
      Width           =   1095
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
      Left            =   3600
      TabIndex        =   2
      Top             =   6900
      Width           =   1215
   End
   Begin VB.TextBox TXTInvoiceComments 
      Height          =   1095
      Left            =   1560
      MultiLine       =   -1  'True
      ScrollBars      =   1  'Horizontal
      TabIndex        =   1
      ToolTipText     =   "Any Information entered here will be displayed on the bottom left part of the invoice"
      Top             =   5040
      Width           =   6495
   End
   Begin ELFDateControl.DateControl TXTCreditNoteDate 
      Height          =   615
      Left            =   9600
      TabIndex        =   3
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
      TabIndex        =   4
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
      TabIndex        =   5
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
      TabIndex        =   6
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
      TabIndex        =   7
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
      TabIndex        =   8
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
      TabIndex        =   9
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
      TabIndex        =   10
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
      TabIndex        =   11
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
      TabIndex        =   12
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
      TabIndex        =   13
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
      TabIndex        =   14
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
   Begin ELFTxtBox.TxtBox1 TXTHomeTelephoneNumber 
      Height          =   285
      Left            =   3840
      TabIndex        =   15
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
      TabIndex        =   16
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
      TabIndex        =   17
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
      TabIndex        =   18
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
   Begin ELFTxtBox.TxtBox1 TXTTitle 
      Height          =   315
      Left            =   1440
      TabIndex        =   19
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
   Begin ELFTxtBox.TxtBox1 TXTCustomerOrderNumber 
      Height          =   285
      Left            =   10320
      TabIndex        =   20
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
   Begin ELFTxtBox.TxtBox1 TXTCompanyName 
      Height          =   285
      Left            =   1440
      TabIndex        =   21
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
      TabIndex        =   36
      Top             =   390
      Width           =   1335
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
      TabIndex        =   35
      Top             =   1050
      Width           =   735
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
      TabIndex        =   34
      Top             =   2610
      Width           =   975
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
      TabIndex        =   33
      Top             =   5250
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
      TabIndex        =   32
      Top             =   5550
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
      TabIndex        =   31
      Top             =   5850
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
      TabIndex        =   30
      Top             =   6150
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Credit Date"
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
      TabIndex        =   29
      Top             =   1140
      Width           =   1215
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
      TabIndex        =   28
      Top             =   2610
      Width           =   1215
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
      TabIndex        =   27
      Top             =   30
      Width           =   1335
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
      Left            =   9285
      TabIndex        =   26
      Top             =   6510
      Width           =   1170
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Credit Number"
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
      TabIndex        =   25
      Top             =   150
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Credit Note Comments"
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
      TabIndex        =   24
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
      Left            =   9105
      TabIndex        =   23
      Top             =   510
      Width           =   1110
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
      TabIndex        =   22
      Top             =   750
      Width           =   1335
   End
End
Attribute VB_Name = "FRMCreditNote"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Credit Note Object
''
'' Coded by Dale Pitman

''
Private vIsLoaded As Boolean
Private vCustomerid As Long
Private vLastProductIndex As Long
Private vParent As Form

'' Child forms
Private vProduct As FRMuProductSearch
Private vCustomer As FrmuCustomerSearch
Private vTexteditor As FRMuLargeTextEditor
Private vDescriptionIndex As Long
Private vCreditNoteClass As New ClassCreditNote
Private vSaleClass2 As New ClassSale
Private vrsCreditNote As Recordset

Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    If (vCurrentActiveChild.ChildType = ProductSearch) Then
        ' Product search callback
    Else
        If (vCurrentActiveChild.ChildType = CustomerSearch) Then
            If (vCreditNoteClass.Customer.HasData = True) Then
                'load Details
                Call LoadCustomerDetailsFromClass
                If (vCustomer.CreditNoteID > 0) Then
                    ' Load previous creditnote
                    If (OpenRecordset(vrsCreditNote, "SELECT * FROM CreditNote WHERE UID=" & vCustomer.CreditNoteID, dbOpenSnapshot)) Then
                        If (vrsCreditNote.EOF = False) Then
                        End If
                    End If
                    'vCreditNoteClass.Invoice.Uid = vrsCreditNote!Invoiceid
                    'vSaleClass.Invoice.ReadRecord
                    'vSaleClass.Invoiceid = vSaleClass.Invoice.Uid
                    vCreditNoteClass.Uid = vCustomer.CreditNoteID
                    Call vCreditNoteClass.ReadRecord
                    'Call vSaleClass.Invoice.ReadRecord
                    Call LoadSaleAndInvoiceDetailsFromCreditNoteClass
                    Call LoadSaleLineDetails(vCustomer.CreditNoteID, False)
                    CMDOK.Caption = "Update"
                    CMDOK.Enabled = True
                Else
                    If (vCustomer.SaleID > 0) Then
                        ' Load previous invoice
                        vSaleClass2.Uid = vCustomer.SaleID
                        Call vSaleClass2.ReadRecord
                        Call vSaleClass2.Invoice.ReadRecord
                        Call LoadSaleAndInvoiceDetailsFromSaleClass
                        Call LoadSaleLineDetails(vSaleClass2.Uid, True)
                        CMDOK.Caption = "&OK"
                        CMDOK.Enabled = True
                    Else
                        Call Messagebox("A Invoice must be selected", vbInformation)
                        Call SearchForInvoice
                        CMDOK.Enabled = False
                    End If
                End If
'                Call TXTProduct(0).SetFocus
            Else
                ' close form
                Call Unload(Me)
            End If
        Else
            If (vCurrentActiveChild.ChildType = TextEditor) Then
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

''
Public Function Search(pInvoiceID As Long) As Boolean
    Dim rstemp As Recordset
    Dim rsSaleLine As Recordset
    Dim i As Long
    If (pInvoiceID > 0) Then
            Search = False
    Else
        Call Me.Show
        Call SearchForInvoice
        Search = True
    End If
End Function

Private Sub LoadCustomerDetailsFromClass()
    TXTTitle.Text = vCreditNoteClass.Customer.Title
    TXTName.Text = AutoCase(vCreditNoteClass.Customer.Name, True)
    TXTCompanyName.Text = AutoCase(vCreditNoteClass.Customer.CompanyName, True)
    TXTStreet1.Text = AutoCase(vCreditNoteClass.Customer.Street1, True)
    TXTStreet2.Text = AutoCase(vCreditNoteClass.Customer.Street2, True)
    TXTTown.Text = AutoCase(vCreditNoteClass.Customer.Town, True)
    TXTCounty.Text = AutoCase(vCreditNoteClass.Customer.County, True)
    TXTCountry.Text = AutoCase(vCreditNoteClass.Customer.Country, True)
    TXTHomeTelephoneNumber.Text = vCreditNoteClass.Customer.ContactTelephoneNumber
    TXTPostcode.Text = vCreditNoteClass.Customer.postcode


'    TXTDueDate.Text = Format(DateAdd("d", vSaleClass.Customer.DueDatePeriod, Now), "dd/mm/yyyy")
'    TXTInvoiceDate.Text = rstemp!invoiceDate
'    TXTHandling.Text = FormatCurrency(rstemp!handlingtotal)
'    TXTAmountPaid.Text = FormatCurrency(rstemp!amountpaid)
'    TXTInvoiceNumber.Text = rstemp!InvoiceNumber
End Sub

Private Sub SearchForInvoice()
    Set vCurrentActiveChild = vCustomer
    Me.Enabled = False
    Call vCustomer.Search
End Sub
    


Private Sub LoadSaleAndInvoiceDetailsFromCreditNoteClass()
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE Uid=" & vCreditNoteClass.DisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            TXTInvoiceComments.Text = rstemp!Message & ""
        Else
            TXTInvoiceComments.Text = ""
        End If
    End If
    
    If (vCreditNoteClass.Vatbatchnumber > 0) Then
        CMDOK.Caption = "N/A"
        CMDOK.Enabled = False
    Else
        CMDOK.Caption = "Update"
        CMDOK.Enabled = True
    End If
    
'    TXTDueDate.Text = Format(DateAdd("d", vSaleClass.Invoice.Duedate, Now), "dd/mm/yyyy")
    TXTCreditNoteDate.Text = Format(vCreditNoteClass.Creditnotedate, "dd/mm/yyyy")
    TXTHandling.Text = FormatCurrency(vCreditNoteClass.Handlingtotal)
    TXTAmountPaid.Text = FormatCurrency(vCreditNoteClass.Amountpaid)
    TXTInvoiceNumber.Text = vCreditNoteClass.Creditnotenumber
End Sub

Private Sub LoadSaleAndInvoiceDetailsFromSaleClass()
    Dim rstemp As Recordset
    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer WHERE Uid=" & vCreditNoteClass.DisclaimerID, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            TXTInvoiceComments.Text = rstemp!Message & ""
        Else
            TXTInvoiceComments.Text = ""
        End If
    End If
    
    If (vSaleClass2.Invoice.Vatbatchnumber > 0) Then
        CMDOK.Caption = "N/A"
        CMDOK.Enabled = False
    Else
        CMDOK.Caption = "Update"
        CMDOK.Enabled = True
    End If
    
'    TXTDueDate.Text = Format(DateAdd("d", vSaleClass.Invoice.Duedate, Now), "dd/mm/yyyy")
    TXTCreditNoteDate.Text = Format(vSaleClass2.Invoice.Invoicedate, "dd/mm/yyyy")
    TXTHandling.Text = FormatCurrency(vSaleClass2.Invoice.Handlingtotal)
    TXTAmountPaid.Text = FormatCurrency(vSaleClass2.Invoice.Amountpaid)
    TXTInvoiceNumber.Text = vSaleClass2.Invoice.InvoiceNumber
End Sub

Private Sub LoadSaleLineDetails(pUID As Long, pFromSale As Boolean)
    Dim rsSaleLine As Recordset
    Dim rsCreditNoteLine As Recordset
    Dim VatPercent As String
    Dim SaleLineID As Long
    Dim i As Long
    Call GrdLine.Clear
    If (pFromSale = True) Then
        If (OpenRecordset(rsSaleLine, "SELECT * FROM saleLine WHERE saleid=" & pUID, dbOpenSnapshot)) Then
            i = 0
            Do While (rsSaleLine.EOF = False)
                If (rsSaleLine!VatPercent = -1) Then
                    VatPercent = "Z"
                Else
                    VatPercent = rsSaleLine!VatPercent
                End If
'                Select Case rsSaleLine!VatType
'                    Case 0
'                        VatPercent = rsSaleLine!VatPercent
'                    Case 1
'                        VatPercent = 0
'                    Case 2
'                        VatPercent = "Z"
'                    Case Else
'                End Select
                If (rsSaleLine!Qty > 0) Then
                    Call GrdLine.AddItem(i & vbTab & AutoCase(rsSaleLine!Product, True) & vbTab & AutoCase(rsSaleLine!Description, True) & vbTab & FormatCurrency(rsSaleLine!NetAmount) & vbTab & rsSaleLine!Qty & vbTab & VatPercent)
                Else
                    Call GrdLine.AddItem(i & vbTab & AutoCase(rsSaleLine!Product, True) & vbTab & AutoCase(rsSaleLine!Description, True) & vbTab & FormatCurrency(rsSaleLine!NetAmount) & vbTab & "N/A" & vbTab & VatPercent)
                End If
                Call rsSaleLine.MoveNext
                i = i + 1
            Loop
        End If
    Else
        ' Load from credit note
        If (OpenRecordset(rsCreditNoteLine, "SELECT * FROM CreditNoteLine WHERE CreditNoteID=" & pUID, dbOpenSnapshot)) Then
            If (rsCreditNoteLine.EOF = False) Then
                i = 0
                Do While (rsCreditNoteLine.EOF = False)
                    If (rsCreditNoteLine!VatPercent = -1) Then
                        VatPercent = "Z"
                    Else
                        VatPercent = rsCreditNoteLine!VatPercent
                    End If
'                    Select Case rsCreditNoteLine!VatType
'                        Case 0
'                            VatPercent = rsCreditNoteLine!VatPercent
'                        Case 1
'                            VatPercent = 0
'                        Case 2
'                            VatPercent = "Z"
'                        Case Else
'                    End Select
                    If (rsCreditNoteLine!Qty > 0) Then
                        Call GrdLine.AddItem(i & vbTab & AutoCase(rsCreditNoteLine!Product, True) & vbTab & AutoCase(rsCreditNoteLine!Description, True) & vbTab & FormatCurrency(rsCreditNoteLine!NetAmount) & vbTab & rsCreditNoteLine!Qty & vbTab & VatPercent)
                    Else
                        Call GrdLine.AddItem(i & vbTab & AutoCase(rsCreditNoteLine!Product, True) & vbTab & AutoCase(rsCreditNoteLine!Description, True) & vbTab & FormatCurrency(rsCreditNoteLine!NetAmount) & vbTab & "N/A" & vbTab & VatPercent)
                    End If
                    Call rsCreditNoteLine.MoveNext
                Loop
            End If
        End If
    End If
    Call CalculateTotals
End Sub
''
Private Sub ClearDetails()
    Dim i As Long
'    Dim rstemp As Recordset
    
    
    TXTTitle.Text = ""
    TXTName.Text = ""
    TXTCompanyName.Text = ""
    TXTStreet1.Text = ""
    TXTStreet2.Text = ""
    TXTTown.Text = ""
    TXTCounty.Text = ""
    TXTCountry.Text = ""
    TXTPostcode.Text = ""
    vCustomerid = 0
    
    Call GrdLine.Clear
   
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
    
    CMDOK.Caption = "&OK"
    CMDOK.Enabled = True
    Call vCustomer.ResetForm
End Sub


''
Private Function FormatField(pLength As Long) As String
    Dim i As Long
    For i = 0 To pLength
        FormatField = FormatField & "&"
    Next
End Function

''
Private Sub CalculateTotals()
    Dim i As Long
    Dim Goodstotal As Currency
    Dim GoodsTotalItem As Currency
    Dim Vattotal As Currency
    Dim VatPercent As Double
    Dim Qty As Long
    
    Goodstotal = 0
    Vattotal = 0
    For i = 0 To GrdLine.ListCount - 1
        GrdLine.row = i
        GrdLine.Col = 3
        GoodsTotalItem = GrdLine.ColList
        GrdLine.Col = 4
        If (GrdLine.ColList <> "N/A") Then
            Qty = Val(GrdLine.ColList)
        Else
            Qty = 1
        End If
        GrdLine.Col = 5 'vat
        Goodstotal = Goodstotal + GoodsTotalItem * Qty
        Vattotal = Vattotal + GoodsTotalItem * Qty * Val(GrdLine.ColList) / 100
    Next
    TXTGoodsTotal.Text = FormatCurrency(Goodstotal)
    TXTVatTotal.Text = FormatCurrency(Vattotal)
    TXTGrandTotal.Text = FormatCurrency(Goodstotal + Vattotal + RemoveNonNumericCharacters(TXTHandling.Text))
End Sub

''
Private Sub CreateCreditNote(pInvoiceType As Long)
    Dim rsInvoice As Recordset
    Dim rsSaleLine As Recordset
    Dim rsProduct As Recordset
    Dim rsDisclaimer As Recordset
'    Dim SaleClass As New ClassSale
    Dim PaymentClass As New ClassPayment
    Dim OldPaymentTotal As Currency
    Dim Invoiceid As Long
    Dim SaleID As Long
    Dim TitleID As Long
    Dim DisclaimerID As Long
    Dim i As Long
    Dim InvoiceNumber As Long
    Dim sql As String
    
    If (vCreditNoteClass.Uid > 0 And vCreditNoteClass.Invoicetype = 0) Then
        ' Amend credit note
    Else
        ' attach to invoice
        vCreditNoteClass.Invoiceid = vSaleClass2.Invoice.Uid
        InvoiceNumber = Val(GetServerSetting("NEXTCREDITNOTENUMBER", False))
        vCreditNoteClass.Creditnotenumber = "C" & InvoiceNumber
        Call SetServerSetting("NEXTCREDITNOTENUMBER", InvoiceNumber + 1)
    End If
    
    vCreditNoteClass.Goodstotal = RemoveNonNumericCharacters(TXTGoodsTotal.Text)
    vCreditNoteClass.Vattotal = RemoveNonNumericCharacters(TXTVatTotal.Text)
    vCreditNoteClass.Handlingtotal = RemoveNonNumericCharacters(TXTHandling.Text)
    vCreditNoteClass.Creditnotedate = CDate(TXTCreditNoteDate.Text)
    OldPaymentTotal = vCreditNoteClass.Amountpaid
    vCreditNoteClass.Amountpaid = RemoveNonNumericCharacters(TXTAmountPaid.Text)
    
'    vSaleClass.Invoice.Duedate = TXTDueDate.Text
    vCreditNoteClass.Invoicetype = pInvoiceType
    If (OpenRecordset(rsDisclaimer, "SELECT * FROM Disclaimer WHERE message=" & cTextField & TXTInvoiceComments.Text & cTextField, dbOpenDynaset)) Then
        If (rsDisclaimer.EOF = False) Then
        Else
            Call rsDisclaimer.AddNew
        End If
        DisclaimerID = rsDisclaimer!Uid
        rsDisclaimer!Message = TXTInvoiceComments.Text
        Call rsDisclaimer.Update
    End If
    
    vCreditNoteClass.DisclaimerID = DisclaimerID
    Call vCreditNoteClass.Customer.SyncRecord
'    vCreditNoteClass.Customerid = vCreditNoteClass.Customer.Uid
    vCreditNoteClass.CustomerOrderNumber = TXTCustomerOrderNumber.Text
    
    Call vCreditNoteClass.SyncRecord
    
    ' IF a payment has been made, log it
'    If (vCreditNoteClass.Amountpaid > OldPaymentTotal) Then
'        ' Log payment
'        PaymentClass.Amountpaid = vSaleClass.Invoice.Amountpaid - OldPaymentTotal
'        PaymentClass.Paymentdate = CDate(TXTInvoiceDate.Text)
'        PaymentClass.Invoiceid = vSaleClass.Invoice.Uid
'        Call PaymentClass.CreateRecord
'    End If
            
    
    SaleID = vCreditNoteClass.Uid
    
    For i = 0 To GrdLine.ListCount - 1
        GrdLine.row = i
        GrdLine.Col = 1
        If (Len(Trim$(GrdLine.ColList)) > 0) Then
            If (OpenRecordset(rsSaleLine, "SELECT * FROM Creditnoteline WHERE CreditnoteID=" & SaleID & " AND Product=" & cTextField & Trim$(UCase$(GrdLine.ColList)) & cTextField, dbOpenDynaset)) Then
                If (rsSaleLine.EOF = False) Then
                    'Call rsSaleLine.Edit
                Else
                    Call rsSaleLine.AddNew
                End If
                rsSaleLine!CreditNoteID = SaleID
                rsSaleLine!Product = Trim$(UCase$(GrdLine.ColList))
                GrdLine.Col = 0
                'rsSaleLine!ProductID = DataStore(i).ProductID
                GrdLine.Col = 2
                rsSaleLine!Description = Trim$(UCase$(GrdLine.ColList))
                GrdLine.Col = 3
                rsSaleLine!NetAmount = GrdLine.ColList
                GrdLine.Col = 0
                'rsSaleLine!VatAmount = DataStore(i).grossAmount - DataStore(i).NetAmount
                GrdLine.Col = 4
                If (GrdLine.ColList = "") Then
                    rsSaleLine!Qty = -1
                Else
                    rsSaleLine!Qty = GrdLine.ColList
                End If
                GrdLine.Col = 5
                rsSaleLine!VatPercent = GrdLine.ColList
                'rsSaleLine!VatType = DataStore(i).VatType
                
                Call rsSaleLine.Update
            End If
            Call rsSaleLine.Close
        End If
    Next
    
    
    If (CHKDontPrint.Value = vbUnchecked) Then
'        Call PrintInvoice("INVOICE")
'        For i = 0 To FRMOptions.InvoiceCopies - 1
'            Call PrintInvoice("INVOICE COPY")
'        Next
    End If
            
    Call ClearDetails
    Call vCustomer.ResetForm
    Call SearchForInvoice
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

Private Sub CMDDeleteItem_Click()
    If (GrdLine.ListIndex >= 0) Then
        Call GrdLine.RemoveItem(GrdLine.ListIndex)
        Call CalculateTotals
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub CMDOK_Click()
    Call CreateCreditNote(FRMOptions.WorkstationIndex)
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)

    TXTCreditNoteDate.Text = Format(Now, "dd/mm/yyyy")
'    TXTDueDate.Text = Format(DateAdd("d", FRMOptions.DefaultDuePeriod, Now), "dd/mm/yyyy")
    TXTHandling.Text = GetServerSetting("DEFAULTHANDLING", False)
'    Call LoadListCBO(CBOTitle, "SELECT * FROM Title", "title", "UID")

    Set vCustomer = New FrmuCustomerSearch
    Set vProduct = New FRMuProductSearch
    Set vTexteditor = New FRMuLargeTextEditor
    Call vCustomer.SetParent(Me)
    Call vCustomer.SetCustomerClass(vCreditNoteClass.Customer)
    Call vProduct.SetParent(Me)
    Call vTexteditor.SetParent(Me)
'    Call SetupFieldSizes
    Call ClearDetails
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

Private Sub GrdLine_DblClick()
    Dim NewQty As String
    If (GrdLine.ListIndex >= 0) Then
        NewQty = InputBox("Enter New Qty", "Qty", 0)
        If (Val(NewQty) > 0) Then
            GrdLine.Col = 4
            GrdLine.ColText = NewQty
        End If
    End If
End Sub

Private Sub TXTAmountPaid_Change()
    Call CalculateTotals
End Sub

Private Sub TXTAmountPaid_GotFocus()
    TXTAmountPaid.Text = Replace(TXTAmountPaid.Text, cCurrencySymbol, "")
End Sub

Private Sub TXTAmountPaid_LostFocus()
    TXTAmountPaid.Text = FormatCurrency(TXTAmountPaid.Text)
End Sub

'' Search for customer by - customer number
Private Sub TXTCustomerNumber_KeyPress(KeyAscii As Integer)
    Dim rsCustomer As Recordset
    If (KeyAscii = 13) Then
        If (OpenRecordset(rsCustomer, "SELECT * FROM Customer WHERE UID=" & Val(TXTCustomerNumber.Text), dbOpenSnapshot)) Then
            If (rsCustomer.EOF = False) Then
                vCustomerid = rsCustomer!Uid
                TXTName.Text = rsCustomer!Name
                TXTStreet1.Text = rsCustomer!Street1
                TXTStreet2.Text = rsCustomer!Street2
                TXTTown.Text = rsCustomer!Town
                TXTCounty.Text = rsCustomer!County
                TXTCountry.Text = rsCustomer!Country
                TXTPostcode.Text = rsCustomer!postcode
                TXTHomeTelephoneNumber.Text = rsCustomer!HomeTelephoneNumber
                
            Else
                Call Messagebox("Customer not found.", vbInformation)
            End If
            Call rsCustomer.Close
        End If
        KeyAscii = 0
        Call TXTTitle.SetFocus
    End If
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

'' Validate Postcode
Private Sub TXTPostcode_LostFocus()
    Dim tempstring As String
    tempstring = ValidatePostcode(TXTPostcode.Text)
    If (Left$(tempstring, 5) = "ERROR") Then
        Call Messagebox(tempstring, vbInformation)
    Else
        TXTPostcode.Text = tempstring
    End If
End Sub

