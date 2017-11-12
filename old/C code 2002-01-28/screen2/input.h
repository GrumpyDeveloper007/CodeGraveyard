#define FLOAT float
// Module - I/O
//		DirectX Version
//
// Includes -
//   cINPUT
//
// Coded by Dark Elf
//
#include <dinput.h>


class cINPUT
{
private:
	// Keyboard
	void AddQueue(char Key);
	
public:
	
	HRESULT  hr; 
	char	KBuffer[256]; 
	char	KBufferBack[256];
	
	char	Queue[256];
	long	QueuePtr;
    LPDIRECTINPUT        g_lpDI; 
	LPDIRECTINPUTDEVICE  g_lpDIDevice; 
	LPDIRECTINPUTDEVICE g_pMouse; 
	DIMOUSESTATE dims;          /* DirectInput mouse state structure */
	long MouseX;
	long MouseY;
	long OldMouseX,OldMouseY;
	long MouseButton;
	long MaxMouseX,MaxMouseY;
	
	~cINPUT();
	
	// Mouse
	void SetMouseMax(int MaxX,int MaxY);
	void SetMouseRange(int MinX,int MinY,int MaxX,int MaxY);
	void ProcessMouse();
	void CloseMouse();
	
	// Keyboard
	bool InitDevices(HINSTANCE g_hinst,HWND hwnd);
	void CloseKeyboard();
	void ProcessKeyboard(); 
	long CheckKey(int KeyNum);
	void KeyboardInterupt();
	char GetCh();
	
};