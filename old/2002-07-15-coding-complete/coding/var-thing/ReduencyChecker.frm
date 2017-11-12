VERSION 5.00
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form ReduencyChecker 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reduency Checker"
   ClientHeight    =   8205
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10920
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   8205
   ScaleWidth      =   10920
   WindowState     =   2  'Maximized
   Begin VB.CommandButton CMDCreateLocaliseFile2 
      Caption         =   "Create Localise File"
      Height          =   375
      Left            =   4080
      TabIndex        =   15
      Top             =   7380
      Width           =   1695
   End
   Begin VB.CommandButton CMDLocalise 
      Caption         =   "Localise"
      Height          =   375
      Left            =   5880
      TabIndex        =   14
      Top             =   7380
      Width           =   1335
   End
   Begin VB.TextBox TxtPath 
      Height          =   375
      Left            =   0
      TabIndex        =   13
      Text            =   "D:\coding\Copy of Current32\Wineasy.vbp"
      Top             =   240
      Width           =   2535
   End
   Begin MSComDlg.CommonDialog FileAccess 
      Left            =   4200
      Top             =   180
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
      FileName        =   "*.vbp"
      Filter          =   "Project Files (*.vbp)"
   End
   Begin VB.CheckBox ChkIndent 
      Caption         =   "Indent Procedures"
      Height          =   255
      Left            =   8280
      TabIndex        =   8
      Top             =   0
      Value           =   1  'Checked
      Width           =   1815
   End
   Begin MSComctlLib.TreeView TreProject 
      Height          =   6375
      Left            =   0
      TabIndex        =   7
      Top             =   960
      Width           =   5775
      _ExtentX        =   10186
      _ExtentY        =   11245
      _Version        =   393217
      LabelEdit       =   1
      Style           =   6
      Appearance      =   1
   End
   Begin VB.ListBox LstDatatypeFails 
      Height          =   450
      ItemData        =   "ReduencyChecker.frx":0000
      Left            =   4800
      List            =   "ReduencyChecker.frx":0002
      TabIndex        =   5
      Top             =   240
      Width           =   3135
   End
   Begin MSComctlLib.StatusBar StaStatusBar 
      Align           =   2  'Align Bottom
      Height          =   315
      Left            =   0
      TabIndex        =   4
      Top             =   7890
      Width           =   10920
      _ExtentX        =   19262
      _ExtentY        =   556
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Alignment       =   1
            AutoSize        =   2
            Object.Width           =   211667
            MinWidth        =   211668
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Webdings"
         Size            =   6
         Charset         =   2
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin VB.CheckBox ChkComment 
      Caption         =   "Comment Unused Varibles"
      Height          =   255
      Left            =   8280
      TabIndex        =   3
      Top             =   240
      Width           =   2295
   End
   Begin VB.CommandButton CmdParseForms 
      Caption         =   "&Parse forms"
      Height          =   375
      Left            =   7440
      TabIndex        =   0
      Top             =   7440
      Width           =   1335
   End
   Begin VB.CommandButton CmdQuit 
      Caption         =   "&Quit"
      Height          =   375
      Left            =   9240
      TabIndex        =   2
      Top             =   7380
      Width           =   1455
   End
   Begin VB.PictureBox PicScreenView 
      AutoRedraw      =   -1  'True
      Height          =   6315
      Left            =   5880
      ScaleHeight     =   6255
      ScaleWidth      =   3915
      TabIndex        =   10
      Top             =   960
      Width           =   3975
      Begin VB.CommandButton CmdControls 
         Caption         =   "X"
         Height          =   375
         Index           =   0
         Left            =   600
         Style           =   1  'Graphical
         TabIndex        =   11
         Top             =   840
         Visible         =   0   'False
         Width           =   495
      End
   End
   Begin RichTextLib.RichTextBox TxtCode 
      CausesValidation=   0   'False
      Height          =   6315
      Left            =   5880
      TabIndex        =   9
      Top             =   960
      Width           =   4575
      _ExtentX        =   8070
      _ExtentY        =   11139
      _Version        =   393217
      BorderStyle     =   0
      ScrollBars      =   3
      DisableNoScroll =   -1  'True
      RightMargin     =   20665
      TextRTF         =   $"ReduencyChecker.frx":0004
   End
   Begin VB.Label LblTime 
      Caption         =   "Label3"
      Height          =   375
      Left            =   3120
      TabIndex        =   12
      Top             =   240
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "Datatypes identification failures -"
      Height          =   255
      Left            =   4800
      TabIndex        =   6
      Top             =   0
      Width           =   2415
   End
   Begin VB.Label Label1 
      Caption         =   "Path"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   0
      Width           =   735
   End
End
Attribute VB_Name = "ReduencyChecker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Program - Redundancy Checker
''
'' Searches .frm files for unused localy dimension varibles and comments
''
'' Coded by Dale Pitman

Private Const cVaribleHightlightColour = &HFF


Private vEnableComment As Boolean        ' If set then forms are modified
Private vSelectedProcedure As Long       ' Used for varible searching in window
Private vTargetPath As String            ' Target dir assiciated with target project
Private vProjectLoaded As Boolean

Private vUtil As New ParseClass          ' Includes tabbing and varible identification code

Private vLastObject As Long      ' Used with treeView to store last selected object/procedure
Private vLastProcedure As Long

