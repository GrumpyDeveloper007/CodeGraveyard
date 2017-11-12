Attribute VB_Name = "Functions"
Option Explicit
Dim NumberOfDataItems As Long
Public LastPacketType As Long
Dim DataItems(10) As Variant
Dim DataItemCount As Long
Public Type TCPHeader
    HeaderID As Long
    PacketType As Long
    DataItems As Long
End Type


    Dim dest(2000& * 2000 * 4) As Byte
    Dim bitmapptr(4) As Long
Public Function BlitScreen(DestinationPicture As PictureBox) As Long
    Dim hfail As Long
    Dim hwind As Long
    Dim pixel As Long, X As Long, Y As Long
    Dim pict() As Byte
    Dim i As Long
    hwind = GetDesktopWindow()
    Dim hdc As Long, proghdc As Long
    Dim Bitmaphandle As Long
    Dim bbitmapinfo As BITMAPINFO
    Dim ptr As Long
    Dim lsize As Size
    ptr = dest()
    bbitmapinfo.bmiHeader.biBitCount = 24
    bbitmapinfo.bmiHeader.biCompression = 0
    bbitmapinfo.bmiHeader.biPlanes = 1
    bbitmapinfo.bmiHeader.biWidth = 1152
    bbitmapinfo.bmiHeader.biHeight = 864
    bbitmapinfo.bmiHeader.biSize = 40
    bbitmapinfo.bmiHeader.biSizeImage = 1152& * 864
    hdc = GetWindowDC(hwind)
'    proghdc = CreateCompatibleDC(0)
'    Bitmaphandle = CreateCompatibleBitmap(proghdc, 800, 600)
 lsize.cx = i
 lsize.cy = i
    hfail = BitBlt(DestinationPicture.hdc, 0, 0, 800, 600, hdc, 0, 0, SRCCOPY)
'    hfail = GetBitmapDimensionEx(hwind, lsize)
    hfail = GetBitmapBits(DestinationPicture.Image.handle, 800& * 600, dest(0))
    hfail = GetDIBits(DestinationPicture.hdc, DestinationPicture.Image.handle, 0, 599, dest(0), bbitmapinfo, DIB_RGB_COLORS)
    'hfail = CreateDIBSection(DestinationPicture.hDC, bbitmapinfo, DIB_PAL_COLORS, pict, 0, 0)
    
'    Call destinationPicture.Refresh
    Call ReleaseDC(hwind, hdc)
End Function

Public Function PacketRecieved()
    Select Case LastPacketType
        Case 1
'                Call tcpClient.GetData(strData)
                CurrentForm.TxtOutput.Text = DataItems(0)
                'Call Shell(strData, vbNormalFocus)
        Case 2
'                Call tcpClient.GetData(strData)
            CurrentForm.TxtAlbums.Text = DataItems(0)
            CurrentForm.TxtSongs.Text = ""
        Case 3
 '               Call tcpClient.GetData(strData)
            CurrentForm.TxtSongs.Text = DataItems(0)
        Case 4
            Call CurrentForm.Hide
        Case 5
            Call CurrentForm.Show
                'connect ack request
'                Call tcpClient.SendData(PacketType)
'                Call tcpClient.SendData(ClientName)
        Case 8 'terminate
            Call CurrentForm.Kill
            End
        Case 7 'connect ack recieve
 '               Call tcpClient.GetData(strData)
'            CurrentForm.FrmState.Caption = "Connection State - " & strData
        Case 9
            Dim points As POINTAPI
'            Call tcpClient.GetData(MouseCurrentX)
        Case 10
'                Call tcpClient.GetData(MouseCurrentY)
'            Call SetCursorPos(receiveLong(0), receiveLong(1))
    '        FrmStatus.LblStatus2.Caption = "Status - x:" & receiveLong(0) & ",y:" & receiveLong(1)
        Case 11         ' left press
'            FrmStatus.LblStatus2.Caption = "PRESS"
            Call mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
        Case 12         ' left depress
 '           FrmStatus.LblStatus2.Caption = "DE-PRESS"
            Call mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    End Select

End Function

Public Function ProcessPacket2(TCPControl As Winsock, ByteTotal As Long) As Long

    Dim strData As String
    Dim PacketType As Long
    Dim lheader As TCPHeader
    Dim ldata As String
    Dim ldata2(1) As Long
'    If (NumberOfDataItemsLeft = 0) Then
    Call GetHeader(TCPControl, lheader)
    If (lheader.HeaderID = 1) Then
        If (LastPacketType > 1) Then        ' data packet type
            Call PacketRecieved
        End If
        LastPacketType = lheader.PacketType
        NumberOfDataItems = lheader.DataItems
        DataItemCount = 0
    Else
        Select Case lheader.HeaderID
            Case 2              ' string param
                Call TCPControl.PeekData(ldata)
                DataItems(DataItemCount) = Right(ldata, ByteTotal - 4)
                DataItemCount = DataItemCount + 1
            Case 3              ' long param
                Call TCPControl.PeekData(ldata)
                DataItems(DataItemCount) = Right(ldata, ByteTotal - 4)
                DataItemCount = DataItemCount + 1
            Case 4              ' byte array param
                Call TCPControl.PeekData(ldata)
                DataItems(DataItemCount) = Right(ldata, ByteTotal - 4)
                DataItemCount = DataItemCount + 1
        End Select
    End If
    
    If (NumberOfDataItems = DataItemCount) Then
        Call PacketRecieved
    End If
    Dim dd As String
    Call TCPControl.GetData(dd)
