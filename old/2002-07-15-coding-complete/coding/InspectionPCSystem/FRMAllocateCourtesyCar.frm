VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#1.0#0"; "TxtBox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMAllocateCourtesyCar 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   486
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   779
   Begin VB.PictureBox PICSelection 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H80000008&
      Height          =   315
      Left            =   3840
      ScaleHeight     =   285
      ScaleWidth      =   1665
      TabIndex        =   9
      Top             =   1380
      Visible         =   0   'False
      Width           =   1695
   End
   Begin VB.Timer SelectionTimer 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   8640
      Top             =   660
   End
   Begin VB.CheckBox CHKOnlyShowAvailible 
      Caption         =   "Only Show Availible"
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
      Left            =   9480
      TabIndex        =   8
      Top             =   60
      Width           =   2055
   End
   Begin VB.PictureBox PICAvailibility 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00C0C0C0&
      FillColor       =   &H00808080&
      ForeColor       =   &H80000008&
      Height          =   210
      Index           =   0
      Left            =   2280
      ScaleHeight     =   12
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   623
      TabIndex        =   5
      Top             =   900
      Width           =   9375
   End
   Begin ELFDateControl.DateControl TXTMapStartDate 
      Height          =   615
      Left            =   1920
      TabIndex        =   3
      Top             =   6660
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
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   10560
      TabIndex        =   2
      Top             =   6900
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTDays 
      Height          =   285
      Left            =   5040
      TabIndex        =   0
      Top             =   6900
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
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   1440
      TabIndex        =   10
      Top             =   0
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
   Begin ELFDateControl.DateControl TXTEndDate 
      Height          =   615
      Left            =   4560
      TabIndex        =   11
      Top             =   0
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
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Date"
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
      Left            =   0
      TabIndex        =   13
      Top             =   300
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "End Date"
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
      Left            =   3120
      TabIndex        =   12
      Top             =   300
      Width           =   1335
   End
   Begin VB.Label LBLLegend 
      BackStyle       =   0  'Transparent
      Caption         =   "<Legend>"
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
      Left            =   2280
      TabIndex        =   7
      Top             =   660
      Width           =   975
   End
   Begin VB.Label LBLVehicleDescription 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "<Vehicle Description>"
      Height          =   255
      Index           =   0
      Left            =   120
      TabIndex        =   6
      Top             =   900
      Width           =   2055
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Days"
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
      Left            =   4320
      TabIndex        =   4
      Top             =   6960
      Width           =   615
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Date"
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
      Left            =   480
      TabIndex        =   1
      Top             =   6960
      Width           =   1335
   End
End
Attribute VB_Name = "FRMAllocateCourtesyCar"
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

Private vCourtesyIDs(10000) As Long
Private vSelectedIndex As Long
Private vDaySizeInt As Long


Private Const cPageMax = 30
Private Const cBoxYModulo = -1
Private Const cInUseJob = &HCF
Private Const cBackSplitLine = &H808080
Private vInUSe() As INUseType
'' Search criteria(Input Parameters)

Private Type INUseType
    InUSe As Boolean
    JobNumber As Long
End Type
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

Private Sub UpdateMap()
    Call GenerateBar(TXTMapStartDate.Text, DateAdd("d", TXTDays.Text, TXTMapStartDate.Text))
    Call EnableSelector
End Sub


Private Sub EnableSelector()
    PICSelection.Top = PICAvailibility(vSelectedIndex).Top
    PICSelection.Height = PICAvailibility(vSelectedIndex).Height
    PICSelection.Width = vDaySizeInt * DateDiff("d", TXTStartDate.Text, TXTEndDate.Text) + 1
    PICSelection.Left = PICAvailibility(vSelectedIndex).Left + DateDiff("d", TXTMapStartDate.Text, TXTStartDate.Text) * vDaySizeInt + 1
    PICSelection.Visible = True
    Call PICSelection.ZOrder
    SelectionTimer.Enabled = True
End Sub

Private Function GetIndexFromID(pUID As Long) As Long
    Dim i As Long
    GetIndexFromID = -1
    For i = 0 To cPageMax - 1
        If (vCourtesyIDs(i) = pUID) Then
            GetIndexFromID = i
            Exit For
        End If
    Next
End Function

