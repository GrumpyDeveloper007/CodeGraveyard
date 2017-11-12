VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLPrinterClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Printer Class
''
'' coded by Dale
''
'' External references -

''orientations - vbPRORPortrait,vbPRORLandscape

Const cPrinterHeight As Long = 16836 '' This is the page size used by preview
Const cPrinterWidth As Long = 11904

Private Type MyPrinter
    FontName As String
    PageOrientation As Long
    fontsize As Single
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

Private vText(20) As String             '' Custom criteria for report

Public vNumberHeadings As Long          '' Set by user
Public vFontSize As Long                '' Set by DetailHeadings (proc)
Public vHeadingSpacing As Long          '' Number of spaces between detail headings
''''''''''''''''''''''''''''''''''''''''''
''
Private vFootNoteSQL As String          '' Used for graph footnotes


''''''''''''''''''''''''''''''''''''''''''

Private vHeadings() As String           '' Actual text for headings
Private vFieldSizes() As Long
Private vHeadingStart() As Long         '' Set by DetailHeadings (proc) - start position of each detail item
Private vFieldTotals() As Single        '' Totals for each field
Private vColoumnStart() As Long         '' Start position for each coloumn

Private vNumberColoumns As Long         '' Allows more than one coloumn of fields
Private vPageOrientation As Long        '' Landscape/portrait

Private vOldPrinterSettings As MyPrinter '' saves printer settings before printing and restores them after

Private vFormatMask As String

Private vWaitForMain As Boolean
'''''''''''''
Private vPreviewObject As New cPrinterClass
Private vCurrentPage As Long
Public vPrintRecordCount As Boolean



Public Function PreviewSQL(sql As String, pHeading As String, Optional pTotalMask As String, Optional pFormatMask As String = "")
    Dim tempobject As Object
    Call Load(Me)
    vPrintPreview = True
    Set tempobject = vOutputDevice
    Call vPreviewObject.ClearDetails
    Call vPreviewObject.SetObject(vOutputDevice)
    Set vOutputDevice = vPreviewObject
    Call i_PrintSQL(sql, pHeading, pTotalMask, pFormatMask)
    Call vPreviewObject.PrintPage(1)
    LBLPages.Caption = "Pages -" & vPreviewObject.Pages
    vCurrentPage = 1
    If (vPreviewObject.Pages > 1) Then
        CMDPrevPage.Enabled = False
        CMDNextPage.Enabled = True
    End If
    Set vOutputDevice = tempobject
End Function

Public Function PrintSQL(sql As String, pHeading As String, Optional pTotalMask As String, Optional pFormatMask As String = "")
    vPrintPreview = False
    Set vOutputDevice = Printer
    Call i_PrintSQL(sql, pHeading, pTotalMask, pFormatMask)
End Function

