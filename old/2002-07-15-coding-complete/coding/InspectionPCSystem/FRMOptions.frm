VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
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
   Begin VB.CommandButton Command1 
      Caption         =   "Read Model/Make from CarInfo2"
      Height          =   375
      Left            =   6360
      TabIndex        =   26
      Top             =   1020
      Width           =   2655
   End
   Begin VB.CommandButton CMDSyncWithCarInfo2 
      Caption         =   "Sync Make/Model with CarInfo2"
      Height          =   375
      Left            =   3240
      TabIndex        =   25
      Top             =   6780
      Width           =   2655
   End
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   11
      Top             =   6780
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   8880
      TabIndex        =   20
      Top             =   6780
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTDefaultHandlingCharge 
      Height          =   285
      Left            =   7200
      TabIndex        =   9
      Top             =   4500
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
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   315
      Left            =   1200
      TabIndex        =   0
      Top             =   4140
      Width           =   3375
      _ExtentX        =   5953
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
      Left            =   1200
      TabIndex        =   1
      Top             =   4500
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTown 
      Height          =   285
      Left            =   1200
      TabIndex        =   3
      Top             =   5220
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCounty 
      Height          =   285
      Left            =   1200
      TabIndex        =   4
      Top             =   5580
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet2 
      Height          =   285
      Left            =   1200
      TabIndex        =   2
      Top             =   4860
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPostcode 
      Height          =   285
      Left            =   1200
      TabIndex        =   6
      Top             =   6300
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
      Left            =   1200
      TabIndex        =   5
      Top             =   5940
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVATNumber 
      Height          =   285
      Left            =   3480
      TabIndex        =   7
      Top             =   6300
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
   Begin ELFTxtBox.TxtBox1 TXTDefaultDuePeriod 
      Height          =   285
      Left            =   7200
      TabIndex        =   8
      Top             =   4140
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
   Begin ELFTxtBox.TxtBox1 TXTDefaultVATPercent 
      Height          =   285
      Left            =   7200
      TabIndex        =   10
      Top             =   4860
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
   Begin ELFTxtBox.TxtBox1 TXTPathToCarInfo 
      Height          =   315
      Left            =   2280
      TabIndex        =   21
      Top             =   480
      Width           =   3375
      _ExtentX        =   5953
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
   Begin ELFTxtBox.TxtBox1 TXTPathToCarInfoFormat 
      Height          =   315
      Left            =   2280
      TabIndex        =   23
      Top             =   900
      Width           =   3375
      _ExtentX        =   5953
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
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Path To CarInfo Format"
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
      Left            =   120
      TabIndex        =   24
      Top             =   900
      Width           =   2055
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Path To CarInfo 2"
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
      Left            =   240
      TabIndex        =   22
      Top             =   480
      Width           =   1935
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
      Left            =   4800
      TabIndex        =   19
      Top             =   4860
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
      Left            =   4800
      TabIndex        =   18
      Top             =   4140
      Width           =   2295
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
      TabIndex        =   17
      Top             =   6300
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Company Details"
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
      Left            =   240
      TabIndex        =   16
      Top             =   3780
      Width           =   4335
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
      TabIndex        =   15
      Top             =   4140
      Width           =   735
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
      TabIndex        =   14
      Top             =   4500
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
      Left            =   120
      TabIndex        =   13
      Top             =   6300
      Width           =   975
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
      Left            =   4800
      TabIndex        =   12
      Top             =   4500
      Width           =   2295
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
Private vVatnumber As String
Private vDefaultDuePeriod As Long
Private vDefaultHandlingCharge As Currency

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
    CompanyVATNumber = vVatnumber
End Property

Public Property Get DefaultDuePeriod() As Long
    DefaultDuePeriod = vDefaultDuePeriod
End Property

Public Property Get DefaultHandlingCharge() As Currency
    DefaultHandlingCharge = vDefaultHandlingCharge
End Property

Public Property Get DefaultVATPercent() As Currency
    DefaultVATPercent = vDefaultVATPercent
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
        Call SetServerSetting("CARINFOPATH", TXTPathToCarInfo.Text)
        Call SetServerSetting("PATHTOELF", TXTPathToCarInfoFormat.Text)
'    If (Val(TXTWorkstationIndex.Text) = 1) Then
'        Call Messagebox("WARNING: Workstation Index must not be 1", vbInformation)
'    Else
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
'        Call SetWorkstationSetting("INVOICENUMBERPREFIX", TXTInvoiceNumberPreFix.Text)
        Call SetServerSetting("DEFAULTDUEPERIOD", TXTDefaultDuePeriod.Text)
