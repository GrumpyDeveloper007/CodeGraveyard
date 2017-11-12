/*
 *      MidpView.h
 *
 * MIDAS Module Player for Windows NT View definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __MIDPVIEW_H
#define __MIDPVIEW_H

#include "MidpList.h"
#include "Registry.h"


class midpViewWindow;


class midpView : public midpListItem
{
public:
    midpView(void);
    virtual ~midpView(void);
    virtual char *Name(void) = 0;
    virtual char *Description(void) = 0;
    virtual midpViewWindow *CreateViewWindow(Registry *registry = NULL) = 0;
    virtual void DestroyViewWindow(midpViewWindow *window) = 0;
};


class midpViewWindow : public midpListItem
{
protected:
    HWND        hwnd;
    midpView    *ownerView;
    int         startX, startY, startWidth, startHeight;

public:
    midpViewWindow(int instanceNumber, midpView *view,
        Registry *registry = NULL);
    virtual ~midpViewWindow(void);
    virtual HWND WindowHandle(void);
    virtual LRESULT SendWindowMessage(UINT message, WPARAM wparam,
        LPARAM lparam);
    virtual void SongChanged(void);
    virtual void Update(void);
    virtual void SaveState(Registry *registry);
    virtual void RestoreState(Registry *registry);
};


#endif