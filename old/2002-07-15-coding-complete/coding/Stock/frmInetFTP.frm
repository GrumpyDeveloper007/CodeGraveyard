VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form Form1 
   Caption         =   "INetFTP "
   ClientHeight    =   7725
   ClientLeft      =   1650
   ClientTop       =   1545
   ClientWidth     =   10050
   LinkTopic       =   "Form1"
   ScaleHeight     =   7725
   ScaleWidth      =   10050
   Begin VB.Timer Timer1 
      Interval        =   58000
      Left            =   9120
      Top             =   240
   End
   Begin VB.TextBox Text1 
      Height          =   4335
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   7
      Text            =   "frmInetFTP.frx":0000
      Top             =   3240
      Width           =   8415
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "C&ancel"
      Height          =   375
      Left            =   60
      TabIndex        =   1
      Top             =   2580
      Width           =   1215
   End
   Begin VB.CommandButton cmdQuit 
      Caption         =   "&Quit"
      Height          =   375
      Left            =   60
      TabIndex        =   2
      Top             =   3060
      Width           =   1215
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "&Connect"
      Default         =   -1  'True
      Height          =   375
      Left            =   60
      TabIndex        =   0
      Top             =   1620
      Width           =   1215
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   9120
      Top             =   780
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      AccessType      =   1
      Protocol        =   4
      RemoteHost      =   "uk.finance.yahoo.com"
      URL             =   "http://uk.finance.yahoo.com/d/quotes.csv?s=ukx.l+@ukx.l&f=sl1d1t1c1ohgv&e=.csv"
      Document        =   "/d/quotes.csv?s=ukx.l+@ukx.l&f=sl1d1t1c1ohgv&e=.csv"
      RequestTimeout  =   10
   End
   Begin VB.Label lblGET 
      Alignment       =   2  'Center
      Height          =   375
      Left            =   2580
      TabIndex        =   6
      Top             =   1680
      Width           =   4230
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   5700
      TabIndex        =   5
      Top             =   1380
      Width           =   1005
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      Caption         =   "Bytes Received:"
      Height          =   195
      Left            =   4320
      TabIndex        =   4
      Top             =   1380
      Width           =   1290
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "Directory List"
      Height          =   195
      Index           =   3
      Left            =   1440
      TabIndex        =   3
      Top             =   1680
      Width           =   915
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

Private Sub cmdCancel_Click()
    Inet1.Cancel
End Sub

Private Sub cmdConnect_Click()
    MousePointer = vbHourglass
    aCmd = "LIST"
    
    lblBR.Caption = "": lblStat.ForeColor = vbRed
    Inet1.Execute , aCmd
End Sub

Private Sub cmdQuit_Click()
    aCmd = "QUIT"
    Inet1.Execute , aCmd
End Sub


Private Sub Form_Load()
    Call ConnectDatabase("Stockvalues.mdb")
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
            If (aCmd <> "QUIT") Then
                lblStat.ForeColor = vbButtonText
                lblStat.Caption = "Response Completed": DoEvents
                
                GetData adata
                Text1.Text = adata
                '"^FTSE",4612.30,"9/25/2001","1:47PM",-1.60,4613.90,4643.70,4515.30,N/A
                Dim tempstring As String
                Dim bdata As String
                Dim Symbol As String
                Dim Value As Currency
                Dim StartDate As Date
                Dim rstemp As Recordset
                Do While (InStr(adata, vbCrLf) > 0)
                    tempstring = Left$(adata, InStr(adata, vbCrLf))
                    If (Len(tempstring) > 2) Then
                        Symbol = Mid$(tempstring, 2, InStr(tempstring, ",") - 3)
                        tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        Value = Mid$(tempstring, 1, InStr(tempstring, ",") - 1)
                        tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        
                        StartDate = Mid$(tempstring, 2, InStr(tempstring, ",") - 3)
                        tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        StartDate = StartDate + Mid$(tempstring, 2, InStr(tempstring, ",") - 3)
                        tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        If (OpenRecordset(rstemp, "SELECT * FROM ftse WHERE symbol='" & Symbol & "' AND [date]=#" & Format(StartDate, "mm/dd/yyyy hh:mm") & "#", dbOpenDynaset)) Then
                            If (rstemp.EOF = False) Then
                            Else
                                Call rstemp.AddNew
                            End If
                            rstemp!Symbol = Symbol
                            rstemp!Date = StartDate
                            rstemp!Value = Value
                            rstemp!valuechange = Mid$(tempstring, 1, InStr(tempstring, ",") - 1)
                            tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        
                            rstemp!valuea = Mid$(tempstring, 1, InStr(tempstring, ",") - 1)
                            tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                            rstemp!valueb = Mid$(tempstring, 1, InStr(tempstring, ",") - 1)
                            tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                            rstemp!valuec = Mid$(tempstring, 1, InStr(tempstring, ",") - 1)
                            tempstring = Mid$(tempstring, InStr(tempstring, ",") + 1)
                        
                            If (Left$(tempstring, 3) <> "N/A") Then
                                rstemp!volume = Mid$(tempstring, 1, InStr(tempstring, vbCr) - 1)
                                tempstring = Mid$(tempstring, InStr(tempstring, vbCr) + 1)
                            End If
                        
                            Call rstemp.Update
                        End If
                    End If
                    
                    adata = Mid$(adata, InStr(adata, vbCrLf) + 2)
                Loop
            End If
            MousePointer = vbDefault
    End Select
    lblStat.Caption = aStat
End Sub


Private Sub Timer1_Timer()
    Call cmdConnect_Click
End Sub

