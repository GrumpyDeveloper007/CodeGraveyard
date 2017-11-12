VERSION 5.00
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "DateControl.ocx"
Begin VB.Form FRMReports 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Reports"
   ClientHeight    =   4365
   ClientLeft      =   765
   ClientTop       =   1470
   ClientWidth     =   8895
   HelpContextID   =   4
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   4365
   ScaleWidth      =   8895
   Begin ELFDateControl.DateControl TXTStartDate 
      Height          =   615
      Left            =   1920
      TabIndex        =   6
      Top             =   720
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin ELFDateControl.DateControl TXTFinishDate 
      Height          =   615
      Left            =   1920
      TabIndex        =   8
      Top             =   1440
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin VB.ComboBox CBOEngineer 
      Height          =   315
      Left            =   5520
      Style           =   2  'Dropdown List
      TabIndex        =   11
      Top             =   900
      Width           =   2535
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "&Print"
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   3960
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   7800
      TabIndex        =   2
      Top             =   3960
      Width           =   1095
   End
   Begin VB.OptionButton optScreen 
      Caption         =   "Screen"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   1080
      TabIndex        =   5
      Top             =   3240
      Value           =   -1  'True
      Width           =   1095
   End
   Begin VB.OptionButton optPrinter 
      Caption         =   "Printer"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   2160
      TabIndex        =   4
      Top             =   3240
      Width           =   1095
   End
   Begin VB.ComboBox CBOreportname 
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      ItemData        =   "FRMReports.frx":0000
      Left            =   1800
      List            =   "FRMReports.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   0
      ToolTipText     =   "Select report type to be printed."
      Top             =   0
      Width           =   7095
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Engineer"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   4080
      TabIndex        =   10
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Finish Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   480
      TabIndex        =   9
      Top             =   1740
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Start Date"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   9
      Left            =   480
      TabIndex        =   7
      Top             =   1020
      Width           =   1335
   End
   Begin VB.Label LBLReportComments 
      BackStyle       =   0  'Transparent
      Caption         =   "<Reports Comments>"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   0
      TabIndex        =   3
      Top             =   2760
      Width           =   8895
   End
End
Attribute VB_Name = "FRMReports"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Reports Object
''
''

Private vIsLoaded As Boolean

Private printerobject As New FRMSPrinterForm

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub DisableAll()
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CBOreportname_Click()
    ' Hide all options here
    Call DisableAll
    Select Case CBOreportname.ListIndex
        Case 0 ' Show used options here, (depending on type of report)
        Case 1
        Case 2
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
End Sub


''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub CMDPrint_Click()
    Dim SQLString As String
    
'            EngineerID= 1
'        PartInsecure= 2
'        PartWongPart= 3
'        PartNotWorking= 4
'        PartOther= 5
'        ElectricalWiring= 6
'        ElectricalConnection= 7
'        ElectricalLight= 8
'        ElectricalOther= 9
'        RepairWeld= 10
'        RepairSealWaxing= 11
'        RepairWaterIngress= 12
'        RepairOther= 13
'        PannelOther= 14
'        Internal= 15
'        Completed= 16
'        Registration= 17
'        InspectionDate= 18

