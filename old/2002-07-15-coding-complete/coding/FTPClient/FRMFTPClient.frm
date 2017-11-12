VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form FRMFTPClient 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "FtpClient"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TXTPath 
      Height          =   315
      Left            =   2400
      TabIndex        =   9
      Text            =   "/"
      Top             =   0
      Width           =   1455
   End
   Begin VB.CheckBox CHKEnableLog 
      Caption         =   "Enable Log"
      Height          =   255
      Left            =   2520
      TabIndex        =   8
      Top             =   1440
      Width           =   1215
   End
   Begin VB.TextBox TXTBytes 
      Height          =   315
      Left            =   0
      TabIndex        =   7
      Top             =   2400
      Width           =   1575
   End
   Begin VB.TextBox TXTSpeed 
      Height          =   315
      Left            =   1680
      TabIndex        =   6
      Top             =   2400
      Width           =   855
   End
   Begin VB.TextBox TXTFailedCount 
      Height          =   345
      Left            =   3960
      TabIndex        =   3
      Top             =   0
      Width           =   615
   End
   Begin VB.TextBox TXTPort 
      Height          =   315
      Left            =   1800
      TabIndex        =   2
      Text            =   "21"
      Top             =   0
      Width           =   495
   End
   Begin VB.ComboBox CBOIP 
      Height          =   315
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   1695
   End
   Begin VB.TextBox TXTLog 
      Height          =   1875
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   480
      Visible         =   0   'False
      Width           =   2415
   End
   Begin MSWinsockLib.Winsock Winsock2 
      Left            =   4080
      Top             =   1740
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   3600
      Top             =   1740
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label LBLStatus 
      Caption         =   "Port 1 Status"
      Height          =   255
      Left            =   2520
      TabIndex        =   5
      Top             =   540
      Width           =   1935
   End
   Begin VB.Label LBLStatus2 
      Caption         =   "Port 2 Status"
      Height          =   255
      Left            =   2520
      TabIndex        =   4
      Top             =   1020
      Width           =   1935
   End
End
Attribute VB_Name = "FRMFTPClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'211.57.222.94

Private vDataReady As Boolean
Private vDirComplete As Boolean
Private vCWDOK As Boolean
Private vFailedCount As Long
Private vUniqueCounter As Long
Private vRecieveMode As RecieveMode

Private vServerType As FTPServerType
Private vStartTime As Date

Private vDownloadFileID As Long
Private vUploadFileID As Long
Private vFileProgress As Long

Private vNumber As Long

Private vDirBuffer  As String

Public Sub ProcessCommand()

End Sub

Public Sub SetNumber(pNumber As Long)
    vNumber = pNumber
End Sub

Public Sub SetIP(pNumber As String)
    CBOIP.Text = pNumber
End Sub

Public Sub SetPort(pNumber As Long)
    TXTPort.Text = pNumber
End Sub

Public Sub Connect()
    Call Winsock1.Close
    Call Winsock1.Connect(CBOIP.Text, TXTPort.Text)
    
    Do While (Winsock1.State <> sckConnected)
        DoEvents
    Loop
    Call ExecuteCommand("USER anonymous")
    Call ExecuteCommand("PASS ddd@d.com")
    Call ExecuteCommand("SYST")

End Sub

Public Sub DisConnect()
    Winsock1.Close
    Winsock2.Close
End Sub

Public Sub List(pPath As String)
    Call ListDir(pPath)
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Sub LogEvent(pName As String)

    If (CHKEnableLog.Value = vbChecked) Then
        TXTLog.Text = TXTLog.Text & pName & vbCrLf
        If (Len(TXTLog.Text) > 0) Then
            TXTLog.SelStart = Len(TXTLog.Text)
        End If
        If (Len(TXTLog.Text) > 65000) Then
            TXTLog.Text = ""
        End If
    End If
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub ExecuteCommand(pCommand As String)
    Static linenumnber As Long
    vDataReady = False
    Call LogEvent(pCommand)
    
    Call Winsock1.SendData(pCommand & vbCrLf)
    Do While (vDataReady = False)
        DoEvents
'        Call Winsock1.SendData("ABOR" & vbCrLf)
    Loop
    linenumnber = linenumnber + 1
    If (linenumnber > 10000) Then
        linenumnber = 0
        TXTLog.Text = ""
    End If
End Sub

Private Sub ListDir(pPath As String)
    vRecieveMode = Dir
    vDirComplete = False
    vCWDOK = True
    vDirBuffer = ""
    Call ExecuteCommand("CWD " & pPath)
    If (vCWDOK = True) Then
'        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
'        Else
'            Call Winsock2.Listen
'            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
'        End If
        Call ExecuteCommand("LIST -al") '-al-alF
        
        Do While (vDirComplete = False)
            DoEvents
        Loop
        DoEvents
        Call Winsock2.Close
    End If
