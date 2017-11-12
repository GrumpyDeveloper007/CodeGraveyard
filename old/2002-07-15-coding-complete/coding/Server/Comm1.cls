VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Comm1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True


Public Function CheckQuit() As Long
    If (Quit = 1) Then
        CheckQuit = 1
    Else
        CheckQuit = 0
    End If
End Function
    
Public Sub ResetQuit()
    Quit = 0
End Sub

Public Sub SetQuit()
    Quit = 1
End Sub

Public Sub ResetA()
    ValA = 0
End Sub

Public Sub ResetB()
    ValB = 0
End Sub

Public Function GetA() As Long
    GetA = ValA
End Function

Public Function GetB() As Long
    GetB = ValB
End Function

Public Sub IncA()
    ValA = ValA + 1
End Sub

Public Sub IncB()
    ValB = ValB + 1
End Sub


Public Function SetStaticA(pVal As Long) As Long
'    Static ValA As Long
    If (pVal <> 0) Then
        ValA = pVal
    End If
    SetStaticA = ValA
End Function

Public Function SetStaticB(pVal As Long) As Long
'    Static ValB As Long
    If (pVal <> 0) Then
        ValB = pVal
    End If
    SetStaticB = ValB
End Function

Private Sub Class_Initialize()
    Call SetStaticA(-1)
    Call SetStaticB(-1)
End Sub

Public Sub ClientExecute(Command As String)
    Call Shell(Command)
End Sub

Public Sub SetMousePos(Xpos As Long, Ypos As Long)
    Call SetCursorPos(Xpos, Ypos)
End Sub

Public Sub LeftClick()
    Call mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    Call mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
End Sub
