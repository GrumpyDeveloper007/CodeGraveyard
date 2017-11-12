VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.0#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Begin VB.Form FRMSummary 
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
      Height          =   195
      Index           =   3
      Left            =   1680
      OleObjectBlob   =   "FRMSummary.frx":0000
      TabIndex        =   20
      Top             =   360
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   2
      Left            =   1200
      OleObjectBlob   =   "FRMSummary.frx":0046
      TabIndex        =   19
      Top             =   360
      Width           =   375
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   1
      Left            =   720
      OleObjectBlob   =   "FRMSummary.frx":008C
      TabIndex        =   18
      Top             =   360
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLz 
      Height          =   195
      Index           =   0
      Left            =   240
      OleObjectBlob   =   "FRMSummary.frx":00D3
      TabIndex        =   17
      Top             =   360
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPanel 
      Height          =   195
      Left            =   1680
      OleObjectBlob   =   "FRMSummary.frx":0119
      TabIndex        =   16
      Top             =   600
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPaint 
      Height          =   195
      Left            =   1200
      OleObjectBlob   =   "FRMSummary.frx":0171
      TabIndex        =   15
      Top             =   600
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTRepair 
      Height          =   195
      Left            =   720
      OleObjectBlob   =   "FRMSummary.frx":01C9
      TabIndex        =   14
      Top             =   600
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTRefit 
      Height          =   195
      Left            =   240
      OleObjectBlob   =   "FRMSummary.frx":0221
      TabIndex        =   13
      Top             =   600
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTAdditionalCost 
      Height          =   195
      Left            =   1800
      OleObjectBlob   =   "FRMSummary.frx":0279
      TabIndex        =   12
      Top             =   1800
      Width           =   495
   End
   Begin IngotTextBoxCtl.AFTextBox TXTRecoveryCost 
      Height          =   195
      Left            =   1800
      OleObjectBlob   =   "FRMSummary.frx":02D1
      TabIndex        =   11
      Top             =   1560
      Width           =   495
   End
   Begin IngotButtonCtl.AFButton CMDOK 
      Height          =   255
      Left            =   0
      OleObjectBlob   =   "FRMSummary.frx":0329
      TabIndex        =   10
      Top             =   2145
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox TXTTotalTimeRequired 
      Height          =   195
      Left            =   1680
      OleObjectBlob   =   "FRMSummary.frx":0370
      TabIndex        =   0
      Top             =   840
      Width           =   615
   End
   Begin IngotLabelCtl.AFLabel LBLRecoveryCost 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSummary.frx":03C8
      TabIndex        =   1
      Top             =   1560
      Width           =   1575
   End
   Begin IngotTextBoxCtl.AFTextBox TXTPantMaterialCost 
      Height          =   195
      Left            =   2040
      OleObjectBlob   =   "FRMSummary.frx":0416
      TabIndex        =   2
      Top             =   1320
      Width           =   255
   End
   Begin IngotLabelCtl.AFLabel LBLPaintCost 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSummary.frx":046E
      TabIndex        =   3
      Top             =   1320
      Width           =   1935
   End
   Begin IngotLabelCtl.AFLabel LBLTotalTimeRequired 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSummary.frx":04CC
      TabIndex        =   4
      Top             =   840
      Width           =   1455
   End
   Begin IngotLabelCtl.AFLabel LBLPartCost 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSummary.frx":0520
      TabIndex        =   5
      Top             =   0
      Width           =   1455
   End
   Begin IngotLabelCtl.AFLabel LBLLabourRate 
      Height          =   195
      Left            =   30
      OleObjectBlob   =   "FRMSummary.frx":056A
      TabIndex        =   6
      Top             =   1080
      Width           =   1455
   End
   Begin IngotLabelCtl.AFLabel LBLAdditionalCost 
      Height          =   195
      Left            =   45
      OleObjectBlob   =   "FRMSummary.frx":05B7
      TabIndex        =   7
      Top             =   1800
      Width           =   1575
   End
   Begin IngotButtonCtl.AFButton CMDCancel 
      Height          =   255
      Left            =   1890
      OleObjectBlob   =   "FRMSummary.frx":0607
      TabIndex        =   8
      Top             =   2145
      Width           =   510
   End
   Begin IngotTextBoxCtl.AFTextBox TXTLabourRate 
      Height          =   195
      Left            =   1680
      OleObjectBlob   =   "FRMSummary.frx":0652
      TabIndex        =   9
      Top             =   1080
      Width           =   615
   End
End
Attribute VB_Name = "FRMSummary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub CMDCancel_Click()
    Call FRMMain.Show
End Sub

Public Sub CalculateCosts()
    Dim totaltime As Long
    Dim TotalRefit As Long
    Dim TotalRepair As Long
    Dim TotalPaint As Long
    Dim TotalPanel As Long
    Dim i As Long
    
    totaltime = 0
    
    For i = 0 To MaxPartIndex - 1
        Select Case RepairType(i)
            Case 0
                'new
                TotalRefit = TotalRefit + Times(i, 0) * 60 + Times(i, 1)
                TotalRepair = 0
                TotalPaint = TotalPaint + Times(i, 4) * 60 + Times(i, 5)
                TotalPanel = TotalPanel + Times(i, 6) * 60 + Times(i, 7)
            Case 1
                'repair
                TotalRefit = TotalRefit + Times(i, 0) * 60 + Times(i, 1)
                TotalRepair = TotalRepair + Times(i, 2) * 60 + Times(i, 3)
                TotalPaint = TotalPaint + Times(i, 4) * 60 + Times(i, 5)
                TotalPanel = 0
            Case 2
                'paint
                TotalRefit = TotalRefit + Times(i, 0) * 60 + Times(i, 1)
                TotalRepair = 0
                TotalPaint = TotalPaint + Times(i, 4) * 60 + Times(i, 5)
                TotalPanel = 0
            Case 3
                'refit
                TotalRefit = TotalRefit + Times(i, 0) * 60 + Times(i, 1)
                TotalRepair = 0
                TotalPaint = 0
                TotalPanel = 0
            Case Else
        End Select
        totaltime = totaltime + TotalRefit + TotalRepair + TotalPaint + TotalPanel
    Next
    TXTRefit.Text = CInt(TotalRefit / 60) & ":" & TotalRefit Mod 60
    TXTRepair.Text = CInt(TotalRepair / 60) & ":" & TotalRepair Mod 60
    TXTPaint.Text = CInt(TotalPaint / 60) & ":" & TotalPaint Mod 60
    TXTPanel.Text = CInt(TotalPanel / 60) & ":" & TotalPanel Mod 60
    
    TXTTotalTimeRequired.Text = CInt(totaltime / 60) & ":" & totaltime Mod 60
End Sub


Private Sub Form_Load()
    Call CalculateCosts
End Sub