End Function


Public Function SendHeader(TCPControl As Winsock, pHeader As TCPHeader)
    Dim Header(11) As Byte
    Dim b1 As Long
    Dim b2 As Long
    Dim b3 As Long
    Dim b4 As Long
    Dim c As Long
    b1 = &HFF000000
    b2 = &HFF0000
    b3 = 255& * 256&
    b4 = &HFF
    c = pHeader.DataItems
    Header(0) = (pHeader.HeaderID And b1) / 16777216
    Header(1) = (pHeader.HeaderID And b2) / 65536
    Header(2) = (pHeader.HeaderID And b3) / 256
    Header(3) = (pHeader.HeaderID And b4)
    Header(4) = (pHeader.PacketType And b1) / 16777216
    Header(5) = (pHeader.PacketType And b2) / 65536
    Header(6) = (pHeader.PacketType And b3) / 256
    Header(7) = (pHeader.PacketType And b4)
    Header(8) = (pHeader.DataItems And b1) / 16777216
    Header(9) = (pHeader.DataItems And b2) / 65536
    Header(10) = (c And b3) / 256
    Header(11) = (pHeader.DataItems And b4)
    
    Call TCPControl.SendData(Header)
'    Call TCPControl.GetData(TCPHeader)
End Function

Public Function GetHeader(TCPControl As Winsock, ByRef pHeader As TCPHeader)
    Dim Header(11) As Byte
    Dim mystring As String
    Dim b(2) As Long
    Dim c(6) As Integer
    Dim i As Long
    On Error Resume Next

    Call TCPControl.PeekData(mystring)
    For i = 0 To 11
        Header(i) = AscB(Mid$(mystring, i + 1, 1))
    Next
'    i = TCPControl.BytesReceived
    pHeader.HeaderID = Header(0) * 16777216 + Header(1) * 65536 + Header(2) * 255 + Header(3)
    pHeader.PacketType = Header(4) * 16777216 + Header(5) * 65536 + Header(6) * 255 + Header(7)
    pHeader.DataItems = Header(8) * 16777216 + Header(9) * 65536 + Header(10) * 255 + Header(11)
    
'    Call TCPControl.GetData(TCPHeader)
End Function

Public Function sendString(TCPControl As Winsock, pString As String) As Long
    Dim Param() As Byte, i As Long
    ReDim Param(Len(pString) + 4) As Byte
    Dim PacketType As Long
    PacketType = 2
    Param(0) = (PacketType And &HFF000000) / 16777216
    Param(1) = (PacketType And &HFF0000) / 65536
    Param(2) = (PacketType And &HFF00) / 255
    Param(3) = (PacketType And &HFF)
    For i = 0 To Len(pString) - 1
        Param(i + 4) = Asc(Mid$(pString, i + 1, 1))
    Next
    
    Call TCPControl.SendData(Param)
End Function

Public Function receiveLong(index As Long) As Long
    receiveLong = AscB(Mid$(DataItems(index), 1, 1)) * 16777216 + AscB(Mid$(DataItems(index), 2, 1)) * 65536 + AscB(Mid$(DataItems(index), 3, 1)) * 256 + AscB(Mid$(DataItems(index), 4, 1))
End Function


Public Function Sendlong(TCPControl As Winsock, pLong As Long) As Long
    Dim Param(8) As Byte, i As Long
    Dim PacketType As Long
    PacketType = 3
    Param(0) = (PacketType And &HFF000000) / 16777216
    Param(1) = (PacketType And &HFF0000) / 65536
    Param(2) = (PacketType And &HFF00) / 255
    Param(3) = (PacketType And &HFF)
    Param(4) = (pLong And &HFF000000) / 16777216
    Param(5) = (pLong And &HFF0000) / 65536
    Param(6) = (pLong And &HFF00) / 255
    Param(7) = (pLong And &HFF)
    
    Call TCPControl.SendData(Param)
End Function

Public Function SendBytes(TCPControl As Winsock, pByte() As Byte, pLength As Long) As Long
    Dim Param() As Byte, i As Long
    ReDim Param(pLength + 4) As Byte
    Dim PacketType As Long
    PacketType = 4
    Param(0) = (PacketType And &HFF000000) / 16777216
    Param(1) = (PacketType And &HFF0000) / 65536
    Param(2) = (PacketType And &HFF00) / 255
    Param(3) = (PacketType And &HFF)
    For i = 0 To pLength
        Param(i + 4) = pByte(i)
    Next
    
    Call TCPControl.SendData(Param)
End Function

