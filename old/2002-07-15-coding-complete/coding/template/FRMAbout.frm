VERSION 5.00
Begin VB.Form FRMAbout 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "About Inspection"
   ClientHeight    =   3705
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6270
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   247
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   418
   Begin VB.CommandButton CMDExit 
      Caption         =   "E&xit"
      Height          =   375
      Left            =   5160
      TabIndex        =   0
      Top             =   3240
      Width           =   1095
   End
   Begin VB.Label LBLLicencedTo 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Licenced to <Company Name>"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   120
      TabIndex        =   7
      Top             =   480
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Tel: 01522 824169"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   2880
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "<System Name>"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   -1  'True
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   3
      Left            =   120
      TabIndex        =   5
      Top             =   120
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Web: www.pyrodesign.co.uk"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   2520
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Email: PyroDesign@ntlworld.com"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   1
      Left            =   120
      TabIndex        =   3
      Top             =   2160
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Copyright PyroDesign"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   6015
   End
   Begin VB.Label LBLZ1 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Written By Dale Pitman@PyroDesign"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   9
      Left            =   120
      TabIndex        =   1
      Top             =   1080
      Width           =   6015
   End
End
Attribute VB_Name = "FRMAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''*************************************************************************
'' <Sample> Object
''
'' Coded by Dale Pitman - PyroDesign

Private vUid As Long
'' Search criteria(Input Parameters)
Public vLicencedTo As String


'' Output parameters
'Private vPartid As Long ' *This is a sample parameter


''
'Private vShiftStatus As Boolean ' True=down

''
'Private vParent As Form                 ' The parent that this form belongs to
Private vCurrentActiveChild As Form     ' If this form has children, this is the currently/previously active one
Private vIsLoaded As Boolean

Private vDataChanged As Boolean

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
'    ChildType =
End Property

'' Used to attach this form to parent, for callback/context knowledge
'Public Sub SetParent(pform As Form)
'    Set vParent = pform
'End Sub

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
    
    Search = False
    Screen.MousePointer = vbDefault
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Update Property Procedures

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Local

'' reset all class details
Private Sub ClearDetails()
End Sub

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' Form objects

''
Private Sub CMDExit_Click()
'    Call vParent.SendChildInactive
    vIsLoaded = False
    Call Unload(Me)
    Call AllFormsHide(Me)
End Sub

'' Set forms location, as stored in registory
Private Sub Form_Load()
    vIsLoaded = True
    Call AllFormsLoad(Me)
    Call SetWindowPosition(Me)
    Me.LBLLicencedTo.Caption = "Linenced to " & vLicencedTo
'    Me.Caption = "<NAME HERE> [" & vParent.Caption & "]"
    vDataChanged = False
End Sub

'' Save forms location
Private Sub Form_Unload(Cancel As Integer)
    Call GetWindowPosition(Me)
    vIsLoaded = False
    Call AllFormsUnLoad(Me)
   
End Sub

