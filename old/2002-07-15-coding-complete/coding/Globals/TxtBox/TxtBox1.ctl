VERSION 5.00
Begin VB.UserControl TxtBox1 
   ClientHeight    =   1815
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3225
   ScaleHeight     =   1815
   ScaleWidth      =   3225
   ToolboxBitmap   =   "TxtBox1.ctx":0000
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   1335
   End
End
Attribute VB_Name = "TxtBox1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'' used in user defined controls (TxtBox)
Public Enum NavigationENUM
    NAVNONE = 0
    NAVEnter = 1
    NAVCursor = 2
    NAVCursorEnter = 3
End Enum

''API
Private Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer

''

Private vNavigationMode As NavigationENUM
Private vMask As String
Private vUpperCase As Boolean
Private vAutoCase As Boolean
Private vAutoSelect As Boolean
Private vPreventLoop As Boolean
'Default Property Values:
Const m_def_TabEnter = 0
Const m_def_BackStyle = 0
'Property Variables:
Dim m_TabEnter As Boolean
Dim m_BackStyle As Integer
'Event Declarations:
Event Click() 'MappingInfo=Text1,Text1,-1,Click
Attribute Click.VB_Description = "Occurs when the user presses and then releases a mouse button over an object."
Event DblClick() 'MappingInfo=Text1,Text1,-1,DblClick
Attribute DblClick.VB_Description = "Occurs when the user presses and releases a mouse button and then presses and releases it again over an object."
Event KeyDown(KeyCode As Integer, Shift As Integer) 'MappingInfo=Text1,Text1,-1,KeyDown
Attribute KeyDown.VB_Description = "Occurs when the user presses a key while an object has the focus."
Event KeyPress(KeyAscii As Integer) 'MappingInfo=Text1,Text1,-1,KeyPress
Attribute KeyPress.VB_Description = "Occurs when the user presses and releases an ANSI key."
Event KeyUp(KeyCode As Integer, Shift As Integer) 'MappingInfo=Text1,Text1,-1,KeyUp
Attribute KeyUp.VB_Description = "Occurs when the user releases a key while an object has the focus."
Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseDown
Attribute MouseDown.VB_Description = "Occurs when the user presses the mouse button while an object has the focus."
Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseMove
Attribute MouseMove.VB_Description = "Occurs when the user moves the mouse."
Event MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,MouseUp
Attribute MouseUp.VB_Description = "Occurs when the user releases the mouse button while an object has the focus."
Event WriteProperties(PropBag As PropertyBag)
Attribute WriteProperties.VB_Description = "Occurs when a user control or user document is asked to write its data to a file."
Event Change() 'MappingInfo=Text1,Text1,-1,Change
Attribute Change.VB_Description = "Occurs when the contents of a control have changed."
'Event OLECompleteDrag(Effect As Long) 'MappingInfo=Text1,Text1,-1,OLECompleteDrag
'Event OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single) 'MappingInfo=Text1,Text1,-1,OLEDragDrop
'Event OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer) 'MappingInfo=Text1,Text1,-1,OLEDragOver
'Event OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean) 'MappingInfo=Text1,Text1,-1,OLEGiveFeedback
'Event OLESetData(Data As DataObject, DataFormat As Integer) 'MappingInfo=Text1,Text1,-1,OLESetData
'Event OLEStartDrag(Data As DataObject, AllowedEffects As Long) 'MappingInfo=Text1,Text1,-1,OLEStartDrag
Event Validate(Cancel As Boolean) 'MappingInfo=Text1,Text1,-1,Validate
Attribute Validate.VB_Description = "Occurs when a control loses focus to a control that causes validation."

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' My functions -

''
Private Function AutoCaseString(pString As String) As String
    Dim Uppercase As Boolean
    Dim i As Long
    Dim char As String
    Uppercase = True
    AutoCaseString = ""
    For i = 1 To Len(pString)
        char = Mid$(pString, i, 1)
        If (Uppercase = True) Then
            AutoCaseString = AutoCaseString & UCase$(char)
            Uppercase = False
        Else
            AutoCaseString = AutoCaseString & LCase$(char)
        End If
        If (char = Chr$(32) Or char = ".") Then
            Uppercase = True
        End If
    Next
