/* Routines for performing graphic geometry operations.*/
				  /* Written By R.J. Cant 7/1/94 */
/*Note - this software is supplied "as is" and with no warranty whatsoever*/

#include <math.h>

#include "trans.h"


Ftype dot(VECTOR p,VECTOR q)
{
  return p.x*q.x+p.y*q.y+p.z*q.z;
}

VECTOR cross(VECTOR p,VECTOR q)
/* This routine is useful for constructing surface normal vectors
since the cross product of two vectors is guaranteed to be at right
angles to both of them.*/
{
   VECTOR tmp;
   tmp.x=p.y*q.z-p.z*q.y;
   tmp.y=p.z*q.x-p.x*q.z;
   tmp.z=p.x*q.y-p.y*q.x;
   return tmp;
}

MATRIX transpose(MATRIX m)
/* This routine transpose any arbitrary
matrix and will invert any rotation matrix*/
{
   MATRIX tmp;
   tmp.cx.x=m.cx.x; tmp.cx.y=m.cy.x; tmp.cx.z=m.cz.x;
   tmp.cy.x=m.cx.y; tmp.cy.y=m.cy.y; tmp.cy.z=m.cz.y;
   tmp.cz.x=m.cx.z; tmp.cz.y=m.cy.z; tmp.cz.z=m.cz.z;
   return tmp;
}


VECTOR m_on_v(MATRIX m,VECTOR v)
{
   VECTOR tmp;
   MATRIX mt;

   mt=transpose(m);
   tmp.x=dot(mt.cx,v);
   tmp.y=dot(mt.cy,v);
   tmp.z=dot(mt.cz,v);
   return tmp;
}

MATRIX product (MATRIX m,MATRIX n)
{
   MATRIX tmp;

   tmp.cx=m_on_v(m,n.cx);
   tmp.cy=m_on_v(m,n.cy);
   tmp.cz=m_on_v(m,n.cz);
   return tmp;
}

MATRIX x_rot(Ftype angle)
{
   MATRIX tmp;
   Ftype s,c;
   c=cos(angle); s=sin(angle);
   tmp.cx.x=1.0;  tmp.cy.x=0;    tmp.cz.x=0;
   tmp.cx.y=0;    tmp.cy.y=c;    tmp.cz.y=s;
   tmp.cx.z=0;    tmp.cy.z= -s;  tmp.cz.z=c;
   return tmp;
}

MATRIX y_rot(Ftype angle)
{
   MATRIX tmp;
   Ftype s,c;
   c=cos(angle); s=sin(angle);
   tmp.cx.x=c;    tmp.cy.x=0;    tmp.cz.x= -s;
   tmp.cx.y=0.0;  tmp.cy.y=1.0;  tmp.cz.y=0.0;
   tmp.cx.z=s;    tmp.cy.z=0.0;  tmp.cz.z=c;
   return tmp;
}
MATRIX z_rot(Ftype angle)
{
   MATRIX tmp;
   Ftype s,c;
   c=cos(angle); s=sin(angle);
   tmp.cx.x=c;   tmp.cy.x=s;    tmp.cz.x=0.0;
   tmp.cx.y= -s; tmp.cy.y=c;    tmp.cz.y=0.0;
   tmp.cx.z=0.0; tmp.cy.z=0.0;  tmp.cz.z=1.0;
   return tmp;
}

VECTOR vector_sum(VECTOR p,VECTOR q)
{
   VECTOR tmp;
   tmp.x=p.x+q.x;
   tmp.y=p.y+q.y;
   tmp.z=p.z+q.z;
   return tmp;
}

VECTOR project(VECTOR p,Ftype  viewangle)
/*Project a coordinate. Angle of view is assumed to be viewangle in both
x and y (square screen). The z coord is transformed to 1/z in readiness
for any possible z buffer usage. (Otherwise you can ignore it)*/
{
   Ftype cotangle;
   VECTOR tmp;
   cotangle= 1.0/tan(viewangle/2.0);
   tmp.z=cotangle/p.z;
   tmp.x=tmp.z*p.x;
   tmp.y=tmp.z*p.y;
   return tmp;
}

VECTOR minus(VECTOR p)
{
   VECTOR tmp;
   tmp.x= -p.x;
   tmp.y= -p.y;
   tmp.z= -p.z;
   return tmp;
}

