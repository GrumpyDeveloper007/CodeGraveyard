VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private obj1 As VBTESTLib.VBTest1
Private obj2 As VBTESTLib.VBTest2
Private itf_derived As VBTESTLib.IDerived
Private itf_base As VBTESTLib.IBase

Private Sub Form_Load()
    Set obj1 = New VBTESTLib.VBTest1
    Set obj2 = New VBTESTLib.VBTest2
    
    Set itf_base = obj2
    Set itf_derived = obj2
    
    ItsATest obj1
    ItsATest obj2

On Error GoTo err_VBTest1_Doesnt_Implement_IDerived
    ItsAnotherTest obj1
On Error GoTo 0

    ItsAnotherTest obj2
    Exit Sub
    
''''''''''''''''''''''''''''''''''''''
err_VBTest1_Doesnt_Implement_IDerived:
    MsgBox "This shows how we can handle QI errors in VB" & vbCrLf _
    & Err.Description
    Resume Next
End Sub

Private Sub ItsATest(base As VBTESTLib.IBase)
    base.MethodBase
End Sub

Private Sub ItsAnotherTest(derived As VBTESTLib.IDerived)
    derived.MethodDerived
End Sub

