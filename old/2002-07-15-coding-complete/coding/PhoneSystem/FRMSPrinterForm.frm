VERSION 5.00
Begin VB.Form FRMSPrinterForm 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Print Preview"
   ClientHeight    =   8595
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11265
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   8595
   ScaleWidth      =   11265
   Begin VB.CommandButton CMDExport 
      Caption         =   "Export"
      Height          =   375
      Left            =   3840
      TabIndex        =   9
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrevPage 
      Caption         =   "Prev Page"
      Height          =   375
      Left            =   120
      TabIndex        =   8
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton CMDPrint 
      Caption         =   "Print"
      Height          =   375
      Left            =   2640
      TabIndex        =   7
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton CMDCancel 
      Caption         =   "Exit"
      Height          =   375
      Left            =   6240
      TabIndex        =   6
      Top             =   0
      Width           =   1095
   End
   Begin VB.VScrollBar ScrV 
      Height          =   7695
      Left            =   10920
      Max             =   10
      TabIndex        =   5
      Top             =   480
      Width           =   230
   End
   Begin VB.HScrollBar ScrH 
      Height          =   230
      Left            =   120
      Max             =   10
      TabIndex        =   4
      Top             =   8280
      Width           =   10695
   End
   Begin VB.ComboBox CBOScale 
      Height          =   315
      ItemData        =   "FRMSPrinterForm.frx":0000
      Left            =   5040
      List            =   "FRMSPrinterForm.frx":000F
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   0
      Width           =   1095
   End
   Begin VB.CommandButton CMDNextPage 
      Caption         =   "Next Page"
      Height          =   375
      Left            =   1320
      TabIndex        =   1
      Top             =   0
      Width           =   1095
   End
   Begin VB.PictureBox PicPrintPreviewBox 
      AutoRedraw      =   -1  'True
      CausesValidation=   0   'False
      Height          =   7695
      Left            =   120
      ScaleHeight     =   7635
      ScaleWidth      =   10635
      TabIndex        =   0
      Top             =   480
      Width           =   10695
      Begin VB.PictureBox PicPrintPreview 
         AutoRedraw      =   -1  'True
         BorderStyle     =   0  'None
         Height          =   5415
         Left            =   1200
         ScaleHeight     =   5415
         ScaleWidth      =   6135
         TabIndex        =   2
         Top             =   720
         Width           =   6135
      End
   End
End
Attribute VB_Name = "FRMSPrinterForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
'' Printer Class
''
'' coded by Dale (see note)
''
'' NOTE: oridinal functions/sub done by other people, changed,OOD'ed,optimised and stuff by me
''
'' External references - CompName$,DB

''orientations - vbPRORPortrait,vbPRORLandscape

Const cPrinterHeight As Long = 11904    '' This is the page size used by preview
Const cPrinterWidth As Long = 16836

Private Type MyPrinter
    FontName As String
    PageOrientation As Long
    FontSize As Single
    ScaleMode As Long
    Orientation As Long
End Type

''''''''''''''''''''''''''''''''''''''''''
Private vCompanyName As String

Public vNumberText As Long

Private vOutputDevice As Object         '' Normally the printer
Private vPrintPreview As Boolean        '' If set then output is sent to screen, and printer specific operations are suppressed
Private vWaitForPage As Boolean         '' Pause varible (messaage used to trigger printer thread)
Private vCancelPrint As Boolean         '' Used to escape print thread, (may rewrite this correctly later)
'
Private vSQLString As String            '' Saves parameters, so we can print to printer
Private vHeadingString As String        '' if desired, later
Private vTotalMask As String            '' ^^^
Private vrsSearch As Recordset          '' Recordset exposed to other functions, so Next Page,Prev Page,Page Scale work correctly
Private vRecordsPerPage As Long         '' Used to force output to reprint a page (see above)
Private vRecordCount As Long            '' Number of records processed
Private vCurrentColoumn As Long         '' Current coloumn on current page
Private vTopLine As Long                '' Used where there are mutiple coloumns

