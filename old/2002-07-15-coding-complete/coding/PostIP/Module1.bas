Attribute VB_Name = "Module1"
Option Explicit
        
'**************************************
'Windows API/Global Declarations for :De
'     tect if there is a Dial up network conne
'     ction
'**************************************
' Registry APIs.
Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_PERFORMANCE_DATA = &H80000004
Public Const HKEY_CURRENT_CONFIG = &H80000005
Public Const HKEY_DYN_DATA = &H80000006
Public Const ERROR_SUCCESS = 0&
Public Const APINULL = 0&
Public Const MAX_STRING_LENGTH As Integer = 256


Declare Function RegOpenKey Lib "advapi32.dll" Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long


Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
    ' RegQueryValueEx: If you declare the lp
    '     Data parameter as String, you must
    'pass it By Value.


Declare Function RegQueryValueEx Lib "advapi32.dll" Alias _
    "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal _
    lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
    ' Remote Access Services (RAS) APIs.
    Public Const RAS_MAXENTRYNAME As Integer = 256
    Public Const RAS_MAXDEVICETYPE As Integer = 16
    Public Const RAS_MAXDEVICENAME As Integer = 128
    Public Const RAS_RASCONNSIZE As Integer = 412


Public Type RasEntryName
    dwSize As Long
    szEntryName(RAS_MAXENTRYNAME) As Byte
    End Type


Public Type RasConn
    dwSize As Long
    hRasConn As Long
    szEntryName(RAS_MAXENTRYNAME) As Byte
    szDeviceType(RAS_MAXDEVICETYPE) As Byte
    szDeviceName(RAS_MAXDEVICENAME) As Byte
    End Type


Public Declare Function RasEnumConnections Lib "rasapi32.dll" Alias "RasEnumConnectionsA" (lpRasConn As Any, lpcb As Long, lpcConnections As Long) As Long


Public Declare Function RasHangUp Lib "rasapi32.dll" Alias "RasHangUpA" (ByVal hRasConn As Long) As Long
    Public gstrISPName As String
    Public ReturnCode As Long
                        
 
'Source Code:
'Can 't Copy and Paste this?
'Click here for a copy-and-paste friendly version of this code!


            
'**************************************
' Name: Detect if there is a Dial up net
'     work connection
' Description:Here is how I detect if th
'     ere is a DUN (ISP) connection. You want
'     to take a look at the Remote Access Serv
'     ices (RAS) APIs. They are
'fully documented at the Microsoft site."J Gerard Olszowiec" entity@ns.sympatico.ca
' By: Newsgroup Posting
'
'
' Inputs:None
'
' Returns:None
'
'Assumes:None
'
'Side Effects:None
'
'Warranty:
'Code provided by Planet Source Code(tm)
'     (http://www.Planet-Source-Code.com) 'as
'     is', without warranties as to performanc
'     e, fitness, merchantability,and any othe
'     r warranty (whether expressed or implied
'     ).
'Terms of Agreement:
'By using this source code, you agree to
'     the following terms...
' 1) You may use this source code in per
'     sonal projects and may compile it into a
'     n .exe/.dll/.ocx and distribute it in bi
'     nary format freely and with no charge.
' 2) You MAY NOT redistribute this sourc
'     e code (for example to a web site) witho
'     ut written permission from the original
'     author.Failure to do so is a violation o
'     f copyright laws.
' 3) You may link to this code from anot
'     her website, provided it is not wrapped
'     in a frame.
' 4) The author of this code may have re
'     tained certain additional copyright righ
'     ts.If so, this is indicated in the autho
'     r's description.
'**************************************



Public Function Connected_To_ISP() As Boolean
    Dim hKey As Long
    Dim lpSubKey As String
    Dim phkResult As Long
    Dim lpValueName As String
    Dim lpReserved As Long
    Dim lpType As Long
    Dim lpData As Long
    Dim lpcbData As Long
    Connected_To_ISP = False
    lpSubKey = "System\CurrentControlSet\Services\RemoteAccess"
    ReturnCode = RegOpenKey(HKEY_LOCAL_MACHINE, lpSubKey, phkResult)


    If ReturnCode = ERROR_SUCCESS Then
        hKey = phkResult
        lpValueName = "Remote Connection"
        lpReserved = APINULL
        lpType = APINULL
        lpData = APINULL
        lpcbData = APINULL
        ReturnCode = RegQueryValueEx(hKey, lpValueName, lpReserved, lpType, ByVal lpData, lpcbData)
        lpcbData = Len(lpData)
        ReturnCode = RegQueryValueEx(hKey, lpValueName, lpReserved, lpType, lpData, lpcbData)


        If ReturnCode = ERROR_SUCCESS Then


            If lpData = 0 Then
                ' Not Connected
            Else
                ' Connected
                Connected_To_ISP = True
            End If
        End If
        RegCloseKey (hKey)
    End If