'' Read text file into memory, line by line
Private Sub ReadFile(pFileName As String, pObjectIndex As Long)
    Dim FileID As Long
    Dim i As Long
    Dim TempStore(10000) As String
    Dim arrayindex As Long
    
    FileID = FreeFile
    Open pFileName For Input As FileID
        
    arrayindex = 0
    Do While (EOF(FileID) = False)
        Line Input #FileID, TempStore(arrayindex)
'        TempStore(arrayindex) = strings.AllTrim(TempStore(arrayindex))
        arrayindex = arrayindex + 1
    Loop
'    arrayindex = arrayindex - 1
    
    ReDim TargetObjects(pObjectIndex).Lines(arrayindex + 1)
    TargetObjects(pObjectIndex).NumberOfLines = arrayindex
    For i = 0 To arrayindex
        TargetObjects(pObjectIndex).Lines(i) = TempStore(i)
    Next i
    Close #FileID
End Sub

'' Remove all formatting
Private Sub RemoveAllFormatting()
    Dim ObjectIndex As Long
    Dim i As Long
    For ObjectIndex = 0 To NumTargetObjects
        For i = 0 To TargetObjects(ObjectIndex).NumberOfLines
            TargetObjects(ObjectIndex).Lines(i) = strings.AllTrim(TargetObjects(ObjectIndex).Lines(i))
        Next i
    Next
End Sub

'' Read project file
Private Function InitTargetInfo(pProjectInfo As String) As Boolean
    On Error GoTo error
    Static TempFileID As Long
    Dim TempString As String
    Dim TargetObjectCount As Long
    Dim TempTargetName(1000) As String
    Dim i As Long
    Dim ScaleSize As Long
    Dim Swaped As Boolean
    
    Call TreProject.Nodes.Clear
    Call LstDatatypeFails.Clear
    TxtCode.Text = ""
    
    TempFileID = FreeFile
    TargetObjectCount = 0
    ' Read project file
    Open pProjectInfo For Input As TempFileID
    Do While (EOF(TempFileID) = False)
        If (EOF(TempFileID) = False) Then
            Line Input #TempFileID, TempString
        End If
        If (UCase(Left(TempString, 5)) = UCase("Form=")) Then
            TempTargetName(TargetObjectCount) = Right(TempString, Len(TempString) - 5)
            TargetObjectCount = TargetObjectCount + 1
        End If
        If (UCase(Left(TempString, 6)) = UCase("Class=")) Then
            TempTargetName(TargetObjectCount) = Right(TempString, Len(TempString) - InStr(TempString, " "))
            TargetObjectCount = TargetObjectCount + 1
        End If
        If (UCase(Left(TempString, 7)) = UCase("Module=")) Then
            TempTargetName(TargetObjectCount) = Right(TempString, Len(TempString) - InStr(TempString, " "))
            TargetObjectCount = TargetObjectCount + 1
        End If
    Loop
    NumTargetObjects = TargetObjectCount - 1
    
    ' Sort list
    Do
        Swaped = False
        For i = 0 To NumTargetObjects - 1
            If (TempTargetName(i) > TempTargetName(i + 1)) Then
                'swap
                TempString = TempTargetName(i + 1)
                TempTargetName(i + 1) = TempTargetName(i)
                TempTargetName(i) = TempString
                Swaped = True
            End If
        Next
    Loop While (Swaped = True)
    
    ReDim TargetObjects(TargetObjectCount)
    
    ScaleSize = StaStatusBar.Width \ ((StaStatusBar.Font.Size * 1.5) * Screen.TwipsPerPixelX)
    StaStatusBar.SimpleText = vbTab & ""
    
    ' Copy objects
    For i = 0 To NumTargetObjects
        TargetObjects(i).Name = TempTargetName(i)
        Call ReadFile(vTargetPath & TargetObjects(i).Name, i) ' Read file into memory
        
        Do While (i * (ScaleSize / NumTargetObjects) > Len(StaStatusBar.SimpleText))
            StaStatusBar.SimpleText = StaStatusBar.SimpleText & "g"
        Loop
    Next i
    Close TempFileID
    
    StaStatusBar.SimpleText = ""
    vProjectLoaded = True
    Exit Function
error:
    Call MsgBox("Unable to Load project -" & pProjectInfo)
    vProjectLoaded = False
End Function

''
Private Sub ReadProcedure()
    Dim i As Long
    Dim CodeString As String
    Dim TempString As String
    Const RTFHeader = "{\rtf1\ansi\deff0{\fonttbl{\f0\fnil\fcharset0 MS Sans Serif;}}" & "{\colortbl ;\red0\green160\blue0;}" & "\viewkind4\uc1\pard\lang2057\f0\fs17"
    
    ' Read file and locate begining of selected procedure
    Screen.MousePointer = vbHourglass
    CodeString = ""
    TxtCode.SelColor = &H0
    
    For i = TargetObjects(vLastObject).Procedures(vLastProcedure).FirstLine To TargetObjects(vLastObject).Procedures(vLastProcedure).LastLine - 1
        TempString = vUtil.StripComment(TargetObjects(vLastObject).Lines(i))
        
        If (vUtil.LineComment <> "") Then
            CodeString = CodeString & TempString & " \cf1 " & vUtil.LineComment & "\cf0 \par "  '& vbCrLf
        Else
            CodeString = CodeString & TargetObjects(vLastObject).Lines(i) & "\par " '& vbCrLf
        End If
    Next i

    TxtCode.TextRTF = RTFHeader & CodeString & vbCrLf & "}"
    TxtCode.SelStart = 0
    Screen.MousePointer = vbNormal