End Sub

Public Sub UploadFile(pPath As String, pFileName As String)
    Call ExecuteCommand("Type I")
    Call ExecuteCommand("CWD " & pPath)
    vRecieveMode = ModeUploadFile
    vUploadFileID = FreeFile
    vCWDOK = True
    Open pFileName For Binary As #vUploadFileID
    
    If (vCWDOK = True) Then
'        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
'        Else
'            Call Winsock2.Listen
'            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
'        End If
        Call ExecuteCommand("STOR " & pFileName)
    End If
End Sub


Public Sub DownloadFile(pPath As String, pFileName As String)
    Dim FilePos As Long
    vStartTime = Now
    vRecieveMode = file
    vDirComplete = False
    vCWDOK = True
    Call ExecuteCommand("Type I")
    Call ExecuteCommand("CWD " & pPath)
    vDownloadFileID = FreeFile
    Open pFileName For Binary As #vDownloadFileID
'    If (LOF(vDownloadFileID) > 0) Then
'        FilePos = LOF(vDownloadFileID) - LOF(vDownloadFileID) Mod 4096
'        Seek #vDownloadFileID, FilePos
'        Call ExecuteCommand("REST " & FilePos)
'    End If
    
    If (vCWDOK = True) Then
'        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
'        Else
'            Call Winsock2.Listen
'            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
'        End If
        Call ExecuteCommand("RETR " & pFileName) '-al-alF
        
        DoEvents
'        Call Winsock2.Close
'        Close #vDownloadFileID
    End If
End Sub

Private Sub ProcessFile()
    Dim tempstring As String
    Dim temparray() As Byte
    Dim i As Long
    
    TXTSpeed.Text = (Winsock2.BytesReceived / DateDiff("s", vStartTime, Now)) / 1024 & "KB" '
    If (LOF(vDownloadFileID) > 1024 * 10) Then
        TXTBytes.Text = Format((LOF(vDownloadFileID)) / 1024, "#############0") & "KB" '
    Else
        TXTBytes.Text = Format((LOF(vDownloadFileID)), "#############0") & "B"  '
    End If
    vFileProgress = LOF(vDownloadFileID)
    Call Winsock2.PeekData(tempstring, vbString)
    Do While (tempstring <> "")
        
        Call Winsock2.GetData(temparray, vbByte + vbArray, 512)
        
        For i = 0 To UBound(temparray)
            Put #vDownloadFileID, , temparray(i)
        Next
        Call Winsock2.PeekData(tempstring, vbString)
    Loop
End Sub

Private Sub ProcessDir()
    Dim tempstring As String
    Dim foldername As String
    Dim outstring As String
    Dim outstring2 As String
    Dim TypeName As String
    Dim PrcoessFolder As Boolean
    Dim FileSize As Long
'"06-19-02  12:31PM       <DIR>          "
    
    tempstring = vDirBuffer
    Do While (tempstring <> "")
        TypeName = Mid$(tempstring, Len("06-19-02  12:31PM        "), 5)
        
        PrcoessFolder = False
        If (vServerType = L8) Then
            'if l8
            If (Left$(tempstring, 1) = "d") Then
                foldername = Mid$(tempstring, Len("drwxr-xr-x  3 1004  operator  512 Jun 25 13:12  "))
                PrcoessFolder = True
            End If
        Else
            If (Left$(TypeName, 5) = "<DIR>") Then
                foldername = Mid$(tempstring, Len("06-19-02  12:31PM       <DIR>           "))
                PrcoessFolder = True
            End If
            If (Left$(tempstring, 1) = "d") Then
                
                foldername = Mid$(tempstring, Len("d---------   1 owner    group               0 May 31 18:00  "))
                PrcoessFolder = True
            End If
        End If
        
        ' get files
        If (PrcoessFolder = False) Then
            foldername = Trim$(Left$(tempstring, InStr(tempstring, vbCrLf) - 1))
            FileSize = Val(Mid$(tempstring, Len("06-28-02  10:27AM            "), Len("          ")))
            
            Call ProcessEvent(vNumber & "-C-" & "(file)" & Trim$(Mid$(foldername, InStrRev(foldername, " "))) & "," & FileSize & vbCrLf)
        End If
        
        If (InStr(foldername, vbCrLf) > 0) Then
            foldername = Left$(foldername, InStr(foldername, vbCrLf) - 1)
        End If
        
        ' ignore dot folders
        If (Trim$(UCase$(foldername)) = "." Or Trim$(UCase$(foldername)) = "..") Then
            PrcoessFolder = False
        End If
        If (vServerType = L8) Then
            If (InStr(foldername, "ÿ") > 0) Then
                foldername = Replace(foldername, "ÿ", "ÿÿ")
            End If
        End If
        
        If (PrcoessFolder = True) Then
            Call ProcessEvent(vNumber & "-C-" & "(Folder)" & TXTPath.Text & foldername & "/" & vbCrLf)
        End If
        '
        If (InStr(tempstring, vbCrLf) > 0) Then
            tempstring = Mid$(tempstring, InStr(tempstring, vbCrLf) + 2)
        Else
            tempstring = ""
        End If
    Loop
    '
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub Form_Load()

