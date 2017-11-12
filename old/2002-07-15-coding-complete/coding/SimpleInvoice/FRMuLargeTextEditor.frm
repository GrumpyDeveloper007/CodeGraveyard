VERSION 5.00
Begin VB.Form FRMuLargeTextEditor 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "<Name Here>"
   ClientHeight    =   6150
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5685
   ControlBox      =   0   'False
   HelpContextID   =   29
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   6150
   ScaleWidth      =   5685
   Begin VB.CommandButton CMDOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   5760
      Width           =   1095
   End
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   4560
      TabIndex        =   1
      Top             =   5760
      Width           =   1095
   End
   Begin VB.TextBox TXTText 
      Height          =   5595
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   0
      Width           =   5655
   End
End
Attribute VB_Name = "FRMuLargeTextEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' Large Text Editor Class
''
'' Coded by Dale Pitman

'' Search criteria(Input Parameters)

'' Output parameters
Private vText As String ' *This is a sample parameter
Private vFontName As String
Private vFontSize As Double

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
    ChildType = TextEditor
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
Public Function Search() As Boolean
    
    Screen.MousePointer = vbHourglass
    Call AllFormsShow(Me)
    Me.Visible = True
    TXTText.FontName = vFontName
    TXTText.FontSize = vFontSize
    
        
    Search = True
    TXTText.Text = vText
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

'' *Sample property
Public Property Let Text(pText As String)
    vText = pText
End Property
Public Property Get Text() As String
    Text = vText
End Property

Public Property Let TextFontName(pFontName As String)
    vFontName = pFontName
End Property
Public Property Get TextFontName() As String
    FontName = vFontName
End Property

Public Property Let TextFontSize(pFontSize As Double)
    vFontSize = pFontSize
End Property
Public Property Get TextFontSize() As Double
    FontSize = vFontSize
End Property

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
'    vShiftStatus = False
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDExit_Click()
    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
End Sub

''
Private Sub CMDOK_Click()
    vIsLoaded = False
    Call Me.Hide
    Call AllFormsHide(Me)
    vText = TXTText.Text
    Call vParent.SendChildInactive
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Me.Caption = "Large Text Editor [" & vParent.Caption & "]"
    Call ClearDetails
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
End Sub
