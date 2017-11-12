VERSION 5.00
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DATECONTROL.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form FRMViewCalls 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "View Calls"
   ClientHeight    =   7290
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11685
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7290
   ScaleWidth      =   11685
   Begin VB.CheckBox CHKCallDate 
      Caption         =   "Call Date"
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
      Left            =   600
      TabIndex        =   11
      Top             =   660
      Width           =   1215
   End
   Begin VB.CheckBox CHKShowNames 
      Caption         =   "Show Names for Telephone Numbers"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   8400
      TabIndex        =   9
      Top             =   360
      Width           =   2055
   End
   Begin VB.ComboBox CBODirection 
      Height          =   315
      Left            =   1680
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   0
      Width           =   2295
   End
   Begin VB.ComboBox CBOLineNumber 
      Height          =   315
      Left            =   6000
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   0
      Width           =   2295
   End
   Begin VB.ComboBox CBOExtension 
      Height          =   315
      Left            =   6000
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   480
      Width           =   2295
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   10560
      TabIndex        =   0
      Top             =   6840
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDSearch 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   6840
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Search"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin MSComctlLib.TreeView TreCalls 
      Height          =   5655
      Left            =   0
      TabIndex        =   2
      Top             =   1080
      Width           =   11655
      _ExtentX        =   20558
      _ExtentY        =   9975
      _Version        =   393217
      Indentation     =   706
      LabelEdit       =   1
      Style           =   6
      FullRowSelect   =   -1  'True
      Appearance      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ELFDateControl.DateControl TXTCallDate 
      Height          =   615
      Left            =   1920
      TabIndex        =   10
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
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Direction"
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
      TabIndex        =   8
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Extension Number"
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
      Left            =   4320
      TabIndex        =   6
      Top             =   480
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Line Number"
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
      Left            =   4320
      TabIndex        =   5
      Top             =   0
      Width           =   1575
   End
End
Attribute VB_Name = "FRMViewCalls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Object
''
''

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' Add Node
Private Sub AddChildNode(pNodes As Nodes, pParent As Long, pText As String, pTag As Long, ByRef pCursor As Long)
    Dim mnode As Node
    Set mnode = pNodes.Add(pParent, tvwChild)
    mnode.Text = pText
    mnode.Tag = pTag
    pCursor = pCursor + 1
End Sub

'' Add node
Private Sub AddChildNode2(pNodes As Nodes, pParent As Long, pText As String, pTag As Long, ByRef pCursor As Long, pcolour As Long)
    Dim mnode As Node
    Set mnode = pNodes.Add(pParent, tvwChild)
    mnode.Text = pText
    mnode.Tag = pTag
    mnode.ForeColor = pcolour
    pCursor = pCursor + 1
