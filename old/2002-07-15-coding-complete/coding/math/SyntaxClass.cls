VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SyntaxClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

'' The core of the emulator
'' This code read,processes,executes HPBasic programs


'' Uses - Strings (StringClass),Expression (ExpressionClass)
'Private strings As New StringClass

'' Type used to store current program line by line
Private Type ProgramLineType
    Line As String
    LineNumber As Long
End Type

'
Public Finished As Boolean                      '' Has a breakpoint been reached or program finished

Private ProgramFileName As String               '' File name of current program

Private ProgramBuffer(10000) As ProgramLineType '' Currently loaded program
Private NumProgramBuffer As Long                '' Size of program (number of lines)


'' Program state
Private DegreeON As Boolean                     '' Convert DEG to radians on MathOP (allways on atm)
Private PC As Long                              '' Program counter
Private WaitForUserInput As Boolean             '' Causes a wait for user input
Private vDynamicData() As Double                '' Used for data statements
Private NumDynamicData As Long
Private vPrintoutEnabled As Boolean             ''

'' Graphics state
Private vGraphicsState As Boolean
Private vAreaPen As Long
Private vClipStatus As Boolean
Private vCSizeX As Double
Private vCSizeY As Double
Private vLDir As Long
Private vLineType1 As Long              ' N/I
Private vLineType2 As Long              ' N/I
Private vLOrg As Long
Private vPenX As Double                 ' Current cursor positions
Private vPenY As Double
Private vPen As Long
Private vPivot As Long
Private vOutputDevice As Long           ' Printer=701, Display=0

Private vMinX As Double                 ' Screen bounds
Private vMaxX As Double
Private vMinY As Double
Private vMaxY As Double

Private vShowAngle As Boolean           ' Added to support printing of arrow heads on lines

''
Public Property Let PrintoutEnabled(value As Boolean)
    vPrintoutEnabled = value
End Property

''
Public Property Get PrintoutEnabled() As Boolean
    PrintoutEnabled = vPrintoutEnabled
End Property

''
Public Property Get CurrentInstruction() As String
    CurrentInstruction = ProgramBuffer(PC).LineNumber & " " & ProgramBuffer(PC).Line
End Property

'' Get Dynamic data used by VaribleClass
Public Property Get DynamicData() As String
    Dim I As Long
    DynamicData = ""
    I = 0
    If (NumDynamicData > 0) Then
        Do While (I < NumDynamicData)
            DynamicData = DynamicData & vDynamicData(I) & ","
            I = I + 1
        Loop
        DynamicData = Left$(DynamicData, Len(DynamicData) - 1)
    End If
End Property

''
Private Sub Class_Initialize()
    vPrintoutEnabled = False
    Call Interface.SetScale(200, 144)
End Sub

'' reset GFX
Private Function ResetGFX() ' as GINIT
    vAreaPen = 1
    vClipStatus = False      ' OFF
    vCSizeX = 5
    vCSizeY = 0.6
    vLDir = 0
    vLineType1 = 1
    vLineType2 = 5
    vLOrg = 1
    vPenX = 0
    vPenY = 0
    vPen = 1
    vPivot = 0
    vShowAngle = False
End Function

'' Convert HP formats to vb
Private Function ConvertFormat(ByRef FormatString As String) As String
    Dim MyFormat As String
    Dim length As Long

    ConvertFormat = ""
    length = strings.GetNextComma(FormatString)
    If (length = 0) Then
        length = Len(FormatString) + 1
    End If
    
    MyFormat = Left$(FormatString, length - 1)
    Do While (Right$(MyFormat, 1) = "X")
        ConvertFormat = ConvertFormat & strings.cInsert("!", Val(Left$(FormatString, Len(FormatString) - 1)))
        FormatString = Right$(FormatString, Len(FormatString) - strings.GetNextComma(FormatString))
        length = strings.GetNextComma(FormatString)
        If (length = 0) Then
            length = Len(FormatString) + 1
        End If
        MyFormat = Left$(FormatString, length - 1)
    Loop
    
    If (Right$(MyFormat, 1) = "K" Or Right$(MyFormat, 1) = "") Then
        ConvertFormat = ConvertFormat & ""
    Else
        If (MyFormat = "4D.D") Then
            ConvertFormat = ConvertFormat & "@@@0.0"
        Else
            If (MyFormat = "4D.DD") Then
                ConvertFormat = ConvertFormat & "@@@0.00"
            Else
                If (MyFormat = "3D.D") Then
                    ConvertFormat = ConvertFormat & "@@0.0"
                Else
                    If (MyFormat = "4D") Then
                        ConvertFormat = ConvertFormat & "@@@0"
                    Else
                        Error.DoError ("WARNING: Unsupported format string - " & MyFormat)
                    End If
                End If
            End If
        End If
    End If
    FormatString = Right$(FormatString, Len(FormatString) - strings.GetNextComma(FormatString))
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Statements

