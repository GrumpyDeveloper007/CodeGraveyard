VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ParseClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Parse Class
''
'' Coded by Dale Pitman

Private strings As New StringClass

Private vLineComment As String               ' The Comment for current line
Private vTabLevel As Long
Private vCurrentTarget As TargetObjectType  ' Current .Frm/.Cls/.bas
Private vIndex As Long                      ' Used in get dim info

Private vCurrentDims(3000) As VaribleType    ' list of varibles defined in a procedure/function
Private vMaxDim As Long                      ' Number of dims is current procedure
Private vContext As Long

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

''
Property Get LineComment() As String
    LineComment = vLineComment
End Property

''
Property Get MaxFormIndex() As Long
    MaxFormIndex = vMaxDim
End Property

''
Property Let CurrentForm(pValue As Long)
'    vCurrentForm = pValue
    vCurrentTarget = TargetObjects(pValue)
End Property

''
Property Let SetContext(pValue As Long)
    vContext = pValue
End Property

''
Public Sub ResetIndex()
    vIndex = 0
End Sub

''
Public Function GetDimInfo(ByRef pName As String, ByRef pType As Long, ByRef pUsed As Long, ByRef pScope As Long) As Boolean
    If (vIndex < vMaxDim) Then
        pName = vCurrentDims(vIndex).Name
        pType = vCurrentDims(vIndex).Type
        pUsed = vCurrentDims(vIndex).Used
        pScope = vCurrentDims(vIndex).Scope
        vIndex = vIndex + 1
        GetDimInfo = True
    Else
        GetDimInfo = False
    End If
End Function

''
Private Function Tabs(NumberTabs As Long) As String
    Static iloop As Long
    For iloop = 0 To NumberTabs - 1
        Tabs = Tabs & "    "
    Next
End Function

''
Private Function GetVaribleScope(pScope As String) As Long
    If (vContext = cGlobal) Then
        If (pScope = "Dim" Or pScope = "Private") Then
            GetVaribleScope = cLocal
        Else
            If (pScope = "Public") Then
                GetVaribleScope = cGlobal
            Else
                GetVaribleScope = cUnknown
            End If
        End If
    Else
        GetVaribleScope = cLocal
    End If
End Function

