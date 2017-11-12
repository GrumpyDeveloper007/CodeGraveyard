Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
''
''

''
Public Const cVersionNumber As String = "V1 (04/05/2001)"
Public Const cProjectName As String = "Card Logger"
Public Const cRegistoryName As String = "Card Logger"
Public Const cProjectNameConst As String = "SInvoice" ' Used for licence validation
Public Const cDatabaseName As String = "Net2System.mdb"


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

'Public Const cWildCard As String = "*" ' % in ADO, * in DAO
'Public Const cDateChar As String = "#" '

'Public Const cCurrencyFormat As String = "£#####0.00"

Public vDataPath As String

