Attribute VB_Name = "modAddressDB"

Option Explicit

Const FLAG_NAME As Long = 1
Const FLAG_FIRST_NAME As Long = 2
Const FLAG_COMPANY As Long = 4
Const FLAG_PHONE1 As Long = 8
Const FLAG_PHONE2 As Long = 16
Const FLAG_PHONE3 As Long = 32
Const FLAG_PHONE4 As Long = 64
Const FLAG_PHONE5 As Long = 128
Const FLAG_ADDRESS As Long = 256
Const FLAG_CITY As Long = 512
Const FLAG_STATE As Long = 1024
Const FLAG_ZIPCODE As Long = 2048
Const FLAG_COUNTRY As Long = 4096
Const FLAG_TITLE As Long = 8192
Const FLAG_CUSTOM1 As Long = 16384
Const FLAG_CUSTOM2 As Long = 32768
Const FLAG_CUSTOM3 As Long = 65536
Const FLAG_CUSTOM4 As Long = 131072
Const FLAG_NOTE As Long = 262144

Const BYTE_SIZE As Long = 1
Const INT_SIZE As Long = 2
Const LNG_SIZE As Long = 4
Const STR_SIZE As Long = 2

Public AddressDB As Long
Public dbname As String

Public Type tAddressRec
    Options As Long
    Reserved As Byte
    DisplayPhoneList As Byte
    PhoneType1 As Byte
    PhoneType2 As Byte
    PhoneType3 As Byte
    PhoneType4 As Byte
    PhoneType5 As Byte

    Flags As Long
    Filler1 As Byte

    Name As String
    FirstName As String
    Company As String
    Phone1 As String
    Phone2 As String
    Phone3 As String
    Phone4 As String
    Phone5 As String
    Address As String
    City As String
    State As String
    ZipCode As String
    Country As String
    Title As String
    Custom1 As String
    Custom2 As String
    Custom3 As String
    Custom4 As String
    Note As String
End Type

Public Sub OpenAddressDB()
    #If APPFORGE Then
        dbname = "AddressDB"
    #Else
        dbname = App.Path & "\AddressDB"
    #End If

    AddressDB = PDBOpen(Byfilename, dbname, 0, 0, 0, 0, afModeAsciiStrings + afModeReadWrite)
    If AddressDB = 0 Then
        'dbhand = PDBCreateDatabase(dbname, 0, 0)
    End If
    If AddressDB = 0 Then
        MsgBox "Failed to create the DB"
    End If
End Sub

Public Sub WriteStringFieldByOffset(DBHandle As Long, ByRef Offset As Long, MyString As String)
    If MyString <> "" Then
        PDBWriteFieldByOffset DBHandle, Offset, MyString
    Else
        Dim TempByte As Byte
        TempByte = 0
        PDBWriteFieldByOffset DBHandle, Offset, TempByte
    End If
    Offset = Offset + Len(MyString) + 1
End Sub