End Function


'' process a char, if invalid them returns false
Private Function IsValidChar(pChar As String, pMask As String) As Boolean
    If (pMask = "#") Then
        IsValidChar = IsNumeric(pChar)
    Else
        If (pMask = "&") Then
            IsValidChar = True
        Else
            If (pMask = pChar) Then
                IsValidChar = True
            Else
                IsValidChar = False
            End If
        End If
    End If
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color used to display text and graphics in an object."
    BackColor = Text1.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    Text1.BackColor() = New_BackColor
    PropertyChanged "BackColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Returns/sets the foreground color used to display text and graphics in an object."
    ForeColor = Text1.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    Text1.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
    Enabled = Text1.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    Text1.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Returns a Font object."
Attribute Font.VB_UserMemId = -512
    Set Font = Text1.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
    Set Text1.Font = New_Font
    PropertyChanged "Font"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=7,0,0,0
Public Property Get BackStyle() As Integer
Attribute BackStyle.VB_Description = "Indicates whether a Label or the background of a Shape is transparent or opaque."
    BackStyle = m_BackStyle
End Property

Public Property Let BackStyle(ByVal New_BackStyle As Integer)
    m_BackStyle = New_BackStyle
    PropertyChanged "BackStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,BorderStyle
Public Property Get BorderStyle() As Integer
Attribute BorderStyle.VB_Description = "Returns/sets the border style for an object."
    BorderStyle = Text1.BorderStyle
End Property

Public Property Let BorderStyle(ByVal New_BorderStyle As Integer)
    Text1.BorderStyle() = New_BorderStyle
    PropertyChanged "BorderStyle"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Refresh
Public Sub Refresh()
Attribute Refresh.VB_Description = "Forces a complete repaint of a object."
    Text1.Refresh
End Sub

Private Sub Text1_Click()
    RaiseEvent Click
End Sub

Private Sub Text1_DblClick()
    RaiseEvent DblClick
End Sub

Private Sub Text1_GotFocus()
    If (vAutoSelect = True) Then
        Text1.SelStart = 0
        Text1.SelLength = Len(Text1.Text)
    End If
End Sub

Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)
    If (KeyCode = 38 Or KeyCode = 40) Then
        Select Case vNavigationMode
            Case NAVNONE, NAVEnter
                RaiseEvent KeyDown(KeyCode, Shift)
            Case NAVCursorEnter, NAVCursor
                If (KeyCode = 40) Then
                    Call SendKeys(Chr$(9)) '"+{TAB}"
                Else
                    Call SendKeys("+{TAB}") '
                End If
                KeyCode = 0
            Case Else
                ' error
        End Select
    Else
        RaiseEvent KeyDown(KeyCode, Shift)
    End If
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
    Dim i As Long
    vPreventLoop = True
    If (KeyAscii = 13) Then
        Select Case vNavigationMode
            Case NAVNONE, NAVCursor
                RaiseEvent KeyPress(KeyAscii)
            Case NAVEnter, NAVCursorEnter
                KeyAscii = 0
                Call SendKeys(Chr$(9)) '"+{TAB}"
            Case Else
                ' error
        End Select
    Else
        'mask
        If (vMask = "" Or KeyAscii = 8) Then
            RaiseEvent KeyPress(KeyAscii)
        Else
            If (Len(vMask) > Len(Text1.Text)) Then
                If (IsValidChar(Chr$(KeyAscii), Mid$(vMask, Len(Text1.Text) + 1, 1))) Then
                    RaiseEvent KeyPress(KeyAscii)
