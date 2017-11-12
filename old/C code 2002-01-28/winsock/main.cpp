#include <windows.h>
#include  <stdio.h>

void abc(char *p)
{
      FILE *fp=fopen("z.txt","a+");
	fprintf(fp,"%s\n",p);
	fclose(fp);
}

WNDCLASS a; HWND b; MSG c; char aa[200]; SOCKET s; struct hostent h;
WSADATA ws; DWORD e; int ii,dw; char bb[100]; struct sockaddr_in Sa;

long _stdcall zzz (HWND,UINT,WPARAM,LPARAM);

int _stdcall WinMain(HINSTANCE i,HINSTANCE j,char *k,int l)
{
	a.lpszClassName="a1";
	a.hInstance=i;
	a.lpfnWndProc=zzz;
	a.hbrBackground=(HBRUSH)GetStockObject(0);
	RegisterClass(&a);
	b=CreateWindow("a1","time client",WS_OVERLAPPEDWINDOW,1,1,10,20,0,0,i,0);
	ShowWindow(b,3);
	while ( GetMessage(&c,0,0,0) )
		DispatchMessage(&c);
	return 1;
}

long _stdcall zzz (HWND w,UINT x,WPARAM y,LPARAM z)
{
if ( x == WM_LBUTTONDOWN)
{	
	e=WSAStartup(0x0101,&ws);
	sprintf(aa,"e = %ld",e);
	abc(aa);
	s = socket(PF_INET,SOCK_DGRAM,0);
	sprintf(aa,"s = %ld",s);
	abc(aa);
	Sa.sin_family=AF_INET;
	Sa.sin_addr.s_addr = inet_addr("140.252.1.32");
	Sa.sin_port=htons(13);
	strcpy (bb,"hello how are you");
	e=sendto(s,bb,100,0,(struct sockaddr *)&Sa,sizeof(Sa));
	sprintf(aa,"SendTo %ld",e);
	int dw = sizeof(Sa);
	recvfrom(s,bb,100,0,(sockaddr *)&Sa,&dw);
	MessageBox(0,bb,"data from server",0);
	MessageBox(0,"end","end",0);
}

if ( x == WM_DESTROY)
	PostQuitMessage(0);
return DefWindowProc(w,x,y,z);
}
