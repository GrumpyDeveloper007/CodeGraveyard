VERSION 5.00
Begin VB.UserControl UserControl1 
   ClientHeight    =   6615
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   9180
   ScaleHeight     =   6615
   ScaleWidth      =   9180
   Begin VB.ListBox LSTMovies 
      Height          =   4545
      Left            =   480
      TabIndex        =   0
      Top             =   360
      Width           =   7455
   End
End
Attribute VB_Name = "UserControl1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit


Private Sub UserControl_Initialize()
    Dim db As Database
    Set db = DBEngine.OpenDatabase("f:\movies\offline movies.mdb", False, False)
    Dim rs As Recordset
    Set rs = db.OpenRecordset("SELECT * FROM Movies", dbOpenSnapshot)
    Do While (rs.EOF = False)
        Call LSTMovies.AddItem(rs!movieName)
        rs.MoveNext
    Loop

End Sub