End Sub

''
Private Function ReadControl(ObjectNumber As Long, ByRef LineNumber As Long, MyName As String) As Long
    Dim MyNumber As Long
    Dim CurrentLine As String
    Dim Properties(1000) As PropertyType
    Dim MaxProperty As Long
    Dim i As Long
    
    MyNumber = NextFreeControl
    NextFreeControl = NextFreeControl + 1
    ControlStore(MyNumber).Name = MyName
    CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
    Call strings.Tokenise(CurrentLine, True)
    Do While (strings.Tokens(0) <> "End")
        LineNumber = LineNumber + 1
        Select Case strings.Tokens(0)
            Case "Left"
                ControlStore(MyNumber).Left = strings.GetLongValue(CurrentLine)
            Case "Top"
                ControlStore(MyNumber).Top = strings.GetLongValue(CurrentLine)
            Case "Width" ' Width
                ControlStore(MyNumber).Width = strings.GetLongValue(CurrentLine)
            Case "Height" ' Height
                ControlStore(MyNumber).Height = strings.GetLongValue(CurrentLine)
            Case "Begin" ' Begin
                ControlStore(MyNumber).Next = ReadControl(ObjectNumber, LineNumber, Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " ")))
'                Call GetControls(Objectnumber, LineNumber + 1, ControlStore(MyNumber).Child)
                Case "Index" ' Index
                    ControlStore(MyNumber).index = strings.GetLongValue(CurrentLine)
                Case "Caption" ' Caption
                    ControlStore(MyNumber).Caption = strings.GetRightValue(CurrentLine)
                    ControlStore(MyNumber).LineNumber = LineNumber 'CurrentLine
            Case Else
                Properties(MaxProperty).Name = strings.GetLeftValue(CurrentLine)
                Properties(MaxProperty).Value = strings.GetRightValue(CurrentLine)
                MaxProperty = MaxProperty + 1
        End Select
        CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
        Call strings.Tokenise(CurrentLine, True)
        
        ' Copy static propties
        ReDim ControlStore(MyNumber).OtherProperties(MaxProperty) ' I Know! (-1)
        For i = 0 To MaxProperty - 1
            ControlStore(MyNumber).OtherProperties(i) = Properties(i)
        Next i
        ControlStore(MyNumber).NumOtherPropties = MaxProperty - 1
    Loop
    LineNumber = LineNumber + 1
    ReadControl = MyNumber
End Function

''
Private Function GetControls(ObjectNumber As Long, ByRef LineNumber As Long, ParentID As Long) As Long
    Dim CurrentLine As String
    Dim i As Long
    Dim Node As Long
    Dim Properties(1000) As PropertyType
    Dim MaxProperty As Long
    
    ' Get first object
    LineNumber = 0
    CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
    Do While (Left$(CurrentLine, 5) <> "Begin" And LineNumber < TargetObjects(ObjectNumber).NumberOfLines)
        LineNumber = LineNumber + 1
        CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
    Loop
    
    If (LineNumber < TargetObjects(ObjectNumber).NumberOfLines) Then
        ControlStore(ParentID).Name = Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " "))
        LineNumber = LineNumber + 1
        CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
        Call strings.Tokenise(CurrentLine, True)
        
        Do While (strings.Tokens(0) <> "End")
            LineNumber = LineNumber + 1
            Select Case strings.Tokens(0)
                Case "Left"
                    ControlStore(ParentID).Left = strings.GetLongValue(CurrentLine)
                Case "Top"
                    ControlStore(ParentID).Top = strings.GetLongValue(CurrentLine)
                Case "Width" ' Width
                    ControlStore(ParentID).Width = strings.GetLongValue(CurrentLine)
                Case "Height" ' Height
                    ControlStore(ParentID).Height = strings.GetLongValue(CurrentLine)
                Case "Index" ' Index
                    ControlStore(ParentID).index = strings.GetLongValue(CurrentLine)
                Case "Caption" ' Caption
                    ControlStore(ParentID).Caption = strings.GetRightValue(CurrentLine)
                    ControlStore(ParentID).LineNumber = LineNumber 'CurrentLine
                Case "Begin" ' Begin
                    Node = ParentID
                    Do While (ControlStore(Node).Next > 0)
                        Node = ControlStore(Node).Next
                    Loop
                    ControlStore(Node).Next = ReadControl(ObjectNumber, LineNumber, Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " ")))
                Case Else
                    Properties(MaxProperty).Name = strings.GetLeftValue(CurrentLine)
                    Properties(MaxProperty).Value = strings.GetRightValue(CurrentLine)
                    MaxProperty = MaxProperty + 1
            End Select
            CurrentLine = TargetObjects(ObjectNumber).Lines(LineNumber)
            Call strings.Tokenise(CurrentLine, True)
        Loop
        
        ' Copy static propties
        ReDim ControlStore(ParentID).OtherProperties(MaxProperty) ' I Know! (-1)
        For i = 0 To MaxProperty - 1
            ControlStore(ParentID).OtherProperties(i) = Properties(i)
        Next i
        ControlStore(ParentID).NumOtherPropties = MaxProperty - 1
    Else
        ControlStore(ParentID).Name = "<None>"
        LineNumber = 0
    End If
    GetControls = LineNumber