'        If (CHKUseProductDatabase.Value = vbChecked) Then
'            Call SetServerSetting("USEPRODUCTDATABASE", True)
'            vUseProductDatabase = True
'        Else
'            Call SetServerSetting("USEPRODUCTDATABASE", False)
'            vUseProductDatabase = False
'        End If
        
'        Call SetWorkstationSetting("WORKSTATIONINDEX", TXTWorkstationIndex.Text)
        
        Call SetServerSetting("DEFAULTVATPERCENT", TXTDefaultVATPercent.Text)
        
'        Call SetServerSetting("NEXTINVOICENUMBER-" & TXTInvoiceNumberPreFix.Text, Val(TXTNextInvoiceNumber.Text))
        
        
        
        vCompanyName = TXTName.Text
        vStreet1 = TXTStreet1.Text
        vStreet2 = TXTStreet2.Text
        vTown = TXTTown.Text
        vCounty = TXTCounty.Text
        vCountry = TXTCountry.Text
        vPostCode = TXTPostcode.Text
        vVatnumber = TXTVATNumber.Text
        vDefaultHandlingCharge = Val(RemoveNonNumericCharacters(TXTDefaultHandlingCharge.Text))
        vDefaultVATPercent = Val(RemoveNonNumericCharacters(TXTDefaultVATPercent.Text))
        
'        TXTSerialNumber.Text = GenerateSerialNumber(TXTProductKey.Text)
'    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub CMDSyncWithCarInfo2_Click()
    Dim rsCarMake As New RecordSetDat
    Dim rsCarModel As New RecordSetDat
    Dim rsLocalMake As Recordset
    Dim rsLocalModel As Recordset

    Call Execute("DELETE FROM Make", True)
    Call Execute("DELETE FROM Model", True)

    If (OpenRecordset(rsLocalMake, "Make", dbOpenTable)) Then
    End If
    If (OpenRecordset(rsLocalModel, "Model", dbOpenTable)) Then
    End If

    Call rsCarMake.ProcessSQL("SELECT * FROM Merk")
    Do While (rsCarMake.EofRec = False)
        rsLocalMake.AddNew
        rsLocalMake!Name = rsCarMake!Name
        rsLocalMake!shortName = rsCarMake!key
        Call rsLocalMake.Update
        Call rsCarModel.ProcessSQL("SELECT * FROM Model WHERE Make='" & rsCarMake!key & "'")
        Do While (rsCarModel.EofRec = False)
            Call rsLocalModel.AddNew
            rsLocalModel!Name = rsCarModel!Name
            rsLocalModel!shortName = rsCarModel!modelshort
            rsLocalModel!MakeID = rsLocalMake!Uid
            Call rsLocalModel.Update
            
            
            Call rsCarModel.MoveNext
        Loop
    
    
        Call rsCarMake.MoveNext
    Loop
'    If (vDataChanged = True) Then
        ' Update Palm Database
        Call Execute("DELETE * FROM INSPMake", True)
        Call Execute("DELETE * FROM INSPModel", True)
        Call Execute("INSERT INTO INSPMake SELECT UID,[Name],ShortName FROM Make", True)
        Call Execute("INSERT INTO INSPModel SELECT UID,[Name],ShortName,startYear,EndYear,MakeID FROM Model", True)
        Call Execute("UPDATE InspFlags SET UpdateMake=True, UpdateModel=True", True)
'    End If
End Sub

