VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form Form1 
   Caption         =   "INetFTP functions sample by Matt Hart - vbhelp@matthart.com"
   ClientHeight    =   7725
   ClientLeft      =   1650
   ClientTop       =   1545
   ClientWidth     =   10050
   LinkTopic       =   "Form1"
   ScaleHeight     =   7725
   ScaleWidth      =   10050
   Begin VB.TextBox txt 
      Height          =   285
      Index           =   0
      Left            =   1380
      TabIndex        =   1
      Text            =   "ftp://DarkElf:Meon@62.254.14.102:22"
      Top             =   60
      Width           =   5355
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   9120
      Top             =   240
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   615
      Left            =   7680
      TabIndex        =   18
      Top             =   360
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   4335
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   16
      Text            =   "frmInetFTP.frx":0000
      Top             =   3240
      Width           =   8415
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   375
      Left            =   120
      TabIndex        =   15
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "C&ancel"
      Height          =   375
      Left            =   60
      TabIndex        =   8
      Top             =   2100
      Width           =   1215
   End
   Begin VB.CommandButton cmdRefresh 
      Caption         =   "&Refresh"
      Height          =   375
      Left            =   60
      TabIndex        =   7
      Top             =   1620
      Width           =   1215
   End
   Begin VB.CommandButton cmdQuit 
      Caption         =   "&Quit"
      Height          =   375
      Left            =   60
      TabIndex        =   9
      Top             =   2580
      Width           =   1215
   End
   Begin VB.ListBox lstData 
      Height          =   1035
      Left            =   1380
      MultiSelect     =   2  'Extended
      OLEDropMode     =   1  'Manual
      TabIndex        =   10
      Top             =   1920
      Width           =   5415
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "&Connect"
      Default         =   -1  'True
      Height          =   375
      Left            =   60
      TabIndex        =   6
      Top             =   1140
      Width           =   1215
   End
   Begin VB.TextBox txt 
      Height          =   285
      Index           =   2
      Left            =   1380
      TabIndex        =   5
      Text            =   "Meon"
      Top             =   660
      Width           =   5355
   End
   Begin VB.TextBox txt 
      Height          =   285
      Index           =   1
      Left            =   1380
      TabIndex        =   3
      Text            =   "DarkElf"
      Top             =   360
      Width           =   5355
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   360
      Top             =   3420
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      AccessType      =   1
      Protocol        =   4
      URL             =   "http://"
   End
   Begin VB.OLE OLE1 
      Height          =   1575
      Left            =   7440
      TabIndex        =   17
      Top             =   1200
      Width           =   1695
   End
   Begin VB.Label lblGET 
      Alignment       =   2  'Center
      Height          =   375
      Left            =   2580
      TabIndex        =   14
      Top             =   1500
      Width           =   4230
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   5700
      TabIndex        =   13
      Top             =   1200
      Width           =   1005
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      Caption         =   "Bytes Received:"
      Height          =   195
      Left            =   2880
      TabIndex        =   12
      Top             =   1200
      Width           =   2730
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Directory List"
      Height          =   195
      Index           =   3
      Left            =   1440
      TabIndex        =   11
      Top             =   1680
      Width           =   915
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Password:"
      Height          =   195
      Index           =   2
      Left            =   60
      TabIndex        =   4
      Top             =   720
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "Login Name:"
      Height          =   195
      Index           =   1
      Left            =   60
      TabIndex        =   2
      Top             =   420
      Width           =   1275
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      Caption         =   "FTP Site:"
      Height          =   195
      Index           =   0
      Left            =   60
      TabIndex        =   0
      Top             =   120
      Width           =   1275
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

' INetFTP sample by Matt Hart - vbhelp@matthart.com
' http://matthart.com
'
' This sample shows how to use many common FTP functions
' with the Microsoft Internet Transfer Control.

Private Declare Function GetShortPathName Lib "kernel32" Alias "GetShortPathNameA" (ByVal lpszLongPath As String, ByVal lpszShortPath As String, ByVal cchBuffer As Long) As Long
Private Const MAX_PATH = 260

Dim aCmd As String, aPath As String, lBytes As Long, lBuf As Long, aFile As String
Dim files(200) As String
Dim numfiles As Long
Dim filenumber As Long
Dim pause As Long

