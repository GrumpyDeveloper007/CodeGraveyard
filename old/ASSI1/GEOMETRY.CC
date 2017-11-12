#include "geometry.h"
#include <dos.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>
#include <iostream.h>

#define ONLINE_DELTA 0.0001

//#define DEBUG
#undef DEBUG

//#define DEBUG_MEM
#undef DEBUG_MEM

int debug_draw=0;
extern ofstream debugfile;

Vector::Vector(double nx, double ny, double nz)
{
  x=nx;
  y=ny;
  z=nz;
}

void Vector::RetrieveFrom ( ifstream& infile)
{
	infile>>x;
	infile>>y;
	infile>>z;
}

void Vector::SaveTo ( ofstream& outfile)
{
	outfile<<x<<" ";
	outfile<<y<<" ";
	outfile<<z<<" ";
}

double operator*(Vector& v1,   Vector& v2) 
{
	return (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z);
}

Vector operator*(  Vector& v1,double scaling)
{
	return Vector(scaling*v1.x, scaling*v1.y, scaling*v1.z);
}

Vector operator*(double scaling,   Vector& v1)
{
	return Vector(scaling*v1.x, scaling*v1.y, scaling*v1.z);
}

Vector operator/(  Vector& v1,double scaling )
{
	 return Vector(v1.x/scaling, v1.y/scaling, v1.z/scaling);
}

Vector operator -(   Vector& v1,   Vector& v2)
{
	return Vector (v1.x-v2.x, v1.y-v2.y, v1.z-v2.z);
}

Vector operator +(   Vector& v1,   Vector& v2)
{
	return Vector (v1.x+v2.x, v1.y+v2.y, v1.z+v2.z);
}

Vector Normalise (  Vector& v1)
{
	 return v1/sqrt(v1*v1);
}

Vector Project (  Vector& v1,double cotangle)
/*Project a coordinate. Angle of view is assumed to be viewangle in both
x and y (square screen). The z coord is transformed to 1/z in readiness
for any possible z buffer usage. (Otherwise you can ignore it)*/
{
	Vector tmp;
	tmp.z=cotangle/v1.z;
	tmp.x=tmp.z*v1.x;
	tmp.y=tmp.z*v1.y;
	return tmp;
}


Vector operator^(   Vector& v1,   Vector& v2) 
/* This routine is useful for constructing surface normal vectors
since the cross product of two vectors is guaranteed to be at right
angles to both of them.*/
{
	Vector tmp;
	tmp.x=v1.y*v2.z-v1.z*v2.y;
	tmp.y=v1.z*v2.x-v1.x*v2.z;
	tmp.z=v1.x*v2.y-v1.y*v2.x;
	return tmp;
}


Plane::Plane ()
{
	Vector nn, np;
	normal = nn;
	point_on_plane = np;

}

Plane::Plane (Vector nnorm, Vector nplane)
{
	normal = nnorm;
	point_on_plane = nplane;
}

int Plane::ClassifyPoint ( Vector& pt)
{
	// return value POSITIVE_SIDE,NEGATIVE_SIDE, ON_PLANE depending on
	// relationship between plane and point
	// To determine - take vector difference between point in question and
	// a point known to be on the plane. Then dot product this difference with
	// the vector normal to the plane. The sign of the resultant value indicates
	// whether the point is above, below or (if 0) on the plane
	double result;
	Vector diff =  pt - point_on_plane;
	result = diff*normal;
	if (debug_draw==1)
	{
		debugfile<<"classify pt val="<<result<<endl;
	}

	if (result>ONLINE_DELTA)
	{
		return POSITIVE_SIDE;
	}
	else if (result<-(ONLINE_DELTA))
	{
		return NEGATIVE_SIDE;
	}
	else
	{
		return ON_PLANE;
	}

} //end of ClassifyPoint

void Plane::RetrieveFrom( ifstream& infile)
{
	normal.RetrieveFrom(infile);
	point_on_plane.RetrieveFrom(infile);
}

