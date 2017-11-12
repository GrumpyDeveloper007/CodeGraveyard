VERSION 5.00
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMMain 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   2400
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2400
   BeginProperty Font 
      Name            =   "AFPalm"
      Size            =   9
      Charset         =   2
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   160
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   160
   StartUpPosition =   2  'CenterScreen
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   255
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":0000
      TabIndex        =   2
      Top             =   0
      Width           =   2175
   End
   Begin IngotButtonCtl.AFButton CMDStockCheck 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMMain.frx":005D
      TabIndex        =   1
      Top             =   2160
      Width           =   855
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   255
      Left            =   1890
      OleObjectBlob   =   "FRMMain.frx":00AD
      TabIndex        =   0
      Top             =   2160
      Width           =   510
   End
End
Attribute VB_Name = "FRMMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub CMDExit_Click()
    End
End Sub

Private Sub CMDStockCheck_Click()
    FRMStockCheck.Show
End Sub

Private Sub Form_Load()
    If (Year(Now) > 2002) Then
        Call MsgBox("This Program has expired.")
    End If
End Sub
