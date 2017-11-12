
// Module - 
//
// Includes -
//   
//   
// 
// Coded by Dark Elf
//

#define ASC_ESC	27
unsigned char KeyToAsc[256]={27,'`','1','2','3','4','5','6','7','8','9','0','-','=',0,
0,'q','w','e','r','t','y','u','i','o','p','[',']',0,
0,'a','s','d','f','g','h','j','k','l',';',0,'#',
0,'\\','z','x','c','v','b','n','m',',','.','/',0,
/*multiply 0x37*/
0,0,' ',0,
/*f1*/
0,0,0,0,0,0,0,0,0,0,
/*numlock*/
0,0,
/*numeric keypad*/
'7','8','9','-','4','5','6','+','1','2','3','0','.'};

unsigned char KeyToAscShift[256]={27,'`','1','2','3','4','5','6','7','8','9','0','_','+',0,
0,'Q','W','E','R','T','Y','U','I','O','P','{','}',0,
0,'A','S','D','F','G','H','J','K','L',':','@','~',
0,'|','Z','X','C','V','B','N','M','<','>','?',0,
/*multiply 0x37*/
0,0,' ',0,
/*f1*/
0,0,0,0,0,0,0,0,0,0,
/*numlock*/
0,0,
/*numeric keypad*/
'7','8','9','-','4','5','6','+','1','2','3','0','.'};

#define KEYDOWN(name,key) (name[key] & 0x80) 
#define KEYUP(name,key) (name[key] ) 

#include <dinput.h> 

#include "input.h"
void cINPUT::AddQueue(char Key)
{
	if (QueuePtr<256)
	{
		Queue[QueuePtr]=Key;
		QueuePtr++;
	}
}

char cINPUT::GetCh()
{
	if (QueuePtr>0)
	{
		char c=Queue[0];
		int i;
		for (i=0;i<QueuePtr;i++)
		{
			Queue[i]=Queue[i+1];
		}
		QueuePtr--;
		return c;
	}
	return 0;
}
void cINPUT::KeyboardInterupt()
{
	int i;
	for(i=0;i<256;i++)
	{
		if (KBuffer[i]!=KBufferBack[i])
		{
			if (KEYDOWN(KBufferBack,i) /*&&KEYUP(KBuffer,i)*/)
			{
				if (KEYDOWN(KBuffer,DIK_LSHIFT) ||KEYDOWN(KBuffer,DIK_RSHIFT))
					AddQueue(KeyToAscShift[i]);
				else
					AddQueue(KeyToAsc[i]);
			}
			KBufferBack[i]=KBuffer[i];
		}
	}
}

long cINPUT::CheckKey(int KeyNum)
{
	return KEYDOWN(KBuffer, KeyNum);
}
void cINPUT::SetMouseRange(int MinX,int MinY,int MaxX,int MaxY)
{
	SetMouseMax(MaxX,MaxY);
}
void cINPUT::SetMouseMax(int MaxX,int MaxY)
{
	MaxMouseX=MaxX;
	MaxMouseY=MaxY;
}
bool cINPUT::InitDevices(HINSTANCE g_hinst,HWND hwnd)
{
    // Create the DirectInput object. 
    hr = DirectInputCreate(g_hinst, DIRECTINPUT_VERSION, 
		&g_lpDI, NULL); 
    if FAILED(hr) return FALSE; 
	
    // Retrieve a pointer to an IDirectInputDevice interface 
	hr = g_lpDI->CreateDevice(GUID_SysKeyboard, &g_lpDIDevice, NULL); 
	if FAILED(hr) 
        return FALSE; 
	
	//mouse
	hr = g_lpDI->CreateDevice(GUID_SysMouse, &g_pMouse, NULL);
	if (FAILED(hr)) 
		return FALSE;
	hr = g_pMouse->SetDataFormat(&c_dfDIMouse);
	if (FAILED(hr))
		return FALSE;
	hr = g_pMouse->SetCooperativeLevel(hwnd,
		DISCL_EXCLUSIVE | DISCL_FOREGROUND);
	if (FAILED(hr)) 
		return FALSE;
    hr = g_pMouse->Acquire(); 
    if FAILED(hr) 
        return FALSE; 
    
	
    // Set the data format using the predefined keyboard data 
    // format provided by the DirectInput object for keyboards. 
    hr = g_lpDIDevice->SetDataFormat(&c_dfDIKeyboard); 
    if FAILED(hr) 
        return FALSE; 
	
    // Set the cooperative level 
	//    hr = g_lpDIDevice->SetCooperativeLevel(g_hwndMain, 
	//                     DISCL_FOREGROUND | DISCL_NONEXCLUSIVE); 
	//    if FAILED(hr) 
	//        return FALSE; 
	
    // Get access to the input device. 
    hr = g_lpDIDevice->Acquire(); 
	
    if FAILED(hr) 
        return FALSE; 
	ProcessKeyboard();
	int i;
	for (i=0;i<256;i++)
		KBufferBack[i]=KBuffer[i];
	
	QueuePtr=0;
    
	return TRUE;  
}

void cINPUT::CloseKeyboard()
{	
	g_lpDIDevice->Unacquire();
	g_lpDIDevice->Release();
}

void cINPUT::CloseMouse()
{	
	g_pMouse->Unacquire();
	g_pMouse->Release();
}

cINPUT::~cINPUT()
{
	g_lpDI->Release();
}
void cINPUT::ProcessKeyboard() 
{ 
    hr = g_lpDIDevice->GetDeviceState(sizeof(KBuffer),(LPVOID)&KBuffer); 
    while( FAILED(hr) )
    { 
		hr = g_lpDIDevice->Acquire(); 
		// If it failed, the device has probably been lost. 
		// We should check for (hr == DI_INPUTLOST) 
		// and attempt to reacquire it here. 
		hr = g_lpDIDevice->GetDeviceState(sizeof(KBuffer),(LPVOID)&KBuffer); 
    } 
	//	g_lpDIDevice->Unacquire();
} 

void cINPUT::ProcessMouse()
{
	hr = g_pMouse->GetDeviceState(sizeof(DIMOUSESTATE), &dims);
	if (hr == DIERR_INPUTLOST)
	{
	/*
	*  DirectInput is telling us that the input stream has
	*  been interrupted.  We aren't tracking any state
	*  between polls, so we don't have any special reset
	*  that needs to be done.  We just re-acquire and
	*  try again.
		*/
		hr = g_pMouse->Acquire();
		return;
	}
	OldMouseX=MouseX;
	OldMouseY=MouseY;
	MouseX+=dims.lX;
	MouseY+=dims.lY;
	if (MouseX<0)
		MouseX=0;
	if (MouseY<0)
		MouseY=0;
	
	if (MouseX>MaxMouseX)
		MouseX=MaxMouseX;
	if (MouseY>MaxMouseY)
		MouseY=MaxMouseY;
	MouseButton=0;
	if (dims.rgbButtons[0]>0)
		MouseButton+=1;
	if (dims.rgbButtons[1]>0)
		MouseButton+=2;
	
		/*            //       dims.lX, dims.lY, dims.lZ,
		//(dims.rgbButtons[0] & 0x80)
		// (dims.rgbButtons[1] & 0x80)
		// (dims.rgbButtons[2] & 0x80) 
		// (dims.rgbButtons[3] & 0x80)
		
	*/
}
