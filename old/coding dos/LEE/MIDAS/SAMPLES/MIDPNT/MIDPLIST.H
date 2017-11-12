/*
 *      MidpList.h
 *
 * MIDAS Module Player for Windows NT List class definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __MIDPLIST_H
#define __MIDPLIST_H



class midpListItem
{
public:
    midpListItem    *next, *prev;
};



class midpList
{
private:
    midpListItem    *first, *current;
public:
    midpList(void);
    ~midpList(void);
    void AddItem(midpListItem *item);
    void RemoveItem(midpListItem *item);
    midpListItem *GetFirst(void);
    midpListItem *GetNext(void);
};


#endif