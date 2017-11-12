VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#11.0#0"; "TxtBox.ocx"
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
      Height          =   1335
      Left            =   120
      TabIndex        =   13
      Top             =   2940
      Width           =   11535
      _Version        =   196608
      _ExtentX        =   20346
      _ExtentY        =   2355
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
      Object.TabStop         =   -1  'True
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
   Begin LpLib.fpList GRDVehicle 
      Height          =   915
      Left            =   120
      TabIndex        =   15
      Top             =   4440
      Width           =   7575
      _Version        =   196608
      _ExtentX        =   13361
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
      ColDesigner     =   "FrmuCustomerSearch.frx":0413
   End
   Begin LpLib.fpList GRDJob 
      Height          =   1125
      Left            =   120
      TabIndex        =   17
      Top             =   5700
      Width           =   7935
      _Version        =   196608
      _ExtentX        =   13996
      _ExtentY        =   1984
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
      Object.TabStop         =   -1  'True
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Columns         =   5
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
      ColDesigner     =   "FrmuCustomerSearch.frx":0808
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   0
      TabIndex        =   11
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   9120
      TabIndex        =   27
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   10560
      TabIndex        =   26
      Top             =   6900
      Width           =   1095
   End
   Begin VB.ComboBox CBOTitle 
      Height          =   315
      Left            =   1440
      Style           =   1  'Simple Combo
      TabIndex        =   1
      Top             =   600
      Width           =   615
   End
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   315
      Left            =   3480
      TabIndex        =   2
      Top             =   600
      Width           =   2175
      _ExtentX        =   3836
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
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet1 
      Height          =   285
      Left            =   1440
      TabIndex        =   3
      Top             =   945
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTown 
      Height          =   285
      Left            =   1440
      TabIndex        =   5
      Top             =   1545
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCounty 
      Height          =   285
      Left            =   1440
      TabIndex        =   6
      Top             =   1845
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet2 
      Height          =   285
      Left            =   1440
      TabIndex        =   4
      Top             =   1245
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPostcode 
      Height          =   285
      Left            =   1440
      TabIndex        =   8
      Top             =   2445
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCountry 
      Height          =   285
      Left            =   1440
      TabIndex        =   7
      Top             =   2145
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPhoneNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   9
      Top             =   0
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCustomerNumber 
      Height          =   285
      Left            =   1440
      TabIndex        =   18
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTEmailAddress 
      Height          =   285
      Left            =   8040
      TabIndex        =   10
      Top             =   1860
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTFaxNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   28
      Top             =   300
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTMobileNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   30
      Top             =   600
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPrivateNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   32
      Top             =   900
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDrivingLicenceNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   34
      Top             =   1260
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVATNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   36
      Top             =   1560
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
      NavigationMode  =   0
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTRegistration 
      Height          =   285
      Left            =   8040
      TabIndex        =   38
      Top             =   2220
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTJobNumber 
      Height          =   285
      Left            =   8040
      TabIndex        =   40
      Top             =   2580
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Title"
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
      Left            =   720
      TabIndex        =   42
      Top             =   630
      Width           =   615
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
      Index           =   7
      Left            =   6240
      TabIndex        =   41
      Top             =   2610
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Registration"
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
      Left            =   6240
      TabIndex        =   39
      Top             =   2250
      Width           =   1695
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
      Index           =   17
      Left            =   6240
      TabIndex        =   37
      Top             =   1590
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Drivering Licence No"
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
      Left            =   6030
      TabIndex        =   35
      Top             =   1290
      Width           =   1905
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Private Number"
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
      Left            =   6240
      TabIndex        =   33
      Top             =   930
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Mobile Number"
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
      Left            =   6240
      TabIndex        =   31
      Top             =   630
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Fax Number"
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
      Left            =   6240
      TabIndex        =   29
      Top             =   330
      Width           =   1695
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
      TabIndex        =   25
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
      TabIndex        =   12
      Top             =   2700
      Width           =   255
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Jobs"
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
      Left            =   120
      TabIndex        =   16
      Top             =   5520
      Width           =   7935
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Vehicles"
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
      TabIndex        =   14
      Top             =   4260
      Width           =   7935
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
      Left            =   6240
      TabIndex        =   24
      Top             =   1890
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
      Left            =   2040
      TabIndex        =   23
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
      TabIndex        =   22
      Top             =   975
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
      TabIndex        =   21
      Top             =   2475
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Phone Number"
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
      Left            =   6240
      TabIndex        =   20
      Top             =   30
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
      TabIndex        =   19
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

