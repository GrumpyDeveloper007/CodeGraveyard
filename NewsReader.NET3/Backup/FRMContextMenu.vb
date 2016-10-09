Option Strict Off
Option Explicit On
Friend Class FRMContextMenu
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' A holder form for the context menu used on the file list form (frmViewFiles)
	''
	'' Coded by Dale Pitman - PyroDesign
	
	Private vParent As System.Windows.Forms.Form
	
	Public ShowHandlingPopupMenu As Boolean
	
	Public vUseUnitCost As Boolean
	Public vDiscountIndex As Integer
	
	Public Sub SetParent(ByRef pform As System.Windows.Forms.Form)
		vParent = pform
	End Sub
	
	
	Private Sub FRMContextMenu_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Me.Hide()
	End Sub
	
	Public Sub mnuDownloadAutoHide_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuDownloadAutoHide.Click
		Call FRMViewFiles.HandleContextMenu((mnuDownloadFiles.Name))
		Call FRMViewFiles.HandleContextMenu((mnuMoveToAutoHide.Name))
	End Sub
	
	Public Sub mnuDownloadFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuDownloadFiles.Click
		Call FRMViewFiles.HandleContextMenu((mnuDownloadFiles.Name))
	End Sub
	
	Public Sub mnuDownloadFirst_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuDownloadFirst.Click
		Call FRMViewFiles.HandleContextMenu((mnuDownloadFirst.Name))
	End Sub
	
	Public Sub mnuHide_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuHide.Click
		Call FRMViewFiles.HandleContextMenu((mnuHide.Name))
	End Sub
	
	Public Sub mnuHide2Day_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuHide2Day.Click
		Call FRMViewFiles.HandleContextMenu((mnuHide2Day.Name))
	End Sub
	
	Public Sub mnuHideAll_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuHideAll.Click
		Call FRMViewFiles.HandleContextMenu((mnuHideAll.Name))
	End Sub
	
	Public Sub mnuMoveToAutoHide_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuMoveToAutoHide.Click
		Call FRMViewFiles.HandleContextMenu((mnuMoveToAutoHide.Name))
	End Sub
	
	Public Sub mnuPauseFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuPauseFiles.Click
		Call FRMViewFiles.HandleContextMenu((mnuPauseFiles.Name))
	End Sub
	
	Public Sub mnuRefresh_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles mnuRefresh.Click
		Call FRMViewFiles.HandleContextMenu((mnuRefresh.Name))
	End Sub
End Class