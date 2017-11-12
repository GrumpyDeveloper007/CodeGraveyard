VERSION 5.00
Begin VB.Form ClassUpdater 
   Caption         =   "Class Updater"
   ClientHeight    =   6630
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9780
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   6630
   ScaleWidth      =   9780
   Begin VB.CommandButton CmdClass 
      Caption         =   "Update Class"
      Height          =   375
      Left            =   6120
      TabIndex        =   10
      Top             =   5640
      Width           =   1335
   End
   Begin VB.FileListBox LSTClassFiles 
      Height          =   1845
      Left            =   3360
      Pattern         =   "*.cls"
      TabIndex        =   5
      Top             =   4200
      Width           =   2655
   End
   Begin VB.DirListBox LSTClassDir 
      Height          =   1665
      Left            =   0
      TabIndex        =   4
      Top             =   4200
      Width           =   3255
   End
   Begin VB.FileListBox Tables 
      Height          =   3600
      Left            =   3360
      Pattern         =   "*.mdb"
      TabIndex        =   2
      Top             =   240
      Width           =   2655
   End
   Begin VB.DirListBox DirTables 
      Height          =   3690
      Left            =   0
      TabIndex        =   1
      Top             =   240
      Width           =   3255
   End
   Begin VB.ListBox LstTables 
      Height          =   3180
      Left            =   6120
      TabIndex        =   0
      Top             =   240
      Width           =   3255
   End
   Begin VB.Label LBLz 
      Caption         =   "Select Database."
      Height          =   255
      Index           =   4
      Left            =   3360
      TabIndex        =   9
      Top             =   0
      Width           =   1815
   End
   Begin VB.Label LBLz 
      Caption         =   "Select Table."
      Height          =   255
      Index           =   3
      Left            =   6120
      TabIndex        =   8
      Top             =   0
      Width           =   1815
   End
   Begin VB.Label LBLz 
      Caption         =   "Select Class."
      Height          =   255
      Index           =   2
      Left            =   3360
      TabIndex        =   7
      Top             =   3960
      Width           =   1815
   End
   Begin VB.Label LBLz 
      Caption         =   "Select Directory."
      Height          =   255
      Index           =   1
      Left            =   0
      TabIndex        =   6
      Top             =   3960
      Width           =   1815
   End
   Begin VB.Label LBLz 
      Caption         =   "Select Directory."
      Height          =   255
      Index           =   0
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   1815
   End
End
Attribute VB_Name = "ClassUpdater"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Class Updater
''
'' Coded by Dale Pitman

Private FieldNames(100) As String   ' fieldnames within class/program
Private FieldNames2(100) As String  ' actual field names
Private FieldData(100) As Variant   ' Not used
Private FieldType(100) As Long      ' Field type
Private FieldSize(100) As Long
Private NumberFields As Long        ' Number of fields in selected table
Private KeyFieldID As Long          ' Currently selected unique field
Private StructureLoaded As Long     ' File containing structure of class, is loaded?

''
Private Function REadTable()
    Dim rsClassTable As Recordset
    Dim tempname As String
    Dim i As Long
    Dim iloop As Long
    
    
    tempname = LstTables.List(LstTables.ListIndex)
    'If (Len(tempname) > 8 + 4) Then
    '    tempname = Left(tempname, 6) & "~1.dbf"
    'End If
    Set rsClassTable = db.OpenRecordset(tempname, dbOpenTable)
    
    NumberFields = rsClassTable.Fields.Count - 1
    
    For iloop = 0 To NumberFields
        FieldNames(iloop) = UCase(Left(rsClassTable.Fields(iloop).Name, 1)) & LCase(Right(rsClassTable.Fields(iloop).Name, Len(rsClassTable.Fields(iloop).Name) - 1))
        FieldNames2(iloop) = UCase(Left(rsClassTable.Fields(iloop).Name, 1)) & LCase(Right(rsClassTable.Fields(iloop).Name, Len(rsClassTable.Fields(iloop).Name) - 1))
        If (UCase(rsClassTable.Fields(iloop).Name) = "TYPE") Then
            Call MsgBox("WARNING: Field name 'Type' is a reserved word in VB6")
        End If
        FieldType(iloop) = rsClassTable.Fields(iloop).Type
        FieldSize(iloop) = rsClassTable.Fields(iloop).Size
    Next