'' Search criteria(Input Parameters)

'' Output parameters
'Private vInvoiceID As Long
'Private vEstimateID As Long
Private vSaleID As Long
Private vCreditNoteID As Long
Private vSearchType As CustomerSearchENUM

''
'Private vShiftStatus As Boolean ' True=down
Private vCustomerClass As ClassCustomer
Private vJobClass As ClassJOB

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

'' A simple additional property to indicate form type
Public Property Get ChildType() As ChildTypesENUM
    ChildType = CustomerSearch
End Property

'' Used to attach this form to parent, for callback/context knowledge
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

Public Sub SetJobClass(pClass As ClassJOB)
    Set vJobClass = pClass
    Set vCustomerClass = pClass.Vehicle.Customer
End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    If (vIsLoaded = True) Then
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
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures


'Public Property Let SaleID(pSaleID As Long)
'    vSaleID = pSaleID
'End Property
'Public Property Get SaleID() As Long
'    SaleID = vSaleID
'End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
    If (OpenRecordset(rstemp, "Title", dbOpenTable)) Then
'        cbotitle.mask= formatfield(GetFieldIndex(rstemp,"Title"))
    End If
    If (OpenRecordset(rstemp, "Customer", dbOpenTable)) Then
        TXTName.MaxLength = GetFieldSize(rstemp, "name")
        TXTStreet1.MaxLength = GetFieldSize(rstemp, "street1")
        TXTStreet2.MaxLength = GetFieldSize(rstemp, "street2")
        TXTTown.MaxLength = GetFieldSize(rstemp, "town")
        TXTCounty.MaxLength = GetFieldSize(rstemp, "county")
        TXTCountry.MaxLength = GetFieldSize(rstemp, "country")
        TXTPostcode.MaxLength = GetFieldSize(rstemp, "postcode") + 1
    End If
End Sub

