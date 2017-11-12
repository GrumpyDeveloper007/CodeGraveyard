Attribute VB_Name = "GlobalFunctions"
Option Explicit
''*************************************************************************
'' Global generic functions
''
'' Coded by Dale Pitman
''

'' Set form focus in a MDI interface
Public Function SetFocus(pCurrentForm As Form) As Long
    ' Set form to normal / Set to front
    pCurrentForm.WindowState = vbNormal
    Call pCurrentForm.ZOrder(0)
End Function

'' Set printer by name
Public Function SetPrinter(Name As String) As Boolean
    Dim CurrentPrinter As Printer
    Dim NumPrinters As Long
    NumPrinters = Printers.Count
    
    SetPrinter = False
    If (NumPrinters > 0) Then
        ' If no name the set to default
        If (Name <> "") Then
            For Each CurrentPrinter In Printers
                If UCase$(CurrentPrinter.DeviceName) = UCase$(Name) Then
                    Set Printer = CurrentPrinter
                    SetPrinter = True
                End If
            Next CurrentPrinter
        Else
            SetPrinter = True
            Set Printer = Printers(1)
        End If
    Else
        ' Error no printers
    End If
End Function

'' Centralise screen, only works with MDI, named frmMain
Public Sub MDICenterScreen(pForm As Form)
    pForm.Left = (FrmMain.Width - pForm.Width) / 2
    pForm.Top = (FrmMain.Height - pForm.Height) / 2
End Sub