End Function

''
Private Function CopyToSync(pPosition As Long, pInFile As Long, pOutFile As Long)
    Dim TempString As String
    Line Input #pInFile, TempString
    Do While (InStr(TempString, "%^" & Format(pPosition, "00")) = 0 And EOF(pInFile) = False)
        Print #pOutFile, TempString
        Line Input #pInFile, TempString
    Loop
    Print #pOutFile, TempString
End Function

''
Private Function MoveToSync(pPosition As Long, pInFile As Long, pOutFile As Long)
    Dim TempString As String
    Line Input #pInFile, TempString
    Do While (InStr(TempString, "%^" & Format(pPosition, "00")) = 0 And EOF(pInFile) = False)
        Line Input #pInFile, TempString
    Loop
    Print #pOutFile, TempString
End Function

Private Sub CmdClass_Click()
    Dim FileID As Long
    Dim OutFileID As Long
    Dim i As Long
    Dim TempString As String
    
    FileID = FreeFile
    Open LSTClassFiles.Path & "\" & LSTClassFiles.List(LSTClassFiles.ListIndex) For Input As FileID
    OutFileID = FreeFile
    Open LSTClassFiles.Path & "\2" & LSTClassFiles.List(LSTClassFiles.ListIndex) For Output As OutFileID
'    TempString = Replace(TxtHeader.Text, "<TableName>", TxtDataBaseName.Text)
'    Print #FileID, TempString
    ' "CONSTANTS" definitions for string sizes
    'For i = 0 To NumberFields
    '    If (FieldSize(i) = 0) Then
    '        FieldSize(i) = 255
    '    End If
    '    Print #FileID, " const v" & FieldNames(i) & "Size = " & FieldSize(i)
    'Next
    
    Call CopyToSync(3, FileID, OutFileID)
    ' "DIMS" for fields
    For i = 0 To NumberFields
        Print #OutFileID, " Private v" & FieldNames(i) & " As " & GetFieldStringDim(FieldType(i))
    Next
    Call MoveToSync(4, FileID, OutFileID)
'    Print #FileID, TxtPart2.Text
    
    ' "DIMS" for field booleans
    Call CopyToSync(5, FileID, OutFileID)
    For i = 0 To NumberFields
        Print #OutFileID, " Private v" & FieldNames(i) & "C As Boolean"
    Next
'    Print #FileID, TxtPart3.Text
    Call MoveToSync(6, FileID, OutFileID)
    
    Call CopyToSync(7, FileID, OutFileID)
    ' reset function for field booleans, and clear values
    For i = 0 To NumberFields
        Print #OutFileID, "    v" & FieldNames(i) & "C = False"
        If (FieldType(i) = 10 Or FieldType(i) = 12) Then ' if string
            Print #OutFileID, "    v" & FieldNames(i) & " = " & Chr$(34) & Chr$(34)
        Else
            Print #OutFileID, "    v" & FieldNames(i) & " = 0"
        End If
    Next
    Call MoveToSync(8, FileID, OutFileID)
    
    Call CopyToSync(9, FileID, OutFileID)
    ' property definitions for each field
    For i = 0 To NumberFields
        TempString = Replace(Class.TXTProperty1.Text, "<FieldName>", FieldNames(i))
        ' Field alias here - ********************************************************************
        TempString = Replace(TempString, "<FieldName2>", FieldNames(i))
        TempString = Replace(TempString, "<FieldType>", GetFieldString(FieldType(i)))
'            If (FieldType(i) = 10 Or FieldType(i) = 12) Then
'                tempstring = Replace(tempstring, "<NewValue>", "trim(left$(NewValue,v" & FieldNames(i) & "Size))")
'            Else
            TempString = Replace(TempString, "<NewValue>", "NewValue")