Private vText(10) As String             '' Custom criteria for report

Public vNumberHeadings As Long          '' Set by user
Public vFontSize As Long                '' Set by DetailHeadings (proc)
Public vHeadingSpacing As Long          '' Number of spaces between detail headings

''''''''''''''''''''''''''''''''''''''''''
'Private page_width As Long              '' Quick read of page width

Private vHeadings() As String           '' Actual text for headings
Private vFieldSizes() As Long
Private vHeadingStart() As Long         '' Set by DetailHeadings (proc) - start position of each detail item
Private vFieldTotals() As Single        '' Totals for each field
Private vColoumnStart() As Long         '' Start position for each coloumn

Private vNumberColoumns As Long         '' Allows more than one coloumn of fields
Private vPageOrientation As Long        '' Landscape/portrait

Private vCurrentPage As Long

Private vOldPrinterSettings As MyPrinter '' saves printer settings before printing and restores them after
'''''''''''''

Public Function PreviewSQL(SQl As String, pHeading As String, Optional pTotalMask As String)
    Call Load(Me)
    vPrintPreview = True
    Call PrintSQL(SQl, pHeading, pTotalMask)
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Let CompanyName(ByVal NewValue As Long)
    vCompanyName = NewValue
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property procedures


Public Property Let PageOrientation(ByVal NewValue As Long)
    vPageOrientation = NewValue
End Property

Public Property Get Coloumns() As Long
    Coloumns = vNumberColoumns
End Property
Public Property Let Coloumns(ByVal NewValue As Long)
        vNumberColoumns = NewValue
End Property

Public Property Get Headings(index As Long) As String
    Headings = vHeadings(index)
End Property
Public Property Let Headings(index As Long, ByVal NewValue As String)
        vHeadings(index) = NewValue
End Property

Public Property Get FieldSizes(index As Long) As Long
    FieldSizes = vFieldSizes(index)
End Property
Public Property Let FieldSizes(index As Long, ByVal NewValue As Long)
        vFieldSizes(index) = NewValue
End Property

Public Property Get HeadingStart(index As Long) As Long
    HeadingStart = vHeadingStart(index)
End Property
Public Property Let HeadingStart(index As Long, ByVal NewValue As Long)
        vHeadingStart(index) = NewValue
End Property
' Custom headings -
Public Property Let Text(index As Long, ByVal NewValue As String)
    vText(index) = NewValue
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Function lCenterString(pString As String, FontSize As Long) As Long
    'A4 page = 210mm (width x 58) = 12180
    lCenterString = (vOutputDevice.Width - (Len(pString) * (FontSize * 13))) / 2
End Function

''
Private Function lAutoSizeCenterString(pString As String, ByRef FontSize As Long) As Single
    'A4 page = 210mm (width x 58) = 12180
    lAutoSizeCenterString = (vOutputDevice.Width - (Len(pString) * (FontSize * 13))) / 2
    Do While (lAutoSizeCenterString < 0)
        FontSize = FontSize - 1
        lAutoSizeCenterString = (vOutputDevice.Width - (Len(pString) * (FontSize * 13))) / 2
    Loop
End Function

''
Private Function lRightString(pString As String, pFontHeight As Long) As Long
    lRightString = (vOutputDevice.Width) - ((Len(pString) * (pFontHeight * 12)))
End Function

''
Private Sub lDrawLine(LineType As Long)
    vOutputDevice.DrawStyle = LineType
    vOutputDevice.Line (0, vOutputDevice.CurrentY)-(vOutputDevice.Width, vOutputDevice.CurrentY)
    vOutputDevice.DrawStyle = 0
End Sub

