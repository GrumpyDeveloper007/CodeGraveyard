VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form Class 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Class Builder"
   ClientHeight    =   8895
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10350
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   ScaleHeight     =   8895
   ScaleWidth      =   10350
   Begin VB.CommandButton CMDUpdater 
      Caption         =   "Updater"
      Height          =   375
      Left            =   7200
      TabIndex        =   48
      Top             =   8520
      Width           =   1335
   End
   Begin VB.CommandButton CmdExit 
      Caption         =   "&Quit"
      Height          =   375
      Left            =   9000
      TabIndex        =   11
      Top             =   8520
      Width           =   1335
   End
   Begin TabDlg.SSTab Options 
      Height          =   8295
      Left            =   3840
      TabIndex        =   10
      Top             =   120
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   14631
      _Version        =   393216
      Tabs            =   6
      Tab             =   5
      TabsPerRow      =   6
      TabHeight       =   450
      ShowFocusRect   =   0   'False
      TabCaption(0)   =   "1"
      TabPicture(0)   =   "Class.frx":0000
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "TxtPart1"
      Tab(0).Control(1)=   "TxtPart2"
      Tab(0).Control(2)=   "TxtPart3"
      Tab(0).Control(3)=   "TxtPart4"
      Tab(0).Control(4)=   "TxtHeader"
      Tab(0).Control(5)=   "zLabel2"
      Tab(0).Control(6)=   "zLabel5"
      Tab(0).Control(7)=   "zLabel6"
      Tab(0).Control(8)=   "zLabel7"
      Tab(0).Control(9)=   "zLabel8"
      Tab(0).ControlCount=   10
      TabCaption(1)   =   "2"
      TabPicture(1)   =   "Class.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "zLabel9"
      Tab(1).Control(1)=   "zLabel18"
      Tab(1).Control(2)=   "TxtPart6"
      Tab(1).Control(3)=   "TxtPart5"
      Tab(1).ControlCount=   4
      TabCaption(2)   =   "3"
      TabPicture(2)   =   "Class.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "TxtPart7"
      Tab(2).ControlCount=   1
      TabCaption(3)   =   "4"
      TabPicture(3)   =   "Class.frx":0054
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "zLabel12"
      Tab(3).Control(1)=   "TxtPart8"
      Tab(3).ControlCount=   2
      TabCaption(4)   =   "5"
      TabPicture(4)   =   "Class.frx":0070
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "zLabel17"
      Tab(4).Control(1)=   "zLabel16"
      Tab(4).Control(2)=   "zLabel13"
      Tab(4).Control(3)=   "zLabel14"
      Tab(4).Control(4)=   "TXTDefaultField"
      Tab(4).Control(5)=   "TxtPart9"
      Tab(4).Control(6)=   "TXTProperty1"
      Tab(4).Control(7)=   "TxtPart6A"
      Tab(4).Control(8)=   "TxtPart6B"
      Tab(4).Control(9)=   "TxtPart10"
      Tab(4).ControlCount=   10
      TabCaption(5)   =   "Path"
      TabPicture(5)   =   "Class.frx":008C
      Tab(5).ControlEnabled=   -1  'True
      Tab(5).Control(0)=   "ZLabel1"
      Tab(5).Control(0).Enabled=   0   'False
      Tab(5).Control(1)=   "zLabel3"
      Tab(5).Control(1).Enabled=   0   'False
      Tab(5).Control(2)=   "zLabel20"
      Tab(5).Control(2).Enabled=   0   'False
      Tab(5).Control(3)=   "Tables"
      Tab(5).Control(3).Enabled=   0   'False
      Tab(5).Control(4)=   "DirTables"
      Tab(5).Control(4).Enabled=   0   'False
      Tab(5).Control(5)=   "LstTables"
      Tab(5).Control(5).Enabled=   0   'False
      Tab(5).ControlCount=   6
      Begin VB.TextBox TxtPart10 
         Height          =   285
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   47
         Top             =   1920
         Width           =   6255
      End
      Begin VB.ListBox LstTables 
         Height          =   3180
         Left            =   240
         TabIndex        =   45
         Top             =   4680
         Width           =   3255
      End
      Begin VB.TextBox TxtPart6B 
         Height          =   855
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   44
         Top             =   7320
         Width           =   6255
      End
      Begin VB.DirListBox DirTables 
         Height          =   3690
         Left            =   240
         TabIndex        =   39
         Top             =   600
         Width           =   3255
      End
      Begin VB.FileListBox Tables 
         Height          =   3600
         Left            =   3600
         Pattern         =   "*.mdb"
         TabIndex        =   38
         Top             =   600
         Width           =   2655
      End
      Begin VB.TextBox TxtPart1 
         Height          =   645
         Left            =   -74760
         MultiLine       =   -1  'True
         TabIndex        =   32
         Top             =   2280
         Width           =   6135
      End
      Begin VB.TextBox TxtPart2 
         Height          =   885
         Left            =   -74760
         MultiLine       =   -1  'True
         TabIndex        =   31
         Top             =   3240
         Width           =   6135
      End
      Begin VB.TextBox TxtPart3 
         Height          =   1455
         Left            =   -74760
         MultiLine       =   -1  'True
         TabIndex        =   30
         Top             =   4320
         Width           =   6135
      End
      Begin VB.TextBox TxtPart4 
         Height          =   2175
         Left            =   -74760
         MultiLine       =   -1  'True
         TabIndex        =   29
         Top             =   6000
         Width           =   6135
      End
      Begin VB.TextBox TxtHeader 
         Height          =   1455
         Left            =   -74760
         MultiLine       =   -1  'True
         TabIndex        =   28
         Top             =   600
         Width           =   6135
      End
      Begin VB.TextBox TxtPart5 
         Height          =   4575
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   25
         Top             =   600
         Width           =   6255
      End
      Begin VB.TextBox TxtPart6 
         Height          =   2775
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   24
         Top             =   5400
         Width           =   6255
      End
      Begin VB.TextBox TxtPart7 
         Height          =   7455
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   22
         Top             =   720
         Width           =   6255
      End
      Begin VB.TextBox TxtPart8 
         Height          =   7455
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   20
         Top             =   720
         Width           =   6255
      End
      Begin VB.TextBox TxtPart6A 
         Height          =   1095
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   15
         Top             =   6120
         Width           =   6255
      End
      Begin VB.TextBox TXTProperty1 
         Height          =   2175
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   14
         Top             =   3600
         Width           =   6255
      End
      Begin VB.TextBox TxtPart9 
         Height          =   1095
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   13
         Top             =   720
         Width           =   6255
      End
      Begin VB.TextBox TXTDefaultField 
         Height          =   735
         Left            =   -74880
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   2520
         Width           =   6255
      End
      Begin VB.Label zLabel20 
         Caption         =   "Select Table."
         Height          =   255
         Left            =   240
         TabIndex        =   46
         Top             =   4440
         Width           =   2655
      End
      Begin VB.Label zLabel18 
         Caption         =   "Fields are moved from the recordset -"
         Height          =   255
         Left            =   -74880
         TabIndex        =   42
         Top             =   5160
         Width           =   5895
      End
      Begin VB.Label zLabel3 
         Caption         =   "Select Database."
         Height          =   255
         Left            =   3600
         TabIndex        =   41
         Top             =   360
         Width           =   2655
      End
      Begin VB.Label ZLabel1 
         Caption         =   "Select Directory."
         Height          =   255
         Left            =   240
         TabIndex        =   40
         Top             =   360
         Width           =   1815
      End
      Begin VB.Label zLabel2 
         Caption         =   "Header"
         Height          =   255
         Left            =   -74760
         TabIndex        =   37
         Top             =   360
         Width           =   3735
      End
      Begin VB.Label zLabel5 
         Caption         =   "Constant definitions of string sizes go here -"
         Height          =   255
         Left            =   -74760
         TabIndex        =   36
         Top             =   2040
         Width           =   4455
      End
      Begin VB.Label zLabel6 
         Caption         =   "Varible definitions of fields -"
         Height          =   255
         Left            =   -74760
         TabIndex        =   35
         Top             =   3000
         Width           =   4455
      End
      Begin VB.Label zLabel7 
         Caption         =   "Boolean varible definitions of fields to track updates -"
         Height          =   255
         Left            =   -74760
         TabIndex        =   34
         Top             =   4080
         Width           =   4335
      End
      Begin VB.Label zLabel8 
         Caption         =   "Boolean varibles are cleared here -"
         Height          =   255
         Left            =   -74760
         TabIndex        =   33
         Top             =   5760
         Width           =   4575
      End
      Begin VB.Label zLabel9 
         Caption         =   "Property definitions for fields here -"
         Height          =   255
         Left            =   -74880
         TabIndex        =   27
         Top             =   360
         Width           =   4575
      End
      Begin VB.Label zLabel10 
         Caption         =   "Fields are copied to varibles here -"
         Height          =   255
         Left            =   -74880
         TabIndex        =   26
         Top             =   5160
         Width           =   3015
      End
      Begin VB.Label zLabel11 
         Caption         =   "Fields are written into the SQL array"
         Height          =   255
         Left            =   -74880
         TabIndex        =   23
         Top             =   480
         Width           =   4455
      End
      Begin VB.Label zLabel12 
         Caption         =   "Fields are defined here in as string to create a record - "
         Height          =   255
         Left            =   -74880
         TabIndex        =   21
         Top             =   480
         Width           =   4455
      End
      Begin VB.Label zLabel14 
         Caption         =   "Property structure -"
         Height          =   255
         Left            =   -74880
         TabIndex        =   19
         Top             =   3360
         Width           =   2895
      End
      Begin VB.Label zLabel13 
         Caption         =   "A set of 'if' statements to set default values for fields"
         Height          =   255
         Left            =   -74880
         TabIndex        =   18
         Top             =   480
         Width           =   4455
      End
      Begin VB.Label zLabel16 
         Caption         =   "Structures -----"
         Height          =   255
         Left            =   -74880
         TabIndex        =   17
         Top             =   2280
         Width           =   5415
      End
      Begin VB.Label zLabel17 
         Caption         =   "Conditional write used in write record() function -----"
         Height          =   375
         Left            =   -74880
         TabIndex        =   16
         Top             =   5880
         Width           =   4215
      End
   End
   Begin VB.CommandButton CmdSave 
      Caption         =   "Save Structure"
      Height          =   375
      Left            =   5400
      TabIndex        =   9
      Top             =   8520
      Width           =   1335
   End
   Begin VB.CommandButton CmdLoad 
      Caption         =   "Load Structure"
      Height          =   375
      Left            =   3960
      TabIndex        =   8
      Top             =   8520
      Width           =   1335
   End
   Begin VB.TextBox TxtFieldName 
      Height          =   375
      Left            =   0
      TabIndex        =   7
      Top             =   8040
      Width           =   3735
   End
   Begin VB.ListBox LstFields2 
      Height          =   6495
      Left            =   1920
      TabIndex        =   6
      Top             =   1440
      Width           =   1815
   End
   Begin VB.CommandButton CmdReadTable 
      Caption         =   "&Read Table"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   720
      Width           =   1335
   End
   Begin VB.CommandButton CmdClass 
      Caption         =   "&Make Class"
      Height          =   375
      Left            =   0
      TabIndex        =   3
      Top             =   8520
      Width           =   1335
   End
   Begin VB.ListBox LstFields 
      Height          =   6495
      Left            =   0
      TabIndex        =   2
      Top             =   1440
      Width           =   1815
   End
   Begin VB.TextBox TxtDataBaseName 
      Height          =   375
      Left            =   1440
      TabIndex        =   0
      Text            =   "test"
      Top             =   120
      Width           =   2295
   End
   Begin VB.Label zLabel19 
      Caption         =   "Select to change -"
      Height          =   255
      Left            =   1920
      TabIndex        =   43
      Top             =   1200
      Width           =   1815
   End
   Begin VB.Label zLabel4 
      Caption         =   "Select Key field -"
      Height          =   255
      Left            =   0
      TabIndex        =   5
      Top             =   1200
      Width           =   1815
   End
   Begin VB.Label zLabel15 
      Caption         =   "Table name -"
      Height          =   255
      Left            =   0
      TabIndex        =   1
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "Class"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Class builder
''
'' Coded by Dale Pitman

