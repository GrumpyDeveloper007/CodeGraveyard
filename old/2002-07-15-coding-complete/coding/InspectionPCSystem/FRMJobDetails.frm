VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#12.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMJobDetails 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Job Details -"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin VB.ComboBox CBOPaintSystem 
      Height          =   315
      Left            =   6240
      Style           =   2  'Dropdown List
      TabIndex        =   93
      Top             =   4140
      Width           =   2295
   End
   Begin VB.CommandButton CMDParts 
      Caption         =   "Parts"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   4200
      TabIndex        =   92
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDEstimate 
      Caption         =   "Estimate"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   2880
      TabIndex        =   91
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDHours 
      Caption         =   "Hours"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   8280
      TabIndex        =   90
      Top             =   6900
      Width           =   1095
   End
   Begin VB.ComboBox CBOPointOfInpact 
      Height          =   315
      Left            =   6240
      Style           =   2  'Dropdown List
      TabIndex        =   89
      Top             =   5400
      Width           =   1695
   End
   Begin VB.ComboBox CBOLocation 
      Height          =   315
      Left            =   6240
      Style           =   2  'Dropdown List
      TabIndex        =   45
      Top             =   1860
      Width           =   2295
   End
   Begin VB.ComboBox CBOMake 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   22
      Top             =   4560
      Width           =   2895
   End
   Begin VB.ComboBox CBOModel 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   21
      Top             =   4920
      Width           =   2895
   End
   Begin VB.ComboBox CBOColour 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   20
      Top             =   5280
      Width           =   1575
   End
   Begin VB.TextBox TXTOptions 
      Height          =   615
      Left            =   6240
      MultiLine       =   -1  'True
      TabIndex        =   18
      Top             =   2580
      Width           =   2895
   End
   Begin VB.TextBox TXTTrim 
      Height          =   555
      Left            =   6240
      MultiLine       =   -1  'True
      TabIndex        =   17
      Top             =   3240
      Width           =   2895
   End
   Begin VB.ComboBox CBOInspector 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   13
      Top             =   2160
      Width           =   2895
   End
   Begin VB.ComboBox CBOInsurer 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   1800
      Width           =   2895
   End
   Begin VB.TextBox TXTAddress 
      BackColor       =   &H00C0C0C0&
      Height          =   1095
      Left            =   1440
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   0
      Width           =   3975
   End
   Begin VB.CommandButton CMDCourtesy 
      Caption         =   "Courtesy Car"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   1560
      TabIndex        =   5
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDCancel 
      Caption         =   "Cancel"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   10560
      TabIndex        =   4
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDNewJob 
      Caption         =   "<New Job>"
      CausesValidation=   0   'False
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   6900
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTJobStatus 
      Height          =   285
      Left            =   6600
      TabIndex        =   9
      Top             =   0
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
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTDriver 
      Height          =   285
      Left            =   1680
      TabIndex        =   11
      Top             =   1500
      Width           =   2655
      _ExtentX        =   4683
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
   Begin ELFTxtBox.TxtBox1 TXTReference 
      Height          =   285
      Left            =   1680
      TabIndex        =   15
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFDateControl.DateControl TXTMOTDate 
      Height          =   615
      Left            =   6600
      TabIndex        =   19
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
   Begin ELFTxtBox.TxtBox1 TXTReg 
      Height          =   285
      Left            =   1680
      TabIndex        =   23
      Top             =   4260
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
   Begin ELFTxtBox.TxtBox1 TXTVIN 
      Height          =   285
      Left            =   6240
      TabIndex        =   24
      Top             =   2280
      Width           =   1575
      _ExtentX        =   2778
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
   Begin ELFTxtBox.TxtBox1 TXTChassisNo 
      Height          =   285
      Left            =   6240
      TabIndex        =   33
      Top             =   4440
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
   Begin ELFTxtBox.TxtBox1 TXTColourCode 
      Height          =   285
      Left            =   3960
      TabIndex        =   34
      Top             =   4260
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
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTMileage 
      Height          =   285
      Left            =   6240
      TabIndex        =   35
      Top             =   6300
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
   Begin ELFTxtBox.TxtBox1 TXTEngineCode 
      Height          =   285
      Left            =   6240
      TabIndex        =   36
      Top             =   3840
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
      Left            =   10200
      TabIndex        =   37
      Top             =   600
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
   Begin ELFTxtBox.TxtBox1 TXTRadioMakeCode 
      Height          =   285
      Left            =   1680
      TabIndex        =   46
      Top             =   5640
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
      Left            =   1680
      TabIndex        =   47
      Top             =   5940
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
      Left            =   10200
      TabIndex        =   48
      Top             =   900
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
      Left            =   10200
      TabIndex        =   49
      Top             =   1560
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
      Left            =   10200
      TabIndex        =   50
      Top             =   1200
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
      Left            =   6240
      TabIndex        =   51
      Top             =   4740
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
      Left            =   6240
      TabIndex        =   52
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
   Begin ELFTxtBox.TxtBox1 TXTCondition 
      Height          =   285
      Left            =   6240
      TabIndex        =   53
      Top             =   5700
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
      Left            =   1680
      TabIndex        =   54
      Top             =   6240
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
      Left            =   1680
      TabIndex        =   55
      Top             =   6540
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
   Begin ELFTxtBox.TxtBox1 TXTBroker 
      Height          =   285
      Left            =   1680
      TabIndex        =   67
      Top             =   2520
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
      Left            =   6120
      TabIndex        =   69
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
   Begin ELFTxtBox.TxtBox1 TXTSuppLabour 
      Height          =   285
      Left            =   6120
      TabIndex        =   70
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
   Begin ELFTxtBox.TxtBox1 TXTPolicyNo 
      Height          =   285
      Left            =   1680
      TabIndex        =   73
      Top             =   2820
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
      Left            =   1680
      TabIndex        =   74
      Top             =   3120
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
      Left            =   1680
      TabIndex        =   77
      Top             =   3420
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
      Left            =   1680
      TabIndex        =   78
      Top             =   3720
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
   Begin ELFTxtBox.TxtBox1 TXTVATPercent 
      Height          =   285
      Left            =   6240
      TabIndex        =   81
      Top             =   6000
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
   Begin ELFTxtBox.TxtBox1 TXTDateIn 
      Height          =   285
      Left            =   10200
      TabIndex        =   82
      Top             =   300
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
      Left            =   10200
      TabIndex        =   83
      Top             =   2220
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
      Left            =   9960
      TabIndex        =   84
      Top             =   6060
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
      Caption         =   "Vat Percent"
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
      Left            =   4800
      TabIndex        =   88
      Top             =   6000
      Width           =   1335
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
      Left            =   9360
      TabIndex        =   87
      Top             =   300
      Width           =   735
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
      Left            =   8640
      TabIndex        =   86
      Top             =   2220
      Width           =   1455
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
      Left            =   8640
      TabIndex        =   85
      Top             =   6060
      Width           =   1215
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
      Left            =   600
      TabIndex        =   80
      Top             =   3420
      Width           =   975
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
      Left            =   840
      TabIndex        =   79
      Top             =   3720
      Width           =   735
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
      Left            =   720
      TabIndex        =   76
      Top             =   2820
      Width           =   855
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
      Left            =   720
      TabIndex        =   75
      Top             =   3120
      Width           =   855
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
      Index           =   13
      Left            =   4440
      TabIndex        =   72
      Top             =   1440
      Width           =   1575
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
      Index           =   12
      Left            =   4440
      TabIndex        =   71
      Top             =   1140
      Width           =   1575
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
      Left            =   840
      TabIndex        =   68
      Top             =   2520
      Width           =   735
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
      Left            =   120
      TabIndex        =   66
      Top             =   6540
      Width           =   1455
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
      Left            =   0
      TabIndex        =   65
      Top             =   6240
      Width           =   1575
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
      Left            =   5280
      TabIndex        =   64
      Top             =   5700
      Width           =   855
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
      Left            =   4680
      TabIndex        =   63
      Top             =   5400
      Width           =   1455
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
      Left            =   4920
      TabIndex        =   62
      Top             =   5100
      Width           =   1215
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
      Left            =   5160
      TabIndex        =   61
      Top             =   4740
      Width           =   975
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
      Left            =   9240
      TabIndex        =   60
      Top             =   1200
      Width           =   855
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
      Left            =   8640
      TabIndex        =   59
      Top             =   1560
      Width           =   1455
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
      Left            =   9120
      TabIndex        =   58
      Top             =   900
      Width           =   975
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
      Left            =   0
      TabIndex        =   57
      Top             =   5940
      Width           =   1575
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
      Left            =   0
      TabIndex        =   56
      Top             =   5640
      Width           =   1575
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
      Left            =   5280
      TabIndex        =   44
      Top             =   1860
      Width           =   855
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
      Left            =   4920
      TabIndex        =   43
      Top             =   4140
      Width           =   1215
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
      Left            =   9600
      TabIndex        =   42
      Top             =   600
      Width           =   495
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
      Left            =   4920
      TabIndex        =   41
      Top             =   3840
      Width           =   1215
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
      Left            =   5400
      TabIndex        =   40
      Top             =   6300
      Width           =   735
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
      Left            =   2760
      TabIndex        =   39
      Top             =   4260
      Width           =   1095
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
      Left            =   5040
      TabIndex        =   38
      Top             =   4440
      Width           =   1095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Reg"
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
      Left            =   600
      TabIndex        =   32
      Top             =   4260
      Width           =   975
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
      Index           =   4
      Left            =   600
      TabIndex        =   31
      Top             =   4560
      Width           =   975
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
      Index           =   5
      Left            =   600
      TabIndex        =   30
      Top             =   4920
      Width           =   975
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
      Index           =   6
      Left            =   600
      TabIndex        =   29
      Top             =   5280
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "MOT Date"
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
      Left            =   5520
      TabIndex        =   28
      Top             =   600
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "VIN"
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
      Left            =   5160
      TabIndex        =   27
      Top             =   2280
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Options"
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
      Left            =   4920
      TabIndex        =   26
      Top             =   2580
      Width           =   1215
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
      Index           =   19
      Left            =   5160
      TabIndex        =   25
      Top             =   3240
      Width           =   975
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
      Index           =   11
      Left            =   600
      TabIndex        =   16
      Top             =   1140
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Inspector"
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
      Left            =   600
      TabIndex        =   14
      Top             =   2160
      Width           =   975
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
      Index           =   8
      Left            =   600
      TabIndex        =   12
      Top             =   1500
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Job Status"
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
      Left            =   5520
      TabIndex        =   10
      Top             =   0
      Width           =   975
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
      Index           =   2
      Left            =   600
      TabIndex        =   8
      Top             =   1800
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
      TabIndex        =   2
      Top             =   480
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
      TabIndex        =   1
      Top             =   240
      Width           =   1335
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
      TabIndex        =   0
      Top             =   0
      Width           =   1335
   End
