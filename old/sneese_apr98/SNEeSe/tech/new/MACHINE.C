#include "machine.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

char *dectohex(int l, int w)
{
        byte b;
	char *s=new char[w+1];
        const char hextable[17]="0123456789ABCDEF";
        for(b=0; b<w; b++)
          s[w-b-1]=(char)hextable[(l >> (b*4)) & 0xf];
	s[b]=0;
        return(s);      
}
int hextodec(char *s)
{
        int b;
        int l,m;
        char hextable[17]="0123456789ABCDEF";
        l=0;m=1;
        for(b=strlen(s)-1;b>=0;b--) {
          l=l+( (strrchr(hextable,toupper(s[b]))-hextable) )*m;
          m=m*16;
        }
        return(l);
}

