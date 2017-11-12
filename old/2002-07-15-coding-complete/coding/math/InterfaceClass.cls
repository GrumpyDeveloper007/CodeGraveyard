VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "InterfaceClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

'' Uses - MathClass (Included)

Private Type InputType
    Question As String
    VaribleName As String
End Type

Private math As New MathClass

Private Const ArrowLength As Double = 10        '' Used when putting arrow on lines
Private Const ArrowAngle As Double = 10

Private Const cFontOffsetScale As Double = 2    '' Used in Labels, relative position
Private Const cFontOffsetScaleX As Double = 1

Private CaptureIO As Boolean                    '' Not used yet
Private ScaleX As Double                        '' Used to scale from interal coors
Private ScaleY As Double                        '' external coords(picturebox)
Private Inputs(300) As String
Private InputIndex As Long
Private MaxInput As Long
Private TopY As Double                      ''
Private vUserInputEnabled As Boolean

Private vHeight As Double                   ''

''
Private Sub Class_Initialize()
    CaptureIO = False
    InputIndex = 0
    TopY = FrmGFXView.PicConsole.Height - 20
    vHeight = FrmGFXView.PicConsole.Height - 40
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Public

'' Load .ans file (for testing)
Public Sub LoadInputs(pFileName As String)
    Dim FileID As Long
    Dim I As Long
    Dim tempstring As String
    FileID = FreeFile
    If (pFileName <> "" And Dir(ProgPath & pFileName) <> "") Then
        Open ProgPath & pFileName For Input As #FileID
        I = 0
        Do While (EOF(FileID) = False)
            Line Input #FileID, tempstring
            Inputs(I) = tempstring
            I = I + 1
        Loop
        MaxInput = I
    Else
        ' Unable to load default inputs
        MaxInput = 0
    End If
End Sub

'' Using MaxX,MaxY to generate multipliers to fit picture to picture box screen
Public Sub SetScale(pMaxX As Double, pMaxY As Double)
    ScaleX = (FrmGFXView.PicConsole.Width - 10) / pMaxX
    ScaleY = (vHeight - 10) / pMaxY
End Sub

'' Print text to console
Public Function iPrint(param As String, device As Long) As Boolean
    If (device = 701) Then 'Printer
        FrmTextView.TxtPrinterWindow.SelText = param & vbCrLf
    Else
        Frmtest.TxtConsole.SelText = param & vbCrLf
    End If
End Function

'' Ask User question (in console)
Public Function iInput(param As String, VaribleName As String) As String
    Frmtest.TxtConsole.SelText = param
    Frmtest.LastVariblename = VaribleName
    '    iInput = InputBox(param)
'        iInput = 0.01
        If (InputIndex < MaxInput) Then
            iInput = Inputs(InputIndex)
            Frmtest.TxtConsole.SelText = iInput & vbCrLf
            InputIndex = InputIndex + 1
        End If
'        Call iPrint(param & iInput)
    If (vUserInputEnabled = True) Then
        Syntax.Finished = True
    End If
End Function

''
Public Function iSetLineStyle(sytle As Long) As Boolean
    
End Function

'' Dump Text to printer
Public Function iPrintTextToPrinter() As Boolean
    ' If printer setup ok then print
    If (SetPrinter(FrmOptions.printerName)) Then
        ' Allways print picture using portrait orientation
        Printer.Orientation = vbPRORPortrait
        Printer.Font = FrmTextView.TxtPrinterWindow.Font
        Printer.FontSize = FrmTextView.TxtPrinterWindow.FontSize
        Printer.Print FrmTextView.TxtPrinterWindow.Text
'        Call Printer.PaintPicture(FrmGFXView.PicConsole.Image, 0, 0)
        Printer.EndDoc
    End If
End Function

