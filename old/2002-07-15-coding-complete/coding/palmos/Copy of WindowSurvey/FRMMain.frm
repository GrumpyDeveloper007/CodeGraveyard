VERSION 5.00
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Object = "{C4C9371C-9674-41BC-8457-C81D40452EF3}#2.0#0"; "IngotRadioButtonCtl.dll"
Object = "{F9885939-2FBB-491F-8EC3-DBC61CCFA7DB}#2.0#0"; "IngotGraphicCtl.dll"
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
   Begin IngotCheckBoxCtl.AFCheckBox CHKSnapToGrid 
      Height          =   195
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":0000
      TabIndex        =   9
      Top             =   660
      Width           =   1095
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   6
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":0056
      TabIndex        =   8
      Top             =   0
      Width           =   735
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   5
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":009A
      TabIndex        =   7
      Top             =   360
      Width           =   735
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   4
      Left            =   720
      OleObjectBlob   =   "FRMMain.frx":00E0
      TabIndex        =   6
      Top             =   180
      Width           =   615
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   3
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":0123
      TabIndex        =   5
      Top             =   420
      Width           =   615
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   2
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":0168
      TabIndex        =   4
      Top             =   240
      Width           =   615
   End
   Begin IngotButtonCtl.AFButton CMDReDraw 
      Height          =   210
      Left            =   120
      OleObjectBlob   =   "FRMMain.frx":01AC
      TabIndex        =   3
      Top             =   0
      Width           =   495
   End
   Begin IngotGraphicCtl.AFGraphic Pic 
      Height          =   1500
      Left            =   480
      OleObjectBlob   =   "FRMMain.frx":01F5
      TabIndex        =   2
      Top             =   840
      Width           =   1815
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   1
      Left            =   1560
      OleObjectBlob   =   "FRMMain.frx":021B
      TabIndex        =   1
      Top             =   180
      Width           =   615
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   195
      Index           =   0
      Left            =   1560
      OleObjectBlob   =   "FRMMain.frx":0260
      TabIndex        =   0
      Top             =   0
      Width           =   855
   End
End
Attribute VB_Name = "FRMMAin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim vline(50) As LineType
Dim MaxLine As Long

Dim vRegion(50) As RegionType
Dim Maxregion As Long

Private Type RegionType
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
    RegionType As Long
End Type

Private Type LineType
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
    LineType As Long ' x=1, y=2
End Type

''
Private Sub DrawGrid()
    Dim x As Long, y As Long
    Pic.Cls
    For y = 0 To Pic.Height Step 10
        Call Pic.DrawLine(0, y, Pic.Width, y, &H777777, 1, False)
    Next
    For x = 0 To Pic.Width Step 10
        Call Pic.DrawLine(x, 0, x, Pic.Height, &H777777, 1, False)
    Next
End Sub

''
Private Sub CMDReDraw_Click()
    Dim i As Long
    Dim dx As Long
    Dim dy As Long
'    Call Pic.Cls
    Call DrawGrid
    For i = 0 To Maxregion - 1
        dx = vRegion(i).x2 - vRegion(i).x1
        dy = vRegion(i).y2 - vRegion(i).y1
        
        Call Pic.DrawRectangle(vRegion(i).x1, vRegion(i).y1, vRegion(i).x2, vRegion(i).y2, 0, False)
        Select Case vRegion(i).RegionType
            Case 1  'left
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y1, vRegion(i).x2, vRegion(i).y1 + dy / 2, 0, 1, False)
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y2, vRegion(i).x2, vRegion(i).y1 + dy / 2, 0, 1, False)
            Case 2  'right
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y1 + dy / 2, vRegion(i).x2, vRegion(i).y1, 0, 1, False)
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y1 + dy / 2, vRegion(i).x2, vRegion(i).y2, 0, 1, False)
            Case 3  'top
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y1, vRegion(i).x1 + dx / 2, vRegion(i).y2, 0, 1, False)
                Call Pic.DrawLine(vRegion(i).x2, vRegion(i).y1, vRegion(i).x1 + dx / 2, vRegion(i).y2, 0, 1, False)
            Case 4  'bottom
                Call Pic.DrawLine(vRegion(i).x1, vRegion(i).y2, vRegion(i).x1 + dx / 2, vRegion(i).y1, 0, 1, False)
                Call Pic.DrawLine(vRegion(i).x2, vRegion(i).y2, vRegion(i).x1 + dx / 2, vRegion(i).y1, 0, 1, False)
        End Select
    Next
End Sub

Private Sub Form_Load()
    MaxLine = 0
    vRegion(0).x1 = 0
    vRegion(0).y1 = 0
    vRegion(0).x2 = Pic.Width - 1
    vRegion(0).y2 = Pic.Height - 1
    vRegion(0).RegionType = 0
    Maxregion = 1
    Call DrawGrid
    Call Pic.DrawRectangle(vRegion(0).x1, vRegion(0).y1, vRegion(0).x2, vRegion(0).y2, 0, False)
