#include <ncurses.h>
#include <stdio.h>
#include <string.h>
#include "screen.h"
#include "machine.h"

screen::screen(void)
{
	initscr();
	cbreak();
	noecho();
	keypad(stdscr,1);
	leaveok(stdscr,1);

	y=stdscr->_maxy+1;
	x=stdscr->_maxx+1;
	jumpToggle=0;

	char str[200]="SPC700 Disassembler v1.0 (c)1994 Jeremy Gordon";
	char str2[100]="Commands";

        wattron(stdscr,A_REVERSE);
	putStrCenter(0,str);
	putStrCenter(y-6,str2);
        wattroff(stdscr,A_REVERSE);

	menuOffset=(x/2)-33;
	mvwprintw(stdscr,y-5,menuOffset+5,"[J]ump to Address"); 
	mvwprintw(stdscr,y-4,menuOffset+5,"[F]ollow Branches/Jumps");
	mvwprintw(stdscr,y-3,menuOffset+5,"[Q]uit");
        mvwprintw(stdscr,y-5,menuOffset+41,"[A]dd Symbol");
        wrefresh(stdscr);

	win=newwin(y-7,x-28,1,0);
	scrollok(win,1);
	wrefresh(win);
	symbols=newwin(y-7,29,1,x-27);
	scrollok(symbols,1);
	wattron(stdscr,A_REVERSE);
	for(int count=1;count<y-6;count++)
	  mvwaddch(stdscr,count,x-28,' ');
	wattroff(stdscr,A_REVERSE);
        curs_set(0);
}
void screen::status(char *fname,int size,int lne,int numlne)
{
	char str3[255];
        sprintf(str3,"FileName[%s] Bytes[%d] Line[%6d/%6d]",fname,size,lne,numlne);
	wattron(stdscr,A_REVERSE);
	putStrCenter(y-1,str3);
	wattroff(stdscr,A_REVERSE);
        wrefresh(stdscr);
}
void screen::noDelay(int flag)
{
	nodelay(stdscr,flag);
}
int screen::getUserKey(int x,int y)
{
	return(mvwgetch(stdscr,y,x));
}
int screen::getValue(void)
{
	char value[100];
	mvwprintw(stdscr,y-5,x/2-10,"=$");
	leaveok(stdscr,0);
	wrefresh(stdscr);
	mvwgetstr(stdscr,y-5,x/2-8,value);
	mvwprintw(stdscr,y-5,x/2-10,"            ");
	leaveok(stdscr,1);
	return(hextodec(value));
}
char *screen::getSymbol(void)
{
	char value[100],*actual;
	mvwprintw(stdscr,y-5,x/2+21,"=");
	leaveok(stdscr,0);
	wrefresh(stdscr);
        mvwgetstr(stdscr,y-5,x/2+22,value);
        mvwprintw(stdscr,y-5,x/2+21,"               ");
        leaveok(stdscr,1);
	actual=strdup(value);
	return(actual);
}
void screen::toggleJumps(void)
{
	jumpToggle=!jumpToggle;
	if(jumpToggle)
        wattron(stdscr,A_REVERSE);
        mvwprintw(stdscr,stdscr->_maxy-3,menuOffset+5,"[F]ollow Branches/Jumps");
        wattroff(stdscr,A_REVERSE);
}
void screen::putStrCenter(int y,char *str)
{
        mvwprintw(stdscr,y,(x/2)-(strlen(str)/2),str);
        for(int count=0;count<=((x/2)-(strlen(str)/2)-1);count++)
           mvwaddch(stdscr,y,count,' ');
        for(count=(((x/2)-(strlen(str)/2)-1)+strlen(str)+1);
		count<=x;count++)
           mvwaddch(stdscr,y,count,' ');
	wrefresh(stdscr);
}
void screen::scrollUpMain(char *str)
{
	wmove(win,0,0);
	winsertln(win);
	mvwaddstr(win,0,0,str);
}
void screen::scrollDownMain(char *str)
{
	scroll(win);
	mvwaddstr(win,win->_maxy,0,str);
}
void screen::scrollUpSymbols(char *str)
{
        wmove(symbols,0,0);
        winsertln(symbols);
        mvwaddstr(symbols,0,0,str);
        wrefresh(symbols);
}
void screen::scrollDownSymbols(char *str)
{
        scroll(symbols);
        mvwaddstr(symbols,symbols->_maxy,0,str);
        wrefresh(symbols);
}
int screen::getMainHeight(void)
{
	return(win->_maxy+1);
}
void screen::putBar(void)
{
	for(int count=1;count<=win->_maxx-2;count++)
          mvwaddch(win,win->_maxy/2,count,mvwinch(win,win->_maxy/2,count)|A_REVERSE);
	wmove(win,win->_maxy/2,win->_maxx-1);
	wrefresh(win);

}
void screen::removeBar(void)
{
        for(int count=0;count<=win->_maxx;count++)
          mvwaddch(win,win->_maxy/2,count,mvwinch(win,win->_maxy/2,count)&A_CHARTEXT);
}
void screen::hideCursor(void)
{
	wmove(stdscr,win->_maxy,0);
}
screen::~screen(void)
{
	endwin();
}
