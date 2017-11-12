/*
 *      ViewList.cpp
 *
 * MIDAS Module Player for Windows NT View list definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#include <string.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include "MidpList.h"
#include "MidpView.h"
#include "ViewList.h"


midpViewList::midpViewList()
{
}


midpViewList::~midpViewList(void)
{
}



void midpViewList::AddView(midpView *view)
{
    AddItem((midpListItem*) view);
}


void midpViewList::RemoveView(midpView *view)
{
    RemoveItem((midpListItem*) view);
}


midpView *midpViewList::GetFirst()
{
    return (midpView*) midpList::GetFirst();
}


midpView *midpViewList::GetNext()
{
    return (midpView*) midpList::GetNext();
}


midpView *midpViewList::FindView(const char *name)
{
    midpView    *view;

    view = GetFirst();
    while ( (view != NULL) && (strcmp(view->Name(), name) != 0) )
        view = GetNext();
    return view;
}


midpViewWindowList::midpViewWindowList(void)
{
    numWindows = 0;
}


midpViewWindowList::~midpViewWindowList(void)
{
}



void midpViewWindowList::AddWindow(midpViewWindow *window)
{
    numWindows++;
    AddItem((midpListItem*) window);
}


void midpViewWindowList::RemoveWindow(midpViewWindow *window)
{
    numWindows--;
    RemoveItem((midpListItem*) window);
}


midpViewWindow *midpViewWindowList::GetFirst(void)
{
    return (midpViewWindow*) midpList::GetFirst();
}


midpViewWindow *midpViewWindowList::GetNext(void)
{
    return (midpViewWindow*) midpList::GetNext();
}


void midpViewWindowList::SongChanged(void)
{
    midpViewWindow  *window;

    window = GetFirst();
    while ( window != NULL )
    {
        window->SongChanged();
        window = GetNext();
    }
}


void midpViewWindowList::CloseAll(void)
{
    midpViewWindow  *window;

    window = GetFirst();
    while ( window != NULL )
    {
        window->SendWindowMessage(WM_CLOSE, 0, 0);
        window = GetNext();
    }
}


int midpViewWindowList::NumWindows()
{
    return numWindows;
}