End Sub


Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub CMDSearch_Click()
    Dim ParentNode As Node
    'tvwFirst 0 First. The Node is placed before all other nodes at the same level of the node named in relative.
    'tvwLast 1 Last. The Node is placed after all other nodes at the same level of the node named in relative. Any Node added subsequently may be placed after one added as Last.
    'tvwNext 2 (Default) Next. The Node is placed after the node named in relative.
    'tvwPrevious - The Node is placed before the node named in relative
    'tvwChild
    
    Dim i As Long, t As Long, v As Long
    Dim Cursor As Long
    Dim mnode As Node
    Dim SelectedFormNode As Long        ' Used when viewing nodes
    Dim SelectedProcedureNode As Long
    Dim SelectedFormObjectNode As Long
    Dim rstemp As Recordset
    Dim rsExtensions As Recordset
    Dim rsLines As Recordset
    Dim rsNumbers As Recordset
    Dim Lines(10) As Long
    Dim tempstring As String
    Dim SQl As String
    Dim PhoneName As String
    Dim Colour As Long
    Dim AnswerTime As String
    
    Call TreCalls.Nodes.Clear
    Set mnode = TreCalls.Nodes.Add()
    mnode.Text = "Calls"
    mnode.Tag = -1
    mnode.Expanded = True
    Cursor = 2
    If (CHKCallDate.Value = vbChecked) Then
        SQl = "SELECT * FROM calls WHERE calldate>#" & Format(DateAdd("d", -1, TXTCallDate.Text), "mm/dd/yyyy") & "# AND calldate<#" & Format(DateAdd("d", 1, TXTCallDate.Text), "mm/dd/yyyy") & "# "
        Select Case CBODirection.ListIndex
            Case 0 ' ALL
            Case 1 ' incoming
                SQl = SQl & " AND direction=1"
            Case 2 ' Outgoing
                SQl = SQl & " AND direction=2"
            Case Else
        End Select
    Else
        SQl = "SELECT * FROM calls"
        Select Case CBODirection.ListIndex
            Case 0 ' ALL
            Case 1 ' incoming
                SQl = SQl & " WHERE direction=1"
            Case 2 ' Outgoing
                SQl = SQl & " WHERE direction=2"
            Case Else
        End Select
    End If
    SQl = SQl & " ORDER BY UID"
    
    If (OpenRecordset(rstemp, SQl, dbOpenSnapshot)) Then
        i = 0
        Do While (rstemp.EOF = False)
            If (OpenRecordset(rsExtensions, "SELECT * FROM extension WHERE uid=" & rstemp!Extensionid, dbOpenSnapshot)) Then
            End If
            If (OpenRecordset(rsLines, "SELECT * FROM Line WHERE uid=" & rstemp!LineID, dbOpenSnapshot)) Then
            End If
            PhoneName = ""
            If (OpenRecordset(rsNumbers, "SELECT * FROM numbers WHERE telephonenumber='" & rstemp!PhoneNumber & "'", dbOpenSnapshot)) Then
                If (rsNumbers.EOF = False) Then
                    PhoneName = rsNumbers!Name
                End If
            End If
            
            If (rstemp!UnanseredCall = True) Then
                AnswerTime = "@" & ">" & Right$(SecondsToTime2(rstemp!AnswerTime), 4)
            Else
                AnswerTime = "@" & SecondsToTime2(rstemp!AnswerTime)
            End If
            If (CHKShowNames.Value = vbChecked) Then
                tempstring = rstemp!CallDate & "-" & SecondsToTime(rstemp!Duration) & AnswerTime & " - " & Pad(rsLines!Uid, 1) & ":" & Pad(rsExtensions!Name, 1) & "  [" & rstemp!PhoneNumber & ":" & PhoneName & "]"
            Else
                tempstring = rstemp!CallDate & "-" & SecondsToTime(rstemp!Duration) & AnswerTime & " - " & Pad(rsLines!Uid, 1) & ":" & Pad(rsExtensions!Name, 1) & "  [" & rstemp!PhoneNumber & "]"
            End If
            If (rstemp!Direction = 1) Then
                Colour = &HFF0000
            Else
                Colour = &HFF
            End If
            
            If (rstemp!Previousid > 0) Then
                Call AddChildNode2(TreCalls.Nodes, Lines(rstemp!LineID), tempstring, rstemp!Uid, Cursor, Colour)
            Else
                Call AddChildNode2(TreCalls.Nodes, 1, tempstring, rstemp!Uid, Cursor, Colour)
            End If
            Lines(rstemp!LineID) = Cursor - 1
            
            ' Do Form objects
'            SelectedProcedureNode = Cursor
'            Call AddChildNode(TreCalls.Nodes, SelectedFormNode, "Form Objects", -1, Cursor)
            
            Call rstemp.MoveNext
        Loop
    End If
'    Set ParentNode = TreCalls.Nodes.Add(, , , "test")
'    Call TreCalls.Nodes.Add(ParentNode, tvwChild, , "test")
'    Call TreCalls.Nodes.Add(, , , "test")
'    Call TreCalls.Nodes.Add(, , , "test")
End Sub

Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    
    Call CBODirection.AddItem("ALL")
    Call CBODirection.AddItem("Incoming")
    Call CBODirection.AddItem("Outgoing")
    CBODirection.ListIndex = 0
    CHKShowNames.Value = GetSetting(cRegistoryName, "Misc", Me.Name & ".ShowNames", 0)
    CHKCallDate.Value = GetSetting(cRegistoryName, "Misc", Me.Name & ".CallDate", 0)

    TXTCallDate.Text = Format(Now, "dd/mm/yyyy")
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)

    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".ShowNames", CHKShowNames.Value)
    Call SaveSetting(cRegistoryName, "Misc", Me.Name & ".CallDate", CHKCallDate.Value)
End Sub