'' Standard goto <Linenumber>
Private Function sGoto(NewLineNumber As Long) As Long
    Dim I As Long
    Dim Found As Boolean
    
    Found = False
    For I = 0 To NumProgramBuffer - 1
        If (ProgramBuffer(I).LineNumber = NewLineNumber) Then
            Found = True
            sGoto = I
        End If
    Next
    
    If (Found = False) Then
        sGoto = PC + 1
        Call Error.DoError("ERROR: Undefined goto")
        Finished = True
    End If
End Function

' append data in statement into dynamic data
Private Sub sData(RightExp As String)
    Dim NumComma As Long
    Dim I As Long
    Dim TempData() As Double
    
    ' Remove post-fix comma
    If (Right$(RightExp, 1) = ",") Then
        RightExp = Left$(RightExp, Len(RightExp) - 1)
    End If
    
    NumComma = strings.CountComma(RightExp)
    If (NumComma > 0) Then
        NumComma = NumComma + 1
        If (NumDynamicData > 0) Then
            'expand data
            
            ReDim TempData(NumDynamicData + NumComma)
            For I = 0 To NumDynamicData
                TempData(I) = vDynamicData(I)
            Next
            ReDim vDynamicData(NumDynamicData + NumComma)
            For I = 0 To NumDynamicData
                vDynamicData(I) = TempData(I)
            Next
            
            I = NumDynamicData
            Do While (RightExp <> "")
               vDynamicData(I) = strings.GetNextNumber(RightExp)
               I = I + 1
            Loop
            NumDynamicData = I
        Else
            'init data
            I = 0
            ReDim vDynamicData(NumComma)
            Do While (RightExp <> "")
               vDynamicData(I) = strings.GetNextNumber(RightExp)
               I = I + 1
            Loop
            NumDynamicData = I
        End If
    Else
        Call Error.DoError("ERROR: data statement")
    End If
End Sub

'' Standard let (create varible if not exists)
Private Sub sLet(RightExp As String)
    Dim VaribleName As String
    Dim lExpression As String
    'get varible name
    VaribleName = Trim$(Left$(RightExp, InStr(RightExp, "=") - 1))
    lExpression = Trim$(Right$(RightExp, Len(RightExp) - InStr(RightExp, "=")))
    
    
    If (Varibles.SetVarible(VaribleName, Expression.Evaluate(lExpression)) = False) Then
        Call Error.DoError("ERROR: Undefined symbol")
    End If
End Sub

'' Read current dynamic data (from data statements) into array
Private Sub sRead(VarName As String)
    ' Just get name, ignore rest
    VarName = Left$(VarName, InStr(VarName, "(") - 1)
    Call Varibles.InitArray(VarName, vDynamicData, NumDynamicData)
    ' Reset dynamic data
    NumDynamicData = 0
End Sub

'' Dimension arrays before use
Private Sub sDim(param As String)
    Dim VarName As String
    Dim ind As String
    Dim NumComma As Long
    Dim Bounds(6) As Long
    Dim I As Long
    
    ind = Mid$(param, InStr(param, "(") + 1, InStrRev(param, ")") - InStr(param, "(") - 1)
    VarName = Left$(param, InStr(param, "(") - 1)
    NumComma = strings.CountComma(param)

    
    I = 0
    Do While (ind <> "")
       Bounds(I) = strings.GetNextNumber(ind)
       I = I + 1
    Loop
    Call Varibles.AddArray(VarName, I, Bounds(0), Bounds(1), Bounds(2), Bounds(3))

