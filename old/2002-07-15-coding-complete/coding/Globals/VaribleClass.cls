VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VaribleClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

'' Uses - Error

Const cMinArrayIndex = 0                '' Starting index when loading arrays

Private Type VaribleType
    value As Variant
    Name As String
End Type

Private Type ArrayType
    value() As Variant
    Name As String
    NumDimensions As Long       ' Number of dimensions in array
    Dim1 As Long                ' First dimension
    Dim2 As Long
    Dim3 As Long
    Dim4 As Long
End Type

Private Arrays(100) As ArrayType        '' Store for arrays
Private NumArrays As Long               '' Current number of arrays

Private Varibles(100) As VaribleType    '' Store for varibles
Private NumVaribles As Long             '' Current number of varibles

'' Find a varible currently stored or return -1
Private Function FindVarible(pName As String) As Long
    Dim I As Long
    
    FindVarible = -1
    Do While (I < NumVaribles And FindVarible = -1)
        If (UCase$(Varibles(I).Name) = UCase$(pName)) Then
            FindVarible = I
        End If
        I = I + 1
    Loop
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'' Set an element in an array
Public Function SetArray(pName As String, pNumDimensions As Long, pValue As Variant, pDimension1 As Long, Optional pDimension2 As Long, Optional pDimension3 As Long, Optional pDimension4 As Long) As Boolean
    Dim I As Long
    Dim Found As Boolean
    
    Found = False
    I = 0
    Do While (I < NumArrays And Found = False)
        If (UCase$(Arrays(I).Name) = UCase$(pName)) Then
            Found = True
        End If
        I = I + 1
    Loop
    
    If (Found = True) Then
        I = I - 1
        Select Case pNumDimensions
            Case 1
                Arrays(I).value(pDimension1) = pValue
            Case 2
                Arrays(I).value(pDimension1, pDimension2) = pValue
            Case 3
                Arrays(I).value(pDimension1, pDimension2, pDimension3) = pValue
            Case 4
                Arrays(I).value(pDimension1, pDimension2, pDimension3, pDimension4) = pValue
            Case Else
                Call Error.DoError("ERROR: Incorrect dimensions")
        End Select
    End If
    SetArray = Found
End Function

'' same as add
Public Function SetVarible(pName As String, pValue As Variant) As Boolean
    Dim I As Long
    ' DEBUG - Check type error
'    If (Right$(pName, 1) <> "$" And IsNumeric(pValue) = False) Then
'        i = i
'    End If
    
    ' Check for array
    If (InStr(pName, "(")) Then
        
    Else
        SetVarible = True
        
        ' Check if varible allready exists
        I = FindVarible(pName)
        If (I <> -1) Then
            Varibles(I).value = pValue
        Else
'            Call error.doerror("ERROR: Undefined varible")
            ' if varible not found then create
            Call AddVarible(pName, pValue)
        End If
    End If
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Check for varibles

'' Return contence of a defined varible
Public Function GetVarible(param As String, ByRef Success As Boolean) As Variant
    Dim I As Long
    
    I = FindVarible(param)
    If (I <> -1) Then
        GetVarible = Varibles(I).value
        Success = True
    Else
        Call Error.DoError("ERROR: Undefined varible : " & param)
        ' If not found then create
        Call AddVarible(param, 0)
        Success = False
    End If
End Function

'' Only bounds checking on first dimension
Public Function GetArray(pName As String, pNumDimensions As Long, ByRef pSuccess As Boolean, pDimension1 As Long, Optional pDimension2 As Long, Optional pDimension3 As Long, Optional pDimension4 As Long) As Variant
    Dim I As Long

    pSuccess = False
    For I = 0 To NumArrays - 1
        If (UCase$(Arrays(I).Name) = UCase$(pName)) Then
            If (Arrays(I).NumDimensions <> pNumDimensions) Then
                Call Error.DoError("ERROR: Incorrect dimensions")
            Else
                If (pDimension1 > Arrays(I).Dim1 Or pDimension1 < 0) Then
                    Call Error.DoError("ERROR: Dimension1 overflow in array - " & pName)
                Else
                    Select Case pNumDimensions
                        Case 1
                            GetArray = Arrays(I).value(pDimension1)
                        Case 2
                            GetArray = Arrays(I).value(pDimension1, pDimension2)
                        Case 3
                            GetArray = Arrays(I).value(pDimension1, pDimension2, pDimension3)
                        Case 4
                            GetArray = Arrays(I).value(pDimension1, pDimension2, pDimension3, pDimension4)
                        Case Else
                            Call Error.DoError("ERROR: in getarray")
                    End Select
                    pSuccess = True
                    Exit Function
                End If
            End If
        End If
    Next
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Add functions


