Attribute VB_Name = "GlobalDeclarations"
Option Explicit
''*************************************************************************
''
''
''

''
Public Const cVersionNumber As String = " (02/07/2002)"
Public Const cProjectName As String = "Phone System "
Public Const cRegistoryName As String = "Phone System"
Public Const cDatabaseName As String = "PhoneSystem.mdb"
Public Const cProjectNameConst As String = "PhoneSystem"

''

Public Const cVAT As Currency = 17.5

'' Used by lots of forms (all that have the following as children


Public Type TransactionDetailsTYPE
    CallDate As Date
    lineNumber As Long
    ExtensionNumber As Long
    Duration As Long
    PhoneNumber As String
    ContinuedCall As Boolean
    Direction As Long
    AnswerTime As Long
    UnanseredCall As Boolean
End Type

Public Const cCurrencyFormat As String = "£#####0.00"