End
Attribute VB_Name = "FRMJobDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
''
''
'' Coded by Dale Pitman

''


''
Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

Private vCustomerSearch As FrmuCustomerSearch
Private vjob As ClassJOB

Public Sub SendChildInactive()
    Me.Enabled = True
    Call Me.ZOrder
    If (vCurrentActiveChild.ChildType = CustomerSearch) Then
        If (vjob.Vehicle.Customer.HasData = True) Then
            Call LoadDetails
        Else
            Call Unload(Me)
        End If
    End If
End Sub

Public Sub Search()
    Call Me.Show
    Set vCurrentActiveChild = vCustomerSearch
    Call vCustomerSearch.Search
    Me.Enabled = False
End Sub

Private Sub LoadDetails()
    Dim address As String
    address = ""
    If (vjob.Vehicle.Customer.CompanyName <> "") Then
        address = address & vjob.Vehicle.Customer.CompanyName & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Name <> "") Then
        address = address & vjob.Vehicle.Customer.Name & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Street1 <> "") Then
        address = address & vjob.Vehicle.Customer.Street1 & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Street2 <> "") Then
        address = address & vjob.Vehicle.Customer.Street2 & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Town <> "") Then
        address = address & vjob.Vehicle.Customer.Town & vbCrLf
    End If
    If (vjob.Vehicle.Customer.County <> "") Then
        address = address & vjob.Vehicle.Customer.County & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Country <> "") Then
        address = address & vjob.Vehicle.Customer.Country & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Postcode <> "") Then
        address = address & vjob.Vehicle.Customer.Postcode & vbCrLf
    End If
    If (vjob.Vehicle.Customer.Name <> "") Then
        address = address & vjob.Vehicle.Customer.Name & vbCrLf
    End If
    
    TXTAddress.Text = address
    
