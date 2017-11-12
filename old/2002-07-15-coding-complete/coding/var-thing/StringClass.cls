VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StringClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

'' Utility class - Strings

''

Private vTokens(100) As String                    '' Current statement split into tokens
Private vNumTokens As Long

''
Property Get Tokens(index As Long) As String
    Tokens = vTokens(index)
End Property

''
Property Get NumTokens() As Long
    NumTokens = vNumTokens
End Property

'' Returns position of the first space or comma, or 0 if not found
Private Function CheckForTokens(ByRef SourceString As String) As Long
    Static tempstring As String
    Static i As Long
    Static ignoreon As Boolean
    Static char As String * 1
    
    tempstring = SourceString
    
    ' Ignore strings constants
'    If (Left$(tempstring, 1) = Chr$(34)) Then
    i = 1
    ignoreon = False
    Do While i < Len(tempstring)
        char = Mid$(tempstring, i, 1)
        If (ignoreon = False) Then
            If (char = " " Or char = ",") Then
                Exit Do
            End If
        End If
        If (char = Chr$(34)) Then
            ignoreon = Not ignoreon
        End If
        
        ' Move to next character(if brackets are found then find closing bracket)
        If (char = "(") Then
            i = GetCloseBracketPos(tempstring, i)
        Else
            i = i + 1
        End If
    Loop
    If (i = Len(tempstring)) Then
        i = 0
    End If
    CheckForTokens = i
'    End If
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Simple operations

'' hmmm,
Private Function IsOperator(ByRef param As String, Position As Long) As Boolean
    Select Case Mid$(param, Position, 1)
        Case "+", "-", "*", "\", "/", "^", "&", "=", "<", ">"
            IsOperator = True
        Case Else
            Select Case UCase$(Mid$(param, Position, 3))
                Case "MOD", "DIV", "XOR", "IMP", "EQV", "NOT", "AND"
                    IsOperator = True
                Case Else
                    Select Case (UCase$(Mid$(param, Position, 2)))
                        Case "OR", ">=", "<=", "<>"
                            IsOperator = True
                        Case Else
                            If (UCase$(Mid$(param, Position, 4)) = "LIKE") Then
                                IsOperator = True
                            Else
                                IsOperator = False
                            End If
                    End Select
            End Select
    End Select
End Function

'' Scan for closing bracket
Private Function GetCloseBracketPos(ByRef param As String, startpos As Long) As Long
    Static bracketCount As Long
    Static i As Long
    Static char As String
    
    bracketCount = 1
    i = startpos + 1
    
    ' Scan until end of string or the last brackets is found
    Do While (i <= Len(param) And bracketCount > 0)
        char = Mid$(param, i, 1)
        
        'Check for nesting of brackets
        Select Case char
            Case "("
                bracketCount = bracketCount + 1
            Case ")"
                bracketCount = bracketCount - 1
            Case Else
        End Select
        i = i + 1
    Loop
    GetCloseBracketPos = i - 1
End Function

'' Search for a set of characters within a string
Private Function ScanForNextChar(ByRef param As String, ByRef SearchParam As String) As Long
    Static i As Long
    Static char As String
    Static ignoreon As Boolean
    
    ignoreon = False
    
    i = 1
    Do While (i <= Len(param))
        char = Mid$(param, i, 1)
        If (ignoreon = False) Then
            If (InStr(SearchParam, char) > 0) Then
                Exit Do
            End If
        End If
        
        If (char = Chr$(34)) Then
            ignoreon = Not ignoreon
        End If
        ' Move to next character(if brackets are found then find closing bracket)
        If (char = "(") Then
            i = GetCloseBracketPos(param, i)
        Else
            i = i + 1
        End If
    Loop
    
    ' Hack to make sure operation doesent return > length
    If (i >= Len(param)) Then
        i = 0
'        i = Len(param)
    End If
    ScanForNextChar = i
End Function

'' Count number of accorances of a character
Private Function CountChar(param As String, char As String) As Long
    Dim i As Long
    Dim Count As Long
    Count = 0
    For i = 1 To Len(param)
        If (Mid$(param, i, 1) = char) Then
            Count = Count + 1
        End If
    Next i
    CountChar = Count
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Public functions

