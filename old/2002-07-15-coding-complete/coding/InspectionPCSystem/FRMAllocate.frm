VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#12.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMAllocate 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   7095
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9420
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   473
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   628
   Begin LpLib.fpList GRDAdditional 
      CausesValidation=   0   'False
      Height          =   1125
      Left            =   0
      TabIndex        =   37
      Top             =   4560
      Width           =   6975
      _Version        =   196608
      _ExtentX        =   12303
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
      ColDesigner     =   "FRMAllocate.frx":0000
   End
   Begin LpLib.fpList GRDParts 
      CausesValidation=   0   'False
      Height          =   2175
      Left            =   0
      TabIndex        =   8
      Top             =   1080
      Width           =   9375
      _Version        =   196608
      _ExtentX        =   16536
      _ExtentY        =   3836
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
      Columns         =   9
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
      ColDesigner     =   "FRMAllocate.frx":03CF
   End
   Begin VB.ComboBox CBOAdditional 
      Height          =   315
      Left            =   1200
      Style           =   2  'Dropdown List
      TabIndex        =   38
      Top             =   3840
      Width           =   2895
   End
   Begin VB.TextBox TXTPanel 
      Height          =   285
      Left            =   4320
      TabIndex        =   21
      Top             =   660
      Width           =   495
   End
   Begin VB.TextBox TXTDummy 
      Height          =   285
      Left            =   4920
      TabIndex        =   6
      Top             =   660
      Width           =   255
   End
   Begin VB.ComboBox CBOOperation 
      Height          =   315
      Left            =   1080
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   300
      Width           =   2895
   End
   Begin VB.CommandButton CMDAddNew 
      Caption         =   "<Add New>"
      Height          =   375
      Left            =   0
      TabIndex        =   9
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   5400
      TabIndex        =   10
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   6840
      TabIndex        =   11
      Top             =   6720
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   8280
      TabIndex        =   12
      Top             =   6720
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTPartCode 
      Height          =   285
      Left            =   1080
      TabIndex        =   0
      Top             =   0
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
   Begin ELFTxtBox.TxtBox1 TXTtotalRefit 
      Height          =   285
      Left            =   4440
      TabIndex        =   3
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTotalRepair 
      Height          =   285
      Left            =   5760
      TabIndex        =   4
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTotalPaint 
      Height          =   285
      Left            =   6960
      TabIndex        =   5
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDescription 
      Height          =   285
      Left            =   3240
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   0
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   503
      BackColor       =   12632256
      Enabled         =   0   'False
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
   Begin ELFTxtBox.TxtBox1 TXTLabourRate 
      Height          =   285
      Left            =   1320
      TabIndex        =   7
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTRefit 
      Height          =   285
      Left            =   600
      TabIndex        =   22
      Top             =   660
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTRepair 
      Height          =   285
      Left            =   1920
      TabIndex        =   23
      Top             =   660
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPaint 
      Height          =   285
      Left            =   3120
      TabIndex        =   24
      Top             =   660
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTotalPanel 
      Height          =   285
      Left            =   8160
      TabIndex        =   29
      Top             =   3300
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPartTotal 
      Height          =   285
      Left            =   8640
      TabIndex        =   31
      Top             =   5340
      Width           =   735
      _ExtentX        =   1296
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
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTRecoveryTotal 
      Height          =   285
      Left            =   8640
      TabIndex        =   33
      Top             =   5700
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTAdditionalTotal 
      Height          =   285
      Left            =   8640
      TabIndex        =   35
      Top             =   6060
      Width           =   735
      _ExtentX        =   1296
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
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TxtBox14 
      Height          =   285
      Left            =   4920
      TabIndex        =   40
      Top             =   3840
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTLabourTotal 
      Height          =   285
      Left            =   8640
      TabIndex        =   42
      Top             =   4980
      Width           =   735
      _ExtentX        =   1296
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
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTAdditionalDescription 
      Height          =   285
      Left            =   1200
      TabIndex        =   44
      TabStop         =   0   'False
      Top             =   4200
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   503
      BackColor       =   12632256
      Enabled         =   0   'False
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
      Caption         =   "Description"
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
      Left            =   120
      TabIndex        =   45
      Top             =   4200
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Labour Cost"
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
      Left            =   7080
      TabIndex        =   43
      Top             =   4980
      Width           =   1455
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Cost"
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
      Left            =   4200
      TabIndex        =   41
      Top             =   3840
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Additional"
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
      Left            =   120
      TabIndex        =   39
      Top             =   3840
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Additional Cost"
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
      Left            =   6840
      TabIndex        =   36
      Top             =   6060
      Width           =   1695
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Recovery Cost"
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
      Left            =   6960
      TabIndex        =   34
      Top             =   5700
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Paint Cost"
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
      Left            =   7320
      TabIndex        =   32
      Top             =   5340
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "Total Times -"
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
      Left            =   2400
      TabIndex        =   30
      Top             =   3300
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Panel"
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
      Left            =   3600
      TabIndex        =   28
      Top             =   660
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Paint"
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
      Left            =   2400
      TabIndex        =   27
      Top             =   660
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Repair"
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
      Left            =   1200
      TabIndex        =   26
      Top             =   660
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Refit"
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
      Left            =   0
      TabIndex        =   25
      Top             =   660
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Labour Rate"
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
      TabIndex        =   20
      Top             =   3300
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Part Code"
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
      Left            =   0
      TabIndex        =   19
      Top             =   0
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Refit"
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
      Left            =   3840
      TabIndex        =   18
      Top             =   3300
      Width           =   495
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Repair"
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
      Left            =   5040
      TabIndex        =   17
      Top             =   3300
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Paint"
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
      TabIndex        =   16
      Top             =   3300
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Panel"
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
      Left            =   7440
      TabIndex        =   15
      Top             =   3300
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Description"
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
      Left            =   2160
      TabIndex        =   14
      Top             =   0
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Operation"
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
      Left            =   0
      TabIndex        =   13
      Top             =   300
      Width           =   975
   End
