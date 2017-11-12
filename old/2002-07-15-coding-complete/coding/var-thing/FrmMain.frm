VERSION 5.00
Begin VB.MDIForm FrmMain 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   9225
   ClientLeft      =   165
   ClientTop       =   450
   ClientWidth     =   12150
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   1  'CenterOwner
   WindowState     =   2  'Maximized
   Begin VB.Menu FileMenu 
      Caption         =   "File"
      Begin VB.Menu MenuVarthing 
         Caption         =   "Open Varthing"
      End
      Begin VB.Menu MenuClass 
         Caption         =   "Open Class"
      End
      Begin VB.Menu MenuOpen 
         Caption         =   "Open Project"
      End
      Begin VB.Menu MNUResizer 
         Caption         =   "Resizer"
      End
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Main Object
''
'' Coded by Dale Pitman

Public db As Database

''
Private Sub MDIForm_Load()
    
    Dim strings As New StringClass
    AppPath = strings.GetPathFromAppPath
    
    ReduencyChecker.Show
End Sub

''
Private Sub MenuClass_Click()
    Class.Show
End Sub

''
Private Sub MenuVarthing_Click()
    ReduencyChecker.Show
End Sub

Private Sub MNUResizer_Click()
    FRMResizer.Show
End Sub
