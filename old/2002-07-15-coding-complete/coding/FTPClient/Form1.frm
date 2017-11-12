VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Form1"
   ClientHeight    =   8880
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   14700
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8880
   ScaleWidth      =   14700
   StartUpPosition =   2  'CenterScreen
   Begin RichTextLib.RichTextBox TXTDirBuffer2 
      Height          =   4035
      Left            =   0
      TabIndex        =   32
      Top             =   2100
      Width           =   8175
      _ExtentX        =   14420
      _ExtentY        =   7117
      _Version        =   393217
      Enabled         =   -1  'True
      ScrollBars      =   3
      TextRTF         =   $"Form1.frx":0000
   End
   Begin VB.CommandButton CMDDeleteFiles 
      Caption         =   "Delete Files"
      Height          =   315
      Left            =   2640
      TabIndex        =   31
      Top             =   1740
      Width           =   1095
   End
   Begin VB.CommandButton CMDUpload 
      Caption         =   "Test"
      Height          =   255
      Left            =   4080
      TabIndex        =   30
      Top             =   1680
      Width           =   495
   End
   Begin VB.CommandButton CMDBuildPath 
      Caption         =   "Build Path"
      Height          =   315
      Left            =   7200
      TabIndex        =   29
      Top             =   1740
      Width           =   1215
   End
   Begin VB.TextBox TXTFileName 
      Height          =   315
      Left            =   5880
      TabIndex        =   28
      Text            =   "/"
      Top             =   60
      Width           =   2175
   End
   Begin VB.ListBox LSTBrowser 
      Height          =   6495
      Left            =   8280
      TabIndex        =   27
      Top             =   2100
      Width           =   1575
   End
   Begin VB.CommandButton CMDDisConnect 
      Caption         =   "Disconnect"
      Height          =   315
      Left            =   4680
      TabIndex        =   26
      Top             =   0
      Width           =   975
   End
   Begin VB.TextBox TXTSpeed 
      Height          =   315
      Left            =   1920
      TabIndex        =   25
      Top             =   1260
      Width           =   855
   End
   Begin VB.TextBox TXTBytes 
      Height          =   315
      Left            =   240
      TabIndex        =   24
      Top             =   1260
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   315
      Left            =   1560
      TabIndex        =   23
      Top             =   1740
      Width           =   975
   End
   Begin VB.TextBox TXTPort 
      Height          =   315
      Left            =   2880
      TabIndex        =   1
      Text            =   "21"
      Top             =   0
      Width           =   495
   End
   Begin VB.CheckBox CHKStop 
      Caption         =   "Stop"
      Height          =   315
      Left            =   3720
      TabIndex        =   22
      Top             =   840
      Width           =   855
   End
   Begin VB.CheckBox CHKPassiveMode 
      Caption         =   "PASV"
      Height          =   315
      Left            =   2880
      TabIndex        =   21
      Top             =   1260
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.CommandButton CMDFolders 
      Caption         =   "Folder"
      Height          =   315
      Left            =   840
      TabIndex        =   20
      Top             =   1740
      Width           =   615
   End
   Begin VB.CommandButton CMDLog 
      Caption         =   "Log"
      Height          =   315
      Left            =   120
      TabIndex        =   19
      Top             =   1740
      Width           =   615
   End
   Begin VB.TextBox TXTFiles 
      Height          =   2535
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   18
      Top             =   6300
      Width           =   8175
   End
   Begin VB.CheckBox CHKPause 
      Caption         =   "Pause"
      Height          =   315
      Left            =   2880
      TabIndex        =   17
      Top             =   840
      Width           =   855
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "Clear"
      Height          =   315
      Left            =   6240
      TabIndex        =   16
      Top             =   1740
      Width           =   855
   End
   Begin VB.CommandButton CMDDeleteEmpty 
      Caption         =   "Delete Empty"
      Height          =   315
      Left            =   8520
      TabIndex        =   13
      Top             =   1740
      Width           =   1215
   End
   Begin VB.ComboBox CBOIP 
      Height          =   315
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   2775
   End
   Begin VB.TextBox TXTFailedCount 
      Height          =   345
      Left            =   10440
      TabIndex        =   12
      Top             =   0
      Width           =   615
   End
   Begin VB.TextBox TXTToDo 
      Height          =   6735
      Left            =   9960
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   11
      Top             =   2100
      Width           =   4695
   End
   Begin VB.CommandButton CMDScan 
      Caption         =   "Scan"
      Height          =   315
      Left            =   9360
      TabIndex        =   10
      Top             =   0
      Width           =   975
   End
   Begin VB.TextBox TXTPath 
      Height          =   315
      Left            =   0
      TabIndex        =   3
      Text            =   "/"
      Top             =   360
      Width           =   4575
   End
   Begin VB.TextBox TXTDirBuffer2a 
      Height          =   4095
      Left            =   7560
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   9
      Top             =   1080
      Visible         =   0   'False
      Width           =   2415
   End
   Begin VB.TextBox TXTDirBuffer 
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1095
      Left            =   4680
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Top             =   600
      Width           =   9255
   End
   Begin MSWinsockLib.Winsock Winsock2 
      Left            =   2280
      Top             =   780
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.CommandButton CMDList 
      Caption         =   "List"
      Height          =   315
      Left            =   8160
      TabIndex        =   6
      Top             =   0
      Width           =   975
   End
   Begin VB.TextBox TXTLog 
      Height          =   6735
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Top             =   2100
      Visible         =   0   'False
      Width           =   8175
   End
   Begin VB.CommandButton CMDConnect 
      Caption         =   "Connect"
      Height          =   315
      Left            =   3600
      TabIndex        =   2
      Top             =   0
      Width           =   975
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   1800
      Top             =   780
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label Label2 
      Caption         =   "To Scan"
      Height          =   255
      Left            =   9960
      TabIndex        =   15
      Top             =   1800
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "Scanned Folders"
      Height          =   255
      Left            =   4680
      TabIndex        =   14
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label LBLStatus2 
      Caption         =   "Label1"
      Height          =   255
      Left            =   11160
      TabIndex        =   7
      Top             =   0
      Width           =   3375
   End
   Begin VB.Label LBLStatus 
      Caption         =   "Label1"
      Height          =   495
      Left            =   0
      TabIndex        =   4
      Top             =   720
      Width           =   2535
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


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

