Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
''
''

''
Public Const cVersionNumber As String = "V1 (04/05/2001)"
Public Const cProjectName As String = ".Project Name Here."
Public Const cRegistoryName As String = ".RegistoryNameHere."
Public Const cProjectNameConst As String = ".Project Name(never changes after release)." ' Used for licence validation
Public Const cDatabaseName As String = ".MDBFileNameHere."

'Public vCrystalReport As CrystalReport

''
'' Other Format Strings
Public Const cPartNumberFieldSize As String = "&&&&&&&&&&&&&&&"   '15
Public Const cDescriptionFieldSize As String = "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"    '30

Public Const cLongFieldSize As String = "########"

Public Const cVAT As Currency = 17.5

'' Used by lots of forms (all that have the following as children
Public Enum ChildTypesENUM
    CustomerSearch = 1
End Enum


'Public vDataPath As String

