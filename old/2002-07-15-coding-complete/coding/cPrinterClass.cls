VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPrinterClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''
'' Printer Class
''
'' coded by Dale Pitman
''
'' NOTE:
''
'' External references -

Public Enum OrientationENUM
    vbPRORPortrait = 1 'vbPRORPortrait
End Enum

Public Enum ScaleModeENUM
    vbMillimeters = 6 ' vbMillimeters
End Enum

Private Type LineType
    x1 As Double
    y1 As Double
    x2 As Double
    y2 As Double
    Page As Long
    DrawStyle As Long
End Type

Private Type TextType
    x1 As Double
    y1 As Double
    Text As String
    FontName As String
    fontsize As Double
    FontItalic As Boolean
    FontBold As Boolean
    Page As Long
End Type

Private vLine(10000) As LineType
Private vText(10000) As TextType

Private vCurrentLine As Long
Private vCurrentText As Long

Private vFontName As String
Private vFontSize As Double
Private vFontItalic As Boolean
Private vFontBold As Boolean
Private vOrientation As OrientationENUM
Private vScaleMode As ScaleModeENUM

Private vDrawStyle As Long

Private vCurrentPage As Long

Private vCurrentX As Double
Private vCurrentY As Double

Private vObject As Object

Private vMaxPage As Long

Private vPrintPageNumber As Boolean

'' Pass through properties
Public Property Get Height() As Double
    Height = vObject.Height
End Property
Public Property Let Height(ByVal NewValue As Double)
    vObject.Height = NewValue
End Property

Public Property Get Width() As Double
    Width = vObject.Width
End Property
Public Property Let Width(ByVal NewValue As Double)
    vObject.Width = NewValue
End Property

'Public Property Get ScaleMode() As Double
'    ScaleMode = vObject.ScaleMode
'End Property
'Public Property Let ScaleMode(ByVal NewValue As Double)
'    vObject.ScaleMode = NewValue
'End Property

'' General Properties
Public Property Get CurrentX() As Double
    CurrentX = vCurrentX
End Property
Public Property Let CurrentX(ByVal NewValue As Double)
    vCurrentX = NewValue
End Property

Public Property Get CurrentY() As Double
    CurrentY = vCurrentY
End Property
Public Property Let CurrentY(ByVal NewValue As Double)
    vCurrentY = NewValue
End Property

'' Line Properties
Public Property Get DrawStyle() As Long
    DrawStyle = vDrawStyle
End Property
Public Property Let DrawStyle(ByVal NewValue As Long)
    vDrawStyle = NewValue
End Property

'' Text Properties
Public Property Get FontName() As String
    FontName = vFontName
End Property
Public Property Let FontName(ByVal NewValue As String)
    vFontName = NewValue
End Property

Public Property Get fontsize() As Double
    fontsize = vFontSize
End Property
Public Property Let fontsize(ByVal NewValue As Double)
    vFontSize = NewValue
End Property

Public Property Get FontItalic() As Boolean
    FontItalic = vFontItalic
End Property
Public Property Let FontItalic(ByVal NewValue As Boolean)
    vFontItalic = NewValue
End Property

Public Property Get FontBold() As Boolean
    FontBold = vFontBold
End Property
Public Property Let FontBold(ByVal NewValue As Boolean)
    vFontBold = NewValue
End Property

Public Property Get Orientation() As OrientationENUM
    Orientation = vOrientation
'    Orientation= vObject
End Property
Public Property Let Orientation(ByVal NewValue As OrientationENUM)
    vOrientation = NewValue
'    vObject.Orientation = NewValue
End Property

Public Property Get ScaleMode() As ScaleModeENUM
    ScaleMode = vScaleMode
    ScaleMode = vObject.ScaleMode
End Property
Public Property Let ScaleMode(ByVal NewValue As ScaleModeENUM)
    vScaleMode = NewValue
    vObject.ScaleMode = NewValue
End Property



Public Property Get Pages() As Long
    Pages = vMaxPage
End Property

Public Property Let PrintPageNumber(ByVal NewValue As Boolean)
    vPrintPageNumber = NewValue
End Property




'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

''
Public Function AutoSizeCenterString(pString As String, ByRef fontsize As Long) As Single
    'A4 page = 210mm (width x 58) = 12180
    vObject.fontsize = fontsize
    AutoSizeCenterString = (vObject.ScaleWidth - vObject.TextWidth(pString)) / 2
    Do While (AutoSizeCenterString < 0)
        fontsize = fontsize - 1
        vObject.fontsize = fontsize
        AutoSizeCenterString = (vObject.ScaleWidth - vObject.TextWidth(pString)) / 2
    Loop
End Function

''
Public Function CenterString2(pString As String, fontsize As Double) As Double
    'A4 page = 210mm (width x 58) = 12180
    vObject.fontsize = fontsize
    CenterString2 = (vObject.ScaleWidth - vObject.TextWidth(pString)) / 2
End Function

''
Public Function RightString(pString As String, pFontHeight As Long) As Long
    RightString = vObject.ScaleWidth - vObject.TextWidth(pString)
End Function

