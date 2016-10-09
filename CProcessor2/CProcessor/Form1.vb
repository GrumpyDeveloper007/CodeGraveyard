

Public Class Form1
    Dim sFileStructures(100000) As List(Of String)
    Dim iStructures As Integer

    Dim oVFTMissingInheritedClasses As List(Of cClass)

    Private Sub ReadFile(ByVal sFileName As String)
        Dim i As Integer
        Dim oSource As System.IO.StreamReader
        Dim bskip As Boolean
        Dim sFileLine As String
        Dim bHeaderFile As Boolean
        Dim iIndentCount As Integer
        Dim bClassLine As Boolean
        bHeaderFile = sFileName.Contains(".h")
        oSource = My.Computer.FileSystem.OpenTextFileReader(sFileName)

        i = 0
        iStructures = 0
        sFileStructures(iStructures) = New List(Of String)
        iIndentCount = 0
        If sFileName.Contains("UI_Event.c") Then
            i = i
        End If

        Do While oSource.EndOfStream = False
            bskip = False
            sFileLine = oSource.ReadLine()

            If sFileLine.StartsWith("//") = False Then
                If sFileLine.Trim.StartsWith("{") And bClassLine = False Then
                    iIndentCount += 1
                End If

                If sFileLine.Trim.StartsWith("}") And iIndentCount > 0 Then
                    iIndentCount -= 1
                End If
            End If
            bClassLine = False
            If sFileLine.Contains("class") Then
                bClassLine = True
            End If

            'If sFileLine.Contains("#ifdef OBJECTIF_CODEGENERATION") Or sFileLine.Contains("//..end ""ifdef objectiF_codegeneration c""") Or sFileLine.Contains("#endif // OBJECTIF_CODEGENERATION") Then
            'Or sFileLine.Contains("//..begin ""endif objectiF_codegeneration c""") Or sFileLine.Contains("//..end ""endif objectiF_codegeneration c""") Or sFileLine.Contains("//..begin ""ifdef objectiF_codegeneration c""") Then
            'bSkip = True
            'End If

            If bskip Then
                sFileLine = "//" & sFileLine
            End If
            'If bSkip = False Then
            sFileStructures(iStructures).Add(sFileLine)
            'oDest.WriteLine(sFileLine)

            If bHeaderFile Then
                If sFileLine.Trim.Length = 0 Then
                    iStructures += 1
                    sFileStructures(iStructures) = New List(Of String)
                End If
            Else
                If sFileLine.Trim.Length = 0 And iIndentCount = 0 Then
                    iStructures += 1
                    sFileStructures(iStructures) = New List(Of String)
                End If
            End If
            'End If


        Loop
        oSource.Close()

    End Sub


    Private Sub butGo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles butGo.Click
        oClasses = New List(Of cClass)
        TreeClasses.Nodes.Clear()
        oVFTMissingInheritedClasses = SetupInheritedClassesWithoutVFT()

        Dim oDest As System.IO.StreamWriter
        Dim i As Integer
        Dim bHeaderFile As Boolean
        Dim z As Integer

        txtDebug.Text = ""

        Cursor = Cursors.WaitCursor
        My.Computer.FileSystem.CreateDirectory(txtWorkingDrive.Text & "Sources_Cpp")
        lstErrors.Items.Clear()
        lblErrorCount.Text = "0"

        For Each sDir As String In My.Computer.FileSystem.GetDirectories(txtWorkingDrive.Text & "Sources")
            sDir = sDir
            My.Computer.FileSystem.CreateDirectory(sDir.Replace(txtWorkingDrive.Text & "Sources", txtWorkingDrive.Text & "Sources_Cpp"))

            ' pre scan to gather class information
            For Each sFile As String In My.Computer.FileSystem.GetFiles(sDir, FileIO.SearchOption.SearchTopLevelOnly, "*.h", "*.hl")
                ReadFile(sFile)
                HeaderFileProcessing(sFile, True)
            Next

            ' Do Headers first 
            For Each sFile As String In My.Computer.FileSystem.GetFiles(sDir, FileIO.SearchOption.SearchTopLevelOnly, "*.h", "*.hl")
                bHeaderFile = sFile.Contains(".h")

                oDest = My.Computer.FileSystem.OpenTextFileWriter(sFile.Replace(txtWorkingDrive.Text & "Sources", txtWorkingDrive.Text & "Sources_Cpp").Replace(".c", ".cpp"), False)

                ReadFile(sFile)

                If bHeaderFile Then
                    HeaderFileProcessing(sFile, False)
                Else
                    CppFileProcessing(sFile)
                End If

                Dim bCommentNextLine As Boolean = False
                Dim bInFunction As Boolean

                For t = 0 To iStructures
                    bInFunction = False
                    For Each sLine As String In sFileStructures(t)
                        If sLine.Contains("{") Then
                            bInFunction = True
                        End If
                        If sLine.Contains("}") Then
                            bInFunction = False
                        End If
                        If bCommentNextLine Then
                            sLine = "//" & sLine
                            bCommentNextLine = False
                        End If

                        If (sLine.StartsWith("extern const ") Or sLine.StartsWith("extern ") Or sLine.StartsWith("const extern ")) And sLine.Contains("VFT") = True Then
                            sLine = "//" & sLine
                            If sLine.Contains(";") = False Then
                                bCommentNextLine = True
                            End If
                        End If

                        ' Fix type references
                        If IsCommentLine(sLine) = False Then
                            sLine = FixWords(sLine)
                            'If bHeaderFile Or (bHeaderFile = False And bInFunction) Then
                            'End If

                            ' fix reserved word(s)
                            If sLine.Contains("delete()") Then
                                'void (* delete)();
                                sLine = sLine.Replace("delete();", "_delete();")
                            End If
                            If sLine.Contains("void delete(   );") Then
                                'void (* delete)();
                                sLine = sLine.Replace("void delete(   );", "void _delete();")
                            End If


                            ' fix complex lines
                            If sLine.Contains("OSTask_Create(this, name, priority, (this.run), stack, stackSize, timeslice, parameter);") Then
                                sLine = sLine.Replace("OSTask_Create(this, name, priority, (this->run), stack, stackSize, timeslice, parameter);", _
                                              "   OSTask_Create( name, priority, (&run), stack, stackSize, timeslice, parameter);")
                            End If


                            ' todo's
                            If sLine.Trim.StartsWith("this =") Then
                                sLine = "//" & sLine
                            End If
                            sLine = sLine.Replace("CCalBitParameterData", "CalBitParameterData")
                            If sLine.Contains("BOOLEAN (* setTimeDate)(const Mca_SystemTimeHandlerType  * const _this,Mca_TimeDateType * TimeDate,U8 Flags);") Then
                                'void (* delete)();
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If
                            If sLine.Contains("BOOLEAN  Activate(BOOLEAN Action,void (*CallBackroutine( U16 Trigger,BOOLEAN Result),U16 Trigger);") Then
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If
                            If sLine.Contains("BOOLEAN  setTimeDate(const Mca_SystemTimeHandlerType  * const _this,Mca_TimeDateType * TimeDate,U8 Flags);") Then
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If
                        End If


                        oDest.WriteLine(sLine)
                    Next
                Next

                oDest.Close()

            Next

        Next

        If chkSkipImplementation.Checked = False Then
            For Each sDir As String In My.Computer.FileSystem.GetDirectories(txtWorkingDrive.Text & "Sources")
                sDir = sDir
                My.Computer.FileSystem.CreateDirectory(sDir.Replace(txtWorkingDrive.Text & "Sources", txtWorkingDrive.Text & "Sources_Cpp"))

                ' Do Code files 
                For Each sFile As String In My.Computer.FileSystem.GetFiles(sDir, FileIO.SearchOption.SearchTopLevelOnly, "*.c")
                    bHeaderFile = sFile.Contains(".h")
                    ReadFile(sFile)

                    oDest = My.Computer.FileSystem.OpenTextFileWriter(sFile.Replace(txtWorkingDrive.Text & "Sources", txtWorkingDrive.Text & "Sources_Cpp").Replace(".c", ".cpp"), False)

                    If bHeaderFile Then
                        HeaderFileProcessing(sFile, False)
                    Else
                        CppFileProcessing(sFile)
                    End If

                    Dim bCommentNextLine As Boolean = False
                    Dim bInFunction As Boolean

                    For t = 0 To iStructures
                        bInFunction = False
                        For Each sLine As String In sFileStructures(t)
                            If sLine.Contains("{") Then
                                bInFunction = True
                            End If
                            If sLine.Contains("}") Then
                                bInFunction = False
                            End If
                            If bCommentNextLine Then
                                sLine = "//" & sLine
                                bCommentNextLine = False
                            End If

                            If sLine.StartsWith("extern const ") Or sLine.StartsWith("extern ") Or sLine.StartsWith("const extern ") Then
                                sLine = "//" & sLine
                                If sLine.Contains(";") = False Then
                                    bCommentNextLine = True
                                End If
                            End If


                            'If bHeaderFile Or (bHeaderFile = False And bInFunction) Then

                            ' Fix type references
                            sLine = FixWords(sLine)
                            'End If

                            ' fix reserved word(s)
                            If sLine.Contains("void  delete()") Then
                                'void (* delete)();
                                sLine = sLine.Replace("void  delete();", "void _delete();")
                            End If

                            ' fix complex lines
                            If sLine.Contains("Create( name, priority, (this->run), stack, stackSize, timeslice, parameter);") Then
                                sLine = sLine.Replace("Create( name, priority, (this->run), stack, stackSize, timeslice, parameter);", _
                                              "   Create( name, priority, (&this->run), stack, stackSize, timeslice, parameter);")
                            End If


                            ' todo's
                            If sLine.Trim.StartsWith("this =") Then
                                sLine = "//" & sLine
                            End If
                            sLine = sLine.Replace("CCalBitParameterData", "CalBitParameterData")
                            If sLine.Contains("BOOLEAN (* setTimeDate)(const Mca_SystemTimeHandlerType  * const _this,Mca_TimeDateType * TimeDate,U8 Flags);") Then
                                'void (* delete)();
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If
                            If sLine.Contains("BOOLEAN  Activate(BOOLEAN Action,void (*CallBackroutine( U16 Trigger,BOOLEAN Result),U16 Trigger);") Then
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If
                            If sLine.Contains("BOOLEAN  setTimeDate(const Mca_SystemTimeHandlerType  * const _this,Mca_TimeDateType * TimeDate,U8 Flags);") Then
                                sLine = "//" & txtConvTODO.Text & sLine
                            End If


                            oDest.WriteLine(sLine)
                        Next
                    Next

                    oDest.Close()

                Next


            Next
        End If

        Dim toClasses As cClass

        Dim bSwap As Boolean
        bSwap = True
        Do While bSwap = True
            bSwap = False
            For i = 0 To oClasses.Count - 2
                If oClasses(i).sClassName > oClasses(i + 1).sClassName Then
                    bSwap = True
                    toClasses = oClasses(i)
                    oClasses(i) = oClasses(i + 1)
                    oClasses(i + 1) = toClasses
                End If
            Next
        Loop


        ' Add full classes
        For Each a As cClass In oClasses
            If a.HasFunction = True Then
                Dim basenode As New TreeNode
                Dim Functionnode As New TreeNode
                basenode.Text = a.sClassName
                Functionnode.Text = "Functions"

                TreeClasses.Nodes.Add(basenode)
                For Each b As String In a.sBaseClasses
                    basenode.Nodes.Add(b)
                Next
                basenode.Nodes.Add(Functionnode)
                For Each b As String In a.sFunctions
                    Functionnode.Nodes.Add(b)
                Next
            End If
        Next

        ' Add data classes (structures?)
        For Each a As cClass In oClasses
            If a.HasFunction = False Then
                Dim basenode As New TreeNode
                Dim Functionnode As New TreeNode
                basenode.Text = a.sClassName
                Functionnode.Text = "Functions"

                TreeStructures.Nodes.Add(basenode)
                For Each b As String In a.sBaseClasses
                    basenode.Nodes.Add(b)
                Next
                basenode.Nodes.Add(Functionnode)
                For Each b As String In a.sFunctions
                    Functionnode.Nodes.Add(b)
                Next
            End If
        Next
        TreeClasses.ExpandAll()
        TreeStructures.ExpandAll()

        Cursor = Cursors.Default

    End Sub

    Private Sub HeaderFileProcessing(ByVal sFile As String, ByVal pPreProcess As Boolean)
        ' join structures 
        Dim z As Integer
        Dim y As Integer
        Dim tempstring As String
        Dim sClassName As String
        Dim sClassNameWithoutType As String
        Dim sBaseClassName As String
        Dim sDestinationFound As Boolean
        Dim sLineObjectName As String
        For t = 0 To iStructures - 1
            sClassName = ""

            If sFileStructures(t)(0).StartsWith("struct") Then
                If sFileStructures(t)(0).EndsWith("VFT") Then ' Source class
                    sDestinationFound = False
                    For z = 0 To iStructures - 1 'dest class
                        'COSTaskFunctionsVFT=COSTask
                        If sFileStructures(z)(0).Split(" ").Count > 1 Then
                            sLineObjectName = sFileStructures(z)(0).Split(" ")(1)
                        Else
                            sLineObjectName = ""
                        End If

                        ' drop typedef as end of class structure
                        For y = 0 To sFileStructures(z).Count - 1
                            If sFileStructures(z)(y).StartsWith("typedef struct ") Then
                                sFileStructures(z)(y) = "//" & sFileStructures(z)(y)
                            End If
                            'sFileStructures(z)(y) = sFileStructures(z)(y).Replace("struct ", "class ")
                        Next

                        If sFileStructures(z)(0) & "VFT" = sFileStructures(t)(0) _
                         Or (sFileStructures(t)(0).Split(" ")(1) = "COSTaskFunctionsVFT" And sLineObjectName = "COSTask") Then ' hard coded link because names are different


                            sClassName = sFileStructures(z)(0).Replace("struct ", "")
                            If sClassName.EndsWith("Type") Then
                                sClassNameWithoutType = sClassName.Substring(sClassName.Length - 4)
                            Else
                                sClassNameWithoutType = sClassName
                            End If
                            sFileStructures(z).Insert(2, "public:")

                            ' pre scan to get base
                            Dim oClass As New cClass
                            oClass.sClassName = sFileStructures(z)(0).Split(" ")(1)
                            tempstring = ""

                            'here
                            ExtractBaseClassFromThisReferences(t, oClass, sBaseClassName, sClassNameWithoutType)


                            For y = sFileStructures(t).Count - 4 To 2 Step -1
                                'need to restructure functon stubs
                                tempstring = sFileStructures(t)(y)
                                ' Attempt to remove the first parameter '_this'
                                For Each sBaseClassName In oClass.sBaseClasses
                                    '                                    If sBaseClassName.Length > 0 Then
                                    tempstring = ThisParameterStripper(tempstring, sBaseClassName & " ")
                                    tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1) & " ")

                                    tempstring = ThisParameterStripper(tempstring, sBaseClassName)
                                    tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1) & "Type")
                                    tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1))
                                    'End If
                                Next
                                tempstring = ThisParameterStripper(tempstring, sClassName & " ")
                                tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1) & " ")

                                tempstring = ThisParameterStripper(tempstring, sClassName)
                                tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1) & "Type")
                                tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1))

                                ' remove the (* ) around the function name
                                tempstring = tempstring.Replace(")(", "(")
                                tempstring = tempstring.Replace("struct ", " ")
                                Dim ii As Integer
                                ii = tempstring.IndexOf("(*")
                                If ii > 0 Then
                                    tempstring = tempstring.Substring(0, ii) & tempstring.Substring(ii + 2)
                                End If

                                oClass.AddFunction(tempstring.Trim)
                                sFileStructures(z).Insert(3, tempstring)
                                If tempstring.Contains("_this") Then
                                    If pPreProcess = False Then
                                        lstErrors.Items.Add(" This reference to unknown class:" & "[" & sClassName & "]" & "." & tempstring)
                                        lblErrorCount.Text = Val(lblErrorCount.Text) + 1
                                    End If
                                End If


                            Next

                            sBaseClassName = ""
                            If oClass.sBaseClasses.Count > 0 Then
                                sBaseClassName = " :"
                                ' Work out what is the correct base class
                                If pPreProcess = False Then
                                    sBaseClassName &= " public " & GetChildClass(oClass.sBaseClasses) & " ,"
                                Else
                                    For Each s As String In oClass.sBaseClasses
                                        sBaseClassName &= " public " & s & " ,"
                                    Next
                                End If
                                sBaseClassName = sBaseClassName.Substring(0, sBaseClassName.Length - 1)
                            End If
                            If sBaseClassName.Length > 0 Then
                                If IsClassNameTheSame(sClassName, sBaseClassName) = False Then

                                    sFileStructures(z)(0) = sFileStructures(z)(0).Replace("struct", "class") & sBaseClassName
                                Else
                                    sFileStructures(z)(0) = sFileStructures(z)(0).Replace("struct", "class")
                                End If
                            Else
                                sFileStructures(z)(0) = sFileStructures(z)(0).Replace("struct", "class")
                            End If

                            AddClass(oClass)
                            sDestinationFound = True
                        End If

                    Next
                    If sDestinationFound = False Then
                        If pPreProcess = False Then
                            lstErrors.Items.Add("Target class for VFT table not found :" & sFileStructures(t)(0))
                            lblErrorCount.Text = Val(lblErrorCount.Text) + 1
                        End If
                    End If


                    For y = 0 To sFileStructures(t).Count - 1
                        sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                    Next
                Else
                    ' Not a virtual function class

                    'For y = 0 To sFileStructures(z).Count - 1
                    '    sFileStructures(z)(y) = sFileStructures(z)(y).Replace("struct ", "")
                    'Next

                End If
            End If
        Next

        ' Second scan to find classes without VFT tables !
        For t = 0 To iStructures - 1
            sClassName = ""

            If sFileStructures(t)(0).StartsWith("class") Then

                sClassName = sFileStructures(t)(0).Trim.Split(" ")(1)

                For y = 2 To sFileStructures(t).Count - 1

                    ' Add static class instances 
                    If sFileStructures(t)(y).Contains("}") Then
                        sFileStructures(t)(y) = sFileStructures(t)(y).Replace(";", sClassName.Substring(1) & ";")
                    End If

                    ' comment const class references (VFT)
                    If sFileStructures(t)(y).Trim.StartsWith("const struct") Then
                        If sFileStructures(t)(y).Contains("VFT") Then
                            sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                        Else
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("const ", "")
                        End If
                    End If

                    ' drop typedef as end of class structure
                    If sFileStructures(t)(y).StartsWith("typedef struct ") Then
                        sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                    End If
                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace("struct ", "class ")
                Next
            End If


            If sFileStructures(t)(0).StartsWith("struct") Then
                sBaseClassName = ""
                Dim oClass As New cClass
                oClass.sClassName = sFileStructures(t)(0).Split(" ")(1)

                ExtractBaseClassFromThisReferences(t, oClass, sBaseClassName, sClassNameWithoutType)

                For y = 0 To oVFTMissingInheritedClasses.Count - 1
                    If sFileStructures(t)(0).Contains(oVFTMissingInheritedClasses(y).sClassName) Then
                        sBaseClassName = oVFTMissingInheritedClasses(y).sBaseClasses(0)
                    End If
                Next
                If sBaseClassName.Length > 0 Then
                    oClass.AddBaseClass(sBaseClassName)
                Else
                    ' unknown base class
                    If pPreProcess = False And oClass.sBaseClasses.Count = 0 And oClass.sClassName.EndsWith("RamData") = False And oClass.sClassName.EndsWith("PersistentData") = False And oClass.sClassName.EndsWith("FastAccessData") = False Then
                        lstErrors.Items.Add("Unknown base class" & oClass.sClassName)
                        lblErrorCount.Text = Val(lblErrorCount.Text) + 1
                    End If
                End If
                    AddClass(oClass)


                If sFileStructures(t)(0).Split(" ")(1).StartsWith("C") Then
                    If sBaseClassName.Length = 0 Then
                        sFileStructures(t)(0) = sFileStructures(t)(0).Replace("struct", "class") & " //" & txtConvTODO.Text & " No VFT table structure found !"
                    Else
                        sFileStructures(t)(0) = sFileStructures(t)(0).Replace("struct", "class") & " : public " & sBaseClassName & " //" & txtConvTODO.Text & " No VFT table structure found !"
                    End If
                    sFileStructures(t).Insert(2, "public:")
                End If

                ' drop typedef as end of class structure
                For y = 2 To sFileStructures(t).Count - 1
                    If sFileStructures(t)(y).StartsWith("typedef struct ") Then
                        sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                    End If
                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace("struct ", "class ")

                    ' Add static class instances 
                    If sFileStructures(t)(y).Contains("}") Then
                        sFileStructures(t)(y) = sFileStructures(t)(y).Replace(";", oClass.sClassName.Substring(1) & ";")
                    End If

                Next

            End If


        Next




        ' attempt to comment out functions, anything that starts with a type and ends with a ;
        For t = 0 To iStructures
            Dim bCommentLine As Boolean = False
            Dim bCommentLineSingle As Boolean = False
            Dim bFunctionStarted As Boolean = False
            Dim sLine As String
            Dim sFunctionName As String

            sFunctionName = ""
            If sFileStructures(t)(0).Contains("class") = False Then

                For y = 0 To sFileStructures(t).Count - 1
                    sLine = sFileStructures(t)(y)

                    If sLine.StartsWith("//") Then
                        bCommentLineSingle = True
                    Else
                        bCommentLineSingle = False
                    End If
                    If sLine.Trim.StartsWith("/*") Then
                        bCommentLine = True
                    End If
                    If sLine.Trim.Contains("*/") Then
                        bCommentLine = False
                    End If



                    If bCommentLine = False And bCommentLineSingle = False Then
                        If StartsWithTypeDeclaration(sLine) Then
                            ' TODO : functions with custom return types
                            bFunctionStarted = True
                        End If
                        If bFunctionStarted = True Then
                            sFunctionName &= sFileStructures(t)(y).Trim
                            sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                            If sLine.Contains(";") Then
                                Exit For ' drop out of this section
                            End If
                        End If
                    End If

                Next


                ' Add function to class
                Dim bFoundClassForFunction As Boolean
                Dim oClass As cClass
                Dim bAddClass As Boolean
                If sFunctionName.Length > 0 Then
                    bFoundClassForFunction = False
                    For i = 0 To iStructures
                        For y = 0 To sFileStructures(i).Count - 1
                            sLine = sFileStructures(i)(y)

                            If sLine.StartsWith("class") Then
                                sClassName = sLine.Split(" ")(1).Substring(1)
                                If sFunctionName.Contains(sClassName & "_") Then
                                    tempstring = sFunctionName.Split(" ")(0) & " " & sFunctionName.Substring(sFunctionName.IndexOf(sClassName, sFunctionName.Split(" ")(0).Length) + sClassName.Length + 1)

                                    sClassName = "C" & sClassName

                                    sBaseClassName = GetBaseClassName(sClassName)
                                    oClass = GetClass(sClassName)
                                    bAddClass = False
                                    If oClass Is Nothing Then
                                        oClass = New cClass
                                        oClass.sClassName = sClassName
                                        AddClass(oClass)
                                    End If

                                    If sBaseClassName.Length > 0 Then
                                        tempstring = ThisParameterStripper(tempstring, sBaseClassName & " ")
                                        tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1) & " ")

                                        tempstring = ThisParameterStripper(tempstring, sBaseClassName)
                                        tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1) & "Type")
                                        tempstring = ThisParameterStripper(tempstring, sBaseClassName.Substring(1))
                                    End If


                                    tempstring = ThisParameterStripper(tempstring, sClassName & " ")
                                    tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1) & " ")

                                    tempstring = ThisParameterStripper(tempstring, sClassName)
                                    tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1) & "Type")
                                    tempstring = ThisParameterStripper(tempstring, sClassName.Substring(1))
                                    tempstring = tempstring.Replace("struct ", "")

                                    ' Check to see if the function exists in the table 

                                    If DoesFunctionExist(sFileStructures(i), tempstring) = False Then
                                        oClass.AddFunction(tempstring.Trim)
                                        sFileStructures(i).Insert(y + 3, tempstring)
                                    End If
                                    bFoundClassForFunction = True
                                    Exit For
                                End If
                            End If

                        Next
                        If bFoundClassForFunction Then
                            Exit For
                        End If
                    Next
                End If
            End If
        Next

    End Sub

    Private Sub ExtractBaseClassFromThisReferences(ByVal t As Integer, ByVal oClass As cClass, ByRef sBaseClassName As String, ByRef sClassNameWithoutType As String)
        Dim tempstring As String = ""

        For y = 2 To sFileStructures(t).Count - 4
            sBaseClassName = ""
            'need to restructure functon stubs
            tempstring &= sFileStructures(t)(y)
            If tempstring.Contains("_this") Then

                ' extract the base class name
                tempstring = tempstring.Trim
                Dim sSplit() As String = ExtractThisType(tempstring).Trim.Split(" ")
                If sSplit(0) = "struct" Or sSplit(0) = "const" Then
                    If "C" & sSplit(1) <> sClassNameWithoutType & "Type" Then
                        If sSplit(1) = "struct" Or sSplit(1) = "const" Then
                            sBaseClassName = sSplit(2)
                        Else
                            sBaseClassName = sSplit(1)
                        End If

                    End If
                Else
                    If "C" & sSplit(0) <> sClassNameWithoutType & "Type" Then
                        sBaseClassName = sSplit(0)
                    End If
                End If
                sBaseClassName = sBaseClassName.Replace("*", "")
            End If
            If tempstring.Contains(";") Or tempstring.Trim.StartsWith("//") Then
                tempstring = ""
            End If
            If sBaseClassName.Length > 0 Then
                If oClass.sBaseClasses.Contains(sBaseClassName) = False And oClass.sClassName <> sBaseClassName Then
                    oClass.AddBaseClass(sBaseClassName)
                End If
            End If
        Next
    End Sub

    Private Function DoesFunctionExist(ByVal sClassBlock As List(Of String), ByVal sFunctionName As String) As Boolean
        Dim i As Integer
        Dim sFunctionNameOnly As String
        Dim tempstring As String
        sFunctionNameOnly = sFunctionName.Trim.Split(" ")(1).Split("(")(0)
        For i = 0 To sClassBlock.Count - 1
            If sClassBlock(i).Trim.StartsWith("//") = False Then
                If sClassBlock(i).Trim.Split(" ").GetUpperBound(0) > 0 Then
                    If sClassBlock(i).Trim.Split(" ")(1) = "" Then
                        tempstring = sClassBlock(i).Trim.Split(" ")(2)
                    Else
                        tempstring = sClassBlock(i).Trim.Split(" ")(1)
                    End If

                Else
                    tempstring = ""
                End If

                ' std function format
                tempstring = tempstring.Split("(")(0)
                If tempstring = sFunctionNameOnly Then
                    Return True
                End If
                '    'void (* isrHandler)(void);' function format
                If sClassBlock(i).Contains("_" & sFunctionNameOnly & "(") Or sClassBlock(i).Contains("_" & sFunctionNameOnly & ")") Or _
                sClassBlock(i).Contains(" " & sFunctionNameOnly & "(") Or sClassBlock(i).Contains(" " & sFunctionNameOnly & ")") Then
                    Return True
                End If
            End If
        Next
        Return False
    End Function

    Private Function GetBaseClassName(ByVal sClassName As String) As String
        Dim i As Integer
        For i = 0 To oClasses.Count - 1
            If oClasses(i).sClassName = sClassName And oClasses(i).sBaseClasses.Count > 0 Then
                Return oClasses(i).sBaseClasses(0)
                Exit For
            End If
        Next

        Return ""
    End Function

    Private Function StartsWithTypeDeclaration(ByVal sLine As String) As Boolean
        If sLine.StartsWith("void ") Or sLine.StartsWith("U8") Or sLine.StartsWith("U16") Or sLine.StartsWith("U32") _
        Or sLine.StartsWith("S8") Or sLine.StartsWith("S16") Or sLine.StartsWith("S32") _
        Or sLine.StartsWith("BOOLEAN") _
        Or sLine.StartsWith("unsigned int") Or sLine.StartsWith("int") Or sLine.StartsWith("char") _
        Or sLine.StartsWith("Mev_AttrIdEnumType ") Or sLine.StartsWith("COSTask*") Or sLine.StartsWith("OSTaskType*") Or sLine.StartsWith("CUI_EventMask") _
         Or sLine.StartsWith("UI_EventMaskType") _
         Or sLine.StartsWith("CUI_DisplayItem") Or sLine.StartsWith("UI_DisplayItemType") _
        Then
            Return True
        Else
            Return False
        End If
    End Function


    Private Sub CppFileProcessing(ByVal sFile As String)
        Dim t As Integer
        Dim sLine As String
        Dim iEnd As Integer
        Dim iStart As Integer
        Dim iClassIndex As Integer
        Dim bFunctionDetailStarted As Boolean


        ' update function declarations and _this references
        For t = 0 To iStructures
            Dim bCommentLine As Boolean = False
            Dim bCommentLineSingle As Boolean = False
            Dim bFunctionStarted As Boolean = False
            bFunctionDetailStarted = False
            For y = 0 To sFileStructures(t).Count - 1
                sLine = sFileStructures(t)(y)
                If sLine.StartsWith("//") Then
                    bCommentLineSingle = True
                End If
                If sLine.Trim.StartsWith("/*") Then
                    bCommentLine = True
                End If
                If sLine.Trim.Contains("*/") Then
                    bCommentLine = False
                End If
                '                If bFunctionStarted = False Then
                'bCommentLine = IsCommentLine(sLine)
                'End If


                If bCommentLine = False And bCommentLineSingle = False Then
                    If (sLine.StartsWith("void ") Or sLine.StartsWith("U8") Or sLine.StartsWith("U16") Or sLine.StartsWith("U32") _
                    Or sLine.StartsWith("S8") Or sLine.StartsWith("S16") Or sLine.StartsWith("S32") _
                    Or sLine.StartsWith("unsigned int") Or sLine.StartsWith("int") Or sLine.StartsWith("BOOLEAN") Or sLine.Contains("(")) And bFunctionDetailStarted = False Then
                        ' TODO : functions with custom return types
                        bFunctionStarted = True

                        iClassIndex = -1
                        For i = 0 To oClasses.Count - 1
                            If sFileStructures(t)(y).Contains(oClasses(i).sClassName.Substring(1)) Then
                                Dim sNewLine As String
                                iClassIndex = i
                                sNewLine = sFileStructures(t)(y)
                                For Each sfun As String In oClasses(i).sFunctions
                                    Dim sfunctionNameOnly As String
                                    sfunctionNameOnly = GetFunctionName(sfun)
                                    If sfunctionNameOnly.Length > 0 Then
                                        ' change 'class _ function' references to 'class :: function'
                                        sNewLine = sNewLine.Replace(oClasses(i).sClassName.Substring(1) & "_" & sfunctionNameOnly, oClasses(i).sClassName & "::" & sfunctionNameOnly)
                                    End If
                                Next
                                'Work on base classes
                                Dim oBaseClass As cClass
                                For x = 0 To oClasses(i).sBaseClasses.Count - 1
                                    oBaseClass = GetClass(oClasses(i).sBaseClasses(x))

                                    If oBaseClass IsNot Nothing Then
                                        For Each sfun As String In oBaseClass.sFunctions
                                            Dim sfunctionNameOnly As String
                                            sfunctionNameOnly = GetFunctionName(sfun)
                                            If sfunctionNameOnly.Length > 0 Then
                                                ' change 'class _ function' references to 'class :: function'
                                                sNewLine = sNewLine.Replace(oClasses(i).sClassName.Substring(1) & "_" & sfunctionNameOnly, oClasses(i).sClassName & "::" & sfunctionNameOnly)
                                            End If
                                        Next

                                    End If
                                Next
                                sFileStructures(t)(y) = sNewLine

                            End If
                        Next

                    End If
                    If bFunctionDetailStarted = True Then
                        ' search for base class references, remove prefix
                        If iClassIndex >= 0 Then
                            If oClasses(iClassIndex).sBaseClasses.Count > 0 Then
                                If sLine.Trim.StartsWith(oClasses(iClassIndex).sBaseClasses(0).Substring(1) & "_") Then
                                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace(oClasses(iClassIndex).sBaseClasses(0).Substring(1) & "_", "")
                                    'strip 'this' parameter from base class calls
                                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this,", "").Replace("_this)", ")").Replace("this,", "").Replace("this)", ")")
                                End If
                            End If
                        End If

                        ' Search for general class references 
                        If sFileStructures(t)(y).Length > 0 Then
                            Dim sTemp As String

                            sTemp = UpdateClassFunctionReferences(sFileStructures(t)(y))
                            If sFileStructures(t)(y) <> sTemp Then
                                txtDebug.Text = txtDebug.Text & sFile & ":" & sFileStructures(t)(y) & ":" & sTemp & vbCrLf
                            End If
                            sFileStructures(t)(y) = sTemp
                        End If

                        If sLine.Contains("_this") Then
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this,", "").Replace("_this)", ")").Replace("this,", "").Replace("this)", ")")

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this->pVFT->", "this->")

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this -> ", "this->")
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this ->", "this->")
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this->", "this->")
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this", "this")
                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace("->pVFT->", "->")
                        End If

                        ' Search for 'this->DisplayList->handle(this->DisplayList,this->Display);', i.e. object references inside and outside of function references
                        Dim iBracketStart As Integer
                        Dim iBracketEnd As Integer
                        Dim sFunctionParameters As String
                        Dim sFirstFunctionParmater As String
                        Dim iObjectPointer As Integer
                        Dim iOutsideRef As Integer
                        iBracketStart = 0
                        iBracketStart = sFileStructures(t)(y).IndexOf("(")
                        Do While iBracketStart > 0
                            iBracketEnd = sFileStructures(t)(y).IndexOf(")", iBracketStart)
                            iObjectPointer = sFileStructures(t)(y).IndexOf("->")
                            If iBracketStart > 0 And iBracketEnd > 0 And iBracketEnd > iBracketStart And iObjectPointer < iBracketStart And iObjectPointer > 0 Then
                                sFunctionParameters = sFileStructures(t)(y).Substring(iBracketStart + 1, iBracketEnd - iBracketStart - 1)
                                sFirstFunctionParmater = sFunctionParameters.Split(",")(0)
                                iOutsideRef = sFileStructures(t)(y).IndexOf(sFirstFunctionParmater)
                                If iOutsideRef < iBracketStart And sFunctionParameters.Length > 0 Then
                                    'sFunctionParameters = sFunctionParameters.Replace(sFirstFunctionParmater, "")
                                    txtDebug.Text &= sFileStructures(t)(y) & vbCrLf
                                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace("(" & sFunctionParameters & ")", "(" & sFunctionParameters.Replace(sFirstFunctionParmater & ",", "") & ")")
                                    sFileStructures(t)(y) = sFileStructures(t)(y).Replace("(" & sFunctionParameters & ")", "(" & sFunctionParameters.Replace(sFirstFunctionParmater, "") & ")")

                                    iBracketEnd = iBracketEnd

                                End If
                            End If
                            'sFileStructures(t)(y).IndexOf (
                            If iBracketStart > sFileStructures(t)(y).Length Then
                                iBracketStart = -1
                            Else
                                iBracketStart = sFileStructures(t)(y).IndexOf("(", iBracketStart + 1)
                            End If

                        Loop

                    End If

                    If bFunctionStarted = True Then
                        If sLine.Contains("{") Then
                            bFunctionDetailStarted = True
                            bFunctionStarted = False
                        End If

                        If sLine.Contains("_this ,") Then
                            iEnd = sLine.IndexOf("_this ,") + 7
                            iStart = 0
                            If sLine.LastIndexOf(",", iStart) > iStart Then
                                iStart = sLine.LastIndexOf(",", iStart)
                            End If
                            If sLine.LastIndexOf("(", iStart) > iStart Then
                                iStart = sLine.LastIndexOf("(", iStart)
                            End If

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace(sLine.Substring(iStart, iEnd - iStart), "")
                        End If
                        If sLine.Contains("_this )") Then
                            iEnd = sLine.IndexOf("_this )") + 6
                            iStart = 0
                            If sLine.LastIndexOf(",", iStart) > iStart Then
                                iStart = sLine.LastIndexOf(",", iStart)
                            End If
                            If sLine.LastIndexOf("(", iStart) > iStart Then
                                iStart = sLine.LastIndexOf("(", iStart)
                            End If

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace(sLine.Substring(iStart, iEnd - iStart), "")
                        End If


                        If sLine.Contains("_this,") Then
                            iEnd = sLine.IndexOf("_this,") + 6
                            iStart = 0
                            If sLine.LastIndexOf(",", iStart) > iStart Then
                                iStart = sLine.LastIndexOf(",", iStart)
                            End If
                            If sLine.LastIndexOf("(", iStart) > iStart Then
                                iStart = sLine.LastIndexOf("(", iStart)
                            End If

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace(sLine.Substring(iStart, iEnd - iStart), "")
                        End If
                        If sLine.Contains("_this)") Then
                            iEnd = sLine.IndexOf("_this)") + 5
                            iStart = 0
                            If sLine.LastIndexOf(",", iStart) > iStart Then
                                iStart = sLine.LastIndexOf(",", iStart)
                            End If
                            If sLine.LastIndexOf("(", iStart) > iStart Then
                                iStart = sLine.LastIndexOf("(", iStart)
                            End If

                            sFileStructures(t)(y) = sFileStructures(t)(y).Replace(sLine.Substring(iStart, iEnd - iStart), "")
                        End If
                    End If
                End If
                bCommentLineSingle = False

            Next
        Next


        ' comment VFT blocks
        For t = 0 To iStructures
            If sFileStructures(t).Count > 0 Then
                If sFileStructures(t)(0).Contains("VFT") And sFileStructures(t)(0).StartsWith("const") Then
                    For y = 0 To sFileStructures(t).Count - 1

                        sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                    Next
                End If
            End If
        Next



        ' update _this references
        For t = 0 To iStructures
            For y = 0 To sFileStructures(t).Count - 1
                sLine = sFileStructures(t)(y)
                '
                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this,", "").Replace("_this)", ")").Replace("this,", "").Replace("this)", ")")

                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this->pVFT->", "this->")

                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this -> ", "this->")
                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this ->", "this->")
                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this->", "this->")
                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("_this", "this")
                sFileStructures(t)(y) = sFileStructures(t)(y).Replace("->pVFT->", "->")

                sLine = sFileStructures(t)(y)
                If sLine.Contains("->") Then
                    ' attempt to identify this parameter function calls
                End If

                If sFileStructures(t)(y).Contains("this =") And sFileStructures(t)(y).Contains("this ==") = False Then
                    sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                End If

                If sFileStructures(t)(y).Contains("this=") And sFileStructures(t)(y).Contains("this==") = False Then
                    sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                End If

                ' Comment lines containing .VFT
                If sFileStructures(t)(y).Contains(".VFT") Then
                    sFileStructures(t)(y) = "//" & sFileStructures(t)(y)
                End If


            Next
        Next
    End Sub


    Private Sub but1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles but1.Click
        Dim sFileName As String

        Cursor = Cursors.WaitCursor

        For Each sDir As String In My.Computer.FileSystem.GetDirectories(txtWorkingDrive.Text & "Sources")
            sDir = sDir
            My.Computer.FileSystem.CreateDirectory(sDir.Replace(txtWorkingDrive.Text & "Sources", txtWorkingDrive.Text & "Sources_Cpp"))

            For Each sFile As String In My.Computer.FileSystem.GetFiles(sDir, FileIO.SearchOption.SearchTopLevelOnly, "*.c", "*.h", "*.hl")
                sFileName = sFile.Split(".")(0)
                sFileName = sFileName.Substring(sFileName.LastIndexOf("\") + 1)
                If lstFiles.Items.Contains(sFileName) = False Then
                    lstFiles.Items.Add(sFileName)
                End If

            Next
        Next
        Cursor = Cursors.Default
    End Sub

    Private Sub Form1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    Private Function IsClassLogged(ByVal sClassName As String) As Boolean
        For Each a As cClass In oClasses
            If sClassName = a.sClassName Then
                Return True
            End If
        Next
        Return False
    End Function

    Private Sub AddClass(ByVal oClass As cClass)
        If IsClassLogged(oClass.sClassName) = False Then
            oClasses.Add(oClass)
        End If
    End Sub

    Private Function IsCommentLine(ByVal sLine As String) As Boolean
        If sLine.StartsWith("//") Then
            Return True
        End If
        Return False
    End Function

    Private Function GetFunctionName(ByVal sFunction As String) As String
        If sFunction.Length = 0 Then
            Return ""
        Else
            If sFunction.Trim.StartsWith("//") Then
                Return ""
            Else
                If sFunction.Split(" ").GetUpperBound(0) > 0 Then
                    If sFunction.Split(" ")(1) = "" Then
                        Return sFunction.Split(" ")(2).Split("(")(0)
                    Else
                        Return sFunction.Split(" ")(1).Split("(")(0)
                    End If
                Else
                    Return ""
                End If
            End If
        End If
    End Function


    ''' <summary>
    ''' Looks for 'class name_function name' and converts to 'class name.function name'
    ''' </summary>
    ''' <param name="sLine"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function UpdateClassFunctionReferences(ByVal sLine As String) As String
        Dim xx As Integer

        For x = 0 To oClasses.Count - 1
            If sLine.Contains(oClasses(x).sClassName.Substring(1)) Then
                For xx = 0 To oClasses(x).sFunctions.Count - 1
                    Dim iFunctionStart As Integer
                    Dim iFirstFunctionComma As Integer
                    If sLine.Contains(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & "(") Then
                        ' attempt to remove the first parameter (this)
                        iFunctionStart = sLine.IndexOf(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & "(") + (oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & "(").Length
                        iFirstFunctionComma = sLine.IndexOf(",", iFunctionStart)
                        If iFirstFunctionComma < 0 Then
                            iFirstFunctionComma = sLine.IndexOf(")", iFunctionStart) - 1
                            If iFirstFunctionComma < iFunctionStart Then
                                iFirstFunctionComma = 0
                            End If
                        End If
                        If iFirstFunctionComma > 0 Then
                            sLine = sLine.Replace(sLine.Substring(iFunctionStart, iFirstFunctionComma - iFunctionStart + 1), "") & "// CONV: '" & sLine.Substring(iFunctionStart, iFirstFunctionComma - iFunctionStart + 1) & "' removed"
                        End If

                        sLine = sLine.Replace(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & "(", oClasses(x).sClassName.Substring(1) & "." & GetFunctionName(oClasses(x).sFunctions(xx)) & "(")
                    End If
                    If sLine.Contains(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & " (") Then
                        ' attempt to remove the first parameter (this)
                        iFunctionStart = sLine.IndexOf(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & " (") + (oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & " (").Length
                        iFirstFunctionComma = sLine.IndexOf(",", iFunctionStart)
                        If iFirstFunctionComma < 0 Then
                            iFirstFunctionComma = sLine.IndexOf(")", iFunctionStart) - 1
                            If iFirstFunctionComma < iFunctionStart Then
                                iFirstFunctionComma = 0
                            End If

                        End If
                        If iFirstFunctionComma > 0 Then
                            sLine = sLine.Replace(sLine.Substring(iFunctionStart, iFirstFunctionComma - iFunctionStart + 1), "") & "// CONV: '" & sLine.Substring(iFunctionStart, iFirstFunctionComma - iFunctionStart + 1) & "' removed"
                        End If

                        sLine = sLine.Replace(oClasses(x).sClassName.Substring(1) & "_" & GetFunctionName(oClasses(x).sFunctions(xx)) & " (", oClasses(x).sClassName.Substring(1) & "." & GetFunctionName(oClasses(x).sFunctions(xx)) & " (")
                    End If
                Next
            End If
        Next

        Return sLine
    End Function
End Class
