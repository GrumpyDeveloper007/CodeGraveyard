VERSION 5.00
Begin VB.Form FRMContextMenu 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   900
   ClientLeft      =   15
   ClientTop       =   300
   ClientWidth     =   4830
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   900
   ScaleWidth      =   4830
   Visible         =   0   'False
   WindowState     =   1  'Minimized
   Begin VB.Menu MNUHandlingMenu 
      Caption         =   "Handling Menu"
      Begin VB.Menu MNUHandlingItem 
         Caption         =   "Test"
         Index           =   0
      End
   End
   Begin VB.Menu MNUDiscountMenu 
      Caption         =   "Discount Menu"
      Begin VB.Menu MNUDiscountItem 
         Caption         =   "5%"
         Index           =   0
      End
      Begin VB.Menu MNUDiscountItem 
         Caption         =   "Other"
         Index           =   1
      End
   End
End
Attribute VB_Name = "FRMContextMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private vParent As Form

Public ShowHandlingPopupMenu As Boolean

Public vUseUnitCost As Boolean
Public vDiscountIndex As Long

Public Sub SetParent(pform As Form)
    Set vParent = pform
End Sub


Private Sub Form_Load()
    MNUDiscountItem(0).Tag = 5
    MNUDiscountItem(1).Tag = -1
End Sub

Private Sub MNUDiscountItem_Click(Index As Integer)
    Dim float As Double
    Dim num As String
    If (vUseUnitCost = True) Then
        float = Val(RemoveNonNumericCharacters(FRMInvoice.TXTUnitCost(vDiscountIndex).Text))
    Else
        float = Val(RemoveNonNumericCharacters(FRMInvoice.TXTNetAmount(vDiscountIndex).Text))
    End If
    If (MNUDiscountItem(Index).Tag > 0) Then
        float = float / 100 * (100 - Val(MNUDiscountItem(Index).Tag))
    Else
        float = float / 100 * (100 - Val(InputBox("Input Discount")))
        ' other, ask user
    End If
    If (vUseUnitCost = True) Then
        FRMInvoice.TXTUnitCost(vDiscountIndex).Text = Val(float)
    Else
        FRMInvoice.TXTNetAmount(vDiscountIndex).Text = Val(float)
    End If
End Sub

Private Sub MNUHandlingItem_Click(Index As Integer)
    FRMInvoice.TXTHandling.Text = FormatCurrency(MNUHandlingItem(Index).Tag)
End Sub
