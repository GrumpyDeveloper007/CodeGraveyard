VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form frmDetails 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2400
   BeginProperty Font 
      Name            =   "AFPalm"
      Size            =   9
      Charset         =   2
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   160
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   160
   StartUpPosition =   2  'CenterScreen
   Begin IngotButtonCtl.AFButton btnEdit 
      Height          =   240
      Left            =   600
      OleObjectBlob   =   "frmDetails.frx":0000
      TabIndex        =   0
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "frmDetails.frx":0049
      TabIndex        =   1
      Top             =   2160
      Width           =   495
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":0094
      TabIndex        =   2
      Top             =   675
      Width           =   705
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":00DD
      TabIndex        =   3
      Top             =   1755
      Width           =   705
   End
   Begin IngotLabelCtl.AFLabel lblName 
      Height          =   180
      Left            =   15
      OleObjectBlob   =   "frmDetails.frx":0126
      TabIndex        =   4
      Top             =   30
      Width           =   525
   End
   Begin IngotLabelCtl.AFLabel lblCompany 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":016C
      TabIndex        =   5
      Top             =   240
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblFirstInitial 
      Height          =   180
      Left            =   1515
      OleObjectBlob   =   "frmDetails.frx":01B4
      TabIndex        =   6
      Top             =   30
      Width           =   150
   End
   Begin IngotLabelCtl.AFLabel lblTitle 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":01F7
      TabIndex        =   7
      Top             =   465
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lablAddress 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":023D
      TabIndex        =   8
      Top             =   885
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblCity 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":0285
      TabIndex        =   9
      Top             =   1110
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblState 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":02CA
      TabIndex        =   10
      Top             =   1320
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblZip 
      Height          =   180
      Index           =   1
      Left            =   1320
      OleObjectBlob   =   "frmDetails.frx":0311
      TabIndex        =   11
      Top             =   1335
      Width           =   330
   End
   Begin IngotLabelCtl.AFLabel lblCountry 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":0355
      TabIndex        =   12
      Top             =   1530
      Width           =   690
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   0
      Left            =   600
      OleObjectBlob   =   "frmDetails.frx":039E
      TabIndex        =   14
      Top             =   30
      Width           =   855
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   1
      Left            =   1695
      OleObjectBlob   =   "frmDetails.frx":03F6
      TabIndex        =   15
      Top             =   30
      Width           =   690
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   2
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":044E
      TabIndex        =   16
      Top             =   255
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   3
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":04A6
      TabIndex        =   17
      Top             =   465
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   4
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":04FE
      TabIndex        =   18
      Top             =   660
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   5
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":0556
      TabIndex        =   19
      Top             =   870
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   6
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":05AE
      TabIndex        =   20
      Top             =   1095
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   7
      Left            =   705
      OleObjectBlob   =   "frmDetails.frx":0606
      TabIndex        =   21
      Top             =   1335
      Width           =   600
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   8
      Left            =   1665
      OleObjectBlob   =   "frmDetails.frx":065E
      TabIndex        =   22
      Top             =   1335
      Width           =   735
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   9
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":06B6
      TabIndex        =   23
      Top             =   1545
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   195
      Index           =   10
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":070E
      TabIndex        =   24
      Top             =   1755
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   11
      Left            =   720
      OleObjectBlob   =   "frmDetails.frx":0766
      TabIndex        =   25
      Top             =   1965
      Width           =   1665
   End
   Begin IngotButtonCtl.AFButton btnSave 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":07BE
      TabIndex        =   26
      Top             =   2160
      Visible         =   0   'False
      Width           =   495
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "frmDetails.frx":0807
      TabIndex        =   13
      Top             =   1965
      Width           =   705
   End
End
Attribute VB_Name = "frmDetails"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub btnEdit_Click()
    bNewRecord = False
    
    btnEdit.Visible = False
    btnSave.Visible = True
    Dim IndexCounter As Integer
    For IndexCounter = 0 To 11
        txtAddress(IndexCounter).UnderlineStyle = afTextBoxUnderlineDot
        txtAddress(IndexCounter).Enabled = True
    Next
    For IndexCounter = 1 To 3
        cmbPhoneType(IndexCounter).Enabled = True
    Next
    txtAddress(0).SetFocus
    SetRecordFields DetailsRecord
    
    
End Sub

Private Sub btnPrev_Click()
End Sub

