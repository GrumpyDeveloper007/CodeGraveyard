VERSION 5.00
Object = "{447880A9-6A37-43B3-A92E-F125FFBE2493}#2.0#0"; "IngotGridCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMMain 
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
   Begin IngotGridCtl.AFGrid GRDParts 
      Height          =   555
      Left            =   0
      OleObjectBlob   =   "Main.frx":0000
      TabIndex        =   0
      Top             =   1200
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLMake 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":0046
      TabIndex        =   1
      Top             =   240
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLName 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":009B
      TabIndex        =   2
      Top             =   0
      Width           =   2175
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   255
      Left            =   1770
      OleObjectBlob   =   "Main.frx":00ED
      TabIndex        =   3
      Top             =   2130
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDNewPart 
      Height          =   255
      Left            =   870
      OleObjectBlob   =   "Main.frx":0136
      TabIndex        =   4
      Top             =   2130
      Width           =   735
   End
   Begin IngotButtonCtl.AFButton CMDShowCosts 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "Main.frx":0183
      TabIndex        =   5
      Top             =   2130
      Width           =   855
   End
   Begin IngotButtonCtl.AFButton CMDAdditionalCost 
      Height          =   255
      Left            =   1800
      OleObjectBlob   =   "Main.frx":01D2
      TabIndex        =   6
      Top             =   1800
      Visible         =   0   'False
      Width           =   735
   End
   Begin IngotLabelCtl.AFLabel LBLModel 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":0221
      TabIndex        =   7
      Top             =   480
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLColour 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":0278
      TabIndex        =   8
      Top             =   960
      Width           =   2295
   End
   Begin IngotLabelCtl.AFLabel LBLYear 
      Height          =   195
      Left            =   0
      OleObjectBlob   =   "Main.frx":02D1
      TabIndex        =   9
      Top             =   720
      Width           =   2295
   End
   Begin IngotButtonCtl.AFButton CMDCustomer 
      Height          =   255
      Left            =   -120
      OleObjectBlob   =   "Main.frx":0326
      TabIndex        =   10
      Top             =   1800
      Visible         =   0   'False
      Width           =   855
   End
End
Attribute VB_Name = "FRMMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Public Sub refreshGRD()
    Dim i As Integer
    GRDParts.Rows = 0
    For i = 0 To MaxPartIndex
        Call GRDParts.AddItem(PartName(i) & vbTab & Description(i))
    Next
End Sub

