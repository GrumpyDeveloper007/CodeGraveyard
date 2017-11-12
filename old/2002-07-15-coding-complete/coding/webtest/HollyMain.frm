VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form FRMHollyMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Holly Download"
   ClientHeight    =   7095
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9495
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7095
   ScaleWidth      =   9495
   Begin VB.CommandButton CMDExit 
      Caption         =   "Exit"
      Height          =   375
      Left            =   8400
      TabIndex        =   3
      Top             =   6720
      Width           =   1095
   End
   Begin VB.TextBox Text1 
      Height          =   6255
      Left            =   480
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Text            =   "HollyMain.frx":0000
      Top             =   360
      Width           =   8415
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   3960
      Top             =   60
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin VB.Label lblStat 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Bytes Received:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   4560
      TabIndex        =   1
      Top             =   0
      Width           =   3810
   End
   Begin VB.Label lblBR 
      Alignment       =   2  'Center
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   8460
      TabIndex        =   0
      Top             =   0
      Width           =   1005
   End
End
Attribute VB_Name = "FRMHollyMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private aCmd As String, aPath As String, lBytes As Long, lBuf As Long, aFile As String
Private vrsTopic As Recordset
Private vrsThreads As Recordset
Private vAction As String
Private vCurrentThreadNumber As Long
Private vCurrentTopicNumber As Long

Private vFinished As Boolean

Private Sub GetDatac2(adata As String)
    Dim vData As Variant
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        adata = adata & vData
        lblBR.Caption = CStr(Len(adata))
    Loop
End Sub


Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub Form_Load()
    Call SetWindowPosition(Me)
    MousePointer = vbHourglass
    aCmd = "LIST"
    
    Call Execute("UPDATE thread SET old=true")
    vAction = "ReadThreads"
    If (OpenRecordset(vrsTopic, "SELECT * FROM topic", dbOpenSnapshot)) Then
        Call getnexttopic
    End If
End Sub

Private Sub getnexttopic()
    Dim exitloop As Boolean
    vFinished = False
    If (vAction = "ReadThreads") Then
        If (vrsTopic.EOF = False) Then
            lblBR.Caption = "": lblStat.ForeColor = vbRed
            Inet1.URL = "http://www.hollyoaks.com/members/forum/tree.asp?TPID=" & vrsTopic!Number
            Inet1.Execute , aCmd
            vrsTopic.MoveNext
        Else
            vrsTopic.Close
            If (OpenRecordset(vrsThreads, "SELECT * FROM thread WHERE ReadReplys=True", dbOpenSnapshot)) Then
                If (vrsThreads.EOF = False) Then
                    vAction = "ReadReplys"
                
                    vCurrentThreadNumber = vrsThreads!threadnumber
                    vCurrentTopicNumber = vrsThreads!topicnumber
                    lblBR.Caption = "": lblStat.ForeColor = vbRed
                    'ShowConversation.asp?STHID=792&TPID=11
                    Inet1.URL = "http://www.hollyoaks.com/members/forum/ShowConversation.asp?STHID=" & vrsThreads!threadnumber & "&TPID=" & vrsThreads!topicnumber
                    Inet1.Execute , aCmd
                    vrsThreads.MoveNext
                Else
                    lblStat.Caption = "Finished downloading articles"
                    Call FRMHollyView.Show
                    Call Unload(Me)
                    vFinished = True
                End If
            End If
        End If
    Else
        If (vAction = "ReadReplys") Then
            If (vrsThreads.EOF = False) Then
                exitloop = False
'                Do While (vrsThreads.EOF = False And exitloop = False)
                    If (vrsThreads!ReadReplys = True) Then
                        vCurrentThreadNumber = vrsThreads!threadnumber
                        vCurrentTopicNumber = vrsThreads!topicnumber
                        lblBR.Caption = "": lblStat.ForeColor = vbRed
                        'ShowConversation.asp?STHID=792&TPID=11
                        Inet1.URL = "http://www.hollyoaks.com/members/forum/ShowConversation.asp?STHID=" & vrsThreads!threadnumber & "&TPID=" & vrsThreads!topicnumber
                        Inet1.Execute , aCmd
                        exitloop = True
                    End If
                    
'                Loop
            End If
            
            If (vrsThreads.EOF = True) Then
                lblStat.Caption = "Finished downloading articles"
                Call FRMHollyView.Show
                Call Unload(Me)
                vFinished = True
            Else
                vrsThreads.MoveNext
            End If
        End If
    End If
End Sub


Private Function GetDatac22() As String
    Dim vData As Variant
    Dim adata As String
    Do
        vData = Inet1.GetChunk(512, icString)
        DoEvents
        If Len(vData) = 0 Then Exit Do
        adata = adata & vData
    Loop
    GetDatac22 = adata