'            End If
        Print #OutFileID, TempString
    Next
    Call MoveToSync(10, FileID, OutFileID)
    
    Call CopyToSync(11, FileID, OutFileID)
    ' Read Record - sql where x=xx
'    TempString = Replace(TxtPart5.Text, "<TableName>", TxtDataBaseName.Text)
'    TempString = Replace(TempString, "<KeyField>", FieldNames(KeyFieldID))
'    TempString = Replace(TempString, "<KeyField2>", FieldNames2(KeyFieldID))
'    Print #FileID, TempString
    
    ' read record - moves from record set to fields
    For i = 0 To NumberFields
        If (FieldType(i) = 10 Or FieldType(i) = 12) Then ' if string
            Print #OutFileID, "        v" & FieldNames(i) & " = rsSearch!" & FieldNames2(i) & " & " & Chr(34) & Chr(34)
        Else
            If (FieldType(i) = 8) Then  ' Date type
                Print #OutFileID, "        If (IsDate(v" & FieldNames(i) & ")) Then"
                Print #OutFileID, "            v" & FieldNames(i) & " = rsSearch!" & FieldNames2(i) & " & " & Chr(34) & Chr(34)
                Print #OutFileID, "        End If"
            Else
                Print #OutFileID, "        v" & FieldNames(i) & " = Val(rsSearch!" & FieldNames2(i) & " & " & Chr$(34) & Chr$(34) & ")"
            End If
        End If
        
    Next
    Call MoveToSync(12, FileID, OutFileID)
    
    Call CopyToSync(13, FileID, OutFileID)
    ' Write record start
'    TempString = Replace(TxtPart6.Text, "<TableName>", TxtDataBaseName.Text)
'    Print #FileID, TempString
    ' Write record - sql key field definition
    'Print #FileID, "    sql = sql & " & Chr(34) & FieldNames2(KeyFieldID) & " = " & Chr(34) & " & v" & FieldNames(KeyFieldID)
    
    ' Write record - moves records into sql "UPDATE" string
    For i = 0 To NumberFields
        If (i <> KeyFieldID) Then
            If (FieldType(i) = 10 Or FieldType(i) = 12) Then
                TempString = Replace(Class.TxtPart6A.Text, "<FieldName>", FieldNames2(i))
                TempString = Replace(TempString, "<FieldName2>", FieldNames2(i))
                TempString = Replace(TempString, "<FieldType>", GetFieldString(FieldType(i)))
            Else
                TempString = Replace(Class.TxtPart6B.Text, "<FieldName>", FieldNames2(i))
                TempString = Replace(TempString, "<FieldName2>", FieldNames2(i))
                TempString = Replace(TempString, "<FieldType>", GetFieldString(FieldType(i)))
            End If
            Print #OutFileID, TempString
        End If
    Next
    
    ' Write record - end + Create record - start
'    TempString = Replace(TxtPart7.Text, "<KeyFieldName>", FieldNames(KeyFieldID))
'    TempString = Replace(TempString, "<KeyFieldName2>", FieldNames2(KeyFieldID))
'    TempString = Replace(TempString, "<TableName>", TxtDataBaseName.Text)
'    Print #FileID, TempString
    Call MoveToSync(14, FileID, OutFileID)
    
    Call CopyToSync(15, FileID, OutFileID)
    'create record - fields to be created
    Print #OutFileID, "    sql = sql & " & Chr(34) & FieldNames2(0) & Chr(34)
    For i = 1 To NumberFields
'            If (FieldType(i) = 10 Or FieldType(i) = 12) Then
'                Print #FileID, "    sql = sql & " & "," & Chr(34) & FieldNames2(i) & Chr(34)
'            Else

            Print #OutFileID, "    If (" & "v" & FieldNames(i) & "C= True) Then"
            Print #OutFileID, "        sql = sql & " & Chr(34) & "," & FieldNames2(i) & Chr(34)
            Print #OutFileID, "    End if"
