Attribute VB_Name = "GridSelectionHelpers"
Option Explicit

''
Public Function IsInGrid(pGrdName As fpList, pMatchVal As Long, pColoumn As Long) As Long
    Dim i As Long

    IsInGrid = -1
    pGrdName.Col = pColoumn
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        If (pMatchVal = pGrdName.ColList) Then
            IsInGrid = i
            Exit For
        End If
    Next
End Function

''
Public Function IsInGridString(pGrdName As fpList, pMatchVal As String, pColoumn As Long) As Long
    Dim i As Long

    IsInGridString = -1
    pGrdName.Col = pColoumn
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        If (pMatchVal = pGrdName.ColList) Then
            IsInGridString = i
            Exit For
        End If
    Next
End Function

''
Public Function IsInGrid2(pGrdName As fpList, pMatchVal As Long, pColoumn As Long, pMatchVal2 As String, pColoumn2 As Long) As Long
    Dim i As Long

    IsInGrid2 = -1
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        pGrdName.Col = pColoumn
        If (pMatchVal = pGrdName.ColList) Then
            pGrdName.row = i
            pGrdName.Col = pColoumn2
            If (pMatchVal2 = pGrdName.ColList) Then
                IsInGrid2 = pGrdName.row
                Exit For
            End If
        End If
    Next

End Function

''
Public Function IsGridSelected(pGrdName As fpList) As Boolean
    Dim i As Long

    IsGridSelected = False
    For i = 0 To pGrdName.ListCount - 1
        pGrdName.row = i
        If (pGrdName.Selected) Then
            IsGridSelected = True
        End If
    Next
End Function

