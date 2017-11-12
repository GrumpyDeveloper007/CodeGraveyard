VERSION 5.00
Begin VB.Form FConfigure 
   Caption         =   "Inspection Conduit (PyroDesign)"
   ClientHeight    =   4245
   ClientLeft      =   60
   ClientTop       =   405
   ClientWidth     =   5985
   LinkTopic       =   "Form1"
   ScaleHeight     =   4245
   ScaleWidth      =   5985
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkDefault 
      Caption         =   "Set as Default"
      Height          =   255
      Left            =   4260
      TabIndex        =   4
      Top             =   2700
      Width           =   1395
   End
   Begin VB.CommandButton btnCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   315
      Left            =   4800
      TabIndex        =   3
      Top             =   3900
      Width           =   1155
   End
   Begin VB.CommandButton btnOk 
      Caption         =   "Ok"
      Default         =   -1  'True
      Height          =   315
      Left            =   0
      TabIndex        =   2
      Top             =   3900
      Width           =   1155
   End
   Begin VB.Label lblRegistry 
      Caption         =   "Conduit Registry:"
      Height          =   255
      Left            =   165
      TabIndex        =   1
      Top             =   975
      Width           =   5775
   End
   Begin VB.Label lblDirectory 
      Caption         =   "Data Directory:"
      Height          =   255
      Left            =   165
      TabIndex        =   0
      Top             =   555
      Width           =   5775
   End
End
Attribute VB_Name = "FConfigure"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Inspection Form Conduit
''
'' Coded By Dale Pitman

Public pPath As String
Public pRegistry As String
Public nSyncType As Long
Public nSyncPref As Long

Public bCancel As Boolean

Private Sub Form_Load()
    '   Set up the labels
    lblDirectory.Caption = pPath
    lblRegistry = pRegistry
    
    '   Set the options
    
'    Select Case nSyncType
'    Case eHHtoPC
'        optHHToPC.Value = True
'    Case ePCtoHH
'        optPCToHH.Value = True
'    Case eDoNothing
'        optDoNothing.Value = True
'    Case Else
'        optSync.Value = True
'    End Select
    
    '   Make the changes temporary
    nSyncPref = eTemporaryPreference
    chkDefault.Value = Unchecked
    
    '   Set as canceled
    bCancel = True
End Sub

Private Sub btnOk_Click()
    '   Save the SyncType
'    If optSync.Value Then
'        nSyncType = eFast
'    ElseIf optPCToHH.Value Then
'        nSyncType = ePCtoHH
'    ElseIf optHHToPC.Value Then
'        nSyncType = eHHtoPC
'    ElseIf optDoNothing.Value Then
'        nSyncType = eDoNothing
'    End If
    
    '   Set the syncpref
    If chkDefault.Value = Checked Then
        nSyncPref = ePermanentPreference
    End If
    
    '   Values are good
    bCancel = False
    Unload Me
    
End Sub

Private Sub btnCancel_Click()
    '   Done
    Unload Me
End Sub

