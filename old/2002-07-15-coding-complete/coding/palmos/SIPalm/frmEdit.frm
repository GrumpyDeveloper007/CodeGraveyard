VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form frmNew 
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
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   240
      Left            =   1905
      OleObjectBlob   =   "frmEdit.frx":0000
      TabIndex        =   0
      Top             =   2160
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton btnSave 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":004B
      TabIndex        =   1
      Top             =   2160
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   0
      Left            =   600
      OleObjectBlob   =   "frmEdit.frx":0094
      TabIndex        =   2
      Top             =   0
      Width           =   855
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   1
      Left            =   1695
      OleObjectBlob   =   "frmEdit.frx":00EC
      TabIndex        =   3
      Top             =   0
      Width           =   690
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   2
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":0144
      TabIndex        =   4
      Top             =   225
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   3
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":019C
      TabIndex        =   5
      Top             =   435
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   4
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":01F4
      TabIndex        =   6
      Top             =   630
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   5
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":024C
      TabIndex        =   7
      Top             =   840
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   6
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":02A4
      TabIndex        =   8
      Top             =   1065
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   7
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":02FC
      TabIndex        =   9
      Top             =   1305
      Width           =   600
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   8
      Left            =   1695
      OleObjectBlob   =   "frmEdit.frx":0354
      TabIndex        =   10
      Top             =   1305
      Width           =   690
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   9
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":03AC
      TabIndex        =   11
      Top             =   1530
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   10
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":0404
      TabIndex        =   12
      Top             =   1755
      Width           =   1665
   End
   Begin IngotTextBoxCtl.AFTextBox txtAddress 
      Height          =   180
      Index           =   11
      Left            =   720
      OleObjectBlob   =   "frmEdit.frx":045C
      TabIndex        =   13
      Top             =   1950
      Width           =   1665
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":04B4
      TabIndex        =   14
      Top             =   660
      Width           =   690
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":04FD
      TabIndex        =   15
      Top             =   1740
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblName 
      Height          =   180
      Left            =   15
      OleObjectBlob   =   "frmEdit.frx":0546
      TabIndex        =   16
      Top             =   15
      Width           =   525
   End
   Begin IngotLabelCtl.AFLabel lblCompany 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":058C
      TabIndex        =   17
      Top             =   225
      Width           =   690
   End
   Begin IngotLabelCtl.AFLabel lblFirstInitial 
      Height          =   180
      Left            =   1515
      OleObjectBlob   =   "frmEdit.frx":05D4
      TabIndex        =   18
      Top             =   15
      Width           =   150
   End
   Begin IngotLabelCtl.AFLabel lblTitle 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":0617
      TabIndex        =   19
      Top             =   450
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel lablAddress 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":065D
      TabIndex        =   20
      Top             =   870
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel lblCity 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":06A5
      TabIndex        =   21
      Top             =   1095
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel lblState 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":06EA
      TabIndex        =   22
      Top             =   1305
      Width           =   675
   End
   Begin IngotLabelCtl.AFLabel lblZip 
      Height          =   180
      Index           =   1
      Left            =   1410
      OleObjectBlob   =   "frmEdit.frx":0731
      TabIndex        =   23
      Top             =   1305
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel lblCountry 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":0775
      TabIndex        =   24
      Top             =   1515
      Width           =   675
   End
   Begin IngotComboBoxCtl.AFComboBox cmbPhoneType 
      Height          =   240
      Index           =   3
      Left            =   0
      OleObjectBlob   =   "frmEdit.frx":07BE
      TabIndex        =   25
      Top             =   1920
      Width           =   690
   End
End
Attribute VB_Name = "frmNew"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim NewRecord As tAddressRec


Private Sub btnSave_Click()
    Dim NewRecord As tAddressRec
    Dim NewRecSize As Long
    Dim RecIndex As Long

    If bNewRecord = True Then
        RecIndex = 0

        ' Set record fields
        SetRecordFields NewRecord

        ' Get the record size
        NewRecSize = CalculateRecordSize(NewRecord)
        Debug.Print "NewRecSize=" & CStr(NewRecSize)

        ' Create the a new record that is a copy to the one read above
        ' Write it and commit it to the database
        PDBCreateRecord AddressDB, NewRecSize
        WriteAddressRecord NewRecord
        PDBUpdateRecord AddressDB

    End If

    Me.Hide
    Unload frmNew
    frmMain.Initialize
    frmMain.Show
End Sub

Private Sub CMDCancel_Click()
'    Me.Hide
'    Unload frmNew
'    Load frmMain
    frmMain.Show
End Sub

Private Sub Form_Load()
    Call Initialize
End Sub
Private Sub Initialize()
    'Fill the combobox
    FillComboBox
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
    MyRecord.PhoneType1 = CByte(cmbPhoneType(1).ListIndex)

    'Set PhoneType2 field
    MyRecord.PhoneType2 = (cmbPhoneType(2).ListIndex)

    'Set PhoneType3 field
    MyRecord.PhoneType3 = (cmbPhoneType(3).ListIndex)
End Sub

Private Sub txtAddress_Change(Index As Integer)
    ' Set text fields to the current
    
    NewRecord.Name = txtAddress(0).Text
    NewRecord.FirstName = txtAddress(1).Text
    NewRecord.Company = txtAddress(2).Text
    NewRecord.Title = txtAddress(3).Text
    NewRecord.Phone1 = txtAddress(4).Text
    NewRecord.Address = txtAddress(5).Text
    NewRecord.City = txtAddress(6).Text
    NewRecord.State = txtAddress(7).Text
    NewRecord.ZipCode = txtAddress(8).Text
    NewRecord.Country = txtAddress(9).Text
    NewRecord.Phone2 = txtAddress(10).Text
    NewRecord.Phone3 = txtAddress(11).Text
End Sub

Private Sub DisplayDetailRecord(MyRecord As tAddressRec)
    ' Display record information
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


Private Sub FillComboBox()
    Dim IntCounter As Integer

    ' Add the same values for each combobox
    For IntCounter = 1 To 3
        cmbPhoneType(IntCounter).AddItem "Work", 0
        cmbPhoneType(IntCounter).AddItem "Home", 1
        cmbPhoneType(IntCounter).AddItem "Fax", 2
        cmbPhoneType(IntCounter).AddItem "Other", 3
        cmbPhoneType(IntCounter).AddItem "Email", 4
        cmbPhoneType(IntCounter).AddItem "Main", 5
        cmbPhoneType(IntCounter).AddItem "Pager", 6
        cmbPhoneType(IntCounter).AddItem "Mobile", 7
        cmbPhoneType(IntCounter).ListIndex = 0
    Next
End Sub