End Function

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
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
                Case "LIST"
                    Call GetDatac2(adata)
                    Text1.Text = adata
                    If (vAction = "ReadThreads") Then
                        Call LookForConversations(adata)
                    Else
                        If (vAction = "ReadReplys") Then
                            Call ReadThread(adata)
                        Else
                        End If
                    End If
                    Call getnexttopic
                Case "GET"
                Case "PUT"
            End Select
            If (vFinished = False) Then
                Screen.MousePointer = vbDefault
            End If
            Exit Sub
    End Select
    lblStat.Caption = aStat
End Sub

Private Function FindTerminator(pSearchString As String) As Long

    Dim i As Long
    Dim OpenCount As Long
    
    OpenCount = 0
    FindTerminator = 0
    For i = 1 To Len(pSearchString)
        If (Mid$(pSearchString, i, 1) = "<") Then
            OpenCount = OpenCount + 1
        End If
        If (Mid$(pSearchString, i, 1) = ">") Then
            OpenCount = OpenCount - 1
            If (OpenCount < 0) Then
                FindTerminator = i
                Exit For
            End If
        End If
    Next
End Function

Private Function ConvertHTMLToText(pString As String) As String
    '&lt;' are '<'
    '&gt;' are '>'
    ConvertHTMLToText = Replace(pString, "&lt;", "<")
    ConvertHTMLToText = Replace(ConvertHTMLToText, "&gt;", ">")
End Function

Private Function ReadThread(pThreadtext As String) As Boolean

    Dim username As String
    Dim i As Long
    Dim tempstring As String
    Dim rstemp As Recordset
    Dim threaddate As Date
    Dim Message As String
    Dim CurrentThreadnumber As Long
    
    
    Dim replyUsername As String
    Dim replydate As Date
    Dim replyBody As String
    Dim prevdate As Date
    Dim writedate As Date
    
'vrsThreads!threadnumber & "&TPID=" & vrsThreads!topicnumber
    If (OpenRecordset(rstemp, "SELECT * FROM Thread WHERE Threadnumber=" & vCurrentThreadNumber & " AND Topicnumber=" & vCurrentTopicNumber, dbOpenDynaset)) Then
        If (rstemp.EOF = False) Then
            
' get username
            If (InStr(tempstring, ">This is an official Hollyoaks posting, and you cannot reply.<") > 0) Then
                ' special post, different structure
                i = i
            Else
            Const namesearch As String = "From:"
            i = InStr(pThreadtext, namesearch)
            If (i <> 0) Then
                tempstring = Mid$(pThreadtext, i)
                i = InStr(tempstring, "color")
                tempstring = Mid$(tempstring, i)
                i = InStr(tempstring, ">")
                tempstring = Mid$(tempstring, i)
                username = Mid$(tempstring, 2, InStr(tempstring, "<") - 2)
    ' get date
                i = InStr(pThreadtext, "Date:")
                tempstring = Mid$(pThreadtext, i)
                i = InStr(tempstring, "color")
                tempstring = Mid$(tempstring, i)
                i = InStr(tempstring, ">")
                tempstring = Mid$(tempstring, i)
                threaddate = Mid$(tempstring, 2, InStr(tempstring, "<") - 2)
    ' get message body
                i = InStr(pThreadtext, "Message:")
                tempstring = Mid$(pThreadtext, i)
                i = InStr(tempstring, "color")
                tempstring = Mid$(tempstring, i)
                i = InStr(tempstring, ">")
                tempstring = Mid$(tempstring, i)
                Message = Mid$(tempstring, 2, InStr(tempstring, "</font") - 2) 'InStr(tempstring, "<") - 2)
    
                rstemp.Edit
                CurrentThreadnumber = rstemp!threadnumber
                rstemp!threadusername = username
                rstemp!threaddate = threaddate
                rstemp!threadmessage = Message
                rstemp!ReadReplys = False
                rstemp.Update
                rstemp.Close
    ' locate replays, complex cause there isn't much unique stuff, to locate them
                i = InStr(tempstring, ">NAME<")
                
                If (i = 0) Then
                    ' no replys to this thread yet
                Else
                
                    tempstring = Mid$(tempstring, i)
                    i = InStr(tempstring, ">REPLY<")
                    tempstring = Mid$(tempstring, i)
                    
                    
                    
                    i = InStr(tempstring, "<tr>")
                    ' ok, first things first, sort into ascending order
                    replyBody = Mid$(tempstring, i)
                    i = InStr(4, replyBody, "<tr>")
                    tempstring = ""
                    Do While (i > 0)
                        tempstring = Mid$(replyBody, 1, i - 1) & tempstring
                        replyBody = Mid$(replyBody, i)
                        i = InStr(4, replyBody, "<tr>")
                    Loop
                    tempstring = replyBody & tempstring
                    
                    
                    i = InStr(tempstring, "<tr>")
                    prevdate = "01/01/1900"
                    If (OpenRecordset(rstemp, "SELECT * FROM reply WHERE Threadnumber=" & CurrentThreadnumber, dbOpenDynaset)) Then
                        Do While (rstemp.EOF = False)
                            If (rstemp!replydate > prevdate) Then
                                prevdate = DateAdd("n", 1, rstemp!replydate)
                                
                            End If
                            Call rstemp.MoveNext
                        Loop
                    End If
                    Call Execute("UPDATE reply SET old=true WHERE Threadnumber=" & CurrentThreadnumber, True)
                        Do While (i > 0)
                    
                        'look for start block '<tr>'
                        tempstring = Mid$(tempstring, i)
                        
                        i = InStr(tempstring, "Sans-serif" & Chr$(34) & ">") + 9
                        tempstring = Mid$(tempstring, i)
                        replyUsername = Mid$(tempstring, 5, InStr(tempstring, "<") - 5)
                        
                        i = InStr(tempstring, "Sans-serif" & Chr$(34) & ">") + 9
                        tempstring = Mid$(tempstring, i)
                        replydate = Mid$(tempstring, 5, InStr(tempstring, "<") - 5)
                        
                        ' check date to ensure correct order
                        Do While (replydate <= prevdate)
                            replydate = DateAdd("n", 1, replydate)
                        Loop
                        prevdate = replydate
                        
                        i = InStr(tempstring, "Sans-serif" & Chr$(34) & ">") + 9
                        tempstring = Mid$(tempstring, i)
                        replyBody = Mid$(tempstring, 5, InStr(tempstring, "</td") - 5)
                        replyBody = Replace(replyBody, "</font>", "")
                        If (OpenRecordset(rstemp, "SELECT * FROM reply WHERE Threadnumber=" & CurrentThreadnumber & " AND ReplyUserName='" & replyUsername & "' AND ReplyDescription='" & ProcessString(replyBody) & "'", dbOpenDynaset)) Then
                            If (rstemp.EOF = False) Then
                                rstemp.Edit
                                rstemp!old = False
                                rstemp.Update
                            Else
                                rstemp.AddNew
                                rstemp!replyUsername = replyUsername
                                rstemp!replydate = replydate
                                rstemp!replydescription = Replace(replyBody, Chr$(124), "")
                                rstemp!threadnumber = CurrentThreadnumber
                                rstemp!topicnumber = vCurrentTopicNumber
                                rstemp!newreply = True
                                rstemp.Update
                                Call Execute("UPDATE thread SET read=false WHERE Threadnumber=" & CurrentThreadnumber)
                            End If
                            rstemp.Close
                        End If
                    
                        i = InStr(tempstring, "<tr>")
                    Loop
                End If
                
                End If
            End If
        Else
        End If
    End If