'EngineerID,PartInsecure,PartWongPart,PartNotWorking,PartOther,ElectricalWiring,ElectricalConnection,ElectricalLight,ElectricalOther,RepairWeld,RepairSealWaxing,RepairWaterIngress,RepairOther,PannelOther,Internal,Completed,Registration,InspectionDate

    Screen.MousePointer = vbHourglass
    Select Case CBOreportname.ListIndex
        Case 0 ' Inspection Export report
        
            SQLString = "SELECT Registration,InspectionDate,e.name AS [Panel Engineer],f.name AS [Painter Engineer],PartInsecure,PartWongPart,PartNotWorking,PartOther,ElectricalWiring,ElectricalConnection,ElectricalLight,ElectricalOther,RepairWeld,RepairSealWaxing,RepairWaterIngress,RepairOther,PannelOther,Internal,PolishingThrough,PolishingFlattingMarks,PolishingOverSpray,PolishingOther,FinishingTouchingUp,FinishingPaint,FinishingBlackingOff,FinishingOther,PaintingSandingMarks,PaintingBareCorrosion,PaintingPaintRuns,PaintingColourMatch,PaintingShrinkage,PaintingMaskingLines,PaintingPaintEdge,PaintingBlowins,PaintingCleaning,PaintingOther,AdditionalText,RepairFillerRepair,PaintingDirtInPaint,PanelFitment,PanelAlighment,PartProblem,CleaningProblem,ma.name AS [Make Name],mo.name AS [Model Name] "
            SQLString = SQLString & " from (((inspdata i LEFT OUTER JOIN employee e ON i.PanelEngineer=e.uid) LEFT OUTER JOIN employee f ON i.PainterEngineer=f.uid) left outer join INSPmake ma ON i.inspmakeid=ma.uid) LEFT OUTER JOIN inspmodel mo ON i.inspmodelid=mo.uid "
            SQLString = SQLString & " WHERE inspectiondate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND inspectiondate<#" & Format(DateAdd("d", 1, TXTFinishDate.Text), "mm/dd/yyyy") & "#"
            If (CBOEngineer.ItemData(CBOEngineer.ListIndex) > 0) Then
                SQLString = SQLString & " AND EngineerID=" & CBOEngineer.ItemData(CBOEngineer.ListIndex)
            End If
            SQLString = SQLString & " ORDER BY e.name"
            
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
            Else
            '    Call printerobject.PrintSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
                Call Messagebox("This report is not printer friendly. Use preview option.", vbInformation)
            End If
        Case 1 ' Panel Engineer
            printerobject.FootNoteSQL = "SELECT count(uid) AS [Number Of Vehicles] FROM inspdata WHERE inspectiondate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND inspectiondate<#" & Format(DateAdd("d", 1, TXTFinishDate.Text), "mm/dd/yyyy") & "#"
            If (CBOEngineer.ItemData(CBOEngineer.ListIndex) > 0) Then
                printerobject.FootNoteSQL = printerobject.FootNoteSQL & " AND EngineerID=" & CBOEngineer.ItemData(CBOEngineer.ListIndex)
            End If
            
            SQLString = "SELECT e.name"
            ' Pannel Fields
            SQLString = SQLString & ",sum(PartInsecure) AS PartInsecure,sum(PartWongPart) AS PartWongPart,sum(PartNotWorking) AS PartNotWorking,sum(PartOther) AS PartOther,sum(ElectricalWiring) AS ElectricalWiring,sum(ElectricalConnection) AS ElectricalConnection,sum(ElectricalLight) AS ElectricalLight,sum(ElectricalOther) AS ElectricalOther"
            SQLString = SQLString & ",sum(RepairWeld) AS RepairWeld,sum(RepairSealWaxing) AS RepairSealWaxing,sum(RepairWaterIngress) AS RepairWaterIngress,sum(RepairOther) AS RepairOther,sum(PannelOther) AS PannelOther" ',sum(Internal) AS Internal
            ' Paint fields
'            SQLString = SQLString & ",sum(PolishingThrough) AS PolishingThrough,sum(PolishingFlattingMarks) AS PolishingFlattingMarks,"
'            SQLString = SQLString & "sum(PolishingOverSpray) AS PolishingOverSpray,sum(PolishingOther) AS PolishingOther,sum(FinishingTouchingUp) AS FinishingTouchingUp,sum(FinishingPaint) AS FinishingPaint,sum(FinishingBlackingOff) AS FinishingBlackingOff,sum(FinishingOther) AS FinishingOther,sum(PaintingSandingMarks) AS PaintingSandingMarks,"
'            SQLString = SQLString & "sum(PaintingBareCorrosion) AS PaintingBareCorrosion,sum(PaintingPaintRuns) AS PaintingPaintRuns,sum(PaintingColourMatch) AS PaintingColourMatch,sum(PaintingShrinkage) AS PaintingShrinkage,sum(PaintingMaskingLines) AS PaintingMaskingLines,sum(PaintingPaintEdge) AS PaintingPaintEdge,sum(PaintingBlowins) AS PaintingBlowins,"
'            SQLString = SQLString & "sum(PaintingCleaning) AS PaintingCleaning,sum(PaintingOther) AS PaintingOther "
            ' Links
            SQLString = SQLString & " FROM inspdata i LEFT OUTER JOIN employee e ON i.PainterEngineer=e.uid"
            
            SQLString = SQLString & " WHERE inspectiondate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND inspectiondate<=#" & Format(DateAdd("d", 1, TXTFinishDate.Text), "mm/dd/yyyy") & "#"
            If (CBOEngineer.ItemData(CBOEngineer.ListIndex) > 0) Then
                SQLString = SQLString & " AND EngineerID=" & CBOEngineer.ItemData(CBOEngineer.ListIndex)
            End If
            SQLString = SQLString & " GROUP BY e.name"
            
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
            Else
            '    Call printerobject.PrintSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