End
Attribute VB_Name = "FRMAllocate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' <Sample> Object
''
'' Coded by Dale Pitman - PyroDesign

Private vAllocateID As Long
Private vPartCodeID As Long
Private vEditRow As Long

Private vAllocateAdditionalID As Long
Private vAdditionalID As Long
Private vEditRowAdditional As Long
'' Search criteria(Input Parameters)


'' Output parameters
'Private vPartid As Long ' *This is a sample parameter


''
'Private vShiftStatus As Boolean ' True=down

''
'Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

Private vDataChanged As Boolean


Private vPartCode As New ClassPartCode
Private vPartCodeSearch As New FRMuPartCodeSearch
Private vAllocate As New ClassAllocate

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
'    ChildType =
End Property

'' Used to attach this form to parent, for callback/context knowledge
'Public Sub SetParent(pform As Form)
'    Set vParent = pform
'End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    Call ClearDetails
End Sub

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
    If (vCurrentActiveChild.ChildType = PartCodeSearch) Then
        If (vPartCode.Uid > 0) Then
            ' part found
            vPartCodeID = vPartCode.Uid

            TXTPartCode.Text = vPartCode.Code
            TXTDescription.Text = vPartCode.Name
            Call CBOOperation.SetFocus
        Else
            TXTPartCode.SetFocus
        End If
    End If
End Sub

