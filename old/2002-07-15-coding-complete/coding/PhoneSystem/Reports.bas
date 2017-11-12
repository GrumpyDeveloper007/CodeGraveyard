Attribute VB_Name = "Reports"
Option Explicit

''
Private Type UserReportColoumnTYPE
    OutGoingTotal As Long
    IncomingTotal As Long
    TransferedTotal As Long
    TransferedTotalFromVoice As Long
    OutGoingTotalDuration As Long
    IncomingTotalDuration As Long
    AnswerTimeDirect As Long
    AnswerTimeTransfered As Long
    AnswerTimeTransferedFromVoice As Long
    UnAnsweredTotal As Long
    UnAnsweredTotalZeroLength As Long
End Type


'' Direction 0-N/A, 1-Incoming, 2-Outgoing, 3-Both

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


Public Sub DailyReport(pDate As Date)
    Dim rstemp As Recordset
    Dim rstemp2 As Recordset
    Dim CurrentName As String
    
    Dim currentrecord As UserReportColoumnTYPE
    Dim Grand As UserReportColoumnTYPE
    Dim VoiceMail As UserReportColoumnTYPE
    Dim LastExtension As Long
    
    If (OpenRecordset(rstemp, "SELECT * FROM calls c LEFT OUTER JOIN extensions e ON c.extensionid=e.uid WHERE callDate>#" & Format(pDate, "mm/dd/yyyy") & "# AND calldate<#" & Format(DateAdd("d", 1, pDate), "mm/dd/yyyy") & "# ORDER BY E.name", dbOpenSnapshot)) Then
        If (rstemp.EOF = False) Then
            Printer.FontName = "Arial"
            Printer.FontSize = 16
            
            CurrentName = rstemp!Name & ""
            Printer.ScaleMode = vbTwips
            Call PrintX(CenterString("User Report for " & Format(pDate, "dd/mm/yyyy")), "User Report for " & Format(pDate, "dd/mm/yyyy"))
            Printer.ScaleMode = vbMillimeters
            Printer.Print ""
            Printer.Print ""
            Printer.FontSize = 10
            Call PrintX(40, "Number Of Calls")
            Call PrintX(75, "UnAnswered")
            Call PrintX(100, "Incoming")
            Call PrintX(120, "Duration")
            Call PrintX(160, "Answer Time(AVG)", True)
            Call PrintX(5, "Name")
            Call PrintX(40, "Outgoing")
            Call PrintX(58, "Incoming")
            Call PrintX(75, "(Engaged)")
            Call PrintX(100, "Transfered")
            Call PrintX(120, "Outgoing")
            Call PrintX(140, "Incoming")
            Call PrintX(160, "Direct")
            Call PrintX(180, "Transfered", True)
            Printer.DrawStyle = 0
            Printer.Line (0, Printer.CurrentY)-(Printer.ScaleWidth, Printer.CurrentY)
            Printer.Print ""
            Do While (rstemp.EOF = False)
            
                If (rstemp!Name <> CurrentName) Then
                    If (CurrentName = "") Then
                        CurrentName = "Others"
                    End If
                    If (LastExtension <> 265) Then
                        Call PrintX(5, AutoCase(CurrentName, True) & "[" & LastExtension & "]")
                        Call PrintX(40, CStr(currentrecord.OutGoingTotal))
                        Call PrintX(58, CStr(currentrecord.IncomingTotal))
                        Call PrintX(75, CStr(currentrecord.UnAnsweredTotal) & "(" & CStr(currentrecord.UnAnsweredTotalZeroLength) & ")")
                        Call PrintX(100, CStr(currentrecord.TransferedTotal))
                        Call PrintX(110, CStr(currentrecord.TransferedTotalFromVoice))
                        Call PrintX(120, SecondsToTime(currentrecord.OutGoingTotalDuration))
                        Call PrintX(140, SecondsToTime(currentrecord.IncomingTotalDuration))
                        If (currentrecord.IncomingTotal > 0) Then
                            currentrecord.AnswerTimeDirect = currentrecord.AnswerTimeDirect / currentrecord.IncomingTotal
                        End If
                        If (currentrecord.TransferedTotal > 0) Then
                            currentrecord.AnswerTimeTransfered = currentrecord.AnswerTimeTransfered / currentrecord.TransferedTotal
                        End If
                        Call PrintX(160, SecondsToTime(currentrecord.AnswerTimeDirect))
                        Call PrintX(180, SecondsToTime(currentrecord.AnswerTimeTransfered), True)
                        
                        If (CurrentName <> "Others") Then
                            Grand.TransferedTotal = Grand.TransferedTotal + currentrecord.TransferedTotal
                            Grand.OutGoingTotal = Grand.OutGoingTotal + currentrecord.OutGoingTotal
                            Grand.OutGoingTotalDuration = Grand.OutGoingTotalDuration + currentrecord.OutGoingTotalDuration
                            Grand.IncomingTotal = Grand.IncomingTotal + currentrecord.IncomingTotal
                            Grand.IncomingTotalDuration = Grand.IncomingTotalDuration + currentrecord.IncomingTotalDuration
                            Grand.AnswerTimeDirect = Grand.AnswerTimeDirect + currentrecord.AnswerTimeDirect
                            Grand.AnswerTimeTransfered = Grand.AnswerTimeTransfered + currentrecord.AnswerTimeTransfered
                            Grand.AnswerTimeTransferedFromVoice = Grand.AnswerTimeTransferedFromVoice + currentrecord.AnswerTimeTransferedFromVoice
                            Grand.TransferedTotalFromVoice = Grand.TransferedTotalFromVoice + currentrecord.TransferedTotalFromVoice
                            Grand.UnAnsweredTotal = Grand.UnAnsweredTotal + currentrecord.UnAnsweredTotal
                            Grand.UnAnsweredTotalZeroLength = Grand.UnAnsweredTotalZeroLength + currentrecord.UnAnsweredTotalZeroLength

                        Else