'' Dump graphics to printer
Public Function iPrintGFXToPrinter() As Boolean
    ' If printer setup ok then print
    If (SetPrinter(FrmOptions.printerName)) Then
        ' Allways print picture using landscape orientation
        Printer.Font = FrmGFXView.PicConsole.Font
        Printer.FontSize = FrmGFXView.PicConsole.FontSize
        Printer.Orientation = vbPRORLandscape
        Call Printer.PaintPicture(FrmGFXView.PicConsole.Image, 0, 0)
        Printer.EndDoc
    End If
End Function

'' Clear screen
Public Function iClearGFX() As Boolean
'    Call FrmGFXView.PicConsole.Cls
End Function

'' Draw line
Public Function iDraw(x1 As Double, y1 As Double, x2 As Double, y2 As Double, pShowAngle As Boolean) As Boolean
    Dim dx As Double, dy As Double
    Dim cx As Double, cy As Double
    Dim angle As Double
    
    ' If arrow head should be on line
    If (pShowAngle = True) Then
        ' Calculate arrow heads and draw
        
        dx = x2 - x1
        dy = -(y2 - y1)
        angle = math.GetAngle(dx, dy)
        Call math.GetDxDy(cx, cy, angle - ArrowAngle, ArrowLength)
        FrmGFXView.PicConsole.Line (x1 * ScaleX, TopY - y1 * ScaleY)-((x1) * ScaleX + cx, TopY - (y1) * ScaleY + cy)
        Call math.GetDxDy(cx, cy, angle + ArrowAngle, ArrowLength)
        FrmGFXView.PicConsole.Line (x1 * ScaleX, TopY - y1 * ScaleY)-((x1) * ScaleX + cx, TopY - (y1) * ScaleY + cy)

'        angle = math.GetAngle(dx, dy)
         angle = angle + 180    ' Inverse angle
         If (angle > 360) Then
            angle = angle - 360
         End If
        Call math.GetDxDy(cx, cy, angle - ArrowAngle, ArrowLength)
        FrmGFXView.PicConsole.Line (x2 * ScaleX, TopY - y2 * ScaleY)-((x2) * ScaleX + cx, TopY - (y2) * ScaleY + cy)
        Call math.GetDxDy(cx, cy, angle + ArrowAngle, ArrowLength)
        FrmGFXView.PicConsole.Line (x2 * ScaleX, TopY - y2 * ScaleY)-((x2) * ScaleX + cx, TopY - (y2) * ScaleY + cy)
    End If
    
    ' Draw line
    FrmGFXView.PicConsole.Line (x1 * ScaleX, TopY - y1 * ScaleY)-(x2 * ScaleX, TopY - y2 * ScaleY)
End Function

'' Plot Label (like print statement, except to graphics console at x,y)
Public Function iLabel(x1 As Double, y1 As Double, lOrg As Long, lDir As Long, param As String) As Boolean
    Dim OffsetX As Long
    Dim OffsetY As Long
        
    Dim x As Long, y As Long
    Dim CurrentX As Long, CurrentY As Long
    Dim FontSize As Long
    If (lDir = 0) Then
        
        Select Case lOrg
            Case 1
                OffsetX = 0
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale
            Case 2
                OffsetX = 0
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale / 2
            Case 3
                OffsetX = 0
                OffsetY = 0
            Case 4
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param) / 2
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale
            Case 5
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param) / 2
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale / 2
            Case 6
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param) / 2
                OffsetY = 0
            Case 7
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param)
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale
            Case 8
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param)
                OffsetY = -FrmGFXView.PicConsole.FontSize * cFontOffsetScale / 2
            Case 9
                OffsetX = -FrmGFXView.PicConsole.FontSize * Len(param)
                OffsetY = 0
             Case Else
        End Select
        FrmGFXView.PicConsole.CurrentX = x1 * ScaleX + OffsetX
        FrmGFXView.PicConsole.CurrentY = TopY - y1 * ScaleY + OffsetY
        FrmGFXView.PicConsole.Print param
    Else
        ' ldir=90, so rotate plot text to scrach pad them rotate 90 degress and copy to
        ' gfx view
        Select Case lOrg
            Case 1
                OffsetX = -FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = 0
            Case 2
                OffsetX = -FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX / 2
                OffsetY = 0
            Case 3
                OffsetX = FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = 0
            Case 4
                OffsetX = -FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param) / 2
            Case 5
                OffsetX = -FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX / 2
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param) / 2
            Case 6
                OffsetX = FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param) / 2
            Case 7
                OffsetX = -FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param)
            Case 8
                OffsetX = FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX / 2
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param)
            Case 9
                OffsetX = FrmGFXView.PicConsole.FontSize * cFontOffsetScaleX
                OffsetY = FrmGFXView.PicConsole.FontSize * Len(param)
             Case Else
        End Select
        ' Rotate text 90 degrees
        FrmGFXView.PicTextPad.Cls
        FrmGFXView.PicTextPad.CurrentX = 0
        FrmGFXView.PicTextPad.CurrentY = 0
        FrmGFXView.PicTextPad.Print param
        
        FontSize = FrmGFXView.PicConsole.FontSize * 2
        CurrentX = (x1 * ScaleX) + OffsetX
        CurrentY = (TopY - y1 * ScaleY) + OffsetY
        
        For y = 0 To FrmGFXView.PicTextPad.ScaleHeight - 1
            For x = 0 To FrmGFXView.PicTextPad.ScaleWidth - 1
                If (FrmGFXView.PicTextPad.Point(x, y) <> &HFFFFFF) Then
                    FrmGFXView.PicConsole.PSet (CurrentX - ((FontSize / 2) - y), CurrentY + (-x)), 0
                End If
            Next x
        Next y
