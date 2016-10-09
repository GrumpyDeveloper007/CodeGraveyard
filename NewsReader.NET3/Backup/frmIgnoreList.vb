Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class frmIgnoreList
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' A configuration form, Add/delete search paths when looking for existing pictures
	''
	'' Coded by Dale Pitman - PyroDesign
	
	
	Private Sub cmdAdd_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdAdd.Click
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		Call Execute("INSERT INTO IgnorePaths (path) VALUES (" & FilterString(txtPath.CtlText) & " )", True)
		Call RefreshList()
	End Sub
	
	Private Sub cmdDelete_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdDelete.Click
		Call Execute("DELETE FROM IgnorePaths WHERE UID=" & VB6.GetItemData(lstIgnore, lstIgnore.SelectedIndex), True)
		Call RefreshList()
	End Sub
	
	Private Sub cmdTempPath_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdTempPath.Click
		Dim path As String
		On Error GoTo fin
		
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		MDIMain.CommonDialogControl.InitDir = txtPath.CtlText
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowSave. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		MDIMain.CommonDialogControl.ShowSave()
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		path = VB.Left(MDIMain.CommonDialogControl.FileName, InStrRev(MDIMain.CommonDialogControl.FileName, "\"))
		If path <> "" Then
			'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
			txtPath.CtlText = path
		End If
fin: 
	End Sub
	
	Private Sub RefreshList()
		Dim rstemp As ADODB.Recordset
		
		If (OpenRecordset(rstemp, "SELECT * FROM IgnorePaths", dbOpenSnapshot)) Then
			Do While rstemp.EOF = False
				Call lstIgnore.Items.Add(rstemp.Fields("path").Value)
				VB6.SetItemData(lstIgnore, lstIgnore.Items.Count - 1, rstemp.Fields("UID").Value)
				
				rstemp.MoveNext()
			Loop 
			
		Else
		End If
		cmdDelete.Enabled = False
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtPath.CtlText = ""
	End Sub
	
	Private Sub frmIgnoreList_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Call RefreshList()
	End Sub
	
	Private Sub frmIgnoreList_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
		Call FRMMain.GetIgnorePaths()
	End Sub
	
	'UPGRADE_WARNING: Event lstIgnore.SelectedIndexChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub lstIgnore_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles lstIgnore.SelectedIndexChanged
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		txtPath.CtlText = VB6.GetItemString(lstIgnore, lstIgnore.SelectedIndex)
		cmdDelete.Enabled = True
	End Sub
End Class