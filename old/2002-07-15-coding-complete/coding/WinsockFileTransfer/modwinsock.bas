Attribute VB_Name = "modwinsock"
Option Explicit
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Sub SendFile(FileName As String, WinS As Winsock)
Dim FreeF As Integer
Dim LocData() As Byte
Dim LenData As Long
Dim sendloop As Long

FreeF = FreeFile

Open FileName For Binary As #FreeF ' Open file

ReDim LocData(1 To 2048) As Byte ' Work in 2kb chunks

LenData = LOF(FreeF) ' Get length of file

For sendloop = 1 To LenData \ 2048 ' Go through file

  Get #FreeF, , LocData 'Get data from the file nCnt is from where to start the get

  WinS.SendData LocData 'Send the chunk

Next

If LenData Mod 2048 <> 0 Then ' If there is any left over at the end
  
  ReDim LocData(1 To LenData Mod 2048) As Byte ' Clear up the leftovers
  
  Get #FreeF, , LocData 'Get data from the file nCnt is from where to start the get

  WinS.SendData LocData 'Send the chunk
  
End If

Close #FreeF ' Close the file

Sleep 200 ' Let computer catch up

End Sub


Public Function oPD(Text As String) As String
'Use this if you get your data in Binary into any textbox
'this turns all the chunk into the Ascii numbers use the rpd
'function to restore it.
'If you open binary into a text box the chances that you'll get
'an Out Of Memory error are high.

Dim TextC As String * 3
Dim G As Long
Dim TextX  As String
Dim x As Long

G = Len(Text)

For x = 1 To G
  TextC = Asc(Mid(Text, x, 1))
  TextX = TextX & TextC
Next x
oPD = TextX
End Function

Public Function rPD(Text As String) As String
Dim TextC As String * 3
Dim G As Long
Dim TextX  As String
Dim x As Long

G = Len(Text)

For x = 1 To G
  On Local Error Resume Next
  TextC = Chr(Mid(Text, x, 3))
  TextX = TextX & TextC
Next x
rPD = TextX
End Function