Private Sub LoadScreen()
    Dim rstemp As Recordset
    Dim rsCourtesy As Recordset
    Dim i As Long
    Dim sql As String
    Dim Availible As Boolean
    
    i = 0
    If (CHKOnlyShowAvailible.Value = vbChecked) Then
        sql = "SELECT * FROM CourtesyCar"
    Else
        sql = "SELECT * FROM CourtesyCar"
    End If
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
        
            Do While (rstemp.EOF = False)
            
                If (CHKOnlyShowAvailible.Value = vbChecked) Then
                    If (i < cPageMax) Then
'                        sql = "SELECT * FROM CourtesyAllocate c WHERE CourtesyCarID=" & rstemp!Uid & " AND"
'                        sql = sql & "( c.EndDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar
'                        sql = sql & " OR c.startDate<=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar & ")"
                        sql = "SELECT * FROM CourtesyAllocate c WHERE CourtesyCarID=" & rstemp!Uid
                        sql = sql & " AND ( (c.EndDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND c.startDate<=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar
                        sql = sql & " ) OR (c.startDate<=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar & " AND c.endDate>=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar & ")"
                        sql = sql & " OR (c.startDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND c.endDate<=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar & ")"
                        sql = sql & ") "
                        If (OpenRecordset(rsCourtesy, sql, dbOpenSnapshot)) Then
                            If (rsCourtesy.EOF = False) Then
                                Availible = False
                            Else
                                Availible = True
                            End If
                        End If
                    End If
                Else
                    Availible = True
                End If

            
                If (Availible = True) Then
                    If (i < cPageMax) Then
                        If (i > PICAvailibility.Count - 1) Then
                            Load PICAvailibility(i)
                            Load LBLVehicleDescription(i)
                            
                            PICAvailibility(i).Top = PICAvailibility(i - 1).Top + PICAvailibility(i - 1).Height + cBoxYModulo
                            LBLVehicleDescription(i).Top = PICAvailibility(i).Top
                            
                        End If
                        LBLVehicleDescription(i).Caption = rstemp!Name & ":" & rstemp!Reg
                        PICAvailibility(i).Visible = True
                        LBLVehicleDescription(i).Visible = True
                    End If
                    vCourtesyIDs(rstemp!Uid) = i
                    vCourtesyIDs(i) = rstemp!Uid
                    i = i + 1
                End If
                Call rstemp.MoveNext
            Loop
            
            Do While (i <= PICAvailibility.Count - 1)
                PICAvailibility(i).Visible = False
                LBLVehicleDescription(i).Visible = False
                i = i + 1
            Loop
            
        End If
    
    End If

End Sub

Private Sub GenerateBar(pStartDate As Date, pEndDate As Date)
    Dim i As Long
    Dim t As Long
    Dim DaySize As Double
    Dim NumberOfDays As Long
    Dim tempdate As Date
    Dim rstemp As Recordset
    Dim sql As String
    Dim day As Long
    Dim LeftDate As Date
    Dim rightDate As Date
    
    Dim PreJobID As Long
    
    NumberOfDays = DateDiff("d", pStartDate, pEndDate)
    DaySize = PICAvailibility(t).ScaleWidth / NumberOfDays
    If (DaySize < 1) Then
        DaySize = 1
    End If
    vDaySizeInt = CLng(DaySize)
    ReDim vInUSe(PICAvailibility.Count - 1, NumberOfDays) As INUseType
    
    ' Make Legend
    tempdate = pStartDate
    For i = 0 To NumberOfDays - 1
        If (i > LBLLegend.Count - 1) Then
            Load LBLLegend(i)
        End If
        LBLLegend(i).Caption = Format(tempdate, "dd/mm")
        tempdate = DateAdd("d", 1, tempdate)
        LBLLegend(i).Left = PICAvailibility(0).Left + i * vDaySizeInt
        LBLLegend(i).Visible = True
    Next
    Do While (i <= LBLLegend.Count - 1)
        LBLLegend(i).Visible = False
        i = i + 1
    Loop
    
    
    ' Build InUseSample