End Function
'> 2) Once I determine that I'd like To disconnect, How Do I do
'> that? It seems like I need some interface To DUN to Do it.
'Use RasHangUp. In this example I display a splash screen (frmHangupSplash)


'While the hangup is In progress. You'll want To Set gstrISPName =    Get_ISP_Name() before calling HangUp(), or better yet modify HangUP and
'    pass the DUN connection name (the ISP) as a parameter..


Public Sub HangUp()
    Dim i As Long
    Dim lpRasConn(255) As RasConn
    Dim lpcb As Long
    Dim lpcConnections As Long
    Dim hRasConn As Long
    frmHangupSplash.Show
    frmHangupSplash.Refresh
    lpRasConn(0).dwSize = RAS_RASCONNSIZE
    lpcb = RAS_MAXENTRYNAME * lpRasConn(0).dwSize
    lpcConnections = 0
    ReturnCode = RasEnumConnections(lpRasConn(0), lpcb, lpcConnections)
    ' Drop ALL the connections that match th
    '     e currect
    ' connections name.


    If ReturnCode = ERROR_SUCCESS Then


        For i = 0 To lpcConnections - 1
            If Trim(ByteToString(lpRasConn(i).szEntryName)) = Trim(gstrISPName) Then
            hRasConn = lpRasConn(i).hRasConn
            ReturnCode = RasHangUp(ByVal hRasConn)
        End If
    Next i
End If
' It takes about 3 seconds to drop the c
'     onnection.
Wait (3)


While Connected_To_ISP
    Wait (1)
Wend
Unload frmHangupSplash
End Sub


Public Sub Wait(sngSeconds As Single)
    Dim sngEndTime As Single
    sngEndTime = Timer + sngSeconds


    While Timer < sngEndTime


        DoEvents
        Wend
    End Sub


Public Function Get_ISP_Name() As String
    Dim hKey As Long
    Dim lpSubKey As String
    Dim phkResult As Long
    Dim lpValueName As String
    Dim lpReserved As Long
    Dim lpType As Long
    Dim lpData As String
    Dim lpcbData As Long
    Get_ISP_Name = ""


    If gblnConnectedToISP Then
        lpSubKey = "RemoteAccess"
        ReturnCode = RegOpenKey(HKEY_CURRENT_USER, lpSubKey, phkResult)


        If ReturnCode = ERROR_SUCCESS Then
            hKey = phkResult
            lpValueName = "Default"
            lpReserved = APINULL
            lpType = APINULL
            lpData = APINULL
            lpcbData = APINULL
            ReturnCode = RegQueryValueEx(hKey, lpValueName, lpReserved, lpType, ByVal lpData, lpcbData)
            lpData = String(lpcbData, 0)
            ReturnCode = RegQueryValueEx(hKey, lpValueName, lpReserved, lpType, ByVal lpData, lpcbData)


            If ReturnCode = ERROR_SUCCESS Then
                ' Chop off the end-of-string character.
                Get_ISP_Name = Left(lpData, lpcbData - 1)
            End If
            RegCloseKey (hKey)
        End If
    End If
End Function
'***************************************
'     ************************************
' Name: ByteToString
' ' Description:* * * THIS IS A FOLLOWUP


'     SUBMISSION * * *
'    Purpose: Convert a String in Byte format (usually from a DLL call) To a string of text.
'    PLEASE POST THIS AS A FOLLOWUP OR ADD To THE CODE SAMPLE TITLED "Detect If there is a Dial up network connection" attributed to me J Gerard Olszowiec, entity@ns.sympatico.ca. The newsgroup post that you captured had a followup post that included the ByteToString code. I've been receiving requets For this functions code. Much Thanx. - Gerard
    ' By: Entity Software
    '
    ' Inputs:None
    ' Returns:None
    ' Assumes:None
    ' Side Effects:None
    '
    'Code provided by Planet Source Code(tm)
    'as is', without
    ' warranties as to performance, fitness,
    '     merchantability,
    ' and any other warranty (whether expres
    '     sed or implied).
    '***************************************
    '     ************************************


Public Function ByteToString(bytString() As Byte) As String
    ' ' Convert a string in byte format (usu
    '     ally from a DLL call)
    ' ' to a string of text.
    Dim i As Integer
    ByteToString = ""
    i = 0


'    While bytString(i)0 &
'    ByteToString = ByteToString & Chr(bytString(i))
'        i = i + 1
'    Wend
End Function



 
 