'' Allocate Dynamic data
Private Sub lInitPrintDetail()
    ReDim vHeadings(vNumberHeadings)
    ReDim vHeadingStart(vNumberHeadings)
    ReDim vFieldSizes(vNumberHeadings)
    ReDim vFieldTotals(vNumberHeadings)
    
    ReDim vColoumnStart(vNumberColoumns)
End Sub

''
Private Sub lPrintHeading(pCompanyName As String, pHeading As String)
    Dim DatePage As String
    Dim Left As Long, FontSize As Long
    DatePage = "Date:  " & Format(Date, "dd/mm/yyyy") & "  Page:  " & vCurrentPage & "      "
    vOutputDevice.PSet (1, 1)
    vOutputDevice.FontSize = 8
    vOutputDevice.Print pCompanyName;
    vOutputDevice.CurrentX = lRightString(DatePage, 8)
    vOutputDevice.Print DatePage
    vOutputDevice.Print " "
    FontSize = 14
    Left = lAutoSizeCenterString(pHeading, FontSize)
    vOutputDevice.FontSize = FontSize
    vOutputDevice.CurrentX = Left
    vOutputDevice.Print pHeading
    vOutputDevice.Print ""
    vOutputDevice.Print ""
    Call lDrawLine(0)
    vOutputDevice.Print ""
End Sub

''
Private Sub lDetailHeadings()
    Dim vStartPos() As Long             '' relitive postion of field (TEMP) used in DetailHeadings
    ReDim vStartPos(vNumberHeadings)
    Dim tempstring As String, TempString2 As String
    Dim i As Long
    Dim fontheight As Long
    
    fontheight = 10 ' for the moment
    
    tempstring = ""
    ' Build string containing all headings or fields depending on which is the longest
    For i = 0 To vNumberHeadings
        vStartPos(i) = Len(tempstring)
        If (vFieldSizes(i) > Len(vHeadings(i))) Then
            tempstring = tempstring & Space(vFieldSizes(i))
        Else
            tempstring = tempstring & vHeadings(i)
        End If
        If (vHeadingSpacing > 0) Then
            tempstring = tempstring & Space(vHeadingSpacing)
        End If
    Next
    
    ' Adjust total length according to number of coloumns
    i = 1
    TempString2 = tempstring
    Do While (i < vNumberColoumns)
        TempString2 = TempString2 & tempstring
        i = i + 1
    Loop
    
    
    ' Try to center string, if too big for line try smaller font - might make this better later
    vHeadingStart(0) = lCenterString(TempString2, 10)
    If vHeadingStart(0) < 0 Then
        Do While vHeadingStart(0) < 0
            fontheight = fontheight - 1
            vHeadingStart(0) = lCenterString(TempString2, fontheight)
        Loop
    End If
    
    ' Store fontsize, left justify if not full page width
    vFontSize = fontheight
    If (vHeadingStart(0) > 10) Then
        vHeadingStart(0) = 10
    End If
    
    ' calculate and store currentX for each heading
    For i = 1 To vNumberHeadings
        vHeadingStart(i) = (vHeadingStart(0) + (vStartPos(i) * (fontheight * 13)))
    Next
    
    ' Calculate coloumn starting positions
    vColoumnStart(0) = 0
    For i = 1 To vNumberColoumns
        vColoumnStart(i) = vColoumnStart(i - 1) + (Len(tempstring) * (fontheight * 13))
    Next
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Sub lSavePrinterSettings()
    vOldPrinterSettings.FontName = vOutputDevice.FontName
    vOldPrinterSettings.PageOrientation = vOutputDevice.Orientation
    vOldPrinterSettings.FontSize = vOutputDevice.FontSize
    vOldPrinterSettings.ScaleMode = vOutputDevice.ScaleMode
    vOldPrinterSettings.Orientation = vOutputDevice.Orientation
End Sub

