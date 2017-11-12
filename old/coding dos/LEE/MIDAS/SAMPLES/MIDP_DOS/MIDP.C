#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <conio.h>
#include <ctype.h>
#include <time.h>
#include <process.h>
#include "midas.h"
#include "mconfig.h"
#include "vu.h"
#include "vga.h"
#include "midp.h"


#ifndef NOTIMER
#define SCRSYNC
#endif

int             numChannels = 0;        /* number of channels in module */
int             activeChannel = 0;      /* active channel number */

uchar           attrDispTop = 0x4F;     /* display top message */
uchar           attrMainBg = 0x70;      /* main window background */
uchar           attrMainLit = 0x7F;     /* main window lit areas */
uchar           attrMainShadow = 0x78;  /* main window shadow areas */
uchar           attrMainBorderLit = 0x0F;   /* main window lit border */
uchar           attrMainBorderSh = 0x08;    /* main window shadow border */
uchar           attrChanInfoSep = 0x70;    /* channel information separator */
uchar           attrChanInfo = 0x70;    /* channel information */
uchar           attrSongInfoLabel = 0x7F;   /* song information label */
uchar           attrSongInfo = 0x70;    /* song information */
uchar           attrUsedInstName = 0x70;    /* used instrument name */
uchar           attrUnusedInstName = 0x78;  /* unused instrument name */
uchar           attrInstNameSeparator = 0x70;  /* instrument name separator */
uchar           attrInstIndicator = 0x7E;   /* instrument used indicator */
uchar           attrActChanMarker = 0x07;   /* active channel marker */
uchar           attrVUMeters = 0x7A;    /* VU meters */
uchar           attrVUBlank = 0x70;     /* Blank VU meters */

int             msgWindowHeight = 8;    /* message window height */

time_t          startTime;              /* total playing time */
time_t          pauseTime = 0;          /* time spent paused */
time_t          pauseStart;             /* start time for current pause */

int             paused = 0;             /* is playing paused? */
unsigned        masterVolume = 64;      /* master volume */
int             instNameMode = 0;       /* instrument name display mode */
int             firstInstName = 1;      /* first instrument name on screen */

int             realVU = 1;             /* are real VU meters active? */

gmpModule       *module;                /* current playing module */
gmpInformation  *info;                  /* current module playing info */
int             callMP;

uchar           chMuted[32];            /* channel muted flags */

unsigned        scrSync;                /* timer screen sync value */

volatile ulong  frameCount;             /* frame counter */

void DumpHeap(void)
{
    static struct _heapinfo hinfo;
    int         hstatus;

    hinfo._pentry = NULL;

    while ( 1 )
    {
        hstatus = _heapwalk(&hinfo);
        if ( hstatus != _HEAPOK )
            break;
        if ( hinfo._useflag == _USEDENTRY )
            printf("USED block at %FP of size %4.4X\n", hinfo._pentry,
                hinfo._size);
        else
            printf("FREE block at %FP of size %4.4X\n", hinfo._pentry,
                hinfo._size);
    }

    switch ( hstatus )
    {
        case _HEAPEND:
            printf("OK - end of heap\n\n");
            break;

        case _HEAPEMPTY:
            printf("OK - heap is empty\n\n");
            break;

        default:
            printf("ERROR - heap corrupted\n\n");
    }
}




void CommandChecksum(void)
{
    ulong       sum = 0;
    int         i;

    for ( i = 0; i < gmpNumCommands; i++ )
        sum += (ulong) gmpTick0CommandsPT[i];
    printf("%08X, ", sum);
    for ( i = 0; i < gmpNumCommands; i++ )
        sum += (ulong) gmpContCommandsPT[i];
    printf("%08X\n", sum);
    fflush(stdout);
}



void CALLING PreVR(void)
{
    frameCount++;
}



void WaitFrame(void)
{
#ifdef SCRSYNC
    ulong       oldFrameCount = frameCount;

    return;

    while ( oldFrameCount == frameCount );
#else
    vgaWaitVR();
    vgaWaitDE();
#endif
}



int CALLING MakeMeter(sdSample *sdsmp, gmpSample *gmpsmp)
{
    return vuPrepare(sdsmp, gmpsmp->sdHandle - 1);
}