VECTOR do_transform(VECTOR point,TRANSFORM ation)
{
/* This routine implements a transformation consisting of a rotation and a displacement
 on the vector "point". The rotation is performed before the displacement so that an
object can have its orientation and position set independently of each other. If the displacement were done first it would be changed by the rotation.

Data types and functions used in conjunction with this function:

TRANSFORM data type.
build_trans() function.

Similar Functions:

do_view_transform.
*/

   VECTOR tmp1,tmp2;
   tmp1=m_on_v(ation.rotate,point);
   tmp2= vector_sum(tmp1,ation.shift);
   return tmp2;
}
VECTOR do_view_transform(VECTOR point,TRANSFORM ation)
/*As for the preceding routine but with the viewpoint's preferred ordering
and with the sense of the displacement reversed so that we can work with the 
position of the viewpoint within the world rather than the position of the 
world within the view coords

 This routine implements a transformation consisting of a rotation and a displacement
 on the vector "point". The rotation is performed after the displacement to
 simulate the effect of moving the observer rather than the object.

Data types and functions used in conjunction with this function:

TRANSFORM data type.
build_view_trans() function.

Similar Functions:

do_transform.
*/
{
   VECTOR tmp1,tmp2;
   tmp1= vector_sum(point,minus(ation.shift));
   tmp2=m_on_v(ation.rotate,tmp1);
   return tmp2;
}

TRANSFORM build_trans(Ftype xangle,Ftype yangle,Ftype zangle,VECTOR disp)
{
/*Constructs a TRANSFORM data set from a displacement (disp) and three angles of rotation. Note that the ordering of the angles is optimum forobjects originally defined with their long axis in the x direction.

Data types and functions used in conjunction with this function:

TRANSFORM data type.
do_transform() function.

Similar Functions:

build_view_trans.
*/

   MATRIX xrot,yrot,zrot,tmp1;
   TRANSFORM tmp;
   tmp.shift=disp;
   xrot=x_rot(xangle);
   yrot=y_rot(yangle);
   zrot=z_rot(zangle);
   tmp1=product(zrot,xrot);
   tmp.rotate=product(yrot,tmp1);
   return tmp;
}

TRANSFORM build_view_trans(Ftype xangle,Ftype yangle,Ftype zangle,VECTOR disp)
/*As for the preceding routine but with the viewpoint's preferred ordering of rotations.*/
{
   MATRIX xrot,yrot,zrot,tmp1;
   TRANSFORM tmp;
0   tmp.shift=disp;
   xrot=x_rot(xangle);
   yrot=y_rot(yangle);
   zrot=z_rot(zangle);
   tmp1=product(xrot,yrot);
   tmp.rotate=product(zrot,tmp1);
   return tmp; 
}

TRANSFORM combine_trans(TRANSFORM u,TRANSFORM v)
/*Concatenates two transformations.
The effective transform applies v to the object first - followed by u*/ 
{

   TRANSFORM tmp;
   tmp.shift= vector_sum(u.shift,m_on_v(u.rotate,v.shift));
   tmp.rotate=product(u.rotate,v.rotate);
   return tmp; 
}

TRANSFORM combine_view_trans(TRANSFORM v,TRANSFORM t)
/*The effective transform applies t to the object first - followed by v_trans.
In this case v_trans is a viewpoint transformation and hence has its shift 
and rotate in a different order and has the sense o the viewing shift 
reversed - see do_view_trans (above) */ 
{

   TRANSFORM tmp;
   tmp.shift= m_on_v(v.rotate,vector_sum(minus(v.shift),t.shift));
   tmp.rotate=product(v.rotate,t.rotate);
   return tmp; 
}

/*

How to use these routines. 


These routines assume that the vertices which you wish to transform are 
stored in the form of VECTOR structures as defined at the start of the file. 

The routines assume a right handed coordinate system and are best used with 
the line of sight in the positive direction along the z axis and the y axis 
pointing down.

You do not need to have both a viewpoint and an object transformation but both 
are supported by these routines.

You should define rotation angles about the x,y,and z axes for both object to
world and world to viewpoint systems. Similarly position vectors defining the 
position of the object and the position of the viewpoint within the world
should be set up.


Next call build_trans and build_view_trans with these parameters.


Now you can transform any point from object to world coords by calling 
do_trans using your output from build trans as parameter and from world 
coords to viewing coords by calling do_view_trans using your output from 
build_view_trans as parameter. Alternatively use combine_view_trans to bundle 
the two transformations together into one which will allow a single call to 
do_trans to be used for the complete transformation. For nested layers of 
object transformation use combine_trans to put the transformations together. 
Finally you can use project to create a two dimensional version of the object 
in a screen coordinate system which has (0,0) at the centre (-1,-1) at the top 
left corner and (+1,+1) at the bottom right corner.


Typical use:

Given an object positioned at  a point defined by position vector p and rotated through angles thetax,thetay and thetaz.

TRANSFORM obj;
obj=build_trans(thetax,thetay,thetaz,p);

for ("All position vectors "x" which define the object":)
{
	xt=do_trans(x,obj);
	xs=project(xt,view_angle);
	xpix=((xs.x+1)*SCREENWIDTH)/2;
	ypix=((xs.y+1)*SCREENHEIGHT)/2;
}
The variables xpix and ypix give the screen position in pixels of each point in the object.
*/