Private vFieldNames(100) As String   ' fieldnames within class/program
Private vFieldNames2(100) As String  ' actual field names
Private vFieldData(100) As Variant   ' Not used
Private vFieldType(100) As Long      ' Field type
Private vFieldSize(100) As Long
Private vNumberFields As Long        ' Number of fields in selected table
Private vKeyFieldID As Long          ' Currently selected unique field
Private vStructureLoaded As Long     ' File containing structure of class, is loaded?


Private Sub CmdClass_Click()
    Dim FileID As Long
    Dim i As Long
    Dim TempString As String
    
    If (vStructureLoaded = True) Then
        FileID = FreeFile
        Open AppPath & "c" & TxtDataBaseName.Text & ".cls" For Output As FileID
        TempString = Replace(TxtHeader.Text, "<TableName>", TxtDataBaseName.Text)
        Print #FileID, TempString
        ' "CONSTANTS" definitions for string sizes
        'For i = 0 To NumberFields
        '    If (FieldSize(i) = 0) Then
        '        FieldSize(i) = 255
        '    End If
        '    Print #FileID, " const v" & FieldNames(i) & "Size = " & FieldSize(i)
        'Next
        
        Print #FileID, TxtPart1.Text
        
        ' "DIMS" for fields
        For i = 0 To vNumberFields
            Print #FileID, " Private v" & vFieldNames(i) & " As " & GetFieldStringDim(vFieldType(i))
        Next
        Print #FileID, TxtPart2.Text
        
        ' "DIMS" for field booleans
        For i = 0 To vNumberFields
            Print #FileID, " Private v" & vFieldNames(i) & "C As Boolean"
        Next
        Print #FileID, TxtPart3.Text
        
        ' reset function for field booleans, and clear values
        For i = 0 To vNumberFields
            Print #FileID, "    v" & vFieldNames(i) & "C = False"
            If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then ' if string
                Print #FileID, "    v" & vFieldNames(i) & " = " & Chr$(34) & Chr$(34)
            Else
                Print #FileID, "    v" & vFieldNames(i) & " = 0"
            End If
        Next
        
        Print #FileID, TxtPart4.Text
        ' property definitions for each field
        For i = 0 To vNumberFields
            TempString = Replace(TXTProperty1.Text, "<FieldName>", vFieldNames(i))
            ' Field alias here - ********************************************************************
            TempString = Replace(TempString, "<FieldName2>", vFieldNames(i))
            TempString = Replace(TempString, "<FieldType>", GetFieldString(vFieldType(i)))
