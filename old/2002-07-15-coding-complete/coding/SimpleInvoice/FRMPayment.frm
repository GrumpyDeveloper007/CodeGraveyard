VERSION 5.00
Object = "{68670FAD-7A98-11D5-910D-0080C845CEED}#7.0#0"; "txtbox.ocx"
Object = "{78F299EE-EF55-11D3-B834-009027603F96}#1.0#0"; "datecontrol.ocx"
Begin VB.Form FRMPayment 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Payment"
   ClientHeight    =   5985
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7380
   ControlBox      =   0   'False
   HelpContextID   =   10
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   5985
   ScaleWidth      =   7380
   Begin VB.ComboBox CBOAccount 
      Height          =   315
      Left            =   3720
      Style           =   2  'Dropdown List
      TabIndex        =   30
      Top             =   5100
      Width           =   3255
   End
   Begin VB.CommandButton CMDAddNew 
      Caption         =   "Add Payment"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDClear 
      Caption         =   "&Clear"
      Height          =   375
      Left            =   4800
      TabIndex        =   3
      Top             =   5580
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   6240
      TabIndex        =   4
      Top             =   5580
      Width           =   1095
   End
   Begin ELFTxtBox.TxtBox1 TXTInvoiceNumber 
      Height          =   285
      Left            =   2520
      TabIndex        =   0
      Top             =   0
      Width           =   1695
      _ExtentX        =   2990
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTName 
      Height          =   315
      Left            =   3600
      TabIndex        =   6
      Top             =   780
      Width           =   3135
      _ExtentX        =   5530
      _ExtentY        =   556
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet1 
      Height          =   285
      Left            =   2520
      TabIndex        =   7
      Top             =   1110
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTown 
      Height          =   285
      Left            =   2520
      TabIndex        =   8
      Top             =   1710
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCounty 
      Height          =   285
      Left            =   2520
      TabIndex        =   9
      Top             =   2010
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTStreet2 
      Height          =   285
      Left            =   2520
      TabIndex        =   10
      Top             =   1410
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPostcode 
      Height          =   285
      Left            =   2520
      TabIndex        =   11
      Top             =   2610
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCountry 
      Height          =   285
      Left            =   2520
      TabIndex        =   12
      Top             =   2310
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTCompanyName 
      Height          =   285
      Left            =   2520
      TabIndex        =   13
      Top             =   480
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTGoodsTotal 
      Height          =   285
      Left            =   2520
      TabIndex        =   18
      Top             =   3060
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTVatTotal 
      Height          =   285
      Left            =   2520
      TabIndex        =   19
      Top             =   3360
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTHandling 
      Height          =   285
      Left            =   2520
      TabIndex        =   20
      Top             =   3660
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTGrandTotal 
      Height          =   285
      Left            =   2520
      TabIndex        =   21
      Top             =   3960
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   0
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTAmountPaid 
      Height          =   285
      Left            =   2520
      TabIndex        =   1
      Top             =   5100
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTPreviousAmountPaid 
      Height          =   285
      Left            =   2520
      TabIndex        =   27
      Top             =   4380
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   503
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      NavigationMode  =   1
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFTxtBox.TxtBox1 TXTTitle 
      Height          =   315
      Left            =   2520
      TabIndex        =   29
      Top             =   780
      Width           =   975
      _ExtentX        =   1720
      _ExtentY        =   556
      BackColor       =   12632256
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Text            =   ""
      Mask            =   "xx"
      UpperCase       =   -1  'True
      AutoCase        =   -1  'True
      AutoSelect      =   -1  'True
   End
   Begin ELFDateControl.DateControl TXTPaymentDate 
      Height          =   615
      Left            =   5160
      TabIndex        =   31
      Top             =   2760
      Width           =   2055
      _ExtentX        =   3625
      _ExtentY        =   1085
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BackStyle       =   0
      Text            =   "__/__/____"
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Payment Date"
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
      Index           =   12
      Left            =   3840
      TabIndex        =   32
      Top             =   3090
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Previous Amount Paid"
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
      Index           =   7
      Left            =   240
      TabIndex        =   28
      Top             =   4410
      Width           =   2175
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Goods Total"
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
      Index           =   3
      Left            =   1200
      TabIndex        =   26
      Top             =   3090
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "VAT Total"
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
      Index           =   4
      Left            =   1200
      TabIndex        =   25
      Top             =   3390
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Handling/Carriage"
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
      Index           =   5
      Left            =   600
      TabIndex        =   24
      Top             =   3690
      Width           =   1815
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Grand Total"
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
      Index           =   6
      Left            =   1200
      TabIndex        =   23
      Top             =   3990
      Width           =   1215
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Amount Paid"
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
      Index           =   15
      Left            =   600
      TabIndex        =   22
      Top             =   5130
      Width           =   1815
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Post Code"
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
      Index           =   2
      Left            =   1440
      TabIndex        =   17
      Top             =   2640
      Width           =   975
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Address"
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
      Left            =   1680
      TabIndex        =   16
      Top             =   1140
      Width           =   735
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Contact Name"
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
      Left            =   1080
      TabIndex        =   15
      Top             =   810
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Company Name"
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
      Index           =   9
      Left            =   1080
      TabIndex        =   14
      Top             =   510
      Width           =   1335
   End
   Begin VB.Label LBLZ1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Invoice Number"
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
      Index           =   14
      Left            =   840
      TabIndex        =   5
      Top             =   30
      Width           =   1575
   End