'-------------------------------------------------------------------------------
'
' Public Sub ReadDatebookRecord(MyRecord as tDatebookRec)
'
' Close the Datebook database.
'
'
'-------------------------------------------------------------------------------
Public Sub ReadAddressRecord(ByRef MyRecord As tAddressRec)
    Dim MyInt As Integer
    Dim Offset As Long
    Dim PhoneData As Byte

    Offset = 0

    ' The first four bytes of the AddressDB records make up the "options" field.
    ' The contents of these bytes are as follows:
    '
    ' Byte zero is reserved and is not used.
    '
    PDBGetFieldByOffset AddressDB, Offset, MyRecord.Reserved
    Offset = Offset + BYTE_SIZE

    '
    ' Byte one contains the displayPhoneForList, and phone5
    '
    PDBGetFieldByOffset AddressDB, Offset, PhoneData
    MyRecord.DisplayPhoneList = PhoneData \ 16 ' get the upper four bits
    MyRecord.PhoneType5 = PhoneData And &HF ' keep the lower four bits
    Offset = Offset + BYTE_SIZE

    '
    ' Byte two contains PhoneType4, and PhoneType3
    '
    PDBGetFieldByOffset AddressDB, Offset, PhoneData
    ' The next line of code will get the upper four bits of the PhoneData
    ' byte, because that is where the Phone4Type is stored.
    MyRecord.PhoneType4 = PhoneData \ 16
    ' This line will keep the lower four bits that is the PhoneType3 data
    MyRecord.PhoneType3 = PhoneData And &HF
    Offset = Offset + BYTE_SIZE

    '
    ' Byte three contains PhoneType2 and PhoneType1
    '
    PDBGetFieldByOffset AddressDB, Offset, PhoneData
    ' The next line of code will get the upper four bits of the PhoneData
    ' byte, because that is where the PhoneType2 is stored.
    MyRecord.PhoneType2 = PhoneData \ 16
    ' This line will keep the lower four bits that is the PhoneType1 data
    MyRecord.PhoneType1 = PhoneData And &HF
    Offset = Offset + BYTE_SIZE

    'Read the Flags
    PDBGetFieldByOffset AddressDB, Offset, MyRecord.Flags
    Offset = Offset + LNG_SIZE

    ' Skip the Filler1
    Offset = Offset + BYTE_SIZE

    ' Read Last Name
    If ((MyRecord.Flags And FLAG_NAME) = FLAG_NAME) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Name
        Offset = Offset + Len(MyRecord.Name) + 1
    Else
        MyRecord.Name = ""
    End If

     ' Read FirstName
    If ((MyRecord.Flags And FLAG_FIRST_NAME) = FLAG_FIRST_NAME) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.FirstName
        Offset = Offset + Len(MyRecord.FirstName) + 1
    Else
        MyRecord.FirstName = ""
    End If

    '  Read Company
    If ((MyRecord.Flags And FLAG_COMPANY) = FLAG_COMPANY) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Company
        Offset = Offset + Len(MyRecord.Company) + 1
    Else
        MyRecord.Company = ""
    End If

    '  Read Phone1
    If ((MyRecord.Flags And FLAG_PHONE1) = FLAG_PHONE1) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Phone1
        Offset = Offset + Len(MyRecord.Phone1) + 1
    Else
        MyRecord.Phone1 = ""
    End If

    '  Read Phone2
    If ((MyRecord.Flags And FLAG_PHONE2) = FLAG_PHONE2) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Phone2
        Offset = Offset + Len(MyRecord.Phone2) + 1
    Else
        MyRecord.Phone2 = ""
    End If

    '  Read Phone3
    If ((MyRecord.Flags And FLAG_PHONE3) = FLAG_PHONE3) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Phone3
        Offset = Offset + Len(MyRecord.Phone3) + 1
    Else
        MyRecord.Phone3 = ""
    End If

    '  Read Phone4
    If ((MyRecord.Flags And FLAG_PHONE4) = FLAG_PHONE4) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Phone4
        Offset = Offset + Len(MyRecord.Phone4) + 1
    Else
        MyRecord.Phone4 = ""
    End If

    '  Read Phone5
    If ((MyRecord.Flags And FLAG_PHONE5) = FLAG_PHONE5) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Phone5
        Offset = Offset + Len(MyRecord.Phone5) + 1
    Else
        MyRecord.Phone5 = ""
    End If

    '  Read Address
    If ((MyRecord.Flags And FLAG_ADDRESS) = FLAG_ADDRESS) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Address
        Offset = Offset + Len(MyRecord.Address) + 1
    Else
        MyRecord.Address = ""
    End If

    '  Read City
    If ((MyRecord.Flags And FLAG_CITY) = FLAG_CITY) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.City
        Offset = Offset + Len(MyRecord.City) + 1
    Else
        MyRecord.City = ""
    End If

    '  Read State
    If ((MyRecord.Flags And FLAG_STATE) = FLAG_STATE) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.State
        Offset = Offset + Len(MyRecord.State) + 1
    Else
        MyRecord.State = ""
    End If

    '  Read ZipCode
    If ((MyRecord.Flags And FLAG_ZIPCODE) = FLAG_ZIPCODE) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.ZipCode
        Offset = Offset + Len(MyRecord.ZipCode) + 1
    Else
        MyRecord.ZipCode = ""
    End If

    '  Read Country
    If ((MyRecord.Flags And FLAG_COUNTRY) = FLAG_COUNTRY) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Country
        Offset = Offset + Len(MyRecord.Country) + 1
    Else
        MyRecord.Country = ""
    End If

    '  Read Title
    If ((MyRecord.Flags And FLAG_TITLE) = FLAG_TITLE) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Title
        Offset = Offset + Len(MyRecord.Title) + 1
    Else
        MyRecord.Title = ""
    End If

    '  Read Custom1
    If ((MyRecord.Flags And FLAG_CUSTOM1) = FLAG_CUSTOM1) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Custom1
        Offset = Offset + Len(MyRecord.Custom1) + 1
    Else
        MyRecord.Custom1 = ""
    End If

    '  Read Custom2
    If ((MyRecord.Flags And FLAG_CUSTOM2) = FLAG_CUSTOM2) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Custom2
        Offset = Offset + Len(MyRecord.Custom2) + 1
    Else
        MyRecord.Custom2 = ""
    End If

    '  Read Custom3
    If ((MyRecord.Flags And FLAG_CUSTOM3) = FLAG_CUSTOM3) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Custom3
        Offset = Offset + Len(MyRecord.Custom3) + 1
     Else
        MyRecord.Custom3 = ""
    End If

    '  Read Custom4
    If ((MyRecord.Flags And FLAG_CUSTOM4) = FLAG_CUSTOM4) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Custom4
        Offset = Offset + Len(MyRecord.Custom4) + 1
    Else
        MyRecord.Custom4 = ""
    End If

    '  Read Note
    If ((MyRecord.Flags And FLAG_NOTE) = FLAG_NOTE) Then
        PDBGetFieldByOffset AddressDB, Offset, MyRecord.Note
        Offset = Offset + Len(MyRecord.Note) + 1
    Else
        MyRecord.Note = ""
    End If
 