End Sub

'' Standard one line if statement
Private Sub sIf(command As String)
    Dim LeftExp As String
    Dim RightExp As String
    Dim CompareType As String
    Dim CompareString As String
    Dim TempCommand As String
    Dim I As Long
    
    CompareString = strings.Tokens(1)
    I = 2
    Do While (strings.Tokens(I) <> "THEN")
        CompareString = CompareString & " " & strings.Tokens(I)
        I = I + 1
    Loop
    
    TempCommand = Trim$(Right$(command, Len(command) - InStr(command, "THEN") - 3))
    If (IsNumeric(TempCommand) = True) Then
        TempCommand = "GOTO " & TempCommand
    End If
    
    If (Expression.Compare(CompareString) = True) Then
        Call ProcessStatement(TempCommand)
    End If
    
End Sub

'' Print text to console
Private Sub sPrint(pCurrentStatement As String)
    Dim tempstring As String
    Dim FormatString As String
    Dim RightParam As String
    Dim CommaPos As Long
    Dim tempe As String
    Dim tempf As String
    Dim I As Long
    
    
    Select Case strings.Tokens(1)
        Case "USING"
            FormatString = Mid$(strings.Tokens(2), 2, InStr(strings.Tokens(2), ";") - 3)
            RightParam = Right$(strings.Tokens(2), Len(strings.Tokens(2)) - InStr(strings.Tokens(2), ";"))
            I = 3
'debug
'            If InStr(FormatString, "4X,K,3D.D,K,") > 0 Then
'            i = i
'            End If
            
            tempf = ConvertFormat(FormatString)
            tempstring = tempstring & strings.MyFormat(Expression.Evaluate(RightParam), tempf)
            Do While (I <= strings.NumTokens)
                tempf = ConvertFormat(FormatString)
                tempstring = tempstring & strings.MyFormat(Expression.Evaluate(strings.Tokens(I)), tempf)
                I = I + 1
            Loop
        
        Case Else
            ' simple print
            Dim A As String
            A = Right$(pCurrentStatement, Len(pCurrentStatement) - InStr(pCurrentStatement, "PRINT") - 5)
            tempstring = Expression.Evaluate(Right$(pCurrentStatement, Len(pCurrentStatement) - InStr(pCurrentStatement, "PRINT") - 5))
    End Select
    Call Interface.iPrint(tempstring, vOutputDevice)
          
End Sub

'' Get responce from user
Private Sub sInput(Question As String, VaribleName As String)
    Call Varibles.AddVarible(VaribleName, Interface.iInput(Question, VaribleName))
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Graphics operations

'' Print Graphics screen to printer
Private Sub sDump()
    If (vPrintoutEnabled = True) Then
        Call Interface.iPrintGFXToPrinter
    End If
End Sub

'' Clear Graphics screen
Private Function sGClear() As Boolean
    sGClear = Interface.iClearGFX
End Function

'' Init gfx mode (move cursor bla,bla,bla)
Private Sub sGInit()
    Call ResetGFX
End Sub

'' Turn graphics display on/off (N/A)
Private Sub sGraphics(param As String)
    If (param = "ON") Then
        vGraphicsState = True
    Else
        If (param = "OFF") Then
            vGraphicsState = False
        Else
            Call Error.DoError("ERROR: in graphics statement")
        End If
    End If
End Sub

'' Clipping (not implemented)
Private Sub sClip(param As String)
    If (param = "ON") Then
        vClipStatus = True
    Else
        If (param = "OFF") Then
            vClipStatus = False
        Else
            Call Error.DoError("ERROR: in clip statement")
        End If
    End If
End Sub

'' Text position relative to cursor (see interface text print function)
Private Sub sLOrg(param As String)
    vLOrg = Val(param)
End Sub