End
Attribute VB_Name = "FRMPayment"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Payment Object
''
'' Coded by Dale Pitman

Private vUid As Long
'' Search criteria(Input Parameters)

Private vSale As New ClassSale
''
'Private vShiftStatus As Boolean ' True=down

''
Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

'' This property indicates if this form is currently visible
Public Function IsNotLoaded() As Boolean
    IsNotLoaded = Not vIsLoaded
End Function

'' General function to make currently active form visible (if a child is active then that form should be made visible),Hierarchical function
Public Sub SetFormFocus()
    If (Me.Enabled = False) Then
        Call vCurrentActiveChild.SetFormFocus
    Else
        Me.ZOrder
    End If
End Sub

'' A simple additional property to indicate form type
Public Property Get ChildType() As ChildTypesENUM
    ChildType = Payment
End Property

'' Used to attach this form to parent, for callback/context knowledge
Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub

'' Hierarchical function, used to clear all details within any sub-classes
Public Sub ResetForm()
    Call ClearDetails
End Sub

'' General 'call back' function for  any children of this form
Public Sub SendChildInactive()
    Me.Enabled = True
    Call AllFormsShow(Me)
    Call Me.ZOrder
End Sub

'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
Public Function Search(pInvoiceID As Long) As Boolean
    
    Screen.MousePointer = vbHourglass
    Call AllFormsShow(Me)
    Call Me.Show
    Me.Caption = "Payment [" & vParent.Caption & "]"
    vSale.Invoice.Uid = pInvoiceID
    Call LoadDetails
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' Copy details from customer class to screen (text boxes)
Private Sub ReadCustomerClass(pCustomerClass As ClassCustomer)
    If (Right(pCustomerClass.CompanyName, 1) = "²") Then
        TXTCompanyName.AutoCase = False
    Else
        TXTCompanyName.AutoCase = True
    End If
    
    TXTCompanyName.Text = AutoCase(pCustomerClass.CompanyName, True)
    
    TXTStreet1.Text = AutoCase(pCustomerClass.Street1, True)
    TXTStreet2.Text = AutoCase(pCustomerClass.Street2, True)
    TXTTown.Text = AutoCase(pCustomerClass.Town, True)
    TXTCounty.Text = AutoCase(pCustomerClass.County, True)
    TXTCountry.Text = AutoCase(pCustomerClass.Country, True)
    TXTTitle.Text = pCustomerClass.Title
    TXTName.Text = AutoCase(pCustomerClass.Name, True)
    TXTPostcode.Text = UCase$(pCustomerClass.postcode)
End Sub

''
Private Sub LoadDetails()
    If (vSale.Invoice.ReadRecord()) Then
        vSale.Invoiceid = vSale.Invoice.Uid
        Call vSale.ReadRecord
        If (vSale.Invoice.InvoiceCustomerID > 0) Then
            vSale.Customer.Uid = vSale.Invoice.InvoiceCustomerID
            Call vSale.Customer.ReadRecord(True)
        Else
            vSale.Customer.Uid = vSale.Customerid
            Call vSale.Customer.ReadRecord(False)
        End If
        
        TXTInvoiceNumber.Text = vSale.Invoice.InvoiceNumber

        Call ReadCustomerClass(vSale.Customer)
        
        TXTGoodsTotal.Text = FormatCurrency(vSale.Invoice.Goodstotal)
        TXTVatTotal.Text = FormatCurrency(vSale.Invoice.Vattotal)
        TXTHandling.Text = FormatCurrency(vSale.Invoice.Handlingtotal)
        TXTGrandTotal.Text = FormatCurrency(vSale.Invoice.Vattotal + vSale.Invoice.Goodstotal + vSale.Invoice.Handlingtotal)
        
        TXTPreviousAmountPaid.Text = FormatCurrency(vSale.Invoice.Amountpaid)
        
        TXTAmountPaid.Text = (vSale.Invoice.Vattotal + vSale.Invoice.Goodstotal + vSale.Invoice.Handlingtotal) - vSale.Invoice.Amountpaid
    
        CMDAddNew.Enabled = True
    End If
