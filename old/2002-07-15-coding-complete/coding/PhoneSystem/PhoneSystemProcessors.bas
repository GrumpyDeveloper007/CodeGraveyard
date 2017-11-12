Attribute VB_Name = "PhoneSystemProcessors"
Option Explicit

Public Function ProcessPhoneSystemString(pString As String) As TransactionDetailsTYPE
    Dim tempstring As String
    'ProcessPhoneSystemString.CallDate
    Select Case FRMOptions.PhoneSystem
        Case "PANASONIC_ISDN", "PANASONIC_KXTD"
            ' Validate record
            If (Val(Mid$(pString, 19, 3)) > 0) Then
                ProcessPhoneSystemString.lineNumber = Mid$(pString, 23, 2)
                ProcessPhoneSystemString.ExtensionNumber = Mid$(pString, 19, 3)
                If (Trim$(Mid$(pString, 26, 3)) = "<I>") Then
                    If (Trim$(Mid$(pString, 29, 19)) = "") Then
                        ProcessPhoneSystemString.PhoneNumber = "N/A"
                    Else
                        ProcessPhoneSystemString.PhoneNumber = Trim$(Mid$(pString, 29, 19)) '"N/A"
                    End If
                    ProcessPhoneSystemString.Direction = 1
                Else
                    ProcessPhoneSystemString.PhoneNumber = Trim$(Mid$(pString, 25, 22))
                    ProcessPhoneSystemString.Direction = 2
                End If
                tempstring = Mid$(pString, 54, 9)
                ProcessPhoneSystemString.Duration = Val(Mid$(tempstring, 1, 2)) * 60 * 60 + Val(Mid$(tempstring, 4, 2)) * 60 + Val(Mid$(tempstring, 7, 2))
                
                tempstring = Mid$(pString, 48, 4)
                ProcessPhoneSystemString.AnswerTime = Val(Mid$(tempstring, 1, 1)) * 60 + Val(Mid$(tempstring, 3, 2))
                
                tempstring = Mid$(pString, 1, 9) & " " & Mid$(pString, 9, 7)
                ProcessPhoneSystemString.CallDate = CDate(tempstring)
                If (Mid$(pString, 78, 2) = "TR") Then
                    ProcessPhoneSystemString.ContinuedCall = True
                Else
                    ProcessPhoneSystemString.ContinuedCall = False
                End If
                If (Mid$(pString, 78, 2) = "NA") Then
                    ProcessPhoneSystemString.UnanseredCall = True
                Else
                    ProcessPhoneSystemString.UnanseredCall = False
                End If
            Else
                ' Invalid record
                ProcessPhoneSystemString.lineNumber = -1
                ProcessPhoneSystemString.ExtensionNumber = -1
            End If
        Case "PANASONIC_PSDN"
            ' Validate record
            If (Mid$(pString, 75, 4) = "....") Then
                ProcessPhoneSystemString.lineNumber = Mid$(pString, 24, 1)
                ProcessPhoneSystemString.ExtensionNumber = Mid$(pString, 20, 2)
                If (Trim$(Mid$(pString, 27, 36)) = "<< incoming >>") Then
                    ProcessPhoneSystemString.PhoneNumber = "N/A"
                    ProcessPhoneSystemString.Direction = 1
                Else
                    ProcessPhoneSystemString.PhoneNumber = Trim$(Mid$(pString, 27, 36))
                    ProcessPhoneSystemString.Direction = 2
                End If
                tempstring = Mid$(pString, 65, 9)
                ProcessPhoneSystemString.Duration = Val(Mid$(tempstring, 1, 2)) * 60 * 60 + Val(Mid$(tempstring, 4, 2)) * 60 + Val(Mid$(tempstring, 7, 2))
                
                tempstring = Mid$(pString, 48, 4)
                ProcessPhoneSystemString.AnswerTime = Val(Mid$(tempstring, 1, 1)) * 60 + Val(Mid$(tempstring, 3, 2))
                
                tempstring = Mid$(pString, 1, 9) & " " & Mid$(pString, 11, 7)
                ProcessPhoneSystemString.CallDate = CDate(tempstring)
                If (Mid$(pString, 10, 1) = "*") Then
                    ProcessPhoneSystemString.ContinuedCall = True
                Else
                    ProcessPhoneSystemString.ContinuedCall = False
                End If
            Else
                ' Invalid record
                ProcessPhoneSystemString.lineNumber = -1
                ProcessPhoneSystemString.ExtensionNumber = -1
            End If
        Case "SYSTEM2"
            ' Validate record
            If (Val(Mid$(pString, 1, 2)) > 0) Then
                tempstring = Mid$(pString, 1, 9) & " " & Mid$(pString, 11, 7)
                ProcessPhoneSystemString.CallDate = CDate(tempstring)
                
                ProcessPhoneSystemString.ExtensionNumber = Mid$(pString, 19, 3)
                ProcessPhoneSystemString.lineNumber = Mid$(pString, 23, 2)
                If (Trim$(Mid$(pString, 26, 21)) = "<I>") Then
                    ProcessPhoneSystemString.PhoneNumber = "N/A"
                    ProcessPhoneSystemString.Direction = 1
                Else
                    ProcessPhoneSystemString.PhoneNumber = Trim$(Mid$(pString, 26, 21))
                    ProcessPhoneSystemString.Direction = 2
                End If
                If (Mid$(pString, 78, 2) = "NA") Then
                    ' This call has not been answered, so no duration
                    ProcessPhoneSystemString.Duration = 0
                Else
                    tempstring = Mid$(pString, 54, 8)
                    ProcessPhoneSystemString.Duration = Val(Mid$(tempstring, 1, 2)) * 60 * 60 + Val(Mid$(tempstring, 4, 2)) * 60 + Val(Mid$(tempstring, 7, 2))
                End If
                If (Mid$(pString, 78, 2) = "TR") Then
                    ProcessPhoneSystemString.ContinuedCall = True
                Else
                    ProcessPhoneSystemString.ContinuedCall = False
                End If
            Else
                ' Invalid record
                ProcessPhoneSystemString.lineNumber = -1
                ProcessPhoneSystemString.ExtensionNumber = -1
            End If
        
        Case Else
    End Select
End Function