'            If (FieldType(i) = 10 Or FieldType(i) = 12) Then
'                tempstring = Replace(tempstring, "<NewValue>", "trim(left$(NewValue,v" & FieldNames(i) & "Size))")
'            Else
                TempString = Replace(TempString, "<NewValue>", "NewValue")
'            End If
            Print #FileID, TempString
        Next
        
        ' Read Record - sql where x=xx
        TempString = Replace(TxtPart5.Text, "<TableName>", TxtDataBaseName.Text)
        TempString = Replace(TempString, "<KeyField>", vFieldNames(vKeyFieldID))
        TempString = Replace(TempString, "<KeyField2>", vFieldNames2(vKeyFieldID))
        Print #FileID, TempString
        
        ' read record - moves from record set to fields
        For i = 0 To vNumberFields
            If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then ' if string
                Print #FileID, "        v" & vFieldNames(i) & " = rsSearch!" & vFieldNames2(i) & " & " & Chr(34) & Chr(34)
            Else
                If (vFieldType(i) = 8) Then  ' Date type
                    Print #FileID, "        If (IsDate(rsSearch!" & vFieldNames(i) & ")) Then"
                    Print #FileID, "            v" & vFieldNames(i) & " = rsSearch!" & vFieldNames2(i) & " & " & Chr(34) & Chr(34)
                    Print #FileID, "        End If"
                Else
                    Print #FileID, "        v" & vFieldNames(i) & " = Val(rsSearch!" & vFieldNames2(i) & " & " & Chr$(34) & Chr$(34) & ")"
                End If
            End If
            
        Next
        
        ' Write record start
        TempString = Replace(TxtPart6.Text, "<TableName>", TxtDataBaseName.Text)
        Print #FileID, TempString
        ' Write record - sql key field definition
        'Print #FileID, "    sql = sql & " & Chr(34) & FieldNames2(KeyFieldID) & " = " & Chr(34) & " & v" & FieldNames(KeyFieldID)
        
        ' Write record - moves records into sql "UPDATE" string
        For i = 0 To vNumberFields
            If (i <> vKeyFieldID) Then
                If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then
                    TempString = Replace(TxtPart6A.Text, "<FieldName>", vFieldNames2(i))
                    TempString = Replace(TempString, "<FieldName2>", vFieldNames2(i))
                    TempString = Replace(TempString, "<FieldType>", GetFieldString(vFieldType(i)))
                Else
                    TempString = Replace(TxtPart6B.Text, "<FieldName>", vFieldNames2(i))
                    TempString = Replace(TempString, "<FieldName2>", vFieldNames2(i))
                    TempString = Replace(TempString, "<FieldType>", GetFieldString(vFieldType(i)))
                End If
                Print #FileID, TempString
            End If
        Next
        
        ' Write record - end + Create record - start
        TempString = Replace(TxtPart7.Text, "<KeyFieldName>", vFieldNames(vKeyFieldID))
        TempString = Replace(TempString, "<KeyFieldName2>", vFieldNames2(vKeyFieldID))
        TempString = Replace(TempString, "<TableName>", TxtDataBaseName.Text)
        Print #FileID, TempString
        
        'create record - fields to be created
        Print #FileID, "    sql = sql & " & Chr(34) & vFieldNames2(0) & Chr(34)
        
        ' Create Record - field values
        If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then
            Print #FileID, "    FieldData = FieldData & " & Chr(34) & "," & Chr(34) & " & Chr(34) &" & "v " & vFieldNames(i) & " & Chr(34) "
        Else
            Print #FileID, "    FieldData = FieldData & " & " v" & vFieldNames(0)
        End If
        For i = 1 To vNumberFields