''
Private Sub ShowCustomers()
    Dim address As String
    Dim i As Long
    
    Screen.MousePointer = vbHourglass
    Call GRDCustomer.Clear
        
    If (BAnd(vSearchType, ByPostcode)) Then
        vCustomerClass.Postcode = TXTPostcode.Text
    End If
    If (BAnd(vSearchType, ByHomeTelphoneNumber)) Then
        vCustomerClass.ContactTelephoneNumber = TXTPhoneNumber.Text
    End If
    If (BAnd(vSearchType, ByStreet1)) Then
        vCustomerClass.Street1 = TXTStreet1.Text
    End If
    If (BAnd(vSearchType, BySurname)) Then
        vCustomerClass.Name = TXTName.Text
    End If
    If (BAnd(vSearchType, ByCompanyName)) Then
        vCustomerClass.CompanyName = TXTCompanyName.Text
    End If
    
    If (vCustomerClass.Search(vSearchType) > 0) Then
        i = 0
        Do
            address = vCustomerClass.Street1
            If (vCustomerClass.Street2 <> "") Then
                address = address & "," & vCustomerClass.Street2
            End If
            If (vCustomerClass.Town <> "") Then
                address = address & "," & vCustomerClass.Town
            End If
            If (vCustomerClass.County <> "") Then
                address = address & "," & vCustomerClass.County
            End If
            Call GRDCustomer.AddItem(vCustomerClass.Uid & vbTab _
             & vCustomerClass.Title & " " & vCustomerClass.Name & vbTab & vCustomerClass.CompanyName & vbTab & address _
             & vbTab & vCustomerClass.ContactTelephoneNumber & vbTab & vCustomerClass.Postcode)
            i = i + 1
            
        Loop While (vCustomerClass.NextRecord() And i < 50)
        Call vCustomerClass.ClearDetails
    End If
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub ReadClass()
    Dim rstemp As Recordset
    Dim i As Long
    Dim Invoicetype As String
    
    Screen.MousePointer = vbHourglass
    
    Call SetByItemCBO(CBOTitle, vCustomerClass.Title)
    TXTCustomerNumber.Text = vCustomerClass.Uid
    TXTCompanyName.Text = vCustomerClass.CompanyName
    TXTStreet1.Text = vCustomerClass.Street1
    TXTStreet2.Text = vCustomerClass.Street2
    TXTTown.Text = vCustomerClass.Town
    TXTCounty.Text = vCustomerClass.County
    TXTCountry.Text = vCustomerClass.Country
    CBOTitle.Text = vCustomerClass.Title
    TXTName.Text = vCustomerClass.Name
    TXTPostcode.Text = vCustomerClass.Postcode
    
    TXTPhoneNumber.Text = vCustomerClass.ContactTelephoneNumber
    TXTFaxNumber.Text = vCustomerClass.Faxnumber
    TXTMobileNumber.Text = vCustomerClass.Contactmobilenumber
    TXTPrivateNumber.Text = vCustomerClass.Contactprivatenumber
    TXTDrivingLicenceNumber.Text = vCustomerClass.Drivinglicencenumber
    TXTVATNumber.Text = vCustomerClass.Vatnumber
    TXTEmailAddress.Text = vCustomerClass.Emailaddress
    
    'search Vehicle
    Call GRDVehicle.Clear
    If (vJobClass.Vehicle.Search(ByCustomerID) > 0) Then
        i = 0
        Do
            Call GRDVehicle.AddItem(vJobClass.Vehicle.Uid & vbTab _
             & vJobClass.Vehicle.Reg & vbTab & vJobClass.Vehicle.Make & vbTab & vJobClass.Vehicle.Model _
             & vbTab & vJobClass.Vehicle.Colour & vbTab & vJobClass.Vehicle.Year)
            i = i + 1
            
        Loop While (vJobClass.Vehicle.NextRecord()) ' And i < 50)
        
    End If
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub ReadVehicleClass()
    Dim rstemp As Recordset
    Dim i As Long
    Dim Invoicetype As String
    
    Screen.MousePointer = vbHourglass
    
    TXTRegistration.Text = vJobClass.Vehicle.Reg
    
    'search job
    Call GRDJob.Clear
    If (vJobClass.Search(ByVehicleID) > 0) Then
        i = 0
        Do
            Call GRDJob.AddItem(vJobClass.Uid & vbTab & vJobClass.Uid & vbTab & vJobClass.Startdate & vbTab & vJobClass.Completedate & vbTab & "status")
            i = i + 1
            
        Loop While (vJobClass.NextRecord()) ' And i < 50)
        
    End If
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub ReadjobClass()
    Dim rstemp As Recordset
    Dim i As Long
    Dim Invoicetype As String
    
    Screen.MousePointer = vbHourglass
    
    TXTJobNumber.Text = vJobClass.Uid
    
    'search job
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub WriteClass()
'    Call SetByItemCBO(CBOTitle, vCustomerClass.Title)
'    vCustomerClass.Uid=TXTCustomerNumber.Text
    vCustomerClass.Street1 = TXTStreet1.Text
    vCustomerClass.Street2 = TXTStreet2.Text
    vCustomerClass.CompanyName = TXTCompanyName.Text
    vCustomerClass.Town = TXTTown.Text
    vCustomerClass.County = TXTCounty.Text
    vCustomerClass.Country = TXTCountry.Text
    vCustomerClass.Title = CBOTitle.Text
    vCustomerClass.Name = TXTName.Text
    vCustomerClass.Postcode = TXTPostcode.Text
    
    vCustomerClass.ContactTelephoneNumber = TXTPhoneNumber.Text
    vCustomerClass.Faxnumber = TXTFaxNumber.Text
    vCustomerClass.Contactmobilenumber = TXTMobileNumber.Text
    vCustomerClass.Contactprivatenumber = TXTPrivateNumber.Text
    vCustomerClass.Drivinglicencenumber = TXTDrivingLicenceNumber.Text
    vCustomerClass.Vatnumber = TXTVATNumber.Text
    vCustomerClass.Emailaddress = TXTEmailAddress.Text
    
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
    
    
    TXTPhoneNumber.Text = ""
    TXTFaxNumber.Text = ""
    TXTMobileNumber.Text = ""
    TXTPrivateNumber.Text = ""
    TXTDrivingLicenceNumber.Text = ""
    TXTVATNumber.Text = ""
    TXTEmailAddress.Text = ""
    
    TXTRegistration.Text = ""
    TXTJobNumber.Text = ""
    
    Call GRDCustomer.Clear
    Call GRDVehicle.Clear
    Call GRDJob.Clear
    
    Set vCustomerClass = vJobClass.Vehicle.Customer
    Call vJobClass.Vehicle.ClearDetails
    Call vCustomerClass.ClearDetails
    Call vJobClass.ClearDetails