Private Sub ExecuteCommand(pCommand As String)
    Static linenumnber As Long
    vDataReady = False
    'Text1.Text = Text1.Text & pCommand & vbCrLf
    TXTLog.SelStart = Len(TXTLog.Text)
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
    TXTDirBuffer.Text = ""
    Call ExecuteCommand("CWD " & pPath)
    If (vCWDOK = True) Then
        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
        Else
            Call Winsock2.Listen
            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
        End If
        Call ExecuteCommand("LIST -al") '-al-alF
        
        Do While (vDirComplete = False)
            DoEvents
        Loop
        DoEvents
        DoEvents
        DoEvents
        DoEvents
        DoEvents
        DoEvents
        Call Winsock2.Close
    End If
End Sub

Private Sub UploadFile(pPath As String, pFileName As String, pLocalName As String)
    Call ExecuteCommand("Type I")
    Call ExecuteCommand("CWD " & pPath)
    vRecieveMode = ModeUploadFile
    vUploadFileID = FreeFile
    vCWDOK = True
    Open pLocalName For Binary As #vUploadFileID
    
    If (vCWDOK = True) Then
        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
        Else
            Call Winsock2.Listen
            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
        End If
        Call ExecuteCommand("STOR " & pFileName)
    End If
End Sub


Private Sub DownloadFile(pPath As String, pFileName As String)
    Dim FilePos As Long
    vStartTime = Now
    vRecieveMode = file
    vDirComplete = False
    vCWDOK = True
    TXTDirBuffer.Text = ""
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
        If (CHKPassiveMode.Value = vbChecked) Then
            Call ExecuteCommand("PASV")
        Else
            Call Winsock2.Listen
            Call ExecuteCommand("PORT 80,4,206,174," & Winsock2.LocalPort \ 256 & "," & (Winsock2.LocalPort Mod 256))
        End If
        Call ExecuteCommand("RETR " & pFileName) '-al-alF
        
'        Do While (vDirComplete = False)
'            DoEvents
'        Loop
        DoEvents
        DoEvents
        DoEvents
        DoEvents
        DoEvents
        DoEvents
'        Do While (vFileProgress < pFileSize)
'            DoEvents
'        Loop
'        Call Winsock2.Close
'        Close #vDownloadFileID
    End If
End Sub

Private Sub ProcessFile()
    Dim tempstring As String
    Dim temparray() As Byte
    Dim i As Long