Private Sub Command1_Click()
    Dim rsCalc As New RecordSetDat
    Dim rsLocalINSPdata As Recordset
    Dim rstemp As Recordset

    Screen.MousePointer = vbHourglass
    If (OpenRecordset(rsLocalINSPdata, "SELECT * FROM INSPdata WHERE INSPmakeid=0", dbOpenDynaset)) Then

        Do While (rsLocalINSPdata.EOF = False)
            Call rsCalc.ProcessSQL("SELECT * FROM calc WHERE vehicle_reg='" & Trim$(rsLocalINSPdata!Registration & "") & "'")
            If (rsCalc.EofRec = False) Then
                If (OpenRecordset(rstemp, "SELECT * FROM make WHere shortname='" & rsCalc!makeshort & "'", dbOpenSnapshot)) Then
                    If (rstemp.EOF = False) Then
                        rsLocalINSPdata!inspmakeid = rstemp!Uid
                        If (OpenRecordset(rstemp, "SELECT * FROM model WHere makeid=" & rstemp!Uid & " AND shortname='" & rsCalc!modelshort & "'", dbOpenSnapshot)) Then
                            If (rstemp.EOF = False) Then
                                rsLocalINSPdata!inspmodelid = rstemp!Uid
                            End If
                        End If
                    End If
                End If
            End If
            Call rsLocalINSPdata.Update
            Call rsLocalINSPdata.MoveNext
        Loop
    End If
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()

    Dim rstemp As Recordset
    Dim i As Long
    vIsLoaded = True
    Call SetWindowPosition(Me)
    Call AllFormsLoad(Me)
    TXTPathToCarInfo.Text = GetServerSetting("CARINFOPATH", True)
    TXTPathToCarInfoFormat.Text = GetServerSetting("PATHTOELF", True)

    TXTDefaultHandlingCharge.Text = GetServerSetting("DEFAULTHANDLING", False)
    TXTName.Text = GetServerSetting("COMPANYNAME", False)
    TXTStreet1.Text = GetServerSetting("COMPANYSTREET2", False)
    TXTStreet2.Text = GetServerSetting("COMPANYSTREET1", False)
    TXTTown.Text = GetServerSetting("COMPANYTOWN", False)
    TXTCounty.Text = GetServerSetting("COMPANYCOUNTY", False)
    TXTCountry.Text = GetServerSetting("COMPANYCOUNTRY", False)
    TXTPostcode.Text = GetServerSetting("COMPANYPOSTCODE", False)
    TXTVATNumber.Text = GetServerSetting("COMPANYVATNUMBER", False)
'    If (OpenRecordset(rstemp, "SELECT * FROM Disclaimer", dbOpenSnapshot)) Then
'        If (rstemp.EOF = False) Then
'            TXTInvoiceComments.Text = rstemp!Message & ""
'        End If
'    End If
'    TXTInvoiceComments.Text = GetServerSetting("INVOICECOMMENTS")
'    TXTInvoiceNumberPreFix.Text = GetWorkstationSetting("INVOICENUMBERPREFIX")
    TXTDefaultDuePeriod.Text = GetServerSetting("DEFAULTDUEPERIOD", False)
'    TXTWorkstationIndex.Text = GetWorkstationSetting("WORKSTATIONINDEX")
        
    TXTDefaultVATPercent.Text = GetServerSetting("DEFAULTVATPERCENT", False)
    
    
'    TXTNextInvoiceNumber.Text = GetServerSetting("NEXTINVOICENUMBER-" & TXTInvoiceNumberPreFix.Text, False)
End Sub

''
Public Sub LoadSettings()
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
    vVatnumber = GetServerSetting("COMPANYVATNUMBER", False)
'    vInvoiceComments = GetServerSetting("INVOICECOMMENTS")
    vDefaultDuePeriod = Val(GetServerSetting("DEFAULTDUEPERIOD", False))
    vDefaultVATPercent = Val(GetServerSetting("DEFAULTVATPERCENT", False))
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
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

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' frmoptions.TXTSerialNumber.Text  =frmoptions.GenerateSerialNumber (frmoptions.TXTProductKey.Text  )

''
Private Function Rotate(pString As String) As String
    Dim i As Long
    Dim RotateValue As Long
    Dim charValue As Long
    RotateValue = 1
    For i = 1 To Len(pString)
        charValue = Asc(Mid$(pString, i, 1))
        If (charValue + RotateValue < 65) Then
            charValue = charValue + 65 - 48
        End If
        If (charValue + RotateValue > Asc("Z")) Then
            Rotate = Rotate & Chr$(charValue - RotateValue)
        Else
            Rotate = Rotate & Chr$(charValue + RotateValue)
        End If
        RotateValue = RotateValue + 1
    Next
End Function

''
Private Function SumString(pString As String) As Long
    Dim i As Long
    Dim key As Long
    Dim char As String
    Dim HiLo As Boolean
    HiLo = False
    For i = 1 To Len(pString)
        char = Mid$(pString, i, 1)
        If (HiLo = False) Then
            key = key + Asc(char)
            HiLo = True
        Else
            key = key + Asc(char) * 514#
            HiLo = False
        End If
        If (key > 400000000) Then
            key = key - 200000000
        End If
    Next
    SumString = key
End Function

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
    key2 = SumString(vVatnumber)
    key3 = SumString(vVatnumber) + SumString(vPostCode) + SumString(vCompanyName)
    GenerateProductKeyFromLocal = key & "-" & key2 & "-" & key3 & "-" & Rotate(vVatnumber)
End Function

''
Public Function GenerateSerialNumber(pProductKey As String) As String
    pProductKey = Replace(pProductKey, "-", "")
    GenerateSerialNumber = Rotate(pProductKey)
End Function