''
Private Sub lRestorePrinterSettings()
    vOutputDevice.FontName = vOldPrinterSettings.FontName
    vOutputDevice.Orientation = vOldPrinterSettings.PageOrientation
    vOutputDevice.FontSize = vOldPrinterSettings.FontSize
    vOutputDevice.ScaleMode = vOldPrinterSettings.ScaleMode
    vOutputDevice.Orientation = vOldPrinterSettings.Orientation
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
'' Print report - automatic
''
'' Parameters - SQL statement
''
'' NOTES: Desired headings are generated from the fields selected in the SQL statement
'' should add first page settings,last page settings
'' Should chage optional parameter to "AUTO"
''
'' - Added totals
'' - Added totalmask to override default action on printing totals
'' - Added coloumns
'' - Added custom criteria
'' - Added page orientation
'' - Added printer settings saving

''
Private Function PrePrintSQL(SQl As String, pHeading As String, Optional pTotalMask As String) As Boolean
    Dim i As Long
    vCancelPrint = False
'    Call uPrintPreView.PrintSQL(sql, pHeading)'working on this one
    If (vPrintPreview = False) Then
        Call lSavePrinterSettings
    Else
'        Call PicPrintPreviewBox.Cls
    End If
    
    Screen.MousePointer = vbHourglass   ' SetCursorBusy
    If (OpenRecordset(vrsSearch, SQl, dbOpenSnapshot)) Then
        If (vrsSearch.EOF = False) Then
            ' Printer Setup
            vOutputDevice.FontName = "Arial"
            vOutputDevice.ScaleMode = 1
            If (vPrintPreview = False) Then
                vOutputDevice.Orientation = vPageOrientation
            End If
            
            ' Automatic heading sizing and aligment
            vNumberHeadings = vrsSearch.Fields.Count - 1
            vHeadingSpacing = 1
            
            ' Override for total calculation
            If (IsMissing(pTotalMask)) Then
                vTotalMask = ""
                For i = 0 To vNumberHeadings
                    vTotalMask = vTotalMask & "X"
                Next
            Else
                vTotalMask = pTotalMask
            End If
            
            ' Save settings for actual print button when previewing
            vSQLString = SQl
            vHeadingString = pHeading
            vTotalMask = vTotalMask
            
            Call lInitPrintDetail
            
            For i = 0 To vNumberHeadings
                vHeadings(i) = vrsSearch.Fields(i).Name
                vFieldTotals(i) = 0
                If (vrsSearch.Fields(i).Type = 4) Then
                    FieldSizes(i) = 10
                Else
                    FieldSizes(i) = vrsSearch.Fields(i).DefinedSize 'size in dao
                End If
            Next
            Call lDetailHeadings
            If (vFontSize < 7) Then
                'fontsize problem
            End If
            PrePrintSQL = True
        Else
            PrePrintSQL = False
        End If
    End If
End Function

''
Public Sub ExportCSV(pSQL As String, pFileName As String)
    Dim rsTemp As Recordset
    Dim fileid As Long
    Dim i As Long
    Dim tempstring As String
    If (OpenRecordset(rsTemp, pSQL, dbOpenSnapshot)) Then
        If (rsTemp.EOF = False) Then
            fileid = FreeFile
            Open pFileName For Output As #fileid
            ' Write headings
            tempstring = rsTemp.Fields(0).Name
            For i = 1 To rsTemp.Fields.Count - 1
                tempstring = tempstring & "," & rsTemp.Fields(i).Name
            Next
            Print #fileid, tempstring
            
            Do While (rsTemp.EOF = False)
                tempstring = rsTemp.Fields(0).Value
                For i = 1 To rsTemp.Fields.Count - 1
                    tempstring = tempstring & "," & rsTemp.Fields(i).Value
                Next
                Print #fileid, tempstring
                Call rsTemp.MoveNext
            Loop
            Call rsTemp.Close
        End If
    End If
End Sub

