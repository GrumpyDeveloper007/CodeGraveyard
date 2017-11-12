VERSION 5.00
Object = "{1A028BB9-0262-48D8-9B67-D74CE4C2A7E8}#2.0#0"; "IngotTextBoxCtl.dll"
Object = "{A54BEB34-AAB3-4A8D-B736-42CB4DA7D664}#2.0#0"; "IngotComboBoxCtl.dll"
Object = "{BAE83016-CA11-4D8A-BBFA-0AE9863B82DE}#2.1#0"; "IngotLabelCtl.dll"
Object = "{9F4EED48-8EC7-4316-A47D-F6161874E478}#2.0#0"; "IngotButtonCtl.dll"
Object = "{899CE9D8-3C9F-48DF-B418-E338294B00E3}#2.0#0"; "IngotCheckBoxCtl.dll"
Object = "{C4C9371C-9674-41BC-8457-C81D40452EF3}#2.0#0"; "IngotRadioButtonCtl.dll"
Object = "{F9885939-2FBB-491F-8EC3-DBC61CCFA7DB}#2.0#0"; "IngotGraphicCtl.dll"
Begin VB.Form FRMDesigner 
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
   Begin IngotTextBoxCtl.AFTextBox TXTPoints 
      Height          =   180
      Left            =   2175
      OleObjectBlob   =   "FRMDesigner.frx":0000
      TabIndex        =   19
      Top             =   735
      Width           =   225
   End
   Begin IngotTextBoxCtl.AFTextBox TXTSpans 
      Height          =   180
      Left            =   2175
      OleObjectBlob   =   "FRMDesigner.frx":0058
      TabIndex        =   18
      Top             =   540
      Width           =   225
   End
   Begin IngotTextBoxCtl.AFTextBox TXTAngle 
      Height          =   180
      Left            =   1470
      OleObjectBlob   =   "FRMDesigner.frx":00B0
      TabIndex        =   17
      Top             =   0
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLAngle 
      Height          =   180
      Left            =   990
      OleObjectBlob   =   "FRMDesigner.frx":0108
      TabIndex        =   16
      Top             =   0
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTDepth 
      Height          =   180
      Left            =   480
      OleObjectBlob   =   "FRMDesigner.frx":0152
      TabIndex        =   15
      Top             =   195
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLDepth 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":01AA
      TabIndex        =   14
      Top             =   195
      Width           =   375
   End
   Begin IngotTextBoxCtl.AFTextBox TXTWidth 
      Height          =   180
      Left            =   480
      OleObjectBlob   =   "FRMDesigner.frx":01F4
      TabIndex        =   13
      Top             =   0
      Width           =   495
   End
   Begin IngotLabelCtl.AFLabel LBLWidth 
      Height          =   180
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":024C
      TabIndex        =   12
      Top             =   0
      Width           =   375
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKShowGrid 
      Height          =   195
      Left            =   1200
      OleObjectBlob   =   "FRMDesigner.frx":0296
      TabIndex        =   11
      Top             =   165
      Width           =   1095
   End
   Begin IngotButtonCtl.AFButton AFButton1 
      Height          =   240
      Left            =   2130
      OleObjectBlob   =   "FRMDesigner.frx":02E9
      TabIndex        =   10
      Top             =   1350
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDLeft 
      Height          =   240
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":032F
      TabIndex        =   9
      Top             =   2160
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDRight 
      Height          =   240
      Left            =   360
      OleObjectBlob   =   "FRMDesigner.frx":0375
      TabIndex        =   8
      Top             =   2160
      Width           =   255
   End
   Begin IngotButtonCtl.AFButton CMDTemplate 
      Height          =   240
      Left            =   1005
      OleObjectBlob   =   "FRMDesigner.frx":03BB
      TabIndex        =   7
      Top             =   2160
      Width           =   735
   End
   Begin IngotGraphicCtl.AFGraphic Pic 
      Height          =   1500
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":0408
      TabIndex        =   1
      Top             =   540
      Width           =   2100
   End
   Begin IngotButtonCtl.AFButton CMDExit 
      Height          =   240
      Left            =   1890
      OleObjectBlob   =   "FRMDesigner.frx":042E
      TabIndex        =   6
      Top             =   2160
      Width           =   510
   End
   Begin IngotCheckBoxCtl.AFCheckBox CHKSnapToGrid 
      Height          =   195
      Left            =   1200
      OleObjectBlob   =   "FRMDesigner.frx":0477
      TabIndex        =   5
      Top             =   0
      Width           =   1095
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   180
      Index           =   2
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":04CD
      TabIndex        =   4
      Top             =   360
      Width           =   615
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   180
      Index           =   1
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":0513
      TabIndex        =   3
      Top             =   180
      Width           =   615
   End
   Begin IngotRadioButtonCtl.AFRadioButton OPTAlign 
      Height          =   180
      Index           =   0
      Left            =   0
      OleObjectBlob   =   "FRMDesigner.frx":0558
      TabIndex        =   2
      Top             =   0
      Width           =   735
   End
   Begin IngotComboBoxCtl.AFComboBox CBOObjectType 
      Height          =   240
      Left            =   720
      OleObjectBlob   =   "FRMDesigner.frx":05A0
      TabIndex        =   0
      Top             =   300
      Width           =   1485
   End
