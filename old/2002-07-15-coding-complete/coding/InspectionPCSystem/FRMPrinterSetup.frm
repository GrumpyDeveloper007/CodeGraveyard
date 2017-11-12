VERSION 5.00
Begin VB.Form FRMPrinterSetup 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Printer Setup"
   ClientHeight    =   3030
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5670
   HelpContextID   =   3
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3030
   ScaleWidth      =   5670
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   2640
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   4560
      TabIndex        =   4
      Top             =   2640
      Width           =   1095
   End
   Begin VB.ComboBox CBOReportPrinter 
      Height          =   315
      Left            =   3120
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   660
      Width           =   2415
   End
   Begin VB.ComboBox CBOInvoicePrinter 
      Height          =   315
      Left            =   3120
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   300
      Width           =   2415
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Report Printer"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   1
      Left            =   1440
      TabIndex        =   3
      Top             =   720
      Width           =   1575
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Invoice Printer"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   1200
      TabIndex        =   1
      Top             =   360
      Width           =   1815
   End
End
Attribute VB_Name = "FRMPrinterSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Printer Setup Object
''
'' Coded by Dale Pitman (11-04-01)

Private vIsLoaded As Boolean

''
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

''
Public Sub SetFormFocus()
    Me.ZOrder
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form Objects

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

Private Sub CMDOK_Click()
    Call SetWorkstationSetting("INVOICEPRINTER", CBOInvoicePrinter.Text)
    Call SetWorkstationSetting("REPORTPRINTER", CBOReportPrinter.Text)
End Sub

''
Private Sub Form_Load()
    Dim P As Printer
    
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)


    Call CBOInvoicePrinter.AddItem("")
    For Each P In Printers
        Call CBOInvoicePrinter.AddItem(P.DeviceName)
    Next
    Call CopyCBOCBO(CBOInvoicePrinter, CBOReportPrinter)
    Call SetByItemCBO(CBOInvoicePrinter, GetWorkstationSetting("INVOICEPRINTER"))
    Call SetByItemCBO(CBOReportPrinter, GetWorkstationSetting("REPORTPRINTER"))
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