'            If (FieldType(i) = 10 Or FieldType(i) = 12) Then
'                Print #FileID, "    sql = sql & " & "," & Chr(34) & FieldNames2(i) & Chr(34)
'            Else

                Print #FileID, "    If (" & "v" & vFieldNames(i) & "C= True) Then"
                Print #FileID, "        sql = sql & " & Chr(34) & "," & vFieldNames2(i) & Chr(34)
'
            If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then
                Print #FileID, "        FieldData = FieldData & " & Chr(34) & "," & Chr(34) & " & Chr(34) & " & "v" & vFieldNames(i) & " & Chr(34) "
            Else
                Print #FileID, "        FieldData = FieldData & " & Chr(34) & "," & Chr(34) & " & v" & vFieldNames(i)
            End If
'
                
                Print #FileID, "    End if"
'            End If
        Next
'        Print #FileID, "    sql = sql &" & Chr(34) & ") VALUES (" & Chr(34)
        
'        For i = 1 To vNumberFields
'            Print #FileID, "    If (" & "v" & vFieldNames(i) & "C= True) Then"
'            Print #FileID, "    End if"
'        Next
'        Print #FileID, "    sql = sql &" & Chr(34) & ") " & Chr(34)
        
        ' Create Record - end
        TempString = Replace(TxtPart8.Text, "<TableName>", TxtDataBaseName.Text)
        TempString = Replace(TempString, "<KeyField>", vFieldNames(vKeyFieldID))
        TempString = Replace(TempString, "<KeyField2>", vFieldNames2(vKeyFieldID))
        Print #FileID, TempString
        
        ' Set Default Values - For fields
        For i = 0 To vNumberFields
            TempString = Replace(TXTDefaultField.Text, "<FieldName>", vFieldNames(i))
            If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then
                TempString = Replace(TempString, "<DefaultVal>", Chr(34) & Chr(34))
            Else
                TempString = Replace(TempString, "<DefaultVal>", "0")
            End If
            Print #FileID, TempString
        Next
        
        ' Default values function, LoadFromSearch function
        Print #FileID, TxtPart9.Text
        
        ' LoadFromSearch function - moves from record set to fields
        For i = 0 To vNumberFields
            If (vFieldType(i) = 10 Or vFieldType(i) = 12) Then ' if string
                Print #FileID, "        v" & vFieldNames(i) & " = vrsSearch!" & vFieldNames2(i) & " & " & Chr(34) & Chr(34)
            Else
                If (vFieldType(i) = 8) Then  ' Date type
                    Print #FileID, "        If (IsDate(vrsSearch!" & vFieldNames(i) & ")) Then"
                    Print #FileID, "            v" & vFieldNames(i) & " = vrsSearch!" & vFieldNames2(i) & " & " & Chr(34) & Chr(34)
                    Print #FileID, "        End If"
                Else    ' Numeric
                    Print #FileID, "        v" & vFieldNames(i) & " = Val(vrsSearch!" & vFieldNames2(i) & " & " & Chr$(34) & Chr$(34) & ")"
                End If
            End If
        Next
        
        ' End of LoadfromSearch function - move recordset to next record, updates record number
        Print #FileID, TxtPart10.Text
        
        Close #FileID
    Else
        Call MsgBox("ERROR: No structure loaded")
    End If