''
Public Sub PrintSQL(SQl As String, pHeading As String, Optional pTotalMask As String)
    Dim i As Long, X As Long, t As Long ' Local
    Dim TotalMask As String
    Dim TopLine As Long
    
    If (PrePrintSQL(SQl, pHeading, pTotalMask) = True) Then
        vRecordCount = 0
        vOutputDevice.FontSize = vFontSize
        vCurrentPage = 1
        vCurrentColoumn = 1
        Do While (vrsSearch.EOF = False And vCancelPrint = False)
        
            vRecordsPerPage = 0
            ' Page Headings
            Call lPrintHeading(vCompanyName, pHeading)
            
            ' Print report criteria
            If (vText(0) <> "") Then
                vOutputDevice.FontSize = 10
                For i = 0 To vNumberText
                    vOutputDevice.Print vText(i)
                Next
                Call lDrawLine(0)
            End If
            
            ' If more than one coloumn repeat coloumn headings
            vOutputDevice.FontSize = vFontSize
            For t = 1 To vNumberColoumns
                For i = 0 To vNumberHeadings
                    vOutputDevice.CurrentX = vColoumnStart(t - 1) + vHeadingStart(i)
                    vOutputDevice.Print vrsSearch.Fields(i).Name;
                Next
            Next
            
            vOutputDevice.Print "" ' Next line
            Call lDrawLine(0)
            vOutputDevice.Print ""
                
            ' Save position of top, used in multiple coloumn reports
            TopLine = vOutputDevice.CurrentY
            
            ' Page detail
            Do While (vrsSearch.EOF = False And vOutputDevice.CurrentY + (vFontSize * 13 * 7) < vOutputDevice.Height)
                If (vOutputDevice.CurrentY > X) Then
                    X = vOutputDevice.CurrentY
                End If
                For i = 0 To vNumberHeadings
                    vFieldTotals(i) = vFieldTotals(i) + Val(vrsSearch.Fields(i).Value & "")
                    vOutputDevice.CurrentX = vColoumnStart(vCurrentColoumn - 1) + vHeadingStart(i)
'                    If (vrsSearch.Fields(i).Type = 7) Then
'                        vOutputDevice.Print Format(vrsSearch.Fields(i).Value, "##########0.00");
'                    Else
'                        vOutputDevice.Print vrsSearch.Fields(i).Value;
'                    End If
                    vOutputDevice.Print FormatField(vrsSearch.Fields(i).Type, vrsSearch.Fields(i).Value & "");
                Next
                vOutputDevice.Print ""
                    
                vrsSearch.MoveNext
                vRecordsPerPage = vRecordsPerPage + 1
                vRecordCount = vRecordCount + 1
'                If (vrsSearch.EOF = True) Then
'                    Do While (vPrintPreview = True And vWaitForPage = True And vCancelPrint = False)
'                        DoEvents
'                    Loop
'                End If
            Loop
            If (vOutputDevice.CurrentY + (vFontSize * 13 * 7) >= vOutputDevice.Height) Then
                Screen.MousePointer = vbNormal
                CMDNextPage.Enabled = True
                If (vRecordCount >= vRecordsPerPage * 2) Then
                    CMDPrevPage.Enabled = True
                Else
                    CMDPrevPage.Enabled = False
                End If
                Do While (vPrintPreview = True And vWaitForPage = True And vCancelPrint = False)
                    DoEvents
                Loop
                Call PostPage
                
            End If
        Loop
        
        Call PostPrintSQL
'       vOutputDevice.KillDoc
    End If
    Screen.MousePointer = vbNormal  'SetCursorReady
    If (vPrintPreview = False And vCancelPrint = False) Then
        Call lRestorePrinterSettings
    End If
End Sub

''
Private Sub PostPage()
    If (vCancelPrint = False) Then
        Screen.MousePointer = vbHourglass
        vWaitForPage = True
        If (vCurrentColoumn >= vNumberColoumns) Then
            ' Page Endings
            If (vPrintPreview = False) Then
                vOutputDevice.NewPage
            Else
                Me.PicPrintPreview.Cls
            End If
            vCurrentPage = vCurrentPage + 1
            vCurrentColoumn = 1
        Else
            ' New coloumn
            vCurrentColoumn = vCurrentColoumn + 1
            vOutputDevice.CurrentY = vTopLine
        End If
    End If
