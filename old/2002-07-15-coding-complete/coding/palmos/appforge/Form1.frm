VERSION 5.00
Object = "{8C8CDC07-116C-11D4-9FBC-00104BD1D5F3}#1.0#0"; "AFBUTTON_INGOT.DLL"
Begin VB.Form Form1 
   BackColor       =   &H00ADC7AD&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   2400
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2400
   BeginProperty Font 
      Name            =   "AFPalm"
      Size            =   5.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   160
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   160
   StartUpPosition =   2  'CenterScreen
   Begin IngotButtonCtl.AFButton AFButton1 
      Height          =   315
      Left            =   840
      TabIndex        =   0
      Top             =   1620
      Width           =   1095
      Caption_CAT_1   =   "AFButton1"
      Enabled         =   -1  'True
      Alignment       =   2
      FontSize        =   5
      FontName        =   "AFPalm"
      ForeColor       =   3
      BackColor       =   0
      FontStyle       =   0
      Appearance      =   0
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

