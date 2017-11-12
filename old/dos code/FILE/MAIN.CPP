#include <conio.h>
#include <fstream.h>
#include <i86.h>
long array[5001];
int hit[5001];

void main()
 {
 fstream temp1,temp2,temp3,temp4;
 temp1.open("d:\\wingames\\orion\\save9.gam",ios::in|ios::binary);
 temp2.open("d:\\wingames\\orion\\save8.gam",ios::out|ios::binary);
 temp3.open("input.dat",ios::binary|ios::in);
 temp4.open("output.dat",ios::binary|ios::out);
 unsigned char a,b;
 int i,arrind;
 long dd,ee;
 int ok=0;

 for(i=0;i<5000;i++)
  hit[i]=0;

 i=0;arrind=0;
 ee=00;
 ok=0;

 temp3.read((char*)&ee,4);
 while (arrind<ee)
  {
  temp3.read((char*)&dd,4);
  array[arrind]=dd;
  temp3.read((char*)&dd,4);
  hit[arrind]=dd;
  arrind++;
  }

 if (arrind==0)
  {
  cout << "file ok"<<endl;
  ok=1;
  }
 int oka=0;
 while (i<208000)
  {
  temp1.read(&a,1);
  if (a==8 && oka==0)
   {
   cout << "find" <<endl;
   a=41;oka=1;
   }


/*
  if (a==4)
   {
   temp2.write(&a,1);
   i++;
   temp1.read(&a,1);
   if (a==14)
    {
//    cout <<"yes :"<<(int)i<<endl;

    if (ok==1)
     {
     array[arrind]=i;
     hit[arrind]=1;
     arrind++;
     }
    else
     {
     for(int t=0;t<arrind;t++)
      {
      if (array[t]==i)
        {
    cout <<"yes :"<<(int)t<<endl;
        hit[t]=hit[t]+1;
        }
      }
     }

    }

   }
  */
  temp2.write(&a,1);
  
  i++;
  }
 i=0;
 dd=arrind;// write length of file 
 temp4.write((char*)&dd,4);
 while (arrind>i)
  {
  dd=array[i];
  temp4.write((char*)&dd,4);
  dd=hit[i];
  temp4.write((char*)&dd,4);
  i++;
  }
 for(i=0;i<arrind;i++)
  {
  if (hit[i]>4)
   {
   cout << "Number :" << i<< ": address :" << array[i]<<": value :"<<hit[i]<<endl;
   }
  }

cout <<endl<< "end";
 }