End Sub

''
Private Sub PostPrintSQL()
    Dim i As Long
    If (vCancelPrint = False) Then
        ' Totals
        Call lDrawLine(0)
        vOutputDevice.FontBold = True
        For i = 0 To vNumberHeadings
            If (Mid$(vTotalMask, i + 1, 1) = "X") Then
                vOutputDevice.CurrentX = vHeadingStart(i)
                vOutputDevice.Print FormatField(vrsSearch.Fields(i).Type, CStr(vFieldTotals(i)));
            End If
        Next
        vOutputDevice.FontBold = False
        vOutputDevice.Print
        vOutputDevice.Print "Record count -" & vRecordCount
        If (vPrintPreview = False) Then
            vOutputDevice.EndDoc
        Else
            CMDNextPage.Enabled = False
        End If
        
        CMDPrevPage.Enabled = False
        vrsSearch.Close
    End If
End Sub

''''''''''''''''''''''''''''''''''''''
''
Private Sub Class_Initialize()
    vNumberColoumns = 1
    vNumberText = 0
    vPageOrientation = vbPRORPortrait
    Set vOutputDevice = Printer
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Sub RecalculateScale()
    Dim Max As Double
    Max = Me.PicPrintPreview.Width / Me.PicPrintPreviewBox.ScaleWidth
    If (Max < 1) Then
        ScrH.Max = 0
    Else
        ScrH.Max = 10
        ScrH.LargeChange = 10 / Max
    End If
'    ScrH.Max = Max
    Max = Me.PicPrintPreview.Height / Me.PicPrintPreviewBox.ScaleHeight
    If (Max < 1) Then
        ScrV.Max = 0
    Else
        ScrV.Max = 10
        ScrV.LargeChange = 10 / Max
    End If
    ScrH.Value = 0
    ScrV.Value = 0
    Me.PicPrintPreview.Left = 0
    Me.PicPrintPreview.Top = 0
End Sub

''
Private Sub CBOScale_Click()
    ' Shoule re-print window here
    Me.PicPrintPreview.Width = (Val(CBOScale.List(CBOScale.ListIndex)) / 100) * cPrinterWidth
    Me.PicPrintPreview.Height = (Val(CBOScale.List(CBOScale.ListIndex)) / 100) * cPrinterHeight
    Call RecalculateScale
    If (Not (vrsSearch Is Nothing)) Then
        If (vrsSearch.State = adStateOpen) Then
            Call Me.PicPrintPreview.Cls
            Call vrsSearch.Move(-vRecordsPerPage)
            vRecordCount = vRecordCount - vRecordsPerPage
            Call lDetailHeadings
            
            ' Heading recalculation hack
            If (vFontSize < 7) Then
                'fontsize problem
            End If
            vWaitForPage = False
        Else
            Call Me.PicPrintPreview.Cls
            
            ' Heading recalculation hack
'            Call lDetailHeadings
'            If (vFontSize < 7) Then
'                'fontsize problem
'            End If
            Call PreviewSQL(vSQLString, vHeadingString, vTotalMask)
        End If
    End If
End Sub

''
Private Sub CMDCancel_Click()
    vCancelPrint = True
    Call Unload(Me)
End Sub

''
Private Sub CMDExport_Click()
    Dim filename As String
    filename = OpenDialogue(".CSV")
    
    If (filename <> "") Then
        Call ExportCSV(vSQLString, filename)
        vCancelPrint = True
        Call Unload(Me)
    End If
End Sub

''
Private Sub CMDNextPage_Click()
    vWaitForPage = False
End Sub

