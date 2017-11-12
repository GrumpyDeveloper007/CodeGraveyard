/*
 *      MidpView.cpp
 *
 * MIDAS Module Player for Windows NT View definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "midasdll.h"
#include "MidpNT.h"
#include "MidpView.h"


/****************************************************************************\
*
* Function:     midpView::midpView(void)
*
* Description:  MIDP View class constructor. Takes care of initialization
*               common to all views.
*
\****************************************************************************/

midpView::midpView(void)
{
}




/****************************************************************************\
*
* Function:     midpView::~midpView(void)
*
* Description:  MIDP View class destructor. Takes care of uninitialization
*               common to all views.
*
\****************************************************************************/

midpView::~midpView(void)
{
}




/****************************************************************************\
*
* Function:     midpViewWindow::midpViewWindow(int instanceNumber,
*                   midpView *view, Registry *registry = NULL)
*
* Description:  MIDP View Window class constructor. Takes care of
*               initialization common to all windows.
*
* Input:        int instanceNumber      view window class instance number
*                                       (zero-based)
*               midpView *view          pointer to owner view object
*               Registry *registry      optional pointer to a Registry object
*                                       where the window infomartion will be
*                                       restored from.
*
\****************************************************************************/

midpViewWindow::midpViewWindow(int instanceNumber, midpView *view,
    Registry *registry)
{
    ownerView = view;
    instanceNumber = instanceNumber;    // bye-bye warning

    startX = startY = startWidth = startHeight = CW_USEDEFAULT;

    if ( registry != NULL )
    {
        if ( registry->ValueExists("X") )
        {
            startX = registry->ValueDWORD("X", 50);
            startY = registry->ValueDWORD("Y", 50);
            startWidth = registry->ValueDWORD("Width", 50);
            startHeight = registry->ValueDWORD("Height", 50);
        }
    }
}




/****************************************************************************\
*
* Function:     midpViewWindow::~midpViewWindow(void)
*
* Description:  MIDP View Window class destructor. Takes care of
*               uninitialization common to all windows.
*
\****************************************************************************/

midpViewWindow::~midpViewWindow(void)
{
    startX = startY = startWidth = startHeight = CW_USEDEFAULT;
}



/****************************************************************************\
*
* Function:     HWND midpViewWindow::WindowHandle(void)
*
* Description:  Reads the window handle.
*
* Returns:      Window handle for the window
*
\****************************************************************************/

HWND midpViewWindow::WindowHandle(void)
{
    return hwnd;
}




/****************************************************************************\
*
* Function:     LRESULT midpViewWindow::SendWindowMessage(UINT message,
*                   WPARAM wparam, LPARAM lparam);
*
* Description:  Sends a message to the window
*
* Returns:      Return value from SendMessage().
*
\****************************************************************************/

LRESULT midpViewWindow::SendWindowMessage(UINT message, WPARAM wparam,
    LPARAM lparam)
{
    return SendMessage(hwnd, message, wparam, lparam);
}




/****************************************************************************\
*
* Function:     void midpViewWindow::SongChanged(void)
*
* Description:  Notify the window that song has been changed
*
\****************************************************************************/

void midpViewWindow::SongChanged(void)
{
    SendWindowMessage(MIDPMSG_SONGCHANGED, 0, 0);
}




/****************************************************************************\
*
* Function:     void midpViewWindow::Update(void)
*
* Description:  Instruct the window to update itself
*
\****************************************************************************/

void midpViewWindow::Update(void)
{
}



/****************************************************************************\
*
* Function:     void midpViewWindow::SaveState(Registry *registry)
*
* Description:  Saves the window's state to registry
*
* Input:        Registry *registry      Pointer to the Registry object where
*                                       the state will be saved. The registry
*                                       must be open at the correct key.
*
\****************************************************************************/

void midpViewWindow::SaveState(Registry *registry)
{
    RECT        rect;

    GetWindowRect(hwnd, &rect);
    registry->WriteString("ViewClass", ownerView->Name());
    registry->WriteDWORD("X", rect.left);
    registry->WriteDWORD("Y", rect.top);
    registry->WriteDWORD("Width", rect.right - rect.left);
    registry->WriteDWORD("Height", rect.bottom - rect.top);
}




/****************************************************************************\
*
* Function:     void midpViewWindow::RestoreState(Registry *registry)
*
* Description:  Restores the window's state from registry
*
* Input:        Registry *registry      Pointer to the Registry object from
*                                       which the state will be restored. The
*                                       The registry must be open at the
*                                       correct key.
*
\****************************************************************************/

void midpViewWindow::RestoreState(Registry *registry)
{
    registry = registry;
}