End
Attribute VB_Name = "FRMDesigner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
Private Const cGridX As Long = 20
Private Const cGridY As Long = 20

Private Enum DesignerENUM
    DesignerMode = 1
    DetailMode = 2
End Enum

Private Type PointTYPE
    x1 As Long
    Depth As Double
    Angle As Double
End Type
    
Private Type XSpanTYPE
    x1 As Long
    x2 As Long
    Width As Double
End Type

Private Type RegionType
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
    RegionType As Long
End Type

Private vRegion(50) As RegionType
Private vMaxregion As Long

Private vSpan(50) As XSpanTYPE
Private vMaxSpan As Long

Private vPoint(50) As PointTYPE
Private vMaxPoint As Long

Private vDesignerMode As DesignerENUM
Private vCurrentSpan As Long
Private vCurrentPoint As Long

Private Sub EnterDrawMode()
    OPTAlign(0).Visible = True
    OPTAlign(1).Visible = True
    OPTAlign(2).Visible = True
    CHKSnapToGrid.Visible = True
    CHKShowGrid.Visible = True
    CBOObjectType.Visible = True
    
    LBLWidth.Visible = False
    TXTWidth.Visible = False
    LBLDepth.Visible = False
    TXTDepth.Visible = False
    LBLAngle.Visible = False
    TXTAngle.Visible = False
    
    vDesignerMode = DesignerMode
    vCurrentSpan = -1
    vCurrentPoint = -1
    Call ReDraw
End Sub

Private Sub HightLightPoint()
    If (vCurrentPoint > -1) Then
        If (vPoint(vCurrentPoint).Angle = 0) Then
            TXTAngle.Text = ""
        Else
            TXTAngle.Text = vPoint(vCurrentPoint).Angle
        End If
        If (vPoint(vCurrentPoint).Depth = 0) Then
            TXTDepth.Text = ""
        Else
            TXTDepth.Text = vPoint(vCurrentPoint).Depth
        End If
        Call Pic.SetPixel(vPoint(vCurrentPoint).x1 - 1, Pic.Height - 2, 0)
        Call Pic.SetPixel(vPoint(vCurrentPoint).x1, Pic.Height - 2, 0)
        Call Pic.SetPixel(vPoint(vCurrentPoint).x1 + 1, Pic.Height - 2, 0)
    End If
End Sub

Private Sub HightLightSpan()
    If (vCurrentSpan > -1) Then
        If (vSpan(vCurrentSpan).Width = 0) Then
            TXTWidth.Text = ""
        Else
            TXTWidth.Text = vSpan(vCurrentSpan).Width
        End If
        Call Pic.DrawLine(vSpan(vCurrentSpan).x1, 1, vSpan(vCurrentSpan).x2, 1, 0, 3, False)
    End If
End Sub