End Function

''
Private Sub ResetPicture()
    Dim i As Long
    i = 0
    Do While i <= CmdControls.UBound
        CmdControls(i).BackColor = &H8000000F ' Button face
        CmdControls(i).Visible = False
        i = i + 1
    Loop
End Sub

''
Private Sub ShowPicture(ObjectNumber As Long)
    Dim Node As Long
    Dim i As Long
    
    i = 0
    Node = TargetObjects(ObjectNumber).Firstcontrol
    If (ControlStore(Node).Next > 0) Then
        Node = ControlStore(Node).Next
        
        CmdControls(i).Visible = True
        CmdControls(i).Caption = ControlStore(Node).Name
        CmdControls(i).Left = ControlStore(Node).Left
        CmdControls(i).Top = ControlStore(Node).Top
        CmdControls(i).Width = ControlStore(Node).Width
        CmdControls(i).Height = ControlStore(Node).Height
        i = i + 1
        
        Do While (ControlStore(Node).Next > 0)
            Node = ControlStore(Node).Next
            If (i > CmdControls.UBound) Then
                Load CmdControls(i)
            End If
            CmdControls(i).Visible = True
            CmdControls(i).Caption = ControlStore(Node).Name
            CmdControls(i).Left = ControlStore(Node).Left
            CmdControls(i).Top = ControlStore(Node).Top
            CmdControls(i).Width = ControlStore(Node).Width
            CmdControls(i).Height = ControlStore(Node).Height
            i = i + 1
        Loop
    End If
    Do While i <= CmdControls.UBound
        CmdControls(i).Visible = False
        i = i + 1
    Loop
    Call PicScreenView.ZOrder
End Sub

'' Process lines in current procedure, indenting lines
Private Sub CopyProcedure(StartLine As Long, EndLine As Long, ProcedureStart As Long, FileID As Long, i As Long)
    Dim CurrentLine As String
    Call vUtil.ResetTab
    Do While (StartLine < EndLine)
        CurrentLine = TargetObjects(i).Lines(StartLine)
        If (StartLine >= ProcedureStart And ChkIndent.Value = 1) Then
            CurrentLine = vUtil.IndentLine(CurrentLine)
        End If
'        Print #FileID, CurrentLine
        TargetObjects(i).Lines(StartLine) = CurrentLine
        StartLine = StartLine + 1
    Loop
End Sub


'' Comment Lines if feature enabled
Private Function CommentLine(SourceString As String)
    Dim startpos As Long
    Dim vName As String, vType As Long, vUsed As Long
    
    CommentLine = SourceString
    If (vEnableComment = True) Then
        If (InStr(SourceString, "Dim")) Then
            
            Call vUtil.ResetIndex
            Do While (vUtil.GetDimInfo(vName, vType, vUsed, 0) = True)
                startpos = InStr(SourceString, vName)
                If (startpos > 0 And vUsed = 0) Then
                    CommentLine = "'" & SourceString
'                CommentLine = Left(SourceString, startpos - 1) & _
'                Right(SourceString, Len(SourceString) - (startpos + 1 + Len(CurrentDims(iloop))))
                End If
            Loop
        End If
    End If
End Function


''***********************************************************************

'' Add Node
Private Sub AddChildNode(pNodes As Nodes, pParent As Long, pText As String, pTag As Long, ByRef pCursor As Long)
    Dim mnode As Node
    Set mnode = pNodes.Add(pParent, tvwChild)
    mnode.Text = pText
    mnode.Tag = pTag
    pCursor = pCursor + 1
End Sub

'' Add node
Private Sub AddChildNode2(pNodes As Nodes, pParent As Long, pText As String, pTag As Long, ByRef pCursor As Long, pUsed As Boolean)
    Dim mnode As Node
    Set mnode = pNodes.Add(pParent, tvwChild)
    mnode.Text = pText
    mnode.Tag = pTag
    If (pUsed = False) Then
        mnode.ForeColor = &HFF  'Red
    Else
        mnode.ForeColor = &HFF0000
    End If
    pCursor = pCursor + 1
End Sub

''
Private Sub SelectFormObject(pName As String)
    Dim i As Long
    For i = 0 To CmdControls.UBound
        If (CmdControls(i).Caption = pName) Then
            CmdControls(i).BackColor = &HFF4040
        Else
            CmdControls(i).BackColor = &H8000000F ' Button face
        End If
    Next
End Sub

''
Private Sub AddControlToLocalise(i As Long, pFormName As String)
    Dim rstemp As Recordset
'    If (ControlStore(i).Caption <> "") Then
'        Set rstemp = db.OpenRecordset("SELECT * FROM localise WHERE objectname='" & pFormName & "' AND itemname='" & ControlStore(i).Name & "' AND [Index]=" & ControlStore(i).index, dbOpenDynaset)
'        If (rstemp.EOF = False) Then
'            rstemp.Edit
'        Else
'            rstemp.AddNew
'        End If
        
'        rstemp!ObjectName = pFormName
'        rstemp!itemname = ControlStore(i).Name
'        rstemp!index = ControlStore(i).index
'        rstemp!englishname = ControlStore(i).Caption
'        Call rstemp.Update
'    End If
End Sub

