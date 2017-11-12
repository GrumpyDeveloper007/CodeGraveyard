/*
 *      InstList.h
 *
 * MIDAS Module Player for Windows NT Instrument List View
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __INSTLIST_H
#define __INSTLIST_H


class InstListWindow;

class InstListView : public midpView
{
private:
    InstListWindow *window;
public:
    InstListView(void);
    virtual ~InstListView(void);
    virtual char *Name(void);
    virtual char *Description(void);
    virtual midpViewWindow *CreateViewWindow(Registry *registry = NULL);
    virtual void DestroyViewWindow(midpViewWindow *window);
};


class InstListWindow : public midpViewWindow
{
protected:
    HWND        listWinHandle;
public:
    InstListWindow(int instanceNumber, midpView *view,
        Registry *registry = NULL);
    virtual ~InstListWindow(void);
    void UpdateList(void);
    LRESULT CALLBACK ClassWindowProc(HWND hwnd, UINT message, WPARAM wparam,
        LPARAM lparam);
};


#endif