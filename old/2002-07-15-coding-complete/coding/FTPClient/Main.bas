Attribute VB_Name = "Main"
Option Explicit

Public Enum FTPServerType
    L8 = 1
    Normal = 0
End Enum

Public Enum RecieveMode
    file = 0
    Dir = 1
    ModeUploadFile = 2
End Enum

Public Sub ProcessEvent(pName As String)
'    Call Winsock1.SendData(pName & vbCrLf)
    Call FRMRelayServer.SendReply(pName)
End Sub
