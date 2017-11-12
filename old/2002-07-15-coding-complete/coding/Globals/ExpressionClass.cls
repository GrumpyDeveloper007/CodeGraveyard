VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ExpressionClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''


''Uses - Varibles (VaribleClass) in globals, strings (StringClass), Error (ErrorClass)

' todo -
' Scientific numbers
'Arithmetic and logical operations
' Not
'Special expressions
'Null, Empty
'True, False
'
' done -
'Arithmetic and logical operations
'+ - * / \ ^ &
'= < > <> >= <=
'Functions
' Mod Div Or Xor Imp Eqv Like AND
'Abs Sgn Int Fix Sin Cos Tan SQR ATN ASN ROUND
'CInt CLng CByte CDbl CDec CCur CSng CBool CDate CVar
'Special expressions
' NOTE : All trig operations work in degrees only

Public vError As Boolean

''
Public Property Get WasError() As String
    WasError = vError
End Property

''
'Public Property Let WasError(Name As String)
'    vProgramName = Name
'End Property

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

'' Evaluate to numbers (or strings...), return result
Private Function ProcessOperator(ByVal LeftNumber As Variant, ByVal RightNumber As Variant, Operator As String) As Variant
    Select Case Operator
        Case "+"
            ProcessOperator = LeftNumber + RightNumber
        Case "-"
            ProcessOperator = LeftNumber - RightNumber
        Case "*"
            ProcessOperator = LeftNumber * RightNumber
        Case "\"
            ProcessOperator = LeftNumber \ RightNumber  ' Integer divide
        Case "/"
            If (RightNumber = 0) Then
                vError = True
                Call Error.DoError("Divide by zero:")
                ProcessOperator = 0
            Else
                ProcessOperator = LeftNumber / RightNumber  ' FP divide
            End If
        Case "^"
            ProcessOperator = LeftNumber ^ RightNumber
        Case "&"
            ProcessOperator = LeftNumber & RightNumber
        Case "MOD"
            ProcessOperator = LeftNumber Mod RightNumber
        Case "DIV"
            ProcessOperator = LeftNumber \ RightNumber
        Case "OR"
            ProcessOperator = LeftNumber Or RightNumber
        Case "XOR"
            ProcessOperator = LeftNumber Xor RightNumber
        Case "IMP"
            ProcessOperator = LeftNumber Imp RightNumber
        Case "EQV"
            ProcessOperator = LeftNumber Eqv RightNumber
        Case "AND"
            ProcessOperator = LeftNumber And RightNumber
