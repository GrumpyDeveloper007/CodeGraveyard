VERSION 5.00
Object = "{0BA686C6-F7D3-101A-993E-0000C0EF6F5E}#1.0#0"; "THREED32.OCX"
Begin VB.Form FRMPrinterSetup 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Printer Setup"
   ClientHeight    =   3030
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5670
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   3030
   ScaleWidth      =   5670
   Begin VB.ComboBox CBOInvoicePrinter 
      Height          =   315
      Left            =   3120
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   300
      Width           =   2415
   End
   Begin Threed.SSCommand CMDExit 
      Height          =   375
      Left            =   4560
      TabIndex        =   0
      Top             =   2640
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "E&xit"
      ForeColor       =   255
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
   End
   Begin Threed.SSCommand CMDCommit 
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   2640
      Width           =   1095
      _Version        =   65536
      _ExtentX        =   1931
      _ExtentY        =   661
      _StockProps     =   78
      Caption         =   "Commit"
      ForeColor       =   16711680
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Font3D          =   3
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
      Left            =   120
      TabIndex        =   3
      Top             =   360
      Width           =   2895
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
Private Sub CBOreportname_Click()
End Sub

''
Private Sub CMDCommit_Click()
    Call SetWorkstationSetting("INVOICEPRINTER", CBOInvoicePrinter.Text)
End Sub

''
Private Sub CMDExit_Click()
    Call Unload(Me)
End Sub

''
Private Sub cmdPrint_Click()
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
    Call SetByItemCBO(CBOInvoicePrinter, GetWorkstationSetting("INVOICEPRINTER"))
End Sub

''
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

