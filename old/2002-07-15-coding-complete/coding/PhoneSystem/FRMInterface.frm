VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form FRMInterface 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Interface"
   ClientHeight    =   2115
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10965
   HelpContextID   =   5
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   2115
   ScaleWidth      =   10965
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   9840
      TabIndex        =   1
      Top             =   1680
      Width           =   1095
   End
   Begin VB.TextBox TXTOutput2 
      Height          =   735
      Left            =   0
      TabIndex        =   0
      Top             =   780
      Width           =   6615
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   6840
      Top             =   1380
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      Handshaking     =   2
      RThreshold      =   1
   End
End
Attribute VB_Name = "FRMInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Interface Object
''
''

Private Const cInterfaceLineLength As Long = 80
Private Const cInterfaceLineLengthTotal As Long = 82
Private vIsLoaded As Boolean
Private vBuffer As String
Private vCallsClass As New ClassCalls
Private vLastInterfaceID As Long

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

''
Private Sub ProcessLine(pString As String)
    Dim details As TransactionDetailsTYPE
    Dim rstemp As Recordset
    Dim LineName As String
    Dim ExtensionName As String
    Dim PhoneName As String
    Dim CallID As Long
    
    details = ProcessPhoneSystemString(pString)
    If (details.lineNumber > 0) Then
            LineName = details.lineNumber
            If (OpenRecordset(rstemp, "SELECT * FROM lines WHERE UID=" & details.lineNumber, dbOpenSnapshot)) Then
                If (rstemp.EOF = False) Then
                    LineName = details.lineNumber & " (" & rstemp!Name & ")"
                End If
            End If
            ExtensionName = details.ExtensionNumber
            If (OpenRecordset(rstemp, "SELECT * FROM Extensions WHERE UID=" & details.ExtensionNumber, dbOpenSnapshot)) Then
                If (rstemp.EOF = False) Then
                    ExtensionName = details.ExtensionNumber & " (" & rstemp!Name & ")"
                End If
            End If
            
            PhoneName = details.PhoneNumber
            If (OpenRecordset(rstemp, "SELECT * FROM Numbers WHERE PhoneNumber='" & details.PhoneNumber & "'", dbOpenSnapshot)) Then
                If (rstemp.EOF = False) Then
                    PhoneName = details.PhoneNumber & " (" & rstemp!Name & ")"
                End If
            End If
            
        CallID = vCallsClass.CreateFromTYPE(details.CallDate, details.ExtensionNumber, details.lineNumber, details.PhoneNumber, details.Duration, details.ContinuedCall, details.Direction, details.AnswerTime, details.UnanseredCall)
    End If
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub Form_Load()
    Dim rstemp As Recordset
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Dim i As Long
    Dim tempstring As String
'    i = FreeFile
'    Open "d:\dale.txt" For Input As #i
'    Line Input #i, tempstring
'    Close #i
    
'    Call ProcessLine(tempstring)
    MSComm1.CommPort = RemoveNonNumericCharacters(GetServerSetting("PORT"))
    MSComm1.Settings = GetServerSetting("LINESPEED") & "," & UCase$(Left$(GetServerSetting("PARITY"), 1)) & "," & GetServerSetting("DATABITS") & "," & GetServerSetting("STOPBITS")

    MSComm1.PortOpen = True
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Dim rstemp As Recordset
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
    MSComm1.PortOpen = False
End Sub

''
Private Sub MSComm1_OnComm()

    Select Case MSComm1.CommEvent
    ' Handle each event or error by placing
    ' code below each case statement

    ' Errors
        Case comEventBreak          ' A Break was received.
        Case comEventFrame          ' Framing Error
        Case comEventOverrun        ' Data Lost.
        Case comEventRxOver         ' Receive buffer overflow.
        Case comEventRxParity       ' Parity Error.
        Case comEventTxFull         ' Transmit buffer full.
        Case comEventDCB            ' Unexpected error retrieving DCB]

    ' Events
        Case comEvCD        ' Change in the CD line.
        Case comEvCTS       ' Change in the CTS line.
        Case comEvDSR       ' Change in the DSR line.
        Case comEvRing      ' Change in the Ring Indicator.
        Case comEvReceive   ' Received RThreshold # of chars.
            vBuffer = vBuffer & MSComm1.Input
            If (InStr(vBuffer, vbLf) > 0) Then
'            If (Len(vBuffer) >= cInterfaceLineLength) Then
                If (InStr(vBuffer, vbLf) >= cInterfaceLineLengthTotal) Then
                   Call ProcessLine(Mid$(vBuffer, InStr(vBuffer, vbLf) - (cInterfaceLineLengthTotal - 1), cInterfaceLineLength))
                Else
                End If
                vBuffer = ""
                'Right$(vBuffer, Len(vBuffer) - InStr(vBuffer, vbCr) + 1)
            End If
            'TXTOutput.Text = vBuffer
    
        Case comEvSend  ' There are SThreshold number of characters in the transmit buffer.
        Case comEvEOF   ' An EOF charater was found in the input stream
    End Select
End Sub

