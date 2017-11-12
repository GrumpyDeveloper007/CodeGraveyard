VERSION 5.00
Begin VB.Form FrmOptions 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Options"
   ClientHeight    =   5295
   ClientLeft      =   6150
   ClientTop       =   3525
   ClientWidth     =   5325
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   353
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   355
   Begin VB.TextBox TxtProgramName 
      Enabled         =   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   10
      Top             =   2040
      Width           =   3735
   End
   Begin VB.CommandButton CMDSetProgram 
      Caption         =   "Program"
      Height          =   375
      Left            =   4080
      TabIndex        =   9
      Top             =   2040
      Width           =   1095
   End
   Begin VB.CheckBox ChkEnableUserInput 
      Caption         =   "Enable user input"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   600
      Width           =   5055
   End
   Begin VB.TextBox TxtGFXFontSize 
      Enabled         =   0   'False
      Height          =   375
      Left            =   3120
      TabIndex        =   6
      Top             =   1560
      Width           =   735
   End
   Begin VB.TextBox TxtGFXFontName 
      Enabled         =   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   1560
      Width           =   2295
   End
   Begin VB.CommandButton CMDGFXFont 
      Caption         =   "GFX Font"
      Height          =   375
      Left            =   4080
      TabIndex        =   4
      Top             =   1560
      Width           =   1095
   End
   Begin VB.CommandButton CmdSetPrinter 
      Caption         =   "Printer"
      Height          =   375
      Left            =   4080
      TabIndex        =   3
      Top             =   1080
      Width           =   1095
   End
   Begin VB.TextBox TxtPrinterName 
      Enabled         =   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   1080
      Width           =   3735
   End
   Begin VB.CommandButton CMDClose 
      Caption         =   "Close"
      Height          =   375
      Left            =   2160
      TabIndex        =   1
      Top             =   4800
      Width           =   1095
   End
   Begin VB.CheckBox CHKEnableProgramPrint 
      Caption         =   "Enable print operation in program"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   240
      Width           =   5055
   End
   Begin VB.Label LblFontSize 
      Caption         =   "Size"
      Height          =   375
      Left            =   2520
      TabIndex        =   7
      Top             =   1560
      Width           =   495
   End
End
Attribute VB_Name = "FrmOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
''
'' Coded by Dale Pitman
''

Private vPrinterName As String
Private vEnableProgPrint As Boolean
Private vGFXFont As String
Private vGFXFontSize As String
Private vEnableUserInput As Boolean
Private vProgramName As String              '' Current program name
Private vProgramOptionName As String        '' Option file associated with program

''
Public Property Get EnableUserInput() As String
    EnableUserInput = vEnableUserInput
End Property

''
Public Property Get GFXFontSize() As String
    GFXFontSize = vGFXFontSize
End Property

''
Public Property Get GFXFont() As String
    GFXFont = vGFXFont
End Property

''
Public Property Get EnableProgramPrint() As Boolean
    EnableProgramPrint = vEnableProgPrint
End Property

''
Public Property Get printerName() As String
    printerName = vPrinterName
End Property

''
Public Property Let printerName(Name As String)
    vPrinterName = Name
End Property

''
Public Property Get ProgramName() As String
    ProgramName = vProgramName
End Property

''
Public Property Let ProgramName(Name As String)
    vProgramName = Name
End Property

''
Public Property Get ProgramOptionName() As String
    ProgramOptionName = vProgramOptionName
End Property

'' Load options from database
Public Sub InitOptions()
    Dim FileID As Long
    Dim TempLine As String
    FileID = FreeFile
    
    'Check if exists
    If (Dir(ProgPath & "options.txt") = "") Then
        ' Unable to load options, so load defaults
        vPrinterName = Printers(0).DeviceName
        vEnableProgPrint = False
        vGFXFont = "Verdana"
        vGFXFontSize = 8
        vEnableUserInput = False
        vProgramName = ""
        vProgramOptionName = ""
    Else
        Open ProgPath & "Options.txt" For Input As #FileID
        Do While (EOF(FileID) = False)
            Line Input #FileID, TempLine
            Select Case UCase$(strings.GetLeftValue(TempLine))
                Case "PRINTER"
                    vPrinterName = strings.GetRightValue(TempLine)
                Case "PROGRAMPRINT"
                    vEnableProgPrint = strings.GetRightValue(TempLine)
                Case "GFXFONT"
                    vGFXFont = strings.GetRightValue(TempLine)
                Case "GFXFONTSIZE"
                    vGFXFontSize = strings.GetRightValue(TempLine)
                Case "ENABLEUSERINPUT"
                    vEnableUserInput = strings.GetRightValue(TempLine)
                Case "PROGRAM"
                    vProgramName = strings.GetRightValue(TempLine)
                    vProgramOptionName = "A-" & strings.GetRightValue(TempLine)
                Case Else
                    ' Unknown option
            End Select
        Loop
        Close #FileID
    End If
            
End Sub

''
Public Sub SaveOptions()
    Dim FileID As Long
    FileID = FreeFile
    Open ProgPath & "Options.txt" For Output As #FileID
    Print #FileID, "PRINTER=" & vPrinterName
    Print #FileID, "PROGRAMPRINT=" & vEnableProgPrint
    Print #FileID, "GFXFONT=" & vGFXFont
    Print #FileID, "GFXFONTSIZE=" & vGFXFontSize
    Print #FileID, "ENABLEUSERINPUT=" & vEnableUserInput
    Print #FileID, "PROGRAM=" & vProgramName
    Close #FileID
End Sub

''
Private Sub CHKEnableProgramPrint_Click()
    If (CHKEnableProgramPrint.value = vbChecked) Then
        vEnableProgPrint = True
    Else
        vEnableProgPrint = False
    End If
End Sub

Private Sub ChkEnableUserInput_Click()
    If (ChkEnableUserInput.value = vbChecked) Then
        vEnableUserInput = True
    Else
        vEnableUserInput = False
    End If
End Sub

''
Private Sub CMDClose_Click()
    Call Me.Hide
End Sub

''
Private Sub CMDGFXFont_Click()
    FrmMain.FileAccess.FontName = vGFXFont
    FrmMain.FileAccess.FontSize = vGFXFontSize
    FrmMain.FileAccess.Flags = cdlCFScreenFonts
    FrmMain.FileAccess.ShowFont
    vGFXFont = FrmMain.FileAccess.FontName
    vGFXFontSize = FrmMain.FileAccess.FontSize
    TxtGFXFontName.Text = vGFXFont
    TxtGFXFontSize.Text = vGFXFontSize
'    GFXFont
End Sub

''
Private Sub CmdSetPrinter_Click()
    FrmMain.FileAccess.ShowPrinter
    vPrinterName = Printer.DeviceName
    TxtPrinterName.Text = vPrinterName
End Sub

''
Private Sub CMDSetProgram_Click()
    Call FrmProgramSelect.Show
    TxtProgramName.Text = vProgramName
End Sub

'' Load controls with current settings
Private Sub Form_Load()
    Call MDICenterScreen(Me)
    TxtPrinterName.Text = vPrinterName
    If (vEnableProgPrint = True) Then
        CHKEnableProgramPrint.value = vbChecked
    Else
        CHKEnableProgramPrint.value = vbUnchecked
    End If
    If (vEnableUserInput = True) Then
        ChkEnableUserInput.value = vbChecked
    Else
        ChkEnableUserInput.value = vbUnchecked
    End If
    TxtGFXFontName.Text = vGFXFont
    TxtGFXFontSize.Text = vGFXFontSize
    TxtProgramName.Text = vProgramName
End Sub

