'10:
PRINTER IS 1
'20:
Print "This programme calculates the Reach Factor and Dump Height for a given set of"
'30:
Print "Cut Dimensions, and the Boom Head Load for the bucket size needed to give the"
'40:
Print "required output."
'50:
DEG
'60:
Option Base 0
'70:
Dim M(6,5)
'80:
DATA 9.6,6.75,10.9,120,84,40,15.3,9.15,15.3,184,128.8,45,13.55,11.44,20.88,184,128.8,50,13.55,11.44,20.88,184,128.8,50,13,55,11.44,20.88,204,142.8,55,
'90:
DATA 16.2,15,22.25,222,155.4,65,16.2,15,22.25,222,155.4,65
'100:
READ M(*)
'110:
Dim N(6,3,2,1)
'120:
DATA 37,18.4,39.5,15.2,41.5,12,43,22.8,45.5,19.5,48,15.6,48.5,29.2,51.5,25.3,54.5,20.6,0,0,0,0,0,0,51.6,26.1,54.7,22.1,57.4,17.8,59.3,33.1,62.9,28.3,66.1,
'130:
DATA 23.3,66.9,41,71.1,35.6,74.7,29.9,74.6,47,79.3,41.3,83.4,34.9,66.7,41.6,70.9,36,74.7,30.2,74.3,48,79.1,41.8,83.3,35.2,0,0,0,0,0,0,0,0,0,0,0,0,64,34.4,
'140:
DATA 0,0,70,25.5,72.5,40.6,0,0,79,32.2,81,48.1,0,0,88,38.2,85,52.1,0,0,92.8,40.8,64,33.4,0,0,70,24.8,72.5,39.9,0,0,79,30.9,81,46.8,0,0,88,36.4,85,50.3,0,
'150:
Data 0,92.8,39.3,81,43,0,0,88,32,87,47,0,0,94.5,36,93,52,0,0,101,40,0,0,0,0,0,0,81,42.3,0,0,88,31.9,87,47,0,0,94.5,35.8,93,51.7,0,0,101,39.5,0,0,0,0,0,0
'160:
READ N(*)
'170:
Dim Lip(82)
'180:
DATA 0,0,0,0,0,0,0,0,80,85,85,85,85,96,100,100,105,105,105,110,110,110,115,115,115,120,120,120,125,125,130,130,130,130,135,135,135,135,135,140,140,
'190:
DATA 140,145,145,145,150,150,150,150,150,155,155,155,155,155,155,160,160,160,160,160,160,165,165,165,165,165,170,170,170,170,170,170,170,170,180,180,180,
'200:
Data 180,180,180,180
'210:
READ Lip(*)
'220:
INPUT "Date ?",Date$
'230:
INPUT "Total Depth of Overburden (M) ?", O
'240:
INPUT "Slope or Angle or Highwall ?",As
'250:
If AAs>40 Then let A=Tan(AAs)
'260:
If AAs<40 Then Let A=AAs
'270:
INPUT "Slope or Angle of Seam end ?", Ds
'280:
If Ds=90 Then GoTo 320
'290:
If Ds>40 And Ds<90 Then GoTo 340
'300:
If Ds<40 Then Let D = Ds
'310:
GoTo 350
'320:
D = 9E+99
'330:
GoTo 350
'340:
D = Tan(Ds)
'350:
INPUT "Angle of Seam to Horizontal ? '-' angle if seam dips under Machine", La
'360:
If La=0 Then GoTo 400
'370:
If La>0 Then Let L=Tan(La)
'380:
If La<0 Then Let L=Tan(La)
'390:
GoTo 410
'400:
Let L = La
'410:
INPUT "Slope or Angle of Spoil Heap ?", Ca
'420:
If Ca>10 Then Let C=Tan(Ca)
'430:
If Ca<10 Then Let C=Ca
'440:
INPUT "Swell of Spoil % ?", Si
'450:
S = Si / 100 + 1
'460:
INPUT "Thickness of Seam (M) ?", T
'470:
INPUT "Width of Road on Seam (M) ? Enter 0 if no Road", Rs
'480:
INPUT "Width of Road on Pit Bottom (M) ? Enter 0 if no Road", Rp
'490:
INPUT "Width of Cut (M) ?", W
'500:
INPUT "Height of Dragline Bench (M) ?", B
'510:
INPUT "Is calculation for Bucket Size required ? Enter Y or N", Bs$
'520:
INPUT "Is a Key Cut required ? Enter Y or N ,K$
'550:
If Bs$ = "N" Then GoTo 830
'580:
INPUT "Machine Size W ?", S$
'590:
INPUT "Weight of Spoil Loose (kg/cu.m) ?", Sw
'600:
INPUT "Annual Output required (BCM) ?", Op
'610:
INPUT "Annual Operating Hours ?", Oh
'620:
INPUT "Machine Availablity % ?", Av
'630:
INPUT "Machine Utilisation % ?", Ut
'640:
INPUT "Bucket Fill Factor % ?", Bf
'650:
INPUT "Bucket Type ? Enter MED or HSL or HDL or HDS or HDH", Bt$
'660:
Bkt=PROUND((Op*((B*M(X,5))+(O-B)* M(X,5)*1.2.)/O*S*278)/(Oh*Av*Ut*Bf)/.76455,0)
'670:
Cm = PROUND(Bkt * 0.76455, -1)
'680:
If Bkt > 12 Then GoTo 720
'681:
Print " "
'682:
Print USING; "K,K,K"; "Bucket Size "; Bkt; " Cu.Yd."
'690:
INPUT "Empty Bucket Weight (Tonnes) ?", Be
'700:
Bh1 = PROUND(Cm * Sw / 1000 + Be, -2)
'710:
GoTo 830
'720:
If Bt$="MED" And Bkt<64 Then Let Wt = 1.115
'730:
If Bt$="MED" And Bkt>63 Then Let Bt$ = "HSL"
'740:
If Bt$="HSL" And Bke<64 Then Let Wt = 1.258
'750:
If Bt$="HSL" And Bkt>63 Then Let Wt = 1.189
'760:
If Bt$="HDL" And Bkt<45 Then Let Wt = 1.314
'770:
If Bt$="HDL" And Bkt>44 Then Let Wt = 1.335
'780:
If Bt$="HDH" And Bkt<45 Then Let Bt$ = "HDS"
'790:
If Bt$="HDS" And Bkt<45 Then Let Wt = 1.356
'800:
If Bt$="HDS" And Bkt>44 Then Let Wt = 1.379
'810:
If Bt$="HDH" And Bkt>44 Then Let Wt = 1.433
'820:
Bh1 = PROUND(Cm * (Wt + Sw / 1000), -2)
'830:
If k$="N" Then GoTo 880
'840:
Kb = Lip(Bkt) * 0.0508
'850:
Kt = Kb + B / (A - L) * 2
'860:
Ks = (Kb + Kt) / 2 * B * S
'870:
GoTo 890
'880:
Ks0
'890:
Rsp = O * S / (C + L) = W / 4 * (C - L ^ 2 / C) / (C + L)
'900:
Hsp = O * S * W / 4 * C * (1 - L ^ 2 / C ^ 2)
'910:
If B=O Then GoTo 940
'920:
Cs = (O - B) * W * S
'930:
GoTo 950
'940:
Cs = 0
'950:
Rf = PROUND(Rsp + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'960:
Dh = PROUND(Hsp - B - T - Rf * L - Rs * L - Rp * L, -1)
'970:
Print USING; "16X,K"; "Reach Factors, Dump Heights and Boom Head Loads"
'980:
Print "Boom"
'990:
Print USING; "K,27X,K"; "Angle"; "Boom Lenghts"
'1000:
Print "W700D/E     43.0            50.4                    57.8"
'1010:
Print " 40   30.25 18.4 38.56   36.25 22.8 31.76   41.75 29.2 25.4"
'1020:
Print " 35   32.75 15.2 36.3    38.75 19.5 29.47   44.75 25.3 24.0"
'1030:
Print " 30   34.75 12.0 34.03   41.25 15.6 27.21   47.75 20.6 22.68"
'1040:
Print "W1000       58.0            68.0                    78.0            88.0"
'1050:
Print " 40   42.45 26.1 59.0    50.15 33.1 50.0    57.75 41.0 40.8      65.45 47.0 34.0"
'1060:
Print " 35   45.55 22.1 55.3    53.75 28.3 45.36   61.95 35.6 38.6      70.15 41.3 31.7"
'1070:
Print " 30   48.25 17.8 52.6    56.95 23.3 42.2    65.55 29.9 36.3      74.25 34.9 30.0"
'1080:
Print "W1700       80.0            90.0"
'1090:
Print " 40   55.26 41.6 87.0    62.86 48.0 73.0"
'1100:
Print " 35   59.46 36.0 79.5    67.66 41.8 65.0"
'1110:
Print " 30   63.26 30.2 73.0    71.86 35.2 58.5"
'1120:
Print "w2000       74.6            85.1                    95.6            100.85"
'1130:
Print " 38   52.56 33.4 102.1   61.06 40.6 98.4    69.56 48.1 83.5      73.56 50.3 75.5"
'1140:
Print " 30   58.56 25.5 102.1   67.56 32.2 86.2    76.56 38.2 77.0      81.36 39.3 67.8"
'1150:
Print "W2100       74.6            85.1                    95.6            100.85"
'1160:
Print " 38   52.56 33.4 114.0   61.06 39.9 106.0   69.56 46.8 98.5      73.56 50.3 95.0"
'1170:
Print " 30   58.56 24.8 108.5   67.56 30.9 100.0   76.56 36.4 92.0      81.36 39.3 88.0"
'1180:
Print "W3000       90.5            98.0                    105.5           "
'1190:
Print " 38   66.00 43.0 158.58  72.00 467.0 147.42 78.00 52.0 137.71"
'1200:
Print " 30   73.00 32.0 146.06  79.50  36.0 136.53 86.00 40.0 127.0"
'1210:
Print "W3100       90.5            98.0                    105.5"
'1220:
Print " 38   66.00 42.3 181.4   72.00 47.0 167.8   78.00 51.7 154.2"
'1230:
Print " 30   73.00 31.9 165.5   79.50 35.8 150.6   86.00 39.5 136.1"
'1240:
Print " "
'1250:
If Bs$ = "N" Then GoTo 1310
'1260:
Print USING; "3X,K,4D.D,K,4X,K,3D.D,4X,K,4D.DD,K"; "Reach Factor"; Rf; " M"; "Dump Height"; Dh; " M"; "Boom Head Load"; Bh1; " Tonnes"
'1270:
Print " "
'1280:
Print USING; "22X,K,3D,K,3D.D,K,K"; "Bucket -"; Bkt; " cu yd -"; Cm; " cu m -"; Bts
'1290:
Print " "
'1300:
GoTo 1330
'1310:
Print USING; "16X,K,4D.D,K,10X,K,3K.D,K"; "Reach Factor"; Rf; " M"; "Dump Height"; Dh; " M"
'1320:
Print " "
'1330:
INPUT "Is Bridging Required ? Enter Y or N", Br$
'1340:
INPUT "Machine Size W ?", S$
'1350:
INPUT "Boom Length (M) ?", Bl
'1360:
INPUT "Boom Angle (Degs) ?", Ba
'1370:
If S$ = "700D" Then Let X = 0
'1380:
If S$ = "700E" Then Let X = 0
'1390:
If S$ = "1000" Then Let X = 1
'1400:
If S$ = "1700" Then Let X = 2
'1410:
If S$ = "2000" Then Let X = 3
'1420:
If S$ = "2100" Then Let X = 4
'1430:
If S$ = "3000" Then Let X = 5
'1440:
If S$ = "3100" Then Let X = 6
'1450:
If Bl = 43 Then Let Y = 0
'1460:
If Bl = 58 Then Let Y = 0
'1470:
If Bl = 80 Then Let Y = 0
'1480:
If Bl = 74.6 Then Let Y = 0
'1490:
If Bl = 90.5 Then Let Y = 0
'1500:
If Bl = 50.4 Then Let Y = 1
'1510:
If Bl = 68 Then Let Y = 1
'1520:
If Bl = 85.1 Then Let Y = 1
'1530:
If Bl = 90 Then Let Y = 1
'1540:
If Bl = 98 Then Let Y = 1
'1550:
If Bl = 57.8 Then Let Y = 2
'1560:
If Bl = 78 Then Let Y = 2
'1570:
If Bl = 95.6 Then Let Y = 2
'1580:
If Bl = 105.5 Then Let Y = 2
'1590:
If Bl = 88 Then Let Y = 3
'1600:
If Bl = 100.85 Then Let Y = 3
'1610:
If Ba = 38 Or 40 Then Let Z = 0
'1620:
If Ba = 35 Then Let Z = 1
'1630:
If Ba = 30 Then Let Z = 2
'1640:
If Br$ = "N" Then GoTo 1910
'1650:
Brl = PROUND(Rf + M(X, Y, Z, 0), -1)
'1660:
If Dh < N(X, Y, Z, 1) Then GoTo 1690
'1670:
Print USING; "12X,K"; "Dump Height TOO LOW, Try Different Boom Length and Angle"
'1680:
GoTo 1330
'1690:
Bb = Brl + (B + T) / (C - L) - B / (A - L) - T / (D - L)
'1700:
Bsh = B + T - Bb / 2 * (C - L)
'1710:
Bsl = Brl - Brsh / (A - L) + Bsh / (C - L)
'1720:
If Bb > W Then GoTo 1760
'1730:
Bra = Brl * (B + T) + (B + T) ^ 2 / (2 * (C - L)) - B ^ 2 / (2 * (A - L)) - B * T / (A - L) - T ^ 2 / (2 * (D - L))
'1740:
Dha = Bra - Bb ^ 2 * C / 4
'1750:
GoTo 1780
'1760:
Bra = Brl * (B + T) + (B + T) ^ 2 / (2 * (C - L)) - B ^ 2 / (2 * (A - L)) - B * T / (A - L) - T ^ 2 / (2 * (D - L)) - (Bb - W) ^ 2 * C / 4
'1770:
Dha = Bra + (Bb - W) ^ 2 * C / 4 - Bb ^ 2 * C / 4
'1780:
Pdh = PROUND(Dha / (O * W * S) * 100, 0)
'1790:
If k$ = "N" Then GoTo 1880
'1800:
If Cs + Ks > Bra Then GoTo 1840
'1810:
Kb = Kb + (Bra - Cs - Ks) / S / B
'1820:
Kt = Kb + B / (A - L) * 2
'1830:
Ks = (Kb + Kt) / 2 * B * S
'1840:
Eba = Bra - Cs - Ks
'1850:
If N(X, Y, Z, 0) > W - Kb / 2 - B / (A - L) + Brl Then GoTo 1880
'1860:
INPUT "WIDTH of Cut too big, New width of cut (M) ?", W
'1870:
GoTo 890
'1880:
Print " "
'1890:
Print USING; "15X,K,3D,K"; "Percentage Double Handle"; Pdh; " %"
'1900:
Print " "
'1910:
INPUT "Are Digging Depths, Dump Heights required for Layer Digging ? Enter Y or N", Dh$
'1920:
If Dh$ = "N" Then GoTo 3930
'1930:
INPUT "Is a PRINT OUT of the results required ? Enter Y or N", Po$
'1940:
If Po$ = "N" Then GoTo 1960
'1950:
Print "SWITCH ON Printer if it is not on"
'1960:
Aw = W * W * C / 4
'1970:
Layer = Lr
'1980:
INPUT "Depth of Layer (M) ?", Lr
'1990:
Layer = Lr
'2000:
If Br$ = "Y" Then GoTo 2970
'2010:
If B = O Then GoTo 2240
'2020:
If Cs = Aw Then GoTo 2100
'2030:
If Cs < Aw Then GoTo 2060
'2040:
Rfc = PROUND(Cs / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2050:
Dhc = PROUND(Cs / W + W / 4 * C * (1 - L ^ 2) - B - T - Rfc * L - Rs * L - Rp * L, -1)
'2060:
GoTo 2120
'2070:
Rfc = PROUND(Sqr(Cs * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2080:
Dhc = PROUND(Sqr(Cs * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfc * L - Rs * L - Rp * L, -1)
'2090:
GoTo 2120
'2100:
Rfc = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2110:
Dhc = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfc * L - Rs * L - Rp * L - Rp * L, -1)
'2120:
If Dhc < 5 Then Let Dhc = 5
'2130:
Ai = ASN((M(X, 2) + W + (O - B)) / N(X, Y, Z, 0))
'2140:
Ao = ASN(M(X, 2) / N(X, Y, Z, 0))
'2150:
If Rfc + M(X, 1) > N(X, Y, Z, 0) Then GoTo 2190
'2160:
If Rfc + M(X, 1) = N(X, Y, Z, 0) Then GoTo 2190
'2070:
Ad = ASN((Rfc + M(X, 1)) / N(X, Y, Z, 0))
'2080:
GoTo 2200
'2090:
Ad = 90
'2200:
Ang = PROUND((Ao + Ai) / 2 + Ad, 0)
'2210:
If Po$ = "N" Then GoTo 2230
'2220:
PRINTER IS 701
'2230:
Print USING; "K,3D,K,3D.D,K,4D.D,K,4d,k"; "Chop Cut Height"; O - B; " M Dump Height"; Dhc; " M Reach Factor"; Rfc; " M Angle"; Ang; "Degs"
'2240:
If k$ = "Y" Then GoTo 2510
'2250:
Al = Layer * W * S + Cs
'2260:
If Al = Aw Then GoTo 2340
'2270:
If Al < Aw Then GoTo 2310
'2280:
Rfl = PROUND(Al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2290:
Dhl = PROUND(Al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2300:
GoTo 2360
'2310:
Rfl = PROUND(Sqr(Al * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2320:
Dhl = PROUND(Sqr(Al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2330:
GoTo 2360
'2340:
Rfl = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2350:
Dhl = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2360:
If Dhl < -1 * Layer + 5 Then Let Dhl = -1 * Layers + 5
'2370:
Ao = Atn((W - M(X, 1) - Layer / A) / (M(X, 0) + Layer))
'2380:
Ai = Atn((M(X, 1) + Layer / A) / (M(X, 0) + Layer))
'2390:
If Rfl + M(X, 1) > N(X, Y, Z, 0) Then GoTo 2430
'2400:
If Rfl + M(X, 1) = N(X, Y, Z, 0) Then GoTo 2430
'2410:
Ad = ASN((Rfl + M(X, 1)) / N(X, Y, Z, 0))
'2420:
GoTo 2440
'2430:
Ad = 90
'2440:
Ang = PROUND((Ao + Ai) / 2 - Ai + Ad, 0)
'2450:
If Po$ = "N" Then GoTo 2470
'2460:
PRINTER IS 701
'2470:
Print USING; "4X,K,3D.D,K,3D.D,K,4D,K"; "Dig Depth"; Layer; " M Dump Height"; Dhl; " M Reach Factor"; Rfl; " M Angle"; Ang; " Degs"
'2480:
Layer = Layer + Lr
'2490:
If Layer > B + 1 Then GoTo 3930
'2500:
GoTo 2250
'2510:
If Ks = Aw Then GoTo 2590
'2520:
If Ks < Aw Then GoTo 2590
'2530:
Drk = PROUND(Ks / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp + W - Kb / 2, -1)
'2540:
Dhk = PROUND(Ks / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - T - Drk * L - Rs * L - Rp * L, -1)
'2550:
GoTo 2610
'2560:
Drk = PROUND(Sqr(Ks * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) + Rs + Rp + W - Kb / 2, -1)
'2570:
Dhk = PROUND(Sqr(Ks * 4 / (C - L)) / 2 * C * (1 - L ^ 2) - B - T - Drk * L - Rs * L - Rp * L, -1)
'2580:
GoTo 2610
'2590:
Drk = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp + W - Kb / 2, -1)
'2600:
Dhk = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Drk * L - Rs * L - Rp * L, -1)
'2610:
If Dhk < 5 Then Let Dhk = 5
'2620:
If Drk > N(X, Y, Z, 0) Then GoTo 2650
'2630:
Kad = PROUND(ASN(Drk / N(X, Y, Z, 0)), 0)
'2640:
GoTo 2680
'2650:
Print USING; "K,3D.D,K"; "Dump Radius too Big, Reduce Width of Cut by"; N(X, Y, Z, 0) - Drk; " M"
'2660:
INPUT "New Width of Cut (M) ?", W
'2670:
GoTo 890
'2680:
If Po$ = "N" Then GoTo 2700
'2690:
PRINTER IS 701
'2700:
Print USING; "2X,K,3D,K,3D.D,K,4D.D,K,4D,K"; "Key Dig Depth"; B; " M Dump Height"; Drk; " M"
'2710:
Al = (W - Kt + Layer / (A - L)) * Layer * S + Ks + Cs
'2720:
If Al = Aw Then GoTo 2800
'2730:
If Al < Aw Then GoTo 2770
'2740:
Rfl = PROUND(Al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs = Rp, -1)
'2750:
Dhl = PROUND(Al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2760:
GoTo 2820
'2770:
Rfl = PROUND(Sqr(Al * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2780:
Dhl = PROUND(Sqr(Al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2790:
GoTo 2820
'2800:
Rfl = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) + Rs + Rp, -1)
'2810:
Dhl = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'2820:
If Dhl < -1 * Layer + 5 Then Let Dhl = -1 * Layer + 5
'2830:
Ao = Atn((W - M(X, 1) - Kt + Layer / (A - L)) / (M(X, 0) + Layer))
'2840:
Ai = Atn((M(X, 1) + Layer / (A - L)) / (M(X, 0) + Layer))
'2850:
If Rfl + M(X, 1) > N(X, Y, Z, 0) Then GoTo 2890
'2860:
If Rfl + M(X, 1) = N(X, Y, Z, 0) Then GoTo 2890
'2870:
Ad = ASN((Rfl + M(X, 1)) / N(X, Y, Z, 0))
'2880:
GoTo 2900
'2890:
Ad = 90
'2900:
Ang = PROUND((Ao + Ai) / 2 - Ai + Ad, 0)
'2910:
If Po$ = "N" Then GoTo 2930
'2920:
PRINTER IS 701
'2930:
Print USING; "4X,K,3D.D,K,3D.D,K,4D,K"; "Dig Depth"; Layer; " M Dump Height "; Dhl; " M Reach Factor"; Rfl; " M Angle"; Ang; "Degs"
'2940:
Layer = Layer + Lr
'2950:
If Layer > B + 1 Then GoTo 3930
'2960:
GoTo 2710
'2970:
If k$ + "Y" Then GoTo 3430
'2980:
If B = O Then GoTo 3080
'2990:
Rfc = PROUND(Brl, -1)
'3000:
Dhc = 5
'3010:
Ai = ASN((M(X, 2) + W + (O - B)) / N(X, Y, Z, 0))
'3020:
Ao = ASN(M(X, 2) / N(X, Y, Z, 0))
'3030:
Ad = ASN((Rfc + M(X, 1)) / N(X, Y, Z, 0))
'3040:
Ang = PROUND((Ao + Ai) / 2 + Ad, 0)
'3050:
If Po$ = "N" Then GoTo 3070
'3060:
PRINTER IS 701
'3070:
Print USING; "K,3D,K,3D.D,K,4D.D,K,4D,K"; "Chop Cut Height"; O - B; "M Dump Height"; Dhc; "M Reach Factor"; Rfc; "M Angle"; Ang; "Degs"
'3080:
Al = Layer * W * S + (Brl + Layer / 2 * (1 / (C - L) - 1 / (A - L))) * Layer + Bra - Dha
'3090:
If Al = Aw Then GoTo 3170
'3100:
If Al < Aw Then GoTo 3140
'3110:
Rfl = PROUND(Al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3120:
Dhl = PROUND(Al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3130:
GoTo 3190
'3140:
Rfl = PROUND(Sqr(Al * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3150:
Dhl = PROUND(Sqr(Al * 4 / (C + L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3160:
GoTo 3190
'3170:
Rfl = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3180:
Dhl = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3190:
If Dhl < -1 * Layer + 5 Then Let Dhl = -1 * Layer + 5
'3200:
Ao = Atn((W + Brl - M(X, 1) - Layer / A) / (M(X, 0) + Layer))
'3210:
If Layer > Bsh Then GoTo 3240
'3220:
Ai = Atn((M(X, 1) + Layer))
'3230:
GoTo 3260
'3240:
Ai = Atn((M(X, 1) + Bsh / C - (Layer - Bsh) / C) / (M(X, 0) + Layer))
'3250:
If Rfl + M(X, 1) > N(X, Y, Z, 0) Then GoTo 3290
'3260:
If Rfl + M(X, 1) = N(X, Y, Z, 0) Then GoTo 3290
'3270:
Ad = ASN((Rfl + M(X, 1)) / N(X, Y, Z, 0))
'3280:
GoTo 3300
'3290:
Ad = 90
'3300:
Ang = PROUND((Ao + Ai) / 2 - Ai + Ad, 0)
'3310:
If Po$ = "N" Then GoTo 3330
'3320:
PRINTER IS 701
'3330:
Print USING; "4X,K,3D.D,K,,4D.D,K,4D,K"; "Dig Depth"; Layer; "M Dump Height"; Dhl; "M Reach Factor"; Rfl; "M Angle"; Ang; "Degs"
'3340:
Layer = Layer + Lr
'3350:
If Layer > B + 1 Then GoTo 3390
'3360:
If Layer < Bsh Then GoTo 3080
'3370:
Al = Layer * W * S * (Brl + Bsl) / 2 * Bsh + (Layer - Bsh) * (Bsl - (Layer - Bsh) / 2 * (1 / (A - L) + 1 / (C - L))) + Bra - Dha
'3380:
GoTo 3090
'3090:
If Po$ = "N" Then GoTo 3410
'3400:
PRINTER IS 701
'3410:
Print USING; "4X,K,3D.D,K,3D.D,K,4D.D,K,4D,K"; "Dig Depth"; B + T; "M Dump Height"; Dh; "M Reach Factor"; Rf; "M Angle"; Ang; "Degs"
'3420:
GoTo 3930
'3430:
If B = O Then GoTo 3530
'3440:
Rfc = PROUND(W - Kb / 2 - B / (A - L) + Brl, -1)
'3450:
Dhc = 5
'3460:
Ai = ASN((M(X, 2) + W + (O - B)) / N(X, Y, Z, 0))
'3470:
Ao = ASN(M(X, 2) / N(X, Z, Y, 0))
'3480:
Ad = ASN((Rfc + M(X, 1)) / N(X, Y, Z, 0))
'3490:
Ang = PROUND((Ao + Ai) / 2 + Ad, 0)
'3500:
If Po$ = "N" Then GoTo 3520
'3510:
PRINTER IS 701
'3520:
Print USING; "K,3D,K,3D.D,K,4D.DK,4D,K"; "Chop Cut Height"; O - B; "M Dump Height"; Dhc; "M Reach Factor"; Rfc; " M Angle"; Ang; "Degs"
'3530:
Drk = PROUND(W - Kb / 2 - B / (A - L) + Brl, -1)
'3540:
Dhk = 5
'3550:
Kad = PROUND(ASN(Drk / N(X, Y, Z, 0)), 0)
'3560:
If Po$ = "N" Then GoTo 3580
'3570:
PRINTER IS 701
'3580:
Print USING; "2X,K,3D,K,3D.D,K,4D.D,K,4D,K"; "Key Dig Depth"; B; " M Dump Height"; Dhk; "M Dump Radius"; Drk; "M Angle"; Kad; "Degs"
'3590:
Al = (W - Kt + Layer / (A - L)) * Layer * S + (Brl + Layer / 2 * (1 / (C - L) - 1 / (A - L))) * Layer + Bra - Dha + Eba
'3600:
If Al = Aw Then GoTo 3680
'3610:
If Al < Aw Then GoTo 3650
'3620:
Rfl = PROUND(Al / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C - L) + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3630:
Dhl = PROUND(Al / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3640:
GoTo 3700
'3650:
Rfl = PROUND(Sqr(Al * 4 / (C + L)) / 2 + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3660:
Dhl = PROUND(Sqr(Al * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3670:
GoTo 3700
'3680:
Rfl = PROUND(W / 2 * (C - L ^ 2 / C) / (C + L) + B / (A - L) + T / (D - L) - Brl + Rs + Rp, -1)
'3690:
Dhl = PROUND(W / 2 * C * (1 - L ^ 2 / C ^ 2) - B - T - Rfl * L - Rs * L - Rp * L, -1)
'3700:
If Dhl < -1 * Layer + 5 Then Let Dhl = -1 * Layer + 5
'3710:
Ao = Atn((W + Brl - M(X, 1) - Layer / A) / (M(X, 0) + Layer))
'3720:
If Layer > Bsh Then GoTo 3750
'3730:
Ai = Atn((M(X, 1) + Layer / C) / (M(X, 0) + Layer))
'3740:
GoTo 3770
'3750:
Ai = Atn((M(X, 1) + Bsh / C - (Layer - Bsh) / C) / (M(X, 0) + Layer))
'3760:
If Rfl + M(X, 1) > N(xX, Y, Z, 0) Then GoTo 3800
'3770:
If Rfl + M(X, 1) = N(X, Y, Z, 0) Then GoTo 3800
'3780:
Ad = ASN((Rfl + M(X, 1)) / N(X, Y, Z, 0))
'3790:
GoTo 3810
'3800:
Ad = 90
'3810:
Ang = PROUND((Ao + Ai) / 2 - Ai + Ad, 0)
'3820:
If Po$ = "N" Then GoTo 3840
'3830:
PRINTER IS 701
'3840:
Print USING; "4X,K,3D.D,K,3D.D,K,4D.D,K,4D,K"; "Dig Depth"; Layer; "M Dump Height"; Dhl; "M Reach Factor"; Rfl; "M Angle"; Ang; "Degs"
'3850:
Layer = Layer + Lr
'3860:
If Layer > B + 1 Then GoTo 3900
'3870:
If Layer < Bsh Then GoTo 3590
'3880:
Al = (W - Kt + Layer / (A - L)) * Layer * S + (Brl + Bsl) / 2 * Bsh + (Layer - Bsh) * (Bsl - (Layer - Bsh) / 2 * (1 / (A - L) + 1 / (C - L))) + Bra - Dha
'3890:
GoTo 3600
'3900:
If Po$ = "N" Then GoTo 3920
'3910:
PRINTER IS 701
'3920:
Print USING; "4X,K,3D.D,K,3D.D,K,4D.D,K,4D,K"; "Dig Depth"; B + T; "M Dump Height"; Dh; "M Reach Factor"; Rf; "M Angle"; Ang; "Degs"
'3930:
PRINTER IS 1
'3940:
Print " "
'3950:
INPUT "Is a DRAWING of the Cut Diagram Required ? Enter Y or N", D$
'3960:
If D$ = "N" Then GoTo 7140
'3970:
INPUT "Is a PRINT of Cut Diagram Required ? Enter Y or N", P$
'3980:
If P$ = "N" Then GoTo 4010
'3990:
Print "SWITCH ON Printer if it is not on"
'4000:
Print " "
'4010:
Print "If MENU is showing Press 'Menu' to clear and then 'f2' to Draw Cut Diagram"
'4020:
PAUSE
'4030:
OUTPUT KBD;"K";
'4040:
GINIT
'4050:
GRAPHICS ON
'4060:
VIEWPORT 11, 111, 2, 72
'4070:
Frame
'4080:
WINDOW 0, M(X, 3), 0, M(X, 4)
'4090:
CSIZE 3.5, 0.6
'4100:
If L < 0 Then GoTo 4140
'4110:
Move 0, M(X, 3) * L + 0.21 * M(X, 4)
'4120:
DRAW M(X, 3), 0.21 * M(X, 4)
'4130:
GoTo 4160
'4140:
Move 0, 0.21 * M(X, 4)
'4150:
DRAW M(X, 3) - -1 * M(X, 3) * L + 0.21 * M(X, 4)
'4160:
Hbl = Abs(M(X, 3) / 2 * L) + 0.21 * M(X, 4)
'4170:
Move M(X, 3) / 2 + Rp / 2, Hbl - Rp / 2 * L
'4180:
DRAW M(X, 3) / 2 + Rsp + Rp / 2, Hbl + Hsp - Rp / 2 * L
'4190:
DRAW M(X, 3) / 2 + Rsp + Rp / 2 + (W + (W * Sin(Atn(L))) / C) / 2, Hbl + Hsp - (W + (W * Sin(Atn(L))) / C) / 2 * C - Rp / 2 * L
'4200:
If Br$ = "N" Then GoTo 4300
'4210:
Move M(X, 3) / 2 - T / (D - L) - Rs - B / (A - L), Hbl + T + Rs * L + B
'4220:
DRAW M(X, 3) / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + T + Rs * L + B
'4230:
DRAW M(X, 3) / 2 + Bb / 2, Hbl + Bb / 2 * (C - L)
'4240:
LINE TYPE 4
'4250:
If Bb > W Then GoTo 4280
'4260:
DRAW M(X, 3) / 2 + Bb, Hbl - Bb * L
'4270:
GoTo 4290
'4280:
DRAW M(X, 3) / 2 + W + (Bb - W) / 2, Hbl - W * L + (Bb - W) / 2 * (C - L)
'4290:
LINE TYPE 1
'4300:
Move M(X, 3) / 2 + W + Rp / 2, Hbl - W * L - Rp / 2 * L
'4310:
DRAW M(X, 3) / 2 + W + Rsp + Rp / 2, Hbl - W * L + Hsp - Rp / 2 * L
'4320:
DRAW M(X, 3) / 2 + W + Rsp + Rp / 2 + (W + (W * Sin(Atn(L))) / C) / 2, Hbl + Hsp - W * L - (W + (W * Sin(Atn(L))) / C) / 2 * C - Rp / 2 * L
'4330:
Move M(X, 3) / 2 + W * 2 + Rp / 2, Hbl - W * L * 2 - Rp / 2 * L
'4340:
DRAW M(X, 3) / 2 + W * 2 + Rsp + Rp / 2, Hbl - Rp / 2 * L
'4350:
DRAW M(X, 3) / 2 + W * 2 + Rsp + Rp / 2 + (W + (W * Sin(Atn(L))) / C) / 2, Hbl + Hsp - W * L * 2 - (W + (W * Sin(Atn(L))) / C) / 2 * C - Rp / 2 * L
'4360:
Move M(X, 3) / 2 + W * 3 + Rp / 2, Hbl - W * L * 3 - Rp / 2 * L
'4370:
DRAW M(X, 3) / 2 + W * 3 + Rsp + Rp / 2, Hbl - W * L * 3 + Hsp - Rp / 2 * L
'4380:
DRAW M(X, 3) / 2 + W * 3 + Rsp + Rp / 2 + (W + (W * Sin(Atn(L))) / C) / 2, Hbl + Hsp - W * L * 3 - (W + (W * Sin(Atn(L))) / C) / 2 * C - Rp / 2 * L
'4390:
Move M(X, 3) / 2 + W * 4 + Rp / 2, Hbl - W * L * 4 - Rp / 2 * L
'4400:
DRAW M(X, 3) / 2 + W * 4 + Rsp + Rp / 2, Hbl - W * L * 4 + Hsp - Rp / 2 * L
'4410:
DRAW M(X,3)/2+W*4+Rsp+Rp/2+(W+(W*SIN(ATN(L)))/C)/2,Hbl+Hsp-W*SIN(ATN(L)))/C)/2*C-Rp/2*L
'4420:
Move M(X, 3) / 2 - Rp / 2, Hbl + Rp / 2 * L
'4430:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L), Hbl + T + Rp / 2 * L
'4440:
DRAW 0, Hbl + T + (M(X, 3) / 2 - Rp / 2 - T / (D - L)) * L
'4450:
Move M(X, 3) / 2 - Rp / 2 - W, Hbl + Rp / 2 * L + W * L
'4460:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - W, Hbl + T + Rp / 2 * L + W * L
'4470:
Move M(X, 3) / 2 - Rp / 2 - W * 2, Hbl + Rp / 2 * L + W * L * 2
'4480:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - W * 2, Hbl + T + Rp / 2 * L + W * L * 2
'4490:
Move M(X, 3) / 2 - Rp / 2 - W * 3, Hbl + Rp / 2 * L + W * L * 3
'4500:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - W * 3, Hbl + T + Rp / 2 * L + W * L * 3
'4510:
Move M(X, 3) / Rp / 2 - W * 4, Hbl + Rp / 2 * L + W * L * 4
'4520:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - W * 4, Hbl + T + Rp / 2 * L + W * L * 4
'4530:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs, Hbl + T + Rp / 2 * L + Rs * L
'4540:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + T + Rp / 2 * L + Rs * L + B
'4550:
DRAW 0, Hbl + T + B + (M(X, 3) / 2 - Rp / 2 - T / (D - L) - B / (A - L)) * L
'4560:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W, Hbl + T + Rp / 2 * L + Rs * L + W * L
'4570:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - W, Hbl + T + Rp / 2 * L + Rs * L + B + W * L
'4580:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W * 2, Hbl + T + Rp / 2 * L + Rs * L + W * L * 2
'4590:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - W * 2, Hbl + T + Rp / 2 * L + Rs * L + Rs * L + B + W * L * 2
'4600:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W * 3, Hbl + T + Rp / 2 * L + W * L * 3
'4610:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - W * 3, Hbl + T + Rp / 2 * L + Rs * L + B + W * L * 3
'4620:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W * 4, Hbl + T + Rp / 2 * L + Rs * L + W * L * 4
'4630:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - W * 4, Hbl + T + Rp / 2 * L + Rs * L + B + W * L * 4
'4640:
If k$ = "N" Then GoTo 4780
'4650:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W + Kb, Hbl + T + Rp / 2 * L + W * L - Kb * L
'4660:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - W + Kb + B / (A - L), Hbl + T + Rp / 2 * L + W * L - Kb * L + B
'4670:
If Br$ = "Y" Then GoTo 4780
'4680:
If Ks = Aw Then GoTo 4760
'4690:
If Ks < Aw Then GoTo 4730
'4700:
MOVE M(X,3)/2+Rp/2+Ks/W/(C+L)+W/4*(C-L^2/C)/(C+L),Hbl+Ks/W+W/4*C*(1-L^2/C^2)Rp/2*L
'4710:
DRAW M(X, 3) / 2 + Rp / 2 + Ks / W / (C + L) + W / 4 * (C - L ^ 2 / C) / (C + L) + (W + (W * Sin(Atn(L))) / C) / 2, Hbl + Ks / W + W / 4 * C * (1 - L ^ 2 / C ^ 2) - (W + (W * Sin(Atn(L))) / C) / 2 * C - Rp / 2 * L
'4720:
GoTo 4780
'4730:
Move M(X, 3) / 2 + Rp / 2 + Sqr(Ks * 4 / (C + L)) / 2, Hbl + Sqr(Ks * 4 / (C - L)) / 2 * C * (1 - L ^ 2 / C ^ 2) - Rp / 2 * L
'4740:
DRAW M(X, 3) / 2 + Rp / 2 + Sqr(Ks * 4 / (C + L)), Hbl + Sqr(Ks * 4 / (C - L)) * L - Rp / 2 * L
'4750:
GoTo 4780
'4760:
Move M(X, 3) / 2 + Rp / 2 + W / 2 * (C - L ^ 2 / C) / (C + L), Hbl + W / 2 * C * (1 - L ^ 2 / C ^ 2) * L - Rp / 2 * L
'4770:
DRAW M(X, 3) / 2 + W + Rp / 2, Hbl - W * L - Rp / 2 * L
'4780:
If B = O Then GoTo 4940
'4790:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2), Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L
'4800:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - (O - B), Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + (O - B)
'4810:
DRAW 0, Hbl + T + Rp * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + (O - B) + (M(X, 3) / 2 - Rp / 2 - T / (D_L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - (O - B)) * L
'4820:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - W, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + W * L
'4830:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - (O - B) - W, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + (O - B) + W * L
'4840:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - W * 2, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + W * L * 2
'4850:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - (O - B) - W * 2, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + (O - B) + W * L * 2
'4860:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X, 2) - W * 3, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + W * L * 3
'4870:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) - M(X - 2) - (O - B) - W * 3, Hbl + T + Rp / 2 * L + Rs * L + B + (M(X, 1) + M(X, 2)) * L + (O - B) + W * L * 3
'4880:
Move M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + T + B + (O - B) + W * 1.6 * L
'4890:
DRAW M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + 0.07 * M(X, 4) + T + B + (O - B) + W * 1.6 * L
'4900:
LDIR 90
'4910:
LORG 1
'4920:
Move 0.99 * M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + 0.01 * M(X, 4) + T + B + (O - B) + W * 1.6 * L
'4930:
LABEL USING "K";O-B
'4940:
LDIR 0
'4950:
Move M(X, 3) / 2 + W + Rp / 2, Hbl - 0.01 * M(X, 4) - W * L
'4960:
DRAW M(X, 3) / 2 + W + Rp / 2, 0.145 * M(X, 4)
'4970:
Move M(X, 3) / 2 + Rp / 2, Hbl - 0.01 * M(X, 4)
'4980:
DRAW M(X, 3) / 2 + Rp / 2, 0.145 * M(X, 4)
'4990:
Move M(X, 3) / 2 - Rp / 2, Hbl - 0.01 * M(X, 4) + Rp / 2 * L
'5000:
DRAW M(X, 3) / 2 - Rp / 2, 0.145 * M(X, 4)
'5010:
Move M(X, 3) / 2 - Rp / 2 - W, Hbl - 0.01 * M(X, 4) + Rp / 2 * L + W * L
'5020:
DRAW M(X, 3) / 2 - Rp / 2 - W, 0.145 * M(X, 4)
'5030:
Move M(X, 3) / 2 + W + Rp / 2, 0.15 * M(X, 4)
'5040:
DRAW M(X, 3) / 2 + Rp / 2, 0.15 * M(X, 4)
'5050:
Move M(X, 3) / 2 - Rp / 2, 0.15 * M(X, 4)
'5060:
DRAW M(X, 3) / 2 - Rp / 2 - W, 0.15 * M(X, 4)
'5070:
LORG 4
'5080:
Move M(X, 3) / 2 + W / 2 + Rp / 2, 0.15 * M(X, 4)
'5090:
LABEL USING "K";W
'5100:
Move M(X, 3) / 2 - Rp / 2 - W / 2, 0.15 * M(X, 4)
'5110:
LABLE USING "K";W
'5120:
If Rp = 0 Then GoTo 5200
'5130:
Move M(X, 3) / 2.15 * M(X, 4)
'5140:
If Rp > 6 Then GoTo 5180
'5150:
LORG 6
'5160:
LABLE USING "K";Rp
'5170:
GoTo 5200
'5180:
LORG 4
'5191:
Move M(X, 3) / 2 + Rp / 2, 0.15 * M(X, 4)
'5192:
DRAW M(X, 3) / 2 - Rp / 2, 0.15 * M(X, 4)
'5200:
If Rs = 0 Then GoTo 5300
'5210:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L), Hbl + 0.01 * M(X, 4) + T + Rp / 2 * L
'5220:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L), Hbl + 8 * M(X, 4) + T
'5230:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs, Hbl + 0.01 * M(X, 4) + T + Rp / 2 * L + Rs * L
'5240:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs, Hbl + 0.08 * M(X, 4) + T
'5250:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L), Hbl + 0.075 * M(X, 4) + T
'5260:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs, Hbl + 0.075 * M(X, 4) + T
'5270:
Move M(X, 3) / 2 - Rp / 2 - Rp / 2 - T / (D - L) - Rs / 2, Hbl + 0.075 * M(X, 4) + T
'5280:
LORG 4
'5290:
LABEL USING "K";Rs
'5300:
If Br$ = "N" Then GoTo 5800
'5310:
Move M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.01 * M(X, 4) + Hsp
'5320:
DRAW M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.14 * M(X, 4) + Hsp
'5330:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + 0.015 * M(X, 4) + T + Rp / 2 * L + Rs * L + B
'5340:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + 0.14 * M(X, 4) + T + B
'5350:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl - 0.02 * M(X, 4) + T + Rp / 2 * L + Rs * L + B - Brl * L + M(X, 1) * L
'5360:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.05 * M(X, 4) + T + B
'5370:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.12 * M(X, 4) + T + B
'5380:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.14 * M(X, 4) + Hsp
'5390:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.13 * M(X, 4) + T + B
'5400:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + 0.13 * M(X, 4) + T + B
'5410:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.015 * M(X, 4) + T + Rp / 2 * L + Rs * L + B
'5420:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.07 * M(X, 4) + T + B
'5430:
Move M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.13 * M(X, 4) + Hsp
'5440:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.13 * M(X, 4) + Hsp
'5450:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + 0.06 * M(X, 4) + T + B
'5460:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.06 * M(X, 4) + T + B
'5470:
Move 0.97 * M(X, 3) / 2 + Rsp + Rp / 2, Hbl + Hsp / 2 * L
'5480:
DRAW 0.94 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + Hsp - Rp / 2 * L
'5490:
Move 1.03 * M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + T + Rp / 2 * L + Rs * L + B
'5500:
DRAW 0.96 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + T + Rp / 2 * L + Rs * L + B
'5510:
Move 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + Hsp - Rp / 2 * L
'5520:
DRAW 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + T + Rp / 2 * L + Rs * L + B
'5530:
Move M(X, 3) / 2 + Rsp + Rp / 2 - (Rf - Brl + M(X, 1)) / 2, Hbl + 0.13 * M(X, 4) + Hsp
'5540:
LABEL USING "K";Rf-Brl+M(X,1)
'5550:
If M(X, 1) < 15 Then GoTo 5590
'5560:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1) / 2, Hbl + 0.13 * M(X, 4) + T + B
'5570:
LORG 4
'5580:
GoTo 5610
'5590:
Move 1.01 * M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl - M(X, 1), Hbl + 0.13 * M(X, 4) + T + B
'5600:
LORG 1
'5610:
LABEL USING "K";M(X,1)
'5620:
If Brl < M(X, 1) Then GoTo 5660
'5630:
LORG 4
'5640:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl / 2, Hbl + 0.06 * M(X, 4) + T + B
'5650:
GoTo 5680
'5660:
LORG 7
'5670:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) + Brl, Hbl + 0.06 * M(X, 4) + T + B
'5680:
LABEL USING "K";Brl
'5690:
If Dh < 15 Then GoTo 5730
'5700:
Move 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + (T + Rp / 2 * L + B + Brl * L + Hsp) / 2
'5710:
LORG 4
'5720:
GoTo 5750
'5730:
Move 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + 0.005 * M(X, 4) + T + Rp / 2 * L + Rs * L + B + Brl * L
'5740:
LORG 1
'5750:
LDIR 90
'5760:
LABEL USING "K";Dh
'5770:
LORG 4
'5780:
LDIR 0
'5790:
GoTo 6140
'5800:
Move M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.01 * M(X, 4) + Hsp
'5810:
DRAW M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.14 * M(X, 4) + Hsp
'5820:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1), Hbl - 0.02 * M(X, 4) + T + Rp / 2 * L + Rs * L + B + M(X, 1) * L
'5830:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1), Hbl + 0.14 * M(X, 4) + Hsp
'5840:
Move M(X, 3) / 2 + Rsp + Rp / 2, Hbl + 0.13 * M(X, 4) + Hsp
'5850:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1), Hbl + 0.13 * M(X, 4) + Hsp
'5860:
Move M(X, 3) / 2 + Rsp + Rp / 2 - (Rf + M(X, 1)) / 2, Hbl + 0.13 * M(X, 4) + Hsp
'5870:
LORG 4
'5880:
LABLE USING "K";Rf+M(X,1)
'5890:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.08 * M(X, 4) + Hsp
'5900:
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.015 * M(X, 4) + T + B
'5910:
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + 0.07 * M(X, 4) + Hsp
'5920
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) / 2, Hbl + 0.07 * M(X, 4) + Hsp
'5930
If M(X, 1) < 15 Then GoTo 5970
'5940
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L) - M(X, 1) / 2, Hbl + 0.07 * M(X, 4) + Hsp
'5950
LORG 4
'5960
GoTo 5990
'5970
Move 1.01 * M(X, 3) / 2 - Rp / 2 - T(D - L) - Rs - B / (A - L) - M(X, 1), Hbl + 0.07 * M(X, 4) + Hsp
'5980
LORG 1
'5990
LABEL USING "K";M(X,1)
'6000
Move 0.97 * M(X, 3) / 2 + Rsp + Rp / 2, Hbl + Hsp - Rp / 2 * L
'6010
DRAW 0.94 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + Hsp - Rp / 2 * L
'6020
Move 1.03 * M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / (A - L), Hbl + T + Rp / 2 * L + Rs * L + B
'6030
DRAW 0.96 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + T + Rp / 2 * L + Rs * L + B
'6040
MOVE .95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + Hsp - Rp / 2 * L]
'6050
DRAW 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + T + Rp / 2 * L + Rs * L + B
'6060
If Dh < 15 Then GoTo 6100
'6070
Move 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + (T + Rp / 2 * L + Rs * L + B + Hsp) / 2
'6080
LORG 4
'6090
GoTo 6120
'6100
Move 0.95 * M(X, 3) / 2 + Rsp + Rp / 2 - Dh / (C - L), Hbl + 0.006 * M(X, 4) + T + Rp / 2 * L + Rs * L + B
'6110
LORG 1
'6120
LDIR 90
'6130
LABEL USING "K";Dh
'6140
LDIR 0
'6150
Move M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + Rp / 2 * L + W * 1.6 * L + T + B
'6160
DRAW M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + Rp / 2 * L + W * 1.6 * L + T
'6170
Move M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + Rp / 2 * L + W * 1.6 * L
'6180
DRAW M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl - 0.07 * M(X, 4) + Rp / 2 * L + W * 1.6 * L
'6190
LDIR 90
'6200
LORG 4
'6210
Move 0.99 * M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl + T + Rp / 2 * L + Rs * L + B / 2
'6220
LABEL USING "K";B
'6230
LORG 7
'6240
Move 0.99 * M(X, 3) / 2 - Rp / 2 - W * 1.6, Hbl - 0.011 * M(X, 4) + Rp / 2 * L + W * 1.6 * L
'6250
LABEL USING "K";T
'6260
If Br$ = "N" Then GoTo 6310
'6270
Move (M(X, 3) - Rp / 2 - T / (D - L) - Rs - (Bb / 2 * (C - L) - T) / (A - L) + Bb / 2) / 2, Hbl + Bb / 2 * (C - L)
'6280
LORG 5
'6290
LDIR 0
'6300
LABEL USING "2D,K";Pdh,"%"
'6310
Move 0.99 * M(X, 3), 0.007 * M(X, 4)
'6320
LORG 7
'6330
LDIR 0
'6340
LABEL USING "K";Date$
'6350
Move 0.01 * M(X, 3), 0.99 * M(X, 4)
'6360
LORG 3
'6370
LABEL USING "K,K,K,4D.DD,K,3D.D,K";"W",S$,"    BOOM LENGTH",Bl," M BOOM ANGLE",Ba,"°"
'6380
Move M(X, 3) / 2, 0.94 * M(X, 4)
'6390
LORG 6
'6400
LABEL USING "K,4D.D,K,3D.D,K";DUMP RADIUS",N(X,Y,Z,0)," M DUMP HEIGHT",N(X,Y,Z,1),"M"
'6410
If AAs < 40 Then GoTo 6460
'6420
Move 0.985 * M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs, Hbl + T + Rp / 2 * L + Rs * L
'6430
LORG 7
'6440
LABEL USING "K,K";As,"°"
'6450
GoTo 6550
'6460
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / 3 / (A - L), Hbl + T + Rp / 2 * L + Rs * L + B / 3
'6470
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - 2 * B / 3 / (A - L), Hbl + T + Rp / 2 * L + Rs * L + B / 3
'6480
DRAW M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - 2 * B / 3 / (A - L), Hbl + T + Rp / 2 * L + Rs * L + 2 * B / 3
'6490
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - B / 2 / (A - L), Hbl + T + Rp / 2 * L + Rs * L + B / 3
'6500
LORG 6
'6510
Label "1"
'6520
Move M(X, 3) / 2 - Rp / 2 - T / (D - L) - Rs - 2 * B / 3 / (A - L), Hbl + T + Rp / 2 * L + Rs * L + Rs * L + B / 2
'6530
LORG 8
'6540
LABEL USING "K";As
'6550
If Ca < 10 Then GoTo 6600
'6560
Move M(X, 3) / 2 + Rp / 2 + 0.05 * M(X, 4) / (C - L), Hbl
'6570
LORG 1
'6580
LABEL USING "K,K";Ca,"°"
'6590
GoTo 6690
'6600
Move M(X, 3) / 2 + Rp / 2 + 0.07 * M(X, 4) / (C - L), Hbl + 0.07 * M(X, 4)
'6610
DRAW M(X, 3) / 2 + Rp / 2 + 0.14 * M(X, 4) / (C - L), Hbl + 0.07 * M(X, 4)
'6620
DRAW M(X, 3) / 2 + Rp / 2 + 0.14 * M(X, 4) / (C - L), Hbl + 0.14 * M(X, 4)
'6630
Move M(X, 3) / 2 + Rp / 2 + 0.105 * M(X, 4) / (C - L), Hbl + 0.07 * M(X, 4)
'6640
LORG 6
'6650
Label "1"
'6660
Move M(X, 3) / 2 + Rp / 2 + 0.14 * M(X, 4) / (C - L), Hbl + 0.105 * M(X, 4)
'6670
LORG 2
'6680
LABEL USING "K";Ca
'6690
Move M(X, 3) / 2 - Rp / 2 - T / (2 * (D - L)), Hbl + T / 2
'6700
DRAW 0.98 * M(X, 3) / 2 - Rp / 2 - T / (D - L), Hbl + T / 2
'6710
DRAW 0.98 * M(X, 3) / 2 - Rp / 2 - T / (D - L), 0.11 * M(X, 4)
'6720
DRAW 0.94 * M(X, 3) / 2 - Rp / 2 - T / (D - L), 0.11 * M(X, 4)
'6730
Move 0.94 * M(X, 3) / 2 - Rp / 2 - T / (D - L), 0.11 * M(X, 4)
'6740
LORG 8
'6750
If Ds = 90 Then GoTo 6810
'6760
If Ds < 40 Then GoTo 6790
'6770
LABEL USING "K,K,K";ANGLE ON SEAM ",Ds,"°"
'6780
GoTo 6820
'6790
LABEL USING "K,K,K";"SLOPE ON SEAM",Ds,":1"
'6800
GoTo 6820
'6810
Label "NO SLOPE ON SEAM"
'6820
Move M(X, 3) / 2 + Rp / 2 + O * S / 2 / (C - L) + W / 2, Hbl + O * S / 2
'6830
LORG 4
'6840
Label "SWELL"
'6850
Move M(X, 3) / 2 + Rp / 2 + O * S / 2 / (C - L) + W / 2, Hbl + O * S / 2
'6860
LORG 6
'6870
LABEL USING "K,K";Si,"%"
'6880
If L = 0 Then GoTo 6980
'6890
Move 0.96 * M(X, 3), 0.11 * M(X, 4)
'6900
DRAW 0.97 * M(X, 3), 0.11 * M(X, 4)
'6910
DRAW 0.97 * M(X, 3), Hbl - 0.47 * M(X, 3) * L
'6920
Move 0.85 * M(X, 3), 0.155 * M(X, 4)
'6930
LORG 5
'6940
LABEL USING "K,K";ABS(La),"° TO"
'6950
Move 0.75 * M(X, 3), 0.11 * M(X, 4)
'6960
LORG 2
'6970
Label "HORIZONAL"
'6980
CLIP OFF
'6990
CSIZE 4.5, 0.75
'7000
LDIR 0
'7010
Move M(X, 3) / 2, 1.01 * M(X, 4)
'7020
LORG 4
'7030
Label "CUT DIAGRAM"
'7040
If P$ = "N" Then GoTo 7100
'7050
Print "Press 'f2' to Print Cut Diagram"
'7060
PAUSE
'7070
DUMP DEVICE Is 701, EXPANDED
'7080
DUMP GRAPHICS
'7090
OUTPUT KBD;"K";
'7100
Print "Press 'f2' to Clear Screen"
'7110
PAUSE
'7120
GCLEAR
'7130
OUTPUT KBD;"K";
'7140
INPUT "Is another Cut Diagramcalculation required ? Enter Y or N", C$
'7150
If C$ = "Y" Then GoTo 230
'7160
End