End Function

Private Function LookForConversations(pSearchText As String) As Boolean
    Dim leftpos As Long
    Dim tempstring As String
    Dim threadnumber As Long
    Dim topicnumber As Long
    Dim ThreadSubject As String
    Dim rstemp As Recordset
    Dim NumberOfReplys As Long
    Const lookkey As String = "ShowConversation.asp"

    tempstring = pSearchText
    leftpos = InStr(tempstring, lookkey)
    Do While (leftpos > 0)
        tempstring = Mid$(tempstring, leftpos + 27)
        threadnumber = Left$(tempstring, InStr(tempstring, "&") - 1)
        tempstring = Mid$(tempstring, InStr(tempstring, "&") + 6)
        topicnumber = Left$(tempstring, InStr(tempstring, Chr$(34)) - 1)
        If (topicnumber = 9) Then
            ThreadSubject = ThreadSubject
        End If
        ThreadSubject = Mid$(tempstring, 20 + Len(topicnumber & ""), InStr(tempstring, "</a>") - (20 + Len(topicnumber & "")))
        leftpos = InStr(tempstring, lookkey)
        NumberOfReplys = Val(Mid$(tempstring, InStr(tempstring, "(") + 1, 5))
        

        If (OpenRecordset(rstemp, "SELECT * FROM Thread WHERE Threadnumber=" & threadnumber & " AND Topicnumber=" & topicnumber, dbOpenDynaset)) Then
            If (rstemp.EOF = False) Then
                rstemp.Edit
                rstemp!ThreadSubject = ThreadSubject
                rstemp!threadnumber = threadnumber
                rstemp!topicnumber = topicnumber
                If (rstemp!NumberOfReplys < NumberOfReplys) Then
                    rstemp!ReadReplys = True
                End If
                rstemp!NumberOfReplys = NumberOfReplys
                rstemp!old = False
                rstemp.Update
            Else
                rstemp.AddNew
                rstemp!ThreadSubject = ThreadSubject
                rstemp!threadnumber = threadnumber
                rstemp!topicnumber = topicnumber
                rstemp!NumberOfReplys = NumberOfReplys
                rstemp!ReadReplys = True
                rstemp!read = False
                rstemp!old = False
                rstemp.Update
            End If
            rstemp.Close
        End If
    Loop
End Function
