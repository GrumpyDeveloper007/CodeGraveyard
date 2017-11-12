Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
''
''
Public GlobalTitles As New ClassTitle

''
Public Const cVersionNumber As String = " V1 (21/05/2002)"
Public Const cProjectName As String = "S Invoice "
Public Const cRegistoryName As String = "S Invoice"
Public Const cProjectNameConst As String = "SInvoice" ' Used for licence validation
Public Const cDatabaseName As String = "SInvoice.MDB"

''
Public Const cLongFieldSize As String = "########"

'' Used by lots of forms (all that have the following as children
Public Enum ChildTypesENUM
    ProductSearch = 1
    CustomerSearch = 2
    TextEditor = 3
    Payment = 4
End Enum


Public Enum FormModeENUM
    dual = 0
    Invoice = 1
    Estmaite = 2
End Enum