'    txtreference.text= vjob.
'    TXTDriver.Text
'    CBOInsurer.Text
'    CBOInspector.Text
'    txtbroker.Text =vjob.
'    txtpolicyno.Text vjob.
'    txtclaimno.Text =vjob.cl
'    TXTClaimDate.Text = vjob.clia
    TXTExcess.Text = vjob.Excess
    TXTReg.Text = vjob.Vehicle.Reg
'    TXTColourCode.Text
'    Call SetByItemDataCBO(CBOMake, vjob.Vehicle.makeid)
    Call SetByItemDataCBO(CBOModel, vjob.Vehicle.Modelid)
    Call SetByItemDataCBO(CBOColour, vjob.Vehicle.Colourid)
    TXTRadioMakeCode.Text = vjob.Vehicle.Radiocode
'    txtalarmmakecode.Text =vjob.Vehicle.al
'    txtpreacccondition.Text =vjob.
'    txtpreaccdamage.Text =
    TXTJobStatus.Text = ""
    TXTMOTDate.Text = vjob.Vehicle.Motdate
'    txtestimatedlabour.Text =vjob.
'    TXTSuppLabour.Text
'    call SetByItemDataCBO(cbolocation,vjob. )
'    txtvin.Text
    TXTOptions.Text = vjob.Vehicle.Options
    TXTTrim.Text = vjob.Vehicle.Trimcode
    TXTEngineCode.Text = vjob.Vehicle.Enginenumber
