Attribute VB_Name = "Reports"
Option Explicit

Private Type EmployeeWeekTYPE
    Name As String
    StartMon As Date
    StartTue As Date
    StartWed As Date
    StartThu As Date
    StartFri As Date
    StartSat As Date
    StartSun As Date
    EndMon As Date
    EndTue As Date
    EndWed As Date
    EndThu As Date
    EndFri As Date
    EndSat As Date
    EndSun As Date
End Type

''
Public Sub PrintX(pXPos As Long, pString As String, Optional NewLine As Boolean = False)
    Printer.CurrentX = pXPos
    If (NewLine = False) Then
        Printer.Print pString;
    Else
        Printer.Print pString
    End If
End Sub

Public Sub UserTimeSheet(pStartDate As Date)
    Dim sql As String
    Dim rstemp As Recordset
    Dim EventStart As Boolean
    Dim duration As Long
    Dim UserName As String
    Dim Starttime As Date
    Dim Endtime As Date
    Dim i As Long
    
    Dim EmployeeWeek(1000) As EmployeeWeekTYPE
    Dim MaxEmployeeWeek As Long
    
    For i = 0 To 1000
        EmployeeWeek(i).EndMon = "09/09/1900"
        EmployeeWeek(i).EndTue = "09/09/1900"
        EmployeeWeek(i).EndWed = "09/09/1900"
        EmployeeWeek(i).EndThu = "09/09/1900"
        EmployeeWeek(i).EndFri = "09/09/1900"
        EmployeeWeek(i).EndSat = "09/09/1900"
        EmployeeWeek(i).EndSun = "09/09/1900"
        EmployeeWeek(i).StartMon = "01/01/9999"
        EmployeeWeek(i).StartTue = "01/01/9999"
        EmployeeWeek(i).StartWed = "01/01/9999"
        EmployeeWeek(i).StartThu = "01/01/9999"
        EmployeeWeek(i).StartFri = "01/01/9999"
        EmployeeWeek(i).StartSat = "01/01/9999"
        EmployeeWeek(i).StartSun = "01/01/9999"
    Next
    
    MaxEmployeeWeek = 0
