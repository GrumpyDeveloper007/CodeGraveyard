Attribute VB_Name = "Module1"
Option Explicit
Public D As Double, O As Double, VAS As Double, DS As Double, LA As Double
Public CA As Double, SI As Double, t As Double, RS As Double, RP As Double
Public W As Double, B As Double

Public A As Double, L As Double, C As Double, S As Double, KS As Double
Public RSP As Double, HSP As Double, CS As Double, RF As Double, dh As Double

Public BKT As Double, CM As Double, BTS As Double, bl As Double, ba As Double
Public br$, vS$, k$, vdh$, po$, p$

Public x As Double, y As Double, z As Double
Public m(6, 5) As Double, n(6, 3, 2, 1) As Double
Public brl As Double, bb As Double, bsh As Double, bsl As Double
Public bra As Double, dha As Double, pdh As Double, kb As Double
Public kt As Double, eba As Double, aw As Double, layer As Double
Public lr As Double, rfc As Double, dhc As Double, ai As Double
Public ao As Double, ad As Double, ang As Double, al As Double
Public rfl As Double, dhl As Double, drk As Double, dhk As Double
Public kad As Double, xx As Double, vd$

Private Function asn(value As Double) As Double
 asn = Atn(value / Sqr(-value * value + 1)) * 180 / pi
End Function

Private Function vatn(value As Double) As Double
    vatn = Atn(value) * 180 / pi
End Function

Private Function vtan(value As Double) As Double
    vtan = tan(value / 180 * pi)
End Function

Private Function DoRound(Number As Variant) As Long
'    On Error GoTo Error
    DoRound = Number
'    Exit Function
'Error:
'    DoRound = 219000000
End Function

Private Function DoPRound(Number As Variant, Exp As Variant) As Variant
    DoPRound = 0
    Select Case Exp
        Case -2
            DoPRound = DoRound(Number * 100) / 100
        Case -1
            DoPRound = DoRound(Number * 10) / 10
        Case 0
            DoPRound = DoRound(Number)
        Case 1
            DoPRound = DoRound(Number / 10) * 10
        Case Else
            Error = True
            Call MsgBox("ERROR: Unknown exp in PRound()")
    End Select
End Function
'Option Explicit

Public Function test()
D = 9E+99
m(0, 0) = 9.6: m(0, 1) = 6.75: m(0, 2) = 10.9: m(0, 3) = 120: m(0, 4) = 84: m(0, 5) = 40
m(1, 0) = 15.3: m(1, 1) = 9.15: m(1, 2) = 15.3: m(1, 3) = 184: m(1, 4) = 128.8: m(1, 5) = 45
m(2, 0) = 13.55: m(2, 1) = 11.44: m(2, 2) = 20.88: m(2, 3) = 184: m(2, 4) = 128.8: m(2, 5) = 50
m(3, 0) = 13.55: m(3, 1) = 11.44: m(3, 2) = 20.88: m(3, 3) = 204: m(3, 4) = 142.8: m(3, 5) = 55
m(4, 0) = 13.55: m(4, 1) = 11.44: m(4, 2) = 20.88: m(4, 3) = 204: m(4, 4) = 142.8: m(4, 5) = 55
m(5, 0) = 16.2: m(5, 1) = 15: m(5, 2) = 22.25: m(5, 3) = 222: m(5, 4) = 155.4: m(5, 5) = 65
m(6, 0) = 16.2: m(6, 1) = 15: m(6, 2) = 22.25: m(6, 3) = 222: m(6, 4) = 155.4: m(6, 5) = 65
Dim i As Long, t As Long, ii As Long, tt As Long
Dim fileid As Long
fileid = FreeFile
Open "NData.txt" For Input As #fileid
' n(6, 3, 2, 1) As Double
    For i = 0 To 6
        For t = 0 To 3
            For ii = 0 To 2
                For tt = 0 To 1
                    Input #fileid, n(i, t, ii, tt)
                Next
            Next
        Next
    Next
    Close fileid
O = 30
VAS = 3
DS = 90
LA = -2
CA = 38
SI = 25
t = 5
RS = 2
RP = 3
W = 25
B = 30
'BS$ = "N"
'K$ = "N"