void Plane::SaveTo( ofstream& outfile)
{
	normal.SaveTo(outfile);
	point_on_plane.SaveTo(outfile);
}

Polygon::Polygon ()
{
	num_vertices = 0;
	shade = 0;
}

Polygon::Polygon(Vector nvertices[], int nnum_vertices)
{
	num_vertices = nnum_vertices;
	for (int i=0; i<num_vertices;i++)
	{
		vertices[i] = nvertices[i];
	}
}

/*
	general linear interpolation - interpolates b range based on
	limits and values in a
 */
double interpolate( int limit, double a, double b, double a1, double b1)
{
	return b1+ (b-b1)*(limit-a1)/(a-a1);
}

void Polygon::RetrieveFrom(ifstream& infile)
{
	infile>>num_vertices;
	for (int i =0; i<num_vertices;i++)
	{
		vertices[i].RetrieveFrom(infile);
	}
	
}

void Polygon::SaveTo(ofstream& outfile)
{
	outfile<<" "<<num_vertices<<" ";
	for (int i =0; i<num_vertices;i++)
	{
		vertices[i].SaveTo(outfile);
	}
} //end of SaveTo

Matrix::Matrix ()
{
	cx = Vector(0., 0., 0.);
	cy = Vector(0., 0., 0.);
	cz = Vector(0., 0., 0.);
}

Matrix::Matrix (Vector nx, Vector ny, Vector nz)
{
	cx = nx; cy = ny; cz = nz;
}

Vector operator*( Matrix& m, Vector& v)
{
	Vector tmp;
	Matrix mt=Transpose(m);
	tmp.x=mt.cx*v;
	tmp.y=mt.cy*v;
	tmp.z=mt.cz*v;
	return tmp;
}

Matrix x_rot (double angle)
{
	Matrix tmp;
	double s,c;
	c=cos(angle); s=sin(angle);
	tmp.cx.x=1.0;  tmp.cy.x=0;    tmp.cz.x=0;
	tmp.cx.y=0;    tmp.cy.y=c;    tmp.cz.y=s;
	tmp.cx.z=0;    tmp.cy.z= -s;  tmp.cz.z=c;
	return tmp;
}

Matrix y_rot(double  angle)
{
	Matrix tmp;
	double s,c;
	c=cos(angle); s=sin(angle);
	tmp.cx.x=c;    tmp.cy.x=0;    tmp.cz.x= -s;
	tmp.cx.y=0.0;  tmp.cy.y=1.0;  tmp.cz.y=0.0;
	tmp.cx.z=s;    tmp.cy.z=0.0;  tmp.cz.z=c;
	return tmp;
}
Matrix z_rot(double angle)
{
	Matrix tmp;
	double s,c;
	c=cos(angle); s=sin(angle);
	tmp.cx.x=c;   tmp.cy.x=s;    tmp.cz.x=0.0;
	tmp.cx.y= -s; tmp.cy.y=c;    tmp.cz.y=0.0;
	tmp.cx.z=0.0; tmp.cy.z=0.0;  tmp.cz.z=1.0;
	return tmp;
}

Matrix Transpose( Matrix& m)
{
	Matrix tmp;
	tmp.cx.x=m.cx.x; tmp.cx.y=m.cy.x; tmp.cx.z=m.cz.x;
	tmp.cy.x=m.cx.y; tmp.cy.y=m.cy.y; tmp.cy.z=m.cz.y;
	tmp.cz.x=m.cx.z; tmp.cz.y=m.cy.z; tmp.cz.z=m.cz.z;
	return tmp;
}

Matrix Scale (double s,  Matrix& m)
{
	Matrix t;
	t.cx.x=m.cx.x*s;   t.cx.y=m.cx.y*s;   t.cx.z=m.cx.z*s;
	t.cy.x=m.cy.x*s;   t.cy.y=m.cy.y*s;   t.cy.z=m.cy.z*s;
	t.cz.x=m.cz.x*s;   t.cz.y=m.cz.y*s;   t.cz.z=m.cz.z*s;
	return t;
}

