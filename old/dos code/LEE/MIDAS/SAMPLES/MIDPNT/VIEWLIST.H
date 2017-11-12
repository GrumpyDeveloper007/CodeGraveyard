/*
 *      ViewList.h
 *
 * MIDAS Module Player for Windows NT View list definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __MIDPVIEWLIST_H
#define __MIDPVIEWLIST_H


class midpViewList : public midpList
{
public:
    midpViewList();
    ~midpViewList();
    void AddView(midpView *view);
    void RemoveView(midpView *view);
    midpView *GetFirst();
    midpView *GetNext();
    midpView *FindView(const char *viewName);
};



class midpViewWindowList : public midpList
{
private:
    int         numWindows;
public:
    midpViewWindowList(void);
    ~midpViewWindowList(void);
    void AddWindow(midpViewWindow *window);
    void RemoveWindow(midpViewWindow *window);
    midpViewWindow *GetFirst(void);
    midpViewWindow *GetNext(void);
    void SongChanged(void);
    void CloseAll(void);
    int NumWindows();
};


extern midpViewWindowList viewWindowList;


#endif