Private Sub AddStringToLocalise(i As Long, ByVal LineNumber As Long)
    Dim rstemp As Recordset
    Dim CurrentLine As String
    Dim TempString As String
    
    ' Look for embeded strings
    Do While (TargetObjects(i).NumberOfLines > LineNumber)
        CurrentLine = Trim$(TargetObjects(i).Lines(LineNumber))
        CurrentLine = vUtil.StripComment(CurrentLine)
        Call strings.Tokenise(CurrentLine, True)
        If (strings.Tokens(0) = "Attribute") Then
        Else
'            If (InStr(CurrentLine, Chr$(34)) > 0) Then
'                TempString = Right$(CurrentLine, Len(CurrentLine) - InStr(CurrentLine, Chr$(34)))
'                TempString = Mid$(TempString, 1, InStr(TempString, Chr$(34)) - 1)
'                If (Len(TempString) > 0) Then
'                    Set rstemp = db.OpenRecordset("SELECT * FROM localise WHERE objectname='" & TargetObjects(i).Name & "' AND LINENUMBER=" & LineNumber, dbOpenDynaset)
'                    If (rstemp.EOF = False) Then
'                        rstemp.Edit
'                    Else
'                        rstemp.AddNew
'                    End If
'
'                    rstemp!ObjectName = TargetObjects(i).Name
'                    rstemp!itemname = ""
'                    rstemp!index = 0
'                    rstemp!englishname = TempString
'                    rstemp!LineNumber = LineNumber
'                    Call rstemp.Update
'                End If
'            End If
        End If
        LineNumber = LineNumber + 1
    Loop
End Sub

'' Function used to place structure into a treeview
Private Sub DisplayStructure()
    Dim i As Long, t As Long, v As Long
    Dim Cursor As Long
    Dim mnode As Node
    Dim SelectedFormNode As Long        ' Used when viewing nodes
    Dim SelectedProcedureNode As Long
    Dim SelectedFormObjectNode As Long
    
    Set mnode = TreProject.Nodes.Add()
    mnode.Text = TxtPath.Text
    mnode.Tag = -1
    mnode.Expanded = True

    Cursor = 2
    For i = 0 To NumTargetObjects
        SelectedFormNode = Cursor
        Call AddChildNode2(TreProject.Nodes, 1, TargetObjects(i).Name, i, Cursor, TargetObjects(i).Used)
        
        ' Do Form objects
        SelectedProcedureNode = Cursor
        Call AddChildNode(TreProject.Nodes, SelectedFormNode, "Form Objects", -1, Cursor)
    
        t = TargetObjects(i).Firstcontrol
        If (ControlStore(t).Next > 0) Then
            t = ControlStore(t).Next
            
            SelectedFormObjectNode = Cursor
            Call AddChildNode(TreProject.Nodes, SelectedProcedureNode, ControlStore(t).Name & "(" & ControlStore(t).index & ")", -1, Cursor)
            
            Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Left = " & ControlStore(t).Left, -1, Cursor)
            Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Top = " & ControlStore(t).Top, -1, Cursor)
            Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Width = " & ControlStore(t).Width, -1, Cursor)
            Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Height = " & ControlStore(t).Height, -1, Cursor)
            Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Caption = " & ControlStore(t).Caption, -1, Cursor)
            
            Call AddControlToLocalise(t, TargetObjects(i).Name)
            
            For v = 0 To ControlStore(t).NumOtherPropties
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, ControlStore(t).OtherProperties(v).Name & " = " & ControlStore(t).OtherProperties(v).Value, -1, Cursor)
            Next v
            
            
            Do While (ControlStore(t).Next > 0)
                t = ControlStore(t).Next
                
                SelectedFormObjectNode = Cursor
                Call AddChildNode(TreProject.Nodes, SelectedProcedureNode, ControlStore(t).Name & "(" & ControlStore(t).index & ")", -1, Cursor)
                
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Left = " & ControlStore(t).Left, -1, Cursor)
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Top = " & ControlStore(t).Top, -1, Cursor)
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Width = " & ControlStore(t).Width, -1, Cursor)
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Height = " & ControlStore(t).Height, -1, Cursor)
                Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, "Caption = " & ControlStore(t).Caption, -1, Cursor)
                
                Call AddControlToLocalise(t, TargetObjects(i).Name)
                
                For v = 0 To ControlStore(t).NumOtherPropties
                    Call AddChildNode(TreProject.Nodes, SelectedFormObjectNode, ControlStore(t).OtherProperties(v).Name & " = " & ControlStore(t).OtherProperties(v).Value, -1, Cursor)
                Next v
            Loop
        End If
        
        ' Do Procedures / Varibles
        For t = 0 To TargetObjects(i).NumProcedures - 1
            SelectedProcedureNode = Cursor
            Call AddChildNode2(TreProject.Nodes, SelectedFormNode, TargetObjects(i).Procedures(t).Name, t, Cursor, TargetObjects(i).Procedures(t).Used)
            
            v = 0
            Do While (v < TargetObjects(i).Procedures(t).NumVaribles)
                Call AddChildNode2(TreProject.Nodes, SelectedProcedureNode, TargetObjects(i).Procedures(t).Varibles(v).Name & "  - TYPE -  " _
                & GetVarTypeString(TargetObjects(i).Procedures(t).Varibles(v).Type) & " - Scope - " _
                & GetScopeString(TargetObjects(i).Procedures(t).Varibles(v).Scope) & ":" _
                & TargetObjects(i).Procedures(t).Varibles(v).Used, v, Cursor, TargetObjects(i).Procedures(t).Varibles(v).Used > 0)
                v = v + 1
            Loop
        Next t
    Next i
    
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form procedures