'' Function to allow code to be better parsed
Public Sub Tokenise(ByRef SourceString As String)
    Static CurrentString As String
    Static NextDelimiter As Long
    
    CurrentString = SourceString
    vNumTokens = 0
    
    Do While (CurrentString <> "")
        NextDelimiter = CheckForTokens(CurrentString)
        If (NextDelimiter < 1) Then
            vTokens(vNumTokens) = CurrentString
            CurrentString = ""
        Else
            vTokens(vNumTokens) = Left$(CurrentString, NextDelimiter - 1)
            CurrentString = Trim$(Right(CurrentString, Len(CurrentString) - (NextDelimiter)))
        End If
        vNumTokens = vNumTokens + 1
    Loop
    vNumTokens = vNumTokens - 1
End Sub

'' Returns two strings one outside of brackets, one inside
Public Function DeleteInBrackets(ByRef instring As String, ByRef retstring As String) As String
    Static positionA As Long, positionB As Long
    positionA = InStr(instring, "(")
    positionB = GetCloseBracketPos(instring, InStr(instring, "("))
    If (positionA > 0 And positionB > 0) Then
        DeleteInBrackets = Left$(instring, positionA - 1) & Right$(instring, Len(instring) - positionB)
        retstring = Mid$(instring, positionA, positionB - positionA + 1)
    Else
        DeleteInBrackets = instring
    End If
End Function

'' Return operator
Public Function GetOperator(ByRef pOperator As String, Position As Long) As String
    Select Case Mid$(pOperator, Position, 1)
        Case "+", "-", "*", "\", "/", "^", "&", "=", "<", ">"
            GetOperator = Mid$(pOperator, Position, 1)
        Case Else
            Select Case UCase$(Mid$(pOperator, Position, 3))
                Case "MOD", "DIV", "XOR", "IMP", "EQV", "NOT", "AND"
                    GetOperator = UCase$(Mid$(pOperator, Position, 3))
                Case Else
                    Select Case (UCase$(Mid$(pOperator, Position, 2)))
                        Case "OR", "<=", ">=", "<>"
                            GetOperator = UCase$(Mid$(pOperator, Position, 2))
                        Case Else
                            If (UCase$(Mid$(pOperator, Position, 4)) = "LIKE") Then
                                GetOperator = UCase$(Mid$(pOperator, Position, 4))
                            Else
                                GetOperator = ""
                                Call error.DoError("ERROR: Undefined operator in :" & pOperator)
                            End If
                    End Select
            End Select
    End Select
End Function

'' Convert format, like format function except additional features added
Public Function MyFormat(param As String, FormatString As String) As String
    Dim tempstring As String
    Dim NumberSpaces As String
    ' Special format numeric format characters -
    ' @ - repersents a number or " "
    If (InStr(FormatString, "!") > 0) Then
        tempstring = tempstring
        NumberSpaces = CountChar(FormatString, "!")
        FormatString = Replace(FormatString, "!", "")
    Else
        NumberSpaces = 0
    End If
    
    If (InStr(FormatString, "@") > 0) Then
        FormatString = Replace(FormatString, "@", "#")
        tempstring = Format(param, FormatString)
        If (Len(FormatString) > Len(tempstring)) Then
            tempstring = Space(Len(FormatString) - Len(tempstring)) & tempstring
        End If
    Else
        If (FormatString = "") Then
            tempstring = param
        Else
            tempstring = Format(param, FormatString)
        End If
    End If
    MyFormat = Space(NumberSpaces) & tempstring
End Function

'' Trims spaces and tabs
Public Function AllTrim(instring As String) As String
    Static tempstring As String
    tempstring = Replace$(instring, Chr(9), " ") ' Delete tabs
    AllTrim = Trim$(tempstring)
End Function

''
Public Function GetNextComma(ByRef param As String) As Long
    GetNextComma = ScanForNextChar(param, ",")
End Function

'' Get next string upto a comma, no special checking ("") etc.
Public Function GetNextParameter(ByRef param As String) As String
    Static i As Long
    
    i = GetNextComma(param)
    If (i > 0) Then
        '999,66
        GetNextParameter = Left$(param, i - 1)
        param = Right$(param, Len(param) - i)
    Else
        ' 999
        GetNextParameter = param
        param = ""
    End If