Private Sub GetData(adata As String)
    Dim vData As Variant
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        adata = adata & vData
        lblBR.Caption = CStr(Len(adata))
    Loop
End Sub

Private Function GetData2() As String
    Dim vData As Variant
    Dim adata As String
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        adata = adata & vData
    Loop
    GetData2 = adata
End Function

Private Sub cmdCancel_Click()
    Inet1.Cancel
End Sub

Private Sub cmdConnect_Click()
    With Inet1
        .Cancel
        .Protocol = icFTP
        .URL = txt(0).Text
        .UserName = txt(1).Text
        .Password = txt(2).Text
    End With
    cmdRefresh_Click
End Sub

Private Sub cmdQuit_Click()
    aCmd = "QUIT"
    Inet1.Execute , aCmd
    lstData.Clear
End Sub

Private Sub cmdRefresh_Click()
    MousePointer = vbHourglass
    aCmd = "DIR"
    lblBR.Caption = "": lblStat.ForeColor = vbRed
'    aCmd = "GET"
    Inet1.Execute , aCmd
End Sub

Private Sub Command1_Click()
    Call Inet1.Execute(, "PUT C:\dale.txt /dale.txt")
End Sub

Private Sub Command2_Click()
    Clipboard.Clear
    Clipboard.SetText (txt(0).Text)
    DoEvents
    DoEvents
    DoEvents
    DoEvents
    DoEvents
End Sub

Private Sub Form_Load()
    Dim fileid As Long
    fileid = FreeFile
    Open "files.txt" For Input As #fileid
    numfiles = 0
    Do While EOF(fileid) = False
        Line Input #fileid, files(numfiles)
        numfiles = numfiles + 1
    Loop
    Close #fileid
    Clipboard.Clear
'    txt(0).Text = files(0)
'    Call cmdConnect_Click
    filenumber = 1
    aPath = App.Path: If Right$(aPath, 1) <> "\" Then aPath = aPath & "\"
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Inet1.Cancel
    MousePointer = vbDefault
    End
End Sub

Private Sub Inet1_StateChanged(ByVal State As Integer)
    Dim adata As String, a As String, k As Long, aStat As String
    Select Case State
        Case icNone
            aStat = ""
        Case icResolvingHost
            aStat = "Resolving Host"
        Case icHostResolved
            aStat = "Host Resolved"
        Case icConnecting
            aStat = "Connecting"
        Case icConnected
            aStat = "Connected"
        Case icRequesting
            aStat = "Sending Request"
        Case icRequestSent
            aStat = "Request Sent"
        Case icReceivingResponse
            aStat = "Receiving Response"
        Case icResponseReceived
            aStat = "Response Received"
        Case icDisconnecting
            aStat = "Disconnecting"
        Case icDisconnected
            aStat = "Disconnected"
        Case icError
            aStat = "Remote Error"
            MousePointer = vbDefault
        Case icResponseCompleted
            lblStat.ForeColor = vbButtonText
            lblStat.Caption = "Response Completed": DoEvents
            Select Case aCmd
                Case "DIR"
                    lblStat.Caption = "Bytes Received:"
                    lstData.Clear
                    GetData adata
                    lstData.AddItem ".."
                    Do While Len(adata)
                        k = InStr(adata, vbCrLf)
                        If k Then
                            a = Left$(adata, k - 1)
                            adata = Mid$(adata, k + 2)
                        Else
                            a = adata
                            adata = ""
                        End If
                        If Len(Trim$(a)) Then lstData.AddItem Trim$(a)
                    Loop
                Case "SIZE"
                    lblStat.Caption = "Bytes To Go:"
                    GetData adata
                    lblBR.Caption = Trim$(adata)
                    lBytes = Val(adata)
                Case "GET"
                    lblGET.Caption = "File Retrieved: " & vbCrLf & aFile
                    Text1.Text = Inet1.GetHeader
                    Text1.Text = Text1.Text & GetData2()
                    ' download file
                    Dim rightpos As Long
                    Dim leftpos As Long
                    Dim page As String
                    Dim page2 As String
                    rightpos = InStr(UCase$(Text1.Text), ".ZIP")
                    page = Left$(Text1.Text, rightpos + 4)
                    leftpos = InStrRev(UCase$(page), "HTTP://")
                    page2 = Mid$(page, leftpos, rightpos + 4 - leftpos)
                    Call Clipboard.Clear
                    Call Clipboard.SetText(page2)
                    Timer1.Enabled = True
                Case "PUT"
                    lblGET.Caption = "File Sent: " & vbCrLf & aFile
            End Select
            MousePointer = vbDefault
            Exit Sub
    End Select
    lblStat.Caption = aStat
