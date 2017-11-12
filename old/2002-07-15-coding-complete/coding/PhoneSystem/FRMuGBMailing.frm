VERSION 5.00
Object = "{8DDE6232-1BB0-11D0-81C3-0080C7A2EF7D}#2.1#0"; "FLP32X20.OCX"
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Begin VB.Form FRMuGBMailing 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Caption Here>"
   ClientHeight    =   4800
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6975
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   4800
   ScaleWidth      =   6975
   Begin LpLib.fpList GRDAddresses 
      Height          =   4065
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   6915
      _Version        =   131073
      _ExtentX        =   12197
      _ExtentY        =   7170
      _StockProps     =   68
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Text            =   ""
      Columns         =   1
      Sorted          =   0
      SelDrawFocusRect=   -1  'True
      ColumnSeparatorChar=   9
      ColumnSearch    =   -1
      ColumnWidthScale=   0
      RowHeight       =   -1
      MultiSelect     =   0
      WrapList        =   0   'False
      WrapWidth       =   0
      SelMax          =   -1
      AutoSearch      =   2
      SearchMethod    =   2
      VirtualMode     =   0   'False
      VRowCount       =   0
      DataSync        =   3
      ThreeDInsideStyle=   1
      ThreeDInsideHighlightColor=   -2147483633
      ThreeDInsideShadowColor=   -2147483642
      ThreeDInsideWidth=   1
      ThreeDOutsideStyle=   1
      ThreeDOutsideHighlightColor=   16777215
      ThreeDOutsideShadowColor=   -2147483632
      ThreeDOutsideWidth=   1
      ThreeDFrameWidth=   0
      BorderStyle     =   0
      BorderColor     =   -2147483642
      BorderWidth     =   1
      ThreeDOnFocusInvert=   0   'False
      ThreeDFrameColor=   -2147483633
      Appearance      =   0
      BorderDropShadow=   0
      BorderDropShadowColor=   -2147483632
      BorderDropShadowWidth=   3
      ScrollHScale    =   2
      ScrollHInc      =   0
      ColsFrozen      =   0
      ScrollBarV      =   2
      NoIntegralHeight=   0   'False
      HighestPrecedence=   0
      AllowColResize  =   0
      AllowColDragDrop=   0
      ReadOnly        =   0   'False
      VScrollSpecial  =   0   'False
      VScrollSpecialType=   0
      EnableKeyEvents =   -1  'True
      EnableTopChangeEvent=   -1  'True
      DataAutoHeadings=   -1  'True
      DataAutoSizeCols=   2
      SearchIgnoreCase=   -1  'True
      ColDesigner     =   "FRMuGBMailing.frx":0000
      ScrollBarH      =   3
      DataFieldList   =   ""
      ColumnEdit      =   0
      ColumnBound     =   0
      Style           =   0
      MaxDrop         =   0
      ListWidth       =   0
      EditHeight      =   0
      GrayAreaColor   =   0
      ListLeftOffset  =   0
      ComboGap        =   0
      MaxEditLen      =   0
      VirtualPageSize =   0
      VirtualPagesAhead=   0
      ExtendCol       =   0
      ColumnLevels    =   1
      ListGrayAreaColor=   -2147483637
      GroupHeaderHeight=   -1
      GroupHeaderShow =   -1  'True
      AllowGrpResize  =   0
      AllowGrpDragDrop=   0
      MergeAdjustView =   0   'False
      ColumnHeaderShow=   -1  'True
      ColumnHeaderHeight=   -1
      GrpsFrozen      =   0
      BorderGrayAreaColor=   -2147483637
      ExtendRow       =   0
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   5760
      TabIndex        =   1
      Top             =   4320
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDCommit 
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   4320
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "C&ommit"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
End
Attribute VB_Name = "FRMuGBMailing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' GBMailing Class
''
'' Coded by Dale Pitman