Private Sub EnterWidthMode()
    OPTAlign(0).Visible = False
    OPTAlign(1).Visible = False
    OPTAlign(2).Visible = False
    CHKSnapToGrid.Visible = False
    CHKShowGrid.Visible = False
    CBOObjectType.Visible = False
    
    LBLWidth.Visible = True
    TXTWidth.Visible = True
    If (FRMDetails1.CHKBayWindow.Value = afCheckBoxValueChecked) Then
        LBLDepth.Visible = True
        TXTDepth.Visible = True
        LBLAngle.Visible = True
        TXTAngle.Visible = True
    End If
    
    vDesignerMode = DetailMode
    Call ReDraw
End Sub

Public Sub ClearRegions()
    vMaxregion = 0
End Sub

''
Public Sub AddRegion(px1 As Long, py1 As Long, px2 As Long, py2 As Long, pRegionType As Long)
    vRegion(vMaxregion).x1 = px1
    vRegion(vMaxregion).y1 = py1
    vRegion(vMaxregion).x2 = px2
    vRegion(vMaxregion).y2 = py2
    vRegion(vMaxregion).RegionType = pRegionType
    vMaxregion = vMaxregion + 1
End Sub

''
Public Sub CompleteRegion()
    Call BuildSpansAndPoints
End Sub



''
Private Sub DrawGrid()
    Dim x As Long, y As Long
    Pic.Cls
    If (CHKShowGrid.Value = afCheckBoxValueChecked) Then
        For y = 0 To Pic.Height Step cGridY
            Call Pic.DrawLine(0, y, Pic.Width, y, &H575757, 1, False)
        Next
        For x = 0 To Pic.Width Step cGridX
            Call Pic.DrawLine(x, 0, x, Pic.Height, &H575757, 1, False)
        Next
    End If
End Sub

''
Private Sub CompactFromN(RemoveIndex As Long)
    Dim i As Long
    For i = RemoveIndex To vMaxregion - 1
        vRegion(i).x1 = vRegion(i + 1).x1
        vRegion(i).y1 = vRegion(i + 1).y1
        vRegion(i).x2 = vRegion(i + 1).x2
        vRegion(i).y2 = vRegion(i + 1).y2
        vRegion(i).RegionType = vRegion(i + 1).RegionType
    Next
    vMaxregion = vMaxregion - 1
End Sub

''
Public Sub ReDraw()
    Dim i As Long
    Dim dx As Long
    Dim dy As Long
    Dim sx As Double
    Dim sy As Double
'    Call Pic.Cls
    Call DrawGrid
    For i = 0 To vMaxregion - 1
        dx = vRegion(i).x2 - vRegion(i).x1
        dy = vRegion(i).y2 - vRegion(i).y1
        sx = dx / 8
        sy = dy / 8
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
            Case 5  'Door
                Call Pic.DrawRectangle(vRegion(i).x1 + sx, vRegion(i).y1 + sy, vRegion(i).x1 + sx * 3, vRegion(i).y1 + sy * 3, 0, False)
                Call Pic.DrawRectangle(vRegion(i).x1 + sx * 5, vRegion(i).y1 + sy, vRegion(i).x1 + sx * 7, vRegion(i).y1 + sy * 3, 0, False)
            
                Call Pic.DrawRectangle(vRegion(i).x1 + sx, vRegion(i).y1 + sy * 5, vRegion(i).x1 + sx * 3, vRegion(i).y1 + sy * 7, 0, False)
                Call Pic.DrawRectangle(vRegion(i).x1 + sx * 5, vRegion(i).y1 + sy * 5, vRegion(i).x1 + sx * 7, vRegion(i).y1 + sy * 7, 0, False)
            
                Call Pic.DrawRectangle(vRegion(i).x1 + sx * 1.5, vRegion(i).y1 + sy * 3.5, vRegion(i).x1 + sx * 6.5, vRegion(i).y1 + sy * 4.5, 0, False)
            
'                Call Pic.DrawText(vRegion(i).x1 + dx / 2, vRegion(i).y1 + dy / 4, 0, "AFPalm", 12, 0, "Door")

        End Select
    Next
    
    Call HightLightPoint
    Call HightLightSpan
End Sub

Private Sub AFButton1_Click()
    Dim x As Long, y As Long
    For y = 0 To Pic.Height / 2
        For x = 0 To Pic.Width
            Call Pic.SetPixel(x, y, &H7F7F7F)
            Call Pic.Refresh
        Next
    Next
End Sub

Private Sub CBOObjectType_Click()
    OPTAlign(2).Value = True