'''''''''''

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Let CompanyName(ByVal NewValue As Long)
    vCompanyName = NewValue
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property procedures

'' For graph
Public Property Get FootNoteSQL() As String
    FootNoteSQL = vFootNoteSQL
End Property
Public Property Let FootNoteSQL(ByVal NewValue As String)
        vFootNoteSQL = NewValue
End Property


''
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
    If (index > vNumberText) Then
        vNumberText = index
    End If
    vText(index) = NewValue
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Function lAutoSizeCenterString(pString As String, ByRef fontsize As Long) As Single
    'A4 page = 210mm (width x 58) = 12180
    lAutoSizeCenterString = (vOutputDevice.Width - (Len(pString) * (fontsize * 13))) / 2
    Do While (lAutoSizeCenterString < 0)
        fontsize = fontsize - 1
        lAutoSizeCenterString = (vOutputDevice.Width - (Len(pString) * (fontsize * 13))) / 2
    Loop
End Function


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
    Dim Left As Long, fontsize As Long
    DatePage = "Date:  " & Format(Date, "dd/mm/yyyy") & "  Page:  " & vCurrentPage & "      "
    vOutputDevice.fontsize = 8
    Call PrintText(pCompanyName, False)
    vOutputDevice.CurrentX = lRightString(DatePage, 8)
    Call PrintText(DatePage, True)
    Call PrintText(" ", True)
    fontsize = 14
    Left = lAutoSizeCenterString(pHeading, fontsize)
    vOutputDevice.fontsize = fontsize
    vOutputDevice.CurrentX = Left
    Call PrintText(pHeading, True)
    vOutputDevice.fontsize = 10
    Call PrintText("", True)
    Call PrintText("", True)
    Call lDrawLine(0)
    Call PrintText("", True)
End Sub

''
Private Sub lDetailHeadings()
    Dim vStartPos() As Long             '' relitive postion of field (TEMP) used in DetailHeadings
    ReDim vStartPos(vNumberHeadings)
    Dim Tempstring As String, TempString2 As String
    Dim i As Long
    Dim fontheight As Long
    
    fontheight = 10 ' for the moment
    
    Tempstring = ""
    ' Build string containing all headings or fields depending on which is the longest
    For i = 0 To vNumberHeadings
        vStartPos(i) = Len(Tempstring)
        If (vFieldSizes(i) > Len(vHeadings(i))) Then
            Tempstring = Tempstring & Space(vFieldSizes(i))
        Else
            Tempstring = Tempstring & vHeadings(i)
        End If
        If (vHeadingSpacing > 0) Then
            Tempstring = Tempstring & Space(vHeadingSpacing)
        End If
    Next
    
    ' Adjust total length according to number of coloumns
    i = 1
    TempString2 = Tempstring
    Do While (i < vNumberColoumns)
        TempString2 = TempString2 & Tempstring
        i = i + 1
    Loop
    
    
    ' Try to center string, if too big for line try smaller font - might make this better later
    
    vHeadingStart(0) = lCenterString(TempString2, 10)
    If vHeadingStart(0) < 0 Then
        Do While vHeadingStart(0) < 0
            fontheight = fontheight - 1
            vHeadingStart(0) = lCenterString(TempString2, CDbl(fontheight))
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
        vColoumnStart(i) = vColoumnStart(i - 1) + (Len(Tempstring) * (fontheight * 13))
    Next
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Private Sub lSavePrinterSettings()
    vOldPrinterSettings.FontName = vOutputDevice.FontName
    vOldPrinterSettings.PageOrientation = vOutputDevice.Orientation
    vOldPrinterSettings.fontsize = vOutputDevice.fontsize
    vOldPrinterSettings.ScaleMode = vOutputDevice.ScaleMode
    vOldPrinterSettings.Orientation = vOutputDevice.Orientation
End Sub

''
Private Sub lRestorePrinterSettings()
    vOutputDevice.FontName = vOldPrinterSettings.FontName
    vOutputDevice.Orientation = vOldPrinterSettings.PageOrientation
    vOutputDevice.fontsize = vOldPrinterSettings.fontsize
    vOutputDevice.ScaleMode = vOldPrinterSettings.ScaleMode
    vOutputDevice.Orientation = vOldPrinterSettings.Orientation
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Print report
''
'' - Added totals
'' - Added totalmask to override default action on printing totals
'' - Added coloumns
'' - Added custom criteria
'' - Added page orientation
'' - Added printer settings saving
'' - Added Support for 'H' Hole Integer

''
Private Function PrePrintSQL(sql As String, pHeading As String, Optional pTotalMask As String) As Boolean
    Dim i As Long
    vCancelPrint = False
'    Call uPrintPreView PrintSQL(sql, pHeading)'working on this one
    If (vPrintPreview = False) Then
        Call lSavePrinterSettings
    Else
'        Call PicPrintPreviewBox.Cls
    End If
    
    Screen.MousePointer = vbHourglass   ' SetCursorBusy
    If (OpenRecordset(vrsSearch, sql, dbOpenSnapshot)) Then
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
            vSQLString = sql
            vHeadingString = pHeading
            vTotalMask = vTotalMask
            
            Call lInitPrintDetail
            
            For i = 0 To vNumberHeadings
                vHeadings(i) = vrsSearch.Fields(i).Name
                vFieldTotals(i) = 0
                If (vrsSearch.Fields(i).Type = 4) Then
                    vFieldSizes(i) = 10
                Else
                    If (vrsSearch.Fields(i).Type = 203) Then 'memo
                        vFieldSizes(i) = 100 'size in dao
                    Else
                        vFieldSizes(i) = vrsSearch.Fields(i).DefinedSize 'size in dao
                    End If
                End If
            Next
            Call lDetailHeadings
            If (vFontSize < 7) Then
                'fontsize problem
                If (vFontSize < 1) Then
                    vFontSize = 1
                End If
            End If
            PrePrintSQL = True
        Else
            PrePrintSQL = False
        End If
    End If
End Function

''
Public Sub ExportCSV(pSql As String, pFileName As String)
    Dim rstemp As Recordset
    Dim fileid As Long
    Dim i As Long
    Dim Tempstring As String
    
    On Error GoTo failed
    If (OpenRecordset(rstemp, pSql, dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            fileid = FreeFile
            Open pFileName For Output As #fileid
            ' Write headings
            Tempstring = rstemp.Fields(0).Name
            For i = 1 To rstemp.Fields.Count - 1
                Tempstring = Tempstring & "," & rstemp.Fields(i).Name
            Next
            Print #fileid, Tempstring
            
            Do While (rstemp.EOF = False)
                Tempstring = rstemp.Fields(0).Value & ""
                For i = 1 To rstemp.Fields.Count - 1
                    Tempstring = Tempstring & "," & rstemp.Fields(i).Value
                Next
                Print #fileid, Tempstring
                Call rstemp.MoveNext
            Loop
            Call rstemp.Close
            Close #fileid
        End If
    End If
Exit Sub
failed:
    Call Messagebox("Failed to export", vbInformation)
End Sub

''
Private Sub i_PrintSQL(sql As String, pHeading As String, Optional pTotalMask As String, Optional pFormatMask As String = "")
    Dim i As Long, X As Long, t As Long ' Local
    Dim TotalMask As String
    Dim TopLine As Long
    
    vWaitForMain = True
    
    vFormatMask = pFormatMask
    
    If (PrePrintSQL(sql, pHeading, pTotalMask) = True) Then
        vRecordCount = 0
        vOutputDevice.fontsize = vFontSize
        vCurrentPage = 1
        vCurrentColoumn = 1
        Do While (vrsSearch.EOF = False And vCancelPrint = False)
        
            vRecordsPerPage = 0
            ' Page Headings
            Call lPrintHeading(vCompanyName, pHeading)
            
            ' Print report criteria
            If (vText(0) <> "") Then
                vOutputDevice.fontsize = 10
                For i = 0 To vNumberText
                    Call PrintText(vText(i), True)
                Next
                Call lDrawLine(0)
            End If
            
            ' If more than one coloumn repeat coloumn headings
            vOutputDevice.fontsize = vFontSize
            For t = 1 To vNumberColoumns
                For i = 0 To vNumberHeadings
                    vOutputDevice.CurrentX = vColoumnStart(t - 1) + vHeadingStart(i)
                    Call PrintText(vrsSearch.Fields(i).Name, False)
                Next
            Next
            
            Call PrintText("", True)  ' Next line
            Call lDrawLine(0)
            Call PrintText("", True)
                
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
                    If (Trim$(Mid$(pFormatMask, i + 1, 1)) = "H") Then
                        Call PrintText(Int(vrsSearch.Fields(i).Value & ""), False)
                    Else
                        If (Trim$(Mid$(pFormatMask, i + 1, 1)) = "T") Then
                            Call PrintText(SecondsToTime(vrsSearch.Fields(i).Value & ""), False)
                        Else
                            If (Trim$(Mid$(pFormatMask, i + 1, 1)) = "L") Then
                                Call PrintText(Format(vrsSearch.Fields(i).Value & "", "dd/mm/yyyy hh:mm"), False)
                            Else
                                Call PrintText(FormatField(vrsSearch.Fields(i).Type, vrsSearch.Fields(i).Value & ""), False)
                            End If
                        End If
                    End If
                Next
                Call PrintText("", True)
                    
                vrsSearch.MoveNext
                vRecordsPerPage = vRecordsPerPage + 1
                vRecordCount = vRecordCount + 1
            Loop
            If (vOutputDevice.CurrentY + (vFontSize * 13 * 7) >= vOutputDevice.Height) Then
                Call PostPage
            End If
        Loop
        
        Call PostPrintSQL
    End If
    Screen.MousePointer = vbNormal  'SetCursorReady
    If (vPrintPreview = False And vCancelPrint = False) Then
        Call lRestorePrinterSettings
    End If
    vWaitForMain = False
End Sub

''
Private Sub PostPage()
    If (vCancelPrint = False) Then
        Screen.MousePointer = vbHourglass
        vWaitForPage = True
        If (vCurrentColoumn >= vNumberColoumns) Then
            ' Page Endings
            vOutputDevice.NewPage
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
                If (Trim$(Mid$(vFormatMask, i + 1, 1)) = "T") Then
                    Call PrintText(SecondsToTime(CLng(vFieldTotals(i))), False)
                Else
                    If (Trim$(Mid$(vFormatMask, i + 1, 1)) = "L") Then
                        Call PrintText(Format(vFieldTotals(i), "dd/mm/yyyy hh:mm"), False)
                    Else
                        Call PrintText(FormatField(vrsSearch.Fields(i).Type, CStr(vFieldTotals(i))), False)
                    End If
                End If
            End If
        Next
        vOutputDevice.FontBold = False
        Call PrintText("", True)
        
        If (vPrintRecordCount = True) Then
            Call PrintText("Record count -" & vRecordCount, True)
        End If
        vOutputDevice.EndDoc
        
        vrsSearch.Close
    End If
End Sub

''''''''''''''''''''''''''''''''''''''
''
Public Sub Initialize()
    vNumberColoumns = 1
    vNumberText = 0
    vText(0) = ""
    vPrintRecordCount = True
    
    vPageOrientation = vbPRORPortrait
    Set vOutputDevice = Printer
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''


''
Private Function FormatField(pType As Long, pValue As String) As String
    Select Case pType
        ' String types
        Case adVarWChar 'A null-terminated Unicode character string (Parameter object only).
            FormatField = Replace(pValue, "²", "")
        
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
            FormatField = Val(pValue)
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
            FormatField = Val(pValue)
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

Private Sub Class_Initialize()
    vPrintPreview = True
    vWaitForPage = True
    vCancelPrint = False
    vNumberColoumns = 1
    vPageOrientation = vbPRORPortrait
    Set vOutputDevice = Me.PicPrintPreview
End Sub