End Sub

Public Function CalculateRecordSize(MyRecord As tAddressRec) As Long
    Dim RecSize As Long
    RecSize = 0

    'Size of Byte0
    RecSize = RecSize + BYTE_SIZE

    'Size of Byte1
    RecSize = RecSize + BYTE_SIZE

    'Size of Byte 2
    RecSize = RecSize + BYTE_SIZE

    'Size of Byte3
    RecSize = RecSize + BYTE_SIZE

    'Size of Flags
    RecSize = RecSize + LNG_SIZE

    'Size of Filler1
    RecSize = RecSize + BYTE_SIZE

    'Size of Name
    If MyRecord.Name <> "" Then
        RecSize = RecSize + Len(MyRecord.Name) + 1
    End If

    'Size of FirstName
    If MyRecord.FirstName <> "" Then
        RecSize = RecSize + Len(MyRecord.FirstName) + 1
    End If

    'Size of Company
    If MyRecord.Company <> "" Then
        RecSize = RecSize + Len(MyRecord.Company) + 1
    End If

    'Size of Phone1
    If MyRecord.Phone1 <> "" Then
        RecSize = RecSize + Len(MyRecord.Phone1) + 1
    End If

    'Size of Phone2
    If MyRecord.Phone2 <> "" Then
        RecSize = RecSize + Len(MyRecord.Phone2) + 1
    End If

    'Size of Phone3
    If MyRecord.Phone3 <> "" Then
        RecSize = RecSize + Len(MyRecord.Phone3) + 1
    End If

    'Size of Phone4
    If MyRecord.Phone4 <> "" Then
        RecSize = RecSize + Len(MyRecord.Phone4) + 1
    End If

    'Size of Phone5
    If MyRecord.Phone5 <> "" Then
        RecSize = RecSize + Len(MyRecord.Phone5) + 1
    End If

    'Size of Address
    If MyRecord.Address <> "" Then
        RecSize = RecSize + Len(MyRecord.Address) + 1
    End If

    'Size of City
    If MyRecord.City <> "" Then
        RecSize = RecSize + Len(MyRecord.City) + 1
    End If

    'Size of State
    If MyRecord.State <> "" Then
        RecSize = RecSize + Len(MyRecord.State) + 1
    End If

    'Size of ZipCode
    If MyRecord.ZipCode <> "" Then
        RecSize = RecSize + Len(MyRecord.ZipCode) + 1
    End If

    'Size of Country
    If MyRecord.Country <> "" Then
        RecSize = RecSize + Len(MyRecord.Country) + 1
    End If

    'Size of Title
    If MyRecord.Title <> "" Then
        RecSize = RecSize + Len(MyRecord.Title) + 1
    End If

    'Size of Custom1
    If MyRecord.Custom1 <> "" Then
        RecSize = RecSize + Len(MyRecord.Custom1) + 1
    End If

    'Size of Custom2
    If MyRecord.Custom2 <> "" Then
        RecSize = RecSize + Len(MyRecord.Custom2) + 1
    End If

    'Size of Custom3
    If MyRecord.Custom3 <> "" Then
        RecSize = RecSize + Len(MyRecord.Custom3) + 1
    End If

    'Size of Custom4
    If MyRecord.Custom4 <> "" Then
        RecSize = RecSize + Len(MyRecord.Custom4) + 1
    End If

    'Size of Note
    If MyRecord.Note <> "" Then
        RecSize = RecSize + Len(MyRecord.Note) + 1
    End If
    CalculateRecordSize = RecSize