'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
Public Function Search() As Boolean
    Dim i As Long
    
    vAllocate.Jobid = 1
    Call vAllocate.ReadRecord
    If (vAllocate.MaxIndex > 0) Then
        For i = 0 To vAllocate.MaxIndex - 1
            vAllocate.Index = i
            If (vAllocate.Deleted = False) Then
                Call GRDParts.AddItem(vAllocate.Uid & vbTab & vAllocate.PartCode.Uid & vbTab & vAllocate.PartCode.Code & vbTab & vAllocate.PartCode.Name & vbTab & OperationNameByID(vAllocate.Operation) & vbTab & vAllocate.Refittime & vbTab & vAllocate.Repairtime & vbTab & vAllocate.Painttime & vbTab & vAllocate.Paneltime)
            End If
        Next
    End If
    Call CalculateTotals
    
    Screen.MousePointer = vbHourglass
    Call AllFormsShow(Me)
    Me.Visible = True
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

Private Sub ClearPartDetails()
    vAllocateID = -1
    vPartCodeID = -1
    vEditRow = -1
    TXTPartCode.Text = ""
    TXTDescription.Text = ""
    CBOOperation.ListIndex = 0
    TXTRefit.Text = ""
    TXTRepair.Text = ""
    TXTPaint.Text = ""
    TXTPanel.Text = ""
    Call TXTPartCode.SetFocus
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

Public Sub AllocateClass(pAllocate As ClassAllocate)
    Set vAllocate = pAllocate
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
    Dim rstemp As Recordset
    Dim VatPercent As String
    Dim NetCost As String
    Dim SaveIndex As Long
    
'    Call ClearPartDetails
    
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
'    If (OpenRecordset(rstemp, "Employee", dbOpenTable)) Then
'        TXTName.MaxLength = GetFieldSize(rstemp, "name")
'        TXTShortName.MaxLength = GetFieldSize(rstemp, "shortname")
'    End If
End Sub

Private Sub AddUpdateGrid()
    Select Case CBOOperation.Text
        Case "New"
            TXTRepair.Text = ""
        Case "Repair"
            TXTPanel.Text = ""
        Case "Paint"
            TXTRepair.Text = ""
            TXTPanel.Text = ""
        Case "Refit"
            TXTRepair.Text = ""
            TXTPaint.Text = ""
            TXTPanel.Text = ""
    End Select
    
    If (vEditRow > -1) Then
        ' Update
        GRDParts.row = vEditRow
        GRDParts.List = vAllocateID & vbTab & vPartCodeID & vbTab & TXTPartCode.Text & vbTab & TXTDescription.Text & vbTab & CBOOperation.Text & vbTab & TXTRefit.Text & vbTab & TXTRepair.Text & vbTab & TXTPaint.Text & vbTab & TXTPanel.Text
        
    Else
        ' Add new
        Call GRDParts.AddItem(vAllocateID & vbTab & vPartCodeID & vbTab & TXTPartCode.Text & vbTab & TXTDescription.Text & vbTab & CBOOperation.Text & vbTab & TXTRefit.Text & vbTab & TXTRepair.Text & vbTab & TXTPaint.Text & vbTab & TXTPanel.Text)
    End If
    Call ClearPartDetails
'    Call TXTPartCode.SetFocus
    Call CalculateTotals
End Sub

Private Sub AddUpdateAdditionalGrid()
    If (vEditRowAdditional > -1) Then
        ' Update
        GRDParts.row = vEditRow
        GRDParts.List = vAllocateID & vbTab & vPartCodeID & vbTab & TXTPartCode.Text & vbTab & TXTDescription.Text & vbTab & CBOOperation.Text & vbTab & TXTRefit.Text & vbTab & TXTRepair.Text & vbTab & TXTPaint.Text & vbTab & TXTPanel.Text
        
    Else
        ' Add new
        Call GRDParts.AddItem(vAllocateID & vbTab & vPartCodeID & vbTab & TXTPartCode.Text & vbTab & TXTDescription.Text & vbTab & CBOOperation.Text & vbTab & TXTRefit.Text & vbTab & TXTRepair.Text & vbTab & TXTPaint.Text & vbTab & TXTPanel.Text)
    End If
    Call ClearPartDetails
'    Call TXTPartCode.SetFocus
    Call CalculateTotals
End Sub

