Option Strict Off
Option Explicit On
Friend Class FRMViewFiles
	Inherits System.Windows.Forms.Form
	''*************************************************************************
	'' Shows available files in a group type
	''
	'' Coded by Dale Pitman - PyroDesign
	
	Private m_GroupTypeID As Integer
	Private m_Mp3StyleFileNameProcessing As Boolean
	
	Private m_PragmaticChange As Boolean
	
	''
	Private vCurrentActiveChild As System.Windows.Forms.Form ' If this form has children, this is the currently/previously active one
	Private vIsLoaded As Boolean
	
	Private vDataChanged As Boolean
	
	Private m_ShiftPressed As Boolean
	
	Private m_ListByArticle As Boolean
	
	Private Structure HiddedIDTYPE
		Dim GridID As Integer
		Dim UID As Integer
	End Structure
	
	Private m_HiddenID(8000) As HiddedIDTYPE
	Private m_HiddenIDMax As Integer
	
	Public Sub RefreshGroupID(ByRef pGroupID As Integer)
		m_GroupTypeID = FRMMain.m_GroupTypeID
		If (m_GroupTypeID = 2) Then
			m_Mp3StyleFileNameProcessing = True
		Else
			m_Mp3StyleFileNameProcessing = False
		End If
		If vIsLoaded = True Then
			Call CMDShowAllFiles_Click(CMDShowAllFiles, New System.EventArgs())
		End If
	End Sub
	
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
			'UPGRADE_WARNING: Form method FRMViewFiles.ZOrder has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
			Me.BringToFront()
		End If
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
	
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'' Form objects
	
	'UPGRADE_WARNING: Event CBOOrderBy.SelectedIndexChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub CBOOrderBy_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CBOOrderBy.SelectedIndexChanged
		If (m_PragmaticChange = False) Then
			Call CMDShowAllFiles_Click(CMDShowAllFiles, New System.EventArgs())
		End If
	End Sub
	
	'UPGRADE_WARNING: Event CBOShowMethod.SelectedIndexChanged may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub CBOShowMethod_SelectedIndexChanged(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CBOShowMethod.SelectedIndexChanged
		If (m_PragmaticChange = False) Then
			Call CMDShowAllFiles_Click(CMDShowAllFiles, New System.EventArgs())
		End If
	End Sub
	
	Private Sub CMDDownloadFiles_Click()
		Dim ListApplyToIndividual As Object
		Dim i As Integer
		Dim t As Integer
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		For i = 0 To GRDFile.ListCount - 1
			If (i Mod 50 = 0) Then
				System.Windows.Forms.Application.DoEvents()
			End If
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = 0
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.row = i
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Selected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDFile.Selected(i) = True) Then
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE  File SET downloadfile=not downloadfile WHERE uid=" & GRDFile.ColList, True)
				If (m_ListByArticle = True) Then
				Else
					' Update all files attach to this grid row
					For t = 0 To m_HiddenIDMax - 1
						'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
						If (m_HiddenID(t).GridID = GRDFile.row) Then
							Call Execute("UPDATE  File SET downloadfile=not downloadfile WHERE uid=" & m_HiddenID(t).UID, False)
						End If
					Next 
					
				End If
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.ListApplyTo = ListApplyToIndividual
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.Col = -1
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				If (GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICFileInQueue.BackColor)) Then
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDFile.BackColor = &HFFFFFF
				Else
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICFileInQueue.BackColor)
				End If
			End If
			
		Next 
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Private Sub CMDDownloadFirst_Click()
		Dim ListApplyToIndividual As Object
		Dim i As Integer
		Dim t As Integer
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		For i = 0 To GRDFile.ListCount - 1
			If (i Mod 50 = 0) Then
				System.Windows.Forms.Application.DoEvents()
			End If
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = 0
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.row = i
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Selected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDFile.Selected(i) = True) Then
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE File SET postdate=#01/01/2003# WHERE uid=" & GRDFile.ColList, False)
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.ListApplyTo = ListApplyToIndividual
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.Col = -1
			End If
			
		Next 
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
		
	End Sub
	
	''
	Private Sub CMDExit_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDExit.Click
		vIsLoaded = False
		Call Me.Close()
		Call AllFormsHide(Me)
	End Sub
	
	Private Sub CMDHideAll_Click()
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		Call Execute("UPDATE  File SET hide=true WHERE grouptypeid=" & m_GroupTypeID, False)
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Private Sub CMDHideFiles_Click()
		Dim ListApplyToIndividual As Object
		Dim i As Integer
		Dim t As Integer
		Dim SelectedCount As Integer
		Dim SelectedLowest As Integer
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		SelectedCount = 0
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		SelectedLowest = GRDFile.ListCount
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		For i = GRDFile.ListCount - 1 To 0 Step -1
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = 0
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.row = i
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Selected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDFile.Selected(i) = True) Then
				If (i < SelectedLowest) Then
					SelectedLowest = i
				End If
				SelectedCount = SelectedCount + 1
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE  File SET hide=true WHERE uid=" & GRDFile.ColList, False)
				System.Windows.Forms.Application.DoEvents()
				If (m_ListByArticle = True) Then
					
				Else
					' Update all files attach to this grid row
					For t = 0 To m_HiddenIDMax - 1
						'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
						If (m_HiddenID(t).GridID = GRDFile.row) Then
							Call Execute("UPDATE  File SET hide=true WHERE uid=" & m_HiddenID(t).UID, False)
						End If
					Next 
					
				End If
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.RemoveItem. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call GRDFile.RemoveItem(i)
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.ListApplyTo = ListApplyToIndividual
			End If
			
		Next 
		
		Dim toprowsave As Integer
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		toprowsave = GRDFile.TopIndex
		
		If toprowsave > SelectedLowest Then
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.TopIndex = toprowsave - SelectedCount
		Else
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.TopIndex = toprowsave
		End If
		
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Private Sub CMDHideOlderThan1Day_Click()
		Dim sql As String
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		sql = "UPDATE  File SET hide=true WHERE grouptypeid=" & m_GroupTypeID
		sql = sql & " AND PostDate<#" & VB6.Format(DateAdd(Microsoft.VisualBasic.DateInterval.Day, -1, Now), "mm/dd/yyyy") & "#"
		sql = sql & " AND PostDate>=#01/01/1900#"
		Call Execute(sql, True)
		
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Private Sub CMDMoveToAutohide_Click()
		Dim ListApplyToIndividual As Object
		Dim i As Integer
		Dim t As Integer
		Dim rstemp As ADODB.Recordset
		Dim clsArticleProcessor As New cArticleProcessing
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		For i = 0 To GRDFile.ListCount - 1
			If (i Mod 50 = 0) Then
				System.Windows.Forms.Application.DoEvents()
			End If
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = 2
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.row = i
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Selected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDFile.Selected(i) = True) Then
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				If (OpenRecordset(rstemp, "SELECT * FROM AutoHide WHERE Filename='" & clsArticleProcessor.GetFileNameWithNoExtenstion(GRDFile.ColList) & "'", dbOpenDynaset)) Then
					If (rstemp.EOF = True) Then
						Call rstemp.AddNew()
					End If
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					rstemp.Fields("FileName").Value = clsArticleProcessor.GetFileNameWithNoExtenstion(GRDFile.ColList)
					
					Call rstemp.Update()
				End If
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.ListApplyTo = ListApplyToIndividual
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.Col = -1
			End If
			
		Next 
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
	End Sub
	
	Private Sub CMDPause_Click()
		Dim ListApplyToIndividual As Object
		Dim i As Integer
		Dim t As Integer
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		For i = 0 To GRDFile.ListCount - 1
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = 0
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.row = i
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Selected. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			If (GRDFile.Selected(i) = True) Then
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ColList. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call Execute("UPDATE  File SET pausefile=not pausefile WHERE uid=" & GRDFile.ColList, False)
				If (m_ListByArticle = True) Then
				Else
					' Update all files attach to this grid row
					For t = 0 To m_HiddenIDMax - 1
						'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
						If (m_HiddenID(t).GridID = GRDFile.row) Then
							Call Execute("UPDATE  File SET pausefile=not pausefile WHERE uid=" & m_HiddenID(t).UID, False)
						End If
					Next 
					
				End If
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.ListApplyTo = ListApplyToIndividual
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.Col = -1
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				If (GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICPaused.BackColor)) Then
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICFileInQueue.BackColor)
				Else
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICPaused.BackColor)
				End If
			End If
			
		Next 
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
		
	End Sub
	
	Private Sub CMDShowAllFiles_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles CMDShowAllFiles.Click
		Dim ListApplyToIndividual As Object
		Dim rstemp As ADODB.Recordset
		Dim FileName As String
		Dim toprowsave As Integer
		Dim sql As String
		Dim HideSQL As String
		Dim RecordCount As Integer
		Dim ArticleName As String
		Dim StartTime As Date
		Dim FilePath As String
		Dim FileName2 As String
		Dim foundcover As Boolean
		
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		toprowsave = GRDFile.TopIndex
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
		m_ListByArticle = True
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Clear. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		Call GRDFile.Clear()
		If (CHKShowAll.CheckState = System.Windows.Forms.CheckState.Checked Or CBOShowMethod.SelectedIndex = 2) Then
			HideSQL = " "
		Else
			HideSQL = "HIDE=False AND "
		End If
		
		Select Case CBOShowMethod.SelectedIndex
			Case 0 ' Default
				If (m_GroupTypeID = 2 Or m_GroupTypeID = 3) Then
					sql = "SELECT * FROM  File WHERE " & HideSQL & "GroupTypeID=" & m_GroupTypeID
				Else
					If (m_GroupTypeID = -1) Then
						sql = "SELECT * FROM  File WHERE " & HideSQL & " true=true"
					Else
						sql = "SELECT * FROM  File WHERE " & HideSQL & "GroupTypeID=" & m_GroupTypeID
					End If
				End If
			Case 1 'Downloading (order by queue)
				If (m_GroupTypeID = -1) Then
					sql = "SELECT * FROM  File WHERE " & HideSQL & "DownloadFile=True "
				Else
					sql = "SELECT * FROM  File WHERE " & HideSQL & "GroupTypeID=" & m_GroupTypeID & " AND DownloadFile=True "
				End If
			Case 2 'Verified Downloading
				If (m_GroupTypeID = -1) Then
					sql = "SELECT * FROM  File WHERE " & HideSQL & "DownloadFile=True AND DownloadedSuccessfully =False "
				Else
					sql = "SELECT * FROM  File WHERE " & HideSQL & "GroupTypeID=" & m_GroupTypeID & " AND DownloadFile=True AND DownloadedSuccessfully =False "
				End If
			Case 3 ' 2010
				sql = "SELECT * FROM  File WHERE (name like '%2011%' or filename like '%2011%' or name like '%2010%' or filename like '%2010%') AND " & HideSQL & "GroupTypeID=" & m_GroupTypeID
			Case 4 ' 2007
				sql = "SELECT * FROM  File WHERE (name like '%2012%' or filename like '%2012%' or name like '%2011%' or filename like '%2011%') AND " & HideSQL & "GroupTypeID=" & m_GroupTypeID
			Case 5 ' 2007
				sql = "SELECT * FROM  File WHERE (name like '%3D%' or filename like '%3D%') AND " & HideSQL & "GroupTypeID=" & m_GroupTypeID
				
			Case Else
		End Select
		
		Select Case CBOOrderBy.SelectedIndex
			Case 0 'File Name
				sql = sql & " ORDER BY Filename"
			Case 1 'Post Date
				sql = sql & " ORDER BY postdate"
			Case 2 'Subject
				sql = sql & " ORDER BY name,filename"
			Case 3 'file type
				sql = sql & " ORDER BY right(filename,3)"
		End Select
		
		StartTime = Now
		
		If (OpenRecordset(rstemp, sql, dbOpenSnapshot)) Then
			
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListApplyTo. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object ListApplyToIndividual. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.ListApplyTo = ListApplyToIndividual
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Col. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Col = -1
			StartTime = Now
			
			Do While (rstemp.EOF = False)
				
				RecordCount = RecordCount + 1
				ArticleName = rstemp.Fields("Name").Value
				FileName = rstemp.Fields("FileName").Value
				If (rstemp.Fields("IMDBName").Value <> "") Then
					ArticleName = rstemp.Fields("IMDBName").Value & ":" & ArticleName
				End If
				FilePath = FRMMain.GetTargetFilePath(FileName, ArticleName, True)
				
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.AddItem. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				Call GRDFile.AddItem(rstemp.Fields("UID").Value & vbTab & "1" & vbTab & FileName & vbTab & ArticleName & vbTab & FilePath & vbTab & rstemp.Fields("TotalArticles").Value & vbTab & rstemp.Fields("currentarticles").Value & vbTab & VB6.Format(rstemp.Fields("PostDate").Value, "hh:mm dd/mm/yyyy"))
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.row. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.ListCount. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
				GRDFile.row = GRDFile.ListCount - 1
				
				foundcover = False
				'If UCase$(Right$(FileName, 4)) = ".JPG" Then
				'    If CheckJPGExists(FileName, ArticleName) = True Then
				'        foundcover = True
				'    End If
				'End If
				FileName2 = FRMOptions.JPGPath & FileName
				FileName = FilePath & FileName
				
				If CBOShowMethod.SelectedIndex = 2 Then
					On Error Resume Next
					'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
					foundcover = Dir(FileName2, FileAttribute.Normal) <> ""
				End If
				
				' Verify if target file exists
				On Error Resume Next
				'UPGRADE_WARNING: Dir has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="9B7D5ADD-D8FE-4819-A36C-6DEDAF088CC7"'
				If (Dir(FileName, FileAttribute.Normal) <> "" Or foundcover = True) Then
					'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
					GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICFileExists.BackColor)
				Else
					If (rstemp.Fields("PauseFile").Value = True) Then
						'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
						GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICPaused.BackColor)
					Else
						'default
						If (rstemp.Fields("TotalArticles").Value > rstemp.Fields("currentarticles").Value) Then
							'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICIncompleteFile.BackColor)
						End If
						
						If (rstemp.Fields("downloading").Value = True) Then
							'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
							GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICDownloading.BackColor)
						Else
							If (rstemp.Fields("DownloadedSuccessfully").Value = True) Then
								'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
								GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICDownloadComplete.BackColor)
							Else
								If (rstemp.Fields("DownloadFile").Value = True) Then
									'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.BackColor. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
									GRDFile.BackColor = System.Drawing.ColorTranslator.ToOle(PICFileInQueue.BackColor)
								End If
							End If
						End If
						
						
					End If
				End If
				On Error GoTo 0
				Call rstemp.MoveNext()
			Loop 
		End If
		LBLRecordCount.Text = CStr(RecordCount)
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.TopIndex. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		GRDFile.TopIndex = toprowsave
		'UPGRADE_WARNING: Screen property Screen.MousePointer has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
		System.Windows.Forms.Cursor.Current = System.Windows.Forms.Cursors.Default
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.SetFocus. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		GRDFile.SetFocus()
	End Sub
	
	'' Set forms location, as stored in registory
	Private Sub FRMViewFiles_Load(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Load
		Dim FileName As String
		vIsLoaded = True
		Call AllFormsLoad(Me)
		Call SetWindowPosition(Me)
		
		m_GroupTypeID = FRMMain.m_GroupTypeID
		If (m_GroupTypeID = 2) Then
			m_Mp3StyleFileNameProcessing = True
		Else
			m_Mp3StyleFileNameProcessing = False
		End If
		
		m_PragmaticChange = True
		Call CBOShowMethod.Items.Add("Default")
		Call CBOShowMethod.Items.Add("Downloaded")
		Call CBOShowMethod.Items.Add("Downloading")
		Call CBOShowMethod.Items.Add("2010")
		Call CBOShowMethod.Items.Add("Latest")
		Call CBOShowMethod.Items.Add("3D")
		CBOShowMethod.SelectedIndex = 2
		
		Call CBOOrderBy.Items.Add("File Name")
		Call CBOOrderBy.Items.Add("Post Date")
		Call CBOOrderBy.Items.Add("Subject")
		Call CBOOrderBy.Items.Add("File Type")
		If (m_GroupTypeID = 2) Then
			CBOOrderBy.SelectedIndex = 2
		Else
			CBOOrderBy.SelectedIndex = 0
		End If
		m_PragmaticChange = False
		Me.Show()
		Call CMDShowAllFiles_Click(CMDShowAllFiles, New System.EventArgs())
		
		vDataChanged = False
	End Sub
	
	''
	Private Function ProcessArticleName(ByRef pString As String) As String
		Dim tempstring As String
		Dim BytePos As Integer
		Dim NumberPos As Integer
		Dim NumberOfBytes As String
		tempstring = Replace(pString, "AS REQ", "", 1, 1, CompareMethod.Text)
		tempstring = Replace(tempstring, "YENC", "", 1, 1, CompareMethod.Text)
		tempstring = Replace(tempstring, "MY REQ", "", 1, 1, CompareMethod.Text)
		BytePos = InStr(1, tempstring, "bytes", CompareMethod.Text)
		If (BytePos > 0) Then
			If (Mid(tempstring, BytePos - 1, 1) = " ") Then
				NumberPos = InStrRev(tempstring, " ", BytePos - 2)
				If (NumberPos > 0) Then
					NumberOfBytes = Mid(tempstring, NumberPos + 1, BytePos - NumberPos - 2)
					tempstring = Replace(tempstring, " " & NumberOfBytes & " " & "BYTES", "", 1, 1, CompareMethod.Text)
					
				End If
			End If
			
		End If
		
		ProcessArticleName = tempstring
	End Function
	
	'UPGRADE_WARNING: Event FRMViewFiles.Resize may fire when form is initialized. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="88B12AE1-6DE0-48A0-86F1-60C0686C026A"'
	Private Sub FRMViewFiles_Resize(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles MyBase.Resize
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Left. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		If Me.ClientRectangle.Width > GRDFile.Left + 2 Then
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Width. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Left. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Width = Me.ClientRectangle.Width - GRDFile.Left - 2
		End If
		'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Top. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
		If Me.ClientRectangle.Height > GRDFile.Top + 2 Then
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Height. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			'UPGRADE_WARNING: Couldn't resolve default property of object GRDFile.Top. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
			GRDFile.Height = Me.ClientRectangle.Height - GRDFile.Top - 2
		End If
	End Sub
	
	'' Save forms location
	Private Sub FRMViewFiles_FormClosed(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
		Call GetWindowPosition(Me)
		vIsLoaded = False
		Call AllFormsUnLoad(Me)
	End Sub
	
	Private Sub GRDFile_DblClick()
		Call CMDDownloadFiles_Click()
	End Sub
	
	Private Sub GRDFile_KeyDown(ByRef KeyCode As Short, ByRef Shift As Short)
		If (KeyCode = 16) Then
			m_ShiftPressed = True
		End If
	End Sub
	
	Private Sub GRDFile_KeyUp(ByRef KeyCode As Short, ByRef Shift As Short)
		If (KeyCode = 16) Then
			m_ShiftPressed = False
		End If
	End Sub
	
	Private Sub GRDFile_MouseDown(ByRef Button As Short, ByRef Shift As Short, ByRef X As Single, ByRef Y As Single)
		If Button = 2 Then
			'UPGRADE_ISSUE: Form method FRMViewFiles.PopupMenu was not upgraded. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="CC4C7EC0-C903-48FC-ACCC-81861D12DA4A"'
			Call Me.PopupMenu(FRMContextMenu.mnuFilesMenu)
		End If
	End Sub
	
	'' Calls the code for a given context menu
	Public Sub HandleContextMenu(ByRef pName As String)
		Select Case pName
			Case "mnuDownloadFiles"
				Call CMDDownloadFiles_Click()
			Case "mnuHide"
				Call CMDHideFiles_Click()
			Case "mnuHideAll"
				Call CMDHideAll_Click()
			Case "mnuDownloadFirst"
				Call CMDDownloadFirst_Click()
			Case "mnuPauseFiles"
				Call CMDPause_Click()
			Case "mnuMoveToAutoHide"
				Call CMDMoveToAutohide_Click()
			Case "mnuHide2Day"
				Call CMDHideOlderThan1Day_Click()
			Case "mnuRefresh"
				Call CMDShowAllFiles_Click(CMDShowAllFiles, New System.EventArgs())
		End Select
	End Sub
End Class