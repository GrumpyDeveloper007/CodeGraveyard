Attribute VB_Name = "Module1"
Option Explicit

'' Binary AND operation, used by classes in search function
Public Function BAnd(pValue1 As Long, pvalue2 As Long) As Long
    BAnd = (pValue1 And pvalue2)
End Function


Public Sub LongToByte(pNumber As Long, pdatabyte() As Byte, pIndex As Long)
    pdatabyte(pIndex) = BAnd(pNumber \ 16777216, 255)
    pdatabyte(pIndex + 1) = BAnd(pNumber \ 65536, 255)
    pdatabyte(pIndex + 2) = BAnd(pNumber \ 256, 255)
    pdatabyte(pIndex + 3) = BAnd(pNumber, 255)
End Sub


Public Function ByteToLong(pdatabyte() As Byte, pIndex As Long) As Long
    Dim templong As Long
    templong = pdatabyte(pIndex + 2)
    ByteToLong = pdatabyte(pIndex) * 16777216
    ByteToLong = ByteToLong + pdatabyte(pIndex + 1) * 65536
    ByteToLong = ByteToLong + templong * 256
    ByteToLong = ByteToLong + pdatabyte(pIndex + 3)
End Function

Public Function ByteToString(pdatabyte() As Byte, pIndex As Long, pLength As Long) As String
    Dim i As Long
    For i = pIndex To pIndex + pLength - 1
        If (pdatabyte(i) <> 0) Then
            ByteToString = ByteToString & Chr$(pdatabyte(i))
        Else
            Exit For
        End If
    Next
End Function

Public Sub StringToByte(pdatabyte() As Byte, pIndex As Long, pLength As Long, pString As String)
    Dim i As Long
    Dim MaxLength As Long
    For i = 1 To pLength
        If (Len(pString) > i) Then
            pdatabyte(i - 1) = Asc(Mid$(pString, i, 1))
        Else
            pdatabyte(i - 1) = 0
        End If
    Next
End Sub

