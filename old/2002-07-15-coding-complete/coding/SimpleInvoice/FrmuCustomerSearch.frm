VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FrmuCustomerSearch 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   ControlBox      =   0   'False
   HelpContextID   =   5
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin LpLib.fpList GRDCustomer 
      Height          =   1755
      Left            =   120
      TabIndex        =   16
      Top             =   2820
      Width           =   11535
      _Version        =   196608
      _ExtentX        =   20346
      _ExtentY        =   3096
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      MousePointer    =   0
      Object.TabStop         =   0   'False
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   6
      Sorted          =   0
      LineWidth       =   1
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   0
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
      ScrollBarH      =   3
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
      DataField       =   ""
      OLEDragMode     =   0
      OLEDropMode     =   0
      Redraw          =   -1  'True
      ResizeRowToFont =   0   'False
      TextTipMultiLine=   0
      ColDesigner     =   "FrmuCustomerSearch.frx":0000
   End
   Begin LpLib.fpList GRDInvoice 
      Height          =   1965
      Left            =   120
      TabIndex        =   18
      Top             =   4860
      Width           =   5775
      _Version        =   196608
      _ExtentX        =   10186
      _ExtentY        =   3466
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      MousePointer    =   0
      Object.TabStop         =   0   'False
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   6
      Sorted          =   0
      LineWidth       =   1
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   0
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
      ScrollBarH      =   3
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
      DataField       =   ""
      OLEDragMode     =   0
      OLEDropMode     =   0
      Redraw          =   -1  'True
      ResizeRowToFont =   0   'False
      TextTipMultiLine=   0
      ColDesigner     =   "FrmuCustomerSearch.frx":041B
   End
   Begin LpLib.fpList GRDEstimate 
      Height          =   705
      Left            =   6120
      TabIndex        =   20
      Top             =   4800
      Width           =   5535
      _Version        =   196608
      _ExtentX        =   9763
      _ExtentY        =   1244
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      MousePointer    =   0
      Object.TabStop         =   0   'False
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   4
      Sorted          =   0
      LineWidth       =   1
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   0
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
      ScrollBarH      =   3
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
      DataField       =   ""
      OLEDragMode     =   0
      OLEDropMode     =   0
      Redraw          =   -1  'True
      ResizeRowToFont =   0   'False
      TextTipMultiLine=   0
      ColDesigner     =   "FrmuCustomerSearch.frx":082F
   End
   Begin LpLib.fpList GRDCreditNote 
      Height          =   915
      Left            =   6120
      TabIndex        =   33
      Top             =   5880
      Width           =   5535
      _Version        =   196608
      _ExtentX        =   9763
      _ExtentY        =   1614
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Enabled         =   -1  'True
      MousePointer    =   0
      Object.TabStop         =   0   'False
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   6
      Sorted          =   0
      LineWidth       =   1
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   0
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
      ScrollBarH      =   3
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
      DataField       =   ""
      OLEDragMode     =   0
      OLEDropMode     =   0
      Redraw          =   -1  'True
      ResizeRowToFont =   0   'False
      TextTipMultiLine=   0
      ColDesigner     =   "FrmuCustomerSearch.frx":0BD1
   End
   Begin VB.CommandButton CMDManualCompanyName 
      Caption         =   "M"
      Height          =   255
      Left            =   5760
      TabIndex        =   40
      Top             =   315
      Width           =   255
   End
   Begin VB.CommandButton CMDSave 
      Caption         =   "Save"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   1560
      TabIndex        =   39
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDFindLocation 
      Caption         =   "Find Location"
      Height          =   255
      Left            =   2520
      TabIndex        =   38
      Top             =   2460
      Width           =   1335
   End
   Begin VB.CommandButton CMDShowAll 
      Caption         =   "Show All"
      Height          =   255
      Left            =   10560
      TabIndex        =   37
      Top             =   5520
      Width           =   1095
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   0
      TabIndex        =   14
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   9120
      TabIndex        =   35
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   10560
      TabIndex        =   34
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CheckBox CHKOneOffCustomer 
      Caption         =   "One-off Customer"
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
      Left            =   7080
      TabIndex        =   30
      Top             =   2460
      Width           =   1935
   End
   Begin VB.ComboBox CBOTitle 
      Height          =   315
      Left            =   1440
      Style           =   1  'Simple Combo
      TabIndex        =   1
      Top             =   600
      Width           =   975
   End
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   315
      Left            =   2520
      TabIndex        =   2
      Top             =   600
      Width           =   3135
      _ExtentX        =   5530
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
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet1 
      Height          =   285
      Left            =   1440
      TabIndex        =   3
      Top             =   930
      Width           =   4215
      _ExtentX        =   7435
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
      Left            =   1440
      TabIndex        =   5
      Top             =   1530
      Width           =   4215
      _ExtentX        =   7435
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
      Left            =   1440
      TabIndex        =   6
      Top             =   1830
      Width           =   4215
      _ExtentX        =   7435
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
      Left            =   1440
      TabIndex        =   4
      Top             =   1230
      Width           =   4215
      _ExtentX        =   7435
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
      Left            =   1440
      TabIndex        =   8
      Top             =   2430
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
      Left            =   1440
      TabIndex        =   7
      Top             =   2130
      Width           =   4215
      _ExtentX        =   7435
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
   Begin ELFTxtBox.TxtBox1 TXTContactTelephoneNumber 
      Height          =   285
      Left            =   8400
      TabIndex        =   9
      Top             =   240
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
   Begin ELFTxtBox.TxtBox1 TXTCustomerNumber 
      Height          =   285
      Left            =   1440
      TabIndex        =   21
      Top             =   0
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
   Begin ELFTxtBox.TxtBox1 TXTEmailAddress 
      Height          =   285
      Left            =   8400
      TabIndex        =   10
      Top             =   600
      Width           =   2985
      _ExtentX        =   5265
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
   Begin ELFTxtBox.TxtBox1 TXTWebAddress 
      Height          =   285
      Left            =   8400
      TabIndex        =   11
      Top             =   960
      Visible         =   0   'False
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
   Begin ELFTxtBox.TxtBox1 TXTDueDatePeriod 
      Height          =   285
      Left            =   8400
      TabIndex        =   12
      Top             =   1320
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
      Mask            =   "########"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCompanyName 
      Height          =   285
      Left            =   1440
      TabIndex        =   0
      Top             =   300
      Width           =   4215
      _ExtentX        =   7435
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
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDiscount 
      Height          =   285
      Left            =   8400
      TabIndex        =   13
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
      Text            =   ""
      Mask            =   "########"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDepartment 
      Height          =   285
      Left            =   8400
      TabIndex        =   41
      Top             =   2040
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
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Department"
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
      Left            =   6840
      TabIndex        =   42
      Top             =   2100
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Discount"
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
      Left            =   6840
      TabIndex        =   36
      Top             =   1710
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Credit Notes"
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
      Left            =   6120
      TabIndex        =   32
      Top             =   5700
      Width           =   5535
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
      Index           =   9
      Left            =   0
      TabIndex        =   31
      Top             =   330
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "&1"
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
      Left            =   120
      TabIndex        =   15
      Top             =   2505
      Width           =   255
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Due Date Period"
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
      Left            =   6840
      TabIndex        =   29
      Top             =   1350
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Estimates"
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
      Left            =   6120
      TabIndex        =   19
      Top             =   4620
      Width           =   5535
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Invoice History"
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
      Left            =   120
      TabIndex        =   17
      Top             =   4665
      Width           =   5895
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Web Address"
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
      Left            =   6600
      TabIndex        =   28
      Top             =   990
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Email Address"
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
      Left            =   6600
      TabIndex        =   27
      Top             =   630
      Width           =   1695
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
      TabIndex        =   26
      Top             =   630
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
      TabIndex        =   25
      Top             =   960
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
      TabIndex        =   24
      Top             =   2460
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Contact Phone No."
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
      Left            =   6600
      TabIndex        =   23
      Top             =   270
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "C&ustomer No."
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
      TabIndex        =   22
      Top             =   30
      Width           =   1335
   End