int main(int argc, char *argv[])
{
    int         error;
    int         quit = 0;
    int         key, i;
    int         doConfig = 0;
    static fileHandle  f;
    static uchar       buf[48];
    static int  panning;


//    puts("Press any");
//    getch();

    setvbuf(stdout, NULL, _IONBF, 0);

    midasSetDefaults();

    if ( argc < 2 )
    {
        puts("Usage:   MIDP <module> [options]\n");
        puts("Options: -c Manual sound card configuration");
        exit(EXIT_SUCCESS);
    }

    if ( argc > 2 )
    {
        if ( ((argv[2][0] == '-') || (argv[2][0] == '/')) &&
             ((argv[2][1] == 'c') || (argv[2][1] == 'C')) )
            doConfig = 1;
    }

    midasSetDefaults();

    if ( doConfig )
        midasConfig();

    midasDisableEMS = 1;
//    midasOutputMode |= sdMono;
//    midasOutputMode &= (~sdStereo);
//    midasSDNumber = 2;

    InitDisplay();
    DrawScreen();

#ifdef SCRSYNC
    if ( (error = tmrGetScrSync(&scrSync)) != OK )
        midasError(error);
#endif

    midasInit();

    if ( realVU )
        if ( (error = vuInit()) != OK )
            midasError(error);

//#ifdef SCRSYNC
//    if ( (error = tmrSyncScr(scrSync, &PreVR, NULL, NULL)) != OK )
//        midasError(error);
//#endif

    printf("%P\n", dsmMixBuffer);

    printf("Using %s\n%s, using port %X, IRQ %i and DMA %i\n",
        midasSD->name, midasSD->cardNames[midasSD->cardType-1],
        midasSD->port, midasSD->IRQ, midasSD->DMA);

    /* Read first 48 bytes of module: */
    if ( (error = fileOpen(argv[1], fileOpenRead, &f)) != OK )
        midasError(error);
    if ( (error = fileRead(f, buf, 48)) != OK )
        midasError(error);
    if ( (error = fileClose(f)) != OK )
        midasError(error);

    if ( mMemEqual(buf, "Extended Module:", 16) )
    {
        puts("Loading Fasttracker 2 module");
        if ( realVU )
        {
            if ( (error = gmpLoadXM(argv[1], 1, &MakeMeter, &module)) != OK )
                midasError(error);
        }
        else
        {
            if ( (error = gmpLoadXM(argv[1], 1, NULL, &module)) != OK )
                midasError(error);
        }
    }
    else
    {
        if ( mMemEqual(buf+44, "SCRM", 4) )
        {
            puts("Loading Screamtracker 3 module");
            if ( realVU )
            {
                if ( (error = gmpLoadS3M(argv[1], 1, &MakeMeter, &module))
                    != OK )
                    midasError(error);
            }
            else
            {
                if ( (error = gmpLoadS3M(argv[1], 1, NULL, &module)) != OK )
                    midasError(error);
            }
        }
        else
        {
            puts("Loading Protracker module");
            if ( realVU )
            {
                if ( (error = gmpLoadMOD(argv[1], 1, &MakeMeter, &module))
                    != OK )
                    midasError(error);
            }
            else
            {
                if ( (error = gmpLoadMOD(argv[1], 1, NULL, &module)) != OK )
                    midasError(error);
            }
        }
    }
    numChannels = dispChannels = module->numChannels;

    puts("Playing");
    midasPlayModule(module, 0);

    DrawScreen();
    DrawSongInfo();
    startTime = time(NULL);

#ifdef SCRSYNC
    if ( (error = tmrSyncScr(scrSync, &PreVR, NULL, NULL)) != OK )
        midasError(error);
#endif

    /* Clear channel muted flags: */
    for ( i = 0; i < 32; i++ )
        chMuted[i] = 0;

    while ( !quit )
    {
        WaitFrame();

#ifdef BORDERS
        vgaSetBorder(15);
#endif
#ifdef NOTIMER
        if ( (error = midasSD->StartPlay()) != OK )
            midasError(error);
        do
        {
#ifdef BORDERS
            vgaSetBorder(3);
#endif
            if ( (error = midasSD->Play(&callMP)) != OK )
                midasError(error);
#ifdef BORDERS
            vgaSetBorder(13);
#endif
            if ( callMP )
            {
//                CommandChecksum();
                if ( (error = gmpPlay()) != OK )
                    midasError(error);
            }
        } while ( callMP && (midasSD->tempoPoll == 0) );
//        gmpPlay();
#endif
#ifdef BORDERS
        vgaSetBorder(1);
#endif

        if ( (error = gmpGetInformation(midasPlayHandle, &info)) != OK )
            midasError(error);

        UpdateScreen();
#ifdef BORDERS
        vgaSetBorder(0);
#endif

        if ( kbhit() )
        {
            key = mGetKey();                /* read keypress */
            if ( key < 0x100 ) key = toupper ( (char) key );

            switch ( key )
            {
                case 27:
                    quit = 1;
                    break;

                case 9:
                    instNameMode ^= 1;
                    DrawScreen();
                    DrawSongInfo();
                    break;

                case 'D':
#ifdef SCRSYNC
                    if ( (error = tmrStopScrSync()) != OK )
                        midasError(error);
#endif
                    spawnl(P_WAIT, mGetEnv("COMSPEC"), NULL);
                    InitDisplay();
                    DrawScreen();
                    DrawSongInfo();
#ifdef SCRSYNC
                    if ( (error = tmrSyncScr(scrSync, &PreVR, NULL, NULL))
                        != OK )
                        midasError(error);
#endif
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

                    case 0x14d:         /* Right arrow */
incPosition:            gmpHandle->position++;

                        /* Check if we reached song length, and if so, jump to
                            restart position: */
                        if (gmpHandle->position > gmpHandle->songEnd)
                        {
                            gmpHandle->position = gmpHandle->restartPos;
                        }

                        /* Get the pattern number for new position: */
                        if (( gmpCurModule->songData[gmpHandle->position]
                            == 0xfffe ) || (gmpCurModule->
                            songData[gmpHandle->position] == 0xffff))
                            goto incPosition;

                        gmpHandle->pattern = gmpCurModule->
                            songData[gmpHandle->position];
                        gmpHandle->row = 0;
                        gmpHandle->playPtr = NULL;
                        break;

                    case 0x14b:         /* Left arrow */
decPosition:            gmpHandle->position--;
                        if ( gmpHandle->position >= gmpCurModule->songLength )
                            gmpHandle->position = gmpCurModule->songLength-1;
                        if ( (gmpCurModule->songData[gmpHandle->position]
                            == 0xfffe ) || ( gmpCurModule->
                            songData[gmpHandle->position] == 0xffff ) )
                            goto decPosition;

                        gmpHandle->pattern = gmpCurModule->
                            songData[gmpHandle->position];
                        gmpHandle->row = 0;
                        gmpHandle->playPtr = NULL;
                        break;

                    case 0x151:         /* Page down */
                        if ( firstInstName < gmpHandle->module->numInsts )
                        {
                            firstInstName++;
                            DrawInstNames();
                        }
                        break;

                    case 0x149:         /* Page up */
                        if ( firstInstName > 1 )
                        {
                            firstInstName--;
                            DrawInstNames();
                        }
                        break;

                    case 0x148:         /* Up arrow */
                        if ( activeChannel > 0 )
                            activeChannel--;
                        break;

                    case 0x150:         /* Down arrow */
                        if ( activeChannel < (numChannels-1) )
                            activeChannel++;
                        break;

                    case 'T':           /* T - toggle channel mute on/off */
                        chMuted[activeChannel] ^= 1;
                        if ( (error = midasSD->MuteChannel(activeChannel,
                            chMuted[activeChannel])) != OK )
                            midasError(error);
                        break;

                    case 'M':
                        if ( (error = midasSD->SetPanning(activeChannel,
                            panMiddle)) != OK )
                            midasError(error);
                        break;

                    case 'L':
                        if ( (error = midasSD->SetPanning(activeChannel,
                            panLeft)) != OK )
                            midasError(error);
                        break;

                    case 'R':
                        if ( (error = midasSD->SetPanning(activeChannel,
                            panRight)) != OK )
                            midasError(error);
                        break;

                    case 'U':
                        if ( (error = midasSD->SetPanning(activeChannel,
                            panSurround)) != OK )
                            midasError(error);
                        break;

                    case ',':
                        if ( (error = midasSD->GetPanning(activeChannel,
                            &panning)) != OK )
                            midasError(error);
                        if ( panning > panLeft )
                        {
                            panning--;
                            if ( (error = midasSD->SetPanning(activeChannel,
                                panning)) != OK )
                                midasError(error);
                        }
                        break;

                    case '.':
                        if ( (error = midasSD->GetPanning(activeChannel,
                            &panning)) != OK )
                            midasError(error);
                        if ( panning < panRight )
                        {
                            panning++;
                            if ( (error = midasSD->SetPanning(activeChannel,
                                panning)) != OK )
                                midasError(error);
                        }
                        break;
            }
        }
    }

    printf("\n");

    puts("0");
    midasStopModule(module);

    puts("0.5");
    if ( realVU )
    {
        for ( i = 0; i < MAXSAMPLES; i++ )
            if ( (error = vuRemove(i)) != OK )
                midasError(error);
    }

    puts("1");
    if ( (error = gmpFreeModule(module)) != OK )
        midasError(error);

    puts("1.5");
    if ( realVU )
    {
        if ( (error = vuClose()) != OK )
            midasError(error);
    }

    puts("2");
    midasClose();

    DumpHeap();
#ifdef DEBUG
    errPrintList();
#endif

    return 0;
}