''
Private Sub CMDPrevPage_Click()
    If (vRecordCount - vRecordsPerPage * 2 >= 0) Then
        vWaitForPage = False
        Call vrsSearch.Move(-vRecordsPerPage * 2)
        vRecordCount = vRecordCount - vRecordsPerPage * 2
    End If
End Sub

''
Private Sub CMDPrint_Click()
    vPrintPreview = False
    Set vOutputDevice = Printer
    If (vSQLString <> "") Then
        Call PrintSQL(vSQLString, vHeadingString, vTotalMask)
    End If
End Sub

''
Private Sub Form_Load()
    Call Me.PicPrintPreview.Cls
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
'    Call dbSystem.SetWindowPosition(Me)
    vPrintPreview = True
    vWaitForPage = True
    vCancelPrint = False
    vNumberColoumns = 1
    vNumberText = 0
    vPageOrientation = vbPRORPortrait
    Set vOutputDevice = Me.PicPrintPreview
    Me.PicPrintPreview.Width = cPrinterWidth
    Me.PicPrintPreview.Height = cPrinterHeight
    Me.PicPrintPreview.Left = 0
    Me.PicPrintPreview.Top = 0
    Me.CBOScale.Text = Me.CBOScale.List(1)
    CMDNextPage.Enabled = False
    CMDPrevPage.Enabled = False
End Sub

''
Private Sub Form_Resize()
    Me.PicPrintPreviewBox.Width = Me.ScaleWidth - Me.PicPrintPreviewBox.Left - (200 + Me.ScrV.Width)
    Me.PicPrintPreviewBox.Height = Me.ScaleHeight - Me.PicPrintPreviewBox.Top - (200 + Me.ScrH.Height)
    Me.ScrH.Top = Me.ScaleHeight - (Me.ScrH.Height + 100)
    Me.ScrV.Left = Me.ScaleWidth - (Me.ScrV.Width + 100)
    Me.ScrH.Width = Me.PicPrintPreviewBox.Width
    Me.ScrV.Height = Me.PicPrintPreviewBox.Height
    Call RecalculateScale
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Set vrsSearch = Nothing
    Call GetWindowPosition(Me)
'    Call dbSystem.GetWindowPosition(Me)
    vCancelPrint = True
'    Call CMDCancel_Click
End Sub

''
Private Sub ScrH_Change()
    Dim rangeX As Double
'    Dim rangeY As Double
    rangeX = Me.PicPrintPreview.ScaleWidth - Me.PicPrintPreviewBox.ScaleWidth
    Me.PicPrintPreview.Left = -rangeX / ScrH.Max * ScrH.Value
'    Me.PicPrintPreview.Top = 0
End Sub

''
Private Sub ScrV_Change()
    Dim rangeY As Double
    rangeY = Me.PicPrintPreview.ScaleHeight - Me.PicPrintPreviewBox.ScaleHeight
    Me.PicPrintPreview.Top = -rangeY / ScrV.Max * ScrV.Value
End Sub

''
Private Function FormatField(pType As Long, pValue As String) As String
    Select Case pType
        ' String types
        Case adVarWChar 'A null-terminated Unicode character string (Parameter object only).
            FormatField = pValue
        
        
        Case adArray    'Joined in a logical OR together with another type to indicate that the data is a safe-array of that type (DBTYPE_ARRAY).
            FormatField = pValue
        Case adBigInt   'An 8-byte signed integer (DBTYPE_I8).
            FormatField = pValue
        Case adBinary   'A binary value (DBTYPE_BYTES).
            FormatField = pValue
        Case adBoolean  'A Boolean value (DBTYPE_BOOL).
            FormatField = pValue
