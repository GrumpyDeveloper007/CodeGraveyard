// Devised for Watcom C++ By Xavier / SCUDD

#include <fstream.h>
#include <string.h>

long DataFileStartPos;
fstream DataFile;

int InitDataFile(char *FileName)
 {
 char TempName[13];
 DataFile.open(FileName,ios::in|ios::binary|ios::atend);
 if (!DataFile)
  return(1==0);
 DataFile.seekg(DataFile.tellg()-16);
 DataFile.read(TempName,12);
 TempName[12]='\0';
 if (stricmp(TempName,"ENDOFFILE   "))
  return(1==0);
 DataFile.read((char *)&DataFileStartPos,4);
 return(1==1);
 }

int LoadDataFile(char *FileName,unsigned char *Address,long Amount2Read=0)
 {
 char TempName[13];
 long Length;
 DataFile.seekg(DataFileStartPos);      // goto start of file
 while (1==1)
  {
  DataFile.read(TempName,12);
  TempName[12]='\0';
  if (stricmp(TempName,"ENDOFFILE   ")==0)
   return (1==0);
  DataFile.read((char *)&Length,4);
  if (stricmp(FileName,TempName)==0)     // File found
   {
   if (Amount2Read==0)
    Amount2Read=Length;
   DataFile.read(Address,Amount2Read);
   return (1==1);
   }
  DataFile.seekg(DataFile.tellg()+Length);
  }
 }

int DataFileOffset(char *FileName)     // returns offset of file in data file
 {
 char TempName[13];
 long Length;
 DataFile.seekg(DataFileStartPos);      // goto start of file
 while (1==1)
  {
  DataFile.read(TempName,12);
  TempName[12]='\0';
  if (stricmp(TempName,"ENDOFFILE   ")==0)
   return 0;    // file not found
  DataFile.read((char *)&Length,4);
  if (stricmp(FileName,TempName)==0)     // File found
   {
   return DataFile.tellg();
   }
  DataFile.seekg(DataFile.tellg()+Length);
  }
 }

int DataFileLength(char *FileName)      // returns length of file in data file
 {
 char TempName[13];
 long Length;
 DataFile.seekg(DataFileStartPos);      // goto start of file
 while (1==1)
  {
  DataFile.read(TempName,12);
  TempName[12]='\0';
  if (stricmp(TempName,"ENDOFFILE   ")==0)
   return 0;    // file not found
  DataFile.read((char *)&Length,4);
  if (stricmp(FileName,TempName)==0)     // File found
   {
   return Length;
   }
  DataFile.seekg(DataFile.tellg()+Length);
  }
 }
