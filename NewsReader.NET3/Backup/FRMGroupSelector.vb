Option Strict Off
Option Explicit On
Imports VB = Microsoft.VisualBasic
Friend Class FRMAddRemoveGroups
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' A configuration form, Groups, path for groups
	''
	'' Coded by Dale Pitman - PyroDesign
	
	Private m_GroupTypeID As Integer
	
	''
	'Private vParent As Form                 ' The parent that this form belongs to
	Private vCurrentActiveChild As System.Windows.Forms.Form ' If this form has children, this is the currently/previously active one
	Private vIsLoaded As Boolean
	
	Private vDataChanged As Boolean
	
	Private vIgnoreUpdate As Boolean
	
	'' This property indicates if this form is currently visible
	Public Function IsNotLoaded() As Boolean
		IsNotLoaded = Not vIsLoaded
	End Function
	
	'' General function to make currently active form visible (if a child is active then that form should be made visible),Hierarchical function
	Public Sub SetFormFocus()
		If (Me.Enabled = False) Then
			'UPGRADE_ISSUE: Control SetFormFocus could not be resolved because it was within the generic namespace Form. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="084D22AD-ECB1-400F-B4C7-418ECEC5E36E"'
			Call vCurrentActiveChild.SetFormFocus()
		Else
			'UPGRADE_WARNING: Form method FRMAddRemoveGroups.ZOrder has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
			Me.BringToFront()
		End If
	End Sub
	
	'' A simple additional property to indicate form type
	Public ReadOnly Property ChildType() As GlobalDeclarations.ChildTypesENUM
		Get
			'    ChildType =
		End Get
	End Property
	
	'' Hierarchical function, used to clear all details within any sub-classes
	Public Sub ResetForm()
		Call ClearDetails()
	End Sub
	
	'' General 'call back' function for  any children of this form
	Public Sub SendChildInactive()
		Me.Enabled = True
		Call AllFormsShow(Me)
		'UPGRADE_WARNING: Form method FRMAddRemoveGroups.ZOrder has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		Call Me.BringToFront()
	End Sub
	
	'' A 'Show' type function used to activate/trigger any functionality on a per-operation basis
	Public Function Search() As Boolean
		
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		Call AllFormsShow(Me)
		Me.Visible = True
		
		Search = False
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Function
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Update Property Procedures
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Local
	
	'' reset all class details
	Private Sub ClearDetails()
	End Sub
	
	''
	Private Sub SetupFieldSizes()
		
	End Sub
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Form objects
	
	''
	Private Sub CMDAddNew_Click()
	End Sub
	
	''
	Private Sub CMDClear_Click()
		Call ClearDetails()
	End Sub
	
	''
	Private Sub cmdDelete_Click()
	End Sub
	
	'UPGRADE_WARNING: Event CBOGroupType.SelectedIndexChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub CBOGroupType_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CBOGroupType.SelectedIndexChanged
		Dim rstemp As ADODB.Recordset
		
		If (OpenRecordset(rstemp, "SELECT * FROM [grouptype] WHERE uid=" & VB6.GetItemData(CBOGroupType, CBOGroupType.SelectedIndex), dbOpenSnapshot)) Then
			'm_SelectedFileTableName = rstemp!dbtablename & " "
			m_GroupTypeID = rstemp.Fields("UID").Value
		End If
	End Sub
	
	''
	Private Sub CMDExit_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDExit.Click
		'    Call vParent.SendChildInactive
		vIsLoaded = False
		Call Me.Close()
		Call AllFormsHide(Me)
		Call FRMMain.ChangeGroupType((MDIMain.CBOGroupType))
	End Sub
	
	Private Sub cmdSetDownloadPath_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdSetDownloadPath.Click
		Dim path As String
		Dim rstemp As ADODB.Recordset
		On Error GoTo fin
		
		Call OpenRecordset(rstemp, "SELECT * FROM grouptype WHERE uid=" & m_GroupTypeID, dbOpenSnapshot)
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.InitDir. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		MDIMain.CommonDialogControl.InitDir = rstemp.Fields("downloadpath").Value & ""
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.ShowSave. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		MDIMain.CommonDialogControl.ShowSave()
		'UPGRADE_WARNING: Couldn't resolve default property of object MDIMain.CommonDialogControl.FileName. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		path = VB.Left(MDIMain.CommonDialogControl.FileName, InStrRev(MDIMain.CommonDialogControl.FileName, "\"))
		If path <> "" Then
			Call Execute("UPDATE grouptype SET downloadpath=" & Chr(34) & path & Chr(34) & " WHERE UID =" & m_GroupTypeID)
		End If
fin: 
	End Sub
	
	'' Set forms location, as stored in registory
	Private Sub FRMAddRemoveGroups_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		vIsLoaded = True
		Call AllFormsLoad(Me)
		Call SetWindowPosition(Me)
		
		Dim rstemp As ADODB.Recordset
		CBOGroupType.Items.Clear()
		If (OpenRecordset(rstemp, "SELECT * FROM grouptype", dbOpenSnapshot)) Then
			Do While (rstemp.EOF = False)
				Call CBOGroupType.Items.Add(rstemp.Fields("Name").Value)
				VB6.SetItemData(CBOGroupType, CBOGroupType.Items.Count - 1, rstemp.Fields("UID").Value)
				Call rstemp.MoveNext()
			Loop 
			CBOGroupType.SelectedIndex = 0
		End If
		
		
		Call SetupFieldSizes()
		Call ClearDetails()
		vDataChanged = False
		
		' Load all groups
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		If (OpenRecordset(rstemp, "SELECT * FROM [GROUP] ", dbOpenSnapshot)) Then
			If rstemp.EOF = True Then
				Call MsgBox("There are no availible newsgroups, please select 'Get All Groups' from the menu and try again.", MsgBoxStyle.Exclamation)
			End If
		End If
		
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	'' Save forms location
	Private Sub FRMAddRemoveGroups_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
		Call GetWindowPosition(Me)
		vIsLoaded = False
		Call AllFormsUnLoad(Me)
		
	End Sub
	
	
	Private Sub GRDGroup_DblClick()
		If vIgnoreUpdate = False Then
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDGroup.Col = -1
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDGroup.row = GRDGroup.ListIndex
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDGroup.BackColor <> &HFF) Then
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDGroup.Col = 0
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ColText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE [group] SET grouptypeid=" & m_GroupTypeID & " WHERE uid=" & GRDGroup.ColText, True)
			Else
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDGroup.Col = 0
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ColText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE [group] SET grouptypeid=" & 0 & " WHERE uid=" & GRDGroup.ColText, True)
			End If
			Call TXTFilter_KeyPressEvent(TXTFilter, New AxELFTxtBox.__TxtBox1_KeyPressEvent(13))
		End If
	End Sub
	
	Private Sub GRDGroup_MouseDown(ByRef Button As Short, ByRef Shift As Short, ByRef X As Single, ByRef Y As Single)
		If Button = 2 Then
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDGroup.Col = -1
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDGroup.row = GRDGroup.ListIndex
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDGroup.BackColor <> &H7F) Then
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDGroup.Col = 0
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ColText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE [group] SET DownloadAlternate=True WHERE uid=" & GRDGroup.ColText, True)
			Else
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDGroup.Col = 0
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ColText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE [group] SET DownloadAlternate=False WHERE uid=" & GRDGroup.ColText, True)
			End If
			Call TXTFilter_KeyPressEvent(TXTFilter, New AxELFTxtBox.__TxtBox1_KeyPressEvent(13))
		End If
	End Sub
	
	Private Sub TXTFilter_KeyPressEvent(ByVal eventSender As System.Object, ByVal eventArgs As AxELFTxtBox.__TxtBox1_KeyPressEvent) Handles TXTFilter.KeyPressEvent
		Dim ListApplyToIndividual As Object
		Dim rstemp As ADODB.Recordset
		Dim sql As String
		Dim SaveIndex As Integer
		Dim SaveSelected As Integer
		
		vIgnoreUpdate = True
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		SaveIndex = GRDGroup.TopIndex
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		SaveSelected = GRDGroup.ListIndex
		
		'UPGRADE_NOTE: Text was upgraded to CtlText. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="A9E4979A-37FA-4718-9994-97DD76ED70A7"'
		sql = "SELECT * FROM [GROUP] WHERE groupname like " & Chr(34) & "%" & TXTFilter.CtlText & "%" & Chr(34)
		If (CHKBinaries.CheckState = System.Windows.Forms.CheckState.Checked) Then
			sql = sql & " AND groupname like '%binaries%'"
		End If
		sql = sql & " ORDER BY groupname"
		
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Clear. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		Call GRDGroup.Clear()
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		If (eventArgs.KeyAscii = 13) Then
			If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
				Do While (rstemp.EOF = False)
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.AddItem. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					Call GRDGroup.AddItem(rstemp.Fields("UID").Value & vbTab & rstemp.Fields("GroupName").Value)
					
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDGroup.ListApplyTo = ListApplyToIndividual
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDGroup.Col = -1
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDGroup.row = GRDGroup.ListCount - 1
					
					If (rstemp.Fields("GroupTypeID").Value = m_GroupTypeID) Then
						If rstemp.Fields("DownloadAlternate").Value = True Then
							'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							GRDGroup.BackColor = &H7F
						Else
							'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							GRDGroup.BackColor = &HFF
						End If
					End If
					
					'If (rstemp!DownloadedSuccessfully = True) Then
					'        GRDFile.BackColor = &HFF0000
					'Else
					'    If (rstemp!DownloadFile = True) Then
					'        GRDFile.BackColor = &HFFFF&
					'    End If
					'End If
					
					
					Call rstemp.MoveNext()
				Loop 
			End If
		End If
		
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		GRDGroup.TopIndex = SaveIndex
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDGroup.ListIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		GRDGroup.ListIndex = SaveSelected
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
		vIgnoreUpdate = False
	End Sub
End Class