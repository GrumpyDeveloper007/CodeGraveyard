/*
 *      SongInfo.h
 *
 * MIDAS Module Player for Windows NT Song Information View
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __SONGINFO_H
#define __SONGINFO_H

#include "Registry.h"


class SongInfoWindow;

class SongInfoView : public midpView
{
private:
    SongInfoWindow *window;
public:
    SongInfoView(void);
    virtual ~SongInfoView(void);
    virtual char *Name(void);
    virtual char *Description(void);
    virtual midpViewWindow *CreateViewWindow(Registry *registry = NULL);
    virtual void DestroyViewWindow(midpViewWindow *window);
};


class SongInfoWindow : public midpViewWindow
{
protected:
    midpModeless    modeless;
public:
    SongInfoWindow(int instanceNumber, midpView *view,
        Registry *registry = NULL);
    virtual ~SongInfoWindow(void);
//    virtual HWND WindowHandle(void);
//    virtual LRESULT SendMessage(UINT message, WPARAM wparam, LPARAM lparam);
//    virtual void SongChanged(void);
    void UpdateInfo(void);
    BOOL CALLBACK SongInfoWindow::ClassDialogProc(HWND hwnd, UINT message,
        WPARAM wparam, LPARAM lparam);
};


#endif