'            End If
    Next
    Print #OutFileID, "    sql = sql &" & Chr(34) & ") VALUES (" & Chr(34)
    
    ' Create Record - field values
    If (FieldType(i) = 10 Or FieldType(i) = 12) Then
        Print #OutFileID, "    sql = sql & " & Chr(34) & "," & Chr(34) & " & Chr(34) &" & "v " & FieldNames(i) & " & Chr(34) "
    Else
        Print #OutFileID, "    sql = sql & " & " v" & FieldNames(0)
    End If
    For i = 1 To NumberFields
        Print #OutFileID, "    If (" & "v" & FieldNames(i) & "C= True) Then"
        If (FieldType(i) = 10 Or FieldType(i) = 12) Then
            Print #OutFileID, "        sql = sql & " & Chr(34) & "," & Chr(34) & " & Chr(34) & " & "v" & FieldNames(i) & " & Chr(34) "
        Else
            Print #OutFileID, "        sql = sql & " & Chr(34) & "," & Chr(34) & " & v" & FieldNames(i)
        End If
        Print #OutFileID, "    End if"
    Next
    Print #OutFileID, "    sql = sql &" & Chr(34) & ") " & Chr(34)
    Call MoveToSync(16, FileID, OutFileID)
    
    ' Create Record - end
'    TempString = Replace(TxtPart8.Text, "<TableName>", TxtDataBaseName.Text)
'    TempString = Replace(TempString, "<KeyField>", FieldNames(KeyFieldID))
'    TempString = Replace(TempString, "<KeyField2>", FieldNames2(KeyFieldID))
'    Print #FileID, TempString
    
    Call CopyToSync(17, FileID, OutFileID)
    ' Set Default Values - For fields
    For i = 0 To NumberFields
        TempString = Replace(Class.TXTDefaultField.Text, "<FieldName>", FieldNames(i))
        If (FieldType(i) = 10 Or FieldType(i) = 12) Then
            TempString = Replace(TempString, "<DefaultVal>", Chr(34) & Chr(34))
        Else
            TempString = Replace(TempString, "<DefaultVal>", "0")
        End If
        Print #OutFileID, TempString
    Next
    Call MoveToSync(18, FileID, OutFileID)
    
    ' Default values function, LoadFromSearch function
'    Print #FileID, TxtPart9.Text
    
    Call CopyToSync(19, FileID, OutFileID)
    ' LoadFromSearch function - moves from record set to fields
    For i = 0 To NumberFields
        If (FieldType(i) = 10 Or FieldType(i) = 12) Then ' if string
            Print #OutFileID, "        v" & FieldNames(i) & " = vrsSearch!" & FieldNames2(i) & " & " & Chr(34) & Chr(34)
        Else
            If (FieldType(i) = 8) Then  ' Date type
                Print #OutFileID, "        If (IsDate(vrsSearch!" & FieldNames(i) & ")) Then"
                Print #OutFileID, "            v" & FieldNames(i) & " = vrsSearch!" & FieldNames2(i) & " & " & Chr(34) & Chr(34)
                Print #OutFileID, "        End If"
            Else    ' Numeric
                Print #OutFileID, "        v" & FieldNames(i) & " = Val(vrsSearch!" & FieldNames2(i) & " & " & Chr$(34) & Chr$(34) & ")"
            End If
        End If
    Next
    Call MoveToSync(20, FileID, OutFileID)
    
    ' End of LoadfromSearch function - move recordset to next record, updates record number
'    Print #FileID, TxtPart10.Text
    Call CopyToSync(21, FileID, OutFileID)
    
    Close #FileID
    Close #OutFileID
End Sub

Private Sub DirTables_Change()
    Tables.Path = DirTables.Path
End Sub

Private Sub LSTClassDir_Change()
    LSTClassFiles.Path = LSTClassDir.Path
End Sub

Private Sub LstTables_Click()
    Call REadTable
End Sub

Private Sub Tables_Click()
    Dim i As Long
    Set db = DBEngine.OpenDatabase(Tables.Path & "\" & Tables.List(Tables.ListIndex), False, False)
    For i = 0 To db.TableDefs.Count - 1
        LstTables.AddItem (db.TableDefs(i).Name)
    Next
End Sub