'        Case adByRef    'Joined in a logical OR together with another type to indicate that the data is a pointer to data of the other type (DBTYPE_BYREF).
'            FormatField = pValue
        Case adBSTR     'A null-terminated character string (Unicode) (DBTYPE_BSTR).
            FormatField = pValue
        Case adChar     'A String value (DBTYPE_STR).
            FormatField = pValue
        Case adCurrency 'A currency value (DBTYPE_CY). Currency is a fixed-point number with four digits to the right of the decimal point. It is stored in an 8-byte signed integer scaled by 10,000.
            FormatField = FormatCurrency(Val(pValue))
        Case adDate     'A Date value (DBTYPE_DATE). A date is stored as a Double, the whole part of which is the number of days since December 30, 1899, and the fractional part of which is the fraction of a day.
            FormatField = Format(pValue, "dd/mm/yyyy")
        Case adDBDate   'A date value (yyyymmdd) (DBTYPE_DBDATE).
            FormatField = pValue
        Case adDBTime   'A time value (hhmmss) (DBTYPE_DBTIME).
            FormatField = pValue
        Case adDBTimeStamp 'A date-time stamp (yyyymmddhhmmss plus a fraction in billionths) (DBTYPE_DBTIMESTAMP).
            FormatField = pValue
        Case adDecimal  'An exact numeric value with a fixed precision and scale (DBTYPE_DECIMAL).
            FormatField = pValue
        Case adDouble   'A double-precision floating point value (DBTYPE_R8).
            FormatField = pValue
        Case adEmpty    'No value was specified (DBTYPE_EMPTY).
            FormatField = pValue
        Case adError    'A 32-bit error code (DBTYPE_ERROR).
            FormatField = pValue
        Case adGUID         'A globally unique identifier (GUID) (DBTYPE_GUID).
            FormatField = pValue
        Case adIDispatch    'A pointer to an IDispatch interface on an OLE object (DBTYPE_IDISPATCH).
            FormatField = pValue
        Case adInteger  'A 4-byte signed integer (DBTYPE_I4).
            FormatField = pValue
        Case adIUnknown 'A pointer to an IUnknown interface on an OLE object (DBTYPE_IUNKNOWN).
            FormatField = pValue
        Case adLongVarBinary 'A long binary value (Parameter object only).
            FormatField = pValue
        Case adLongVarChar  'A long String value (Parameter object only).
            FormatField = pValue
        Case adLongVarWChar 'A long null-terminated string value (Parameter object only).
            FormatField = pValue
        Case adNumeric  'An exact numeric value with a fixed precision and scale (DBTYPE_NUMERIC).
            FormatField = pValue
        Case adSingle   'A single-precision floating point value (DBTYPE_R4).
            FormatField = pValue
        Case adSmallInt 'A 2-byte signed integer (DBTYPE_I2).
            FormatField = pValue
        Case adTinyInt  'A 1-byte signed integer (DBTYPE_I1).
            FormatField = pValue
        Case adUnsignedBigInt 'An 8-byte unsigned integer (DBTYPE_UI8).
            FormatField = pValue
        Case adUnsignedInt      'A 4-byte unsigned integer (DBTYPE_UI4).
            FormatField = pValue
        Case adUnsignedSmallInt     'A 2-byte unsigned integer (DBTYPE_UI2).
            FormatField = pValue
        Case adUnsignedTinyInt  'A 1-byte unsigned integer (DBTYPE_UI1).
            FormatField = pValue
        Case adUserDefined  'A user-defined variable (DBTYPE_UDT).
            FormatField = pValue
        Case adVarBinary 'A binary value (Parameter object only).
            FormatField = pValue
        Case adVarChar  'A String value (Parameter object only).
            FormatField = pValue
        Case adVariant  'An Automation Variant (DBTYPE_VARIANT).
            FormatField = pValue
'        Case adVector   'Joined in a logical OR together with another type to indicate that the data is a DBVECTOR structure, as defined by OLE DB, that contains a count of elements and a pointer to data of the other type (DBTYPE_VECTOR).
'            FormatField = pValue
        
        
        Case adWChar    'A null-terminated Unicode character string (DBTYPE_WSTR).
            FormatField = pValue
        Case Else
            FormatField = pValue
    End Select
End Function