''
Private Sub ChkComment_Click()
    If (ChkComment.Value = 1) Then
        vEnableComment = True
    Else
        vEnableComment = False
    End If
End Sub

Private Sub CMDCreateLocaliseFile_Click()
    Dim i As Long
    Dim ScaleSize As Long
    Dim BeginCount As Long
    Dim CurrentLine As String
    Dim LineNumber As Long
    Dim ObjectName As String
    Dim FileID As Long
    Dim TempString As String
    
    Dim rstemp As Recordset
    If (vProjectLoaded = True) Then
        FileID = FreeFile
        Set db = DBEngine.OpenDatabase(AppPath & "Localise.mdb", False, False)
'        Open "localise.txt" For Output As #FileID
    
        ScaleSize = StaStatusBar.Width \ ((StaStatusBar.Font.Size * 1.5) * Screen.TwipsPerPixelX)
        StaStatusBar.SimpleText = vbTab & ""
        For i = 0 To NumTargetObjects
            vUtil.CurrentForm = i
            ' Status bar update
            DoEvents
            Do While (i * (ScaleSize / NumTargetObjects) > Len(StaStatusBar.SimpleText))
                StaStatusBar.SimpleText = StaStatusBar.SimpleText & "g"
            Loop
           
            TargetObjects(i).Name = TargetObjects(i).Name
            ' Get Form Objects
            LineNumber = 0
            If (UCase$(Right$(TargetObjects(i).Name, 3)) = "FRM") Then
                BeginCount = 0
                Do While (BeginCount = 0 And TargetObjects(i).NumberOfLines > LineNumber)
                    CurrentLine = Trim$(TargetObjects(i).Lines(LineNumber))
                    LineNumber = LineNumber + 1
                    Call strings.Tokenise(CurrentLine, True)
                    If (strings.Tokens(0) = "Begin") Then
                        BeginCount = BeginCount + 1
                        ObjectName = Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " "))
                    End If
                Loop
                
                ' Loop through all sub-objects
                Do While (BeginCount > 0 And TargetObjects(i).NumberOfLines > LineNumber)
                    CurrentLine = Trim$(TargetObjects(i).Lines(LineNumber))
                    LineNumber = LineNumber + 1
                    Call strings.Tokenise(CurrentLine, True)
                    If (strings.Tokens(0) = "Begin") Then
                        ObjectName = Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " "))
                        BeginCount = BeginCount + 1
                    End If
                    If (strings.Tokens(0) = "End") Then
                        ObjectName = Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, " "))
                        BeginCount = BeginCount - 1
                    End If
                    If (strings.Tokens(0) = "Caption") Then
'                        Print #FileID, TargetObjects(i).Name & "." & ObjectName & "=" & strings.GetRightValue(CurrentLine)
                        Set rstemp = db.OpenRecordset("SELECT * FROM localise WHERE objectname='" & TargetObjects(i).Name & "' AND itemname='" & ObjectName & "'", dbOpenDynaset)
                        If (rstemp.EOF = False) Then
                            rstemp.Edit
                        Else
                            rstemp.AddNew
                        End If
                        
                        rstemp!ObjectName = TargetObjects(i).Name
                        rstemp!itemname = ObjectName
                        rstemp!englishname = strings.GetRightValue(CurrentLine)
                        rstemp!LineNumber = LineNumber
                        Call rstemp.Update
                        
                    End If
                Loop
            End If
            
        Next i
        
        Screen.MousePointer = 0
        StaStatusBar.SimpleText = ""
'        Close #FileID
    End If

End Sub

Private Sub CMDCreateLocaliseFile2_Click()
    Dim i As Long
    For i = 0 To NextFreeControl - 1
    Next
End Sub

Private Sub CMDLocalise_Click()
    Dim i As Long
    Dim ScaleSize As Long
    If (MsgBox("Warning, this is a descructive operation, continue?", vbYesNo) = vbYes And vProjectLoaded = True) Then
        ScaleSize = StaStatusBar.Width \ ((StaStatusBar.Font.Size * 1.5) * Screen.TwipsPerPixelX)
        StaStatusBar.SimpleText = vbTab & ""
        For i = 0 To NumTargetObjects
            vUtil.CurrentForm = i
            ' Status bar update
            DoEvents
            Do While (i * (ScaleSize / NumTargetObjects) > Len(StaStatusBar.SimpleText))
                StaStatusBar.SimpleText = StaStatusBar.SimpleText & "g"
            Loop
           
            TargetObjects(i).Name = TargetObjects(i).Name
            '
        Next i
        
        Screen.MousePointer = 0
        StaStatusBar.SimpleText = ""
    
    End If
End Sub

''
Private Sub CmdParseForms_Click()
    Dim starttime As Date, endtime As Date
    
    Dim FileID2 As Long
    Dim ProcedureStart As Long, ProcedureEnd As Long
    Dim processline As Long
    Dim ScaleSize As Long
    Dim i As Long, t As Long, v As Long
    Dim vUsed As Long
    Dim ProcedureNumber As Long
    Dim ProcedureUsed As Boolean
    Dim FormUsed As Boolean
    Dim Firstcontrol As Long
    
    Dim Procedures(1200) As ProcedureType
    
    
    If (vProjectLoaded = True) Then