'debug
'        FrmGFXView.PicConsole.PSet ((x1 * ScaleX), (TopY - y1 * ScaleY)), &HFF
'        FrmGFXView.PicConsole.PSet ((x1 * ScaleX), (TopY - y1 * ScaleY)), &HFF
'        FrmGFXView.PicConsole.PSet ((x1 * ScaleX) - 1, (TopY - y1 * ScaleY)), &HFF
'        FrmGFXView.PicConsole.PSet ((x1 * ScaleX) - 1, (TopY - y1 * ScaleY) - 1), &HFF
'        FrmGFXView.PicConsole.PSet ((x1 * ScaleX), (TopY - y1 * ScaleY)), &HFF
    End If
End Function

'' Draw Box
Public Function iBox(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Boolean
    Call iDraw(x1, y1, x2, y1, False)     'top
    Call iDraw(x2, y1, x2, y2, False)    '
    Call iDraw(x2, y2, x1, y2, False)    '
    Call iDraw(x1, y2, x1, y1, False)    '
End Function

'' Reset Display
Public Sub Reset()
    FrmGFXView.PicConsole.Cls
    FrmGFXView.PicConsole.Line (0, 0)-(0, FrmGFXView.PicConsole.Height - 4)
    FrmGFXView.PicConsole.Line (0, 0)-(FrmGFXView.PicConsole.Width - 4, 0)
    FrmGFXView.PicConsole.Line (FrmGFXView.PicConsole.Width - 5, FrmGFXView.PicConsole.Height - 5)-(0, FrmGFXView.PicConsole.Height - 5)
    FrmGFXView.PicConsole.Line (FrmGFXView.PicConsole.Width - 5, FrmGFXView.PicConsole.Height - 5)-(FrmGFXView.PicConsole.Width - 5, 0)
    FrmTextView.TxtPrinterWindow.Text = ""
    Frmtest.TxtConsole.Text = ""
    
    ' load settings
    FrmGFXView.PicConsole.Font = FrmOptions.GFXFont
    FrmGFXView.PicConsole.FontSize = FrmOptions.GFXFontSize
    FrmGFXView.PicTextPad.Font = FrmOptions.GFXFont
    FrmGFXView.PicTextPad.FontSize = FrmOptions.GFXFontSize
    FrmGFXView.PicTextPad.Height = FrmOptions.GFXFontSize * 2
    vUserInputEnabled = FrmOptions.EnableUserInput
    Call Class_Initialize
End Sub
