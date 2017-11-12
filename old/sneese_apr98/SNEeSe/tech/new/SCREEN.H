#ifndef __screen_
#define __screen_

#include <ncurses.h>
#include "machine.h"

#define ARROW_DOWN KEY_DOWN
#define ARROW_UP KEY_UP
#define ARROW_LEFT KEY_LEFT
#define ARROW_RIGHT KEY_RIGHT
#define PAGE_UP	KEY_PPAGE
#define PAGE_DOWN KEY_NPAGE


class screen {
   public:
	screen();
	void putStrCenter(int,char *);
	void toggleJumps(void);
	void noDelay(int);
	int getUserKey(int,int);
	void status(char *,int,int,int);
	void scrollUpMain(char *);
	void scrollDownMain(char *);
	void scrollUpSymbols(char *);
	void scrollDownSymbols(char *);
	int getMainHeight(void);
	void putBar(void);
	void removeBar(void);
	void hideCursor(void);
	int getValue(void);
	char *getSymbol(void);
	~screen();
   private:
	WINDOW *win,*symbols;
	int jumpToggle;
	int x,y;
	int menuOffset;
};

#endif