'        Set db = DBEngine.OpenDatabase(AppPath & "Localise.mdb", False, False)
        
        starttime = Now
        
        ' Ensure there is no formatting at the start of each line
        Call RemoveAllFormatting
        
        Call TreProject.Nodes.Clear
        Call LstDatatypeFails.Clear
        
        StaStatusBar.SimpleText = vbTab & ""
        Screen.MousePointer = vbHourglass
        ScaleSize = StaStatusBar.Width \ ((StaStatusBar.Font.Size * 1.5) * Screen.TwipsPerPixelX)
        
        FileID2 = FreeFile
        
        For i = 0 To NumTargetObjects
            FormUsed = True
            vUtil.CurrentForm = i
            ' Status bar update
            DoEvents
             Do While (i * (ScaleSize / NumTargetObjects) > Len(StaStatusBar.SimpleText))
                StaStatusBar.SimpleText = StaStatusBar.SimpleText & "g"
            Loop
           
     '       Open TargetPath & "\temp.fff" For Output As FileID2
            
            processline = 0
            ProcedureNumber = 0
            Firstcontrol = NextFreeControl
            NextFreeControl = NextFreeControl + 1
            TargetObjects(i).Firstcontrol = Firstcontrol
            TargetObjects(i).Name = TargetObjects(i).Name
            
            ProcedureEnd = GetControls(i, 0, Firstcontrol) + 1
            Call AddStringToLocalise(i, ProcedureEnd)
            
            ProcedureStart = vUtil.GetProcedureStart(ProcedureEnd, "")
            
            Procedures(ProcedureNumber).FirstLine = ProcedureEnd
            Procedures(ProcedureNumber).LastLine = TargetObjects(i).NumberOfLines
            Procedures(ProcedureNumber).Name = "0-Global Declarations"
            
            vUtil.SetContext = cGlobal
            Call vUtil.ClearUsage
            Call vUtil.GetDimedVars(0, ProcedureStart - 1)
            Call vUtil.CheckUsage(ProcedureStart - 1, TargetObjects(i).NumberOfLines)
            
            ReDim Procedures(ProcedureNumber).Varibles(vUtil.MaxFormIndex)
            Procedures(ProcedureNumber).NumVaribles = vUtil.MaxFormIndex
            t = 0
            Call vUtil.ResetIndex
            ProcedureUsed = True
            Do While (vUtil.GetDimInfo(Procedures(ProcedureNumber).Varibles(t).Name, _
                      Procedures(ProcedureNumber).Varibles(t).Type, vUsed, _
                      Procedures(ProcedureNumber).Varibles(t).Scope) = True)
                Procedures(ProcedureNumber).Varibles(t).Used = vUsed
                If (vUsed = 0) Then
                    ProcedureUsed = False
                End If
                t = t + 1
            Loop
            Procedures(ProcedureNumber).Used = ProcedureUsed
            ProcedureNumber = ProcedureNumber + 1
            
            vUtil.SetContext = cLocal
            Do While (processline < TargetObjects(i).NumberOfLines)
                ProcedureStart = vUtil.GetProcedureStart(processline, Procedures(ProcedureNumber).Name)
                ProcedureEnd = vUtil.GetProcedureEnd(ProcedureStart)
                If (ProcedureStart < TargetObjects(i).NumberOfLines) Then
                    Procedures(ProcedureNumber).FirstLine = ProcedureStart
                    Procedures(ProcedureNumber).LastLine = ProcedureEnd
                    
    '                Call Util.ClearUsage
                    Call vUtil.GetDimedVars2(ProcedureStart, ProcedureEnd)
    '                Call vUtil.CheckUsage(ProcedureStart, ProcedureEnd)
                    
                    ReDim Procedures(ProcedureNumber).Varibles(vUtil.MaxFormIndex)
                    Procedures(ProcedureNumber).NumVaribles = vUtil.MaxFormIndex
                    t = 0
                    Call vUtil.ResetIndex
                    ProcedureUsed = True
                    Do While (vUtil.GetDimInfo(Procedures(ProcedureNumber).Varibles(t).Name, _
                              Procedures(ProcedureNumber).Varibles(t).Type, vUsed, _
                              Procedures(ProcedureNumber).Varibles(t).Scope) = True)
                        Procedures(ProcedureNumber).Varibles(t).Used = vUsed
                        If (vUsed = 0) Then
                            ProcedureUsed = False
                            FormUsed = False
                        End If
                        t = t + 1
                    Loop
                    Procedures(ProcedureNumber).Used = ProcedureUsed
                    
                    ' Write file
                    Call CopyProcedure(processline, ProcedureEnd, ProcedureStart, FileID2, i)
                End If
                processline = ProcedureEnd
                ProcedureNumber = ProcedureNumber + 1
            Loop
            
            ' Write file
            Call CopyProcedure(processline, TargetObjects(i).NumberOfLines, 32768, FileID2, i)
    '        Close #FileID2
            
    '        Kill targetpath & "\" & MyName
    '        Call fs.CopyFile(targetpath & "\temp.fff", targetpath & "\" & MyName)
    
            ' Copy static procedure info to dynamic info
            TargetObjects(i).Used = FormUsed
            ReDim TargetObjects(i).Procedures(ProcedureNumber)
            TargetObjects(i).NumProcedures = ProcedureNumber
            For t = 0 To ProcedureNumber
                TargetObjects(i).Procedures(t).FirstLine = Procedures(t).FirstLine
                TargetObjects(i).Procedures(t).LastLine = Procedures(t).LastLine
                TargetObjects(i).Procedures(t).Name = Procedures(t).Name
                TargetObjects(i).Procedures(t).Used = Procedures(t).Used
                ReDim TargetObjects(i).Procedures(t).Varibles(Procedures(t).NumVaribles)
                TargetObjects(i).Procedures(t).NumVaribles = Procedures(t).NumVaribles
                v = 0
                Do While (v < Procedures(t).NumVaribles)
                    TargetObjects(i).Procedures(t).Varibles(v) = Procedures(t).Varibles(v)
                    v = v + 1
                Loop
            Next t
            '
        Next i
        
        Call DisplayStructure
        
        Screen.MousePointer = 0
        StaStatusBar.SimpleText = ""
        endtime = Now
        LblTime.Caption = "Time :" & Format(endtime - starttime, "hh:mm:ss")
    Else
        Call MsgBox("No Project loaded")
    End If