'' Returns the position of the next valid varible definition
Private Function AddDimToList(TokenNumber As Long) As Long
    vCurrentDims(vMaxDim).Name = strings.DeleteInBrackets(strings.Tokens(TokenNumber), "")
    vCurrentDims(vMaxDim).Used = 0
    
    AddDimToList = TokenNumber + 1
    vCurrentDims(vMaxDim).Scope = GetVaribleScope(strings.Tokens(TokenNumber - 1))
    Select Case Right(strings.Tokens(TokenNumber), 1)
        Case "%"
            vCurrentDims(vMaxDim).Type = vbInteger
        Case "!"
            vCurrentDims(vMaxDim).Type = vbSingle
        Case "$"
            vCurrentDims(vMaxDim).Type = vbString
        Case "&"
            vCurrentDims(vMaxDim).Type = vbLong
        Case "@"
            vCurrentDims(vMaxDim).Type = vbCurrency
        Case Else
            '' static xxxxx as nnnnnn
            If (strings.NumTokens > TokenNumber + 1 And strings.Tokens(TokenNumber + 1) = "As") Then
                ''
                AddDimToList = TokenNumber + 3
                Select Case strings.Tokens(TokenNumber + 2)
                    Case "Integer"
                        vCurrentDims(vMaxDim).Type = vbInteger '2
                    Case "Long"
                        vCurrentDims(vMaxDim).Type = vbLong    '3
                    Case "Single"
                        vCurrentDims(vMaxDim).Type = vbSingle '4
                    Case "Double"
                        vCurrentDims(vMaxDim).Type = vbDouble '5
                    Case "Currency"
                        vCurrentDims(vMaxDim).Type = vbCurrency   '6
                    Case "Date"
                        vCurrentDims(vMaxDim).Type = vbDate   '7
                    Case "String"
                        vCurrentDims(vMaxDim).Type = vbString '8
                        If (strings.Tokens(TokenNumber + 3) = "*") Then
                            AddDimToList = TokenNumber + 5
                        End If
                    Case "Object"
                        vCurrentDims(vMaxDim).Type = vbObject '9
                    Case "Error"
                        vCurrentDims(vMaxDim).Type = vbError  '10
                    Case "Boolean"
                        vCurrentDims(vMaxDim).Type = vbBoolean '11
                    Case "Variant"
                        vCurrentDims(vMaxDim).Type = vbVariant '12
                    Case "DataObject"
                        vCurrentDims(vMaxDim).Type = vbDataObject '13
                    Case "Decimal"
                        vCurrentDims(vMaxDim).Type = vbDecimal '14
                    Case "Byte"
                        vCurrentDims(vMaxDim).Type = vbByte   '17
                    Case "UserDefinedType"
                        vCurrentDims(vMaxDim).Type = vbUserDefinedType '36
                    Case "Array"
                        vCurrentDims(vMaxDim).Type = vbArray  '8192
                        
                    Case "Recordset"
                        vCurrentDims(vMaxDim).Type = dRecordSet
                    Case "Field"
                        vCurrentDims(vMaxDim).Type = dField
                    Case "Node"
                        vCurrentDims(vMaxDim).Type = dNode
                    Case "New"
                        AddDimToList = TokenNumber + 4
                        vCurrentDims(vMaxDim).Type = vbUserDefinedType
                    Case Else
                        Call ReduencyChecker.LstDatatypeFails.AddItem("Failed Datatype -" & strings.Tokens(TokenNumber + 2))
                        '                        MsgBox ("Unknown data type -" & LineTokens(TokenNumber + 2))
                End Select
            Else
                vCurrentDims(vMaxDim).Type = vbVariant
            End If
    End Select
    vMaxDim = vMaxDim + 1
End Function

'' Seperates comment and code, returns code
Public Function StripComment(line As String) As String
    Dim i As Long
    Dim InsideSpeech As Boolean
    If (Left(line, 1) = "'") Then
        vLineComment = Trim(line)
        StripComment = ""
    Else
        InsideSpeech = False
        vLineComment = ""
        StripComment = line
        For i = 1 To Len(line)
            If (Mid$(line, i, 1) = Chr$(34)) Then
                If (InsideSpeech = True) Then
                    InsideSpeech = False
                Else
                    InsideSpeech = True
                End If
            End If
            If (InsideSpeech = False) Then
                If (Mid$(line, i, 1) = "'") Then
                    vLineComment = Trim$(Right$(line, Len(line) - i + 1))
                    StripComment = Left$(line, i - 1)
'                    vLineComment = Trim$(Right$(line, Len(line) - InStr(line, "'") + 1))
'                    StripComment = Left$(line, InStr(line, "'") - 1)
                Else
                End If
            End If
        Next
    End If
End Function

'' Checks if first token is a declaration within context (Dim/Public/Private)
Private Function IsDeclaration(pString As String) As Boolean
    If (vContext = cGlobal) Then
        If (pString = "Dim" Or pString = "Public" Or pString = "Private") Then
            IsDeclaration = True
        Else
            IsDeclaration = False
        End If
    Else
        If (pString = "Dim") Then
            IsDeclaration = True
        Else
            IsDeclaration = False
        End If
    End If
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


''
Private Sub GetDims()
    Static CurrentToken As Long
    
    ' linetokens(0) = "Dim",linetikens(1) = varible name
    CurrentToken = 1
    If (IsDeclaration(strings.Tokens(0))) Then
        Do While (strings.NumTokens >= CurrentToken)
            ' Check for types and constants
            If (strings.Tokens(CurrentToken) = "Const" Or strings.Tokens(CurrentToken) = "Type") Then
                CurrentToken = strings.NumTokens + 1
            Else
                CurrentToken = AddDimToList(CurrentToken)
            End If
        Loop
    End If
