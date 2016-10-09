Module Globals
    Public oClasses As List(Of cClass)

    Public Class cClass
        Public sClassName As String
        Public m_sBaseClasses As List(Of String)
        Private m_sFunctions As List(Of String)

        Public ReadOnly Property sFunctions() As List(Of String)
            Get
                Return m_sFunctions
            End Get
        End Property

        Public ReadOnly Property sBaseClasses() As List(Of String)
            Get
                Return m_sBaseClasses
            End Get
        End Property

        Public Sub New()
            m_sBaseClasses = New List(Of String)
            m_sFunctions = New List(Of String)
        End Sub

        Public Sub New(ByVal pClassName As String, ByVal pBaseName As String)
            sClassName = pClassName
            m_sBaseClasses = New List(Of String)
            m_sFunctions = New List(Of String)
            m_sBaseClasses.Add(pBaseName)
        End Sub

        Public Sub AddBaseClass(ByVal sBase As String)
            If sBase.EndsWith("Type") Then
                sBase = "C" & sBase.Substring(0, sBase.Length - 4) ' remove 'Type' suffix and add 'C' prefix
            Else
                If sBase.StartsWith("C") = True Then
                    sBase = sBase
                Else
                    sBase = "C" & sBase ' add 'C' prefix
                End If
            End If

            If IsClassNameTheSame(sClassName.Trim, sBase.Trim) = False Then
                For Each a As String In m_sBaseClasses
                    If IsClassNameTheSame(a.Trim, sBase.Trim) Then
                        Return
                    End If
                Next
                m_sBaseClasses.Add(sBase)

            End If
        End Sub

        Public Sub AddFunction(ByVal sString As String)
            m_sFunctions.Add(sString)
        End Sub

        Public Function HasFunction() As Boolean
            If m_sFunctions.Count > 0 Then
                Return True
            Else
                Return False
            End If
        End Function
    End Class

    Public Function GetChildClass(ByVal sClasses As List(Of String)) As String
        If sClasses.Count = 1 Then
            Return sClasses(0)
        Else
            If sClasses.Count = 2 Then
                Dim a As cClass
                Dim b As cClass
                Try
                    a = GetClass(sClasses(0))
                    b = GetClass(sClasses(1))
                    If b.sBaseClasses(0) = a.sClassName Then
                        Return b.sClassName
                    Else
                        Return a.sClassName
                    End If
                Catch ex As Exception
                    Return "// CONVTODO: Unable to extract base class name"
                End Try
            Else
                Return sClasses(0)
            End If

        End If
    End Function



    Public Function GetClass(ByVal sClassName As String) As cClass
        Dim i As Integer
        For i = 0 To oClasses.Count - 1
            If oClasses(i).sClassName = sClassName Then
                Return oClasses(i)
                Exit For
            End If
        Next

        Return Nothing
    End Function



    Public Function IsClassNameTheSame(ByVal sClassName As String, ByVal sBaseClassName As String) As Boolean
        If sClassName = sBaseClassName Then
            Return True
        End If
        If sClassName.Substring(1) = sBaseClassName Then
            Return True
        End If

        If sClassName.Substring(1) & "Type" = sBaseClassName Then
            Return True
        End If

        If sClassName = sBaseClassName.Substring(1) Then
            Return True
        End If

        If sClassName = sBaseClassName.Substring(1) & "Type" Then
            Return True
        End If

    End Function


    Public Function ExtractThisType(ByVal pString As String) As String
        Dim i As Integer
        Dim start As Integer
        i = pString.IndexOf("_this")
        start = pString.LastIndexOf("(", i)
        Return pString.Substring(start + 1, i - start + 4)
    End Function

    Public Function ThisParameterStripper(ByVal pString As String, ByVal sBaseClassName As String) As String
        pString = pString.Replace("const struct " & sBaseClassName & " * _this,", "")
        pString = pString.Replace("const struct " & sBaseClassName & "* _this,", "")
        pString = pString.Replace("const struct " & sBaseClassName & " *_this,", "")

        pString = pString.Replace("const struct " & sBaseClassName & "* _this", "")
        pString = pString.Replace("const struct " & sBaseClassName & " * _this", "")
        pString = pString.Replace("const struct " & sBaseClassName & " *_this", "")

        pString = pString.Replace("struct " & sBaseClassName & " * _this,", "")
        pString = pString.Replace("struct " & sBaseClassName & "* _this,", "")
        pString = pString.Replace("struct " & sBaseClassName & " *_this,", "")

        pString = pString.Replace("struct " & sBaseClassName & "* _this", "")
        pString = pString.Replace("struct " & sBaseClassName & " * _this", "")
        pString = pString.Replace("struct " & sBaseClassName & " *_this", "")

        pString = pString.Replace("const " & sBaseClassName & " * const _this,", "")
        pString = pString.Replace("const " & sBaseClassName & "* const _this,", "")
        pString = pString.Replace("const " & sBaseClassName & " *const _this,", "")

        pString = pString.Replace("const " & sBaseClassName & "* const _this", "")
        pString = pString.Replace("const " & sBaseClassName & " * const _this", "")
        pString = pString.Replace("const " & sBaseClassName & " *const _this", "")

        pString = pString.Replace("const " & sBaseClassName & " * _this,", "")
        pString = pString.Replace("const " & sBaseClassName & "* _this,", "")
        pString = pString.Replace("const " & sBaseClassName & " *_this,", "")

        pString = pString.Replace("const " & sBaseClassName & "* _this", "")
        pString = pString.Replace("const " & sBaseClassName & " * _this", "")
        pString = pString.Replace("const " & sBaseClassName & " *_this", "")

        pString = pString.Replace(sBaseClassName & " * const _this,", "")
        pString = pString.Replace(sBaseClassName & "* const _this,", "")
        pString = pString.Replace(sBaseClassName & " *const _this,", "")

        pString = pString.Replace(sBaseClassName & "* const _this", "")
        pString = pString.Replace(sBaseClassName & " * const _this", "")
        pString = pString.Replace(sBaseClassName & " *const _this", "")

        pString = pString.Replace(sBaseClassName & " const * _this,", "")
        pString = pString.Replace(sBaseClassName & "const * _this,", "")
        pString = pString.Replace(sBaseClassName & " const *_this,", "")

        pString = pString.Replace(sBaseClassName & "const * _this", "")
        pString = pString.Replace(sBaseClassName & " const * _this", "")
        pString = pString.Replace(sBaseClassName & " const *_this", "")

        pString = pString.Replace(sBaseClassName & " * _this,", "")
        pString = pString.Replace(sBaseClassName & "* _this,", "")
        pString = pString.Replace(sBaseClassName & " *_this,", "")

        pString = pString.Replace(sBaseClassName & "* _this", "")
        pString = pString.Replace(sBaseClassName & " * _this", "")
        pString = pString.Replace(sBaseClassName & " *_this", "")

        Return pString
    End Function


    Public Function SetupInheritedClassesWithoutVFT() As List(Of cClass)
        Dim oVFTMissingInheritedClasses As List(Of cClass)
        oVFTMissingInheritedClasses = New List(Of cClass)


        oVFTMissingInheritedClasses.Add(New cClass("CUI_Event", "COSTimer"))

        'CAca_CheckTOUSignalList()
        'CAca_ActivatePassiveObjectsList()
        'CAca_DayMonth()
        'CAca_HoursMinutes()
        'CAca_DayMonthYear()
        'CAca_ExceptionDayEntry()
        'CAca_WeekProfileEntry()
        'CAca_SeasonEntry()
        'CAca_DayProfileEntry()
        'CAca_DayTable()
        'CAca_Calendar()
        'CAca_IndexData()
        'CAca_BackupRamData()
        'CAca_FastAccessData()
        'CAca_PersistenData()
        'CAca_VolatileRamData()
        'CADC_RamData()
        'CAMIS_RamData()
        'CAvb_VolatileRamData()
        'CAvb_FastAccessData()
        'CBcu_ButtonStatus()
        'CBcu_FastAccessData()
        'CBcu_VolatileRamData()
        'CBcu_BackupRamData()
        'CBcu_QueMessage()
        'CBPR_BackupRamData()
        'CBPR_FastAccessData()
        'CBPR_PersistentData()
        'CBPR_VolatileRamData()
        'CBRB_BackupRamData()
        'CBRB_FastAccessData()
        'CBSI_FastAccessData()
        'CBSI_VolatileRamData()
        'CEmd_MemoryAreaListEntry()
        'CCr_FastAccessData()
        'CCr_VolatileRamData()
        'CDab_AttrToSecGroupList()
        'CDab_AttrSuppSelectorsList()
        'CDab_PropertyDescriptor()
        'CDavb_PutObjectlistStates()
        'CDavb_CommonParameterSet()
        'CDbh_BufferState()
        'CDDA_Handler()
        'CDDA_ServerInfo()
        'CDlb_RamData()
        'CDMA_ApplicationInterfaceRamData()
        'CDMA_RegisterStructure()
        'CDMA_ChannelRegisterStructure()
        'CDSU_DemandSupervisionApplicationFastAccessData()
        'CDSU_DemandSupervisionApplicationVolatileRamData()
        'CDsu_RingDemandSupervisionBuffer()
        'CDSU_DemandSupervisionRegisterBackupRamData()
        'CDSU_DemandSupervisionRegisterFastAccessData()
        'CDSU_DemandSupervisionRegisterPersistentData()
        'CDSU_DemandSupervisionRegisterVolatileRamData()
        'CDvr_ResolutionData()
        'CDvr_FastAccessData()
        'CDvr_PersistentData()
        'CDvr_VolatileRamData()
        'CEmd_DataFastAccess()
        'CEmd_DataRamBackup()
        'CEmd_DataVolatileRam()
        'CEMD_QueMessage()
        'CEmd_RegularChecksumCheckTimer()
        'CEmd_CommandRegularChecksumCheckRamData()
        'CEventQueueMessage()
        'CEHT_EventHandlerList()
        'CEHT_EventHandlerListSimple()
        'CELG_FastAccessData()
        'CELG_VolatileRamData()
        'CELG_BackupRamData()
        'CGas_ActionScript()
        'CGas_BackupRamData()
        'CGas_FastAccesData()
        'CGas_VolatileRamData()
        'CGat_QueueMessage()
        'CGat_CommandListElementRamData()
        'CGat_CommandListElementSimple()
        'CGcr_BackupRamData()
        'CGcr_PersistentData()
        'CGvc_FastAccessData()
        'CGvc_VolatileRamData()
        'Ci2c_drv_data()
        'CI2C_HW()
        'CIcu_InputStatus()
        'CIcu_FastAccessData()
        'CIcu_BackupRamData()
        'CIcu_InputHandler()
        'CIcu_VolatileRamData()
        'CIcu_QueMessage()
        'CIhu_TimeMessage()
        'CIhu_RequestedMessage()
        'CIhu_FrozenValuesHourly()
        'CIhu_FrozenValuesDailyOther()
        'CIhu_FrozenValuesDaily()
        'CIhu_FrozenValuesMonthlyOthers()
        'CIhu_FrozenValuesMonthly()
        'CIhu_FrozenValues()
        'CIhu_PersistentData()
        'CIhu_BackupRamData()
        'CIhu_VolatileRamData()
        'CIhu_FastAccessData()
        'CIhu_DataHistoryControl()
        'CIhu_DataHistory_GeneralDigest()
        'CIhu_DataHistory_DigestHourly()
        'CIhu_DataHistory_DigestElectricityDaily()
        'CIhu_DataHistory_DigestElectricityMonthly()
        'CIhu_DataHistory_DigestOtherDaily()
        'CIhu_DataHistory_DigestOtherMonthly()
        'CIhu_DataHistory_Digest()
        'CIhu_QueueMsg()
        'CIhu_DigestEntryOtherDaily()
        'CIhu_DigestEntryElectricityDaily()
        'CIhu_InstantaneousData()
        'CIhu_Message_Configuration()
        'CIhu_Message_TextUpdate()
        'CIhu_Message_Update()
        'CIhu_Message_UpdateDaily()
        'CIhu_Message_UpdateMonthly()
        'CIhu_Message_Digest()
        'CIhu_Message_DigestElectricityDaily()
        'CIhu_Message_DigestElectricityMonthly()
        'CIhu_Message_DigestHourly()
        'CIhu_Message_DigestOtherDaily()
        'CIhu_Message_DigestOtherMonthly()
        'CIhu_Message_CatchUpRequest()
        'CIhu_Message_MeterIdentification()
        'CIhu_Message()
        'CInputStatusInfo()
        'CInputHandler()
        'CInputHandlerInterface()
        'CIpa_InstantPulseOutputApplicationFastAccessData()
        'CIpa_InstantPulseOutputApplicationVolatileRamData()
        'CIpo_FastAccessData()
        'CIpo_Impulsconstant()
        'CIpo_OutputTypeData()
        'CIpo_CreepData()
        'CIpo_RamData()
        'CIpo_VolatileRamData()
        'CIpo_PersistentData()
        'CIpo_OutputControl()
        'CIta_CommandParameter()
        'CIta_IdentifierStructure()
        'CIta_ImageStructure01()
        'CIta_InfoStucture()
        'CIta_FastAccessData()
        'CIta_PersistentData()
        'CIta_RamBackupData()
        'CIta_VolatileRamData()
        'CLCDDeviceDriver()
        'CLCD_DisplayInterface()
        'CLPR_SrcStruct()
        'CLPR_NTAMsgStruct()
        'CLPR_IHUMsgStruct()
        'CLPR_ReadWriteStruct()
        'CLPR_StatusStruct()
        'CLPR_LPRViewStruct()
        'CLPR_IHUViewStruct()
        'CLPR_FastAccessData()
        'CLPR_VolatileRamData()
        'CLrb_EmergencyProfile()
        'CLrb_MonitoredValue()
        'CLrb_ActionScript()
        'CLrb_BackupRamData()
        'CLrb_FastAccessData()
        'CLrb_VolatileRamData()
        'CMBUS_LlcFastAccessData()
        'CMBUS_PhyRamData()
        'CMBUS_RegisterFastAccessData()
        'CMBUS_RegisterBackupRamData()
        'CMBUS_BackupRamData()
        'CMBUS_CaptureItem()
        'CMBUS_RawValue()
        'CMBUS_Configuration()
        'CMBUS_FastAccessData()
        'CMBUS_PersistentData()
        'CMBUS_VolatileRamData()
        'CMBUS_Message()
        'CMBUS_WirelessLinkVolatileRamData()
        'CMca_DaylightSavingsTime()
        'CMca_DaylightSavingSwitchTimes()
        'CMca_TimeStamp()
        'CMca_PowerDownData()
        'CMca_TimeDate()
        'CMca_StatusToSetByShiftTime()
        'CMca_BackupRamData()
        'CMca_FastAccesData()
        'CMca_PersistentData()
        'CMca_VolatileRamData()
        'CMca_QueMessage()
        'CMda_MeterDemandApplicationFastAccessData()
        'CMda_MeterDemandApplicationVolatileRamData()
        'CMda_MaximBackupRamData()
        'CMda_MaximDigitsEnergy()
        'CMda_MaximFastAccessData()
        'CMda_MaximEnergyValue()
        'CMda_MaximPersistentData()
        'CMda_MaximVolatileRamData()
        'CMdr_BackupRamData()
        'CMdr_DigitsEnergy()
        'CMdr_FastAccessData()
        'CMdr_PersistentData()
        'CMdr_VolatileRamData()
        'CMev_ValueStruct()
        'CMev_FastAccessData()
        'CMev_VolatileRamData()
        'CMev_AttributeDescr()
        'CMev_MeterValueBaseSimple()
        'CMev_BackupStorage()
        'CMPB_CaptureObjectInfo()
        'CMPB_CaptureObjectData()
        'CMPB_ReadSelector()
        'CMPB_BackupRamData()
        'CMPB_FastAccessData()
        'CMPB_VolatileRamData()
        'CMPB_PersistentData()
        'CMRB_DigitsEnergy()
        'CMRB_BackupRamData()
        'CMRB_FastAccessData()
        'CMRB_PersistentData()
        'CMsb_FastAccessData()
        'CMsb_VolatileRamData()
        'CMsb_PersistentData()
        'CMsb_MeasurementValue()
        'CMsb_DiagnosticValue()
        'CMsm_BridgeNewValueList()
        'CMsm_BridgeNewValueListSimple()
        'CMSM_Driver()
        'CMSM_Mmi3DeviceDriver()
        'CalBitParameterData()
        'CMSM_PhaseCalibrationData()
        'CMSM_CalibrationData()
        'CMSM_DCField()
        'CMSM_EnergyTypeOnLed()
        'CMSM_ParameterValues_ErrorCounters()
        'CMSM_ParameterValues_FastAccessData()
        'CMSM_ParameterValues_VolatileRamData()
        'CMSM_ParameterValues_BackupRamData()
        'CMSM_ParameterValues_PersistentData()
        'CMSM_Utilities()
        'CMUP_BackupRamData()
        'CMUP_FastAccessData()
        'CMUP_VolatileRamData()
        'CMUP_PersistentData()
        'COcu_OutputControl()
        'COcu_FastAccessData()
        'COcu_BackupRamData()
        'COcu_VolatileRamData()
        'COhd_RamData()
        'COTR_BackupRamData()
        'COTR_FastAccessData()
        'COTR_PersistentData()
        'COTR_VolatileRamData()
        'CPAB_RamData()
        'CPdl_Message()
        'CPDT_ListEntry()
        'CPLAN_ase()
        'CPLAN_aseFrame()
        'CPLAN_ciaseVolatileData()
        'CPLAN_ciaseFastAccessData()
        'CPLAN_llcFrame()
        'CPLAN_llc()
        'CPLAN_macFrame()
        'CPLAN_macSyncInfo()
        'CPLAN_macDeSyncInfo()
        'CPLAN_macFrameStats()
        'CPLAN_macDataStats()
        'CPLAN_macPersistentData()
        'CPLAN_macVolatileRamData()
        'CPLAN_macFastAccessData()
        'CPLAN_macBackupRamData()
        'CPLAN_Config()
        'CPpf_AveragePFReg_BackupRamData()
        'CPpf_AveragePFReg_FastAccessData()
        'CPpf_AveragePFReg_PersistentData()
        'CPpf_AveragePFReg_VolatileRamData()
        'CPpf_MinPFReg_BackupRamData()
        'CPpf_MinPFReg_FastAccessData()
        'CPpf_MinPFReg_PersistentData()
        'CPpf_MinPFReg_VolatileRamData()
        'CPqm_Application_VolatileRamData()
        'CPqm_LevelMonitor_VolatileRamData()
        'CPqm_LevelMonitor_FastAccessData()
        'CPqm_LevelMonitor_PersistentData()
        'CPqm_ActionItem()
        'CPqm_ActionSet()
        'CPqm_EventSet()
        'CPqm_MonitoredValue()
        'CPqm_Monitor_VolatileRamData()
        'CPqm_Monitor_BackupRamData()
        'CPqm_Monitor_PersistentData()
        'CPqm_Monitor_FastAccessData()
        'CPqm_Threshold_FastAccessData()
        'CPST_persistentShutdownReason()
        'CPST_ApplicationTaskInfo()
        'CPTA_persistentState()
        'CPTA_persistentRtcCalibration()
        'CPTA_IecDlmsInterface()
        'CPTA_WriteInterface()
        'CPth_FastAccessData()
        'CPth_VolatileRamData()
        'CPth_State()
        'CRal_CallBack()
        'CRal_EventAction()
        'CRal_RegisterAlarmFastAccessData()
        'CRal_RegisterAlarmVolatileRamData()
        'CRea_VolatileRamData()
        'CRea_FastAccessData()
        'CRea_BackupRamData()
        'CRea_PersistentData()
        'CRee_EnergyValue()
        'CRee_RegisterEnergyBackupRamData()
        'CRee_RegisterEnergyFastAccessData()
        'CRee_RegisterEnergyPersistentData()
        'CRee_RegisterEnergyVolatileRamData()
        'CReg_RegisterFastAccessData()
        'CReg_RegisterVolatileRamData()
        'CRer_RegisterErrorBackupRamData()
        'CRer_EventAction()
        'CRer_RegisterErrorFastAccessData()
        'CRer_RegisterErrorVolatileRamData()
        'CRes_RegisterStringPersistentData()
        'CRes_RegisterStringBackupRamData()
        'CRes_RegisterStringFastAccessRamData()
        'CRes_RegisterStringVolatileRamData()
        'CRrt_Timer()
        'CRTC_RamData()
        'SCI_drv_data()
        'CSEC_SecurityAttributeBase()
        'CSEC_SecuritySystemSessionAttribute()
        'CSEC_SecuritySystemSession()
        'CSEC_SecurityLevel()
        'CSEC_SecuritySystem()
        'CSed_Vaa()
        'CSed_VaaAccessFastAccessData()
        'CSed_VaaAccessPersistentData()
        'CSed_VaaAccessBackupRamData()
        'CSed_VaaAccessVolatileRamData()
        'CSed_VaaDefinitionBackupRamData()
        'CSed_VaaDefinitionFastAccessData()
        'CSed_VaaDefinitionPersistentData()
        'CSed_VaaDefinitionVolatileRamData()
        'CSed_SecurityMaterial()
        'CSPI_ApplicationInterfaceRamData()
        'CSta_Control()
        'CSta_BackupRamData()
        'CStc_ExecutionMethod()
        'CStc_ScriptAction()
        'CStc_ScriptElement()
        'CStc_FastAccessData()
        'CStc_VolatileRamData()
        'CTea_ProbeActionNode()
        'CTea_PersistentData()
        'CTea_FastAccessData()
        'CTea_BackupRamData()
        'CTea_VolatileRamData()
        'CTER_BackupRamData()
        'CTER_FastAccessData()
        'CTER_PersistentData()
        'CTER_VolatileRamData()
        'CTIM_RamData()
        'CTIM_ParameterReload()
        'CTIM_ParameterPwmOut()
        'CTIM_ParameterPwmOutChannel()
        'CTIM_ParameterSquareOut()
        'CTIM_ParameterExtClkDownCounter()
        'CTIM_ParameterExtTriggerInput()
        'CTmon_TamperHandler()
        'CTmon_BackupData()
        'CTmon_VolatileRamData()
        'CTmon_FastAccessData()
        'CUI_DisplayArrowDef()
        'CUI_DisplayArrowFastAccessData()
        'CUI_DisplayItem()
        'CUI_ObjectFormat()
        'CUI_DisplayListFastAccessData()
        'CUI_DisplayListPersistentData()
        'CUI_DisplayListVolatileRamData()
        'CUI_statusVolatileData()
        'CUI_statusFastAccessData()
        'CUI_statusRamBackupData()
        'CWDT_TaskInfo()
        'CWWDG()

        Return oVFTMissingInheritedClasses
    End Function

    Function IsAClass(ByVal pName As String)
        Dim i As Integer
        For i = 0 To oClasses.Count - 1
            If oClasses(i).sClassName.Contains(pName) Then
                Return True
            End If
        Next
        Return False
    End Function

    Function FixWords(ByVal sLine As String) As String
        Dim words() As String
        Dim words2() As String
        Dim words3() As String
        Dim words4() As String
        Dim o As Integer

        If sLine.StartsWith("typedef ") = False Then
            words4 = sLine.Split(")"c)
            For o = 0 To words4.Count - 1
                words3 = words4(o).Split("("c)
                Dim u As Integer
                For u = 0 To words3.Count - 1
                    words = words3(u).Split(" "c)
                    For i = 0 To words.Count - 1

                        words2 = words(i).Split(","c)
                        For z = 0 To words2.Count - 1
                            If words2(z).Contains("getFirstInstanceBy") = False And words2(z).Contains("getNextInstanceBy") = False Then ' hard coded fix
                                If words2(z).EndsWith("Type") And words2(z).EndsWith("EnumType") = False Then
                                    If IsAClass(words2(z).Substring(0, words2(z).Length - 4)) Then
                                        words2(z) = "C" & words2(z).Substring(0, words2(z).Length - 4)
                                    End If
                                End If

                                If words2(z).EndsWith("Type*") And words2(z).EndsWith("EnumType*") = False Then 'And words2(z).StartsWith("*") = False
                                    If IsAClass(words2(z).Substring(0, words2(z).Length - 5)) Then
                                        words2(z) = "C" & words2(z).Substring(0, words2(z).Length - 5) & "*"
                                    End If
                                End If
                            End If
                        Next
                        words(i) = String.Join(","c, words2)
                    Next
                    words3(u) = String.Join(" "c, words)
                Next
                words4(o) = String.Join("("c, words3)
            Next
            sLine = String.Join(")", words4)
        End If
        Return sLine
    End Function
End Module
