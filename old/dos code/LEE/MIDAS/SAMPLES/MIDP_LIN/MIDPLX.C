#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <ctype.h>
#include <time.h>
#include <unistd.h>
#include "midas.h"

#include <curses.h>



#define MIDPVERSION 0.1.3
#define MIDPVERSTR "0.1.3"

gmpModule       *module;                /* current playing module */
gmpInformation  *info;                  /* current module playing info */
int             callMP;


char            *title =
"\nMIDAS Module Player for Linux, version " MIDPVERSTR "\n"
"Copyright 1996-1997 Jarno Paananen\n";


char            *usage =
"Usage:\tMIDP\t[options] <filename> [options]\n"\
"Options:\n"\
"\t-?, -h\t This information\n"\
"\t-mx\tMixing rate x Hz\n"\
"\t-ox\tOutput mode (8=8-bit, 1=16-bit, s=stereo, m=mono\n\n"\
"Keys while playing:\n"\
"\tESC\tExit\n"\
"\t+/-\tMaster volume control\n"\
"\t./,\tJump forward/backward in the song\n"\
"\n";


static int mode, rate, end;



int main(int argc, char *argv[])
{
    int                error;
    static fileHandle  f;
    static uchar       buf[48];
    int                i, j, k;
    gmpInstrument      *inst;
    char               *fileName = NULL;
    char               *name;

    int                key, oldRow = 0;

    int                masterVolume = 64;


    setbuf(stdout, NULL);
    setbuf(stdin, NULL);

    puts(title);

    midasSetDefaults();

    if ( argc < 2 )
    {
        puts(usage);
        exit(EXIT_SUCCESS);
    }

    midasSetDefaults();

/* These settings control the default output mode, useful for GUS people at least */
//    midasOutputMode |= sd8bit;
//    midasOutputMode |= sdMono;
//    midasOutputMode &= ~sdStereo;

    for ( i = 1 ; i < argc; i++ )
    {
        if ( argv[i][0] == '-' )
	{
	    switch ( argv[i][1] )
	    {
	        case 'm':
		    sscanf(&argv[i][2], "%d", &midasMixRate );
		    break;

	        case 'o':
		    for ( j = 2; j < 4; j++ )
		    {
		        switch ( argv[i][j] )
			{
			    case '1':
			        midasOutputMode &= ~sd8bit;
				midasOutputMode |= sd16bit;
			        break;
			    case '8':
			        midasOutputMode &= ~sd16bit;
				midasOutputMode |= sd8bit;
			        break;
			    case 's':
			        midasOutputMode &= ~sdMono;
				midasOutputMode |= sdStereo;
			        break;
			    case 'm':
			        midasOutputMode &= ~sdStereo;
				midasOutputMode |= sdMono;
			        break;
                        }
		    }
		    break;

	        default:
		    fileName = argv[i];  // :)
	    }
	}
	else
	    fileName = argv[i];

    }

    if ( fileName == NULL )
    {
        puts("No filename given!\n");
	return 1;
    }

    midasInit();

    /* Read first 48 bytes of module: */
    if ( (error = fileOpen(fileName, fileOpenRead, &f)) != OK )
        midasError(error);
    if ( (error = fileRead(f, buf, 48)) != OK )
        midasError(error);
    if ( (error = fileClose(f)) != OK )
        midasError(error);

    if ( mMemEqual(buf, "Extended Module:", 16) )
    {
        puts("Loading Fasttracker 2 module");
        if ( (error = gmpLoadXM(fileName, 1, NULL, &module)) != OK )
            midasError(error);
    }
    else
    {
        if ( mMemEqual(buf+44, "SCRM", 4) )
        {
            puts("Loading Screamtracker 3 module");
            if ( (error = gmpLoadS3M(fileName, 1, NULL, &module)) != OK )
                midasError(error);
        }
        else
	{
             puts("Loading Protracker module");
                 if((error = gmpLoadMOD(fileName, 1, NULL, &module)) != OK )
                     midasError(error);
	}
    }

    printf("Module: %s\n", module->name);

    k = ( module->numInsts + 1) / 2;

    for ( i = 0; i < k; i++ )
    {
        inst = module->instruments[i];
	name = inst->name;
	while ( *name != 0 )
	{
	    if ( *name < 32 )
	        *name = 32;
	    name++;
	}

        printf( "\n%02x: %-35s", i + 1, inst->name );
        if ( i + k < (int)module->numInsts )
        {
	    inst = module->instruments[i+k];
	    name = inst->name;
	    while ( *name != 0 )
	    {
	        if ( *name < 32 )
	            *name = 32;
		name++;
	    }
            printf( "%02x: %s", i + k + 1, inst->name );
        }	  
    }

    printf("\n\n");
    midasPlayModule(module, 0);

    midasSD->GetMixRate(&rate);
    printf("Playing at %d Hz", rate);
    
    midasSD->GetMode(&mode);
    if ( mode & sd8bit )
        printf(" 8-bit");
    else
        printf(" 16-bit");

    if ( mode & sdMono )
        printf(" mono");
    else
        printf(" stereo");

    end = 0;

    puts("\n");

    /* Initialize ncurses */

    atexit((void*)endwin);
    initscr();
    cbreak();
    nodelay(stdscr, TRUE);
    noecho();


    /* Start playing thread */

    StartPlayThread(100);

    /* The Main Loop */
    while( !end )
    {
        if ( (error = gmpGetInformation(midasPlayHandle, &info)) != OK )
	    midasError(error);

	if ( info->row != (unsigned)oldRow )
	{
	    oldRow = info->row;
	    printf("Position: %02x Pattern: %02x Row: %02x\r", info->position, info->pattern,
		   info->row);

	    fflush(stdout);
	}


	key = getch();


        switch ( key )
        {
            case 27:
                end = 1;
                break;

            case '-':
                if ( masterVolume > 0 )
                    masterVolume--;
                if ( (error = midasSD->SetMasterVolume(masterVolume))
                    != OK )
                    midasError(error);
                break;

            case '+':
                if ( masterVolume < 64 )
                    masterVolume++;
                if ( (error = midasSD->SetMasterVolume(masterVolume))
                    != OK )
                    midasError(error);
                break;

             case '.':         /* Right arrow */
	        gmpSetPosition( midasPlayHandle, info->position + 1 );
		break;

	    case ',':         /* Left arrow */
	        gmpSetPosition( midasPlayHandle, info->position - 1 );
		break;
        }
	usleep(50000);
    }

    /* Wait for the playing thread to return */
    StopPlayThread();


    /* And off we go... */
    printf("\n");
    midasStopModule(module);
    if ( (error = gmpFreeModule(module)) != OK )
        midasError(error);
    midasClose();
    errPrintList();

    return 0;
}