End
Attribute VB_Name = "FrmuCustomerSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Customer Search Class
''
'' Coded by Dale Pitman

'' Output parameters
Private vSaleID As Long
Private vCreditNoteID As Long
Private vSearchType As CustomerSearchENUM

Private vTitleMaxLenght As Long

''
Private vCustomerClass As ClassCustomer
Private vCustomerSearchClass As New ClassCustomer ' Used with customer grid

Private vSearchsaleclass As New ClassSale

''
Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

'' This property indicates if this form is currently visible
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

'' General function to make currently active form visible (if a child is active then that form should be made visible),Hierarchical function
Public Sub SetFormFocus()
    If (Me.Enabled = False) Then
        Call vCurrentActiveChild.SetFormFocus
    Else
        Me.ZOrder
    End If
End Sub

'' Add record in class to list in customer grid
Private Sub WriteToCustomerGrid(ByRef pCustomerClass As ClassCustomer)
    Dim Address As String
    Dim postcode As String
    Dim CompanyName As String
    
    Address = pCustomerClass.Street1
    If (pCustomerClass.Street2 <> "") Then
        Address = Address & ", " & pCustomerClass.Street2
    End If
    If (pCustomerClass.Town <> "") Then
        Address = Address & ", " & pCustomerClass.Town
    End If
    If (pCustomerClass.County <> "") Then
        Address = Address & ", " & pCustomerClass.County
    End If
    Address = AutoCase(Address, True)
    postcode = ValidatePostcode(pCustomerClass.postcode)
    If (Left$(postcode, 5) = "ERROR") Then
        postcode = pCustomerClass.postcode
    End If
    
    If (Right(pCustomerClass.CompanyName, 1) = "²") Then
        TXTCompanyName.AutoCase = False
    Else
        TXTCompanyName.AutoCase = True
    End If
    CompanyName = AutoCase(pCustomerClass.CompanyName, True)
    
    Call GRDCustomer.AddItem(pCustomerClass.Uid & vbTab _
     & CompanyName & vbTab & Address & vbTab _
     & postcode & vbTab _
     & AutoCase(pCustomerClass.Title, True) & " " & AutoCase(pCustomerClass.Name, True) & vbTab _
     & pCustomerClass.ContactTelephoneNumber)
