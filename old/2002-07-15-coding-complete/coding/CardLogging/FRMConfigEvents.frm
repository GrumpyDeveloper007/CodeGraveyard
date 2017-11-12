VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMConfigEvents 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Event Config"
   ClientHeight    =   5985
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7320
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   399
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   488
   Begin LpLib.fpList GRDEvent 
      Height          =   3225
      Left            =   0
      TabIndex        =   6
      Top             =   2220
      Width           =   7215
      _Version        =   196608
      _ExtentX        =   12726
      _ExtentY        =   5689
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
      ColDesigner     =   "FRMConfigEvents.frx":0000
   End
   Begin VB.OptionButton OPTAction 
      Caption         =   "End"
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
      Index           =   1
      Left            =   3360
      TabIndex        =   5
      Top             =   840
      Width           =   735
   End
   Begin VB.OptionButton OPTAction 
      Caption         =   "Start"
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
      Index           =   0
      Left            =   3360
      TabIndex        =   4
      Top             =   420
      Value           =   -1  'True
      Width           =   735
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   6120
      TabIndex        =   10
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   4680
      TabIndex        =   9
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   3240
      TabIndex        =   8
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDAddNew 
      Caption         =   "<Add New>"
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   5580
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTEventType 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   0
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTEventSubType 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   360
      Width           =   615
      _ExtentX        =   1085
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
   Begin ELFTxtBox.TxtBox1 TXTAddress 
      Height          =   285
      Left            =   1680
      TabIndex        =   2
      Top             =   720
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTSubAddress 
      Height          =   285
      Left            =   1680
      TabIndex        =   3
      Top             =   1080
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Sub-Address"
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
      Left            =   0
      TabIndex        =   14
      Top             =   1080
      Width           =   1575
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
      Left            =   0
      TabIndex        =   13
      Top             =   720
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Event Sub Type"
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
      TabIndex        =   12
      Top             =   360
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Event Type"
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
      Left            =   240
      TabIndex        =   11
      Top             =   0
      Width           =   1335
   End
End
Attribute VB_Name = "FRMConfigEvents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Employee Config Object
''
'' Coded by Dale Pitman

Private vUid As Long
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
    Dim rstemp2 As Recordset
    Dim VatPercent As String
    Dim NetCost As String
    Dim SaveIndex As Long
    
    Dim ActionName As String
        
    vUid = -1
    CMDAddNew.Caption = "Add New"
    TXTEventType.Text = ""
    TXTEventSubType.Text = ""
    OPTAction(0).Value = True
    TXTAddress.Text = ""
    TXTSubAddress.Text = ""
    
    
    If (OpenRecordset(rstemp, "SELECT * FROM E_EventAction ", dbOpenSnapshot)) Then
        SaveIndex = GRDEvent.TopIndex
        Call GRDEvent.Clear
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                If (rstemp!action = 1) Then
                    ActionName = "Start"
                Else
                    ActionName = "End"
                End If
                Call GRDEvent.AddItem(rstemp!Uid & vbTab & rstemp!eventtype & vbTab & rstemp!eventsubtype & vbTab & ActionName & vbTab & rstemp!address & vbTab & rstemp!subaddress)
                Call rstemp.MoveNext
            Loop
        End If
        Call rstemp.Close
        GRDEvent.TopIndex = SaveIndex
    End If
    Call TXTEventType.SetFocus
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
'    If (OpenRecordset(rstemp, "E_EventAction", dbOpenTable)) Then
'        TXTName.MaxLength = GetFieldSize(rstemp, "name")
'    End If
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
    Dim EmployeeTypeID As Long
    Dim action As Long
    
    If (OPTAction(0).Value = True) Then
        action = 1
    Else
        action = 2
    End If
'    If (TXTName.Text <> "") Then
        If (vUid > 0) Then
            ' update
            If (Execute("UPDATE E_EventAction Set [eventtype]=" & Trim$(TXTEventType.Text) & ", [eventsubtype]=" & Val(TXTEventSubType.Text) & ", [action]=" & action & ", [Address]=" & Val(TXTAddress.Text) & ", [SubAddress]=" & Val(TXTSubAddress.Text) & " WHERE UID=" & vUid) > 0) Then
                vDataChanged = True
                Call ClearDetails
            End If
        Else
            ' add new
            If (Execute("INSERT INTO E_EventAction (eventtype,eventsubtype,[action],[Address],[SubAddress]) VALUES (" & Val(TXTEventType.Text) & "," & Val(TXTEventSubType.Text) & "," & action & "," & Val(TXTAddress.Text) & "," & Val(TXTSubAddress.Text) & ")") > 0) Then
                vDataChanged = True
                Call ClearDetails
            End If
        End If
'    Else
'    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDelete_Click()
    If (GRDEvent.ListIndex >= 0) Then
        GRDEvent.Col = 0
        If (Execute("DELETE FROM E_EventAction WHERE UID=" & GRDEvent.ColText) > 0) Then
            vDataChanged = True
            Call GRDEvent.RemoveItem(GRDEvent.ListIndex)
        End If
    End If
End Sub

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
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
'    Call ClearDetails
    Me.Show
    Call ClearDetails
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
    
    If (vDataChanged = True) Then
        ' Update Palm Database
    End If
End Sub

''
Private Sub GRDEvent_Click()
    If (GRDEvent.ListIndex >= 0) Then
        ' Load item
        GRDEvent.Col = 0
        vUid = GRDEvent.ColText
        GRDEvent.Col = 1
        TXTEventType.Text = GRDEvent.ColText
        GRDEvent.Col = 2
        TXTEventSubType.Text = GRDEvent.ColText
        GRDEvent.Col = 3
        If (GRDEvent.ColText = "Start") Then
            OPTAction(0).Value = True
        Else
            OPTAction(1).Value = True
        End If
        GRDEvent.Col = 4
        TXTAddress.Text = GRDEvent.ColText
        GRDEvent.Col = 5
        TXTSubAddress.Text = GRDEvent.ColText
        CMDAddNew.Caption = "Update"
    End If
End Sub