End Sub

'' reset all class details
Private Sub ClearDetails()
    Dim rstemp As Recordset
        
    vUid = -1
    TXTInvoiceNumber.Text = ""
    
    TXTCompanyName.Text = ""
    TXTStreet1.Text = ""
    TXTStreet2.Text = ""
    TXTTown.Text = ""
    TXTCounty.Text = ""
    TXTCountry.Text = ""
    TXTTitle.Text = ""
    TXTName.Text = ""
    TXTPostcode.Text = ""
    
    TXTGoodsTotal.Text = ""
    TXTVatTotal.Text = ""
    TXTHandling.Text = ""
    TXTGrandTotal.Text = ""
    
    TXTAmountPaid.Text = ""
    
    TXTPreviousAmountPaid.Text = ""

    Call vSale.Invoice.ClearDetails
    Call vSale.ClearDetails
    Call vSale.Customer.ClearDetails
    
    CMDAddNew.Enabled = False
'    vShiftStatus = False
End Sub

''
Private Sub SetupFieldSizes()
'    Dim rstemp As Recordset
'    Dim i As Long
'    If (OpenRecordset(rstemp, "Account", dbOpenTable)) Then
'        TXTProductName.MaxLength = GetFieldSize(rstemp, "name")
'        TXTDescription.MaxLength = GetFieldSize(rstemp, "description")
'    End If
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDAddNew_Click()
    Dim PaymentClass As New ClassPayment
    vSale.Invoice.Amountpaid = vSale.Invoice.Amountpaid + Val(TXTAmountPaid.Text)
    vSale.Invoice.Paymentdate = TXTPaymentDate.Text
    Call vSale.Invoice.WriteRecord
    
    PaymentClass.AccountID = CBOAccount.ItemData(CBOAccount.ListIndex)
    PaymentClass.Invoiceid = vSale.Invoice.Uid
    PaymentClass.Amountpaid = Val(TXTAmountPaid.Text)
    PaymentClass.Paymentdate = TXTPaymentDate.Text
    Call PaymentClass.CreateRecord
    Beep
    
    Call ClearDetails
    If (vParent Is Nothing) Then
    Else
        Call CMDExit_Click
    End If
End Sub

''
Private Sub CMDClear_Click()
    Call ClearDetails
End Sub

''
Private Sub CMDExit_Click()
    If (vParent Is Nothing) Then
        Call Unload(Me)
    Else
        Me.Visible = False
        Call vParent.SendChildInactive
    End If
    vIsLoaded = False
    Call AllFormsHide(Me)
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Call SetupFieldSizes
    Call ClearDetails
    
    Call LoadListCBO(CBOAccount, "Account", "Name", "UID", False, True)
    If (CBOAccount.ListCount > 2) Then
        CBOAccount.ListIndex = 1
    End If
    TXTPaymentDate.Text = Format(Now, "dd/mm/yyyy")
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub

''
Private Sub TXTAmountPaid_Change()
    If (Val(RemoveNonNumericCharacters(TXTAmountPaid.Text)) + Val(RemoveNonNumericCharacters(TXTPreviousAmountPaid.Text)) > Val(RemoveNonNumericCharacters(TXTGrandTotal.Text))) Then
        TXTAmountPaid.ForeColor = &HFF
    Else
        TXTAmountPaid.ForeColor = &H80000008
    End If
End Sub

''
Private Sub TXTInvoiceNumber_Validate(Cancel As Boolean)
    Dim InvoiceNumber As String
    If (TXTInvoiceNumber.Text <> "") Then
        ' find by invoice number
        InvoiceNumber = TXTInvoiceNumber.Text
        Call ClearDetails
        vSale.Invoice.InvoiceNumber = InvoiceNumber
        Call LoadDetails
    End If
End Sub