End Sub

Private Sub CHKShowGrid_Click()
    Call ReDraw
End Sub

Private Sub CMDAnanyse_Click()
End Sub

Private Sub CMDExit_Click()
    Call Me.Hide
    Call FRMMain.Show
End Sub


Private Sub CMDLeft_Click()
    If (vDesignerMode = DesignerMode) Then
        Me.Hide
        FRMDetails2.Show
    Else
        Call EnterDrawMode
    End If
End Sub

Private Sub CMDRight_Click()
    If (vDesignerMode = DesignerMode) Then
        Call EnterWidthMode
    Else
        Me.Hide
        FRMMain.Show
    End If
End Sub

Private Sub CMDTemplate_Click()
    Me.Hide
    FRMSelectTemplate.Show
End Sub

Private Sub Form_Load()
    vRegion(0).x1 = 0
    vRegion(0).y1 = 0
    vRegion(0).x2 = Pic.Width - 1
    vRegion(0).y2 = Pic.Height - 1
    vRegion(0).RegionType = 0
    vMaxregion = 1
    Call DrawGrid
    Call Pic.DrawRectangle(vRegion(0).x1, vRegion(0).y1, vRegion(0).x2, vRegion(0).y2, 0, False)
    
    Call CBOObjectType.AddItem("None")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 0
    Call CBOObjectType.AddItem("Left")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 1
    Call CBOObjectType.AddItem("Right")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 2
    Call CBOObjectType.AddItem("Top")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 3
    Call CBOObjectType.AddItem("Bottom")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 4
    Call CBOObjectType.AddItem("Door")
    CBOObjectType.ItemData(CBOObjectType.ListCount - 1) = 5
    CBOObjectType.ListIndex = 0
    
    Call EnterDrawMode
End Sub

