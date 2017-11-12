VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DataStore"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
' Should use sets or bags here, but what the hell

Const cForm = 1
Const cProcedure = 2
Const cVarible = 3

Private Type DataObjectType
    ItemType As Long
    ItemName As String
    ItemName2 As String
    ItemUsed As Long
    Next As Long
    Child As Long
    Parent As Long
End Type

' so here it is -
'
' n* forms -
'    n* procedures -
'       n* locals -

Const DataStoreMax = 32000
Dim Datastore(32000) As DataObjectType
Dim NumDataStore As Long

Dim SelectedForm As Long
Dim SelectedProcedure As Long
Dim SelectedVarible As Long
Public index As Long
Public Parent As Long
Dim Cursor As Long
Dim LinkStart As Long
Public IsUsed As Long

Private Function InsertItem(paramobj As DataObjectType) As Long
    Dim prelink As Long
    Do While (Datastore(LinkStart).Next > 0 And _
    UCase(Datastore(LinkStart).ItemName) < UCase(paramobj.ItemName))
        prelink = LinkStart
        LinkStart = Datastore(LinkStart).Next
    Loop
    
    If (UCase(Datastore(LinkStart).ItemName) < UCase(paramobj.ItemName)) Then
        paramobj.Next = Datastore(LinkStart).Next
        Datastore(LinkStart).Next = NumDataStore
    Else
        paramobj.Next = LinkStart
        Datastore(prelink).Next = NumDataStore
        ' Datastore(LinkStart).Next
        'Datastore(LinkStart).Next = NumDataStore
    End If
    Datastore(NumDataStore) = paramobj
End Function

' atm used blind insertion, maybe later it will use sorted insert
Private Function AddItem(paramobj As DataObjectType) As Long

    paramobj.Child = -1
    If (paramobj.ItemType = cForm) Then
        paramobj.Next = Datastore(0).Child
        paramobj.Parent = 0
    End If
    If (paramobj.ItemType = cProcedure) Then
        paramobj.Next = Datastore(SelectedForm).Child
        paramobj.Parent = SelectedForm
    End If
    If (paramobj.ItemType = cVarible) Then
        paramobj.Next = Datastore(SelectedProcedure).Child
        paramobj.Parent = SelectedProcedure
    End If
    LinkStart = paramobj.Next
    
    If (LinkStart > 0) Then
        If (UCase(Datastore(LinkStart).ItemName) < UCase(paramobj.ItemName)) Then
            Call InsertItem(paramobj)
            AddItem = NumDataStore
            NumDataStore = NumDataStore + 1
            Exit Function
        End If
    End If
    
        Datastore(NumDataStore) = paramobj
        AddItem = NumDataStore
    
        If (paramobj.ItemType = cForm) Then
            Datastore(0).Child = NumDataStore
        End If
        If (paramobj.ItemType = cProcedure) Then
            Datastore(SelectedForm).Child = NumDataStore
        End If
        If (paramobj.ItemType = cVarible) Then
            Datastore(SelectedProcedure).Child = NumDataStore
        End If
    
     NumDataStore = NumDataStore + 1
   
    If (NumDataStore > DataStoreMax) Then
        Call MsgBox("Error: Datastore overflow")
    End If
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function AddForm(Name As String)
    Dim tempobj As DataObjectType
    tempobj.ItemName = Name
    tempobj.ItemType = cForm
    SelectedForm = AddItem(tempobj)
End Function

Public Function AddProcedure(Name As String)
    Dim tempobj As DataObjectType
    tempobj.ItemName = Name
    tempobj.ItemType = cProcedure
    SelectedProcedure = AddItem(tempobj)
    
End Function

Public Function AddVarible(Name As String, VarType As String, IsUsed As Long)
    Dim tempobj As DataObjectType
    tempobj.ItemName = Name
    tempobj.ItemType = cVarible
    tempobj.ItemName2 = VarType
    tempobj.ItemUsed = IsUsed
    SelectedVarible = AddItem(tempobj)
    
End Function

Private Sub Class_Initialize()
    ' Init the god form
    Datastore(0).ItemName = "God"
    Datastore(0).ItemType = -1
    Datastore(0).Next = -1
    Datastore(0).Child = -1
    Datastore(0).Parent = -1
    NumDataStore = 1
    index = 0
End Sub

Public Function ResetCursor()
    Cursor = 0
End Function

Public Function GetNext() As String
    If (Datastore(Cursor).Child > 0) Then
        Cursor = Datastore(Cursor).Child
    Else
        If (Datastore(Cursor).Next > 0) Then
            Cursor = Datastore(Cursor).Next
        Else
            Do While (Datastore(Cursor).Next < 0)
                If (Datastore(Cursor).Parent > 0) Then
                    Cursor = Datastore(Cursor).Parent
                Else
                    GetNext = "End"
                    Exit Function
                End If
            Loop
            Cursor = Datastore(Cursor).Next
        End If
    End If
    IsUsed = Datastore(Cursor).ItemUsed
    Select Case Datastore(Cursor).ItemType
        Case -1
            GetNext = Datastore(Cursor).ItemName
        Case cForm
            GetNext = "X-" & Datastore(Cursor).ItemName
        Case cProcedure
            GetNext = "X---" & Datastore(Cursor).ItemName
        Case cVarible
            GetNext = "X-----" & Datastore(Cursor).ItemName & Space(30 - Len(Datastore(Cursor).ItemName)) & Datastore(Cursor).ItemName2
    End Select
End Function