End Sub


Private Sub CmdReadTable_Click()
    Dim rsClassTable As Recordset
    Dim tempname As String
    Dim i As Long
    
    Call LstFields.Clear
    Call LstFields2.Clear
    
    tempname = LstTables.List(LstTables.ListIndex)
    'If (Len(tempname) > 8 + 4) Then
    '    tempname = Left(tempname, 6) & "~1.dbf"
    'End If
    Set rsClassTable = db.OpenRecordset(tempname, dbOpenTable)
    
    vNumberFields = rsClassTable.Fields.Count - 1
    
    For i = 0 To vNumberFields
        vFieldNames(i) = UCase(Left(rsClassTable.Fields(i).Name, 1)) & LCase(Right(rsClassTable.Fields(i).Name, Len(rsClassTable.Fields(i).Name) - 1))
        vFieldNames2(i) = UCase(Left(rsClassTable.Fields(i).Name, 1)) & LCase(Right(rsClassTable.Fields(i).Name, Len(rsClassTable.Fields(i).Name) - 1))
        If (UCase(rsClassTable.Fields(i).Name) = "TYPE") Then
            Call MsgBox("WARNING: Field name 'Type' is a reserved word in VB6")
        End If
        vFieldType(i) = rsClassTable.Fields(i).Type
        vFieldSize(i) = rsClassTable.Fields(i).Size
        LstFields.AddItem (vFieldNames(i) & "-" & vFieldType(i)) & "=" & vFieldSize(i)
        LstFields2.AddItem (vFieldNames(i))
    Next
