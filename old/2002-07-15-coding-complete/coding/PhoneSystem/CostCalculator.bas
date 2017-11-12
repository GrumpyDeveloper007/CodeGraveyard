Attribute VB_Name = "CostCalculator"
Option Explicit

Public Type AreaCodeTYPE
    NationalNumberCode As String '1. The national number group (NNG) code
    ReplacementNationNumberCode As String '2. A replacement NNG code, where the code in (1) is not correct.
    CodeStatus As String '3. The status of the code (e.g. is it valid, was it changed on Phoneday?)
    BTChargeRate As String '4. The BT charge rate for calls to numbers in that group
    OSGridLocation As String '5. The approximate OS grid location, where applicable
    LatitudeLongitude As String '6. The approximate latitude and longitude, where applicable
    PlaceName As String '7. A text description, often a place name.
    DigitsInAreaCode As Long '8. Digits in Area Code
    See As String '9. See also NNG code
    Operator As String '10. Operator
    ChargingArea As String '11. Charging Area
    DigitsInFullNumber As Long '12. Digits in full number
    Notes As String '13. Notes
End Type

Private CodeList() As AreaCodeTYPE
Private NumCodeList As Long

''
Public Function ReadDataFile()
    Dim StringC As New stringclass
    Dim TempString As String
    Dim i As Long
    
    ReDim CodeList(1000) As AreaCodeTYPE
    NumCodeList = 1000
    i = 0
    Dim fs As New Scripting.FileSystemObject
    Dim ts As Scripting.TextStream
    
    Set ts = fs.OpenTextFile("d:\phonedetails\nng_list.csv", ForReading, False, TristateUseDefault)
    
    
    Do While (ts.AtEndOfStream = False)
        
        TempString = ts.ReadLine
        Call StringC.Tokenise(TempString, False)
        
        If (i > UBound(CodeList, 1)) Then
            ReDim Preserve CodeList(i + 500) As AreaCodeTYPE
        End If
        
        
        
        CodeList(i).NationalNumberCode = StringC.TokensProcess(0)
        CodeList(i).ReplacementNationNumberCode = StringC.TokensProcess(1)
        CodeList(i).CodeStatus = StringC.TokensProcess(2)
        CodeList(i).BTChargeRate = StringC.TokensProcess(3)
        CodeList(i).OSGridLocation = StringC.TokensProcess(4)
        CodeList(i).LatitudeLongitude = StringC.TokensProcess(5)
        CodeList(i).PlaceName = StringC.TokensProcess(6)
        CodeList(i).DigitsInAreaCode = Val(StringC.TokensProcess(7))
        CodeList(i).See = StringC.TokensProcess(8)
        CodeList(i).Operator = StringC.TokensProcess(9)
        CodeList(i).ChargingArea = StringC.TokensProcess(10)
        CodeList(i).DigitsInFullNumber = Val(StringC.TokensProcess(11))
        CodeList(i).Notes = StringC.Tokens(12)
        i = i + 1
       ' StringC.NumTokens
    Loop
    NumCodeList = i
    ts.Close
'    Close #FileID
End Function

''
Public Function FindArea(pArea As String) As AreaCodeTYPE
    Dim i As Long
    FindArea.NationalNumberCode = ""
    If (Left$(pArea, 1) = "0") Then
        pArea = Right(pArea, Len(pArea) - 1)
    End If
    For i = 0 To NumCodeList - 1
        If (Left$(pArea, Len(CodeList(i).NationalNumberCode)) = CodeList(i).NationalNumberCode) Then
            FindArea = CodeList(i)
            Exit For
        End If
    Next
End Function