End Sub

''
Public Sub CheckUsage(startv As Long, endv As Long)
    Static iloop As Long, iloop2 As Long
    For iloop = startv To endv
        Call strings.Tokenise(vCurrentTarget.Lines(iloop), True)
    
        For iloop2 = 0 To vMaxDim - 1
            If (InStr(vCurrentTarget.Lines(iloop), vCurrentDims(iloop2).Name) > 0) Then
            
                If (IsDeclaration(strings.Tokens(0)) = False) Then
                    vCurrentDims(iloop2).Used = vCurrentDims(iloop2).Used + 1
                End If
            End If
        Next
    Next
End Sub

''
Public Sub ClearUsage()
    vMaxDim = 0
End Sub

'' Loop all lines looking for declarations
Public Function GetDimedVars(startv As Long, endv As Long) As Long
    Static iloop As Long
    Static TempString As String
    
    For iloop = startv To endv
        TempString = StripComment(vCurrentTarget.Lines(iloop))
        Call strings.Tokenise(TempString, True)
        Call GetDims
    Next
End Function

'' Look for declarations, and check for usage of the declarations
Public Function GetDimedVars2(startv As Long, endv As Long) As Long
    Static iloop As Long, iloop2 As Long
    Static TempString As String
    
    ' Clear usage
    vMaxDim = 0
    
    For iloop = startv To endv
        ' Check for dims
        TempString = StripComment(vCurrentTarget.Lines(iloop))
        Call strings.Tokenise(TempString, True)
        Call GetDims
    
        ' Check if used, using simpler method
        For iloop2 = 0 To vMaxDim - 1
            If (InStr(TempString, vCurrentDims(iloop2).Name) > 0) Then
                If (IsDeclaration(strings.Tokens(0)) = False) Then
                    vCurrentDims(iloop2).Used = vCurrentDims(iloop2).Used + 1
                End If
            End If
        Next
    Next
End Function

''
Public Function ResetTab()
    vTabLevel = 0
End Function

''
Public Function IndentLine(SourceString As String) As String
    Static iloop As Long
    
    Call strings.Tokenise(SourceString, True)
    If (strings.NumTokens > -1) Then
        Select Case strings.Tokens(0)
            Case "Public", "Private", "Friend", "Property"
                Select Case strings.Tokens(1)
                    Case "Sub"
                        vTabLevel = 0
                    Case "Function"
                        vTabLevel = 0
                    Case "Type"
                        vTabLevel = 0
                    Case "Let", "Get"
                        vTabLevel = 0
                End Select
            Case "Case"
                vTabLevel = vTabLevel - 1
            Case "Next", "Loop", "Wend"
                vTabLevel = vTabLevel - 1
            Case "Else", "ElseIf"
                vTabLevel = vTabLevel - 1
            Case "End"
                Select Case strings.Tokens(1)
                    Case "Sub"
                        vTabLevel = 0
                    Case "Function"
                        vTabLevel = 0
                    Case "Property"
                        vTabLevel = 0
                    Case "Select"
                        vTabLevel = vTabLevel - 2
                    Case "If", "With"
                        vTabLevel = vTabLevel - 1
                End Select
        End Select
        
        IndentLine = Tabs(vTabLevel) & SourceString
        Select Case strings.Tokens(0)
            Case "Public", "Private", "Friend", "Property"
                Select Case strings.Tokens(1)
                    Case "Sub"
                        vTabLevel = vTabLevel + 1
                    Case "Function"
                        vTabLevel = vTabLevel + 1
                    Case "Type"
                        vTabLevel = vTabLevel + 1
                    Case "Let", "Get"
                        vTabLevel = vTabLevel + 1
                End Select
            Case "If", "ElseIf"
                ' Quick check for if nnnn then xxxx - style statement
                For iloop = 0 To strings.NumTokens
                    If (strings.Tokens(iloop) = "Then" And strings.NumTokens > iloop And (Left(strings.Tokens(iloop + 1), 1) <> "'" Or Left$(strings.Tokens(iloop + 1), 1) <> "'")) Then
                        Exit Function
                    End If
                Next
                vTabLevel = vTabLevel + 1
            Case "Select"
                vTabLevel = vTabLevel + 2
            Case "Else", "Case", "While", "With"
                vTabLevel = vTabLevel + 1
            Case "For"
                For iloop = 0 To strings.NumTokens
                    If (strings.Tokens(iloop) = "Next") Then
                        Exit Function
                    End If
                Next
                vTabLevel = vTabLevel + 1
                
            Case "Do"
                If (strings.NumTokens > 1 And Left$(strings.Tokens(1), 1) = "While") Then
                    vTabLevel = vTabLevel + 1
                Else
                    vTabLevel = vTabLevel + 1
                End If
                '        Case "End"
                '            Select Case LineTokens(1)
                '                Case "If", "Select"
                '                    TabLevel = TabLevel - 1
                '                Case "Function", "Sub"
                '                    TabLevel = 0
                '            End Select
        End Select
        
        If (vTabLevel < 0) Then
            vTabLevel = 0
        End If
    Else
        IndentLine = Tabs(vTabLevel) & SourceString
    End If