End Sub

Private Sub CmdSave_Click()
    Dim FileID As Long
    FileID = FreeFile
    
    If (vStructureLoaded = True) Then
        Open AppPath & "structure2.txt" For Output As FileID
        Print #FileID, TxtHeader.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart1.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart2.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart3.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart4.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart5.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart6.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart7.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart8.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart9.Text
        Print #FileID, "[Section]"
        
        Print #FileID, TXTDefaultField.Text
        Print #FileID, "[Section]"
        Print #FileID, TXTProperty1.Text
        Print #FileID, "[Section]"
        Print #FileID, TxtPart6A.Text
        Print #FileID, "[Section]"
        Close #FileID
    Else
        MsgBox ("Structure not loaded")
    End If
End Sub

Private Function GetPart(FileID As Long) As String
    Dim CurrentLine As String
    GetPart = ""
    Do While ((Not (EOF(FileID))) And CurrentLine <> "[Section]")
        Line Input #FileID, CurrentLine
        If (CurrentLine <> "[Section]") Then
            GetPart = GetPart & CurrentLine & Chr(13) & Chr(10)
        End If
    Loop
    GetPart = Left(GetPart, Len(GetPart) - 2)
End Function


Private Sub CmdLoad_Click()
    Dim FileID As Long
    
    vStructureLoaded = True
    FileID = FreeFile
    Open AppPath & "structure2.txt" For Input As FileID
    TxtHeader.Text = GetPart(FileID)
    TxtPart1.Text = GetPart(FileID)
    TxtPart2.Text = GetPart(FileID)
    TxtPart3.Text = GetPart(FileID)
    TxtPart4.Text = GetPart(FileID)
    TxtPart5.Text = GetPart(FileID)
    TxtPart6.Text = GetPart(FileID)
    TxtPart7.Text = GetPart(FileID)
    TxtPart8.Text = GetPart(FileID)
    TxtPart9.Text = GetPart(FileID)
    TxtPart10.Text = GetPart(FileID)
    TXTDefaultField.Text = GetPart(FileID)
    TXTProperty1.Text = GetPart(FileID)
    TxtPart6A.Text = GetPart(FileID)
    TxtPart6B.Text = GetPart(FileID)
    Close #FileID