'        Case "NOT"
'            ProcessOperator = LeftNumber & RightNumber
        Case "LIKE"
            ProcessOperator = LeftNumber Like RightNumber
        ' Logical evaluators
        Case "="
            If (LeftNumber = RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case "<"
            If (LeftNumber < RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case ">"
            If (LeftNumber > RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case "<="
            If (LeftNumber <= RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case ">="
            If (LeftNumber >= RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case "<>"
            If (LeftNumber <> RightNumber) Then
                ProcessOperator = True
            Else
                ProcessOperator = False
            End If
        Case Else
            vError = True
            Call Error.DoError("Unidentified operator :" & Operator)
            ProcessOperator = -1
    End Select
End Function

'' Check for known operators, get priority (BODMAS)
Private Function GetOperatorPriority(Operator As String) As Long
    Select Case Operator
        Case "NULL"
            GetOperatorPriority = 0
        Case "AND", "DIV", "XOR", "IMP", "EQV", "NOT", "AND", "OR", "LIKE"
            GetOperatorPriority = 1
        Case "=", "<>", "<", ">", "<=", ">="
            GetOperatorPriority = 2
        Case "+"
            GetOperatorPriority = 3
        Case "-"
            GetOperatorPriority = 3
        Case "*"
            GetOperatorPriority = 6
        Case "\", "/"
            GetOperatorPriority = 6
        Case "^"
            GetOperatorPriority = 7
        Case Else
            vError = True
            Call Error.DoError("Unidentified operator :" & Operator)
            GetOperatorPriority = -1
    End Select
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Functions

'' ABS()
Private Function DoABS(Number As Double) As Double
    If (Number < 0) Then
        Number = -Number
    End If
    DoABS = Number
End Function

'' Round number down to a integer value
Private Function DoRound(Number As Variant) As Long
'    On Error GoTo Error
    DoRound = Number
'    Exit Function
'Error:
'    DoRound = 219000000
End Function

'' Precision round, round number to a set number of digits
Private Function DoPRound(Number As Variant, Exp As Variant) As Variant
    DoPRound = 0
    Select Case Exp
        Case -2
            DoPRound = DoRound(Number * 100) / 100
        Case -1
            DoPRound = DoRound(Number * 10) / 10
        Case 0
            DoPRound = DoRound(Number)
        Case 1
            DoPRound = DoRound(Number / 10) * 10
        Case Else
            vError = True
            Call Error.DoError("ERROR: Unknown exp in PRound()")
    End Select
End Function

'' Get function result or array value
Private Function GetFunction(param As String, ByRef Success As Boolean) As Variant
    Dim command As String
    Dim BracketPos As Long
    Dim RightNumber(10) As Variant
    Dim CommaPos As Long
    Dim Parameters As String
    Dim tempparam As String
    Dim numparam As Long
    
    
    BracketPos = InStr(param, "(")
    command = Left$(param, BracketPos - 1)
    Parameters = Mid$(param, BracketPos + 1, Len(param) - (BracketPos + 1))
    CommaPos = Strings.GetNextComma(Parameters)
    
    If (CommaPos = 0) Then
    ' Resolve inbrackets parts - abs(xxxx)
        RightNumber(0) = Evaluate(Parameters)
        numparam = 1
    Else
        numparam = 0
        tempparam = Strings.GetNextParameter(Parameters)
        Do While (tempparam <> "")
            RightNumber(numparam) = Evaluate(tempparam)
            numparam = numparam + 1
            tempparam = Strings.GetNextParameter(Parameters)
        Loop
    End If
    
    Success = True
    Select Case UCase$(command)
        Case "CINT"
            GetFunction = CInt(RightNumber(0))
        Case "CLNG"
            GetFunction = CLng(RightNumber(0))
        Case "CBYTE"
            GetFunction = CByte(RightNumber(0))
        Case "CDBL"
            GetFunction = CDbl(RightNumber(0))
        Case "CDEC"
            GetFunction = CDec(RightNumber(0))
        Case "CCUR"
            GetFunction = CCur(RightNumber(0))
        Case "CSTR"
            GetFunction = CStr(RightNumber(0))
        Case "CSNG"
            GetFunction = CSng(RightNumber(0))
        Case "CBOOL"
            GetFunction = CBool(RightNumber(0))
        Case "CDATE"
            GetFunction = CDate(RightNumber(0))
        Case "CVAR"
            GetFunction = CVar(RightNumber(0))
        Case "ABS"
            GetFunction = Abs(RightNumber(0))
        Case "FIX"
            GetFunction = Fix(RightNumber(0))
        Case "SGN"
            GetFunction = Sgn(RightNumber(0))
        Case "INT"
            GetFunction = Int(RightNumber(0))
        Case "ROUND"
            GetFunction = DoRound(RightNumber(0))
        Case "SIN"
            GetFunction = Sin(RightNumber(0) * pi / 180)
        Case "COS"
            GetFunction = Cos(RightNumber(0) * pi / 180)
        Case "TAN"
            GetFunction = Tan(RightNumber(0) * pi / 180)
        Case "SQR"
            GetFunction = Sqr(RightNumber(0))
        Case "ATN"
            GetFunction = Atn(RightNumber(0)) * 180 / pi
        Case "ASN"
            ' only works in -90 to +90 degrees
            If (RightNumber(0) < 1) Then
                RightNumber(0) = RightNumber(0)
                GetFunction = Atn(RightNumber(0) / Sqr(-RightNumber(0) * RightNumber(0) + 1)) * 180 / pi
            Else
                vError = True
                Call Error.DoError("ERROR: Invalid asn value")
            End If
        Case "PROUND"
 '           GetFunction = RightNumber(0)
            GetFunction = DoPRound(RightNumber(0), RightNumber(1))
        Case Else
            Select Case numparam
                Case 1
                    ' one dimension
                    GetFunction = Varibles.GetArray(command, 1, Success, Val(RightNumber(0)))
                Case 2
                    'two dimension or more
                    GetFunction = Varibles.GetArray(command, 2, Success, Val(RightNumber(0)), Val(RightNumber(1)))
                Case 3
                    'two dimension or more
                    GetFunction = Varibles.GetArray(command, 3, Success, Val(RightNumber(0)), Val(RightNumber(1)), Val(RightNumber(2)))
                Case 4
                    'two dimension or more
                    GetFunction = Varibles.GetArray(command, 4, Success, Val(RightNumber(0)), Val(RightNumber(1)), Val(RightNumber(2)), Val(RightNumber(3)))
                Case Else
                    vError = True
                    Call Error.DoError("ERROR: Unsupported number of array parameters")
            End Select
            
            If (Success = False) Then
                vError = True
                Call Error.DoError("ERROR: Unsupported array :" & command)
            End If
    End Select
    
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''

'' Get number, check for varibles, arrays, functions, brackets...
Private Function GetNumber(ByRef param As String) As Variant
    Dim OperatorPos As Long
    Dim LeftExpression As String
    Dim Success As Boolean
    param = Trim$(param)
    OperatorPos = Strings.GetOperatorPos(param)
    LeftExpression = Left$(param, OperatorPos)
    
    ' if operator position =0 then = ('-10' or '+10') or ('/10' or '*10')
    If (OperatorPos = 0) Then
        If (Left$(param, 1) = "+" Or Left$(param, 1) = "-") Then
            param = "0" & param
            GetNumber = SubEvaluate(param)
        Else
            vError = True
            Call Error.DoError("Error invalid statement : " & param)
            param = ""
            GetNumber = -1
        End If
    Else
        ' Check for brackets, if then process expression in brackets
        If (Left$(LeftExpression, 1) = "(") Then
            'there is a bracket, so clip and process
            GetNumber = SubEvaluate(Mid$(LeftExpression, 2, Len(LeftExpression) - 2))
        Else
            ' Check for varibles and functions
            If (IsNumeric(LeftExpression)) Then
                ' Simple numeric here
                GetNumber = Val(LeftExpression)
            Else
                ' Varibles and functions here
                If (InStr(LeftExpression, "(") = 0) Then
                    If (InStr(LeftExpression, Chr$(34)) > 0) Then
                        ' "dale" (string constant)
                        OperatorPos = InStr(2, LeftExpression, Chr$(34))
                        GetNumber = Mid$(LeftExpression, 2, OperatorPos - 2)
                        Success = True
                    Else
                        GetNumber = Varibles.GetVarible(LeftExpression, Success)
                    End If
                Else
                    GetNumber = GetFunction(LeftExpression, Success)
                End If
                If (Success = False) Then
                    vError = True
'                    Call error.doerror("Undefined symbol :" & LeftExpression)
                End If
            End If
        End If
        param = Trim$(Right$(param, Len(param) - OperatorPos))
    End If
End Function

'' Evaluate all lower priority expressions to the right otherwise exit(return current result)
Private Function Process(LeftNumber As Variant, LeftOperator As String, rightstring As String) As Variant
    Dim RightNumber As Variant
    Dim RightOperator As String
    Dim TempString As String
    
    
    ' Get/resolve right operator
    RightNumber = GetNumber(rightstring)
    If (Strings.IsMoreOperators(rightstring) = True) Then
    
        ' Get next operator and check if it should be done before current one
        RightOperator = Strings.GetOperator(rightstring, 1)
        Do While (GetOperatorPriority(LeftOperator) < GetOperatorPriority(RightOperator))
            '1+1*8
            rightstring = Trim$(Right$(rightstring, Len(rightstring) - Len(RightOperator)))
            RightNumber = Process(RightNumber, RightOperator, rightstring)
            
            If (rightstring = "") Then
                RightOperator = "NULL"
            Else
                RightOperator = Strings.GetOperator(rightstring, 1)
            End If
        Loop
        If (GetOperatorPriority(LeftOperator) >= GetOperatorPriority(RightOperator)) Then
            '1*8+1
            Process = ProcessOperator(LeftNumber, RightNumber, LeftOperator)
        Else
        End If
    Else
        ' 1+1
        Process = ProcessOperator(LeftNumber, RightNumber, LeftOperator)
    End If
End Function

'' Evaluate all left high priority operations, otherwise call process,return result
Private Function SubEvaluate(Expression As String) As Variant
    Dim LeftNumber As Variant
    Dim LeftOperator As String
    Dim Acc As Variant
        ' Check for string ops
'        If (InStr(Expression, "$") > 0 Or InStr(Expression, Chr$(34)) > 0) Then
'            ' simple evaluate
'            If (InStr(Expression, "$")) Then
'                ' v$ (varible)
'                Evaluate = Varibles.GetVarible(Expression, False)
'            Else
'                ' "dale" (string constant)
'                Evaluate = Mid$(Expression, 2, Len(Expression) - 2)
'            End If
'        Else
    If Left$(Expression, 1) = "O" Then
        Acc = Acc
    End If
    
    LeftNumber = GetNumber(Expression)
    
    If (Len(Expression) > 0) Then
        Do While (Expression <> "")
            LeftOperator = Strings.GetOperator(Expression, 1)
            Expression = Trim$(Right$(Expression, Len(Expression) - Len(LeftOperator)))
            Acc = Process(LeftNumber, LeftOperator, Expression)
            LeftNumber = Acc
        Loop
    Else
        Acc = LeftNumber
    End If
    SubEvaluate = Acc
End Function

'' Set
Public Sub ResetStatus()
    vError = False
End Sub

'' Starting point
Public Function Evaluate(Expression As String) As Variant
    Dim tempnum As Double
    Dim TempString As String
    TempString = Expression
    
    ' Hack for big number
'    Expression = strings.DeleteWhiteSpace(tempstring)

    ' No scientific numbers supported yet
    If (TempString = "9.E+99" Or TempString = "9E+99") Then
        Evaluate = Val(9E+99)
    Else
        Evaluate = SubEvaluate(TempString)
    End If
    If (IsNumeric(Evaluate)) Then
        tempnum = Evaluate
        Evaluate = tempnum
    End If
End Function

'' Starting point for operation that allways return a True/False value
Public Function Compare(Expression As String) As Boolean
    Compare = False
    If (Evaluate(Expression) = True) Then
        Compare = True
    End If
End Function
