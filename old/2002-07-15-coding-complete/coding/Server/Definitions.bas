Attribute VB_Name = "Definitions"
Option Explicit

'blt constants
Public Const SRCCOPY = &HCC0020 ' (DWORD) dest = source

Public Const DIB_PAL_COLORS = 1 '  color table in palette indices
Public Const DIB_PAL_INDICES = 2 '  No color table indices into surf palette
Public Const DIB_PAL_LOGINDICES = 4 '  No color table indices into DC palette
Public Const DIB_PAL_PHYSINDICES = 2 '  No color table indices into surf palette
Public Const DIB_RGB_COLORS = 0 '  color table in RGBs

' Send mouse operations
Public Const MOUSEEVENTF_LEFTDOWN = &H2  'Specifies that the left button was pressed.
Public Const MOUSEEVENTF_LEFTUP = &H4 'Specifies that the left button was released.
Public Const MOUSEEVENTF_RIGHTDOWN = &H8 'Specifies that the right button was pressed.
Public Const MOUSEEVENTF_RIGHTUP = &H10 'Specifies that the right button was released.
Public Const MOUSEEVENTF_MIDDLEDOWN = &H20 'Specifies that the middle button was pressed.
Public Const MOUSEEVENTF_MIDDLEUP = &H40 ' Specifies that the middle button was released.


Public db As Database
Public wrkJet As Workspace
Public CurrentForm As Object
Public oComm1 As Object


Public Type POINTAPI
        X As Long
        Y As Long
End Type

Public Type MSEV        '8+16=24 bytes
        pt As POINTAPI
        mousedata As Long
        flags As Long
        time As Long
        dwExtraInfo As Long
End Type

Public Type BITMAPINFOHEADER '40 bytes
        biSize As Long
        biWidth As Long
        biHeight As Long
        biPlanes As Integer
        biBitCount As Integer
        biCompression As Long
        biSizeImage As Long
        biXPelsPerMeter As Long
        biYPelsPerMeter As Long
        biClrUsed As Long
        biClrImportant As Long
End Type

Public Type RGBQUAD
        rgbBlue As Byte
        rgbGreen As Byte
        rgbRed As Byte
        rgbReserved As Byte
End Type

Public Type BITMAPINFO
        bmiHeader As BITMAPINFOHEADER
        bmiColors As RGBQUAD
End Type


Public Type Size
        cx As Long
        cy As Long
End Type



Public MouseCoords As POINTAPI
Public MouseButton As Long

'Public Declare Function GetCapture Lib "user32" () As Long
'Public Declare Function GetCursor Lib "user32" () As Long
'Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function GetDesktopWindow Lib "user32" () As Long
'Public Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
'Public Declare Function GetDeviceGammaRamp Lib "gdi32" (ByVal hdc As Long, lpv As Any) As Long
'Public Declare Function GetDIBColorTable Lib "gdi32" (ByVal hdc As Long, ByVal un1 As Long, ByVal un2 As Long, pRGBQuad As RGBQUAD) As Long
'Public Declare Function GetGraphicsMode Lib "gdi32" (ByVal hdc As Long) As Long
'Public Declare Function GetInputState Lib "user32" () As Long
'Public Declare Function GetKeyboardState Lib "user32" (pbKeyState As Byte) As Long
'Public Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
'Public Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
'Public Declare Function GetViewportExtEx Lib "gdi32" (ByVal hdc As Long, lpSize As Size) As Long
'Public Declare Function GetViewportOrgEx Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI) As Long
Public Declare Function GetWindowDC Lib "user32" (ByVal hwnd As Long) As Long

Public Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

Public Declare Function SetCursorPos Lib "user32" (ByVal X As Long, ByVal Y As Long) As Long

Public Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, ByRef lpBits As Any, lpBI As BITMAPINFO, ByVal wUsage As Long) As Long

Public Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long

Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long

Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Public Declare Sub mouse_event Lib "user32" (ByVal dwflags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)

Public Declare Sub MouseEventEx Lib "user32" (ByRef pEvents() As MSEV, ByVal nEvents As Long, ByVal cbSize As Long, ByVal dwflags As Long)

Public Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
Public Declare Function CreateDIBSection Lib "gdi32" (ByVal hdc As Long, pBitmapInfo As BITMAPINFO, ByVal un As Long, ByRef lplpVoid As Any, ByVal handle As Long, ByVal dw As Long) As Long


Public Declare Function GetBitmapBits Lib "gdi32" (ByVal hBitmap As Long, ByVal dwCount As Long, lpBits As Any) As Long
Public Declare Function GetBitmapDimensionEx Lib "gdi32" (ByVal hBitmap As Long, lpDimension As Size) As Long