End Sub

'' A simple additional property to indicate form type
Public Property Get ChildType() As ChildTypesENUM
    ChildType = CustomerSearch
End Property

'' Used to attach this form to parent, for callback/context knowledge
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

'' Used to pass customer details
Public Sub SetCustomerClass(pClass As ClassCustomer)
    Set vCustomerClass = pClass
End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    If (vIsLoaded = True) Then
        Call LogEvent("Customer Search Screen, ResetFORM")
        Call ClearDetails
    End If
End Sub

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
End Sub

'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
Public Function Search() As Boolean
    
    Screen.MousePointer = vbHourglass
    Call AllFormsShow(Me)
    Me.Visible = True
    Call TXTCompanyName.SetFocus
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

'' Property used to pass selected sale(invoice)
Public Property Let SaleID(pSaleID As Long)
    vSaleID = pSaleID
End Property
Public Property Get SaleID() As Long
    SaleID = vSaleID
End Property

Public Property Let CreditNoteID(pCreditNoteID As Long)
    vCreditNoteID = pCreditNoteID
End Property
Public Property Get CreditNoteID() As Long
    CreditNoteID = vCreditNoteID
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' Get all field size from customer table, set max length of text boxes
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    
    If (OpenRecordset(rstemp, "Title", dbOpenTable)) Then
        vTitleMaxLenght = GetFieldSize(rstemp, "Title")
    End If
    If (OpenRecordset(rstemp, "Customer", dbOpenTable)) Then
        
        TXTCompanyName.MaxLength = GetFieldSize(rstemp, "companyname")
        
        TXTName.MaxLength = GetFieldSize(rstemp, "name")
        TXTStreet1.MaxLength = GetFieldSize(rstemp, "street1")
        TXTStreet2.MaxLength = GetFieldSize(rstemp, "street2")
        TXTTown.MaxLength = GetFieldSize(rstemp, "town")
        TXTCounty.MaxLength = GetFieldSize(rstemp, "county")
        TXTCountry.MaxLength = GetFieldSize(rstemp, "country")
        TXTPostcode.MaxLength = GetFieldSize(rstemp, "postcode") + 1
        
        TXTContactTelephoneNumber.MaxLength = GetFieldSize(rstemp, "ContactTelephoneNumber")
        TXTEmailAddress.MaxLength = GetFieldSize(rstemp, "EmailAddress")
        TXTDepartment.MaxLength = GetFieldSize(rstemp, "Department")
    End If
End Sub