''Declare the functions required by GBmailing
Private Declare Function GBOpen Lib "gbhltv32.dll" Alias "_GBOpen@0" () As Integer
Private Declare Function GBClose Lib "gbhltv32.dll" Alias "_GBClose@0" () As Integer
Private Declare Function GBGetAddress Lib "gbhltv32.dll" Alias "_GBGetAddress@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetAddressFromDPS Lib "gbhltv32.dll" Alias "_GBGetAddressFromDPS@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetAddressFromAKey Lib "gbhltv32.dll" Alias "_GBGetAddressFromAKey@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetAKeyFromDPS Lib "gbhltv32.dll" Alias "_GBGetAKeyFromDPS@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetError Lib "gbhltv32.dll" Alias "_GBGetError@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBPostcodeAddress Lib "gbhltv32.dll" Alias "_GBPostcodeAddress@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer

Private Declare Function GBGetNext Lib "gbhltv32.dll" Alias "_GBGetNext@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetPrevious Lib "gbhltv32.dll" Alias "_GBGetPrevious@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBUpdatePassword Lib "gbhltv32.dll" Alias "_GBUpdatePassword@8" (ByVal szUserBuff As String, ByVal iBuffLen As Integer) As Integer

' HLT GetInformation() type functions
' -----------------------------------
Private Declare Function GBGetAbbrCounty Lib "gbhltv32.dll" Alias "_GBGetAbbrCounty@8" (ByVal szAbbrCounty As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetAddressKey Lib "gbhltv32.dll" Alias "_GBGetAddressKey@8" (ByVal szAddressKey As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetBuilding Lib "gbhltv32.dll" Alias "_GBGetBuilding@8" (ByVal szBuilding As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetCountry Lib "gbhltv32.dll" Alias "_GBGetCountry@8" (ByVal szCountry As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetCounty Lib "gbhltv32.dll" Alias "_GBGetCounty@8" (ByVal szCounty As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetCountyRequired Lib "gbhltv32.dll" Alias "_GBGetCountyRequired@8" (ByVal szCntyReq As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDefine Lib "gbhltv32.dll" Alias "_GBGetDefine@8" (ByVal szDefine As String, ByVal iBuffLen As Integer) As Integer

Private Declare Function GBGetDepartment Lib "gbhltv32.dll" Alias "_GBGetDepartment@8" (ByVal szDepartment As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDepLocality Lib "gbhltv32.dll" Alias "_GBGetDepLocality@8" (ByVal szDLocality As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDepThorofare Lib "gbhltv32.dll" Alias "_GBGetDepThorofare@8" (ByVal szDThorofare As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDHACode Lib "gbhltv32.dll" Alias "_GBGetDHACode@8" (ByVal szDHACode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDoubleLocality Lib "gbhltv32.dll" Alias "_GBGetDoubleLocality@8" (ByVal szDDLocality As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetDPS Lib "gbhltv32.dll" Alias "_GBGetDPS@8" (ByVal szDPS As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetEasting Lib "gbhltv32.dll" Alias "_GBGetEasting@8" (ByVal szEasting As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetEstGridRef Lib "gbhltv32.dll" Alias "_GBGetEstGridRef@8" (ByVal szEstGridRef As String, ByVal iBuffLen As Integer) As Integer

Private Declare Function GBGetHLTVersion Lib "gbhltv32.dll" Alias "_GBGetHLTVersion@8" (ByVal szHltVer As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetLocality Lib "gbhltv32.dll" Alias "_GBGetLocality@8" (ByVal szLocality As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetLocalityDetails Lib "gbhltv32.dll" Alias "_GBGetLocalityDetails@8" (ByVal szFullLoc As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetLAAreaCode Lib "gbhltv32.dll" Alias "_GBGetLAAreaCode@8" (ByVal szLAAreaCode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetLACode Lib "gbhltv32.dll" Alias "_GBGetLACode@8" (ByVal szLACode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetLAWardCode Lib "gbhltv32.dll" Alias "_GBGetLAWardCode@8" (ByVal szLAWardCode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetMailSort Lib "gbhltv32.dll" Alias "_GBGetMailSort@8" (ByVal szMailSort As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetMosaic Lib "gbhltv32.dll" Alias "_GBGetMosaic@8" (ByVal szMosaic As String, ByVal iBuffLen As Integer) As Integer

Private Declare Function GBGetNHSCode Lib "gbhltv32.dll" Alias "_GBGetNHSCode@8" (ByVal szNHSCode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetNHSRegion Lib "gbhltv32.dll" Alias "_GBGetNHSRegion@8" (ByVal szNHSRegion As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetNorthing Lib "gbhltv32.dll" Alias "_GBGetNorthing@8" (ByVal szNorthing As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetOldMailSort Lib "gbhltv32.dll" Alias "_GBGetOldMailSort@8" (ByVal szOldMailSort As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetOrganisation Lib "gbhltv32.dll" Alias "_GBGetOrganisation@8" (ByVal szOrganisation As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetPAFVersion Lib "gbhltv32.dll" Alias "_GBGetPAFVersion@8" (ByVal szPafVer As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetPOBox Lib "gbhltv32.dll" Alias "_GBGetPOBox@8" (ByVal szPoBox As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetPostcode Lib "gbhltv32.dll" Alias "_GBGetPostcode@8" (ByVal szPostcode As String, ByVal iBuffLen As Integer) As Integer

Private Declare Function GBGetSecurityCode Lib "gbhltv32.dll" Alias "_GBGetSecurityCode@8" (ByVal szSecCode As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetSubBuilding Lib "gbhltv32.dll" Alias "_GBGetSubBuilding@8" (ByVal szSubBuilding As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetThorofare Lib "gbhltv32.dll" Alias "_GBGetThorofare@8" (ByVal szThorofare As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetThorofareDetails Lib "gbhltv32.dll" Alias "_GBGetThorofareDetails@8" (ByVal szFullTho As String, ByVal iBuffLen As Integer) As Integer
Private Declare Function GBGetToolsVersion Lib "gbhltv32.dll" Alias "_GBGetToolsVersion@8" (ByVal szToolsVer As String, ByVal iBuffLen As Integer) As Integer
'
' HLT Set functions
' -----------------
Private Declare Function GBSetAddressCase Lib "gbhltv32.dll" Alias "_GBSetAddressCase@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetBuildingRange Lib "gbhltv32.dll" Alias "_GBSetBuildingRange@4" (ByVal szOption As String) As Integer

Private Declare Function GBSetDataFileType Lib "gbhltv32.dll" Alias "_GBSetDataFileType@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetDllLevel Lib "gbhltv32.dll" Alias "_GBSetDllLevel@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetInAddressFmt Lib "gbhltv32.dll" Alias "_GBSetInAddressFmt@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetInDelimiter Lib "gbhltv32.dll" Alias "_GBSetInDelimiter@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetInFmtStyle Lib "gbhltv32.dll" Alias "_GBSetInFmtStyle@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetListSorted Lib "gbhltv32.dll" Alias "_GBSetListSorted@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetMaxElements Lib "gbhltv32.dll" Alias "_GBSetMaxElements@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetNoStreetInd Lib "gbhltv32.dll" Alias "_GBSetNoStreetInd@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetOutDelimiter Lib "gbhltv32.dll" Alias "_GBSetOutDelimiter@4" (ByVal szOption As String) As Integer

Private Declare Function GBSetOutFmtStyle Lib "gbhltv32.dll" Alias "_GBSetOutFmtStyle@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetOutTerminator Lib "gbhltv32.dll" Alias "_GBSetOutTerminator@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetOutAddressFmt Lib "gbhltv32.dll" Alias "_GBSetOutAddressFmt@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetPostcodeFmt Lib "gbhltv32.dll" Alias "_GBSetPostcodeFmt@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetReturnCounty Lib "gbhltv32.dll" Alias "_GBSetReturnCounty@4" (ByVal szOption As String) As Integer
Private Declare Function GBSetUnwantedElements Lib "gbhltv32.dll" Alias "_GBSetUnwantedElements@4" (ByVal szOption As String) As Integer

''GBmailing required variables
Private Const User_buf_size = 4096         ' The size of the user buffer
Private Const Error_buf_size = 200             ' The size of the error buffer
Private szUser_buf As String * User_buf_size   ' User buffer passed to HLT functions
Private szError_buf As String * Error_buf_size ' Buffer passed to GBGetError
Private szCurrent_tho As String                ' The current thorofare selection
Private szCurrent_bui As String                ' The current building selection

Private bMore As Integer                       ' Boolean - True = more data to come
                                              '           False = no more data

Private vGBStreet1 As String
Private vGBStreet2 As String
Private vGBTown As String
Private vGBCounty As String
Private vGBPostcode As String

Private vGBMailingConnected As Boolean
Private vAddressSelected As Boolean
Private vParent As Form
Private vParentForm As Form
Private vIsLoaded As Boolean

''''''''''''''''''''''''''''''''''''''''''''''''
''

Public Property Get AddressSelected() As Boolean
    AddressSelected = vAddressSelected
End Property

Public Property Get Street1() As String
    Street1 = vGBStreet1
End Property
Public Property Get Street2() As String
    Street2 = vGBStreet2
End Property
Public Property Get Town() As String
    Town = vGBTown
End Property
Public Property Get County() As String
    County = vGBCounty
End Property
Public Property Get Postcode() As String
    Postcode = vGBPostcode
End Property

''''''''''''''''''''''''''''''''''''''''''''''''
''

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

''
Public Property Get ChildType() As ChildTypesENUM
    ChildType = GBMailing
End Property

''
Public Function CloseGBMailing() As Boolean
    If (vGBMailingConnected) Then
        CloseGBMailing = GBClose
    Else
        CloseGBMailing = True
    End If
End Function

''
Public Function ConnectGBMailing() As Boolean
Dim OpenCounter As Integer
Dim Reply As Integer
Dim vErrorMessage As String * 4096

For OpenCounter = 0 To 10
    Reply = GBOpen
    If Reply <= -738 Then
        Reply = GBClose
        Reply = GBOpen
    End If
    If (Reply >= -500) Then
        Exit For
    Else
        OpenCounter = OpenCounter + 1
        If (OpenCounter > 10) Then
            Reply = GBGetError(vErrorMessage, 4096)
            If (MsgBox("There is a problem opening the gbmailing system." & Chr(13) & Trim(vErrorMessage) & Chr(13) & "Would you like to try again?", vbQuestion + vbYesNo, "GB Mailing Open") = vbYes) Then
            
                OpenCounter = 0
            End If
        End If
    End If
Next
If (Reply > -500 And Reply < 0) Then
    Reply = GBGetError(vErrorMessage, 4096)
    If (Reply = -129) Then
        ' No error message file
    Else
       Call Messagebox("WARNING:" & Trim$(vErrorMessage), vbExclamation)
    End If
End If

If (Reply > -500) Then
    ConnectGBMailing = True
    vGBMailingConnected = True
Else
    ConnectGBMailing = False
End If
End Function

''
Public Function GetAddressFromPostcode(pParentForm As Form, pPostCode As String) As Boolean
    Dim Reply As Long
    Dim Address As String * 4096
    Dim ErrorReply As Long
    Dim ErrorMessage As String * 4096
    Dim AddressFound As Boolean
    
    Set vParentForm = pParentForm
    vAddressSelected = False
    AddressFound = False
    Address = pPostCode
    vGBPostcode = pPostCode
'    If InStr(Address, Chr(95)) Then
'        Address = Left$(Trim$(Address), 3) & " " & Right$(Trim$(Address), 3)
'    End If
    Reply = GBGetAddress(Address, 4096)
    Select Case Reply
        Case -431
            Call MsgBox("Invalid Postcode", vbInformation)
            AddressFound = False
        Case -999 To -1
            ErrorReply = GBGetError(ErrorMessage, 4096)
            MsgBox "There was an error while trying to get this address!" & vbCr & Trim$(ErrorMessage), vbExclamation, "GB Mailing"
            AddressFound = False
        Case 0 To 99
            Call PostAddress(Address)
            AddressFound = True
        Case 100 To 199
            Call ShowAddresses(Address, pPostCode)
            AddressFound = True
        Case Else
            MsgBox "Unable to sort this amount of data!", vbExclamation, "GB Mailing"
            AddressFound = False
    End Select
    GetAddressFromPostcode = AddressFound
End Function

''
Private Sub PostAddress(pAddressString As String)
    Dim TempAddressString As String
    Dim AddressLines(1 To 10) As String
    Dim lineCounter As Long
    Dim CountyFinder As String * 4096
    Dim Reply As Long
    lineCounter = 1
    TempAddressString = Trim$(pAddressString)
    Do While lineCounter < 11 And Len(TempAddressString) > 0 And InStr(TempAddressString, ";") > 0
        AddressLines(lineCounter) = Trim$(Left$(TempAddressString, InStr(TempAddressString, ";") - 1))
        TempAddressString = Mid$(TempAddressString, InStr(TempAddressString, ";") + 1)
        If (Trim(AddressLines(lineCounter)) <> "") Then
            lineCounter = lineCounter + 1
        End If
    Loop
    Select Case lineCounter
        Case 1
            vGBStreet1 = ""
            vGBStreet2 = ""
            vGBTown = ""
            vGBPostcode = ""
        Case 2
            vGBStreet1 = ""
            vGBStreet2 = ""
            vGBTown = ""
            vGBPostcode = AddressLines(1)
        Case 3
            vGBStreet1 = AddressLines(1)
            vGBStreet2 = ""
            vGBTown = ""
            vGBPostcode = AddressLines(2)
        Case 4
            vGBStreet1 = AddressLines(1)
            vGBStreet2 = ""
            vGBTown = AddressLines(2)
            vGBPostcode = AddressLines(3)
        Case 5
            vGBStreet1 = AddressLines(1)
            vGBStreet2 = AddressLines(2)
            vGBTown = AddressLines(3)
            vGBPostcode = AddressLines(4)
        Case 6
            vGBStreet1 = AddressLines(1) & "," & AddressLines(2)
            vGBStreet2 = AddressLines(3)
            vGBTown = AddressLines(4)
            vGBPostcode = AddressLines(5)
        Case 7
            vGBStreet1 = AddressLines(1) & "," & AddressLines(2)
            vGBStreet2 = AddressLines(3)
            vGBTown = AddressLines(4)
            vGBCounty = AddressLines(5)
            vGBPostcode = AddressLines(6)
        Case 8, 9, 10, 11
            vGBStreet1 = AddressLines(1) & "," & AddressLines(2) & "," & AddressLines(3)
            vGBStreet2 = AddressLines(4)
            vGBTown = AddressLines(5)
            vGBCounty = AddressLines(6)
            vGBPostcode = AddressLines(7)
    End Select
    CountyFinder = vGBPostcode
    Reply = GBGetCounty(CountyFinder, 4096)
    vGBCounty = Trim(Left(CountyFinder, Len(Trim(CountyFinder)) - 1))
End Sub

''
Private Function ShowAddresses(vAddressString As String, vPostCode As String) As Boolean
    Dim vTempAddresses As String
    Dim vAddItem As String
    Dim Street1 As String * 4096
    vTempAddresses = vAddressString & ";"
    GRDAddresses.Clear
    
    Do While Len(vTempAddresses) > 0
        vAddItem = Left(vTempAddresses, InStr(vTempAddresses, ";") - 1)
        Call GRDAddresses.AddItem(vAddItem)
        vTempAddresses = Mid(vTempAddresses, InStr(vTempAddresses, ";") + 1)
    Loop
    Call GBGetThorofare(Street1, 4096)
    Me.Caption = "Locate House Number in " & Trim$(vGBPostcode) & "," & Street1
    
    If (vParentForm.hDC <> Me.hDC) Then
        Set vParent = vParentForm
    End If
    Me.Show
    Call GRDAddresses.SetFocus
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form functions

''
Private Sub CMDCommit_Click()
    If (GRDAddresses.ListIndex >= 0) Then
        GRDAddresses.Col = 0
        Call GetAddressFromPostcode(Me, vGBPostcode & ";;" & GRDAddresses.ColText)
        Call Me.Hide
        vAddressSelected = True
        Call vParent.SendChildInactive
    Else
        Call Messagebox("Please select an address", vbInformation)
    End If
End Sub

''
Private Sub CMDExit_Click()
    vAddressSelected = False
    Call Me.Hide
    Call vParent.SendChildInactive
End Sub

''
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
End Sub

''
Private Sub GRDAddresses_DblClick()
    If (GRDAddresses.ListIndex >= 0) Then
        GRDAddresses.Col = 0
        Call GetAddressFromPostcode(Me, vGBPostcode & ";;" & GRDAddresses.ColText)
        Call Me.Hide
        vAddressSelected = True
        Call vParent.SendChildInactive
    End If
End Sub

''
Private Sub GRDAddresses_KeyPress(KeyAscii As Integer)
    If (KeyAscii = 13) Then
        GRDAddresses.Col = 0
        Call GetAddressFromPostcode(Me, vGBPostcode & ";;" & GRDAddresses.ColText)
        Call Me.Hide
        vAddressSelected = True
        Call vParent.SendChildInactive
    End If
End Sub

''
Public Function GetPostcodeFromAddress(pParentForm As Form, pAddress As String) As Boolean
    Dim Reply As Long
    Dim Reply2 As Long
    Dim ierror_no As Long
    Dim szError_msg  As String

    ' set fatal error flag to flase
    ierror_no = 999
    
    ' This next line is required as Visual Basic always
    ' converts fixed length strings to variant length strings
    ' before passing them to a DLL. We therefore ensure the
    ' string is the correct length by stuffing it with nulls
'    szUser_buf = txtAddress.Text & String(User_buf_size - Len(txtAddress.Text), 0)
    szUser_buf = pAddress

    ' Now call the HLT function
    Reply = GBPostcodeAddress(szUser_buf, User_buf_size)

    ' Push all the errors into a buffer
    szError_msg = ""
    While ierror_no <> 0
        szError_buf = String(Error_buf_size, 0)
        ierror_no = GBGetError(szError_buf, Error_buf_size)
        If ierror_no <= -700 Then
'            bFatal = True
        End If
        szError_msg = szError_msg & ";" & "GBPostcodeAddress: " & Str(ierror_no) & " " & szError_buf
    Wend
    
    ' Display all the errors
'    If bFatal = True Then
'        Msg_box_reply = MsgBox("Fatal Error In GBPostcodeAddress", vbOK, "FATAL ERROR")
'        End
'    End If
    
    ' If the reply is between zero and 24 then the address has been successfully postcoded

    If Reply >= 0 And Reply < 24 And Reply <> 22 Then
    Reply2 = Reply
'        TXTAddress.Text = szUser_buf
        
'        Postcode = String(15, 0): Reply = GBGetPostcode(Postcode, 15)

'        txtInput(3).Text = Mid$(Postcode, 1, 4)
'        If Mid$(Postcode, 5, 1) <> " " Then
'            txtInput(4).Text = Mid$(Postcode, 5, 3)
'        Else
'            txtInput(4).Text = Mid$(Postcode, 6, 3)
'        End If
'        If Reply2 = 23 Then
'            CheckPostCodeDB ("POSTCODE")
'            Exit Function
'        End If
        'PostCode = String(15, 0): reply =GBGetPostCode(PostCode, 15)
        '****************************************************
'FillInNormalAddressFields:
'    Building = String(50, 0): Reply = GBGetBuilding(Building, 50)
'    Building = RemoveSpace(Building)
'    County = String(40, 0): Reply = GBGetCounty(County, 40)
'    County = RemoveSpace(County)
'    depLocality = String(40, 0): Reply = GBGetDepLocality(depLocality, 40)
'    depLocality = RemoveSpace(depLocality)
'    depThorofare = String(40, 0): Reply = GBGetDepThorofare(depThorofare, 128)
'    depThorofare = RemoveSpace(depThorofare)
'    depDoubleLocal = String(40, 0): Reply = GBGetDoubleLocality(depDoubleLocal, 40)
'    depDoubleLocal = RemoveSpace(depDoubleLocal)
'    Locality = String(40, 0): Reply = GBGetLocality(Locality, 40)
'    Locality = RemoveSpace(Locality)
'    Postcode = String(15, 0): Reply = GBGetPostcode(Postcode, 15)
'    Postcode = RemoveSpace(Postcode)
'    SubBuilding = String(50, 0): Reply = GBGetSubBuilding(SubBuilding, 50)
'    SubBuilding = RemoveSpace(SubBuilding)
'    Thorofare = String(50, 0): Reply = GBGetThorofare(Thorofare, 50)
'    Thorofare = RemoveSpace(Thorofare)
'    Organisation = String(50, 0): Reply = GBGetOrganisation(Organisation, 50)
'    Organisation = RemoveSpace(Organisation)
    End If
End Function