'                Call Messagebox("This report is not printer friendly. Use preview option.", vbInformation)
            End If
        Case 2  ' Paint Engineer
            SQLString = "SELECT e.name"
            ' Pannel Fields
'            SQLString = SQLString & ",sum(PartInsecure) AS PartInsecure,sum(PartWongPart) AS PartWongPart,sum(PartNotWorking) AS PartNotWorking,sum(PartOther) AS PartOther,sum(ElectricalWiring) AS ElectricalWiring,sum(ElectricalConnection) AS ElectricalConnection,sum(ElectricalLight) AS ElectricalLight,sum(ElectricalOther) AS ElectricalOther"
'            SQLString = SQLString & ",sum(RepairWeld) AS RepairWeld,sum(RepairSealWaxing) AS RepairSealWaxing,sum(RepairWaterIngress) AS RepairWaterIngress,sum(RepairOther) AS RepairOther,sum(PannelOther) AS PannelOther"',sum(Internal) AS Internal
            ' Paint fields
            SQLString = SQLString & ",sum(PolishingThrough) AS PolishingThrough,sum(PolishingFlattingMarks) AS PolishingFlattingMarks,"
            SQLString = SQLString & "sum(PolishingOverSpray) AS PolishingOverSpray,sum(PolishingOther) AS PolishingOther,sum(FinishingTouchingUp) AS FinishingTouchingUp,sum(FinishingPaint) AS FinishingPaint,sum(FinishingBlackingOff) AS FinishingBlackingOff,sum(FinishingOther) AS FinishingOther,sum(PaintingSandingMarks) AS PaintingSandingMarks,"
            SQLString = SQLString & "sum(PaintingBareCorrosion) AS PaintingBareCorrosion,sum(PaintingPaintRuns) AS PaintingPaintRuns,sum(PaintingColourMatch) AS PaintingColourMatch,sum(PaintingShrinkage) AS PaintingShrinkage,sum(PaintingMaskingLines) AS PaintingMaskingLines,sum(PaintingPaintEdge) AS PaintingPaintEdge,sum(PaintingBlowins) AS PaintingBlowins,"
            SQLString = SQLString & "sum(PaintingCleaning) AS PaintingCleaning,sum(PaintingOther) AS PaintingOther "
            ' Links
            SQLString = SQLString & " FROM inspdata i LEFT OUTER JOIN employee e ON i.PanelEngineer=e.uid"
            
            SQLString = SQLString & " WHERE inspectiondate>=#" & Format(TXTStartDate.Text, "mm/dd/yyyy") & "# AND inspectiondate<=#" & Format(DateAdd("d", 1, TXTFinishDate.Text), "mm/dd/yyyy") & "#"
            If (CBOEngineer.ItemData(CBOEngineer.ListIndex) > 0) Then
                SQLString = SQLString & " AND EngineerID=" & CBOEngineer.ItemData(CBOEngineer.ListIndex)
            End If
            SQLString = SQLString & " GROUP BY e.name"
            
            If (optScreen.Value = True) Then
                Call printerobject.PreviewSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
            Else
            '    Call printerobject.PrintSQL(SQLString, "Inspection Report", "0XXXXXXXXXXXXX")
'                Call Messagebox("This report is not printer friendly. Use preview option.", vbInformation)
            End If
        Case 3
        Case 4
        Case 5
        Case 6
        Case 7
        Case 8
    End Select
    
    Screen.MousePointer = vbDefault
End Sub

''
Private Sub Form_Load()
    Dim i As Long
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call DisableAll
    Call CBOreportname.AddItem("Inpection Report(export)")
    Call CBOreportname.AddItem("Panel Inpection Report(Graph)")
    Call CBOreportname.AddItem("Paint Inpection Report(Graph)")
    CBOreportname.ListIndex = 0
    Call LoadListCBO(CBOEngineer, "SELECT * FROM Employee WHERE EmployeeTypeID=0", "Name", "uid", True, True)
    Call SetPrinter(GetWorkstationSetting("REPORTPRINTER"))
    
    TXTStartDate.Text = Format(Now, "dd/mm/yyyy")
    TXTFinishDate.Text = Format(DateAdd("m", 3, Now), "dd/mm/yyyy")
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

