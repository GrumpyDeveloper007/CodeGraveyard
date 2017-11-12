VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "MathClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''
' Shit! I wrote this ages ago !!
'
' Direction Angle as follows -
'
'       0           100
'       ¦           ^
' 270---+---90      ¦
'       ¦           ¦
'      180          0------>100

''
Private Function GetAngle2(dx As Double, dy As Double) As Double
    If (dx = 0) Then
        GetAngle2 = 0
    Else
        If (dy = 0) Then
            GetAngle2 = 0
        Else
            If (dx >= dy) Then           '// adj > opp
                GetAngle2 = (180 * Atn(dy / dx)) / pi   ' atan
            Else
                GetAngle2 = (180 * Atn(dx / dy)) / pi   ' atan
            End If
        End If
    End If
End Function

'float GetHyp(float &dx,float &dy,float &Angle)  // Angle = degrees
' {
' if (dx==0)
'  return dy;
' if (dy==0)
'  return dx;
' if (dx>=dy)
'  return dy/sin(( Angle*_PI/180 ));
' return dx/sin(( Angle*_PI/180 ));
' }

''
Private Function aSin(angle As Double) As Double
    Dim temp As Double
    temp = angle / 180 * pi
    aSin = Atn(temp / Sqr(-temp * temp + 1))
End Function

''
Private Function aCos(angle As Double) As Double
    Dim temp As Double
    temp = angle / 180 * pi
    aCos = Atn(-temp / Sqr(-temp * temp + 1)) + 2 * Atn(1)
End Function

''
Public Sub GetDxDy(ByRef dx As Double, ByRef dy As Double, ByVal angle As Double, ByVal Scalor As Double)
    Dim AngleRad As Double
    Dim Opp As Double
    Dim Adj As Double
    If (angle < 0) Then
        angle = angle + 360
    End If
    If (angle > 360) Then
        angle = angle - 360
    End If
    If ((angle + 45) Mod 90 = 0) Then
        If (angle > 0 And angle < 180) Then
            dx = Scalor
        Else
            dx = -Scalor
        End If
        If (angle > 90 And angle < 270) Then
            dy = -Scalor
        Else
            dy = Scalor
        End If
    Else
        If (angle >= 0 And angle < 45) Then
            AngleRad = (angle) / 180 * pi
            dx = Sin(AngleRad) * Scalor ' Smaller
            dy = Cos(AngleRad) * Scalor ' Larger
        Else
            If (angle >= 45 And angle < 90) Then
            AngleRad = (90 - angle) / 180 * pi
                dy = Sin(AngleRad) * Scalor ' Smaller
                dx = Cos(AngleRad) * Scalor ' Larger
            Else
                If (angle >= 90 And angle < 135) Then
            AngleRad = (angle - 90) / 180 * pi
                    dy = -Sin(AngleRad) * Scalor ' Smaller
                    dx = Cos(AngleRad) * Scalor ' Larger
                Else
                    If (angle >= 135 And angle < 180) Then
            AngleRad = (180 - angle) / 180 * pi
                        dx = Sin(AngleRad) * Scalor ' Smaller
                        dy = -Cos(AngleRad) * Scalor ' Larger
                    Else
                        If (angle >= 180 And angle < 225) Then
            AngleRad = (angle - 180) / 180 * pi
                            dx = -Sin(AngleRad) * Scalor ' Smaller
                            dy = -Cos(AngleRad) * Scalor ' Larger
                        Else
                            If (angle >= 225 And angle < 270) Then
            AngleRad = (270 - angle) / 180 * pi
                                dy = -Sin(AngleRad) * Scalor ' Smaller
                                dx = -Cos(AngleRad) * Scalor ' Larger
                            Else
                                If (angle >= 270 And angle < 315) Then
            AngleRad = (angle - 270) / 180 * pi
                                    dy = Sin(AngleRad) * Scalor ' Smaller
                                    dx = -Cos(AngleRad) * Scalor ' Larger
                                Else
                                    If (angle >= 315 And angle < 360) Then
            AngleRad = (360 - angle) / 180 * pi
                                        dx = -Sin(AngleRad) * Scalor ' Smaller
                                        dy = Cos(AngleRad) * Scalor ' Larger
                                    Else
                                    End If
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
    End If
End Sub

''
Public Function GetAngle(dx As Double, dy As Double) As Double
    Dim angle As Double
    Dim temp As Double
    Dim Base As Double
    
    temp = 0
    If (dx > dy) Then
        angle = GetAngle2(Abs(dy), Abs(dx))
    Else
        angle = GetAngle2(Abs(dx), Abs(dy))
    End If
    ' ¦
    ' ¦
    ' +---
    If (dx > 0 And dy < 0) Then
        If (Abs(dx) > Abs(dy)) Then
            Base = 90
            temp = Base + angle
        Else
            Base = 180
            temp = Base - angle
        End If
    End If
    ' +---
    ' ¦
    ' ¦
    If (dx >= 0 And dy >= 0) Then
        If (Abs(dx) > Abs(dy)) Then
            Base = 90
            temp = Base - angle
        Else
            Base = 0
            temp = Base + angle
        End If
    End If
    ' ----+
    '     ¦
    '     ¦
    If (dx < 0 And dy >= 0) Then
        If (Abs(dx) < Abs(dy)) Then
            Base = 360
            temp = Base - angle
        Else
            Base = 270
            temp = Base + angle
        End If
    End If
    '    ¦
    '    ¦
    ' ---+
    If (dx <= 0 And dy < 0) Then
        If (Abs(dx) < Abs(dy)) Then
            Base = 180
            temp = Base + angle
        Else
            Base = 270
            temp = Base - angle
        End If
    End If
    
    GetAngle = temp
End Function
