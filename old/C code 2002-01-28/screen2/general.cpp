

// 
//
// Includes -
//   
//   
// 
// Coded by Dark Elf
//

#include <math.h>


#include "types.h"
#include "general.h"

MFLOAT GetAngle(MFLOAT dx,MFLOAT dy)
{
	if (dx==0)
		return 0;
	if (dy==0)
		return 45;
	if (dx>=dy)             // adj > opp
		return (MFLOAT)((180*(MFLOAT)atan(dy/dx))/_PI);
	else
		return (MFLOAT)((180*(MFLOAT)atan(dx/dy))/_PI);
}

MFLOAT abs(MFLOAT val)
{
	if (val<0)
		return -val;
	else
		return val;
}

long abs(long val)
{
	if (val<0)
		return -val;
	else
		return val;
}

MFLOAT Angle360(MFLOAT x,MFLOAT y)
{
	// where | =0
	MFLOAT Angle,a=0,ax,ay;
	ax=abs(x);
	ay=abs(y);
    Angle=GetAngle(ax,ay);
	
	if (x>=0 && y>=0)
    {
		if (ax>=ay)
			a=90-Angle;
		else
			a=0+Angle;
    }            
	if (x>0 && y<0)
    {
		if (ax>=ay)
			a=90+Angle;
		else
			a=180-Angle;
    }
	
	if (x<0 && y>0)
    {
		if (ax>=ay)
			a=270+Angle;
		else
			a=360-Angle;
    }
	if (x<=0 && y<=0)
    {
		if (ax>=ay)
			a=270-Angle;
		else
			a=180+Angle;
    }
	
	return a;
}