Private Sub copyrecords()
    Dim db As Database
    Dim i As Long
    Set db = DBEngine.OpenDatabase("parts.mdb", False, False)
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Set rstemp = db.OpenRecordset("SELECT * FROM partscsfima", dbOpenDynaset)
    Set rstemp2 = db.OpenRecordset("SELECT * FROM PDAIMA1", dbOpenDynaset)
    For i = 0 To 65000
        rstemp2.AddNew
        rstemp2!mancode = rstemp!mancode
        rstemp2!partnumber = rstemp!partnumber
        rstemp2!partDescription = rstemp!partDescription
        rstemp2!replacementpartnumber = rstemp!replacementpartnumber
        rstemp2!retailprice1 = rstemp!retailprice1
        rstemp2!retailprice2 = rstemp!retailprice2
        rstemp2!retailprice3 = rstemp!retailprice3
        rstemp2!retailprice4 = rstemp!retailprice4
        rstemp2!retailprice5 = rstemp!retailprice5
        rstemp2!retaildate1 = rstemp!retaildate1
        rstemp2!retaildate2 = rstemp!retaildate2
        rstemp2!retaildate3 = rstemp!retaildate3
        rstemp2!retaildate4 = rstemp!retaildate4
        rstemp2!retaildate5 = rstemp!retaildate5
        rstemp2.Update
        rstemp.MoveNext
    Next
    
    Set rstemp2 = db.OpenRecordset("SELECT * FROM PDAIMA2", dbOpenDynaset)
    For i = 0 To 65000
        rstemp2.AddNew
        rstemp2!mancode = rstemp!mancode
        rstemp2!partnumber = rstemp!partnumber
        rstemp2!partDescription = rstemp!partDescription
        rstemp2!replacementpartnumber = rstemp!replacementpartnumber
        rstemp2!retailprice1 = rstemp!retailprice1
        rstemp2!retailprice2 = rstemp!retailprice2
        rstemp2!retailprice3 = rstemp!retailprice3
        rstemp2!retailprice4 = rstemp!retailprice4
        rstemp2!retailprice5 = rstemp!retailprice5
        rstemp2!retaildate1 = rstemp!retaildate1
        rstemp2!retaildate2 = rstemp!retaildate2
        rstemp2!retaildate3 = rstemp!retaildate3
        rstemp2!retaildate4 = rstemp!retaildate4
        rstemp2!retaildate5 = rstemp!retaildate5
        rstemp2.Update
        rstemp.MoveNext
    Next
    
    Set rstemp2 = db.OpenRecordset("SELECT * FROM PDAIMA3", dbOpenDynaset)
    For i = 0 To 65000
        rstemp2.AddNew
        rstemp2!mancode = rstemp!mancode
        rstemp2!partnumber = rstemp!partnumber
        rstemp2!partDescription = rstemp!partDescription
        rstemp2!replacementpartnumber = rstemp!replacementpartnumber
        rstemp2!retailprice1 = rstemp!retailprice1
        rstemp2!retailprice2 = rstemp!retailprice2
        rstemp2!retailprice3 = rstemp!retailprice3
        rstemp2!retailprice4 = rstemp!retailprice4
        rstemp2!retailprice5 = rstemp!retailprice5
        rstemp2!retaildate1 = rstemp!retaildate1
        rstemp2!retaildate2 = rstemp!retaildate2
        rstemp2!retaildate3 = rstemp!retaildate3
        rstemp2!retaildate4 = rstemp!retaildate4
        rstemp2!retaildate5 = rstemp!retaildate5
        rstemp2.Update
        rstemp.MoveNext
    Next
    
    Set rstemp2 = db.OpenRecordset("SELECT * FROM PDAIMA4", dbOpenDynaset)
    For i = 0 To 65000
        rstemp2.AddNew
        rstemp2!mancode = rstemp!mancode
        rstemp2!partnumber = rstemp!partnumber
        rstemp2!partDescription = rstemp!partDescription
        rstemp2!replacementpartnumber = rstemp!replacementpartnumber
        rstemp2!retailprice1 = rstemp!retailprice1
        rstemp2!retailprice2 = rstemp!retailprice2
        rstemp2!retailprice3 = rstemp!retailprice3
        rstemp2!retailprice4 = rstemp!retailprice4
        rstemp2!retailprice5 = rstemp!retailprice5
        rstemp2!retaildate1 = rstemp!retaildate1
        rstemp2!retaildate2 = rstemp!retaildate2
        rstemp2!retaildate3 = rstemp!retaildate3
        rstemp2!retaildate4 = rstemp!retaildate4
        rstemp2!retaildate5 = rstemp!retaildate5
        rstemp2.Update
        rstemp.MoveNext
    Next
    
    Set rstemp2 = db.OpenRecordset("SELECT * FROM PDAIMA5", dbOpenDynaset)
    For i = 0 To 65000
        rstemp2.AddNew
        rstemp2!mancode = rstemp!mancode
        rstemp2!partnumber = rstemp!partnumber
        rstemp2!partDescription = rstemp!partDescription
        rstemp2!replacementpartnumber = rstemp!replacementpartnumber
        rstemp2!retailprice1 = rstemp!retailprice1
        rstemp2!retailprice2 = rstemp!retailprice2
        rstemp2!retailprice3 = rstemp!retailprice3
        rstemp2!retailprice4 = rstemp!retailprice4
        rstemp2!retailprice5 = rstemp!retailprice5
        rstemp2!retaildate1 = rstemp!retaildate1
        rstemp2!retaildate2 = rstemp!retaildate2
        rstemp2!retaildate3 = rstemp!retaildate3
        rstemp2!retaildate4 = rstemp!retaildate4
        rstemp2!retaildate5 = rstemp!retaildate5
        rstemp2.Update
        rstemp.MoveNext
    Next
    
End Sub


Private Sub AFButton3_Click()

End Sub

Private Sub CMDExit_Click()
    End
End Sub

Private Sub CMDNewPart_Click()
    Call FRMSelectPart.Show
    FRMSelectPart.TXTPart.SetFocus
End Sub

Private Sub CMDShowCosts_Click()
    Call FRMSummary.Show
End Sub

Private Sub Form_Load()
    Dim Reply As Boolean
'    Call copyrecords
'    Call OpenPartsDatabase
'    Call PDBSetSort(dbParts, tPartsDatabaseFields.ShortName_Field)
    
'    Call OpenParamDatabase
    
'    ParamRecord.pName = "MODEL"
'    ParamRecord.pValue = "Fiesta"
'    Call PDBCreateRecordBySchema(dbParam)
'    Call PDBWriteRecord(dbParam, VarPtr(ParamRecord))
'    Call PDBUpdateRecord(dbParam)
'    Call PDBMoveFirst(dbParam)


    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbHourglass
    #End If
    
    #If APPFORGE Then
    #Else
    Screen.MousePointer = vbDefault
    #End If
    
'    PartsRecord.LongName = "longname"
'    PartsRecord.ShortName = "test"
'    Call PDBCreateRecordBySchema(dbParts)
'    Reply = PDBWriteRecord(dbParts, VarPtr(PartsRecord))
'    Call PDBUpdateRecord(dbParts)
'    MsgBox "ReadRecord Error = " & CStr(PDBGetLastError(dbParts))
    'read data
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim i As Long
    i = i
End Sub
