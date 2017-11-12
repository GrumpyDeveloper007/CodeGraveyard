/*
 *      SongInfo.cpp
 *
 * MIDAS Module Player for Windows NT Song Information View
 *
 * $Id: SongInfo.cpp 1.3 1997/01/14 17:42:08 pekangas Exp $
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "midasdll.h"
#include "MidpView.h"
#include "MidpNT.h"
#include "MidpModeless.h"
#include "SongInfo.h"
#include "MidpRes.h"
#include "ViewList.h"


static BOOL CALLBACK DialogProc(HWND hwnd, UINT message, WPARAM wparam,
    LPARAM lparam);



SongInfoView::SongInfoView(void)
{
    window = NULL;
}


SongInfoView::~SongInfoView(void)
{
    if ( window != NULL )
    {
        delete window;
        window = NULL;
    }
}


char *SongInfoView::Name(void)
{
    return "SongInfoView";
}


char *SongInfoView::Description(void)
{
    return "Song Information";
}


midpViewWindow *SongInfoView::CreateViewWindow(Registry *registry)
{
    if ( window != NULL )
        return (midpViewWindow*) window;
    window = new SongInfoWindow(0, this, registry);
    return (midpViewWindow*) window;
}


void SongInfoView::DestroyViewWindow(midpViewWindow *_window)
{
    if ( _window != window )
        Panic("SongInfoView::DestroyWindow: _window != window");

    delete window;
    window = NULL;
}




SongInfoWindow::SongInfoWindow(int instanceNumber, midpView *view,
    Registry *registry) :
    midpViewWindow(instanceNumber, view, registry)
{
    HWND        parent = NULL;

    if ( viewsChildren )
        parent = mainWinHandle;

    instanceNumber = instanceNumber;
//    modeless.hwnd = hwnd = CreateDialogParam(instance, "SONGINFO", NULL,
//        (DLGPROC) DialogProc, (LPARAM) this);

    modeless.hwnd = hwnd = CreateDialogParam(instance, "SONGINFO",
        parent, (DLGPROC) DialogProc, (LPARAM) this);

    midpModelessList.AddItem(&modeless);
    viewWindowList.AddWindow(this);
}



SongInfoWindow::~SongInfoWindow(void)
{
    viewWindowList.RemoveWindow(this);
    midpModelessList.RemoveItem(&modeless);
    DestroyWindow(hwnd);
}



static BOOL CALLBACK DialogProc(HWND hwnd, UINT message, WPARAM wparam,
    LPARAM lparam)
{
    SongInfoWindow *window;

    if ( message == WM_INITDIALOG )
            SetWindowLong(hwnd, GWL_USERDATA, lparam);

    window = (SongInfoWindow*) GetWindowLong(hwnd, GWL_USERDATA);

    return window->ClassDialogProc(hwnd, message, wparam, lparam);
}


BOOL CALLBACK SongInfoWindow::ClassDialogProc(HWND hwnd, UINT message,
    WPARAM wparam, LPARAM lparam)
{
    hwnd = hwnd;
    wparam = wparam;
    lparam = lparam;

    switch ( message )
    {
        case WM_INITDIALOG:
            this->hwnd = hwnd;
            SendDlgItemMessage(hwnd, SONGINFO_SONG, EM_LIMITTEXT, 255, 0);
            SendDlgItemMessage(hwnd, SONGINFO_COMPOSER, EM_LIMITTEXT, 255, 0);
            SendDlgItemMessage(hwnd, SONGINFO_COMMENT, EM_LIMITTEXT, 255, 0);
            UpdateInfo();
            SendDlgItemMessage(hwnd, SONGINFO_SONG, EM_SETSEL, (unsigned) -1,
                255);
            SetWindowPos(hwnd, NULL, 0, 0, 17, 42, SWP_NOSIZE | SWP_NOREDRAW
                 | SWP_NOZORDER | SWP_NOACTIVATE);
            if ( startX != CW_USEDEFAULT )
                SetWindowPos(hwnd, NULL, startX, startY, 17, 42,
                    SWP_NOSIZE | SWP_NOREDRAW | SWP_NOZORDER | SWP_NOACTIVATE);
            return TRUE;

        case WM_CLOSE:
            ownerView->DestroyViewWindow(this);
            return TRUE;

        case MIDPMSG_SONGCHANGED:
            UpdateInfo();
            return TRUE;

        case WM_COMMAND:
            switch ( LOWORD(wparam) )
            {
                case IDCANCEL:
                    ownerView->DestroyViewWindow(this);
                    return TRUE;
            }

    }

    return FALSE;
}


void SongInfoWindow::UpdateInfo(void)
{
    MIDASmoduleInfo moduleInfo;

    if ( module != NULL )
    {
        MIDASgetModuleInfo(module, &moduleInfo);
        SendDlgItemMessage(hwnd, SONGINFO_SONG, WM_SETTEXT, 0,
            (LPARAM)(LPCTSTR) moduleInfo.songName);
    }
    else
    {
        SendDlgItemMessage(hwnd, SONGINFO_SONG, WM_SETTEXT, 0,
            (LPARAM)(LPCTSTR) "[none]");
    }
}


/*
 * $Log: SongInfo.cpp $
 * Revision 1.3  1997/01/14 17:42:08  pekangas
 * Changed to use MIDAS DLL API
 *
 * Revision 1.2  1996/07/16 19:22:16  pekangas
 * Removed Visual C warnings, added RCS keywords, converted to LFs
 *
*/