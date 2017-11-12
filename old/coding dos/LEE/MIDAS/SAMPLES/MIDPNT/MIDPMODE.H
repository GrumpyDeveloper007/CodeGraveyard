/*
 *      MidpModeless.h
 *
 * MIDAS Module Player for Windows NT modeless dialog box list definitions
 *
 * Copyright 1996 Petteri Kangaslampi
*/

#ifndef __MIDPMODELESS_H
#define __MIDPMODELESS_H



class midpModeless : public midpListItem
{
public:
    HWND        hwnd;
};


extern midpList midpModelessList;

#endif