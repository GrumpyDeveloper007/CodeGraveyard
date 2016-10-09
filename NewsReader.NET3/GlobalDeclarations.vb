Option Strict Off
Option Explicit On
Module GlobalDeclarations
	''*************************************************************************
	''
	'' Coded by Dale Pitman
	''
	
	
	
    'Public Declare Function CopyTo Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef InBuffer() As Byte, ByVal Size As Integer, ByRef OutBuffer() As Byte, ByRef WriteMax As Integer, ByVal DataStart As Integer) As Integer

    'Public Declare Function GetCRC2 Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef Buffer() As Byte, ByVal Size As Integer, ByRef Buffer2() As Byte, ByVal BufferSize As Integer) As Integer
    'Public Declare Function CopyArray Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef InBuffer() As Byte, ByVal Size As Integer, ByRef OutBuffer() As Byte, ByVal DestStart As Integer) As Integer
    'Public Declare Function Base64 Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef InBuffer() As Byte, ByRef OutBuffer() As Byte, ByVal pInPtr As Integer, ByVal pOutPtr As Integer) As Integer
    'Public Declare Function ReadLine Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef pBinaryBuffer() As Byte, ByVal pBufferSize As Integer, ByRef pLineCursor As Integer, ByRef pString As String) As Integer

    Public Sub CopyArray(ByRef InBuffer() As Byte, ByVal Size As Integer, ByRef OutBuffer() As Byte, ByVal DestStart As Integer)
        Dim i As Integer
        For i = 0 To Size - 1
            OutBuffer(DestStart + i) = InBuffer(i)
        Next
    End Sub

    Public Function CopyTo(ByRef InBuffer() As Byte, ByVal Size As Integer, ByRef OutBuffer() As Byte, ByRef WriteMax As Integer, ByVal DataStart As Integer) As Integer
        Dim c As New NewsReaderSupport.NewsReaderSupportClass
        Return c.CopyTo(InBuffer, Size, OutBuffer, WriteMax, DataStart)
    End Function

    Public Function GetCRC2(ByRef Buffer() As Byte, ByVal Size As Integer, ByRef Buffer2() As Byte, ByVal BufferSize As Integer) As UInteger
        Dim c As New NewsReaderSupport.NewsReaderSupportClass
        Return c.GetCRC2(Buffer, Size, Buffer2, BufferSize)
    End Function
    'Public Declare Function CopyArray Lib "D:\from c\coding\MyProjects\testdll\Release\testdll.dll" (ByRef InBuffer() As Byte, ByVal Size As Integer, ByRef OutBuffer() As Byte, ByVal DestStart As Integer) As Integer
    Public Function Base64(ByRef InBuffer() As Byte, ByRef OutBuffer() As Byte, ByVal pInPtr As Integer, ByVal pOutPtr As Integer) As Integer
        Dim c As New NewsReaderSupport.NewsReaderSupportClass
        Return c.Base64(InBuffer, OutBuffer, pInPtr, pOutPtr)
    End Function
    Public Function ReadLine(ByRef pBinaryBuffer() As Byte, ByVal pBufferSize As Integer, ByRef pLineCursor As Integer, ByRef pString As String) As Integer
        Dim c As New NewsReaderSupport.NewsReaderSupportClass
        Return c.ReadLine(pBinaryBuffer, pBufferSize, pLineCursor, pString)
    End Function


    ''
    Public Const cVersionNumber As String = " (05/10/2006)"
    Public Const cProjectName As String = "NewsReader"
    Public Const cRegistoryName As String = "NewReader"
    Public Const cProjectNameConst As String = "NewsReader" ' Used for licence validation
    Public Const cDatabaseName As String = "NewsReader.MDB"


    '' File paths
    'Public m_TempDownloadPath As String
    Public m_BytesFor2Second As Double
    Public m_BytesTotal As Double
    Public m_WSTime As Integer
    Public m_TotalTime As Integer
    Public m_BufferProcessing As Integer


    'Public vCrystalReport As CrystalReport

    ''
    '' Other Format Strings

    Public Const cLongFieldSize As String = "########"

    '' Used by lots of forms (all that have the following as children
    Public Enum ChildTypesENUM
        CustomerSearch = 1
    End Enum

    Public Structure GroupTYPE
        Dim Name As String
        Dim HighArticle As Integer
        Dim LowArticle As Integer
        Dim Postability As String
    End Structure

    Public m_Groups() As GroupTYPE
    Public m_MaxGroup As Integer

    Public Const cCurrencySymbol As String = "£" ' must be 1 char
    Public Const cCurrencyFormat As String = cCurrencySymbol & "#####0.00"

    Public Declare Function GetTickCount Lib "kernel32" () As Integer

    ''
    Public Function ShowForm(ByRef pform As System.Windows.Forms.Form) As Boolean
        Call pform.Show()
        'UPGRADE_WARNING: Form method pform.ZOrder has a new behavior. Click for more: 'ms-help://MS.VSCC.v90/dv_commoner/local/redirect.htm?keyword="6BA9B8D2-2A32-4B6E-8D36-44949974A5B4"'
        Call pform.BringToFront()
    End Function

    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    '' Registory stuff

    Private Function SetFormPicture(ByRef pFormname As System.Windows.Forms.Form) As Object
    End Function

    ''
    Public Sub AllFormsLoad(ByRef pform As System.Windows.Forms.Form)

    End Sub

    ''
    Public Sub AllFormsUnLoad(ByRef pform As System.Windows.Forms.Form)

    End Sub

    ''
    Public Sub AllFormsHide(ByRef pform As System.Windows.Forms.Form)

    End Sub

    ''
    Public Sub AllFormsShow(ByRef pform As System.Windows.Forms.Form)

    End Sub
End Module