End Function


Public Sub WriteAddressRecord(ByRef MyRecord As tAddressRec)
    Dim MyInt As Integer
    Dim Offset As Long
    Dim btemp As Byte


    Offset = 0

    ' Write Options
    'PDBWriteFieldByOffset AddressDB, 0, MyRecord.Options
    'Offset = Offset + LNG_SIZE

    ' Write the Reserved byte in "Options"
    PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Reserved
    Offset = Offset + BYTE_SIZE

    ' Write byte 1 of the "Options"
    btemp = (MyRecord.DisplayPhoneList * 16) Or MyRecord.PhoneType5
    PDBWriteFieldByOffset AddressDB, Offset, btemp
    Offset = Offset + BYTE_SIZE

    ' Write byte 2 of the "Options"
    btemp = (MyRecord.PhoneType4 * 16) Or MyRecord.PhoneType3
    PDBWriteFieldByOffset AddressDB, Offset, btemp
    Offset = Offset + 1

    ' Write byte 3 of the "Options"
    btemp = (MyRecord.PhoneType2 * 16) Or MyRecord.PhoneType1
    PDBWriteFieldByOffset AddressDB, Offset, btemp
    Offset = Offset + 1

    'In the natural order of the record, we would write the Flags field next.
    'However, we will build the flags field based on the fields within the current
    'record.  The Offset will be adjusted to account for the space needed for the Flags
    'field.  The Flags will be written at the end of this routine after determing what they
    'need to be based on the record.
    Offset = Offset + LNG_SIZE

    ' Skip the Filler1
    Offset = Offset + BYTE_SIZE

    ' The Flags are initialized to zero to set a valid starting point.
    MyRecord.Flags = 0

    ' Write Name
    If MyRecord.Name <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_NAME
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Name
        Offset = Offset + Len(MyRecord.Name) + 1
    End If

    ' Write FirstName
    If MyRecord.FirstName <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_FIRST_NAME
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.FirstName
        Offset = Offset + Len(MyRecord.FirstName) + 1
    End If

    ' Write Company
    If MyRecord.Company <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_COMPANY
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Company
        Offset = Offset + Len(MyRecord.Company) + 1
    End If

    ' Write FirstName Phone1
     If MyRecord.Phone1 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_PHONE1
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Phone1
        Offset = Offset + Len(MyRecord.Phone1) + 1
    End If

    ' Write Phone2
     If MyRecord.Phone2 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_PHONE2
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Phone2
        Offset = Offset + Len(MyRecord.Phone2) + 1
    End If

    ' Write Phone3
     If MyRecord.Phone3 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_PHONE3
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Phone3
        Offset = Offset + Len(MyRecord.Phone3) + 1
    End If

    ' Write Phone4
     If MyRecord.Phone4 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_PHONE4
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Phone4
        Offset = Offset + Len(MyRecord.Phone4) + 1
    End If

    ' Write Phone5
     If MyRecord.Phone5 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_PHONE5
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Phone5
        Offset = Offset + Len(MyRecord.Phone5) + 1
    End If

    ' Write Address
     If MyRecord.Address <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_ADDRESS
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Address
        Offset = Offset + Len(MyRecord.Address) + 1
    End If

    ' Write City
     If MyRecord.City <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_CITY
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.City
        Offset = Offset + Len(MyRecord.City) + 1
    End If

    ' Write State
     If MyRecord.State <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_STATE
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.State
        Offset = Offset + Len(MyRecord.State) + 1
    End If

    ' Write ZipCode
    If MyRecord.ZipCode <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_ZIPCODE
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.ZipCode
        Offset = Offset + Len(MyRecord.ZipCode) + 1
    End If

    ' Write Country
     If MyRecord.Country <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_COUNTRY
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Country
        Offset = Offset + Len(MyRecord.Country) + 1
    End If

    ' Write Title
     If MyRecord.Title <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_TITLE
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Title
        Offset = Offset + Len(MyRecord.Title) + 1
    End If

    ' Write Custom1
     If MyRecord.Custom1 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_CUSTOM1
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Custom1
        Offset = Offset + Len(MyRecord.Custom1) + 1
    End If

    ' Write Custom2
     If MyRecord.Custom2 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_CUSTOM2
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Custom2
        Offset = Offset + Len(MyRecord.Custom2) + 1
    End If

    ' Write Custom3
        If MyRecord.Custom3 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_CUSTOM3
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Custom3
        Offset = Offset + Len(MyRecord.Custom3) + 1
    End If

    ' Write Custom4
        If MyRecord.Custom4 <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_CUSTOM4
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Custom4
        Offset = Offset + Len(MyRecord.Custom4) + 1
    End If

    ' Write Note
     If MyRecord.Note <> "" Then
        MyRecord.Flags = MyRecord.Flags Or FLAG_NOTE
        PDBWriteFieldByOffset AddressDB, Offset, MyRecord.Note
        Offset = Offset + Len(MyRecord.Note) + 1
    End If

    'We have determined which fields contain valid data and we have set their flags accordingly.
    'We know the flags are set to offset 4.
    PDBWriteFieldByOffset AddressDB, 4, MyRecord.Flags

