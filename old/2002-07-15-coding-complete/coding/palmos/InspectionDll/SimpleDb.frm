VERSION 5.00
Begin VB.Form FSearch 
   Caption         =   "PDDirect Tutorial ActiveXDll"
   ClientHeight    =   3135
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   5040
   LinkTopic       =   "Form1"
   ScaleHeight     =   3135
   ScaleWidth      =   5040
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton btnSearch 
      Caption         =   "Search"
      Height          =   435
      Left            =   1680
      TabIndex        =   2
      Top             =   2370
      Width           =   1485
   End
   Begin VB.TextBox txtSearch 
      Height          =   345
      Left            =   270
      TabIndex        =   1
      Top             =   540
      Width           =   4215
   End
   Begin VB.Label lblCount 
      Caption         =   "0 of 100 records contained the string."
      Height          =   285
      Left            =   270
      TabIndex        =   3
      Top             =   1260
      Width           =   4215
   End
   Begin VB.Label Label1 
      Caption         =   "Search the MemoDB and find this string."
      Height          =   225
      Left            =   300
      TabIndex        =   0
      Top             =   210
      Width           =   2955
   End
End
Attribute VB_Name = "FSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub btnSearch_Click()
    '   Handle errors
    On Error GoTo Handler
    
    '   Let the user know we're processing
    lblCount = "Please wait....."
    
    '   Declare the PDDatabaseQuery object
    Dim pDbQuery As New PDDatabaseQuery
    
    '   Declare the PDRecordAdapter object
    Dim pMemo As PDRecordAdapter
    
    '   Open the Memo database
    Set pMemo = pDbQuery.OpenRecordDatabase("MemoDB", "PDDirect.PDRecordAdapter", eRead Or eWrite Or eShowSecret)
    
    '   Declare the record header and data
    Dim nIndex As Long
    Dim vUniqueId As Variant
    Dim nCategory As Long
    Dim eAttributes As ERecordAttributes
    Dim vData As Variant
    
    '   Declare the PDUtility object
    Dim pUtility As New PDUtility
    
    '   Declare the Memo string
    Dim sMemo As String
    
    '   Declare the count of records containing the string
    Dim nCount As Long
    Dim nTest As Variant
    
    '   Read the first record
    pMemo.IterationIndex = 0
    vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
    
    '   Loop and search each Memo record for the string
    Do While Not pMemo.EOF
        '   Convert the Memo record to a string
        '   ByteArrayToBSTR returns the next offset
        '   We don't need it
        pUtility.ByteArrayToBSTR vData, 0, 32767, sMemo
        
        '   See if the search string is in the Memo record
        nTest = InStr(sMemo, txtSearch.Text)
        If VarType(nTest) <> vbNull And nTest > 0 Then nCount = nCount + 1
            
        '   Read the next record
        vData = pMemo.ReadNext(nIndex, vUniqueId, nCategory, eAttributes)
    Loop
    
    '   Prepare the result
    lblCount.Caption = Str(nCount) & " of " & Str(pMemo.RecordCount) & _
                       " records contained the string."
                       
    '   Don't need the objects anymore
    Set pDbQuery = Nothing
    Set pMemo = Nothing
    Set pUtility = Nothing
    
    '   Normal exit
    Exit Sub
    
Handler:
    MsgBox "There was an error performing the search." & vbNewLine & _
           Err.Description & vbNewLine & _
           "Number = " & Hex(Err.Number)
           
    '   Don't need the objects anymore
    Set pDbQuery = Nothing
    Set pMemo = Nothing
    Set pUtility = Nothing
End Sub



