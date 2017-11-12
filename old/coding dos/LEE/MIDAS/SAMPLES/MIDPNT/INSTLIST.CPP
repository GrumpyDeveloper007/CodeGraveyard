/*
 *      InstList.cpp
 *
 * MIDAS Module Player for Windows NT Instrument List View
 *
 * $Id: InstList.cpp 1.4 1997/01/14 17:42:08 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <string.h>
#include <windows.h>
#include <stdio.h>
#include "midasdll.h"
#include "MidpView.h"
#include "MidpNT.h"
#include "MidpModeless.h"
#include "InstList.h"
#include "MidpRes.h"
#include "ViewList.h"


LRESULT CALLBACK WindowProc(HWND hwnd, UINT message, WPARAM wparam,
    LPARAM lparam);



InstListView::InstListView(void)
{
    static WNDCLASS wc;

    /* Set up and register window class for the view window: */
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WindowProc;
    wc.cbClsExtra = 0;
    wc.cbWndExtra = sizeof(DWORD);
    wc.hInstance = instance;
    wc.hIcon = LoadIcon(instance, "GenericIcon");
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = NULL;
    wc.lpszMenuName = NULL;
    wc.lpszClassName = "midpInstList";
    if ( RegisterClass(&wc) == 0 )
        Panic("InstListView::InstListView:: RegisterClass() failed");

    window = NULL;
}


InstListView::~InstListView(void)
{
    if ( window != NULL )
    {
        delete window;
        window = NULL;
    }
}


char *InstListView::Name(void)
{
    return "InstListView";
}


char *InstListView::Description(void)
{
    return "Instrument List";
}


midpViewWindow *InstListView::CreateViewWindow(Registry *registry)
{
    if ( window != NULL )
        return (midpViewWindow*) window;
    window = new InstListWindow(0, this, registry);
    return (midpViewWindow*) window;
}


void InstListView::DestroyViewWindow(midpViewWindow *_window)
{
    if ( _window != window )
        Panic("InstListView::DestroyWindow: _window != window");

    delete window;
    window = NULL;
}




InstListWindow::InstListWindow(int instanceNumber, midpView *view,
    Registry *registry) :
    midpViewWindow(instanceNumber, view, registry)
{
    HWND        parent = NULL;

    if ( viewsChildren )
        parent = mainWinHandle;

    instanceNumber = instanceNumber;

    hwnd = CreateWindow(
        "midpInstList",                         /* class */
        "Instrument List",                      /* caption */
        WS_POPUPWINDOW | WS_CAPTION | WS_THICKFRAME | WS_VISIBLE,            /* style */
//        100, 100, 400, 200,
        startX,                                 /* init. x pos */
        startY,                                 /* init. y pos */
        startWidth,                             /* init. x size */
        startHeight,                            /* init. y size */
//        mainWinHandle,                          /* parent window */
        parent,
        NULL,                                   /* menu handle */
        instance,                               /* program handle */
        (LPVOID) this                           /* create parms */
    );

//    ShowWindow(hwnd, SW_SHOWDEFAULT);
//    UpdateWindow(hwnd);

    viewWindowList.AddWindow(this);
}



InstListWindow::~InstListWindow(void)
{
    viewWindowList.RemoveWindow(this);
    DestroyWindow(hwnd);
}



LRESULT CALLBACK InstListWindow::ClassWindowProc(HWND hwnd, UINT message,
    WPARAM wparam, LPARAM lparam)
{
    INT         tabstop = 4;
    hwnd = hwnd;
    wparam = wparam;
    lparam = lparam;

    switch ( message )
    {
        case WM_CREATE:
            listWinHandle = CreateWindow(
                "LISTBOX",
                NULL,
                WS_CHILD | WS_VISIBLE | WS_VSCROLL | WS_HSCROLL |
                    LBS_USETABSTOPS | LBS_NOINTEGRALHEIGHT,
                0, 0, 0, 0,             /* set size in WM_SIZE message */
                hwnd,                   /* parent window */
                NULL,                   /* edit control ID */
                instance,
                NULL);                  /* no window creation data */

            SendMessage(listWinHandle, LB_SETHORIZONTALEXTENT, 40, 0);
            SendMessage(listWinHandle, LB_SETTABSTOPS, 1, (LPARAM) &tabstop);

            UpdateList();
            return 0;

        case WM_SIZE:
            /* Make the list box the size of the window's client area: */
            MoveWindow(listWinHandle,
                0, 0,           /* starting x- and y-coordinates */
                LOWORD(lparam), /* width of client area          */
                HIWORD(lparam), /* height of client area         */
                TRUE);          /* repaint window                */
                //SetBkMode
            return 0;

        case WM_CLOSE:
            DestroyWindow(listWinHandle);
            ownerView->DestroyViewWindow(this);
            return 0;

        case MIDPMSG_SONGCHANGED:
            UpdateList();
            return 0;

        default:
            return(DefWindowProc(hwnd, message, wparam, lparam));
    }
}


void InstListWindow::UpdateList(void)
{
    unsigned    i;
    char        str[128];
    char        name[64];
    HFONT       oldFont, font;
    HDC         hdc;
    SIZE        size;
    int         extent = 0;
    MIDASmoduleInfo moduleInfo;
    MIDASinstrumentInfo instrumentInfo;

    font = (HFONT) SendMessage(listWinHandle, WM_GETFONT, 0, 0);
    hdc = GetDC(listWinHandle);
    oldFont = SelectObject(hdc, font);

    SendMessage(listWinHandle, LB_RESETCONTENT, 0, 0);
    if ( module != NULL )
    {
        MIDASgetModuleInfo(module, &moduleInfo);

        for ( i = 0; i < moduleInfo.numInstruments; i++ )
        {
            MIDASgetInstrumentInfo(module, i, &instrumentInfo);
            OemToChar(instrumentInfo.instName, name);
            sprintf(str, "%02X\t%s", i+1, name);
            SendMessage(listWinHandle, LB_ADDSTRING, 0, (LPARAM) str);
            if ( !GetTextExtentPoint32(hdc, str, strlen(str), &size) )
            {
                sprintf(str, "ListViewWindow::UpdateList: GetTextExtentPoint"
                    "32 fails (%i)", GetLastError());
                Panic(str);
            }
            if ( size.cx > extent )
                extent = size.cx;
        }
    }

    SendMessage(listWinHandle, LB_SETHORIZONTALEXTENT, extent, 0);

    SelectObject(hdc, oldFont);
}


static LRESULT CALLBACK WindowProc(HWND hwnd, UINT message, WPARAM wparam,
    LPARAM lparam)
{
    InstListWindow *window;
    LPCREATESTRUCT cs;

    if ( message == WM_NCCREATE )
    {
        cs = (LPCREATESTRUCT) lparam;
        window = (InstListWindow*) cs->lpCreateParams;
        SetWindowLong(hwnd, GWL_USERDATA, (LONG) window);
    }

    window = (InstListWindow*) GetWindowLong(hwnd, GWL_USERDATA);

    return window->ClassWindowProc(hwnd, message, wparam, lparam);
}


/*
 * $Log: InstList.cpp $
 * Revision 1.4  1997/01/14 17:42:08  pekangas
 * Changed to use MIDAS DLL API
 *
 * Revision 1.3  1996/08/13 20:23:40  pekangas
 * #included stdio.h as MIDAS rawfile.h no longer does that
 *
 * Revision 1.2  1996/07/16  19:25:13  pekangas
 * Removed Visual C warnings, Added RCS keywords, converted to LFs
 *
*/