'' Add Array !
Public Sub AddArray(pName As String, pNumDimensions As Long, pDimension1 As Long, Optional pDimension2 As Long, Optional pDimension3 As Long, Optional pDimension4 As Long)
    Dim I As Long, T As Long, x As Long, y As Long
    Arrays(NumArrays).Name = UCase$(pName)
    Arrays(NumArrays).NumDimensions = pNumDimensions
    Arrays(NumArrays).Dim1 = pDimension1
    
    'init array
    Select Case pNumDimensions
        Case 1
            ReDim Arrays(NumArrays).value(pDimension1)
            For I = 0 To pDimension1
                Arrays(NumArrays).value(I) = 0
            Next
        Case 2
            Arrays(NumArrays).Dim2 = pDimension2
            ReDim Arrays(NumArrays).value(pDimension1, pDimension2)
            For I = 0 To pDimension1
                For T = 0 To pDimension2
                    Arrays(NumArrays).value(I, T) = 0
                Next
            Next
        Case 3
            Arrays(NumArrays).Dim2 = pDimension2
            Arrays(NumArrays).Dim3 = pDimension3
            ReDim Arrays(NumArrays).value(pDimension1, pDimension2, pDimension3)
            For I = 0 To pDimension1
                For T = 0 To pDimension2
                    For x = 0 To pDimension3
                        Arrays(NumArrays).value(I, T, x) = 0
                    Next
                Next
            Next
        Case 4
            Arrays(NumArrays).Dim2 = pDimension2
            Arrays(NumArrays).Dim3 = pDimension3
            Arrays(NumArrays).Dim4 = pDimension4
            ReDim Arrays(NumArrays).value(pDimension1, pDimension2, pDimension3, pDimension4)
            For I = 0 To pDimension1
                For T = 0 To pDimension2
                    For x = 0 To pDimension3
                        For y = 0 To pDimension4
                            Arrays(NumArrays).value(I, T, x, y) = 0
                        Next
                    Next
                Next
            Next
        Case Else
            MsgBox ("ERROR: Unable to create array")
    End Select
    NumArrays = NumArrays + 1
End Sub

'' Add varible !
Public Function AddVarible(pName As String, pValue As Variant)
    Dim I As Long
    Dim Tempdouble As Double
    Dim tempstring As String
    

    ' Check if varible allready exists
    I = FindVarible(pName)
    If (I <> -1) Then
        Varibles(I).value = pValue
    Else
        ' If not found then create
        Varibles(NumVaribles).Name = UCase$(pName)
        If (Right$(pName, 1) = "$") Then
            tempstring = pValue
            Varibles(NumVaribles).value = tempstring
        Else
            Tempdouble = pValue
            Varibles(NumVaribles).value = Tempdouble
        End If
        NumVaribles = NumVaribles + 1
    End If
    AddVarible = True
End Function

'' Reset number of Varibles, arrays defined
Public Sub Reset()
    NumVaribles = 0
    NumArrays = 0
End Sub

'' Display all varibles, arrays to a listbox
Public Sub PrintVaribles(LstBox As ListBox)
    Dim I As Long
    Call LstBox.Clear
    For I = 0 To NumVaribles - 1
        Call LstBox.AddItem(Varibles(I).Name & vbTab & Varibles(I).value)
    Next
    For I = 0 To NumArrays - 1
        Call LstBox.AddItem(Arrays(I).Name & "()" & vbTab)
    Next
End Sub

'' Read values from 1-dimension array into new array
Public Sub InitArray(Name As String, values() As Double, numvalues As Long)
    On Error GoTo Error
    Dim ArrayIndex As Long
    Dim Found As Boolean
    Dim I As Long
    Dim Dimension1 As Long, Dimension2 As Long, Dimension3 As Long, Dimension4 As Long
    
    Found = False
    ArrayIndex = 0
    Do While (ArrayIndex < NumArrays And Found = False)
        If (UCase$(Arrays(ArrayIndex).Name) = UCase$(Name)) Then
            Found = True
        End If
        ArrayIndex = ArrayIndex + 1
    Loop
    
    If (Found = True) Then
        ArrayIndex = ArrayIndex - 1
        Dimension1 = cMinArrayIndex
        Dimension2 = cMinArrayIndex
        Dimension3 = cMinArrayIndex
        Dimension4 = cMinArrayIndex
        For I = 0 To numvalues - 1
            Select Case Arrays(ArrayIndex).NumDimensions
                Case 1
                    Arrays(ArrayIndex).value(Dimension1) = values(I)
                    Dimension1 = Dimension1 + 1
               Case 2
                    Arrays(ArrayIndex).value(Dimension1, Dimension2) = values(I)
                    Dimension2 = Dimension2 + 1
                    If (Dimension2 > Arrays(ArrayIndex).Dim2) Then
                        Dimension1 = Dimension1 + 1
                        Dimension2 = cMinArrayIndex
                    End If
                Case 3
                    Arrays(ArrayIndex).value(Dimension1, Dimension2, Dimension3) = values(I)
                    Dimension3 = Dimension3 + 1
                   If (Dimension3 > Arrays(ArrayIndex).Dim3) Then
                        Dimension2 = Dimension2 + 1
                        Dimension3 = cMinArrayIndex
                        If (Dimension2 > Arrays(ArrayIndex).Dim2) Then
                            Dimension1 = Dimension1 + 1
                            Dimension2 = cMinArrayIndex
                        End If
                    End If
                Case 4
                    Arrays(ArrayIndex).value(Dimension1, Dimension2, Dimension3, Dimension4) = values(I)
                    Dimension4 = Dimension4 + 1
                   If (Dimension4 > Arrays(ArrayIndex).Dim4) Then
                        Dimension3 = Dimension3 + 1
                        Dimension4 = cMinArrayIndex
                        If (Dimension3 > Arrays(ArrayIndex).Dim3) Then
                            Dimension2 = Dimension2 + 1
                            Dimension3 = cMinArrayIndex
                            If (Dimension2 > Arrays(ArrayIndex).Dim2) Then
                               Dimension1 = Dimension1 + 1
                                Dimension2 = cMinArrayIndex
                            End If
                        End If
                    End If
                Case Else
                    Call Error.DoError("ERROR: Incorrect dimensions")
            End Select
        Next
    Else
        Call Error.DoError("ERROR: Unable to find array :" & Name)
    End If
    'InitArray = Found
    Exit Sub
Error:
    If (Err.Number = 9) Then
        Call Error.DoError("ERROR: Incorrect number of elements in DATA statement")
        Resume Next
    Else
    End If
End Sub


