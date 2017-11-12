VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim files(2000) As String
Dim files2(2000) As String
Dim numfiles As Long

Private Sub Form_Load()
    Dim filename As String
    Dim fs As New FileSystemObject
    Dim i As Long
    Dim path As String
    path = CurDir$
    filename = Dir(path & "\*.mp3")
    numfiles = 0
    Do While (filename <> "")
        files(numfiles) = path & "\" & filename
        If (UCase$(Left$(filename, 5)) = "TRACK") Then
            filename = Trim$(Right$(filename, Len(filename) - 5))
        End If
        files2(numfiles) = path & "\" & "1" & filename
        numfiles = numfiles + 1
        filename = Dir()
    Loop
    
    For i = 0 To numfiles - 1
        Call fs.MoveFile(files(i), files2(i))
    Next
    End
End Sub