'    Dim message
    TXTSpeed.Text = (Winsock2.BytesReceived / DateDiff("s", vStartTime, Now)) / 1024 & "KB" '
    TXTDirBuffer.Text = ""
    If (LOF(vDownloadFileID) > 1024 * 10) Then
        TXTBytes.Text = Format((LOF(vDownloadFileID)) / 1024, "#############0") & "KB" '
    Else
        TXTBytes.Text = Format((LOF(vDownloadFileID)), "#############0") & "B"  '
    End If
    vFileProgress = LOF(vDownloadFileID)
    Call Winsock2.PeekData(tempstring, vbString)
    Do While (tempstring <> "")
        
        Call Winsock2.GetData(temparray, vbByte + vbArray, 512)
        
    '    Call Winsock2.GetData(tempstring, vbString, 512)
        For i = 0 To UBound(temparray)
            Put #vDownloadFileID, , temparray(i)
    '        TXTDirBuffer.Text = TXTDirBuffer.Text & Chr$(temparray(i))
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
        
    Call LSTBrowser.Clear
    Call LSTBrowser.AddItem("..")
    LSTBrowser.ItemData(LSTBrowser.ListCount - 1) = 2
    
    tempstring = TXTDirBuffer.Text
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
            
            Call LSTBrowser.AddItem("(file)" & Trim$(Mid$(foldername, Len("06-03-02  04:02PM              3523523 "))) & "," & FileSize)
            LSTBrowser.ItemData(LSTBrowser.ListCount - 1) = 1
            TXTFiles.Text = TXTFiles.Text & TXTPath.Text & Trim$(Mid$(foldername, Len("06-03-02  04:02PM              3523523 "))) & vbCrLf
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
'        If (foldername = "scanned by ") Then
'            PrcoessFolder = False
'        End If
'        If (foldername = "scanned by") Then
'            PrcoessFolder = False
'        End If
'        If (Trim$(UCase$(foldername)) = "TAG") Then
'            PrcoessFolder = False
'        End If
        If (Left$(Trim$(UCase$(foldername)), 7) = "DARKELF") Then
            PrcoessFolder = False
        End If
'        If (Trim$(UCase$(foldername)) = "SYS") Then
'            PrcoessFolder = False
'        End If
        
        If (PrcoessFolder = True) Then
            Call LSTBrowser.AddItem(foldername)
            LSTBrowser.ItemData(LSTBrowser.ListCount - 1) = 2
            outstring = outstring & TXTPath.Text & foldername & "/" & vbCrLf
            outstring2 = outstring2 & TXTPath.Text & foldername & "/" & vbCrLf
        End If
        '
        If (InStr(tempstring, vbCrLf) > 0) Then
            tempstring = Mid$(tempstring, InStr(tempstring, vbCrLf) + 2)
        Else
            tempstring = ""
        End If
    Loop
    TXTDirBuffer2.Text = TXTDirBuffer2.Text & outstring2
'    If (Len(TXTDirBuffer2.Text) > 65000) Then
'        CHKStop.Value = vbChecked
'    End If
    TXTDirBuffer2.SelStart = Len(TXTDirBuffer2) - 1
    TXTToDo.Text = outstring2 & TXTToDo.Text
    '
End Sub

