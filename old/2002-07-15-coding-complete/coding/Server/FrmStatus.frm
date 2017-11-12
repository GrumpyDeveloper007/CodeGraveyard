VERSION 5.00
Begin VB.Form FrmStatus 
   Caption         =   "Status Window"
   ClientHeight    =   9570
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   12225
   ClipControls    =   0   'False
   FillStyle       =   0  'Solid
   LinkTopic       =   "Form1"
   ScaleHeight     =   9570
   ScaleWidth      =   12225
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer MouseTimer 
      Left            =   9600
      Top             =   0
   End
   Begin VB.CommandButton CmdCancel 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   10800
      TabIndex        =   1
      Top             =   0
      Width           =   1215
   End
   Begin VB.PictureBox Pic 
      CausesValidation=   0   'False
      ClipControls    =   0   'False
      FontTransparent =   0   'False
      Height          =   9135
      Left            =   0
      ScaleHeight     =   605
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   805
      TabIndex        =   0
      Top             =   360
      Width           =   12135
   End
   Begin VB.Label LblStatus2 
      Caption         =   "Label1"
      Height          =   375
      Left            =   5040
      TabIndex        =   3
      Top             =   0
      Width           =   4575
   End
   Begin VB.Label LblStatus 
      Caption         =   "Label1"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   0
      Width           =   4575
   End
End
Attribute VB_Name = "FrmStatus"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub CmdCancel_Click()
    Call Me.Hide
End Sub

Private Sub MouseTimer_Timer()
'           Dim mouseEvents(1) As MSEV
'            mouseEvents(0).pt.x = 0
'            mouseEvents(0).pt.y = 0
'            mouseEvents(0).flags = MOUSEEVENTF_LEFTDOWN ' button here
'            mouseEvents(0).mousedata = 0
'            mouseEvents(0).time = 0
                
'            Call MouseEventEx(mouseEvents, 2, 24, 0) '
'    Call GetCursorPos(MouseCoords)
'    Dim i As String
'    i = MouseCoords.x & MouseCoords.y
    Dim PacketType As Long
    PacketType = 9
    Dim lheader As TCPHeader
    lheader.HeaderID = 1
    lheader.DataItems = 2
    lheader.PacketType = 10
    LblStatus.Caption = "Status - X=" & MouseCoords.X & ";Y=" & MouseCoords.Y & ";Button=" & MouseButton
'    Call SendHeader(CurrentForm.tcpServer, lheader)
'    Call Sendlong(CurrentForm.tcpServer, MouseCoords.X)
'    Call Sendlong(CurrentForm.tcpServer, MouseCoords.Y)
    Call BlitScreen(Pic)
End Sub

Private Sub Pic_Click()
    Dim lheader As TCPHeader
    lheader.HeaderID = 1
    lheader.DataItems = 0
    lheader.PacketType = 11
    Call SendHeader(CurrentForm.tcpServer, lheader)
    lheader.HeaderID = 1
    lheader.DataItems = 0
    lheader.PacketType = 12
    Call SendHeader(CurrentForm.tcpServer, lheader)
End Sub

Private Sub Pic_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    MouseButton = Button
    If (X > 0) Then
        MouseCoords.X = X
    End If
    If (Y > 0) Then
        MouseCoords.Y = Y
    End If
End Sub