Private Sub btnSave_Click()
    Dim EditRecord As tAddressRec
    Dim NewRecord As tAddressRec
    Dim NewRecSize As Long
    Dim RecIndex As Long
    
    RecIndex = 0
    
    EditRecord = DetailsRecord
    PDBEditRecord AddressDB

    ' Set record fields
    SetRecordFields EditRecord

    ' Get size of edited record
    NewRecSize = CalculateRecordSize(EditRecord)
    
    PDBResizeRecord AddressDB, (NewRecSize)

    'Write edited record to database
    WriteAddressRecord EditRecord

    PDBUpdateRecord AddressDB
    
    Me.Hide
    Unload frmNew
    frmMain.Initialize
    frmMain.Show
    
End Sub

Private Sub CMDCancel_Click()
'    Me.Hide
'    Unload frmDetails
    frmMain.Initialize
    frmMain.Show
End Sub

Private Sub Form_Load()
    Call Initialize
End Sub

Public Sub Initialize()
'    Dim DetailsRecord As tAddressRec

    Dim IndexCounter As Integer
    For IndexCounter = 0 To 11
        txtAddress(IndexCounter).UnderlineStyle = afTextBoxUnderlineNone
        txtAddress(IndexCounter).Enabled = False
    Next IndexCounter
    
    'Fill the combobox
    FillComboBox
    DisplayDetailRecord DetailsRecord

End Sub

    
Private Sub FillComboBox()
    ' Add the same values for each combobox
    
    Dim IntCounter As Integer

    For IntCounter = 1 To 3
        cmbPhoneType(IntCounter).Clear
        cmbPhoneType(IntCounter).AddItem "Work", 0
        cmbPhoneType(IntCounter).AddItem "Home", 1
        cmbPhoneType(IntCounter).AddItem "Fax", 2
        cmbPhoneType(IntCounter).AddItem "Other", 3
        cmbPhoneType(IntCounter).AddItem "Email", 4
        cmbPhoneType(IntCounter).AddItem "Main", 5
        cmbPhoneType(IntCounter).AddItem "Pager", 6
        cmbPhoneType(IntCounter).AddItem "Mobile", 7
        cmbPhoneType(IntCounter).ListIndex = 0
    Next IntCounter
End Sub

Private Sub DisplayDetailRecord(MyRecord As tAddressRec)
    txtAddress(0).Text = MyRecord.Name
    txtAddress(1).Text = MyRecord.FirstName
    txtAddress(2).Text = MyRecord.Company
    txtAddress(3).Text = MyRecord.Title
    txtAddress(4).Text = MyRecord.Phone1
    txtAddress(5).Text = MyRecord.Address
    txtAddress(6).Text = MyRecord.City
    txtAddress(7).Text = MyRecord.State
    txtAddress(8).Text = MyRecord.ZipCode
    txtAddress(9).Text = MyRecord.Country
    txtAddress(10).Text = MyRecord.Phone2
    txtAddress(11).Text = MyRecord.Phone3
    cmbPhoneType(1).ListIndex = MyRecord.PhoneType1
    cmbPhoneType(2).ListIndex = MyRecord.PhoneType2
    cmbPhoneType(3).ListIndex = MyRecord.PhoneType3
End Sub
Private Sub SetRecordFields(MyRecord As tAddressRec)

    'Set Name field
    MyRecord.Name = txtAddress(0).Text

    'Set FirstName field
    MyRecord.FirstName = txtAddress(1).Text

    'Set Company field
    MyRecord.Company = txtAddress(2).Text

    'Set Title field
    MyRecord.Title = txtAddress(3).Text

    'Set Phone1 field
    MyRecord.Phone1 = txtAddress(4).Text

    'Set Address field
    MyRecord.Address = txtAddress(5).Text

    'Set City field
     MyRecord.City = txtAddress(6).Text

    'Set State field
    MyRecord.State = txtAddress(7).Text

    'Set ZipCode field
    MyRecord.ZipCode = txtAddress(8).Text

    'Set Country field
    MyRecord.Country = txtAddress(9).Text

    'Set Phone2 field
    MyRecord.Phone2 = txtAddress(10).Text

    'Set Phone3 field
    MyRecord.Phone3 = txtAddress(11).Text

    'Set PhoneType1 field
    MyRecord.PhoneType1 = (cmbPhoneType(1).ListIndex)

    'Set PhoneType2 field
    MyRecord.PhoneType2 = (cmbPhoneType(2).ListIndex)

    'Set PhoneType3 field
    MyRecord.PhoneType3 = (cmbPhoneType(3).ListIndex)

End Sub