End Sub



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CBOTitle_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
    Else
        KeyAscii = Asc(UCase$(Chr$(KeyAscii)))
    End If
End Sub

''
Private Sub CBOTitle_KeyUp(KeyCode As Integer, Shift As Integer)
    Dim i As Long
    Dim originaltext As String
    Dim Length As Long
    If (KeyCode > 28) Then
        originaltext = CBOTitle.Text
        For i = 0 To CBOTitle.ListCount - 1
            If (originaltext = Left$(CBOTitle.List(i), Len(originaltext))) Then
                Length = Len(CBOTitle.List(i)) - Len(originaltext)
                CBOTitle.Text = CBOTitle.Text & Right(CBOTitle.List(i), Length)
                CBOTitle.SelStart = Len(originaltext)
                CBOTitle.SelLength = Length
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
End Sub

''
Private Sub CMDExit_Click()
    Call vCustomerClass.ClearDetails
    Call vParent.SendChildInactive
'    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

''
Private Sub CMDOK_Click()
'    vIsLoaded = False
    Call WriteClass
    Call Me.Hide
    Call AllFormsHide(Me)
    Call vParent.SendChildInactive
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
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
Private Sub GRDCreditNote_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub GRDCustomer_Click()
    If (GRDCustomer.ListIndex >= 0) Then
        Call vCustomerClass.NextRecord(GRDCustomer.ListIndex + 1)
        Call ReadClass
    End If
End Sub

''
Private Sub GRDCustomer_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub GRDEstimate_DblClick()
    Call CMDOK_Click
End Sub

''
Private Sub GRDInvoice_DblClick()
    Call CMDOK_Click
End Sub

Private Sub GRDJob_Click()
    If (GRDJob.ListIndex >= 0) Then
        Call vJobClass.NextRecord(GRDJob.ListIndex + 1)
        Call ReadjobClass
    End If
End Sub

Private Sub GRDVehicle_Click()
    If (GRDVehicle.ListIndex >= 0) Then
        Call vJobClass.Vehicle.NextRecord(GRDVehicle.ListIndex + 1)
        Call ReadVehicleClass
    End If
End Sub

''
Private Sub TXTCompanyName_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or ByCompanyName
    Call ShowCustomers
End Sub

''
Private Sub TXTContactTelephoneNumber_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
'        vCustomerClass.ContactTelephoneNumber = TXTContactTelephoneNumber.Text
        vSearchType = vSearchType Or ByHomeTelphoneNumber
        Call ShowCustomers
        Call TXTEmailAddress.SetFocus
        KeyAscii = 0
    End If
End Sub

''
Private Sub TXTCustomerNumber_KeyPress(KeyAscii As Integer)
    Dim address As String
    If (KeyAscii = 13) Then
        vCustomerClass.Uid = Val(TXTCustomerNumber.Text)
        If (vCustomerClass.ReadRecord()) Then
            address = vCustomerClass.Street1
            If (vCustomerClass.Street2 <> "") Then
                address = address & "," & vCustomerClass.Street2
            End If
            If (vCustomerClass.Town <> "") Then
                address = address & "," & vCustomerClass.Town
            End If
            If (vCustomerClass.County <> "") Then
                address = address & "," & vCustomerClass.County
            End If
            Call GRDCustomer.AddItem(vCustomerClass.Uid & vbTab _
             & vCustomerClass.Title & " " & vCustomerClass.Name & vbTab & vCustomerClass.CompanyName & vbTab & address _
             & vbTab & vCustomerClass.ContactTelephoneNumber & vbTab & vCustomerClass.Postcode)
            Call ReadClass
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
        Call TXTPhoneNumber.SetFocus
    End If
End Sub

''
Private Sub TXTStreet1_Validate(Cancel As Boolean)
    vSearchType = vSearchType Or ByStreet1
    Call ShowCustomers
End Sub

