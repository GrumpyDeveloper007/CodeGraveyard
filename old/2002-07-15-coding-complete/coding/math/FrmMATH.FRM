VERSION 5.00
Begin VB.Form Frmtest 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Program View"
   ClientHeight    =   9015
   ClientLeft      =   1395
   ClientTop       =   840
   ClientWidth     =   13185
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   601
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   879
   Begin VB.CommandButton CMDShowText 
      Caption         =   "Show Text"
      Height          =   495
      Left            =   5640
      TabIndex        =   12
      Top             =   7440
      Width           =   1095
   End
   Begin VB.CommandButton CmdPrintText 
      Caption         =   "Print Text"
      Height          =   495
      Left            =   6960
      TabIndex        =   11
      Top             =   7440
      Width           =   1095
   End
   Begin VB.CommandButton CMDShowGFX 
      Caption         =   "Show GFX"
      Height          =   495
      Left            =   8280
      TabIndex        =   9
      Top             =   7440
      Width           =   1095
   End
   Begin VB.TextBox TxtError 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1815
      Left            =   10920
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Top             =   6720
      Width           =   2175
   End
   Begin VB.TextBox TxtConsole 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6855
      HelpContextID   =   2
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   6
      Top             =   480
      Width           =   10815
   End
   Begin VB.CommandButton CMDPrintGFX 
      Caption         =   "Print GFX"
      Height          =   495
      Left            =   9600
      TabIndex        =   5
      Top             =   7440
      Width           =   1095
   End
   Begin VB.CommandButton CmdDo 
      Caption         =   "Run"
      Height          =   495
      Left            =   0
      TabIndex        =   0
      Top             =   7440
      Width           =   1095
   End
   Begin VB.TextBox TxtImediate 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   8040
      Width           =   10815
   End
   Begin VB.ListBox LstVaribles 
      Columns         =   2
      Height          =   5910
      Left            =   10920
      TabIndex        =   2
      Top             =   360
      Width           =   2175
   End
   Begin VB.Label LblCurrentInput 
      Caption         =   "Current Input :"
      Height          =   255
      Left            =   7800
      TabIndex        =   13
      Top             =   120
      Width           =   3015
   End
   Begin VB.Label Label2 
      Caption         =   "Errors -"
      Height          =   255
      Left            =   10920
      TabIndex        =   10
      Top             =   6360
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "Console"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   7
      Top             =   120
      Width           =   3495
   End
   Begin VB.Label lblInstruction 
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   8400
      Width           =   10335
   End
   Begin VB.Label LblVaribles 
      Caption         =   "Varibles"
      Height          =   255
      Left            =   10920
      TabIndex        =   3
      Top             =   120
      Width           =   1935
   End
End
Attribute VB_Name = "Frmtest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

Private LastCommand As String
Public LastVariblename As String
Private FileID As Long

''
Public Sub DoProgram()
    Syntax.PrintoutEnabled = FrmOptions.EnableProgramPrint
    Syntax.Finished = False
    Do While (Syntax.Finished = False)
        Call Syntax.ProcessorTick
    Loop
    Call Update
    Call TxtConsole.SetFocus
End Sub

''
Public Sub Update()
     Call Varibles.PrintVaribles(LstVaribles)
'    LblData.Caption = "Data -" & Syntax.GetDynamicData()
    lblInstruction.Caption = Syntax.CurrentInstruction
End Sub

''
Private Sub CmdDo_Click()
    Call DoProgram
End Sub

''
Private Sub CMDPrintGFX_Click()
    Call Interface.iPrintGFXToPrinter
End Sub

''
Private Sub CmdPrintText_Click()
    Call Interface.iPrintTextToPrinter
End Sub

''
Private Sub CMDShowGFX_Click()
    Call FrmGFXView.Show
    Call FrmGFXView.ZOrder
End Sub

''
Private Sub Command3_Click()
'    Dim strings As New StringClass
'    Dim fileid As Long
'    Dim i As Long
'    Dim linenum As String
'    Dim command As String
'    fileid = FreeFile
'    Open "dale.bas" For Input As #fileid
'    Open "dale.txt" For Output As #fileid + 1
'    Do While (EOF(fileid) = False)
'        Line Input #fileid, linenum
'        Line Input #fileid, command
'        command = UCase$(command)
'        If (Left$(command, 3) = "LET") Then
'            command = "LET " & strings.DeleteWhiteSpace(Right$(command, Len(command) - 3))
'        End If
'        If (InStr(command, "PROUND") > 0) Then
'            command = strings.DeleteWhiteSpace(command)
'        End If
'        If (Left$(command, 4) = "DRAW" Or Left$(command, 4) = "MOVE") Then
'
'            command = "DRAW " & strings.DeleteWhiteSpace(Right$(command, Len(command) - 4))
'        End If
'        If (Right$(linenum, 1) = ":") Then
'            linenum = Mid$(linenum, 2, Len(linenum) - 2)
'        Else
'            linenum = Mid$(linenum, 2, Len(linenum) - 1)
'        End If
'
'        Print #fileid + 1, linenum & " " & command
'    Loop
End Sub

Private Sub Command2_Click()

End Sub

Private Sub CMDShowText_Click()
    Call FrmTextView.Show
    Call FrmTextView.ZOrder
End Sub

''
Private Sub Form_Load()
'    Dim strings As New StringClass
'    Call test
'    fileid = FreeFile
'    Open "dale.ans" For Output As #fileid
End Sub

''
Private Sub TxtConsole_Click()
    TxtConsole.SelStart = Len(TxtConsole.Text)
End Sub

''
Private Sub TxtConsole_DblClick()
    TxtConsole.SelStart = Len(TxtConsole.Text)
End Sub

''
Private Sub TxtConsole_GotFocus()
    TxtConsole.SelStart = Len(TxtConsole.Text)
End Sub

''
Private Sub TxtConsole_KeyDown(KeyCode As Integer, Shift As Integer)
If (KeyCode = 37 Or KeyCode = 38 Or KeyCode = 39 Or KeyCode = 40) Then
    KeyCode = 0
End If
End Sub

''
Private Sub TxtConsole_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
'        TxtConsole.SelText = vbCrLf
'        Print #fileid, LastCommand
        If (LastCommand <> "") Then
            Call Varibles.SetVarible(LastVariblename, LastCommand)
        End If
        Call DoProgram
        LastCommand = ""
    Else
        Select Case KeyAscii
            Case 8 ' Backspace
                If (Len(LastCommand) >= 1) Then
                    LastCommand = Left$(LastCommand, Len(LastCommand) - 1)
                End If
            Case 32 To 122
                LastCommand = LastCommand & Chr$(KeyAscii)
            Case Else
                KeyAscii = 0
        End Select
    End If
    LblCurrentInput.Caption = "Current Input : " & LastCommand
End Sub

''
Private Sub TxtImediate_KeyPress(KeyAscii As Integer)
    Dim value As Double
    If (KeyAscii = 13) Then
        Call Syntax.ProcessStatement(UCase$(TxtImediate.Text))
        Call Update
'        TxtImediate.Text = ""
    End If
'TxtImediate
End Sub