''
Public Sub DrawLine(LineType As Long)
    vDrawStyle = LineType
    Call PrintLine(0, vCurrentY, vObject.ScaleWidth, vCurrentY)
End Sub


''
Public Sub PrintHeading(pCompanyName As String, pHeading As String)
    Dim DatePage As String
    Dim Left As Long
    Dim fontsize As Long
    DatePage = "Date:  " & Format(Date, "dd/mm/yyyy") & "  Page:  " & vCurrentPage & "      "
    vFontSize = 8
    Call PrintText(pCompanyName, False)
    vCurrentX = RightString(DatePage, 8)
    Call PrintText(DatePage, True)
    Call PrintText(" ", True)
    fontsize = 14
    Left = AutoSizeCenterString(pHeading, fontsize)
    vFontSize = fontsize
    vCurrentX = Left
    Call PrintText(pHeading, True)
    vFontSize = 10
    Call PrintText("", True)
    Call PrintText("", True)
    Call DrawLine(0)
    Call PrintText("", True)
End Sub



'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub NewPage()
    vCurrentPage = vCurrentPage + 1
    If (vCurrentPage > vMaxPage) Then
        vMaxPage = vCurrentPage
    End If
    
    CurrentX = 0
    CurrentY = 0
End Sub

Public Sub ClearDetails()
    vCurrentPage = 1
    
    vFontName = ""
    vFontSize = 8
    vFontItalic = False
    vFontBold = False
    
    CurrentX = 0
    CurrentY = 0

    vCurrentLine = 0
    vCurrentText = 0
    
    vMaxPage = 0
    
    vPrintPageNumber = False
End Sub

Public Sub SetObject(pObject As Object)
    Set vObject = pObject
End Sub

Public Sub EndDoc()
    Dim i As Long
    '
    If (vPrintPageNumber = True) Then
        For i = 0 To vCurrentPage
            If (vCurrentText < 10000) Then
                vText(vCurrentText).Text = "Page " & i & " of " & vCurrentPage
                vText(vCurrentText).FontName = vFontName
                vText(vCurrentText).fontsize = 8
                vText(vCurrentText).FontItalic = False
                vText(vCurrentText).FontBold = False
                vObject.fontsize = 8
                vText(vCurrentText).x1 = (vObject.ScaleWidth - vObject.TextWidth(vText(vCurrentText).Text)) / 2
                vText(vCurrentText).y1 = vObject.ScaleHeight - vObject.TextHeight("Page") * 2
                vText(vCurrentText).Page = i
                vCurrentText = vCurrentText + 1
            End If
        Next
    End If
End Sub

Public Sub PrintLine(px1 As Double, py1 As Double, px2 As Double, py2 As Double)
    If (vCurrentLine < 10000) Then
        vLine(vCurrentLine).x1 = px1
        vLine(vCurrentLine).y1 = py1
        vLine(vCurrentLine).x2 = px2
        vLine(vCurrentLine).y2 = py2
        vLine(vCurrentLine).DrawStyle = vDrawStyle
        vLine(vCurrentLine).Page = vCurrentPage
        vCurrentLine = vCurrentLine + 1
    End If
End Sub

Public Sub PrintText(pString As String, pNewLine As Boolean)
    If (vCurrentText < 10000) Then
        vText(vCurrentText).Text = pString
        vText(vCurrentText).FontName = vFontName
        vText(vCurrentText).fontsize = vFontSize
        vText(vCurrentText).FontItalic = vFontItalic
        vText(vCurrentText).FontBold = vFontBold
        vText(vCurrentText).x1 = vCurrentX
        vText(vCurrentText).y1 = vCurrentY
        vText(vCurrentText).Page = vCurrentPage
        
        vObject.fontsize = vFontSize
        If (pNewLine = True) Then
            vCurrentX = 0
            vCurrentY = vCurrentY + (vObject.TextHeight(pString) * 1.1)
        Else
            vCurrentX = vCurrentX + vObject.TextWidth(pString)
            vCurrentY = vCurrentY
        End If
        
        vCurrentText = vCurrentText + 1
    End If
End Sub

''
Public Sub PrintX(pXPos As Long, pString As String, Optional NewLine As Boolean = False)
    vCurrentX = pXPos
    Call PrintText(pString, NewLine)
End Sub

Public Sub PrintPage(pPageNumber As Long)
    Dim i As Long
    For i = 0 To vCurrentLine - 1
        If (vLine(i).Page = pPageNumber) Then
            vObject.DrawStyle = vLine(i).DrawStyle
            vObject.Line (vLine(i).x1, vLine(i).y1)-(vLine(i).x2, vLine(i).y2)
        End If
    Next
    
    For i = 0 To vCurrentText - 1
        If (vText(i).Page = pPageNumber) Then
            vObject.FontName = vText(i).FontName
            vObject.fontsize = vText(i).fontsize
            vObject.FontItalic = vText(i).FontItalic
            vObject.FontBold = vText(i).FontBold
            vObject.CurrentX = vText(i).x1
            vObject.CurrentY = vText(i).y1
            vObject.Print vText(i).Text;
        End If
    Next
End Sub

Private Sub Class_Initialize()
    vPrintPageNumber = False
End Sub