End Sub

Private Sub lstData_DblClick()
    Dim a As String, k As Long
    a = lstData.List(lstData.ListIndex)
    MousePointer = vbHourglass
    lblStat.ForeColor = vbRed
    If a = ".." Or Right$(a, 1) = "/" Then
        DoEvents
        If a = ".." Then
            aCmd = "CDUP"
            Inet1.Execute , aCmd
        Else
            aCmd = "CD " & Left$(a$, Len(a$) - 1)
            Inet1.Execute , aCmd
        End If
        Do While Inet1.StillExecuting: DoEvents: Loop
        aCmd = "DIR"
        MousePointer = vbHourglass
        Inet1.Execute , aCmd
    Else
        aCmd = "SIZE"
        lblGET.Caption = "Retrieving:" & vbCrLf & a
        Inet1.Execute , aCmd & " " & a
        Do While Inet1.StillExecuting: DoEvents: Loop
        aCmd = "GET"
        MousePointer = vbHourglass
        lBuf = FreeFile
        aFile = Space$(MAX_PATH)
        k = GetShortPathName(aPath & a, aFile, MAX_PATH)
        aFile = Left$(aFile, k)
        If Len(Dir$(aFile)) Then
            If MsgBox("File already exists. Overwrite?", vbYesNoCancel Or vbQuestion) <> vbYes Then
                lblStat.Caption = "Operation Cancelled"
                lblGET.Caption = ""
                MousePointer = vbDefault
                Exit Sub
            Else
                Kill aFile
            End If
        End If
        Inet1.Execute , aCmd & " " & a & " " & aFile
    End If
End Sub

Private Sub lstData_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then
        KeyAscii = 0
        lstData_DblClick
    End If
End Sub

Private Sub lstData_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Data.GetFormat(vbCFFiles) Then
        Dim k As Long, j As Long, aSend As String
        aCmd = "PUT"
        For k = 1 To Data.files.Count
            aFile = Space$(MAX_PATH)
            aSend = Data.files(k)
            j = GetShortPathName(aSend, aFile, MAX_PATH)
            aFile = Left$(aFile, j)
            lblGET.Caption = "Sending:" & vbCrLf & aFile
            For j = Len(aSend) To 1 Step -1
                Select Case Mid$(aSend, j, 1)
                    Case "/", "\", ":"
                        aSend = Mid$(aSend, j + 1)
                        Exit For
                End Select
            Next
            j = InStr(aSend, " ")
            Do While j
                Mid$(aSend, j, 1) = "_"
                j = InStr(j, aSend, " ")
            Loop
            lblBR.Caption = CStr(Data.files.Count - k + 1)
            lblStat.Caption = "Sending File(s)"
            lblStat.ForeColor = vbRed
            MousePointer = vbHourglass
            Inet1.Execute , "PUT " & aFile & " " & aSend
            Do While Inet1.StillExecuting: DoEvents: Loop
        Next
        cmdRefresh_Click
    End If
End Sub

Private Sub Timer1_Timer()
    Dim fileid As Long
    Dim tempstring As String
    Dim temps As String
    If (pause > 10) Then
    fileid = FreeFile
    tempstring = ""
    Open "c:\program files\getright\getright.ini" For Input As #fileid
    Do While EOF(fileid) = False
        Line Input #fileid, temps
        tempstring = tempstring & temps
    Loop
    Close #fileid
    temps = Trim$(Mid$(files(filenumber - 1), InStrRev(files(filenumber - 1), "/") + 1, 14))
    If (InStr(tempstring, temps) = 0) Then
        Timer1.Enabled = False
        pause = 0
        ' add file
        txt(0).Text = files(filenumber)
        Call cmdConnect_Click
        If (numfiles > filenumber) Then
            filenumber = filenumber + 1
        End If
    End If
    Else
        pause = pause + 1
    End If
End Sub

Private Sub txt_GotFocus(Index As Integer)
    With txt(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With
End Sub
