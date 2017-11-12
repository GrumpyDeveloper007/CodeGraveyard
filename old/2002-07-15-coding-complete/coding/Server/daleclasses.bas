Attribute VB_Name = "Module1"
Public ValA As Long
Public ValB As Long
Public Quit As Long

' Send mouse operations
Public Const MOUSEEVENTF_LEFTDOWN = &H2  'Specifies that the left button was pressed.
Public Const MOUSEEVENTF_LEFTUP = &H4 'Specifies that the left button was released.
Public Const MOUSEEVENTF_RIGHTDOWN = &H8 'Specifies that the right button was pressed.
Public Const MOUSEEVENTF_RIGHTUP = &H10 'Specifies that the right button was released.
Public Const MOUSEEVENTF_MIDDLEDOWN = &H20 'Specifies that the middle button was pressed.
Public Const MOUSEEVENTF_MIDDLEUP = &H40 ' Specifies that the middle button was released.

Public Declare Sub mouse_event Lib "user32" (ByVal dwflags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)
Public Declare Function SetCursorPos Lib "user32" (ByVal X As Long, ByVal Y As Long) As Long