End Sub

Private Sub Winsock1_Connect()
    LBLStatus.Caption = "Connect"
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    Dim tempstring As String
    Dim IP As String
    Dim port As String
    Dim portleft As String
    Dim portlong As Long
    
    Dim feedback As String
    Call Winsock1.GetData(tempstring, vbString)
    
    feedback = Left$(tempstring, Len(tempstring) - 2)
    feedback = Replace(feedback, vbCrLf, vbCrLf & vNumber & "-S-")
    Call ProcessEvent(vNumber & "-S-" & feedback & vbCrLf)
    
    Call LogEvent(tempstring)
    LBLStatus.Caption = "Data Arrival"
    
    ' check commands
    
    'SYST
'215 UNIX Type: L8 Version: BSD-199506
    If (InStr(tempstring, "227") > 0) Then
        tempstring = tempstring
        IP = Mid$(tempstring, InStr(tempstring, "(") + 1)
        IP = Replace(IP, vbCrLf, "")
        IP = Left$(IP, Len(IP) - 1)
        port = Mid$(IP, InStrRev(IP, ",") + 1)
        IP = Left$(IP, InStrRev(IP, ",") - 1)
        portleft = Mid$(IP, InStrRev(IP, ",") + 1)
        
        IP = Left$(IP, InStrRev(IP, ",") - 1)
        
        IP = Replace(IP, ",", ".")
        portlong = Val(port) + Val(portleft * 256)
        '227 Entering Passive Mode (127,0,0,1,8,91)
        On Error Resume Next
        
        Call Winsock2.Connect(IP, portlong)
        If (vRecieveMode = ModeUploadFile) Then
            Do While (Winsock2.State <> 7)
                DoEvents
            Loop
        
            Dim DataBuffer(511) As Byte
            Get #vUploadFileID, , DataBuffer
            Call Winsock2.SendData(DataBuffer)
            TXTBytes.Text = Loc(vUploadFileID)
            DoEvents
        End If
        On Error GoTo 0
    End If
    If (InStr(tempstring, "226") > 0) Then
    '226 Transfer complete.
        If (vRecieveMode = file) Then
            Winsock2.Close
            Close #vDownloadFileID
        Else
        End If
        
        vDirComplete = True
    End If
    If (InStr(tempstring, "425") > 0) Then
        vDirComplete = True
    End If
    
    If (InStr(tempstring, "215") > 0) Then
        If (InStr(tempstring, "UNIX Type: L8 Version") > 0) Then
            vServerType = L8
        Else
            vServerType = Normal
        End If
    End If
    If (InStr(tempstring, "550") > 0) Then
        vCWDOK = False
    End If
    vDataReady = True
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    LBLStatus.Caption = "ERROR " & Description
End Sub

Private Sub Winsock2_ConnectionRequest(ByVal requestID As Long)
  ' Close the connection if it is currently open
   ' by testing the State property.
   If Winsock2.State <> sckClosed Then Winsock2.Close

   ' Pass the value of the requestID parameter to the
   ' Accept method.
   Call Winsock2.Accept(requestID)
End Sub

Private Sub Winsock2_DataArrival(ByVal bytesTotal As Long)
    Dim tempstring As String
    Dim tempstring2 As String
    LBLStatus2.Caption = "Data Arrival"
    On Error GoTo failed
    
    If (vRecieveMode = Dir) Then
        Call Winsock2.PeekData(tempstring2, vbString)
        Do While (tempstring2 <> "")
            Call Winsock2.GetData(tempstring, vbString)
            vDirBuffer = vDirBuffer & tempstring
            Call ProcessDir
            Call Winsock2.PeekData(tempstring2, vbString)
        Loop
    Else
        Call ProcessFile
    End If
    Exit Sub
failed:
    TXTFailedCount.Text = Val(TXTFailedCount.Text) + 1
End Sub

Private Sub Winsock2_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    LBLStatus2.Caption = "ERROR " & Description
End Sub


Private Sub Winsock2_SendComplete()
    Dim DataBuffer(511) As Byte
    If (EOF(vUploadFileID) = False) Then
        Get #vUploadFileID, , DataBuffer
        Call Winsock2.SendData(DataBuffer)
        TXTBytes.Text = Loc(vUploadFileID)
    Else
        ' complete
        Call Winsock2.Close
    End If
End Sub