'    TXTPaintSystem.Text = ""
'    txtchassisno.Text =vjob.Vehicle.chass
'    txtlamptype.Text =vjob.Vehicle.Lampnumber
'    txtdamagetype.Text =vjob.Vehicle.da
'    call SetByItemDataCBO(cbopointofinpact,vjob.
'    txtcondition.Text =vjob.Vehicle.con
    TXTVATPercent.Text = ""
'    TXTMileage.Text = vjob.Vehicle.mile
    TXTDateIn.Text = vjob.Startdate
    TXTYear.Text = vjob.Vehicle.Year
'    txtfuellevel.Text =vjob.Vehicle.fu
'    txttaxdate.Text =vjob.Vehicle.tax
    TXTDateRegistered.Text = vjob.Vehicle.Registereddate
'    TXTInspectionDate.Text = vjob.Finalinspectiondate ??

    

    


End Sub

Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub


Private Sub CBOInsurer_Click()
    Call CBOInspector.Clear
    Call LoadListCBO(CBOInspector, "SELECT * FROM Employee WHERE EmployeeTypeID=1 AND InsuranceCompanyID=" & CBOInsurer.ItemData(CBOInsurer.ListIndex), "Name", "UID", False, False)
End Sub


Private Sub CBOMake_Click()
    Call CBOInspector.Clear
    Call LoadListCBO(CBOModel, "SELECT * FROM Model WHERE MakeID=" & CBOMake.ItemData(CBOMake.ListIndex), "Name", "UID", False, False)
End Sub

Private Sub CMDCancel_Click()
    Me.Enabled = False
    Call vCustomerSearch.Search
End Sub

Private Sub CMDCourtesy_Click()
    Call FRMAllocateCourtesyCar.Show
End Sub

Private Sub CMDEstimate_Click()
    Call FRMAllocate.Search
End Sub

Private Sub CMDHours_Click()
    Call FRMHours.Show
End Sub


Private Sub CMDParts_Click()
    Call FRMAllocateParts.Show
End Sub

Private Sub Form_Load()
    Set vCustomerSearch = New FrmuCustomerSearch
    Set vjob = New ClassJOB
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call vCustomerSearch.SetParent(Me)
    Call vCustomerSearch.SetJobClass(vjob)


    Call LoadListCBO(CBOInsurer, "InsuranceCompany", "Name", "UID", False, False)
    
    Call LoadListCBO(CBOInsurer, "Employee", "Name", "UID", False, False)
    
    Call LoadListCBO(CBOMake, "make", "Name", "UID", False, False)
    Call LoadListCBO(CBOModel, "model", "Name", "UID", False, False)
    Call LoadListCBO(CBOColour, "colour", "Name", "UID", False, False)
    
    Call LoadListCBO(CBOPointOfInpact, "jobpointofinpact", "Name", "UID", False, False)
    Call LoadListCBO(CBOLocation, "location", "Name", "UID", False, False)

    Call LoadListCBO(CBOPaintSystem, "PaintSystem", "Name", "UID", False, False)


    TXTMOTDate.Text = Format(Now, "dd/mm/yyyy")
    
'    ConduitManager2.InstallConduit(
    
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

Private Sub TxtBox15_Click()

End Sub