Private Sub CMDBuildPath_Click()
    Call ListDir(TXTPath.Text)
    Call ExecuteCommand("MKD a / /")
    Call ExecuteCommand("MKD b / /")
    Call ExecuteCommand("MKD c / /")
    Call ExecuteCommand("MKD d / /")
    Call ExecuteCommand("MKD e / /")
    Call ExecuteCommand("MKD f / /")
    Call ExecuteCommand("MKD g / /")
    Call ExecuteCommand("MKD h / /")
    Call ExecuteCommand("MKD i / /")
    Call ExecuteCommand("MKD j / /")
    Call ExecuteCommand("MKD k / /")
    Call ExecuteCommand("MKD l / /")
    Call ExecuteCommand("MKD m / /")

    Call ExecuteCommand("MKD a /a  / /")
    Call ExecuteCommand("MKD b /a  / /")
    Call ExecuteCommand("MKD c /a  / /")
    Call ExecuteCommand("MKD d /a  / /")
    Call ExecuteCommand("MKD e /a  / /")
    Call ExecuteCommand("MKD f /a  / /")
    Call ExecuteCommand("MKD g /a  / /")
    Call ExecuteCommand("MKD h /a  / /")
    Call ExecuteCommand("MKD i /a  / /")
    Call ExecuteCommand("MKD j /a  / /")
    Call ExecuteCommand("MKD k /a  / /")
    Call ExecuteCommand("MKD l /a  / /")
    Call ExecuteCommand("MKD m /a  / /")

    Call ExecuteCommand("MKD a /b  / /")
    Call ExecuteCommand("MKD b /b  / /")
    Call ExecuteCommand("MKD c /b  / /")
    Call ExecuteCommand("MKD d /b  / /")
    Call ExecuteCommand("MKD e /b  / /")
    Call ExecuteCommand("MKD f /b  / /")
    Call ExecuteCommand("MKD g /b  / /")
    Call ExecuteCommand("MKD h /b  / /")
    Call ExecuteCommand("MKD i /b  / /")
    Call ExecuteCommand("MKD j /b  / /")
    Call ExecuteCommand("MKD k /b  / /")
    Call ExecuteCommand("MKD l /b  / /")
    Call ExecuteCommand("MKD m /b  / /")

    Call ExecuteCommand("MKD a /c  / /")
    Call ExecuteCommand("MKD b /c  / /")
    Call ExecuteCommand("MKD c /c  / /")
    Call ExecuteCommand("MKD d /c  / /")
    Call ExecuteCommand("MKD e /c  / /")
    Call ExecuteCommand("MKD f /c  / /")
    Call ExecuteCommand("MKD g /c  / /")
    Call ExecuteCommand("MKD h /c  / /")
    Call ExecuteCommand("MKD i /c  / /")
    Call ExecuteCommand("MKD j /c  / /")
    Call ExecuteCommand("MKD k /c  / /")
    Call ExecuteCommand("MKD l /c  / /")
    Call ExecuteCommand("MKD m /c  / /")