Private Sub CalculateTotals()
    Dim i As Long
    Dim Refittime As Double
    Dim Repairtime As Double
    Dim Painttime As Double
    Dim Paneltime As Double
    
    Refittime = 0
    Repairtime = 0
    Painttime = 0
    Paneltime = 0
    For i = 0 To GRDParts.ListCount - 1
        GRDParts.row = i
        GRDParts.Col = 5
        Refittime = Refittime + Val(GRDParts.ColList)
        GRDParts.Col = 6
        Repairtime = Repairtime + Val(GRDParts.ColList)
        GRDParts.Col = 7
        Painttime = Painttime + Val(GRDParts.ColList)
        GRDParts.Col = 8
        Paneltime = Paneltime + Val(GRDParts.ColList)
    Next

    TXTtotalRefit.Text = Refittime
    TXTTotalRepair.Text = Repairtime
    TXTTotalPaint.Text = Painttime
    TXTTotalPanel.Text = Paneltime
End Sub



Private Function OperationNameByID(pID As Long) As String
    Select Case pID
        Case 0
            OperationNameByID = "New"
    
        Case 1
            OperationNameByID = "Repair"
        Case 2
            OperationNameByID = "Paint"
        Case 3
            OperationNameByID = "Refit"
        Case Else
            OperationNameByID = -1
    End Select
End Function

Private Function OperationIDByName(pName As String) As Long
    Select Case pName
        Case "New"
            OperationIDByName = 0
    
        Case "Repair"
            OperationIDByName = 1
        Case "Paint"
            OperationIDByName = 2
        Case "Refit"
            OperationIDByName = 3
        Case Else
            OperationIDByName = -1
    End Select
End Function



''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CBOOperation_Click()
    TXTRefit.Visible = True
    TXTRepair.Visible = True
    TXTPaint.Visible = True
    TXTPanel.Visible = True
    Select Case CBOOperation.Text
        Case "New"
'            TXTRefit.Visible = True
            TXTRepair.Visible = False
'            TXTPaint.Visible = True
'            TXTPanel.Visible = True
    
        Case "Repair"
'            TXTRefit.Visible = True
'            TXTRepair.Visible = True
'            TXTPaint.Visible = True
            TXTPanel.Visible = False
        Case "Paint"
'            TXTRefit.Visible = True
            TXTRepair.Visible = False
'            TXTPaint.Visible = True
            TXTPanel.Visible = False
        Case "Refit"
'            TXTRefit.Visible = True
            TXTRepair.Visible = False
            TXTPaint.Visible = False
            TXTPanel.Visible = False
    End Select
End Sub

Private Sub CBOOperation_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearPartDetails
End Sub

''
Private Sub CMDExit_Click()
    Dim i As Long
'    Call vParent.SendChildInactive
    For i = 0 To GRDParts.ListCount - 1
        GRDParts.row = i
        GRDParts.Col = 0
'        vAllocate.Uid = GRDParts.ColText

        If (Val(GRDParts.ColList) <> -1) Then
            'edit record
            If (vAllocate.SetIndexByUID(GRDParts.ColList) = False) Then
                ' error finding record
                i = i
            End If
            
        Else
            'add new record
            Call vAllocate.AddRecord(-1)
        End If
        GRDParts.Col = 1
        vAllocate.Partcodeid = GRDParts.ColList