Frmtest.TxtError.SelText = "THIS PROGRAMME CALCULATES THE REACH FACTOR AND DUMP HEIGHT FOR A GIVEN SET OF" & vbCrLf
Frmtest.TxtError.SelText = "CUT DIMENSIONS, AND THE BOOM HEAD LOAD FOR THE BUCKET SIZE NEEDED TO GIVE THE" & vbCrLf
Frmtest.TxtError.SelText = "REQUIRED OUTPUT."
250 If VAS > 40 Then Let A = vtan(VAS * pi / 180)
260 If VAS < 40 Then Let A = VAS
280 If DS = 90 Then GoTo 320
290 If DS > 40 And DS < 90 Then GoTo 340
300 If DS < 40 Then Let D = DS
310 GoTo 350
320
330 GoTo 350
340 D = vtan(DS * pi / 180)
350
360 If LA = 0 Then GoTo 400
370 If LA > 0 Then Let L = vtan(LA * pi / 180)
380 If LA < 0 Then Let L = vtan(LA * pi / 180)
390 GoTo 410
400 Let L = LA
410
420 If CA > 10 Then Let C = vtan(CA * pi / 180)
430 If CA < 10 Then Let C = CA
450 S = SI / 100 + 1

880 KS = 0
890 RSP = O * S / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L)
900 HSP = O * S + W / 4 * C * (1 - L ^ 2 / C ^ 2)
Frmtest.TxtError.SelText = "rsp:" & RSP & " hsp : " & HSP & vbCrLf
910 If B = O Then GoTo 940
920 CS = (O - B) * W * S
930 GoTo 950
940 CS = 0
950 RF = DoPRound(RSP + B / (A - L) + t / (D - L) + RS + RP, -1)
960 dh = DoPRound(HSP - B - t - RF * L - RS * L - RP * L, -1)
'1250 If BS$ = "N" Then GoTo 1310
Frmtest.TxtError.SelText = "REACH FACTOR" & RF & " M" & "DUMP HEIGHT" & dh & " M" & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
Frmtest.TxtError.SelText = "22X,K,3D,K,3D.D,K,K" & "BUCKET -" & BKT & " CU YD -" & CM & " CU M -" & BTS & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
1300 GoTo 1330
Frmtest.TxtError.SelText = "16X,K,4D.D,K,10X,K,3K.D,K" & "REACH FACTOR" & RF & " M" & "DUMP HEIGHT" & dh & " M" & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
1330 br$ = "N"
vS$ = "2000"
bl = 95.6
ba = 30
1370 If vS$ = "700D" Then Let x = 0
1380 If vS$ = "700E" Then Let x = 0
1390 If vS$ = "1000" Then Let x = 1
1400 If vS$ = "1700" Then Let x = 2
1410 If vS$ = "2000" Then Let x = 3
1420 If vS$ = "2100" Then Let x = 4
1430 If vS$ = "3000" Then Let x = 5
1440 If vS$ = "3100" Then Let x = 6
1450 If bl = 43 Then Let y = 0
1460 If bl = 58 Then Let y = 0
1470 If bl = 80 Then Let y = 0
1480 If bl = 74.6 Then Let y = 0
1490 If bl = 90.5 Then Let y = 0
1500 If bl = 50.4 Then Let y = 1
1510 If bl = 68 Then Let y = 1
1520 If bl = 85.1 Then Let y = 1
1530 If bl = 90 Then Let y = 1
1540 If bl = 98 Then Let y = 1
1550 If bl = 57.8 Then Let y = 2
1560 If bl = 78 Then Let y = 2
1570 If bl = 95.6 Then Let y = 2
1580 If bl = 105.5 Then Let y = 2
1590 If bl = 88 Then Let y = 3
1600 If bl = 100.85 Then Let y = 3
1610 If ba = 38 Or 40 Then Let z = 0
1620 If ba = 35 Then Let z = 1
1630 If ba = 30 Then Let z = 2
1640 If br$ = "N" Then GoTo 1910
1650 brl = DoPRound(RF + m(x, 1) - n(x, y, z, 0), -1)
1660 If dh < n(x, y, z, 1) Then GoTo 1690
Frmtest.TxtError.SelText = "DUMP HEIGHT TOO LOW, TRY DIFFERENT BOOM LENGTH AND ANGLE" & vbCrLf
1680 GoTo 1330
1690 bb = brl + (B + t) / (C - L) - B / (A - L) - t / (D - L)
1700 bsh = B + t - bb / 2 * (C - L)
1710 bsl = brl - bsh / (A - L) + bsh / (C - L)
1720 If bb > W Then GoTo 1760
1730 bra = brl * (B + t) + (B + t) ^ 2 / (2 * (C - L)) - B ^ 2 / (2 * (A - L)) - B * t / (A - L) - t ^ 2 / (2 * (D - L))
1740 dha = bra - bb ^ 2 * C / 4
1750 GoTo 1780
1760 bra = brl * (B + t) + (B + t) ^ 2 / (2 * (C - L)) - B ^ 2 / (2 * (A - L)) - B * t / (A - L) - t ^ 2 / (2 * (D - L)) - (bb - W) ^ 2 * C / 4
1770 dha = bra + (bb - W) ^ 2 * C / 4 - bb ^ 2 * C / 4
1780 pdh = DoPRound(dha / (O * W * S) * 100, 0)
1790 If k$ = "N" Then GoTo 1880
1800 If CS + KS > bra Then GoTo 1840
1810 kb = kb + (bra - CS - KS) / S / B
1820 kt = kb + B / (A - L) * 2
1830 KS = (kb + kt) / 2 * B * S
1840 eba = bra - CS - KS
1850 If n(x, y, z, 0) > W - kb / 2 - B / (A - L) + brl Then GoTo 1880
'1860 INPUT "WIDTH OF CUT TOO BIG, NEW WIDTH OF CUT (M) ?",W
1870 GoTo 890
1880 Frmtest.TxtError.SelText = " " & vbCrLf
Frmtest.TxtError.SelText = "PERCENTAGE DOUBLE HANDLE" & pdh & " %" & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
1910 vdh$ = "Y"
1920 If vdh$ = "N" Then GoTo 3930
po$ = "Y"
1940 If po$ = "N" Then GoTo 1960
Frmtest.TxtError.SelText = "SWITCH ON PRINTER IF IT IS NOT ON" & vbCrLf
1960 aw = W * W * C / 4
1970 layer = 0
lr = 5
1990 layer = lr
2000 If br$ = "Y" Then GoTo 2970
2010 If B = O Then GoTo 2240
2020 If CS = aw Then GoTo 2100
2030 If CS < aw Then GoTo 2060
2040 rfc = DoPRound(CS / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2050 dhc = DoPRound(CS / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfc - RS * L - RP * L, -1)
2060 GoTo 2120
2070 rfc = DoPRound(Sqr(CS * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) + RS + RP, -1)
2080 dhc = DoPRound(Sqr(CS * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfc * L - RS * L - RP * L, -1)
2090 GoTo 2120
2100 rfc = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2110 dhc = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfc * L - RS * L - RP * L, -1)
2120 If dhc < 5 Then Let dhc = 5
2130 ai = asn((m(x, 2) + W + (O - B)) / n(x, y, z, 0))
2140 ao = asn(m(x, 2) / n(x, y, z, 0))
2150 If rfc + m(x, 1) > n(x, y, z, 0) Then GoTo 2190
2160 If rfc + m(x, 1) = n(x, y, z, 0) Then GoTo 2190
2170 ad = asn((rfc + m(x, 1)) / n(x, y, z, 0))
2180 GoTo 2200
2190 ad = 90
2200 ang = DoPRound((ao + ai) / 2 + ad, 0)
2210 If po$ = "N" Then GoTo 2230
2230 Frmtest.TxtError.SelText = "CHOP CUT HEIGHT" & O - B & " M DUMP HEIGHT" & dhc & " M REACH FACTOR" & rfc & " M ANGLE" & ang & "DEGS" & vbCrLf
2240 If k$ = "Y" Then GoTo 2510
2250 al = layer * W * S + CS
2260 If al = aw Then GoTo 2340
2270 If al < aw Then GoTo 2310
2280 rfl = DoPRound(al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2290 dhl = DoPRound(al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2300 GoTo 2360
2310 rfl = DoPRound(Sqr(al * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) + RS + RP, -1)
2320 dhl = DoPRound(Sqr(al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2330 GoTo 2360
2340 rfl = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2350 dhl = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2360 If dhl < -1 * layer + 5 Then Let dhl = -1 * layer + 5
2370 ao = vatn((W - m(x, 1) - layer / A) / (m(x, 0) + layer))
2380 ai = vatn((m(x, 1) + layer / A) / (m(x, 0) + layer))
2390 If rfl + m(x, 1) > n(x, y, z, 0) Then GoTo 2430
2400 If rfl + m(x, 1) = n(x, y, z, 0) Then GoTo 2430
2410 ad = asn((rfl + m(x, 1)) / n(x, y, z, 0))
2420 GoTo 2440
2430 ad = 90
2440 ang = DoPRound((ao + ai) / 2 - ai + ad, 0)
2450 If po$ = "N" Then GoTo 2470
2470 Frmtest.TxtError.SelText = "DIG DEPTH" & layer & " M DUMP HEIGHT" & dhl & " M REACH FACTOR" & rfl & " M ANGLE" & ang & " DEGS" & vbCrLf
GoTo fin
2480 layer = layer + lr
2490 If layer > B + 1 Then GoTo 3930
2500 GoTo 2250

2510 If KS = aw Then GoTo 2590
2520 If KS < aw Then GoTo 2590
2530 drk = DoPRound(KS / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP + W - kb / 2, -1)
2540 dhk = DoPRound(KS / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - drk * L - RS * L - RP * L, -1)
2550 GoTo 2610
2560 drk = DoPRound(Sqr(KS * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) + RS + RP + W - kb / 2, -1)
2570 dhk = DoPRound(Sqr(KS * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - drk * L - RS * L - RP * L, -1)
2580 GoTo 2610
2590 drk = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP + W - kb / 2, -1)
2600 dhk = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - drk * L - RS * L - RP * L, -1)
2610 If dhk < 5 Then Let dhk = 5
2620 If drk > n(x, y, z, 0) Then GoTo 2650
2630 kad = DoPRound(asn(drk / n(x, y, z, 0)), 0)
2640 GoTo 2680
2650 Frmtest.TxtError.SelText = "DUMP RADIUS TOO BIG, REDUCE WIDTH OF CUT BY" & n(x, y, z, 0) - drk & " M" & vbCrLf
'2660 INPUT "NEW WIDTH OF CUT (M) ?",W
2670 GoTo 890
2680 If po$ = "N" Then GoTo 2700
2700 Frmtest.TxtError.SelText = "KEY DIG DEPTH" & B & " M DUMP HEIGHT" & drk & " M" & vbCrLf
2710 al = (W - kt + layer / (A - L)) * layer * S + KS + CS
2720 If al = aw Then GoTo 2800
2730 If al < aw Then GoTo 2770
2740 rfl = DoPRound(al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2750 dhl = DoPRound(al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2760 GoTo 2820
2770 rfl = DoPRound(Sqr(al * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) + RS + RP, -1)
2780 dhl = DoPRound(Sqr(al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2790 GoTo 2820
2800 rfl = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) + RS + RP, -1)
2810 dhl = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
2820 If dhl < -1 * layer + 5 Then Let dhl = -1 * layer + 5
2830 ao = vatn((W - m(x, 1) - kt + layer / (A - L)) / (m(x, 0) + layer))
2840 ai = vatn((m(x, 1) + layer / (A - L)) / (m(x, 0) + layer))
2850 If rfl + m(x, 1) > n(x, y, z, 0) Then GoTo 2890
2860 If rfl + m(x, 1) = n(x, y, z, 0) Then GoTo 2890
2870 ad = asn((rfl + m(x, 1)) / n(x, y, z, 0))
2880 GoTo 2900
2890 ad = 90
2900 ang = DoPRound((ao + ai) / 2 - ai + ad, 0)
2910 If po$ = "N" Then GoTo 2930
2930 Frmtest.TxtError.SelText = "DIG DEPTH" & layer & " M DUMP HEIGHT " & dhl & " M REACH FACTOR" & rfl & " M ANGLE" & ang & "DEGS" & vbCrLf
2940 layer = layer + lr
2950 If layer > B + 1 Then GoTo 3930
2960 GoTo 2710
2970 If k$ = "Y" Then GoTo 3430
2980 If B = O Then GoTo 3080
2990 rfc = DoPRound(brl, -1)
3000 dhc = 5
3010 ai = asn((m(x, 2) + W + (O - B)) / n(x, y, z, 0))
3020 ao = asn(m(x, 2) / n(x, y, z, 0))
3030 ad = asn((rfc + m(x, 1)) / n(x, y, z, 0))
3040 ang = DoPRound((ao + ai) / 2 + ad, 0)
3050 If po$ = "N" Then GoTo 3070
3070 Frmtest.TxtError.SelText = "CHOP CUT HEIGHT" & O - B & "M DUMP HEIGHT" & dhc & "M REACH FACTOR" & rfc & "M ANGLE" & ang & "DEGS" & vbCrLf
3080 al = layer * W * S + (brl + layer / 2 * (1 / (C - L) - 1 / (A - L))) * layer + bra - dha
3090 If al = aw Then GoTo 3170
3100 If al < aw Then GoTo 3140
3110 rfl = DoPRound(al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3120 dhl = DoPRound(al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3130 GoTo 3190
3140 rfl = DoPRound(Sqr(al * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3150 dhl = DoPRound(Sqr(al * 4 / (C + L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3160 GoTo 3190
3170 rfl = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3180 dhl = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3190 If dhl < -1 * layer + 5 Then Let dhl = -1 * layer + 5
3200 ao = vatn((W + brl - m(x, 1) - layer / A) / (m(x, 0) + layer))
3210 If layer > bsh Then GoTo 3240
3220 ai = vatn((m(x, 1) + layer / C) / (m(x, 0) + layer))
3230 GoTo 3260
3240 ai = vatn((m(x, 1) + bsh / C - (layer - bsh) / C) / (m(x, 0) + layer))
3250 If rfl + m(x, 1) > n(x, y, z, 0) Then GoTo 3290
3260 If rfl + m(x, 1) = n(x, y, z, 0) Then GoTo 3290
3270 ad = asn((rfl + m(x, 1)) / n(x, y, z, 0))
3280 GoTo 3300
3290 ad = 90
3300 ang = DoPRound((ao + ai) / 2 - ai + ad, 0)
3310 If po$ = "N" Then GoTo 3330
3330 Frmtest.TxtError.SelText = "DIG DEPTH" & layer & "M DUMP HEIGHT" & dhl & "M REACH FACTOR" & rfl & "M ANGLE" & ang & "DEGS" & vbCrLf
3340 layer = layer + lr
3350 If layer > B + 1 Then GoTo 3390
3360 If layer < bsh Then GoTo 3080
3370 al = layer * W * S * (brl + bsl) / 2 * bsh + (layer - bsh) * (bsl - (layer - bsh) / 2 * (1 / (A - L) + 1 / (C - L))) + bra - dha
3380 GoTo 3090
3390 If po$ = "N" Then GoTo 3410
3410 Frmtest.TxtError.SelText = "DIG DEPTH" & B + t & "M DUMP HEIGHT" & dh & "M REACH FACTOR" & RF & "M ANGLE" & ang & "DEGS" & vbCrLf
3420 GoTo 3930
3430 If B = O Then GoTo 3530
3440 rfc = DoPRound(W - kb / 2 - B / (A - L) + brl, -1)
3450 dhc = 5
3460 ai = asn((m(x, 2) + W + (O - B)) / n(x, y, z, 0))
3470 ao = asn(m(x, 2) / n(x, z, y, 0))
3480 ad = asn((rfc + m(x, 1)) / n(x, y, z, 0))
3490 ang = DoPRound((ao + ai) / 2 + ad, 0)
3500 If po$ = "N" Then GoTo 3520
3520 Frmtest.TxtError.SelText = "CHOP CUT HEIGHT" & O - B & "M DUMP HEIGHT" & dhc & "M REACH FACTOR" & rfc & " M ANGLE" & ang & "DEGS" & vbCrLf
3530 drk = DoPRound(W - kb / 2 - B / (A - L) + brl, -1)
3540 dhk = 5
3550 kad = DoPRound(asn(drk / n(x, y, z, 0)), 0)
3560 If po$ = "N" Then GoTo 3580
3580 Frmtest.TxtError.SelText = "KEY DIG DEPTH" & B & " M DUMP HEIGHT" & dhk & "M DUMP RADIUS" & drk & "M ANGLE" & kad & "DEGS" & vbCrLf
3590 al = (W - kt + layer / (A - L)) * layer * S + (brl + layer / 2 * (1 / (C - L) - 1 / (A - L))) * layer + bra - dha + eba
3600 If al = aw Then GoTo 3680
3610 If al < aw Then GoTo 3650
3620 rfl = DoPRound(al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C - L) + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3630 dhl = DoPRound(al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3640 GoTo 3700
3650 rfl = DoPRound(Sqr(al * 4 / (C + L)) / 2 + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3660 dhl = DoPRound(Sqr(al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3670 GoTo 3700
3680 rfl = DoPRound(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + t / (D - L) - brl + RS + RP, -1)
3690 dhl = DoPRound(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - t - rfl * L - RS * L - RP * L, -1)
3700 If dhl < -1 * layer + 5 Then Let dhl = -1 * layer + 5
3710 ao = vatn((W + brl - m(x, 1) - layer / A) / (m(x, 0) + layer))
3720 If layer > bsh Then GoTo 3750
3730 ai = vatn((m(x, 1) + layer / C) / (m(x, 0) + layer))
3740 GoTo 3770
3750 ai = vatn((m(x, 1) + bsh / C - (layer - bsh) / C) / (m(x, 0) + layer))
3760 If rfl + m(x, 1) > n(xx, y, z, 0) Then GoTo 3800
3770 If rfl + m(x, 1) = n(x, y, z, 0) Then GoTo 3800
3780 ad = asn((rfl + m(x, 1)) / n(x, y, z, 0))
3790 GoTo 3810
3800 ad = 90
3810 ang = DoPRound((ao + ai) / 2 - ai + ad, 0)
Frmtest.TxtError.SelText = "DIG DEPTH" & layer & "M DUMP HEIGHT" & dhl & "M REACH FACTOR" & rfl & "M ANGLE" & ang & "DEGS" & vbCrLf
3850 layer = layer + lr
3860 If layer > B + 1 Then GoTo 3900
3870 If layer < bsh Then GoTo 3590
3880 al = (W - kt + layer / (A - L)) * layer * S + (brl + bsl) / 2 * bsh + (layer - bsh) * (bsl - (layer - bsh) / 2 * (1 / (A - L) + 1 / (C - L))) + bra - dha
3890 GoTo 3600
3900 If po$ = "N" Then GoTo 3920
3930
Frmtest.TxtError.SelText = "DIG DEPTH" & B + t & "M DUMP HEIGHT" & dh & "M REACH FACTOR" & RF & "M ANGLE" & ang & "DEGS" & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
vd$ = "Y"
p$ = "Y"
3980 If p$ = "N" Then GoTo 4010
Frmtest.TxtError.SelText = "SWITCH ON PRINTER IF IT IS NOT ON" & vbCrLf
Frmtest.TxtError.SelText = " " & vbCrLf
Frmtest.TxtError.SelText = "IF MENU IS SHOWING PRESS 'MENU' TO CLEAR AND THEN 'F2' TO DRAW CUT DIAGRAM" & vbCrLf
4010
3920
fin:
Frmtest.TxtError.SelText = " x  :" & x & " y :" & y & " z:" & z & " brl:" & brl & " bb:" & bb & " bsh:" & bsh & vbCrLf
Frmtest.TxtError.SelText = " bra:" & bra & " dha:" & dha & " pdh:" & pdh & " kb:" & kb & vbCrLf
Frmtest.TxtError.SelText = " kt :" & kt & " eba:" & eba & " aw:" & aw & " layer:" & layer & vbCrLf
Frmtest.TxtError.SelText = " lr :" & lr & " rfc:" & rfc & " dhc:" & dhc & " ai:" & ai & vbCrLf
Frmtest.TxtError.SelText = " ao :" & ao & " ad:" & ad & " ang:" & ang & " al:" & al & vbCrLf
Frmtest.TxtError.SelText = " rfl:" & rfl & " dhl:" & dhl & " drk:" & drk & " dhk:" & dhk & vbCrLf
'Public kad As Double, xx As Double, vd$
End Function