'                            Printer.Line (0, Printer.CurrentY)-(Printer.ScaleWidth, Printer.CurrentY)
                            Printer.Print ""
                        End If
                    Else
                        ' voice mail
                        
                        VoiceMail.TransferedTotal = currentrecord.TransferedTotal
                        VoiceMail.OutGoingTotal = currentrecord.OutGoingTotal
                        VoiceMail.OutGoingTotalDuration = currentrecord.OutGoingTotalDuration
                        VoiceMail.IncomingTotal = currentrecord.IncomingTotal
                        VoiceMail.IncomingTotalDuration = currentrecord.IncomingTotalDuration
                        VoiceMail.AnswerTimeDirect = currentrecord.AnswerTimeDirect
                        VoiceMail.AnswerTimeTransfered = currentrecord.AnswerTimeTransfered
                        VoiceMail.AnswerTimeTransferedFromVoice = currentrecord.AnswerTimeTransferedFromVoice
                        VoiceMail.TransferedTotalFromVoice = currentrecord.TransferedTotalFromVoice
                        VoiceMail.UnAnsweredTotal = currentrecord.UnAnsweredTotal
                        VoiceMail.UnAnsweredTotalZeroLength = currentrecord.UnAnsweredTotalZeroLength

                    End If
                    
                    currentrecord.OutGoingTotal = 0
                    currentrecord.OutGoingTotalDuration = 0
                    currentrecord.IncomingTotal = 0
                    currentrecord.IncomingTotalDuration = 0
                    currentrecord.TransferedTotal = 0
                    currentrecord.AnswerTimeDirect = 0
                    currentrecord.AnswerTimeTransfered = 0
                    currentrecord.AnswerTimeTransferedFromVoice = 0
                    currentrecord.TransferedTotalFromVoice = 0
                    currentrecord.UnAnsweredTotal = 0
                    currentrecord.UnAnsweredTotalZeroLength = 0
                    CurrentName = rstemp!Name & ""
                    LastExtension = rstemp!Extensionid
                End If
            
                If (rstemp!Previousid > 0) Then
                    If (rstemp!Direction = 1) Then
                        currentrecord.IncomingTotalDuration = currentrecord.IncomingTotalDuration + rstemp!Duration
                        If (OpenRecordset(rstemp2, "SELECT * FROM Calls WHERE uid=" & rstemp!Previousid, dbOpenSnapshot)) Then
                            If (rstemp2.EOF = False) Then
                                If (rstemp2!Extensionid = "265") Then
                                    currentrecord.TransferedTotalFromVoice = currentrecord.TransferedTotalFromVoice + 1
                                    currentrecord.AnswerTimeTransferedFromVoice = currentrecord.AnswerTimeTransferedFromVoice + Val(rstemp2!Duration)
                                Else
                                    currentrecord.TransferedTotal = currentrecord.TransferedTotal + 1
                                    currentrecord.AnswerTimeTransfered = currentrecord.AnswerTimeTransfered + Val(rstemp2!Duration)
                                End If
                            End If
                        End If
                    End If
                Else
                    currentrecord.AnswerTimeDirect = currentrecord.AnswerTimeDirect + Val(rstemp!AnswerTime)
                    If (rstemp!Direction = 2) Then
                        currentrecord.OutGoingTotal = currentrecord.OutGoingTotal + 1
                        currentrecord.OutGoingTotalDuration = currentrecord.OutGoingTotalDuration + rstemp!Duration
                    Else    '1
                        If (rstemp!UnanseredCall = 0) Then
                            currentrecord.IncomingTotal = currentrecord.IncomingTotal + 1
                            currentrecord.IncomingTotalDuration = currentrecord.IncomingTotalDuration + rstemp!Duration
                        Else
                            '
                            If (rstemp!AnswerTime = 0) Then
                                currentrecord.UnAnsweredTotalZeroLength = currentrecord.UnAnsweredTotalZeroLength + 1
                            Else
                                currentrecord.UnAnsweredTotal = currentrecord.UnAnsweredTotal + 1
                            End If
                        End If
                    End If
                End If
                Call rstemp.MoveNext
            Loop
            
            ' Print last group
            If (CurrentName = "") Then
                CurrentName = "Others"
            End If
            Call PrintX(5, AutoCase(CurrentName, True) & "[" & LastExtension & "]")
            Call PrintX(40, CStr(currentrecord.OutGoingTotal))
            Call PrintX(58, CStr(currentrecord.IncomingTotal))
            Call PrintX(75, CStr(currentrecord.UnAnsweredTotal) & "(" & CStr(currentrecord.UnAnsweredTotalZeroLength) & ")")
            Call PrintX(100, CStr(currentrecord.TransferedTotal))
            Call PrintX(110, CStr(currentrecord.TransferedTotalFromVoice))
            Call PrintX(120, SecondsToTime(currentrecord.OutGoingTotalDuration))
            Call PrintX(140, SecondsToTime(currentrecord.IncomingTotalDuration))
            If (currentrecord.IncomingTotal > 0) Then
                currentrecord.AnswerTimeDirect = currentrecord.AnswerTimeDirect / currentrecord.IncomingTotal
            End If
            If (currentrecord.TransferedTotal > 0) Then
                currentrecord.AnswerTimeTransfered = currentrecord.AnswerTimeTransfered / currentrecord.TransferedTotal
            End If
            Call PrintX(160, SecondsToTime(currentrecord.AnswerTimeDirect))
            Call PrintX(180, SecondsToTime(currentrecord.AnswerTimeTransfered), True)
            Grand.TransferedTotal = Grand.TransferedTotal + currentrecord.TransferedTotal
            Grand.OutGoingTotal = Grand.OutGoingTotal + currentrecord.OutGoingTotal
            Grand.OutGoingTotalDuration = Grand.OutGoingTotalDuration + currentrecord.OutGoingTotalDuration
            Grand.IncomingTotal = Grand.IncomingTotal + currentrecord.IncomingTotal
            Grand.IncomingTotalDuration = Grand.IncomingTotalDuration + currentrecord.IncomingTotalDuration
            Grand.AnswerTimeDirect = Grand.AnswerTimeDirect + currentrecord.AnswerTimeDirect
            Grand.AnswerTimeTransfered = Grand.AnswerTimeTransfered + currentrecord.AnswerTimeTransfered
            Grand.AnswerTimeTransferedFromVoice = Grand.AnswerTimeTransferedFromVoice + currentrecord.AnswerTimeTransferedFromVoice
            Grand.TransferedTotalFromVoice = Grand.TransferedTotalFromVoice + currentrecord.TransferedTotalFromVoice
            Grand.UnAnsweredTotal = Grand.UnAnsweredTotal + currentrecord.UnAnsweredTotal
            Grand.UnAnsweredTotalZeroLength = Grand.UnAnsweredTotalZeroLength + currentrecord.UnAnsweredTotalZeroLength
            
            'totals
            Printer.Print ""
            Printer.Fontbold = True
            Call PrintX(5, "Total")
            Call PrintX(40, CStr(Grand.OutGoingTotal))
            Call PrintX(58, CStr(Grand.IncomingTotal))
            Call PrintX(75, CStr(Grand.UnAnsweredTotal) & "(" & CStr(Grand.UnAnsweredTotalZeroLength) & ")")
            Call PrintX(100, CStr(Grand.TransferedTotal))
            Call PrintX(110, CStr(Grand.TransferedTotalFromVoice))
            
            Call PrintX(120, SecondsToTime(Grand.OutGoingTotalDuration))
            Call PrintX(140, SecondsToTime(Grand.IncomingTotalDuration))
            Call PrintX(160, SecondsToTime(Grand.AnswerTimeDirect))
            Call PrintX(180, SecondsToTime(Grand.AnswerTimeTransfered), True)
            
            Printer.Fontbold = False
            
            Printer.Print ""
            Call PrintX(5, "VoiceMail")
            Call PrintX(40, CStr(VoiceMail.OutGoingTotal))
            Call PrintX(58, CStr(VoiceMail.IncomingTotal))
            Call PrintX(75, CStr(VoiceMail.UnAnsweredTotal) & "(" & CStr(VoiceMail.UnAnsweredTotalZeroLength) & ")")
            Call PrintX(100, CStr(VoiceMail.TransferedTotal))
            Call PrintX(110, CStr(VoiceMail.TransferedTotalFromVoice))
            
            Call PrintX(120, SecondsToTime(VoiceMail.OutGoingTotalDuration))
            Call PrintX(140, SecondsToTime(VoiceMail.IncomingTotalDuration))
            Call PrintX(160, SecondsToTime(VoiceMail.AnswerTimeDirect))
            Call PrintX(180, SecondsToTime(VoiceMail.AnswerTimeTransfered), True)
            Call PrintX(0, "", True)
            Call PrintX(5, "Total calls answered by voice mail, not transfered -" & (VoiceMail.IncomingTotal - (VoiceMail.TransferedTotalFromVoice + Grand.TransferedTotalFromVoice)), True)
            
            Printer.EndDoc
        End If
    End If
End Sub