'' Search for customer records, fill customer grid
Private Sub ShowCustomers()
    Dim Address As String
    Dim i As Long
    
    Screen.MousePointer = vbHourglass
    Call GRDCustomer.Clear
        
    If (BAnd(vSearchType, ByPostcode)) Then
        vCustomerSearchClass.postcode = TXTPostcode.Text
    End If
    If (BAnd(vSearchType, ByHomeTelphoneNumber)) Then
        vCustomerSearchClass.ContactTelephoneNumber = TXTContactTelephoneNumber.Text
    End If
    If (BAnd(vSearchType, ByStreet1)) Then
        vCustomerSearchClass.Street1 = TXTStreet1.Text
    End If
    If (BAnd(vSearchType, BySurname)) Then
        vCustomerSearchClass.Name = TXTName.Text
    End If
    If (BAnd(vSearchType, ByCompanyName)) Then
        vCustomerSearchClass.CompanyName = TXTCompanyName.Text
    End If
    
    If (vCustomerSearchClass.Search(vSearchType) > 0) Then
        i = 0
        Do
            Call WriteToCustomerGrid(vCustomerSearchClass)
            i = i + 1
        Loop While (vCustomerSearchClass.NextRecord() And i < 50)
'        Call vCustomerSearchClass.ClearDetails
    End If
    Screen.MousePointer = vbDefault
End Sub

'' Copy details from customer class to screen (text boxes)
Private Sub ReadCustomerClass(pCustomerClass As ClassCustomer)
    Call SetByItemCBO(CBOTitle, pCustomerClass.Title)
    TXTCustomerNumber.Text = pCustomerClass.Uid
    If (Right(pCustomerClass.CompanyName, 1) = "²") Then
        TXTCompanyName.AutoCase = False
    Else
        TXTCompanyName.AutoCase = True
    End If
    
    TXTCompanyName.Text = AutoCase(pCustomerClass.CompanyName, True)
    
    TXTStreet1.Text = AutoCase(pCustomerClass.Street1, True)
    TXTStreet2.Text = AutoCase(pCustomerClass.Street2, True)
    TXTTown.Text = AutoCase(pCustomerClass.Town, True)
    TXTCounty.Text = AutoCase(pCustomerClass.County, True)
    TXTCountry.Text = AutoCase(pCustomerClass.Country, True)
    CBOTitle.Text = AutoCase(pCustomerClass.Title, True)
    TXTName.Text = AutoCase(pCustomerClass.Name, True)
    TXTPostcode.Text = UCase$(pCustomerClass.postcode)
    
    TXTContactTelephoneNumber.Text = pCustomerClass.ContactTelephoneNumber
    TXTEmailAddress.Text = pCustomerClass.Email
    TXTDueDatePeriod.Text = pCustomerClass.DueDatePeriod
    TXTDiscount.Text = pCustomerClass.PercentageDiscount
    If (pCustomerClass.OneOffCustomer = 1) Then
        CHKOneOffCustomer.Value = vbChecked
    Else
        CHKOneOffCustomer.Value = vbUnchecked
    End If
    TXTDepartment.Text = AutoCase(pCustomerClass.Department, True)
End Sub