End Function

''
Public Function GetProcedureStart(CurrentLine As Long, ByRef ProcedureName As String) As Long
    Static iloop As Long
    For iloop = CurrentLine To vCurrentTarget.NumberOfLines - 1
        If (Left$(Trim$(vCurrentTarget.Lines(iloop)), 1) <> "'") Then
            If (InStr(vCurrentTarget.Lines(iloop), "(") > 0 And InStr(vCurrentTarget.Lines(iloop), ")") > 0) Then
                If (InStr(vCurrentTarget.Lines(iloop), "Function ") > 0) Then
                    ProcedureName = Right$(vCurrentTarget.Lines(iloop), Len(vCurrentTarget.Lines(iloop)) - InStr(vCurrentTarget.Lines(iloop), "Function") - 8)
                    GetProcedureStart = iloop
                    Exit For
                End If
                If (InStr(vCurrentTarget.Lines(iloop), "Sub ") > 0) Then
                    ProcedureName = Right$(vCurrentTarget.Lines(iloop), Len(vCurrentTarget.Lines(iloop)) - InStr(vCurrentTarget.Lines(iloop), "Sub") - 3)
                    GetProcedureStart = iloop
                    Exit For
                End If
                If (InStr(vCurrentTarget.Lines(iloop), "Property ") > 0) Then
                    ProcedureName = Right$(vCurrentTarget.Lines(iloop), Len(vCurrentTarget.Lines(iloop)) - InStr(vCurrentTarget.Lines(iloop), "Property") - 8)
                    GetProcedureStart = iloop
                    Exit For
                End If
                
            End If
        End If
    Next
    GetProcedureStart = iloop
End Function

''
Public Function GetProcedureEnd(CurrentLine As Long) As Long
    Static iloop As Long
    GetProcedureEnd = vCurrentTarget.NumberOfLines
    For iloop = CurrentLine To vCurrentTarget.NumberOfLines
        If (Left$(Trim$(vCurrentTarget.Lines(iloop)), 1) <> "'") Then
            If (Left(vCurrentTarget.Lines(iloop), 12) = "End Function") Then
                GetProcedureEnd = iloop + 1
                Exit For
            End If
            If (Left(vCurrentTarget.Lines(iloop), 7) = "End Sub") Then
                GetProcedureEnd = iloop + 1
                Exit For
            End If
            If (Left(vCurrentTarget.Lines(iloop), 12) = "End Property") Then
                GetProcedureEnd = iloop + 1
                Exit For
            End If
        End If
    Next
    ' If beyond last line (if last line is a "End Sub" or "End Function"
    If (GetProcedureEnd > vCurrentTarget.NumberOfLines) Then
        GetProcedureEnd = vCurrentTarget.NumberOfLines
    End If
End Function

