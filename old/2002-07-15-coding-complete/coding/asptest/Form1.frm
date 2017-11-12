VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6630
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8505
   LinkTopic       =   "Form1"
   ScaleHeight     =   6630
   ScaleWidth      =   8505
   StartUpPosition =   3  'Windows Default
   Begin VB.ListBox LSTMovies 
      Height          =   4545
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   7455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim db As Database
    Set db = DBEngine.OpenDatabase("f:\movies\offline movies.mdb", False, False)
    Dim rs As Recordset
    Set rs = db.OpenRecordset("SELECT * FROM Movies", dbOpenSnapshot)
    Do While (rs.EOF = False)
        Call LSTMovies.AddItem(rs!movieName)
        rs.MoveNext
    Loop

End Sub