'' Copy details from class to screen (customer/sale/credit notes)
Private Sub ReadClass(pCustomerClass As ClassCustomer)
    Dim rstemp As Recordset
    Dim i As Long
    Dim Invoicetype As String
    
    Screen.MousePointer = vbHourglass
    
    Call ReadCustomerClass(pCustomerClass)
    
    ' Look for any invoices/estimates
    Call GRDEstimate.Clear
    Call GRDInvoice.Clear
    Call GRDCreditNote.Clear
    vSaleID = 0
    vSearchsaleclass.Customerid = pCustomerClass.Uid
    If (vSearchsaleclass.Search(ByCustomerID) > 0) Then
        Do
            vSearchsaleclass.Invoice.ReadRecord
            If (vSearchsaleclass.Invoice.Invoicetype = 1) Then
                ' Estimate invoice
                Call GRDEstimate.AddItem(vSearchsaleclass.Uid & vbTab & vSearchsaleclass.Invoice.InvoiceNumber & vbTab & FormatCurrency(vSearchsaleclass.Invoice.Goodstotal + vSearchsaleclass.Invoice.Handlingtotal + vSearchsaleclass.Invoice.Vattotal) & vbTab & Format(vSearchsaleclass.Invoice.Invoicedate, "dd/mm/yyyy"))
            Else
                ' Normal invoice
                Call GRDInvoice.AddItem(vSearchsaleclass.Uid & vbTab & vSearchsaleclass.Invoice.InvoiceNumber & vbTab & FormatCurrency(vSearchsaleclass.Invoice.Goodstotal + vSearchsaleclass.Invoice.Handlingtotal + vSearchsaleclass.Invoice.Vattotal) & vbTab & Format(vSearchsaleclass.Invoice.Invoicedate, "dd/mm/yyyy") & vbTab & vSearchsaleclass.Invoice.Amountpaid & vbTab & vSearchsaleclass.Invoice.Duedate)
                If (OpenRecordset(rstemp, "SELECT * FROM CreditNote WHERE InvoiceID=" & vSearchsaleclass.Invoice.Uid, dbOpenSnapshot)) Then
                    Do While (rstemp.EOF = False)
                        Call GRDCreditNote.AddItem(rstemp!Uid & vbTab & rstemp!Creditnotenumber & vbTab & FormatCurrency(rstemp!Goodstotal + rstemp!Handlingtotal + rstemp!Vattotal) & vbTab & Format(rstemp!Creditnotedate, "dd/mm/yyyy") & vbTab & FormatCurrency(rstemp!Amountpaid))
                        Call rstemp.MoveNext
                    Loop
                End If
            End If
        Loop While (vSearchsaleclass.NextRecord())
    End If
    Screen.MousePointer = vbDefault
End Sub

'' Copy details from screen to customer class
Private Sub WriteClass()
    Call LogEvent("Customer Search (Writedetails) -" & TXTCompanyName.Text)
    vCustomerClass.Street1 = UCase$(TXTStreet1.Text)
    vCustomerClass.Street2 = UCase$(TXTStreet2.Text)
    If (TXTCompanyName.AutoCase = False) Then
        vCustomerClass.CompanyName = TXTCompanyName.Text & "²"
    Else
        vCustomerClass.CompanyName = UCase$(TXTCompanyName.Text)
    End If
    vCustomerClass.Town = UCase$(TXTTown.Text)
    vCustomerClass.County = UCase$(TXTCounty.Text)
    vCustomerClass.Country = UCase$(TXTCountry.Text)
    vCustomerClass.Title = UCase$(CBOTitle.Text)
    vCustomerClass.Name = UCase$(TXTName.Text)
    vCustomerClass.postcode = UCase$(TXTPostcode.Text)
    
    vCustomerClass.ContactTelephoneNumber = TXTContactTelephoneNumber.Text
    vCustomerClass.Email = UCase$(TXTEmailAddress.Text)
    vCustomerClass.DueDatePeriod = Val(TXTDueDatePeriod.Text)
    vCustomerClass.PercentageDiscount = Val(TXTDiscount.Text)
    If (CHKOneOffCustomer.Value = vbChecked) Then
        vCustomerClass.OneOffCustomer = 1
    Else
        vCustomerClass.OneOffCustomer = 0
    End If
    vCustomerClass.Department = UCase$(TXTDepartment.Text)
End Sub

'' reset all class details
Private Sub ClearDetails()
    TXTCustomerNumber.Text = ""
    CBOTitle.Text = ""
    TXTName.Text = ""
    TXTCompanyName.Text = ""
    TXTStreet1.Text = ""
    TXTStreet2.Text = ""
    TXTTown.Text = ""
    TXTCounty.Text = ""
    TXTCountry.Text = ""
    TXTPostcode.Text = ""
    TXTContactTelephoneNumber.Text = ""
    TXTEmailAddress.Text = ""
    TXTWebAddress.Text = ""
    TXTDueDatePeriod.Text = FRMOptions.DefaultDuePeriod
    CHKOneOffCustomer.Value = vbUnchecked
    
    Call GRDCustomer.Clear
    Call GRDInvoice.Clear
    Call GRDEstimate.Clear
    Call GRDCreditNote.Clear
    
    Call vCustomerClass.ClearDetails
    Call vCustomerSearchClass.ClearDetails
    
    TXTCompanyName.AutoCase = True

    vSaleID = 0
    vCreditNoteID = 0
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CBOTitle_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
    Else
        KeyAscii = Asc(UCase$(Chr$(KeyAscii)))
        CBOTitle.Text = Left$(CBOTitle.Text, vTitleMaxLenght)
    End If
