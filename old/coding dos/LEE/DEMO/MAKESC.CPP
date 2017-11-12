// MAKE SIN COS TABLES

#include <math.h>
#include <fstream.h>

#define M_PI 3.1415278

float Sin[450];

void MakeTables()	// Creates the Sin & Cos tables
 {
 for (int Loop=0;Loop<450;Loop++)
  {
  Sin[Loop]=sin((Loop*M_PI)/180);
//  Cos[Loop]=cos((Loop*M_PI)/180);
  }
 }

void main()
 {
 MakeTables();

 fstream SinCosFile("h\\SinCos.h",ios::out);

 SinCosFile << "float Sin[450]={" << endl;
 for (int a=0;a<450;a++)
  {
  SinCosFile << Sin[a] << "," << endl;
  }
// for (a=0;a<90;a++)
//  {
//  SinCosFile << Sin[a] << "," << endl;
//  }
 SinCosFile << "};" << endl;
 SinCosFile << "float *Cos=&Sin[90];" << endl;
 }