'' Set text direction (angle of rotation, not implemented yet)
Private Sub sLDir(param As String)
    vLDir = Val(param)
End Sub

'' Draws a line from cursor position to new coords
Private Sub sDraw(xpos As Double, ypos As Double)
'    If (xpos < vMaxX And ypos < vMaxY And xpos > vMinX And ypos > vMinY) Then
        Call Interface.iDraw(vPenX, vPenY, xpos, ypos, vShowAngle)
        vShowAngle = False
        vPenX = xpos
        vPenY = ypos
'    Else
        ' error
'    End If
'    Finished = True
End Sub

'' Moves cursor on graphics screen
Private Sub sMove(xpos As String, ypos As String)
    vPenX = xpos
    vPenY = ypos
End Sub

'' Like print, except print on graphics screen at current cursor coords
Private Sub sLabel()
    Dim tempstring As String
    Dim FormatString As String
    Dim RightParam As String
    Dim tempe As String
    Dim tempf As String
    Dim I As Long
    Dim CommaPos As Long
    
    Select Case strings.Tokens(1)
        Case "USING"
            FormatString = Mid$(strings.Tokens(2), 2, InStr(strings.Tokens(2), ";") - 3)
            RightParam = Right$(strings.Tokens(2), Len(strings.Tokens(2)) - InStr(strings.Tokens(2), ";"))
            I = 3
            
            tempf = ConvertFormat(FormatString)
            tempstring = tempstring & strings.MyFormat(Expression.Evaluate(RightParam), tempf)
            Do While (I <= strings.NumTokens)
                tempf = ConvertFormat(FormatString)
                tempstring = tempstring & strings.MyFormat(Expression.Evaluate(strings.Tokens(I)), tempf)
                I = I + 1
            Loop
        Case Else
            ' simple print
            tempstring = Expression.Evaluate(strings.Tokens(1))
    End Select
    
'    If (vPenX > vMinX And vPenX < vMaxX And vPenY > vMinY And vPenY < vMaxY) Then
        Call Interface.iLabel(vPenX, vPenY, vLOrg, vLDir, tempstring)
'    End If
End Sub

'' Sets line style (not implemented)
Private Sub sLine()
    Call Interface.iSetLineStyle(strings.Tokens(2))
End Sub

'' Character size (font on graphics screen)
Private Sub sCSize(xsize As Double, ysize As Double)
    vCSizeX = xsize
    vCSizeY = ysize
End Sub

'' This defines viewable area on the graphics screen
Private Sub sViewPort(Minx As Double, MaxX As Double, Miny As Double, MaxY As Double)
    Call Interface.SetScale(200, 144)
'    Call Interface.SetScale(250, 250)
    vMinX = Minx
    vMaxX = MaxX
    vMinY = Miny
    vMaxY = MaxY
End Sub

''
Private Sub sFrame()
    vPenX = vMinX
    vPenY = vMinY
'    Call Interface.iBox(vMinX, vMinY, vMaxX, vMaxY)
End Sub

''
Private Sub sWindow()
    ' this one is complex
End Sub

''
Private Sub sShowAngle()
    vShowAngle = True
End Sub

Private Sub sSetPrinter(Number As String)
    vOutputDevice = Expression.Evaluate(Number)
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Processing

