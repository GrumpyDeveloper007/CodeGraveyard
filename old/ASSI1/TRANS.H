/*
	transcom.H
    V1.0
	Header file written by Dr. W. Steiger
	for Vector & Matrix manipulation file 'Trans.c' written by Dr. R. Cant
	12.10.1995
    Note: works only if in ANSI compilation mode and source files having
          the  *.c extension.  For files using the *.cpp extension or
          the Borland C++ compilation mode the function declarations will
          cuase a linker error. This can be overcome by the use of
          "extern "C" { <fct decl.>; <... }
	6/12/1995
		rkp - few cosmetic changes
 */

#ifndef _VECTORCOM_H
#define	_VECTORCOM_H


/* selected data type for vetcor and matrix manipulaions */

#define	Ftype	double

typedef struct
{
	Ftype x,y,z;
}VECTOR;

typedef struct
{
	VECTOR cx,cy,cz;
}MATRIX;

typedef struct
{
	VECTOR shift;
	MATRIX rotate;
}TRANSFORM;


/* graphics transformations functions */

Ftype  dot   (VECTOR, VECTOR);
VECTOR cross (VECTOR, VECTOR);
MATRIX transpose (MATRIX);
VECTOR m_on_v    (MATRIX, VECTOR);
MATRIX product   (MATRIX, MATRIX);
MATRIX x_rot (Ftype);
MATRIX y_rot (Ftype);
MATRIX z_rot (Ftype);
VECTOR vector_sum (VECTOR, VECTOR);
VECTOR project (VECTOR,Ftype);
VECTOR minus (VECTOR);
VECTOR do_transform (VECTOR, TRANSFORM);
VECTOR do_view_transform (VECTOR, TRANSFORM);
TRANSFORM build_trans (Ftype, Ftype, Ftype, VECTOR);
TRANSFORM build_view_trans (Ftype, Ftype, Ftype, VECTOR);
TRANSFORM combine_trans (TRANSFORM, TRANSFORM);
TRANSFORM combine_view_trans(TRANSFORM, TRANSFORM);

#endif

