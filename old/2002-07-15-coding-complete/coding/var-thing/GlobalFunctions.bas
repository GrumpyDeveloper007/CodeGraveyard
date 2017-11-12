Attribute VB_Name = "GlobalFunctions"
Option Explicit
'' Global generic functions
''


'' Set form focus in a MDI interface
Public Function SetFocus(pCurrentForm As Form) As Long
    ' Set form to normal / Set to front
    pCurrentForm.WindowState = vbNormal
    Call pCurrentForm.ZOrder(0)
End Function

'' Center screen
Public Function CenterScreen(pForm As Form) As Boolean
    Dim i As Long
    Dim MinX As Long
    Dim MinY As Long
    Dim MaxX As Long
    Dim MaxY As Long
    Dim OffsetX As Long
    Dim OffsetY As Long
    
    MinX = pForm.Controls(0).Left
    MinY = pForm.Controls(0).Top
    MaxX = pForm.Controls(0).Left + pForm.Controls(0).Width
    MaxY = pForm.Controls(0).Top + pForm.Controls(0).Height
    
    ' Get top left, bottom right position of controls
    For i = 1 To pForm.Controls.Count - 1
        If (pForm.Controls(i).Left < MinX) Then
            MinX = pForm.Controls(i).Left
        End If
        If (pForm.Controls(i).Top < MinY) Then
            MinY = pForm.Controls(i).Top
        End If
        If (pForm.Controls(i).Left + pForm.Controls(i).Width > MaxX) Then
            MaxX = pForm.Controls(i).Left + pForm.Controls(i).Width
        End If
        If (pForm.Controls(i).Top + pForm.Controls(i).Height > MaxY) Then
            MaxY = pForm.Controls(i).Top + pForm.Controls(i).Height
        End If
    
    Next
    ' Calculate offset from width of client area - area used by controls / 2
    OffsetX = (pForm.ScaleWidth - (MaxX - MinX)) / 2
    OffsetY = (pForm.ScaleHeight - (MaxY - MinY)) / 2
    
    ' Move all controls by offset
    For i = 0 To pForm.Controls.Count - 1
        ' Don't move objects that are in containers
        If (pForm.Controls(i).Container.Name = pForm.Name) Then
            pForm.Controls(i).Left = pForm.Controls(i).Left + OffsetX
            pForm.Controls(i).Top = pForm.Controls(i).Top + OffsetY
        End If
    Next
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
    pForm.Left = (pForm.Width - pForm.Width) / 2
    pForm.Top = (pForm.Height - pForm.Height) / 2
End Sub

Public Function ConnectDatabases() As Boolean
Dim SystemPath As String
Dim SettingsPath As String
Dim KeepChecking As Boolean
KeepChecking = True
SystemPath = GetSetting("Service Manager", "Settings", "servicemanager.mdb", "****")
SettingsPath = GetSetting("Service Manager", "Settings", "settings.mdb", "****")
Do While (KeepChecking = True)
    If (Dir(SystemPath) = "") Or SystemPath = "****" Then
        SystemPath = LocateDatabase("servicemanager.mdb")
        If (SystemPath = "****") Then
            If (MsgBox("You cannot run this program without the database.  Do you want to look again?", vbQuestion + vbYesNo, "Unable to Continue") = vbNo) Then
                ConnectDatabases = False
                Exit Function
            End If
        End If
    Else
        KeepChecking = False
    End If
Loop
KeepChecking = True
Do While KeepChecking = True
    If (Dir(SettingsPath) = "") Or SettingsPath = "****" Then
        SettingsPath = LocateDatabase("settings.mdb")
        If (SettingsPath = "****") Then
            If (MsgBox("You cannot run this program without the database.  Do you want to look again?", vbQuestion + vbYesNo, "Unable to continue") = vbNo) Then
                ConnectDatabases = False
                Exit Function
            End If
        Else
            KeepChecking = False
        End If
    Else
        KeepChecking = False
    End If
Loop
Set SysDB = DBEngine.OpenDatabase(SystemPath, False, False)
Set SetDB = DBEngine.OpenDatabase(SettingsPath, False, False)
End Function

Private Function LocateDatabase(DatabaseName As String) As String
On Error GoTo Dialog_Cancelled
With MDIServiceManager.CommonDialogControl
    .Filter = DatabaseName & "|" & DatabaseName
    .CancelError = True
    .DialogTitle = "Locate " & DatabaseName & " database"
    .ShowOpen
    SaveSetting "Service Manager", "Settings", DatabaseName, .FileName
    LocateDatabase = .FileName
End With
Exit Function
Dialog_Cancelled:
    LocateDatabase = "****"
    Exit Function
End Function
Public Function FullTrim(TextString As String, Optional Postcode As Boolean) As String
Dim Counter As Long
Dim TempString As String
TempString = ""
For Counter = 1 To Len(TextString)
    TempString = TempString & Trim(Mid(TextString, Counter, 1))
Next Counter
If Postcode = True Then
    If (Len(TempString) > 5) Then
        TempString = Left(TempString, Len(TempString) - 3) & " " & Right(TempString, 3)
    End If
End If
FullTrim = TempString
End Function