End Sub

Private Sub Pic_MouseDown(ByVal x As Long, ByVal y As Long)
    Dim x1 As Long, y1 As Long, x2 As Long, y2 As Long
    Dim LineType As Long
    Dim i As Long
    Dim RegionIndex As Long
    Dim RegionFound As Boolean
    
    If (CHKSnapToGrid.Value = afCheckBoxValueChecked) Then
        If (x Mod 10 < 5) Then
            x = x - x Mod 10
        Else
            x = x - x Mod 10 + 10
        End If
        If (y Mod 10 < 5) Then
            y = y - y Mod 10
        Else
            y = y - y Mod 10 + 10
        End If
    End If
    
    RegionIndex = 0
    RegionFound = False
    Do While (RegionFound = False And RegionIndex < Maxregion)
        If (x >= vRegion(RegionIndex).x1 And x < vRegion(RegionIndex).x2 _
         And y >= vRegion(RegionIndex).y1 And y < vRegion(RegionIndex).y2) Then
            RegionFound = True
        Else
            RegionIndex = RegionIndex + 1
        End If
    Loop
    
    If (OPTAlign(0).Value = True) Then
        ' vert
        x1 = x
        y1 = 0
        x2 = x
        y2 = Pic.Height
        LineType = 2
        
        ' split region by v
        vRegion(Maxregion).x1 = x
        vRegion(Maxregion).y1 = vRegion(RegionIndex).y1
        vRegion(Maxregion).x2 = vRegion(RegionIndex).x2
        vRegion(Maxregion).y2 = vRegion(RegionIndex).y2
        vRegion(Maxregion).RegionType = vRegion(RegionIndex).RegionType
        
'        vRegion(RegionIndex).x1
'        vRegion(RegionIndex).y1
        vRegion(RegionIndex).x2 = x
'        vRegion(RegionIndex).y2
        
        Maxregion = Maxregion + 1
    Else
        If (OPTAlign(1).Value = True) Then
            'horiz
            x1 = 0
            y1 = y
            x2 = Pic.Width
            y2 = y
            LineType = 1
        
            ' split region by v
            vRegion(Maxregion).x1 = vRegion(RegionIndex).x1
            vRegion(Maxregion).y1 = y
            vRegion(Maxregion).x2 = vRegion(RegionIndex).x2
            vRegion(Maxregion).y2 = vRegion(RegionIndex).y2
            vRegion(Maxregion).RegionType = vRegion(RegionIndex).RegionType
            
    '        vRegion(RegionIndex).x1
    '        vRegion(RegionIndex).y1
    '        vRegion(RegionIndex).x2 = x
            vRegion(RegionIndex).y2 = y
            
            Maxregion = Maxregion + 1
        Else
            If (OPTAlign(2).Value = True) Then
                'left
                vRegion(RegionIndex).RegionType = 1
            Else
                If (OPTAlign(3).Value = True) Then
                    'right
                    vRegion(RegionIndex).RegionType = 2
                Else
                    If (OPTAlign(4).Value = True) Then
                        'top
                        vRegion(RegionIndex).RegionType = 3
                    Else
                        If (OPTAlign(5).Value = True) Then
                            ' bottom
                            vRegion(RegionIndex).RegionType = 4
                        Else
                            ' none
                            vRegion(RegionIndex).RegionType = 0
                        End If
                    End If
                End If
            End If
        
        End If
    End If
    
    
    For i = 0 To MaxLine - 1
        If (vline(i).LineType <> LineType) Then
            If (vline(i).LineType = 2) Then
                ' check bounds
                If (y > vline(i).y1 And y < vline(i).y2) Then
                    If (x < vline(i).x1) Then
                        If (x2 > vline(i).x1) Then
                            x2 = vline(i).x1
                        End If
                    Else
                        If (x1 < vline(i).x1) Then
                            x1 = vline(i).x1
                        End If
                    End If
                End If
            Else
'            If (vline(i).LineType = 1) Then
                ' check bounds
                If (x > vline(i).x1 And x < vline(i).x2) Then
                    If (y < vline(i).y1) Then
                        ' check bounds
                        If (y2 > vline(i).y1) Then
                            y2 = vline(i).y1
                        End If
                    Else
                        If (y1 < vline(i).y1) Then
                            y1 = vline(i).y1
                        End If
                    End If
                End If
            End If
        End If
    Next
     
    If (OPTAlign(0).Value = True Or OPTAlign(1).Value = True) Then
'        Call Pic.DrawLine(x1, y1, x2, y2, 1, 1, False)
        
        vline(MaxLine).x1 = x1
        vline(MaxLine).y1 = y1
        vline(MaxLine).x2 = x2
        vline(MaxLine).y2 = y2
        vline(MaxLine).LineType = LineType
        MaxLine = MaxLine + 1
    End If
    Call CMDReDraw_Click
End Sub
