VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#11.0#0"; "TxtBox.ocx"
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#3.0#0"; "Flp32a30.ocx"
Begin VB.Form FRMConfigEmployee 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Config Employee"
   ClientHeight    =   6015
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6285
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6015
   ScaleWidth      =   6285
   Begin LpLib.fpList GRDEmployee 
      Height          =   3225
      Left            =   0
      TabIndex        =   6
      Top             =   2280
      Width           =   6255
      _Version        =   196608
      _ExtentX        =   11033
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
      ColDesigner     =   "FRMConfigEmployee.frx":0000
   End
   Begin VB.OptionButton OPTEmployeeType 
      Caption         =   "Painter/ Panel Engineer"
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
      Left            =   1680
      TabIndex        =   13
      Top             =   1980
      Width           =   2655
   End
   Begin VB.OptionButton OPTEmployeeType 
      Caption         =   "Painter"
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
      Left            =   1680
      TabIndex        =   5
      Top             =   1680
      Width           =   1695
   End
   Begin VB.OptionButton OPTEmployeeType 
      Caption         =   "Panel Engineer"
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
      Left            =   1680
      TabIndex        =   4
      Top             =   1380
      Width           =   1815
   End
   Begin VB.OptionButton OPTEmployeeType 
      Caption         =   "Estimator"
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
      Left            =   1680
      TabIndex        =   3
      Top             =   1080
      Width           =   1215
   End
   Begin VB.OptionButton OPTEmployeeType 
      Caption         =   "Engineer"
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
      Left            =   1680
      TabIndex        =   2
      Top             =   780
      Value           =   -1  'True
      Width           =   1215
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   5160
      TabIndex        =   10
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   3720
      TabIndex        =   9
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDDelete 
      Caption         =   "Delete"
      Height          =   375
      Left            =   2280
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
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   285
      Left            =   1680
      TabIndex        =   0
      Top             =   0
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
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTShortName 
      Height          =   285
      Left            =   1680
      TabIndex        =   1
      Top             =   420
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
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Short Name"
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
      Left            =   240
      TabIndex        =   12
      Top             =   420
      Width           =   1335
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
      Index           =   14
      Left            =   240
      TabIndex        =   11
      Top             =   0
      Width           =   1335
   End
End
Attribute VB_Name = "FRMConfigEmployee"
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
    Dim VatPercent As String
    Dim NetCost As String
    Dim SaveIndex As Long
        
    vUid = -1
    CMDAddNew.Caption = "Add New"
    TXTName.Text = ""
    TXTShortName.Text = ""
    OPTEmployeeType(0).Value = True
    
    If (OpenRecordset(rstemp, "SELECT * FROM Employee ORDER BY [Name]", dbOpenSnapshot)) Then
        SaveIndex = GRDEmployee.TopIndex
        Call GRDEmployee.Clear
        If (rstemp.EOF = False) Then
            Do While (rstemp.EOF = False)
                Call GRDEmployee.AddItem(rstemp!Uid & vbTab & rstemp!Name & vbTab & rstemp!shortName & vbTab & rstemp!EmployeeTypeID)
                Call rstemp.MoveNext
            Loop
        End If
        Call rstemp.Close
        GRDEmployee.TopIndex = SaveIndex
    End If
    Call TXTName.SetFocus
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
    Dim rstemp As Recordset
    Dim i As Long
    If (OpenRecordset(rstemp, "Employee", dbOpenTable)) Then
        TXTName.MaxLength = GetFieldSize(rstemp, "name")
        TXTShortName.MaxLength = GetFieldSize(rstemp, "shortname")
    End If
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
    Dim EmployeeTypeID As Long
    Dim EmployeeTypeShort As String
    If (OPTEmployeeType(0).Value = True) Then
        EmployeeTypeID = 0
        EmployeeTypeShort = ""
    Else
        If (OPTEmployeeType(1).Value = True) Then
            EmployeeTypeID = 1
            EmployeeTypeShort = "ES"
        Else
            If (OPTEmployeeType(2).Value = True) Then
                EmployeeTypeID = 2
                EmployeeTypeShort = "PL"
            Else
                If (OPTEmployeeType(3).Value = True) Then
                    EmployeeTypeID = 3
                    EmployeeTypeShort = "PM"
                Else
                    If (OPTEmployeeType(4).Value = True) Then
                        EmployeeTypeID = 4
                        EmployeeTypeShort = "PP"
                    Else
                        EmployeeTypeID = 5
                    End If
                End If
            End If
        End If
    End If
    
    If (TXTName.Text <> "") Then
        If (vUid > 0) Then
            ' update
            If (Execute("UPDATE Employee Set [name]=" & cTextField & Trim$(TXTName.Text) & cTextField & ", ShortName=" & cTextField & Trim$(TXTShortName.Text) & cTextField & ", employeetypeID=" & EmployeeTypeID & ", EmployeeTypeShort=" & cTextField & Trim$(EmployeeTypeShort) & cTextField & " WHERE UID=" & vUid) > 0) Then
                vDataChanged = True
                Call ClearDetails
            End If
        Else
            ' add new
            If (Execute("INSERT INTO Employee (Name,shortname,employeetypeid,EmployeeTypeShort) VALUES (" & cTextField & Trim$(TXTName.Text) & cTextField & "," & cTextField & Trim$(TXTShortName.Text) & cTextField & "," & EmployeeTypeID & "," & cTextField & EmployeeTypeShort & cTextField & ")") > 0) Then
                vDataChanged = True
                Call ClearDetails
            End If
        End If
    Else
        Call Messagebox("Employee must have a name.", vbInformation)
    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDDelete_Click()
    If (GRDEmployee.ListIndex >= 0) Then
        GRDEmployee.Col = 0
        If (Execute("DELETE FROM Employee WHERE UID=" & GRDEmployee.ColText) > 0) Then
            vDataChanged = True
            Call GRDEmployee.RemoveItem(GRDEmployee.ListIndex)
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
        Call Execute("DELETE * FROM InspEng", True)
        Call Execute("INSERT INTO inspEng SELECT UID,[Name],ShortName,employeeTypeShort AS [Type] FROM Employee", True)
        Call Execute("UPDATE InspFlags SET UpdateEngineer=True", True)
    End If
End Sub

''
Private Sub GRDEmployee_Click()
    If (GRDEmployee.ListIndex >= 0) Then
        ' Load item
        GRDEmployee.Col = 0
        vUid = GRDEmployee.ColText
        GRDEmployee.Col = 1
        TXTName.Text = GRDEmployee.ColText
        GRDEmployee.Col = 2
        TXTShortName.Text = GRDEmployee.ColText
        GRDEmployee.Col = 3
        OPTEmployeeType(GRDEmployee.ColText).Value = True
        CMDAddNew.Caption = "Update"
    End If
End Sub