End Sub

'' Nice bit of code that works a bit like IE address bar
Private Sub CBOTitle_KeyUp(KeyCode As Integer, Shift As Integer)
    Dim i As Long
    Dim originaltext As String
    Dim length As Long
    If (KeyCode > 28) Then
        originaltext = CBOTitle.Text
        For i = 0 To CBOTitle.ListCount - 1
            If (originaltext = Left$(CBOTitle.List(i), Len(originaltext))) Then
                length = Len(CBOTitle.List(i)) - Len(originaltext)
                CBOTitle.Text = CBOTitle.Text & Right(CBOTitle.List(i), length)
                CBOTitle.SelStart = Len(originaltext)
                CBOTitle.SelLength = length
                Exit For
            End If
        Next
    End If
End Sub

''
Private Sub CBOTitle_LostFocus()
    CBOTitle.Text = AutoCase(CBOTitle.Text, True)
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
    Call TXTCompanyName.SetFocus
End Sub

''
Private Sub CMDExit_Click()
    Call LogEvent("Customer Search Screen, Exit Click")
    Call vCustomerClass.ClearDetails
    Call vParent.SendChildInactive
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

'' Link to multimap web size, passes postcode, displays map in IE
Private Sub CMDFindLocation_Click()
    Dim postcode As String
    postcode = Replace(TXTPostcode.Text, " ", "")
    Call Shell("c:\Program Files\Internet Explorer\IEXPLORE http://uk2.multimap.com/map/browse.cgi?client=europe&=&overviewmap=ap&lang=&width=700&client=europe&addr1=&addr2=&addr3=&pc=" & postcode & "&db=ap&cname=Great+Britain&height=400&coordsys=gb&SUBMIT=Find", vbNormalFocus)
End Sub

''
Private Sub CMDManualCompanyName_Click()
    TXTCompanyName.AutoCase = False
End Sub

'' Transfer details to class, pass control back to parent
Private Sub CMDOK_Click()
    Dim Continue As Boolean
    Call LogEvent("Customer Search (OK)")
    Continue = False
    If (Len(Trim$(TXTCompanyName.Text & TXTName.Text)) = 0) Then
        If (Messagebox("Warning company Name/Name blank, continue ?", vbQuestion + vbYesNo) = vbYes) Then
            Continue = True
        End If
    Else
        Continue = True
    End If
    If (Continue = True) Then
        Call WriteClass
        Call Me.Hide
        Call AllFormsHide(Me)
        Call vParent.SendChildInactive
    End If
End Sub

'' Save customer details, without creating an invoice
Private Sub CMDSave_Click()
    Dim Continue As Boolean
    Continue = False
    If (Len(Trim$(TXTCompanyName.Text & TXTName.Text)) = 0) Then
        If (Messagebox("Warning company Name/Name blank, continue ?", vbQuestion + vbYesNo) = vbYes) Then
            Continue = True
        End If
    Else
        Continue = True
    End If
    If (Continue = True) Then
        Call LogEvent("Customer Search Screen, Save Details Click")
        Call WriteClass
        Call vCustomerClass.SyncRecord
        Call ClearDetails
        Call TXTCompanyName.SetFocus
    End If
End Sub

'' Show all estimates
Private Sub CMDShowAll_Click()
    Dim saleclass As New ClassSale
    Call GRDEstimate.Clear
    saleclass.Invoice.Invoicetype = 1
    If (saleclass.Invoice.Search(ByInvoiceType) > 0) Then
        Do
            Call saleclass.ClearDetails
            saleclass.Invoiceid = saleclass.Invoice.Uid
            Call saleclass.ReadRecord
            ' Estimate invoice
            Call GRDEstimate.AddItem(saleclass.Uid & vbTab & saleclass.Invoice.InvoiceNumber & vbTab & (saleclass.Invoice.Goodstotal + saleclass.Invoice.Handlingtotal + saleclass.Invoice.Vattotal) & vbTab & Format(saleclass.Invoice.Invoicedate, "dd/mm/yyyy"))
        Loop While (saleclass.Invoice.NextRecord())
    End If
   
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    Call LogEvent("Customer Search Screen, Load")
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call LoadListCBO(CBOTitle, "SELECT * FROM Title", "title", "UID", False, False)
    Me.Caption = "Customer Search [" & vParent.Caption & "]"
    Call SetWindowPosition(Me)
    Call SetupFieldSizes
    Call ClearDetails
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub GRDCreditNote_Click()
    If (GRDCreditNote.ListIndex >= 0) Then
        GRDCreditNote.Col = 0
        vCreditNoteID = GRDCreditNote.ColText
    End If