End Sub

Private Sub CMDUpdater_Click()
    Call ClassUpdater.Show
End Sub

Private Sub DirTables_Change()
    Tables.Path = DirTables.Path
End Sub

Private Sub LstTables_Click()
    TxtDataBaseName = LstTables.List(LstTables.ListIndex)
    Call CmdReadTable_Click
End Sub

Private Sub Tables_Click()
    Dim i As Long
    Set db = DBEngine.OpenDatabase(Tables.Path & "\" & Tables.List(Tables.ListIndex), False, False)
    For i = 0 To db.TableDefs.Count - 1
        LstTables.AddItem (db.TableDefs(i).Name)
    Next
End Sub

Private Sub LstFields_Click()
    vKeyFieldID = LstFields.ListIndex
End Sub

Private Sub LstFields2_Click()
    TxtFieldName.Text = LstFields2.List(LstFields2.ListIndex)
End Sub

Private Sub TxtFieldName_KeyPress(KeyAscii As Integer)
    LstFields2.List(LstFields2.ListIndex) = TxtFieldName.Text
    vFieldNames(LstFields2.ListIndex) = TxtFieldName.Text
    If KeyAscii = 13 Then KeyAscii = 0: SendKeys Chr$(9)
End Sub

' Sync list boxes -
Private Sub LstFields_Scroll()
    LstFields2.TopIndex = LstFields.TopIndex
End Sub
Private Sub LstFields2_Scroll()
    LstFields.TopIndex = LstFields2.TopIndex
End Sub

Private Sub CmdExit_Click()
    Call Unload(Me)
End Sub

Private Sub Form_Load()
    vStructureLoaded = False
    Call CmdLoad_Click
End Sub

