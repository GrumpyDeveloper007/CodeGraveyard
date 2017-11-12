/*
 *      MidpList.cpp
 *
 * MIDAS Module Player for Windows NT List class definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/


#include <stdlib.h>
#include "MidpList.h"

midpList::midpList(void)
{
    first = current = new midpListItem;
    first->next = first->prev = first;
}


midpList::~midpList(void)
{
    delete first;
}


void midpList::AddItem(midpListItem *item)
{
    item->next = first->next;
    item->prev = first;
    first->next->prev = item;
    first->next = item;
}



void midpList::RemoveItem(midpListItem *item)
{
    item->next->prev = item->prev;
    item->prev->next = item->next;
}




midpListItem *midpList::GetFirst(void)
{
    current = first;
    return GetNext();
}



midpListItem *midpList::GetNext(void)
{
    current = current->next;
    if ( current != first )
        return current;
    return NULL;
}