End Sub


Public Sub DisplayRecordContents(MyRecord As tAddressRec)

    'Display byte 1 of the "Options"
    Debug.Print "DisplayPhoneList=" & MyRecord.DisplayPhoneList
    Debug.Print "PhoneType5=" & MyRecord.PhoneType5

    'Display byte 2 of the "Options"
    Debug.Print "PhoneType4=" & MyRecord.PhoneType4
    Debug.Print "PhoneType3=" & MyRecord.PhoneType3

    'Display byte 3 of the "Options"
    Debug.Print "PhoneType2=" & MyRecord.PhoneType2
    Debug.Print "PhoneType1=" & MyRecord.PhoneType1

    Debug.Print "Flags=" & Hex(MyRecord.Flags)

    If ((MyRecord.Flags And 1) = 1) Then
        Debug.Print "Name=" & MyRecord.Name
    End If

    If ((MyRecord.Flags And 2) = 2) Then
        Debug.Print "FirstName=" & MyRecord.FirstName
    End If

    'Display Company
    If ((MyRecord.Flags And 4) = 4) Then
        Debug.Print "Company=" & MyRecord.Company
    End If

    'Display Phone1
    If ((MyRecord.Flags And 8) = 8) Then
        Debug.Print "Phone1=" & MyRecord.Phone1
    End If

    'Display Phone2
    If ((MyRecord.Flags And 16) = 16) Then
        Debug.Print "Phone2=" & MyRecord.Phone2
    End If

    'Display Phone3
    If ((MyRecord.Flags And 32) = 32) Then
        Debug.Print "Phone3=" & MyRecord.Phone3
    End If

    'Display Phone4
    If ((MyRecord.Flags And 64) = 64) Then
        Debug.Print "Phone4=" & MyRecord.Phone4
    End If

    'Display Phone5
    If ((MyRecord.Flags And 128) = 128) Then
        Debug.Print "Phone5=" & MyRecord.Phone5
    End If

    'Display Address
    If ((MyRecord.Flags And 256) = 256) Then
        Debug.Print "Address=" & MyRecord.Address
    End If

    'Display City
    If ((MyRecord.Flags And 512) = 512) Then
        Debug.Print "City=" & MyRecord.City
    End If

    'Display State
    If ((MyRecord.Flags And 1024) = 1024) Then
        Debug.Print "State=" & MyRecord.State
    End If

    'Display ZipCode
    If ((MyRecord.Flags And 2048) = 2048) Then
        Debug.Print "ZipCode=" & MyRecord.ZipCode
    End If

    'Display Country
    If ((MyRecord.Flags And 4096) = 4096) Then
        Debug.Print "Country=" & MyRecord.Country
    End If

    'Display Title
    If ((MyRecord.Flags And 8192) = 8192) Then
        Debug.Print "Title=" & MyRecord.Title
    End If

    'Display Custom1
    If ((MyRecord.Flags And 16384) = 16384) Then
        Debug.Print "Custom1=" & MyRecord.Custom1
    End If

    'Display Custom2
    If ((MyRecord.Flags And 32768) = 32768) Then
        Debug.Print "Custom2=" & MyRecord.Custom2
    End If

    'Display Custom3
    If ((MyRecord.Flags And 65536) = 65536) Then
        Debug.Print "Custom3=" & MyRecord.Custom3
    End If

    'Display Custom4
    If ((MyRecord.Flags And 131072) = 131072) Then
        Debug.Print "Custom4=" & MyRecord.Custom4
    End If

    'Display Note
    If ((MyRecord.Flags And 262144) = 262144) Then
        Debug.Print "Note=" & MyRecord.Note
    End If
End Sub