'        GRDParts.Col = 2
'        TXTPartCode.Text = GRDParts.Collist
'        GRDParts.Col = 3
'        TXTDescription.Text = GRDParts.Collist
        GRDParts.Col = 4
        vAllocate.Operation = OperationIDByName(GRDParts.ColList)
        GRDParts.Col = 5
        vAllocate.Refittime = Val(GRDParts.ColList)
        GRDParts.Col = 6
        vAllocate.Repairtime = Val(GRDParts.ColList)
        GRDParts.Col = 7
        vAllocate.Painttime = Val(GRDParts.ColList)
        GRDParts.Col = 8
        vAllocate.Paneltime = Val(GRDParts.ColList)
        
    Next


    vAllocate.WriteRecord
    Call vAllocate.ClearDetails
    vIsLoaded = False
    Call Unload(Me)
    Call AllFormsHide(Me)
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
'    Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    Call SetupFieldSizes
    
    Call LoadListCBO(CBOAdditional, "AdditionalCost", "Name", "UID", False, False)
    
    Call CBOOperation.AddItem("New")
    CBOOperation.ItemData(CBOOperation.ListCount - 1) = 0
    Call CBOOperation.AddItem("Repair")
    CBOOperation.ItemData(CBOOperation.ListCount - 1) = 1
    Call CBOOperation.AddItem("Paint")
    CBOOperation.ItemData(CBOOperation.ListCount - 1) = 2
    Call CBOOperation.AddItem("Refit")
    CBOOperation.ItemData(CBOOperation.ListCount - 1) = 3
    
    CBOOperation.ListIndex = 0
    
    vAllocateID = -1
    vPartCodeID = -1
    
    vPartCodeSearch.PartCode = vPartCode
    Call vPartCodeSearch.SetParent(Me)
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
   
End Sub

Private Sub GRDAdditional_Click()
    If (GRDAdditional.ListIndex >= 0) Then
        GRDAdditional.Col = 0
        vAllocateID = GRDAdditional.ColText
        Call CBOAdditional.SetFocus
    End If
End Sub

Private Sub GRDParts_Click()
    If (GRDParts.ListIndex >= 0) Then
        GRDParts.Col = 0
        vAllocateID = GRDParts.ColText
        GRDParts.Col = 1
        vPartCodeID = GRDParts.ColText
        GRDParts.Col = 2
        TXTPartCode.Text = GRDParts.ColText
        GRDParts.Col = 3
        TXTDescription.Text = GRDParts.ColText
        GRDParts.Col = 4
        Call SetByItemCBO(CBOOperation, GRDParts.ColText)
        GRDParts.Col = 5
        TXTRefit.Text = GRDParts.ColText
        GRDParts.Col = 6
        TXTRepair.Text = GRDParts.ColText
        GRDParts.Col = 7
        TXTPaint.Text = GRDParts.ColText
        GRDParts.Col = 8
        TXTPanel.Text = GRDParts.ColText
        vEditRow = GRDParts.ListIndex
        Call TXTPartCode.SetFocus
    End If
End Sub


Private Sub TxtBox14_Click()

End Sub

Private Sub TxtBox14_LostFocus()
    ' Add
End Sub

Private Sub TXTDummy_GotFocus()
    Call AddUpdateGrid
End Sub


Private Sub TXTPanel_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        Call SendKeys(vbTab)
    End If
End Sub

Private Sub TXTPanel2_Validate(Cancel As Boolean)
    Call AddUpdateGrid
'    Cancel = True
End Sub

Private Sub TXTPartCode_Validate(Cancel As Boolean)
    If (TXTPartCode.Text <> "") Then
        vPartCode.Code = TXTPartCode.Text
        Me.Enabled = False
        Set vCurrentActiveChild = vPartCodeSearch
        If (vPartCodeSearch.Search() = False) Then
            Me.Enabled = True
            Call Messagebox("Part not found.", vbInformation)
            Cancel = True
            TXTPartCode.SetFocus
        Else
        End If
    End If
End Sub

Private Sub TXTRefit_Validate(Cancel As Boolean)
    If (TXTPanel.Visible = False And TXTPaint.Visible = False And TXTRepair.Visible = False) Then
'        Call AddUpdateGrid
'        Cancel = True
    End If
End Sub

Private Sub TXTRepair_Validate(Cancel As Boolean)
    If (TXTPanel.Visible = False And TXTPaint.Visible = False) Then
'        Call AddUpdateGrid
'        Cancel = True
    End If
End Sub