'    Printer.Orientation = vbPRORPortrait
    Printer.FontName = "Arial"
    Printer.ScaleMode = vbMillimeters
    
    
    sql = "SELECT *" 'em.name,ev.eventtime
    sql = sql & " FROM ([Events] ev INNER JOIN E_Employee em ON ev.USERID=em.USERID) INNER JOIN E_EventAction ea ON ev.Eventtype=ea.eventtype AND ev.eventsubtype=ea.eventsubtype"
    sql = sql & " WHERE em.Include=True "
    'AND (ev.Eventtype=" & FRMOptions.StartEventType & " AND ev.EventSubType=" & FRMOptions.StartEventSubType & ") OR (ev.Eventtype=" & FRMOptions.EndEventType & " AND ev.EventSubType=" & FRMOptions.EndEventSubType & ")  "
    sql = sql & " AND ev.eventtime>=" & cDateChar & Format(pStartDate, "mm/dd/yyyy") & cDateChar
    sql = sql & " AND ev.eventtime<=" & cDateChar & Format(DateAdd("d", 8, pStartDate), "mm/dd/yyyy") & cDateChar
    
    sql = sql & " ORDER BY ev.userid,ev.eventtime"
    
    EventStart = False
    duration = 0
    
    If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
        
        If (rstemp.EOF = False) Then
        
            UserName = rstemp!Name
            EmployeeWeek(MaxEmployeeWeek).Name = UserName
        
            Do While (rstemp.EOF = False)
                If (UserName <> rstemp!Name) Then
    
                    UserName = rstemp!Name
                    MaxEmployeeWeek = MaxEmployeeWeek + 1
                    EmployeeWeek(MaxEmployeeWeek).Name = UserName
                End If
                If (rstemp!action = 1) Then
    '                    If (rstemp!eventsubtype = FRMOptions.StartEventSubType And rstemp!eventtype = FRMOptions.StartEventType) Then
                    Starttime = rstemp!eventtime
                    If (EventStart = True) Then
                        ' start without end
                        duration = 0
                        Select Case UCase$(Format(Starttime, "ddd"))
                            Case "MON"
                                If (EmployeeWeek(MaxEmployeeWeek).StartMon > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartMon = Starttime
                                End If
                            Case "TUE"
                                If (EmployeeWeek(MaxEmployeeWeek).StartTue > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartTue = Starttime
                                End If
                            Case "WED"
                                If (EmployeeWeek(MaxEmployeeWeek).StartWed > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartWed = Starttime
                                End If
                            Case "THU"
                                If (EmployeeWeek(MaxEmployeeWeek).StartThu > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartThu = Starttime
                                End If
                            Case "FRI"
                                If (EmployeeWeek(MaxEmployeeWeek).StartFri > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartFri = Starttime
                                End If
                            Case "SAT"
                                If (EmployeeWeek(MaxEmployeeWeek).StartSat > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartSat = Starttime
                                End If
                            Case "SUN"
                                If (EmployeeWeek(MaxEmployeeWeek).StartSun > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartSun = Starttime
                                End If
                        End Select
    '                    Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & Format(Starttime, "dd/mm/yyyy hh:mm") & cTextField & "," & cTextField & "***" & cTextField & "," & duration & ")", False)
                    Else
                    End If
                    EventStart = True
                End If
                If (rstemp!action = 2) Then
    '                    If (rstemp!eventsubtype = FRMOptions.EndEventSubType And rstemp!eventtype = FRMOptions.EndEventType) Then
                    Endtime = rstemp!eventtime
                    If (EventStart = True) Then
                        
                        Select Case UCase$(Format(Starttime, "ddd"))
                            Case "MON"
                                If (EmployeeWeek(MaxEmployeeWeek).StartMon > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartMon = Starttime
                                End If
                            Case "TUE"
                                If (EmployeeWeek(MaxEmployeeWeek).StartTue > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartTue = Starttime
                                End If
                            Case "WED"
                                If (EmployeeWeek(MaxEmployeeWeek).StartWed > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartWed = Starttime
                                End If
                            Case "THU"
                                If (EmployeeWeek(MaxEmployeeWeek).StartThu > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartThu = Starttime
                                End If
                            Case "FRI"
                                If (EmployeeWeek(MaxEmployeeWeek).StartFri > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartFri = Starttime
                                End If
                            Case "SAT"
                                If (EmployeeWeek(MaxEmployeeWeek).StartSat > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartSat = Starttime
                                End If
                            Case "SUN"
                                If (EmployeeWeek(MaxEmployeeWeek).StartSun > Starttime) Then
                                    EmployeeWeek(MaxEmployeeWeek).StartSun = Starttime
                                End If
                        End Select
                        Select Case UCase$(Format(Starttime, "ddd"))
                            Case "MON"
                                If (EmployeeWeek(MaxEmployeeWeek).EndMon < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndMon = Endtime
                                End If
                            Case "TUE"
                                If (EmployeeWeek(MaxEmployeeWeek).EndTue < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndTue = Endtime
                                End If
                            Case "WED"
                                If (EmployeeWeek(MaxEmployeeWeek).EndWed < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndWed = Endtime
                                End If
                            Case "THU"
                                If (EmployeeWeek(MaxEmployeeWeek).EndThu < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndThu = Endtime
                                End If
                            Case "FRI"
                                If (EmployeeWeek(MaxEmployeeWeek).EndFri < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndFri = Endtime
                                End If
                            Case "SAT"
                                If (EmployeeWeek(MaxEmployeeWeek).EndSat < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndSat = Endtime
                                End If
                            Case "SUN"
                                If (EmployeeWeek(MaxEmployeeWeek).EndSun < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndSun = Endtime
                                End If
                        End Select
                        duration = DateDiff("s", Starttime, Endtime)
    '                    Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & Format(Starttime, "dd/mm/yyyy hh:mm") & cTextField & "," & cTextField & Format(Endtime, "dd/mm/yyyy hh:mm") & cTextField & "," & duration & ")", False)
                        
                    Else
                        ' end without start
                        duration = 0
                        Select Case UCase$(Format(Starttime, "ddd"))
                            Case "MON"
                                If (EmployeeWeek(MaxEmployeeWeek).EndMon < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndMon = Endtime
                                End If
                            Case "TUE"
                                If (EmployeeWeek(MaxEmployeeWeek).EndTue < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndTue = Endtime
                                End If
                            Case "WED"
                                If (EmployeeWeek(MaxEmployeeWeek).EndWed < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndWed = Endtime
                                End If
                            Case "THU"
                                If (EmployeeWeek(MaxEmployeeWeek).EndThu < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndThu = Endtime
                                End If
                            Case "FRI"
                                If (EmployeeWeek(MaxEmployeeWeek).EndFri < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndFri = Endtime
                                End If
                            Case "SAT"
                                If (EmployeeWeek(MaxEmployeeWeek).EndSat < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndSat = Endtime
                                End If
                            Case "SUN"
                                If (EmployeeWeek(MaxEmployeeWeek).EndSun < Endtime) Then
                                    EmployeeWeek(MaxEmployeeWeek).EndSun = Endtime
                                End If
                        End Select
    '                    Call Execute("INSERT INTO [report1] (name,starttime,endtime,duration) VALUES (" & cTextField & UserName & cTextField & "," & cTextField & "***" & cTextField & "," & cTextField & Format(Endtime, "dd/mm/yyyy hh:mm") & cTextField & "," & duration & ")", False)
                    End If
                    EventStart = False
                End If
                Call rstemp.MoveNext
            Loop
            
            
            ' Page Headings
            Printer.fontsize = 20
            Printer.CurrentX = (Printer.ScaleWidth - Printer.TextWidth("Customer Statement")) / 2
            Printer.Print "User Time Sheet"
            Call PrintX(5, "", True)
            Call PrintX(5, "", True)
    
            ' Do Detail Headings
            Printer.fontsize = 10
            Printer.FontBold = True
            Call PrintX(5, "Name")
            Call PrintX(40, "Mon")
            Call PrintX(50, "Tue")
            Call PrintX(60, "Wed")
            Call PrintX(70, "Thr")
            Call PrintX(80, "Fri")
            Call PrintX(90, "Sat")
            Call PrintX(100, "Sun")
            
            Call PrintX(120, "Mon")
            Call PrintX(130, "Tue")
            Call PrintX(140, "Wed")
            Call PrintX(150, "Thr")
            Call PrintX(160, "Fri")
            Call PrintX(170, "Sat")
            Call PrintX(180, "Sun", True)
            Call PrintX(5, "", True)
            
            Printer.FontBold = False
            
            For i = 0 To MaxEmployeeWeek
                Call PrintX(5, EmployeeWeek(i).Name)
                If (Format(EmployeeWeek(i).StartMon, "hh:mm") <> "00:00") Then
                    Call PrintX(40, Format(EmployeeWeek(i).StartMon, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartTue, "hh:mm") <> "00:00") Then
                    Call PrintX(50, Format(EmployeeWeek(i).StartTue, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartWed, "hh:mm") <> "00:00") Then
                    Call PrintX(60, Format(EmployeeWeek(i).StartWed, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartThu, "hh:mm") <> "00:00") Then
                    Call PrintX(70, Format(EmployeeWeek(i).StartThu, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartFri, "hh:mm") <> "00:00") Then
                    Call PrintX(80, Format(EmployeeWeek(i).StartFri, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartSat, "hh:mm") <> "00:00") Then
                    Call PrintX(90, Format(EmployeeWeek(i).StartSat, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).StartSun, "hh:mm") <> "00:00") Then
                    Call PrintX(100, Format(EmployeeWeek(i).StartSun, "hh:mm"))
                End If
                
                If (Format(EmployeeWeek(i).EndMon, "hh:mm") <> "00:00") Then
                    Call PrintX(120, Format(EmployeeWeek(i).EndMon, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndTue, "hh:mm") <> "00:00") Then
                    Call PrintX(130, Format(EmployeeWeek(i).EndTue, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndWed, "hh:mm") <> "00:00") Then
                    Call PrintX(140, Format(EmployeeWeek(i).EndWed, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndThu, "hh:mm") <> "00:00") Then
                    Call PrintX(150, Format(EmployeeWeek(i).EndThu, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndFri, "hh:mm") <> "00:00") Then
                    Call PrintX(160, Format(EmployeeWeek(i).EndFri, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndSat, "hh:mm") <> "00:00") Then
                    Call PrintX(170, Format(EmployeeWeek(i).EndSat, "hh:mm"))
                End If
                If (Format(EmployeeWeek(i).EndSun, "hh:mm") <> "00:00") Then
                    Call PrintX(180, Format(EmployeeWeek(i).EndSun, "hh:mm"), True)
                Else
                    Call PrintX(180, "", True)
                End If
            Next
            
            
            ' page endings
            If (rstemp.EOF = False) Then
                Call Printer.NewPage
            End If
            Printer.FontBold = True
            ' Do Summary
    '            Call PrintX(120, FormatCurrency(Val(GrandTotalSum)))
            
            Printer.CurrentY = 245
            Printer.fontsize = 12
            
            
            Call Printer.EndDoc
        End If
    
    End If
End Sub