End Function

'' Like get next parameter, but return a double
Public Function GetNextNumber(ByRef param As String) As Double
    Static pos As Long
    
    pos = InStr(param, ",")
    If (pos = 0) Then
        GetNextNumber = Val(param)
        param = ""
    Else
        GetNextNumber = Val(Left$(param, pos - 1))
        param = Right$(param, Len(param) - pos)
    End If
End Function

'' Returns the position of the next operator '+-*\/' or last position if not found
Public Function GetOperatorPos(ByRef param As String) As Long
    Static i As Long
    Static char As String
    
    i = 1
    Do While (i <= Len(param))
        char = Mid$(param, i, 1)
        If (IsOperator(param, i) = True) Then
            i = i - 1
            Exit Do
        End If
        
        ' Move to next character(if brackets are found then find closing bracket)
        Select Case char
            Case "("
                i = GetCloseBracketPos(param, i)
            Case Chr$(34)
                If (InStr(i + 1, param, Chr$(34)) > 0) Then
                    i = InStr(i + 1, param, Chr$(34))
                Else
                    i = i + 1
                End If

            Case Else
                i = i + 1
        End Select
    Loop
    
    ' Hack to make sure operation doesent return > length
    If (i > Len(param)) Then
        i = Len(param)
    End If
'    GetOperatorPos = ScanForNextChar(param, "+-*/\") - 1
    GetOperatorPos = i
End Function

'' Simple scan for more operators, shouldent search within brackets
Public Function IsMoreOperators(ByRef param As String) As Boolean
    Static i As Long
    
    
    If (GetOperatorPos(param) < Len(param)) Then
        IsMoreOperators = True
    Else
        IsMoreOperators = False
    End If
End Function

'' Return number of comma in a string
Public Function CountComma(ByRef param As String) As Long
    Static i As Long
    CountComma = CountChar(param, ",")
End Function

'' Insert a character a number of times
Public Function cInsert(ByRef char As String, Times As Long) As String
    Static i As Long
    cInsert = ""
    For i = 1 To Times
        cInsert = cInsert & char
    Next
End Function

'' Gets a string right of a '=' sign
Public Function GetRightValue(CurrentLine As String) As String
    GetRightValue = Trim$(Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, "=")))
End Function

'' Gets a value right of a '=' sign
Public Function GetLongValue(CurrentLine As String) As Long
    GetLongValue = Right$(CurrentLine, Len(CurrentLine) - InStrRev(CurrentLine, "="))
End Function

'' Get a string left of a '=' sign
Public Function GetLeftValue(param As String) As String
    If (InStrRev(param, "=") > 0) Then
        GetLeftValue = Trim(Left$(param, InStrRev(param, "=") - 1))
    Else
        GetLeftValue = ""
    End If
End Function

'' Delete all white space ignoring string literals
Public Function DeleteWhiteSpace(pSource As String) As String
    Dim i As Long
    Dim InSpeech As Boolean
    Dim char As String * 1
    i = 1
    InSpeech = False
    Do While (i <= Len(pSource))
        char = Mid$(pSource, i, 1)
        If (char = Chr$(34)) Then
            InSpeech = Not InSpeech
        End If
        If (InSpeech = False) Then
            If (char <> " ") Then
                DeleteWhiteSpace = DeleteWhiteSpace & char
            End If
        Else
            DeleteWhiteSpace = DeleteWhiteSpace & char
        End If
        i = i + 1
    Loop
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Other useful string operation

'' Ensures a string has an extension
Public Function CheckExtension(ByRef Name As String, ByRef Extension As String) As String
    If (Right$(Name, Len(Extension)) <> Extension) Then
        CheckExtension = Name & Extension
    Else
        CheckExtension = Name
    End If
End Function

'' Ensure path allways includes a back slash
Public Function GetPathFromAppPath() As String
    If (Right$(App.Path, 1) <> "\") Then
        GetPathFromAppPath = App.Path & "\"
    Else
        GetPathFromAppPath = App.Path
    End If
End Function