'                    i = Len(Text1.Text) + 2
'                    Do While (Ismaskchar(Mid$(vMask, i, 1)))
'
'                    Loop
                Else
                    KeyAscii = 0
                End If
            Else
                If (Text1.SelLength > 0) Then
                    If (IsValidChar(Chr$(KeyAscii), Mid$(vMask, Text1.SelStart + 1, 1))) Then
                        RaiseEvent KeyPress(KeyAscii)
                    Else
                        KeyAscii = 0
                    End If
                Else
                    KeyAscii = 0
                End If
            End If
        End If
    End If
    
    If (vUpperCase = True) Then
        KeyAscii = Asc(UCase$(Chr$(KeyAscii)))
    End If
    vPreventLoop = False
End Sub

Private Sub Text1_KeyUp(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub Text1_LostFocus()
    Dim retval As Integer
    If (AutoCase = True) Then
        Text1.Text = AutoCaseString(Text1.Text)
    End If
    retval = GetKeyState(vbKeyTab)
    If retval < 0 Then
        ' tab pressed
        If (m_TabEnter = True And vPreventLoop = False) Then
            RaiseEvent KeyPress(13)
        End If
'        retval = GetKeyState(vbKeyShift)
'        If retval < 0 Then
'            Debug.Print "Shift and Tab was pressed in Text1"
'            WhichIndex = ActiveControl.Index
'        End If
    End If

End Sub

Private Sub Text1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseDown(Button, Shift, X, Y)
End Sub

Private Sub Text1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseMove(Button, Shift, X, Y)
End Sub

Private Sub Text1_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    RaiseEvent MouseUp(Button, Shift, X, Y)
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Alignment
Public Property Get Alignment() As Integer
Attribute Alignment.VB_Description = "Returns/sets the alignment of a CheckBox or OptionButton, or a control's text."
    Alignment = Text1.Alignment
End Property

Public Property Let Alignment(ByVal New_Alignment As Integer)
    Text1.Alignment() = New_Alignment
    PropertyChanged "Alignment"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Appearance
Public Property Get Appearance() As Integer
Attribute Appearance.VB_Description = "Returns/sets whether or not an object is painted at run time with 3-D effects."
    Appearance = Text1.Appearance
End Property

Public Property Let Appearance(ByVal New_Appearance As Integer)
    Text1.Appearance() = New_Appearance
    PropertyChanged "Appearance"
End Property

Private Sub Text1_Change()
    RaiseEvent Change
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,CausesValidation
Public Property Get CausesValidation() As Boolean
Attribute CausesValidation.VB_Description = "Returns/sets whether validation occurs on the control which lost focus."
    CausesValidation = Text1.CausesValidation
End Property

Public Property Let CausesValidation(ByVal New_CausesValidation As Boolean)
    Text1.CausesValidation() = New_CausesValidation
    PropertyChanged "CausesValidation"
End Property
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MappingInfo=Text1,Text1,-1,DataFormat
'Public Property Get DataFormat() As Object 'IStdDataFormatDisp
'    Set DataFormat = Text1.DataFormat
'End Property
'
'Public Property Set DataFormat(ByVal New_DataFormat As Object) 'IStdDataFormatDisp
'    Set Text1.DataFormat = New_DataFormat
'    PropertyChanged "DataFormat"
'End Property
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MappingInfo=Text1,Text1,-1,DataMember
'Public Property Get DataMember() As String
'    DataMember = Text1.DataMember
'End Property
'
'Public Property Let DataMember(ByVal New_DataMember As String)
'    Text1.DataMember() = New_DataMember
'    PropertyChanged "DataMember"
'End Property
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MappingInfo=Text1,Text1,-1,DataSource
'Public Property Get DataSource() As Object 'DataSource
'    Set DataSource = Text1.DataSource
'End Property
'
'Public Property Set DataSource(ByVal New_DataSource As Object) 'DataSource
'    Set Text1.DataSource = New_DataSource
'    PropertyChanged "DataSource"
'End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,HideSelection
Public Property Get HideSelection() As Boolean
Attribute HideSelection.VB_Description = "Specifies whether the selection in a Masked edit control is hidden when the control loses focus."
    HideSelection = Text1.HideSelection
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,LinkItem
Public Property Get LinkItem() As String
Attribute LinkItem.VB_Description = "Returns/sets the data passed to a destination control in a DDE conversation with another application."
    LinkItem = Text1.LinkItem
End Property

Public Property Let LinkItem(ByVal New_LinkItem As String)
    Text1.LinkItem() = New_LinkItem
    PropertyChanged "LinkItem"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,LinkMode
Public Property Get LinkMode() As Integer
Attribute LinkMode.VB_Description = "Returns/sets the type of link used for a DDE conversation and activates the connection."
    LinkMode = Text1.LinkMode
End Property

Public Property Let LinkMode(ByVal New_LinkMode As Integer)
    Text1.LinkMode() = New_LinkMode
    PropertyChanged "LinkMode"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,LinkTimeout
Public Property Get LinkTimeout() As Integer
Attribute LinkTimeout.VB_Description = "Returns/sets the amount of time a control waits for a response to a DDE message."
    LinkTimeout = Text1.LinkTimeout
End Property

Public Property Let LinkTimeout(ByVal New_LinkTimeout As Integer)
    Text1.LinkTimeout() = New_LinkTimeout
    PropertyChanged "LinkTimeout"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,LinkTopic
Public Property Get LinkTopic() As String
Attribute LinkTopic.VB_Description = "Returns/sets the source application and topic for a destination control."
    LinkTopic = Text1.LinkTopic
End Property

Public Property Let LinkTopic(ByVal New_LinkTopic As String)
    Text1.LinkTopic() = New_LinkTopic
    PropertyChanged "LinkTopic"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Locked
Public Property Get Locked() As Boolean
Attribute Locked.VB_Description = "Determines whether a control can be edited."
    Locked = Text1.Locked
End Property

Public Property Let Locked(ByVal New_Locked As Boolean)
    Text1.Locked() = New_Locked
    PropertyChanged "Locked"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,MaxLength
Public Property Get MaxLength() As Long
Attribute MaxLength.VB_Description = "Returns/sets the maximum number of characters that can be entered in a control."
    MaxLength = Text1.MaxLength
End Property

Public Property Let MaxLength(ByVal New_MaxLength As Long)
    Text1.MaxLength() = New_MaxLength
    PropertyChanged "MaxLength"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,MouseIcon
Public Property Get MouseIcon() As Picture
Attribute MouseIcon.VB_Description = "Sets a custom mouse icon."
    Set MouseIcon = Text1.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
    Set Text1.MouseIcon = New_MouseIcon
    PropertyChanged "MouseIcon"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,MousePointer
Public Property Get MousePointer() As Integer
Attribute MousePointer.VB_Description = "Returns/sets the type of mouse pointer displayed when over part of an object."
    MousePointer = Text1.MousePointer
End Property

Public Property Let MousePointer(ByVal New_MousePointer As Integer)
    Text1.MousePointer() = New_MousePointer
    PropertyChanged "MousePointer"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,MultiLine
Public Property Get MultiLine() As Boolean
Attribute MultiLine.VB_Description = "Returns/sets a value that determines whether a control can accept multiple lines of text."
    MultiLine = Text1.MultiLine
End Property
'
''Public Property Let MultiLine(ByVal NewValue As Boolean)
''    Text1.MultiLine = NewValue
''    PropertyChanged "MultiLine"
''End Property
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MappingInfo=Text1,Text1,-1,OLEDragMode
'Public Property Get OLEDragMode() As Integer
'    OLEDragMode = Text1.OLEDragMode
'End Property
'
'Public Property Let OLEDragMode(ByVal New_OLEDragMode As Integer)
'    Text1.OLEDragMode() = New_OLEDragMode
'    PropertyChanged "OLEDragMode"
'End Property
'
''WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
''MappingInfo=Text1,Text1,-1,OLEDropMode
'Public Property Get OLEDropMode() As Integer
'    OLEDropMode = Text1.OLEDropMode
'End Property
'
'Public Property Let OLEDropMode(ByVal New_OLEDropMode As Integer)
'    Text1.OLEDropMode() = New_OLEDropMode
'    PropertyChanged "OLEDropMode"
'End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,PasswordChar
Public Property Get PasswordChar() As String
Attribute PasswordChar.VB_Description = "Returns/sets a value that determines whether characters typed by a user or placeholder characters are displayed in a control."
    PasswordChar = Text1.PasswordChar
End Property

Public Property Let PasswordChar(ByVal New_PasswordChar As String)
    Text1.PasswordChar() = New_PasswordChar
    PropertyChanged "PasswordChar"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,RightToLeft
Public Property Get RightToLeft() As Boolean
Attribute RightToLeft.VB_Description = "Determines text display direction and control visual appearance on a bidirectional system."
    RightToLeft = Text1.RightToLeft
End Property

Public Property Let RightToLeft(ByVal New_RightToLeft As Boolean)
    Text1.RightToLeft() = New_RightToLeft
    PropertyChanged "RightToLeft"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,ScrollBars
Public Property Get ScrollBars() As Integer
Attribute ScrollBars.VB_Description = "Returns/sets a value indicating whether an object has vertical or horizontal scroll bars."
    ScrollBars = Text1.ScrollBars
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,Text
Public Property Get Text() As String
Attribute Text.VB_Description = "Returns/sets the text contained in the control."
    Text = Text1.Text
End Property

Public Property Let Text(ByVal New_Text As String)
    Text1.Text() = New_Text
    PropertyChanged "Text"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,ToolTipText
Public Property Get ToolTipText() As String
Attribute ToolTipText.VB_Description = "Returns/sets the text displayed when the mouse is paused over the control."
    ToolTipText = Text1.ToolTipText
End Property

Public Property Let ToolTipText(ByVal New_ToolTipText As String)
    Text1.ToolTipText() = New_ToolTipText
    PropertyChanged "ToolTipText"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=Text1,Text1,-1,WhatsThisHelpID
Public Property Get WhatsThisHelpID() As Long
Attribute WhatsThisHelpID.VB_Description = "Returns/sets an associated context number for an object."
    WhatsThisHelpID = Text1.WhatsThisHelpID
End Property

Public Property Let WhatsThisHelpID(ByVal New_WhatsThisHelpID As Long)
    Text1.WhatsThisHelpID() = New_WhatsThisHelpID
    PropertyChanged "WhatsThisHelpID"
End Property
'
'Private Sub Text1_OLECompleteDrag(Effect As Long)
'    RaiseEvent OLECompleteDrag(Effect)
'End Sub
'
'Private Sub Text1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
'    RaiseEvent OLEDragDrop(Data, Effect, Button, Shift, X, Y)
'End Sub
'
'Private Sub Text1_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
'    RaiseEvent OLEDragOver(Data, Effect, Button, Shift, X, Y, State)
'End Sub
'
'Private Sub Text1_OLEGiveFeedback(Effect As Long, DefaultCursors As Boolean)
'    RaiseEvent OLEGiveFeedback(Effect, DefaultCursors)
'End Sub
'
'Private Sub Text1_OLESetData(Data As DataObject, DataFormat As Integer)
'    RaiseEvent OLESetData(Data, DataFormat)
'End Sub
'
'Private Sub Text1_OLEStartDrag(Data As DataObject, AllowedEffects As Long)
'    RaiseEvent OLEStartDrag(Data, AllowedEffects)
'End Sub

Private Sub Text1_Validate(Cancel As Boolean)
'    RaiseEvent Validate(Cancel)
End Sub


'Initialize Properties for User Control
Private Sub UserControl_InitProperties()
    Call UserControl_Resize
    m_BackStyle = m_def_BackStyle
    m_TabEnter = m_def_TabEnter
End Sub

'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

    Text1.BackColor = PropBag.ReadProperty("BackColor", &H80000005)
    Text1.ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
    Text1.Enabled = PropBag.ReadProperty("Enabled", True)
    Set Text1.Font = PropBag.ReadProperty("Font", Ambient.Font)
    m_BackStyle = PropBag.ReadProperty("BackStyle", m_def_BackStyle)
    Text1.BorderStyle = PropBag.ReadProperty("BorderStyle", 1)
    Text1.Alignment = PropBag.ReadProperty("Alignment", 0)
    Text1.Appearance = PropBag.ReadProperty("Appearance", 1)
    Text1.CausesValidation = PropBag.ReadProperty("CausesValidation", True)
'    Set DataFormat = PropBag.ReadProperty("DataFormat", Nothing)
'    Text1.DataMember = PropBag.ReadProperty("DataMember", "")
'    Set DataSource = PropBag.ReadProperty("DataSource", Nothing)
    Text1.LinkItem = PropBag.ReadProperty("LinkItem", "")
    Text1.LinkMode = PropBag.ReadProperty("LinkMode", 0)
    Text1.LinkTimeout = PropBag.ReadProperty("LinkTimeout", 50)
    Text1.LinkTopic = PropBag.ReadProperty("LinkTopic", "")
    Text1.Locked = PropBag.ReadProperty("Locked", False)
    Text1.MaxLength = PropBag.ReadProperty("MaxLength", 0)
    Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
    Text1.MousePointer = PropBag.ReadProperty("MousePointer", 0)
    'Text1.MultiLine = PropBag.ReadProperty("MultiLine", 0)
'    Text1.OLEDragMode = PropBag.ReadProperty("OLEDragMode", 0)
'    Text1.OLEDropMode = PropBag.ReadProperty("OLEDropMode", 0)
    Text1.PasswordChar = PropBag.ReadProperty("PasswordChar", "")
    Text1.RightToLeft = PropBag.ReadProperty("RightToLeft", False)
    Text1.Text = PropBag.ReadProperty("Text", "Text1")
    Text1.ToolTipText = PropBag.ReadProperty("ToolTipText", "")
    Text1.WhatsThisHelpID = PropBag.ReadProperty("WhatsThisHelpID", 0)
    vNavigationMode = PropBag.ReadProperty("NavigationMode", 3)
    vMask = PropBag.ReadProperty("Mask", "")
    vUpperCase = PropBag.ReadProperty("UpperCase", False)
    vAutoCase = PropBag.ReadProperty("AutoCase", False)
    vAutoSelect = PropBag.ReadProperty("AutoSelect", False)
    m_TabEnter = PropBag.ReadProperty("TabEnter", m_def_TabEnter)
End Sub

Private Sub UserControl_Resize()
    Text1.Width = UserControl.Width '- UserControl.ScaleX(1, vbPixels, UserControl.ScaleMode)
    Text1.Height = UserControl.Height ' - UserControl.ScaleY(1, vbPixels, UserControl.ScaleMode)
    UserControl.Width = Text1.Width
    UserControl.Height = Text1.Height
End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("BackColor", Text1.BackColor, &H80000005)
    Call PropBag.WriteProperty("ForeColor", Text1.ForeColor, &H80000008)
    Call PropBag.WriteProperty("Enabled", Text1.Enabled, True)
    Call PropBag.WriteProperty("Font", Text1.Font, Ambient.Font)
    Call PropBag.WriteProperty("BackStyle", m_BackStyle, m_def_BackStyle)
    Call PropBag.WriteProperty("BorderStyle", Text1.BorderStyle, 1)
    Call PropBag.WriteProperty("Alignment", Text1.Alignment, 0)
    Call PropBag.WriteProperty("Appearance", Text1.Appearance, 1)
    Call PropBag.WriteProperty("CausesValidation", Text1.CausesValidation, True)
'    Call PropBag.WriteProperty("DataFormat", DataFormat, Nothing)
'    Call PropBag.WriteProperty("DataMember", Text1.DataMember, "")
'    Call PropBag.WriteProperty("DataSource", DataSource, Nothing)
    Call PropBag.WriteProperty("LinkItem", Text1.LinkItem, "")
    Call PropBag.WriteProperty("LinkMode", Text1.LinkMode, 0)
    Call PropBag.WriteProperty("LinkTimeout", Text1.LinkTimeout, 50)
    Call PropBag.WriteProperty("LinkTopic", Text1.LinkTopic, "")
    Call PropBag.WriteProperty("Locked", Text1.Locked, False)
    Call PropBag.WriteProperty("MaxLength", Text1.MaxLength, 0)
    Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)
    Call PropBag.WriteProperty("MousePointer", Text1.MousePointer, 0)
    'Call PropBag.WriteProperty("MultiLine", Text1.MultiLine, 0)