'    sql = "SELECT * FROM CourtesyAllocate c WHERE " 'CourtesyCarID=" & rstemp!Uid
'    sql = sql & " ( (c.EndDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND c.EndDate<=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar
'    sql = sql & " ) OR (c.startDate>=" & cDateChar & Format(TXTStartDate.Text, "mm/dd/yyyy") & cDateChar & " AND c.startDate<=" & cDateChar & Format(TXTEndDate.Text, "mm/dd/yyyy") & cDateChar & ") ) "
    sql = "SELECT * FROM CourtesyAllocate c WHERE c.EndDate>=" & cDateChar & Format(pStartDate, "mm/dd/yyyy") & cDateChar & " OR c.startDate<=" & cDateChar & Format(pEndDate, "mm/dd/yyyy") & cDateChar
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        Do While (rstemp.EOF = False)
            If (rstemp!Startdate > pStartDate) Then
                LeftDate = rstemp!Startdate
            Else
                LeftDate = pStartDate
            End If
            If (rstemp!enddate < pEndDate) Then
                rightDate = rstemp!enddate
            Else
                rightDate = pEndDate
            End If
            For i = DateDiff("d", pStartDate, LeftDate) To DateDiff("d", pStartDate, rightDate)
                If (GetIndexFromID(rstemp!Courtesycarid) >= 0) Then
                    vInUSe(GetIndexFromID(rstemp!Courtesycarid), i).InUSe = True
                    vInUSe(GetIndexFromID(rstemp!Courtesycarid), i).JobNumber = rstemp!Jobid
                End If
            Next
            Call rstemp.MoveNext
        Loop
    End If
    
    ' Draw Information
    PreJobID = -1
    For t = 0 To PICAvailibility.Count - 1
        Call PICAvailibility(t).Cls
        For i = 0 To NumberOfDays
            If (vInUSe(t, i).InUSe = True) Then
                PICAvailibility(t).FillColor = &HFF
                PICAvailibility(t).Line (i * vDaySizeInt, 0)-((i + 1) * vDaySizeInt, PICAvailibility(t).ScaleHeight), cInUseJob, BF
                PICAvailibility(t).CurrentX = i * vDaySizeInt + 2
                PICAvailibility(t).CurrentY = 0
                If (PreJobID <> vInUSe(t, i).JobNumber) Then
                    PICAvailibility(t).Print vInUSe(t, i).JobNumber
                End If
            End If
            
            ' draw Scale Lines
            If (PreJobID <> vInUSe(t, i).JobNumber And i > 0) Then
                PICAvailibility(t).Line (i * vDaySizeInt, 0)-((i) * vDaySizeInt, PICAvailibility(t).ScaleHeight), &H0
            Else
                If (i > 0 And vInUSe(t, i).InUSe = False) Then
                    PICAvailibility(t).Line (i * vDaySizeInt, 0)-((i) * vDaySizeInt, PICAvailibility(t).ScaleHeight), cBackSplitLine
                End If
            End If
            
            
            PreJobID = vInUSe(t, i).JobNumber
        Next
    Next

End Sub



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

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub



Private Sub CHKOnlyShowAvailible_Click()
    Screen.MousePointer = vbHourglass
    Call LoadScreen
    Call UpdateMap
    Screen.MousePointer = vbDefault
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

    TXTStartDate.Text = "02/04/2002" ' Format(Now, "dd/mm/yyyy")
    TXTEndDate.Text = "04/04/2002" 'Format(DateAdd("d", 5, Now), "dd/mm/yyyy")
    TXTMapStartDate.Text = "01/04/2002" ' Format(Now, "dd/mm/yyyy")
    TXTDays.Text = 10

    Call LoadScreen
    Call UpdateMap
    
    Call SetupFieldSizes
    Call ClearDetails
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    SelectionTimer.Enabled = False
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
   
End Sub

Private Sub PICAvailibility_Click(Index As Integer)
    vSelectedIndex = Index
    Call EnableSelector
End Sub

Private Sub Timer1_Timer()
    'vDaySizeInt
End Sub

Private Sub SelectionTimer_Timer()
    If (PICSelection.Visible = True) Then
        PICSelection.Visible = False
    Else
        PICSelection.Visible = True
    End If
End Sub

Private Sub TXTDays_Validate(Cancel As Boolean)
    Call UpdateMap
End Sub

Private Sub TXTEndDate_Click()
    Call EnableSelector
End Sub

Private Sub TXTMapEndDate_Click()
    Call UpdateMap
End Sub

Private Sub TXTMapStartDate_Click()
    Call UpdateMap
End Sub

Private Sub TXTStartDate_Click()
    Call EnableSelector
End Sub
