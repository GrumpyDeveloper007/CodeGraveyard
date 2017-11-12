VERSION 5.00
Object = "{67397AA1-7FB1-11D0-B148-00A0C922E820}#6.0#0"; "MSADODC.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form FRMDatabaseView 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Database View"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   HelpContextID   =   800
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   486
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   779
   Begin VB.CommandButton CMDPrint 
      Caption         =   "Print"
      Height          =   375
      Left            =   1440
      TabIndex        =   8
      Top             =   6900
      Width           =   1095
   End
   Begin VB.ComboBox cboTableName 
      Height          =   315
      Left            =   1800
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   0
      Width           =   9855
   End
   Begin MSAdodcLib.Adodc ADOControl 
      Height          =   435
      Left            =   7560
      Top             =   1560
      Visible         =   0   'False
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   767
      ConnectMode     =   0
      CursorLocation  =   3
      IsolationLevel  =   -1
      ConnectionTimeout=   15
      CommandTimeout  =   30
      CursorType      =   3
      LockType        =   3
      CommandType     =   1
      CursorOptions   =   0
      CacheSize       =   50
      MaxRecords      =   0
      BOFAction       =   0
      EOFAction       =   0
      ConnectStringType=   1
      Appearance      =   1
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Orientation     =   0
      Enabled         =   -1
      Connect         =   ""
      OLEDBString     =   ""
      OLEDBFile       =   ""
      DataSourceName  =   ""
      OtherAttributes =   ""
      UserName        =   ""
      Password        =   ""
      RecordSource    =   ""
      Caption         =   "Adodc1"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      _Version        =   393216
   End
   Begin VB.TextBox txtSQL 
      Height          =   855
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   5
      Top             =   360
      Width           =   11655
   End
   Begin VB.CommandButton CMDOpen 
      Caption         =   "Open"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   6900
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   7680
      TabIndex        =   3
      Top             =   6900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   9120
      TabIndex        =   2
      Top             =   6900
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   10560
      TabIndex        =   1
      Top             =   6900
      Width           =   1095
   End
   Begin MSDataGridLib.DataGrid GRDGrid 
      Bindings        =   "FRMDatabaseView.frx":0000
      Height          =   5415
      Left            =   0
      TabIndex        =   7
      Top             =   1380
      Width           =   11655
      _ExtentX        =   20558
      _ExtentY        =   9551
      _Version        =   393216
      HeadLines       =   1
      RowHeight       =   15
      BeginProperty HeadFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColumnCount     =   2
      BeginProperty Column00 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
      EndProperty
      BeginProperty Column01 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   2057
            SubFormatType   =   0
         EndProperty
      EndProperty
      SplitCount      =   1
      BeginProperty Split0 
         BeginProperty Column00 
         EndProperty
         BeginProperty Column01 
         EndProperty
      EndProperty
   End
   Begin VB.Label LBLZ1 
      BackStyle       =   0  'Transparent
      Caption         =   "SQL Statement"
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
      TabIndex        =   0
      Top             =   120
      Width           =   2055
   End
End
Attribute VB_Name = "FRMDatabaseView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' <Sample> Object
''
'' Coded by Dale Pitman - PyroDesign

Private vUid As Long
'' Search criteria(Input Parameters)


'' Output parameters
'Private vPartid As Long ' *This is a sample parameter


''
'Private vShiftStatus As Boolean ' True=down

Private printerobject As New FRMSPrinterForm


''
'Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean
Private vQuestionAsked As Boolean

Private vDataChanged As Boolean

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

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
    Dim rstemp As Recordset
    Dim VatPercent As String
    Dim NetCost As String
    Dim SaveIndex As Long
        
    
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

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
End Sub

Private Sub cboTableName_Click()
    txtSQL.Text = "SELECT * FROM [" & cboTableName.List(cboTableName.ListIndex) & "]"
    Call CMDOpen_Click
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDelete_Click()
End Sub

Private Sub cmdExecuteStatement_Click()

End Sub

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Unload(Me)
    Call AllFormsHide(Me)
End Sub

Private Sub CMDOpen_Click()
    On Error GoTo failed
    ADOControl.RecordSource = txtSQL.Text
    Call ADOControl.Refresh
    Exit Sub
failed:
End Sub

Private Sub CMDPrint_Click()
    Dim sql As String
    Screen.MousePointer = vbHourglass
    Call printerobject.Initialize
    
    sql = txtSQL.Text
'    If (optScreen.Value = True) Then
        Call printerobject.PreviewSQL(sql, "Customer Export Report")
'    Else
'        Call printerobject.PrintSQL(sql, "Customer Export Report")
'    End If
    
    Screen.MousePointer = vbDefault
End Sub

Private Sub Form_Activate()
    If (vQuestionAsked = False) Then
        vQuestionAsked = True
        If (Messagebox("WARNING: This screen should only be used if you know what you are doing. Using it incorrectly could cause " & cProjectName & " to stop working. Continue ?", vbExclamation + vbYesNo) = vbNo) Then
            Call Unload(Me)
            vQuestionAsked = False
        Else
            vQuestionAsked = True
        End If
    End If
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    vQuestionAsked = False
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    
    ADOControl.ConnectionString = db.ConnectionString
    txtSQL.Text = GetServerSetting("SQLSTRING", False)

    Call GetTablesCBO(cboTableName, False)


'    Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    Call SetupFieldSizes
    Call ClearDetails
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call SetServerSetting("SQLSTRING", txtSQL.Text)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
   
End Sub