Private Sub Pic_MouseDown(ByVal x As Long, ByVal y As Long)
    Dim x1 As Long, y1 As Long, x2 As Long, y2 As Long
    Dim LineType As Long
    Dim i As Long
    Dim RegionIndex As Long
    Dim RegionFound As Boolean
    
    
    If (OPTAlign(0).Value = True) Then
        ' vert
        If (y Mod 20 < 10) Then
            y = y - y Mod cGridY
        Else
            y = y - y Mod cGridY '+ 10
        End If
    Else
        If (OPTAlign(1).Value = True) Then
            ' horiz
            If (x Mod 20 < 10) Then
                x = x - x Mod cGridX
            Else
                x = x - x Mod cGridX '+ 10
            End If
        Else
        End If
    End If
    
    RegionIndex = 0
    RegionFound = False
    Do While (RegionFound = False And RegionIndex < vMaxregion)
        If (x >= vRegion(RegionIndex).x1 And x < vRegion(RegionIndex).x2 _
         And y >= vRegion(RegionIndex).y1 And y < vRegion(RegionIndex).y2) Then
            RegionFound = True
        Else
            RegionIndex = RegionIndex + 1
        End If
    Loop
    
    If (vDesignerMode = DesignerMode) Then
        ' in edit mode
        If (CHKSnapToGrid.Value = afCheckBoxValueChecked) Then
            If (x Mod 20 < 10) Then
                x = x - x Mod cGridX
            Else
                x = x - x Mod cGridX '+ 10
            End If
            If (y Mod 20 < 10) Then
                y = y - y Mod cGridY
            Else
                y = y - y Mod cGridY ' + 10
            End If
        End If
        
        If (OPTAlign(0).Value = True) Then
            ' vert
            x1 = x
            y1 = 0
            x2 = x
            y2 = Pic.Height
            LineType = 2
            
            If (vRegion(RegionIndex).x2 = x Or vRegion(RegionIndex).x1 = x) Then
                ' Unable to split region
                For i = 0 To vMaxregion - 1
                    If (i <> RegionIndex) Then
                        If (vRegion(i).y1 = vRegion(RegionIndex).y1 _
                         And vRegion(i).y2 = vRegion(RegionIndex).y2) Then
                            If (vRegion(i).x1 = x) Then
                                ' i=right,regionindex=left
                                vRegion(RegionIndex).x2 = vRegion(i).x2
                                Call CompactFromN(i)
                            Else
                                If (vRegion(i).x2 = x) Then
                                    ' i=left,regionindex=right
                                    vRegion(i).x2 = vRegion(RegionIndex).x2
                                    Call CompactFromN(RegionIndex)
                                End If
                            End If
                        End If
                    End If
                Next
            Else
                ' split region by v
                vRegion(vMaxregion).x1 = x
                vRegion(vMaxregion).y1 = vRegion(RegionIndex).y1
                vRegion(vMaxregion).x2 = vRegion(RegionIndex).x2
                vRegion(vMaxregion).y2 = vRegion(RegionIndex).y2
                vRegion(vMaxregion).RegionType = vRegion(RegionIndex).RegionType
                
                vRegion(RegionIndex).x2 = x
                
                vMaxregion = vMaxregion + 1
                
            End If
            Call BuildSpansAndPoints
        Else
            If (OPTAlign(1).Value = True) Then
                'horiz
                x1 = 0
                y1 = y
                x2 = Pic.Width
                y2 = y
                LineType = 1
            
                If (vRegion(RegionIndex).y2 = y Or vRegion(RegionIndex).y1 = y) Then
                    ' Unable to split region
                    For i = 0 To vMaxregion - 1
                        If (i <> RegionIndex) Then
                            If (vRegion(i).x1 = vRegion(RegionIndex).x1 _
                             And vRegion(i).x2 = vRegion(RegionIndex).x2) Then
                                If (vRegion(i).y1 = y) Then
                                    ' i=right,regionindex=left
                                    vRegion(RegionIndex).y2 = vRegion(i).y2
                                    Call CompactFromN(i)
                                Else
                                    If (vRegion(i).y2 = y) Then
                                        ' i=left,regionindex=right
                                        vRegion(i).y2 = vRegion(RegionIndex).y2
                                        Call CompactFromN(RegionIndex)
                                    End If
                                End If
                            End If
                        End If
                    Next
                Else
                    ' split region by v
                    vRegion(vMaxregion).x1 = vRegion(RegionIndex).x1
                    vRegion(vMaxregion).y1 = y
                    vRegion(vMaxregion).x2 = vRegion(RegionIndex).x2
                    vRegion(vMaxregion).y2 = vRegion(RegionIndex).y2
                    vRegion(vMaxregion).RegionType = vRegion(RegionIndex).RegionType
                    
                    vRegion(RegionIndex).y2 = y
                    
                    vMaxregion = vMaxregion + 1
                    
                End If
                Call BuildSpansAndPoints
            Else
                If (OPTAlign(2).Value = True) Then
                    ' Object
                    vRegion(RegionIndex).RegionType = CBOObjectType.ItemData(CBOObjectType.ListIndex)
                Else
                End If
            
            End If
        End If
    Else
        ' In edit detail mode, select focus
        
        ' Select span
        vCurrentSpan = -1
        For i = 0 To vMaxSpan - 1
            If (vRegion(RegionIndex).x1 = vSpan(i).x1 And vRegion(RegionIndex).x2 = vSpan(i).x2) Then
                vCurrentSpan = i
            End If
        Next
        
        'select point
        vCurrentPoint = -1
        For i = 0 To vMaxPoint - 1
            If (vRegion(RegionIndex).x1 = vPoint(i).x1) Then
                vCurrentPoint = i
            End If
        Next
        
        If (vCurrentPoint = -1) Then
            ' try x2
            For i = 0 To vMaxPoint - 1
                If (vRegion(RegionIndex).x2 = vPoint(i).x1) Then
                    vCurrentPoint = i
                End If
            Next
        End If
        
    End If
    
    Call ReDraw
End Sub

