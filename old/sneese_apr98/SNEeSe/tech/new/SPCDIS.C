#include <stdio.h>
#include "machine.h"
#include "memory.h"
#include "screen.h"
#include "spc700.h"
#include "options.h"

static int upper,lower,current;
void drawLines(screen*,memory*,spc700*);
void doJump(screen*,memory*,spc700*);
void doLabel(screen*,memory*,spc700*);
void doUp(screen*,memory*,spc700*);
void doDown(screen*,memory*,spc700*);
void doLeft(screen*,memory*,spc700*);
void doRight(screen*,memory*,spc700*);


main(int argc,char **argv)
{
	options opts;
	if(opts.parseCommandLine(argc,argv)) return(0);

	memory objectCode;
	if(objectCode.load(opts.getFname(),opts.getLoadAddress())) return(0);

	spc700 disasm;
        printf("performing quick scan, please wait...\n");
	disasm.scan(&objectCode,objectCode.getBase(),
			objectCode.getSize()+objectCode.getBase());

	screen display;
	display.status(opts.getFname(),objectCode.getSize(),1,disasm.getLinecount());

	int key=0; current=0; lower=(display.getMainHeight()/2);
	upper=(-1)*((display.getMainHeight()/2)-1+(display.getMainHeight()%2));

	drawLines(&display,&objectCode,&disasm);

	display.putBar();
	while((key!='Q')&&(key!='q')) {
	  if((key=='f')||(key=='F'))
	 	display.toggleJumps(); 
	  else if((key=='a')||(key=='A')) 
		doLabel(&display,&objectCode,&disasm);	
	  else if(key==ARROW_UP) {
		doUp(&display,&objectCode,&disasm);
		display.status(opts.getFname(),objectCode.getSize(),current+1,disasm.getLinecount());
	  }
          else if(key==ARROW_DOWN) {
		doDown(&display,&objectCode,&disasm);
	        display.status(opts.getFname(),objectCode.getSize(),current+1,disasm.getLinecount());
          }
	  else if(key==ARROW_RIGHT) {
		doRight(&display,&objectCode,&disasm);
		display.status(opts.getFname(),objectCode.getSize(),current+1,disasm.getLinecount());
	  }
	  else if(key==ARROW_LEFT) {
		doLeft(&display,&objectCode,&disasm);
		display.status(opts.getFname(),objectCode.getSize(),current+1,disasm.getLinecount());
	  }
	  else if((key=='j')||(key=='J'))  {
		doJump(&display,&objectCode,&disasm);
                display.status(opts.getFname(),objectCode.getSize(),current+1,disasm.getLinecount());
          }	  
	  key=display.getUserKey(0,0);
	}
}
void doJump(screen *display,memory *objectCode,spc700 *disasm)
{
                int input=display->getValue(),value;
		if(input<objectCode->getBase()) input=objectCode->getBase();
                if(input<(objectCode->getSize()+objectCode->getBase())) {
                  if((value=disasm->inList(input))==-1) {
                        disasm->scan(objectCode,(word)input,
                                objectCode->getSize()+objectCode->getBase());
                        value=disasm->inList(input);
                  }     
                  current=value;
                  lower=current+(display->getMainHeight()/2);
                  upper=current+(-1)*((display->getMainHeight()/2)-1+(display->getMainHeight()%2));
                  display->removeBar();
                  drawLines(display,objectCode,disasm);
                  display->putBar();
                }

}
void doLabel(screen *display,memory *objectCode,spc700 *disasm)
{
	char *freeme=display->getSymbol();
	if(freeme) {
	  disasm->addLabel(current,freeme);
  	  delete freeme;
          display->removeBar();
          drawLines(display,objectCode,disasm);
          display->putBar();
	}
}
void doUp(screen *display,memory *objectCode,spc700 *disasm)
{
		char *freeme;
                current--;
                if(current<0) current=0; 
                else {
                 upper--;
                 lower--;
                 if(upper>=0) {
                  display->removeBar();  
                  display->scrollUpMain(freeme=disasm->getLine(objectCode,upper));
                  display->putBar();
                  delete freeme;        
                 }
                 else {
                  display->removeBar();
                  display->scrollUpMain(" ");
                  display->putBar();
                 }
		}
}
void doDown(screen *display,memory *objectCode,spc700 *disasm)
{
		char *freeme;
                current++;
                if(current>disasm->getLinecount()-1) current=disasm->getLinecount()-1;
                else {
                 upper++;
                 lower++;
                 if(lower<disasm->getLinecount()) {
                  display->removeBar();
                  display->scrollDownMain(freeme=disasm->getLine(objectCode,lower));
                  display->putBar();
                  delete freeme;
                 }
                 else {
                  display->removeBar();
                  display->scrollDownMain("");
                  display->putBar();
                }
		}
}
void doLeft(screen *display,memory *objectCode,spc700 *disasm)
{
		char *freeme;
                current-=display->getMainHeight();
                upper-=display->getMainHeight();
                lower-=display->getMainHeight();
                if(current<0) { 
                  current=0;
                  lower=(display->getMainHeight()/2);
                  upper=(-1)*((display->getMainHeight()/2)-1+(display->getMainHeight()%2));
                }
                display->removeBar();
                drawLines(display,objectCode,disasm);
                display->putBar();
}
void doRight(screen *display,memory *objectCode,spc700 *disasm)
{
		char *freeme;
                current+=display->getMainHeight();       
                upper+=display->getMainHeight();
                lower+=display->getMainHeight();
                if(lower>disasm->getLinecount()-1) { 
                  current=disasm->getLinecount()-1-(display->getMainHeight()/2);
                  lower=disasm->getLinecount()-1;
                  upper=disasm->getLinecount()-1-display->getMainHeight();
                }
                display->removeBar();
                drawLines(display,objectCode,disasm);
                display->putBar();
}
void drawLines(screen *display,memory *objectCode,spc700 *disasm)
{
	char *freeme;
	int count;

	if(upper<0) 
	  for(count=0;count<(display->getMainHeight()/2)+(display->getMainHeight()%2)-1;count++)
		display->scrollDownMain("");
	
	for(count=((upper<0)?0:upper);count<=((lower>disasm->getLinecount()-1)?disasm->getLinecount()-1:lower);count++) {
		display->scrollDownMain(freeme=disasm->getLine(objectCode,count));
		delete freeme;
	}
	if(lower>disasm->getLinecount()-1)
	  for(count=0;count<(display->getMainHeight()/2);count++)
		display->scrollDownMain("");
}