'''3
    Call ExecuteCommand("MKD a /a  /a / /")
    Call ExecuteCommand("MKD b /a  /a / /")
    Call ExecuteCommand("MKD c /a  /a / /")
    Call ExecuteCommand("MKD d /a  /a / /")
    Call ExecuteCommand("MKD e /a  /a / /")
    Call ExecuteCommand("MKD f /a  /a / /")
    Call ExecuteCommand("MKD g /a  /a / /")
    Call ExecuteCommand("MKD h /a  /a / /")
    Call ExecuteCommand("MKD i /a  /a / /")
    Call ExecuteCommand("MKD j /a  /a / /")
    Call ExecuteCommand("MKD k /a  /a / /")
    Call ExecuteCommand("MKD l /a  /a / /")
    Call ExecuteCommand("MKD m /a  /a / /")

    Call ExecuteCommand("MKD a /b  /a / /")
    Call ExecuteCommand("MKD b /b  /a / /")
    Call ExecuteCommand("MKD c /b  /a / /")
    Call ExecuteCommand("MKD d /b  /a / /")
    Call ExecuteCommand("MKD e /b  /a / /")
    Call ExecuteCommand("MKD f /b  /a / /")
    Call ExecuteCommand("MKD g /b  /a / /")
    Call ExecuteCommand("MKD h /b  /a / /")
    Call ExecuteCommand("MKD i /b  /a / /")
    Call ExecuteCommand("MKD j /b  /a / /")
    Call ExecuteCommand("MKD k /b  /a / /")
    Call ExecuteCommand("MKD l /b  /a / /")
    Call ExecuteCommand("MKD m /b  /a / /")

    Call ExecuteCommand("MKD a /c  /a / /")
    Call ExecuteCommand("MKD b /c  /a / /")
    Call ExecuteCommand("MKD c /c  /a / /")
    Call ExecuteCommand("MKD d /c  /a / /")
    Call ExecuteCommand("MKD e /c  /a / /")
    Call ExecuteCommand("MKD f /c  /a / /")
    Call ExecuteCommand("MKD g /c  /a / /")
    Call ExecuteCommand("MKD h /c  /a / /")
    Call ExecuteCommand("MKD i /c  /a / /")
    Call ExecuteCommand("MKD j /c  /a / /")
    Call ExecuteCommand("MKD k /c  /a / /")
    Call ExecuteCommand("MKD l /c  /a / /")
    Call ExecuteCommand("MKD m /c  /a / /")

''3b
    Call ExecuteCommand("MKD a /a  /b / /")
    Call ExecuteCommand("MKD b /a  /b / /")
    Call ExecuteCommand("MKD c /a  /b / /")
    Call ExecuteCommand("MKD d /a  /b / /")
    Call ExecuteCommand("MKD e /a  /b / /")
    Call ExecuteCommand("MKD f /a  /b / /")
    Call ExecuteCommand("MKD g /a  /b / /")
    Call ExecuteCommand("MKD h /a  /b / /")
    Call ExecuteCommand("MKD i /a  /b / /")
    Call ExecuteCommand("MKD j /a  /b / /")
    Call ExecuteCommand("MKD k /a  /b / /")
    Call ExecuteCommand("MKD l /a  /b / /")
    Call ExecuteCommand("MKD m /a  /b / /")

    Call ExecuteCommand("MKD a /b  /b / /")
    Call ExecuteCommand("MKD b /b  /b / /")
    Call ExecuteCommand("MKD c /b  /b / /")
    Call ExecuteCommand("MKD d /b  /b / /")
    Call ExecuteCommand("MKD e /b  /b / /")
    Call ExecuteCommand("MKD f /b  /b / /")
    Call ExecuteCommand("MKD g /b  /b / /")
    Call ExecuteCommand("MKD h /b  /b / /")
    Call ExecuteCommand("MKD i /b  /b / /")
    Call ExecuteCommand("MKD j /b  /b / /")
    Call ExecuteCommand("MKD k /b  /b / /")
    Call ExecuteCommand("MKD l /b  /b / /")
    Call ExecuteCommand("MKD m /b  /b / /")

    Call ExecuteCommand("MKD a /c  /b / /")
    Call ExecuteCommand("MKD b /c  /b / /")
    Call ExecuteCommand("MKD c /c  /b / /")
    Call ExecuteCommand("MKD d /c  /b / /")
    Call ExecuteCommand("MKD e /c  /b / /")
    Call ExecuteCommand("MKD f /c  /b / /")
    Call ExecuteCommand("MKD g /c  /b / /")
    Call ExecuteCommand("MKD h /c  /b / /")
    Call ExecuteCommand("MKD i /c  /b / /")
    Call ExecuteCommand("MKD j /c  /b / /")
    Call ExecuteCommand("MKD k /c  /b / /")
    Call ExecuteCommand("MKD l /c  /b / /")
    Call ExecuteCommand("MKD m /c  /b / /")

    Call ExecuteCommand("MKD h /c  /b /a / /")
    Call ExecuteCommand("MKD h /c  /b /a /b / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e /f / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e /f /g / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e /f /g /h / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e /f /g /h /a / /")
    Call ExecuteCommand("MKD h /c  /b /a /b /c /d /e /f /g /h /a /Here")

End Sub

Private Sub CMDClear_Click()
    TXTDirBuffer2.Text = ""
    TXTFiles.Text = ""
    TXTLog.Text = ""
    TXTToDo.Text = ""
End Sub

Private Sub CMDConnect_Click()
    Dim co As String
'    Call Winsock1.Connect("Localhost", 99)
    Call Winsock1.Close
    Call Winsock1.Connect(CBOIP.Text, TXTPort.Text)
'    Call Winsock1.Connect("160.252.122.191", 21)
'137.43.110.11
    
    Do While (Winsock1.State <> sckConnected)
        DoEvents
    Loop
    
'    Call ExecuteCommand("GET /index.htm HTTP/1.1" & vbCrLf & "Host: www.pyrodesign.co.uk")
    '"User-Agent: Sam Spade 1.14"'
    
'co = co & "GET /index.htm HTTP/1.1" & vbCrLf
'co = co & "Accept: */*" & vbCrLf
'co = co & "Referer: http://www.pyrodesign.co.uk/title.htm" & vbCrLf
'co = co & "Accept -Language: en -gb" & vbCrLf
'co = co & "Accept -Encoding: gzip , deflate" & vbCrLf
''co = co & "If-Modified-Since: Wed, 27 Feb 2002 13:01:54 GMT" & vbCrLf
''co = co & "If-None-Match: " & Chr$(34) & "ee2456ee8ebfc11:88c" & Chr$(34) & vbCrLf
'co = co & "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)" & vbCrLf
'co = co & "Host: www.pyrodesign.co.uk" & vbCrLf
'co = co & "Connection: Keep -Alive" & vbCrLf
'    Call ExecuteCommand(co)


    Call ExecuteCommand("USER anonymous")
    Call ExecuteCommand("PASS ddd@d.com")
    Call ExecuteCommand("SYST")
    
'    Call Winsock1.SendData("CWD " & "/" & vbCrLf)
End Sub

Private Sub CMDDeleteEmpty_Click()
    Screen.MousePointer = vbHourglass
    Dim tempstring As String
    Dim todo As String
    
    Call CMDLog_Click
    Call ExecuteCommand("CWD /")
    todo = TXTDirBuffer2.Text
    TXTLog.Text = ""
    
    If (InStr(todo, vbCrLf) > 0) Then
        tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
        todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
        tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
        todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
'        TXTPath.Text = tempstring
        
        Do While (tempstring <> "")
            ' Check for Locked dir
            If (Trim$(tempstring) <> "") Then
                If (Left$(tempstring, 4) <> "xx") Then
                    Call ExecuteCommand("RMD " & tempstring)
'                    Call ExecuteCommand("PWD ")
                End If
            End If
            DoEvents
            
'            Call ListDir(tempstring)
            If (todo <> "") Then
                If (InStr(todo, vbCrLf) > 0) Then
                    tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
                    todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
                Else
                    tempstring = todo
                    TXTPath.Text = tempstring
                    todo = ""
                End If
            Else
                todo = ""
                tempstring = ""
            End If
        Loop
    End If
    TXTLog.Text = TXTLog.Text & "Finished"

    Screen.MousePointer = vbDefault
End Sub

Private Sub CMDDeleteFiles_Click()
    Screen.MousePointer = vbHourglass
    Dim tempstring As String
    Dim todo As String
    
    Call CMDLog_Click
    Call ExecuteCommand("CWD /")
    todo = TXTFiles.Text
    TXTLog.Text = ""
    
    If (InStr(todo, vbCrLf) > 0) Then
        tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
        todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
        tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
        If (InStr(todo, vbCrLf) > 0) Then
            todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
        Else
            todo = ""
        End If
'        TXTPath.Text = tempstring
        
        Do While (tempstring <> "")
            ' Check for Locked dir
            If (Trim$(tempstring) <> "") Then
                Call ExecuteCommand("DELE " & tempstring)
            End If
            DoEvents
            
'            Call ListDir(tempstring)
            If (todo <> "") Then
                If (InStr(todo, vbCrLf) > 0) Then
                    tempstring = Mid$(todo, InStrRev(todo, vbCrLf) + 2)
                    todo = Left$(todo, InStrRev(todo, vbCrLf) - 1)
                Else
                    tempstring = todo
                    todo = ""
                End If
            Else
                todo = ""
                tempstring = ""
            End If
        Loop
    End If
    TXTLog.Text = TXTLog.Text & "Finished"

    Screen.MousePointer = vbDefault
End Sub

Private Sub CMDDisConnect_Click()
    Winsock1.Close
    Winsock2.Close
End Sub

Private Sub CMDFolders_Click()
    TXTLog.Visible = False
    TXTDirBuffer2.Visible = True
    TXTFiles.Visible = True
End Sub

Private Sub CMDList_Click()
    Call ListDir(TXTPath.Text)
    
'    Call Winsock1.SendData("USER DarkElf" & vbCrLf)
'    Call Winsock1.SendData("PASS Meon" & vbCrLf)
'    Call Winsock1.SendData("CWD " & "/dbsit/.temp/scanned by /elusive/filled by /DarkElf/c/" & vbCrLf)
End Sub

Private Sub CMDLog_Click()
    TXTLog.Visible = True
    TXTDirBuffer2.Visible = False
    TXTFiles.Visible = False
End Sub

Private Sub CMDScan_Click()
    Dim tempstring As String
    Dim OldName As String
    
    Screen.MousePointer = vbHourglass
    Call ListDir(TXTPath.Text)
    
    If (InStr(TXTToDo.Text, vbCrLf) > 0) Then
        tempstring = Left$(TXTToDo.Text, InStr(TXTToDo.Text, vbCrLf) - 1)
        TXTToDo.Text = Mid$(TXTToDo.Text, InStr(TXTToDo.Text, vbCrLf) + 2)
        TXTPath.Text = tempstring
        
        Do While (tempstring <> "")
            Do While (CHKPause.Value = vbChecked)
                DoEvents
            Loop
                
            ' Check for Locked dir
            If (Mid$(tempstring, Len(tempstring) - 1, 1) = " ") Then
'                Call ExecuteCommand("MKD " & Left$(tempstring, Len(tempstring) - 2))
            
            End If
            OldName = tempstring
            Call CheckForReservedFolderName(tempstring)
            If (OldName <> tempstring) Then
                TXTToDo.Text = Replace(TXTToDo.Text, OldName, tempstring)
                TXTDirBuffer2.Text = Replace(TXTDirBuffer2.Text, OldName, tempstring)
                TXTDirBuffer2.SelStart = Len(TXTDirBuffer2) - 1
            End If
            TXTPath.Text = tempstring
            
            Call ListDir(tempstring)
            If (InStr(TXTToDo.Text, vbCrLf) > 0) Then
                tempstring = Left$(TXTToDo.Text, InStr(TXTToDo.Text, vbCrLf) - 1)
                TXTToDo.Text = Mid$(TXTToDo.Text, InStr(TXTToDo.Text, vbCrLf) + 2)
                OldName = tempstring
            Else
                tempstring = ""
            End If
            If (CHKStop.Value = vbChecked) Then
                tempstring = ""
            End If
        Loop
    End If
    Screen.MousePointer = vbDefault
End Sub


Private Sub CheckForReservedFolderName(ByRef pName As String)
    Dim foldername As String
    Dim foldernameshort As String
    Dim rename As Boolean
    Dim rename2 As Boolean
    Dim Index As Long
    Dim tempstring As String
    Dim savename As String
    savename = pName
    foldername = Left$(pName, Len(pName) - 1)
    foldername = UCase$(Mid$(foldername, InStrRev(foldername, "/") + 1))
    foldernameshort = Trim$(UCase$(Mid$(foldername, InStrRev(foldername, "/") + 1, 4)))
    Index = 0
    rename = False
    Select Case Trim$(foldernameshort)
        Case "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9", "COM0"
            rename = True
            Index = Val(Mid$(foldername, 4))
        Case "AUX1", "AUX2", "AUX3", "AUX4", "AUX5", "AUX6", "AUX7", "AUX8", "AUX9", "AUX0"
            rename = True
            Index = Val(Mid$(foldername, 4)) + 10
        Case "PRN1", "PRN2", "PRN3", "PRN4", "PRN5", "PRN6", "PRN7", "PRN8", "PRN9", "PRN0"
            rename = True
            Index = Val(Mid$(foldername, 4)) + 20
        Case "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9", "LPT0"
            rename = True
            Index = Val(Mid$(foldername, 4)) + 30
        Case "PRN"
            rename = True
            Index = 96
        Case "AUX"
            rename = True
            Index = 97
        Case "NUL"
            rename = True
            Index = 98
        Case "NULL"
            rename = True
            Index = 99
        'do 'CLOCK$' later
    End Select
    
    If (InStr(foldername, UCase$("ÿ")) > 0) Then
        rename2 = True
        Index = vUniqueCounter
        vUniqueCounter = vUniqueCounter + 1
    End If
    
    
    If (Len(foldername) > 1) Then
        If (Mid$(foldername, Len(foldername), 1) = " ") Then
            rename2 = False
            rename = True
            Index = vUniqueCounter
            vUniqueCounter = vUniqueCounter + 1
        End If
    
        If (Mid$(foldername, Len(foldername), 1) = ".") Then
            rename2 = False
            rename = True
            Index = vUniqueCounter
            vUniqueCounter = vUniqueCounter + 1
        End If
    End If
    
    
    If (Left$(foldername, 1) = " ") Then
        rename = True
        Index = vUniqueCounter
        vUniqueCounter = vUniqueCounter + 1
    End If
    vCWDOK = True
    If (rename = True) Then
        Call ExecuteCommand("RNFR " & pName & " /")
        tempstring = Left$(pName, Len(pName) - 1)
        tempstring = Left$(tempstring, InStrRev(tempstring, "/")) & "b" & Index & "/"
        Call ExecuteCommand("RNTO " & tempstring)
        pName = tempstring
        If (vCWDOK = False) Then
'            pName = savename
            Call ExecuteCommand("RNFR " & pName)
            tempstring = Left$(pName, Len(pName) - 1)
            tempstring = Left$(tempstring, InStrRev(tempstring, "/")) & "a" & Index & "/"
            Call ExecuteCommand("RNTO " & tempstring)
            pName = tempstring
            If (vCWDOK = False) Then
                pName = savename
            End If
        End If
    Else
        ' Check for leading spaces
    End If

    If (rename2 = True) Then
        Call ExecuteCommand("RNFR " & pName)
        tempstring = Left$(pName, Len(pName) - 1)
        tempstring = Left$(tempstring, InStrRev(tempstring, "/")) & "b" & Index & "/"
        Call ExecuteCommand("RNTO " & tempstring)
        pName = tempstring
        If (vCWDOK = False) Then
'            pName = savename
            Call ExecuteCommand("RNFR " & pName & " /")
            tempstring = Left$(pName, Len(pName) - 1)
            tempstring = Left$(tempstring, InStrRev(tempstring, "/")) & "a" & Index & "/"
            Call ExecuteCommand("RNTO " & tempstring)
            pName = tempstring
            If (vCWDOK = False) Then
                pName = savename
            End If
        End If
    Else
        ' Check for leading spaces
    End If
End Sub



Private Sub CMDUpload_Click()
'    Call UploadFile("/", "/Tagged/by/Misca/ultride/ULTRIDE.ACE / /", "0.txt")
'    Call ExecuteCommand("DELE /Tagged/by/Misca/ultride/ULTRIDE.ACE ./ /")
End Sub

Private Sub Command1_Click()
    Call UploadFile("/pub/", "nli-tit.r00", "nli-tit.r00")
End Sub

Private Sub Form_Load()
'    Call FRMControlServer.Show
'    Call FRMRelayServer.Show
    Call CBOIP.AddItem("137.43.110.11")
    Call CBOIP.AddItem("211.234.43.106")
    Call CBOIP.AddItem("64.192.255.13")
    
    Call CBOIP.AddItem("160.252.122.191")
    
    Call CBOIP.AddItem("195.47.16.130")
    
    Call CBOIP.AddItem("205.227.116.117")
    
    Call CBOIP.AddItem("211.57.221.162")
    Call CBOIP.AddItem("--------------")
    Call CBOIP.AddItem("203.250.120.181")

    Call CBOIP.AddItem("--------------")
    Call CBOIP.AddItem("211.224.231.28")
    Call CBOIP.AddItem("216.36.67.12")
    Call CBOIP.AddItem("211.224.231.28")
    Call CBOIP.AddItem("--------------")
    Call CBOIP.AddItem("www.pyrodesign.co.uk")
    Call CBOIP.AddItem("211.58.254.237")
    Call CBOIP.AddItem("195.56.65.66")
    
    Call CMDLog_Click

    vUniqueCounter = 40
End Sub

Private Sub Form_Unload(Cancel As Integer)
    End
End Sub

Private Sub LSTBrowser_DblClick()
    Dim FileSize As Long
    Dim tempstring As String
    If (LSTBrowser.ItemData(LSTBrowser.ListIndex) = 2) Then
        ' folder
        If (LSTBrowser.List(LSTBrowser.ListIndex) = "..") Then
            If (TXTPath.Text <> "/") Then
                TXTPath.Text = Left$(TXTPath.Text, InStrRev(TXTPath.Text, "/", Len(TXTPath.Text) - 1))
            End If
        Else
            If (Right$(TXTPath.Text, 1) <> "/") Then
                TXTPath.Text = TXTPath.Text & "/"
            End If
            TXTPath.Text = TXTPath.Text & LSTBrowser.List(LSTBrowser.ListIndex)
        End If
        Call CMDList_Click
    Else
        ' file
        tempstring = Mid$(LSTBrowser.List(LSTBrowser.ListIndex), 7)
        FileSize = Mid$(tempstring, InStrRev(tempstring, ",") + 1)
        tempstring = Mid$(tempstring, 1, InStrRev(tempstring, ",") - 1)
        Call DownloadFile(TXTPath.Text, tempstring)

    End If

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
    Call Winsock1.GetData(tempstring, vbString)
    TXTLog.Text = TXTLog.Text & tempstring
    TXTLog.SelStart = Len(TXTLog.Text) - 1
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
'        portlong = 1234
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
'        Winsock2.State
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

Private Sub Winsock2_Close()
    Dim tempstring As String

'    If (vRecieveMode = Dir) Then
'        Call Winsock2.GetData(tempstring, vbString)
'        TXTDirBuffer.Text = TXTDirBuffer.Text & tempstring
'        Call ProcessDir
'    Else
'        Call ProcessFile
'    End If
End Sub

Private Sub Winsock2_ConnectionRequest(ByVal requestID As Long)
    ' Close the connection if it is currently open
    ' by testing the State property.
    If Winsock2.State <> sckClosed Then Winsock2.Close

    ' Pass the value of the requestID parameter to the
    ' Accept method.
    Winsock2.Accept requestID
    If (vRecieveMode = ModeUploadFile) Then
        Do While (Winsock2.State <> 7)
            DoEvents
        Loop
        Dim DataBuffer(511) As Byte
        Get #vUploadFileID, , DataBuffer
        Call Winsock2.SendData(DataBuffer)
    End If
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
            TXTDirBuffer.Text = TXTDirBuffer.Text & tempstring
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