'' Here it is, the HP interpreter
Public Function ProcessStatement(CurrentStatement As String)
    Dim I As Long
    Dim tempstring As String
    Call strings.Tokenise(CurrentStatement)
    
    Call Expression.ResetStatus
    
    Select Case UCase$(strings.Tokens(0))
    
        ' Special ops
        Case "BREAKPOINT"
            Finished = True
            
        ' Single token op's
        Case "DEG"
            DegreeON = True
        Case "END"
            Finished = True
        Case "PAUSE"        'Wait for continue button to be pressed
            'NOP
        Case "PRINTER"
            Call sSetPrinter(strings.Tokens(2))
        Case "GCLEAR"
            Call sGClear
        Case "GINIT"
            Call sGInit
        Case "VIEWPORT"
            Call sViewPort(strings.Tokens(1), strings.Tokens(2), strings.Tokens(3), strings.Tokens(4))
        Case "FRAME"
            Call sFrame
        Case "WINDOW"
            ' ignore
  
            
        ' two token op's
        Case "GOTO"
            PC = sGoto(Val(strings.Tokens(1)))
        Case "INPUT"
            Call sInput(strings.Tokens(1), strings.Tokens(2))
        Case "GRAPHICS"
            Call sGraphics(strings.Tokens(1))
        Case "CLIP"
            Call sClip(strings.Tokens(1))
        Case "LORG"
            'specifies the relative origin of a label
            Call sLOrg(strings.Tokens(1))
        Case "LDIR"
            Call sLDir(strings.Tokens(1))
        Case "DRAW"
            Call sDraw(Expression.Evaluate(strings.Tokens(1)), Expression.Evaluate(strings.Tokens(2)))
        Case "CSIZE"
            Call sCSize(Expression.Evaluate(strings.Tokens(1)), Expression.Evaluate(strings.Tokens(2)))
        Case "MOVE"
            Call sMove(Expression.Evaluate(strings.Tokens(1)), Expression.Evaluate(strings.Tokens(2)))
            
            
        ' three token op's
        Case "OPTION"
            'nop
        Case "LET"
            Call sLet(strings.Tokens(1))
        Case "READ"
            Call sRead(strings.Tokens(1))
        Case "DIM"
            Call sDim(strings.Tokens(1))
        
        ' complex token op's
        Case "OUTPUT"      ' Hopefully only used to redirect to printer...
            'nop
        Case "DATA"
            tempstring = strings.Tokens(1)
            For I = 2 To strings.NumTokens
                tempstring = tempstring & "," & strings.Tokens(I)
            Next I
            Call sData(tempstring)
        Case "IF"
            Call sIf(CurrentStatement)
        Case "PRINT"
            Call sPrint(CurrentStatement)
        Case "LABEL"
            Call sLabel
        Case "DUMP"
            Call sDump
        Case "LINE"
            Call sLine
        
        ' Additional opperations - Used to add features not supp
        
        Case "SHOWANGLE"
            Call sShowAngle
        
        'Hybrid
'        Case "?"
            
        Case Else
            If (InStr(strings.Tokens(0), "=")) Then
                ' do exp=9*9
                Call sLet(strings.Tokens(0))
            Else
                Call Error.DoError("Unrecognised command : " & strings.Tokens(0))
            End If
    End Select
    If (Expression.WasError = True) Then
        Frmtest.TxtError.SelText = CurrentStatement & vbCrLf
    End If
End Function

'' Do one instruction
Public Sub ProcessorTick()
    'Main loop
    PC = PC + 1
    Error.LineNumber = ProgramBuffer(PC - 1).LineNumber
    Call ProcessStatement(ProgramBuffer(PC - 1).Line)
End Sub

''
Public Sub ResetProcessor()
    Call Varibles.Reset
    NumDynamicData = 0
    PC = 0
    DegreeON = False
    Finished = False
    Call Interface.Reset
End Sub

'' Load a program into memory
Public Function SetProgram(FileName As String) As Boolean
    Dim FileID As Long
    Dim I As Long
    Dim tempstring As String
    
    Call ResetProcessor
    ProgramFileName = FileName
    
    FileID = FreeFile
    If (FileName <> "" And Dir(ProgPath & FileName) <> "") Then
        Open ProgPath & FileName For Input As #FileID
        
        Do While (EOF(FileID) = False)
            Line Input #FileID, tempstring
            ProgramBuffer(I).LineNumber = Left$(tempstring, InStr(tempstring, " "))
            ProgramBuffer(I).Line = Right$(tempstring, Len(tempstring) - InStr(tempstring, " "))
            I = I + 1
        Loop
        
        NumProgramBuffer = I
        Close #FileID
        SetProgram = True
    Else
        ' If unable to load a program, load default program to avoid probs
        ProgramBuffer(I).LineNumber = "0"
        ProgramBuffer(I).Line = "End"
        SetProgram = False
    End If
End Function