End Sub

''
Private Sub GRDCreditNote_DblClick()
    Call CMDOK_Click
End Sub

'' Copy details from selected item(record) to screen(text boxes)
Private Sub GRDCustomer_Click()
    If (GRDCustomer.ListIndex >= 0) Then
        Call LogEvent("Customer Search Screen, Customer GRD Click")
        Call vCustomerSearchClass.NextRecord(GRDCustomer.ListIndex + 1)
        vCustomerClass.Uid = vCustomerSearchClass.Uid
        Call vCustomerClass.ReadRecord(False)
        Call ReadClass(vCustomerSearchClass)
        vSaleID = 0
    End If
End Sub

''
Private Sub GRDCustomer_DblClick()
    Call CMDOK_Click
End Sub

'' Load estimate, ensure customer details match selected estimate details
Private Sub GRDEstimate_Click()
    Dim saleclass As New ClassSale
    Dim Address As String
    If (GRDEstimate.ListIndex >= 0) Then
        Call LogEvent("Customer Search Screen, Estimate GRD Click")
        GRDEstimate.Col = 0
        vSaleID = GRDEstimate.ColText
        saleclass.Uid = vSaleID
        saleclass.ReadRecord
        vCustomerSearchClass.Uid = saleclass.Customerid
        Call vCustomerSearchClass.Search(ByUid)
    
        Call GRDCustomer.Clear
        
        Call WriteToCustomerGrid(vCustomerSearchClass)
        
        vCustomerClass.Uid = vCustomerSearchClass.Uid
        Call vCustomerClass.ReadRecord(False)
        
        Call ReadCustomerClass(vCustomerSearchClass)
    End If
End Sub

''
Private Sub GRDEstimate_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub GRDInvoice_Click()
    If (GRDInvoice.ListIndex >= 0) Then
        GRDInvoice.Col = 0
        vSearchsaleclass.Uid = GRDInvoice.ColText
        vSearchsaleclass.ReadRecord
        Call vSearchsaleclass.Invoice.ReadRecord
        Call LogEvent("Customer Search Screen, Invoice Click")
        If (vSearchsaleclass.Invoice.Vatbatchnumber > 0) Then
            Call Messagebox("This invoice has been VAT processed.", vbInformation)
            vSaleID = GRDInvoice.ColText
        Else
            vSaleID = GRDInvoice.ColText
        End If
    End If
End Sub

''
Private Sub GRDInvoice_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub TXTCompanyName_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or ByCompanyName
    Call ShowCustomers
End Sub

''
Private Sub TXTContactTelephoneNumber_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or ByHomeTelphoneNumber
    Call ShowCustomers
End Sub

''
Private Sub TXTCustomerNumber_Validate(Cancel As Boolean)
    vCustomerClass.Uid = Val(TXTCustomerNumber.Text)
    If (vCustomerClass.Uid > 0) Then
        If (vCustomerClass.ReadRecord(False)) Then
            Call WriteToCustomerGrid(vCustomerClass)
            Call ReadClass(vCustomerClass)
        End If
    End If
End Sub

''
Private Sub TXTName_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or BySurname
    Call ShowCustomers
End Sub

''
Private Sub TXTPostcode_Validate(Cancel As Boolean)
    Dim Tempstring As String
    Tempstring = ValidatePostcode(TXTPostcode.Text)
    If (Left$(Tempstring, 5) = "ERROR") Then
        Call Messagebox(Tempstring, vbInformation)
        Call TXTPostcode.SetFocus
    Else
        TXTPostcode.Text = Tempstring
        vSearchType = vSearchType Or ByPostcode
        Call ShowCustomers
        Call TXTContactTelephoneNumber.SetFocus
    End If
End Sub

''
Private Sub TXTStreet1_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or ByStreet1
    Call ShowCustomers
End Sub