End Sub

''
Private Sub CmdQuit_Click()
    Call Unload(Me)
    Call Unload(FrmMain)
End Sub

''
Private Sub Form_Load()
'    TargetPath = Left$(TxtPath.Text, InStrRev(TxtPath.Text, "\"))
'    Call InitTargetInfo(TxtPath.Text)
    vEnableComment = False
End Sub

''
Private Sub Form_Resize()
    If (Me.WindowState <> 1) Then
        If (Me.Width > 100) Then
            TxtCode.Width = (Me.Width - 100) - TxtCode.Left
            PicScreenView.Width = (Me.Width - 100) - PicScreenView.Left
        End If
        CmdParseForms.Top = Me.ScaleHeight - 825
        CmdQuit.Top = Me.ScaleHeight - 825
        CMDLocalise.Top = Me.ScaleHeight - 825
        CMDCreateLocaliseFile2.Top = Me.ScaleHeight - 825
        PicScreenView.Height = (Me.ScaleHeight - (825 + 120)) - PicScreenView.Top
        TreProject.Height = (Me.ScaleHeight - (825 + 120)) - TreProject.Top
        TxtCode.Height = (Me.ScaleHeight - (825 + 120)) - TxtCode.Top
    End If
End Sub

''

''
Private Sub TreProject_NodeClick(ByVal Node As MSComctlLib.Node)
    Dim VaribleName As String
    Dim LastPosition As Long
    
    If (Node.Parent Is Nothing) Then ' If selected = root
    Else
        If (Node.Parent.Parent Is Nothing) Then ' If selected = .Frm/.cls/.bas
            Call ShowPicture(Node.Tag)
        Else
            If (Node.Parent.Parent.Parent Is Nothing) Then ' If selected  = procedure
                ' Read procedure
                If (Node.Tag > -1) Then
                    vLastObject = Node.Parent.Tag
                    vLastProcedure = Node.Tag
                    Call ReadProcedure
                    Call TxtCode.ZOrder
                End If
            Else
                If (Node.Parent.Parent.Parent.Parent Is Nothing) Then ' If selected = varible
                    If (Node.Tag > -1) Then
'                        If (LastObject <> Node.Parent.Parent.Tag Or LastProcedure <> Node.Parent.Tag) Then
                            ' Click outside of currently selected procedure, so read new procedure
                            vLastObject = Node.Parent.Parent.Tag
                            vLastProcedure = Node.Parent.Tag
                            Call ReadProcedure
'                        End If
                        ' Reset colour of text
'                        TxtCode.SelStart = 0
'                        TxtCode.SelLength = Len(TxtCode.Text)
'                        TxtCode.SelColor = &H0
            
                       ' Highlight all instances in blue
                        LastPosition = 1
                        VaribleName = TargetObjects(Node.Parent.Parent.Tag).Procedures(Node.Parent.Tag).Varibles(Node.Tag).Name
                        Do While (InStr(LastPosition, TxtCode.Text, VaribleName) > 0)
                            TxtCode.SelStart = InStr(LastPosition, TxtCode.Text, VaribleName) - 1
                            TxtCode.SelLength = Len(VaribleName)
                            TxtCode.SelColor = cVaribleHightlightColour
                            TxtCode.SelLength = 0
                            LastPosition = InStr(LastPosition, TxtCode.Text, VaribleName) + 1
                        Loop
                        Call TxtCode.ZOrder
                    Else
                        ' Form object selected
                        Call SelectFormObject(Node.Text)
                    End If
                End If

            End If
        End If
    End If
End Sub

''
Private Sub TxtPath_Click()
    FileAccess.InitDir = vTargetPath
    FileAccess.ShowOpen
    If (FileAccess.FileName <> "*.vbp") Then
        vProjectLoaded = False
        TxtPath.Text = FileAccess.FileName
        vTargetPath = Left$(TxtPath.Text, InStrRev(TxtPath.Text, "\"))
        Call InitTargetInfo(TxtPath.Text)
    End If
End Sub
