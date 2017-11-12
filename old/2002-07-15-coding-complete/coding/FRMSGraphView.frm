VERSION 5.00
Object = "{65E121D4-0C60-11D2-A9FC-0000F8754DA1}#2.0#0"; "mschrt20.ocx"
Begin VB.Form FRMSGraphView 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Graph View"
   ClientHeight    =   8595
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11265
   HelpContextID   =   803
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   8595
   ScaleWidth      =   11265
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00FFFFFF&
      ClipControls    =   0   'False
      Height          =   8205
      Left            =   45
      ScaleHeight     =   8145
      ScaleWidth      =   11085
      TabIndex        =   2
      Top             =   390
      Width           =   11145
      Begin MSChart20Lib.MSChart MSChart1 
         Height          =   8130
         Left            =   0
         OleObjectBlob   =   "FRMSGraphView.frx":0000
         TabIndex        =   3
         Top             =   0
         Width           =   11055
      End
   End
   Begin VB.CommandButton CMDCancel 
      Caption         =   "Exit"
      Height          =   375
      Left            =   5880
      TabIndex        =   1
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "Print"
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   0
      Visible         =   0   'False
      Width           =   1095
   End
End
Attribute VB_Name = "FRMSGraphView"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Graph Print Object
''

Private vIsLoaded As Boolean

''
Public Function PrintSQL(pSql As String, pHeading As String, pFootNoteSQL As String)
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim MaxValue As Long

    Dim Column As Long
    Dim row As Long
    Dim index1 As Long
    Dim index2 As Long
    Dim index3 As Long
    Dim index4 As Long
    
    If (OpenRecordset(rstemp, pSql, dbOpenSnapshot)) Then
    With MSChart1
        ' Displays a 3d chart with 8 columns and 8 rows
        ' data.
        .chartType = VtChChartType2dBar ' VtChChartType3dBar
        .ColumnCount = 1
        .TitleText = "" 'rstemp.Fields(0).Value
        .RowCount = rstemp.Fields.Count - 1
        
        MaxValue = 0
        .Column = 1 'Column
        .ColumnLabel = "Number of faults"
        For row = 1 To rstemp.Fields.Count - 1
            .row = row
            .Data = 0
            .RowLabel = rstemp.Fields(row).Name
        Next
        
        Do While (rstemp.EOF = False)
            For row = 1 To rstemp.Fields.Count - 1
                .row = row
                .Data = .Data + Val(rstemp.Fields(row).Value & "")
                If (MaxValue < .Data) Then
                    MaxValue = .Data
                End If
            Next
            .TitleText = .TitleText & rstemp.Fields(0).Value & ","
            Call rstemp.MoveNext
        Loop
        .TitleText = Left$(.TitleText, Len(.TitleText) - 1)
        'Next Column
        .Plot.Axis(VtChAxisIdY).ValueScale.Maximum = MaxValue
        If (MaxValue <= 25) Then
            .Plot.Axis(VtChAxisIdY).ValueScale.MajorDivision = MaxValue
        Else
            If (MaxValue <= 100) Then
                .Plot.Axis(VtChAxisIdY).ValueScale.MajorDivision = MaxValue / 10
            Else
                If (MaxValue <= 500) Then
                    .Plot.Axis(VtChAxisIdY).ValueScale.MajorDivision = MaxValue / 20
                Else
                    If (MaxValue <= 5000) Then
                        .Plot.Axis(VtChAxisIdY).ValueScale.MajorDivision = MaxValue / 100
                    Else
                        .Plot.Axis(VtChAxisIdY).ValueScale.MajorDivision = MaxValue / 1000
                    End If
                End If
            End If
        End If
        
        ' Do footer
        .FootnoteText = ""
        If (pFootNoteSQL <> "") Then
            If (OpenRecordset(rstemp2, pFootNoteSQL, dbOpenSnapshot)) Then
                Do While (rstemp2.EOF = False)
                    .FootnoteText = .FootnoteText & rstemp2.Fields(0).Name & " - " & rstemp2.Fields(0).Value
                    Call rstemp2.MoveNext
                Loop
            End If
        End If
        
    End With
   End If
End Function

''
Private Sub CMDCancel_Click()
    Call Unload(Me)
End Sub

Private Sub CMDPrint_Click()
    Call Printer.PaintPicture(MSChart1, 5, 5)
    Call Printer.EndDoc
End Sub

Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub
