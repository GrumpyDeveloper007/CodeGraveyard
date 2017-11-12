// Elf standard functions -
#include <math.h>
const float _PI=3.141592654;


void Copy(unsigned char *BufferA,unsigned char *BufferB,int Size)
 {
 for(int i=0;i<Size;i++)
  *BufferA++=*BufferB++;
 }

void Clear(unsigned char *Buffer,int Size)
 {
 for(int i=0;i<Size;i++)
 Buffer[i]=0;
 }


float GetHyp(float &dx,float &dy,float &Angle)  // Angle = degrees
 {
 if (dx==0)
  return dy;
 if (dy==0)
  return dx;
 if (dx>=dy)
  return dy/sin(( Angle*_PI/180 ));
 return dx/sin(( Angle*_PI/180 ));
 }

float Abs(float val)
 {
 if (val<0)
  return -val;
 return val;
 }

float GetAngle(float &dx,float &dy)
 {
 if (dx==0)
  return 0;
 if (dy==0)
  return 45;
 if (dx>=dy)             // adj > opp
  return (180*atan(dy/dx))/_PI;
 return (180*atan(dx/dy))/_PI;
 }