Matrix operator *( Matrix& m1,  Matrix& m2)
{
	Matrix tmp;

	tmp.cx=m1*m2.cx;
	tmp.cy=m1*m2.cy;
	tmp.cz=m1*m2.cz;
	return tmp;
}

Vector Transform::Do ( Vector& v1) 
/* This routine implements a transformation consisting of a rotation and a
displacement on the vector "v1". The rotation is performed before the
displacement so that an object can have its orientation and position set
independently of each other. If the displacement were done first it would
be changed by the rotation.
*/
{
	Vector tmp1= rotate*v1;
	Vector tmp3 = shift;
	Vector tmp2= tmp1 + tmp3;
	return tmp2;
}

Vector ViewTransform::Do ( Vector& v1)
/*As for the preceding routine but with the viewpoint's preferred ordering
and with the sense of the displacement reversed so that we can work with the
position of the viewpoint within the world rather than the position of the
world within the view coords

This routine implements a transformation consisting of a rotation and a
displacement on the vector "v1". The rotation is performed after the
displacement to simulate the effect of moving the observer rather than
the object.

*/
{
	Vector tmp1 = v1 - shift;
	Vector tmp2=rotate*tmp1;
	return tmp2;
}

Transform::Transform()
{
	shift = Vector(0., 0., 0.);
}

Transform::Transform (Vector b1, Vector b3, Vector disp)
{
	// create via a basis transformation
	Matrix tmprot;
	Vector b2;
	shift = disp;
	tmprot.cy=Normalise(b1);
	tmprot.cz=Normalise(b3);
	b2=b1^b3;
	tmprot.cx=Normalise(b2);
	rotate=tmprot;
}

Transform::Transform (double nx, double ny, double nz, Vector v1)
{
/*Constructs a Transform from a displacement (v1) and three angles of
 rotation. Note that the ordering of the angles is optimum for objects originally
 defined with their long axis in the x direction.

*/
	shift=v1;
	 Matrix xrot=x_rot(nx);
	 Matrix yrot=y_rot(ny);
	 Matrix zrot=z_rot(nz);
	 Matrix tmp1=zrot * xrot;
	rotate=yrot * tmp1;
}



ViewTransform::ViewTransform (double nx, double ny, double nz, Vector v1)
/*As for the preceding routine but with the viewpoint's preferred ordering of rotations.*/
{
	Matrix xrot,yrot,zrot,tmp1;
	shift=v1;
	xrot=x_rot(nx);
	yrot=y_rot(ny);
	zrot=z_rot(nz);
	tmp1=xrot * yrot;
	rotate= zrot * tmp1;
}

ViewTransform::ViewTransform ()
{
	shift = Vector (0., 0., 0.);
}

ViewTransform::ViewTransform (ViewTransform& vt)
{
	shift = vt.shift;
	rotate = vt.rotate;
}
Transform Combine ( Transform& t1,  Transform& t2)
/*Concatenates two transformations.
The effective transform applies t2 to the object first - followed by t1
*/
{

	Transform tmp;
	Vector tmp2 = t1.rotate*t2.shift;
	tmp.shift= t1.shift; 
	tmp.shift =tmp.shift+tmp2;
	tmp.rotate=t1.rotate * t2.rotate;
	return tmp;
}

ViewTransform  Combine ( ViewTransform& t1,  Transform& t2)
/*The effective transform applies t2 to the object first - followed by t1_trans.
In this case t1_trans is a viewpoint transformation and hence has its shift
and rotate in a different order and has the sense of the viewing shift
reversed - see do_view_trans (above) */ 
{

	ViewTransform tmp;
	Vector tmp2 = (t2.shift-t1.shift);
	tmp.shift= t1.rotate*tmp2;
	tmp.rotate= t1.rotate*t2.rotate;
	return tmp;
}

Matrix Transform::Rotate()
{
	return rotate;
}

Vector Transform::Shift()
{
	return shift;
}
