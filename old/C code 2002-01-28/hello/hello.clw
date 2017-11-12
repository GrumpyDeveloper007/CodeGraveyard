; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=FU
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "hello.h"

ClassCount=2
Class1=CMainWindow

ResourceCount=6
Resource1="MAINMENU"
Resource2="MAINACCELTABLE"
Resource3="ABOUTBOX"
Resource4=IDR_MAINFRAME
Resource5=IDD_ABOUTBOX
Class2=FU
Resource6=IDD_FU

[CLS:CMainWindow]
Type=0
HeaderFile=hello.h
ImplementationFile=hello.cpp
LastObject=CMainWindow
Filter=T
BaseClass=CFrameWnd 
VirtualFilter=fWC

[MNU:"MAINMENU"]
Type=1
Command1=IDM_ABOUT
CommandCount=1
Class=?

[ACL:"MAINACCELTABLE"]
Type=1
Command1=IDM_ABOUT
CommandCount=1
Class=?

[DLG:"ABOUTBOX"]
Type=1
ControlCount=5
Control1=IDC_STATIC,static,1342308353
Control2=IDC_STATIC,static,1342308353
Control3=IDC_STATIC,static,1342308353
Control4=IDC_STATIC,static,1342308353
Control5=IDOK,button,1342373889
Class=?

[MNU:IDR_MAINFRAME]
Type=1
Class=CMainWindow
Command1=ID_APP_ABOUT
Command2=me
CommandCount=2

[ACL:IDR_MAINFRAME]
Type=1
Class=?
Command1=ID_APP_ABOUT
CommandCount=1

[DLG:IDD_ABOUTBOX]
Type=1
Class=?
ControlCount=5
Control1=IDC_STATIC,static,1342308353
Control2=IDC_STATIC,static,1342308353
Control3=IDC_STATIC,static,1342308353
Control4=IDC_STATIC,static,1342308353
Control5=IDOK,button,1342373889

[DLG:IDD_FU]
Type=1
Class=FU
ControlCount=2
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816

[CLS:FU]
Type=0
HeaderFile=FU.h
ImplementationFile=FU.cpp
BaseClass=CDialog
Filter=D