''
Private Sub BuildSpansAndPoints()
    Dim i As Long
    Dim SpanIndex As Long
    Dim PointIndex As Long
    Dim Found As Boolean
    vSpan(0).x1 = 0
    vSpan(0).x2 = Pic.Width - 1
    vSpan(0).Width = 0
    vMaxSpan = 1
    
    For i = 0 To vMaxregion - 1
        For SpanIndex = 0 To vMaxSpan - 1
            If (vRegion(i).x1 > vSpan(SpanIndex).x1 And vRegion(i).x1 < vSpan(SpanIndex).x2) Then
                ' Split region on x1
                vSpan(vMaxSpan).x1 = vRegion(i).x1
                vSpan(vMaxSpan).x2 = vSpan(SpanIndex).x2
                vSpan(vMaxSpan).Width = 0
                vMaxSpan = vMaxSpan + 1
                
                'vSpan(SpanIndex).x1 = 0
                vSpan(SpanIndex).x2 = vRegion(i).x1
                vSpan(SpanIndex).Width = 0
            End If
            
            If (vRegion(i).x2 < vSpan(SpanIndex).x2 And vRegion(i).x2 > vSpan(SpanIndex).x1) Then
                ' Split region on x2
                vSpan(vMaxSpan).x1 = vRegion(i).x2
                vSpan(vMaxSpan).x2 = vSpan(SpanIndex).x2
                vSpan(vMaxSpan).Width = 0
                vMaxSpan = vMaxSpan + 1
                
               ' vSpan(SpanIndex).x1 = 0
                vSpan(SpanIndex).x2 = vRegion(i).x2
                vSpan(SpanIndex).Width = 0
            End If
        Next
    Next
    Pic.Cls
    For i = 0 To vMaxSpan - 1
        Call Pic.DrawLine(vSpan(i).x1, 0, vSpan(i).x1, Pic.Height, &H0, 1, False)
        Call Pic.DrawLine(vSpan(i).x2, 0, vSpan(i).x2, Pic.Height, &H0, 1, False)
    Next
    
    ' Get Points
    vMaxPoint = 0
    For i = 0 To vMaxSpan - 1
        Found = False
        For PointIndex = 0 To vMaxPoint - 1
            If (vPoint(PointIndex).x1 = vSpan(i).x1) Then
                Found = True
            End If
        Next
        If (Found = False) Then
            vPoint(vMaxPoint).x1 = vSpan(i).x1
            vMaxPoint = vMaxPoint + 1
        End If
        
        Found = False
        For PointIndex = 0 To vMaxPoint - 1
            If (vPoint(PointIndex).x1 = vSpan(i).x2) Then
                Found = True
            End If
        Next
        If (Found = False) Then
            vPoint(vMaxPoint).x1 = vSpan(i).x2
            vMaxPoint = vMaxPoint + 1
        End If
    Next
    
    ' Remove exterior points, left
    i = 0
    For PointIndex = 1 To vMaxPoint - 1
        If (vPoint(PointIndex).x1 < vPoint(i).x1) Then
            i = PointIndex
        End If
    Next
    ' compress list
    For PointIndex = i To vMaxPoint - 1
        vPoint(PointIndex).x1 = vPoint(PointIndex + 1).x1
    Next
    vMaxPoint = vMaxPoint - 1

    ' Remove exterior points, right
    i = 0
    For PointIndex = 1 To vMaxPoint - 1
        If (vPoint(PointIndex).x1 > vPoint(i).x1) Then
            i = PointIndex
        End If
    Next
    ' compress list
    For PointIndex = i To vMaxPoint - 1
        vPoint(PointIndex).x1 = vPoint(PointIndex + 1).x1
    Next
    vMaxPoint = vMaxPoint - 1
    
    TXTSpans.Text = vMaxSpan
    TXTPoints.Text = vMaxPoint
End Sub

Private Sub TXTAngle_Change()
    TXTAngle.Text = RemoveNonNumericCharacters(TXTAngle.Text, 8)
    If (vCurrentPoint > -1) Then
        vPoint(vCurrentPoint).Angle = CLng("0" & TXTAngle.Text)
    End If
End Sub

Private Sub TXTDepth_Change()
    TXTDepth.Text = RemoveNonNumericCharacters(TXTDepth.Text, 8)
    If (vCurrentPoint > -1) Then
        vPoint(vCurrentPoint).Depth = CLng("0" & TXTDepth.Text)
    End If
End Sub

Private Sub TXTWidth_Change()
    TXTWidth.Text = RemoveNonNumericCharacters(TXTWidth.Text, 8)
    If (vCurrentSpan > -1) Then
        vSpan(vCurrentSpan).Width = CLng("0" & TXTWidth.Text)
    End If
End Sub
