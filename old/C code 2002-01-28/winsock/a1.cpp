     #include <windows.h>
     #include <stdio.h>
     void abc(char *p)
     {
             FILE *fp=fopen("c:\\z.txt","a+");
             fprintf(fp,"%s\n",p);
             fclose(fp);
     }
     WNDCLASS a;HWND b;MSG c;
     long _stdcall zzz (HWND,UINT,WPARAM,LPARAM);
     int _stdcall WinMain(HINSTANCE i,HINSTANCE j,char *k,int l)
     {
             a.lpszClassName="a1";
             a.hInstance=i;
             a.lpfnWndProc=zzz;
             a.hbrBackground=(HBRUSH)GetStockObject(WHITE_BRUSH);
             RegisterClass(&a);
             b=CreateWindow("a1","aaa",WS_OVERLAPPEDWINDOW,1,1,10,20,0,0,i,0	);
             ShowWindow(b,3);
             while ( GetMessage(&c,0,0,0) )
                     DispatchMessage(&c);
             return 1;
     }
     long _stdcall zzz (HWND w,UINT x,WPARAM y,LPARAM z)
     {
             if ( x == WM_LBUTTONDOWN)
             {
      	       MessageBox(0,"end","end",0);
             }
             if ( x == WM_DESTROY)
                     PostQuitMessage(0);
             return DefWindowProc(w,x,y,z);
     }
