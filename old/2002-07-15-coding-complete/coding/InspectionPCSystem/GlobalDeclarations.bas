Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
''
''

Public GlobalTitles As New ClassTitle


''
Public Const cVersionNumber As String = " V1 (02/07/2002)"
Public Const cProjectName As String = "BodyWork "
Public Const cRegistoryName As String = "BodyWork2"
Public Const cProjectNameConst As String = "BodyWork" ' Used for licence validation
Public Const cDatabaseName As String = "BodyWork.MDB"

'Public vCrystalReport As CrystalReport

''
'' Other Format Strings
Public Const cPartNumberFieldSize As String = "&&&&&&&&&&&&&&&"   '15
Public Const cDescriptionFieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"    '30

Public Const cLongFieldSize As String = "########"

'' Addresses
Public Const cSalutationFieldSize As String = "&&&&&&" '6
Public Const cNameFieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" '35
Public Const cStreet1FieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" ' 65
Public Const cStreet2FieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"   '30

Public Const chomeTelphoneNumberFieldSize As String = "&&&&&&&&&&&&&&" '14
Public Const cTownFieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" '30
Public Const cCountyFieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" '30

'Public Const cVAT As Currency = 17.5

'' Used by lots of forms (all that have the following as children
Public Enum ChildTypesENUM
    ProductSearch = 1
    CustomerSearch = 2
    TextEditor = 3
    PartCodeSearch = 4
End Enum


Public vDataPath As String