'    Call PropBag.WriteProperty("OLEDragMode", Text1.OLEDragMode, 0)
'    Call PropBag.WriteProperty("OLEDropMode", Text1.OLEDropMode, 0)
    Call PropBag.WriteProperty("PasswordChar", Text1.PasswordChar, "")
    Call PropBag.WriteProperty("RightToLeft", Text1.RightToLeft, False)
    Call PropBag.WriteProperty("Text", Text1.Text, "Text1")
    Call PropBag.WriteProperty("ToolTipText", Text1.ToolTipText, "")
    Call PropBag.WriteProperty("WhatsThisHelpID", Text1.WhatsThisHelpID, 0)
    Call PropBag.WriteProperty("NavigationMode", vNavigationMode, 3)
    Call PropBag.WriteProperty("Mask", vMask, "")
    Call PropBag.WriteProperty("UpperCase", vUpperCase, False)
    Call PropBag.WriteProperty("AutoCase", vAutoCase, False)
    Call PropBag.WriteProperty("AutoSelect", vAutoSelect, False)
    Call PropBag.WriteProperty("TabEnter", m_TabEnter, m_def_TabEnter)
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Property Let NavigationMode(pMode As NavigationENUM)
Attribute NavigationMode.VB_Description = "Determines the effect of the enter and cursor keys"
    vNavigationMode = pMode
