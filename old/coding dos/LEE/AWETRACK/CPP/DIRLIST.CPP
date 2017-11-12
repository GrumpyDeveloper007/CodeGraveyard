#include <direct.h>
#include <string.h>

// This fills an array of FILELIST with file information
// from the path given, starting at file number Offset
// and with a maximum number of files of MaxLen

struct FILELIST
 {
 char Name[13];
 long Size;
 int Directory; // if 1 this is a directory
 };

int GetDirList(char *Path,FILELIST *Files,int MaxLen,int Offset)
 {
 DIR *dirp;
 dirent *direntp;
 int FilesRead=0;

 dirp=opendir(Path);
 if (dirp==NULL) // invalid dir ? returns -1
  return -1;

 for (int a=0;a<Offset;a++)
  {
  direntp=readdir(dirp);
  if (direntp==NULL)
   {
   closedir(dirp);
   return 0;
   }
  }

 direntp=readdir(dirp);

 while (direntp!=NULL && FilesRead<MaxLen) // while more files and more wanted
  {
  if ((direntp->d_attr&_A_VOLID)!=_A_VOLID)
   {
   strcpy(Files[FilesRead].Name,direntp->d_name);
   Files[FilesRead].Size=direntp->d_size;
   if ((direntp->d_attr&_A_SUBDIR)==_A_SUBDIR)
    Files[FilesRead].Directory=1;
   else
    Files[FilesRead].Directory=0;
   FilesRead++;
   direntp=readdir(dirp);
   }
  }

 closedir(dirp);
 return FilesRead;
 }