End Property

Public Property Get NavigationMode() As NavigationENUM
    NavigationMode = vNavigationMode
End Property

Public Property Let Mask(pMask As String)
Attribute Mask.VB_Description = "Simple mask field"
    vMask = pMask
End Property

Public Property Get Mask() As String
    Mask = vMask
End Property

Public Property Let Uppercase(pUpperCase As Boolean)
Attribute Uppercase.VB_Description = "Automatically sets text to uppercase"
    vUpperCase = pUpperCase
End Property

Public Property Get Uppercase() As Boolean
    Uppercase = vUpperCase
End Property

Public Property Let AutoCase(pAutoCase As Boolean)
Attribute AutoCase.VB_Description = "Will automatically set first character of every word to upper case and all other characters to lower case"
    vAutoCase = pAutoCase
End Property

Public Property Get AutoCase() As Boolean
    AutoCase = vAutoCase
End Property

Public Property Let AutoSelect(pAutoSelect As Boolean)
Attribute AutoSelect.VB_Description = "Hightlight all text on got focus"
    vAutoSelect = pAutoSelect
End Property

Public Property Get AutoSelect() As Boolean
    AutoSelect = vAutoSelect
End Property

'Private Sub SetNextTabIndex()
'    Dim ThisIndex As Long
'    Dim i As Long
'    ThisIndex = TxtBox1.TabIndex + 1
'    For i = 0 To TxtBox1.Parent.Controls.Count
'        If (TxtBox1.Parent.Controls(i).TabIndex = ThisIndex) Then
'            TxtBox1.Parent.Controls(i).SetFocus
'            Exit For
'        End If
'    Next
'End Sub

'Private Sub Text2_GotFocus()
'    Call Text1_KeyPress(13)
'    Call SetNextTabIndex
'End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=0,0,0,0
Public Property Get TabEnter() As Boolean
    TabEnter = m_TabEnter
End Property

Public Property Let TabEnter(ByVal New_TabEnter As Boolean)
    m_TabEnter = New_TabEnter
    PropertyChanged "TabEnter"
End Property

