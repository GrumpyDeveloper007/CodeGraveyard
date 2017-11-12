/*

   Memory mapper V1.2 basicly, it now supports all addresses shown as valid from 
  the memory mapping document (V3.0) by SiMKiN.

  Notes : - Lorom has a rom address space of 3MBytes unlike the previous mapper.


 Mem Functions / Macros / Hardware Mappings for SNES - In Assembler for obvious reasons!

 NB there are numerous jump tables in this chunk of code, I may reduce them to 1 64K!!!!
jump table l8r, to gain a little speed... for now they`ll do as they are.

 Trying a new APU skipper, (This one is a brilliant idea put forward by albert lloyd sawyers,jr!)

  Basicly he wrote A back whenever the APU was called... I`ll go one better I`ll write :

    A.W,X.W,Y.W,A.B,X.B,Y.B in a rotary motion.. see if this fixes problems!

  However, his skipper does not work in all situations.. so I have combined the two methods for
 an even more stable skipper... lets try again!


  NEW MEM MAPPING FUNCTIONALITY.

  To give a potential speed increase, and a small inflation of exe size ;),
 the memory mapper has been modified as follows -

  There are now 4096 pointers (not 256) to various functions that read/write
 to hardware on the snes. This should reduce the need to only complex map
 the hardware devices (GFX,DMA,DSP), the rest can be mapped as simple as
 possible.

  There are various pointer tables to ram areas defined so I can simply add
 the value in %esi (24bit pointer!) to the value of a pointer to get the
 address to read from in PC Memory... V.Fast (in comparison to the current
 method at least!).

  Files are split up (YES! EVEN MORE FILES) as follows :

    mem.S - This file contains the mapping tables and the mapping
           functions.
    memhard.S - Contains the stuff for dealing with hardware (2100 type)
               memory locations.
    memDMA.S  - Contains the dma code.

*/

#include "scankeys.h"

.macro	DUPLICATE vartype, amount, data, from=1		/* Why does this need to be 1 ? */
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

/*#include "memDMA.S"*/
/*#include "memhard.S"*/

/* esi - contains the actual address, al is where the info should be stored, edi is free */
/* NB esi is not corrupted! edi is corrupted! */
/* NB eax is not corrupted barring returnvalue in al... e.g. ah should not be used etc! */

.balign 16
.globl LOW_RAM_READ
LOW_RAM_READ:
	movl _MappedLoRamAddress,%edi
	movw %si,%di
	movb (%edi),%al			/* Return value in al */
	ret

.balign 16
.globl PPU_2X_READ
PPU_2X_READ:
	movl %esi,%edi	
	andl $0x0000FF00,%edi
	cmpl $0x00002100,%edi
	je MAP_READ_21
	movb $0xFF,%al
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message returns what we do! */
	pusha
	call _InvalidHWRead		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl PPU_NOT_SUPPORTED
PPU_NOT_SUPPORTED:
	movb $0xFF,%al
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message returns what we do! */
	pusha
	call _InvalidHWRead		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl PPU_4X_READ
PPU_4X_READ:
    movl %esi,%edi
	andl $0x0000FF00,%edi
	cmpl $0x00004200,%edi
	je MAP_READ_42
	cmpl $0x00004300,%edi
	je MAP_READ_43
	cmpl $0x00004000,%edi
	je MAP_READ_40			/* NOT DOCUMENTED WELL!!!!!! */
	movb $0xFF,%al
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message returns what we do! */
	pusha
	call _InvalidHWRead		/* Unmapped hardware address ! */
	popa
#endif
	ret

.macro ROM_READ_EXPAND num
.balign 16
ROM_READ\num:
	movl _RomReadBuffer+(\num*4),%edi
	movb (%esi,%edi),%al
	ret
.endm

	ROM_READ_EXPAND 0x00
	ROM_READ_EXPAND 0x01
	ROM_READ_EXPAND 0x02
	ROM_READ_EXPAND 0x03
	ROM_READ_EXPAND 0x04
	ROM_READ_EXPAND 0x05
	ROM_READ_EXPAND 0x06
	ROM_READ_EXPAND 0x07
	ROM_READ_EXPAND 0x08
	ROM_READ_EXPAND 0x09
	ROM_READ_EXPAND 0x0A
	ROM_READ_EXPAND 0x0B
	ROM_READ_EXPAND 0x0C
	ROM_READ_EXPAND 0x0D
	ROM_READ_EXPAND 0x0E
	ROM_READ_EXPAND 0x0F
	ROM_READ_EXPAND 0x10
	ROM_READ_EXPAND 0x11
	ROM_READ_EXPAND 0x12
	ROM_READ_EXPAND 0x13
	ROM_READ_EXPAND 0x14
	ROM_READ_EXPAND 0x15
	ROM_READ_EXPAND 0x16
	ROM_READ_EXPAND 0x17
	ROM_READ_EXPAND 0x18
	ROM_READ_EXPAND 0x19
	ROM_READ_EXPAND 0x1A
	ROM_READ_EXPAND 0x1B
	ROM_READ_EXPAND 0x1C
	ROM_READ_EXPAND 0x1D
	ROM_READ_EXPAND 0x1E
	ROM_READ_EXPAND 0x1F
	ROM_READ_EXPAND 0x20
	ROM_READ_EXPAND 0x21
	ROM_READ_EXPAND 0x22
	ROM_READ_EXPAND 0x23
	ROM_READ_EXPAND 0x24
	ROM_READ_EXPAND 0x25
	ROM_READ_EXPAND 0x26
	ROM_READ_EXPAND 0x27
	ROM_READ_EXPAND 0x28
	ROM_READ_EXPAND 0x29
	ROM_READ_EXPAND 0x2A
	ROM_READ_EXPAND 0x2B
	ROM_READ_EXPAND 0x2C
	ROM_READ_EXPAND 0x2D
	ROM_READ_EXPAND 0x2E
	ROM_READ_EXPAND 0x2F
	ROM_READ_EXPAND 0x30
	ROM_READ_EXPAND 0x31
	ROM_READ_EXPAND 0x32
	ROM_READ_EXPAND 0x33
	ROM_READ_EXPAND 0x34
	ROM_READ_EXPAND 0x35
	ROM_READ_EXPAND 0x36
	ROM_READ_EXPAND 0x37
	ROM_READ_EXPAND 0x38
	ROM_READ_EXPAND 0x39
	ROM_READ_EXPAND 0x3A
	ROM_READ_EXPAND 0x3B
	ROM_READ_EXPAND 0x3C
	ROM_READ_EXPAND 0x3D
	ROM_READ_EXPAND 0x3E
	ROM_READ_EXPAND 0x3F
	ROM_READ_EXPAND 0x40
	ROM_READ_EXPAND 0x41
	ROM_READ_EXPAND 0x42
	ROM_READ_EXPAND 0x43
	ROM_READ_EXPAND 0x44
	ROM_READ_EXPAND 0x45
	ROM_READ_EXPAND 0x46
	ROM_READ_EXPAND 0x47
	ROM_READ_EXPAND 0x48
	ROM_READ_EXPAND 0x49
	ROM_READ_EXPAND 0x4A
	ROM_READ_EXPAND 0x4B
	ROM_READ_EXPAND 0x4C
	ROM_READ_EXPAND 0x4D
	ROM_READ_EXPAND 0x4E
	ROM_READ_EXPAND 0x4F
	ROM_READ_EXPAND 0x50
	ROM_READ_EXPAND 0x51
	ROM_READ_EXPAND 0x52
	ROM_READ_EXPAND 0x53
	ROM_READ_EXPAND 0x54
	ROM_READ_EXPAND 0x55
	ROM_READ_EXPAND 0x56
	ROM_READ_EXPAND 0x57
	ROM_READ_EXPAND 0x58
	ROM_READ_EXPAND 0x59
	ROM_READ_EXPAND 0x5A
	ROM_READ_EXPAND 0x5B
	ROM_READ_EXPAND 0x5C
	ROM_READ_EXPAND 0x5D
	ROM_READ_EXPAND 0x5E
	ROM_READ_EXPAND 0x5F

.balign 16
.globl NON_MAPPED_READ
NON_MAPPED_READ:
	movb $0xFF,%al
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message returns what we do! */
	pusha
	call _InvalidHWRead		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl SRAM_READ
SRAM_READ:
	movl _MappedSaveRamAddress,%edi
	movb (%esi,%edi),%al			/* Return value in al */
	ret

.balign 16
.globl RAM_READ
RAM_READ:
	movl _MappedWorkRamAddress,%edi
	movb (%esi,%edi),%al
	ret


.macro HI_ROM_READ_EXPAND num
.balign 16
HI_ROM_READ\num:
	movl _RomHiReadBuffer+(\num*4),%edi
	movb (%esi,%edi),%al
	ret
.endm

	HI_ROM_READ_EXPAND 0x00
	HI_ROM_READ_EXPAND 0x01
	HI_ROM_READ_EXPAND 0x02
	HI_ROM_READ_EXPAND 0x03
	HI_ROM_READ_EXPAND 0x04
	HI_ROM_READ_EXPAND 0x05
	HI_ROM_READ_EXPAND 0x06
	HI_ROM_READ_EXPAND 0x07
	HI_ROM_READ_EXPAND 0x08
	HI_ROM_READ_EXPAND 0x09
	HI_ROM_READ_EXPAND 0x0A
	HI_ROM_READ_EXPAND 0x0B
	HI_ROM_READ_EXPAND 0x0C
	HI_ROM_READ_EXPAND 0x0D
	HI_ROM_READ_EXPAND 0x0E
	HI_ROM_READ_EXPAND 0x0F
	HI_ROM_READ_EXPAND 0x10
	HI_ROM_READ_EXPAND 0x11
	HI_ROM_READ_EXPAND 0x12
	HI_ROM_READ_EXPAND 0x13
	HI_ROM_READ_EXPAND 0x14
	HI_ROM_READ_EXPAND 0x15
	HI_ROM_READ_EXPAND 0x16
	HI_ROM_READ_EXPAND 0x17
	HI_ROM_READ_EXPAND 0x18
	HI_ROM_READ_EXPAND 0x19
	HI_ROM_READ_EXPAND 0x1A
	HI_ROM_READ_EXPAND 0x1B
	HI_ROM_READ_EXPAND 0x1C
	HI_ROM_READ_EXPAND 0x1D
	HI_ROM_READ_EXPAND 0x1E
	HI_ROM_READ_EXPAND 0x1F
	HI_ROM_READ_EXPAND 0x20
	HI_ROM_READ_EXPAND 0x21
	HI_ROM_READ_EXPAND 0x22
	HI_ROM_READ_EXPAND 0x23
	HI_ROM_READ_EXPAND 0x24
	HI_ROM_READ_EXPAND 0x25
	HI_ROM_READ_EXPAND 0x26
	HI_ROM_READ_EXPAND 0x27
	HI_ROM_READ_EXPAND 0x28
	HI_ROM_READ_EXPAND 0x29
	HI_ROM_READ_EXPAND 0x2A
	HI_ROM_READ_EXPAND 0x2B
	HI_ROM_READ_EXPAND 0x2C
	HI_ROM_READ_EXPAND 0x2D
	HI_ROM_READ_EXPAND 0x2E
	HI_ROM_READ_EXPAND 0x2F
	HI_ROM_READ_EXPAND 0x30
	HI_ROM_READ_EXPAND 0x31
	HI_ROM_READ_EXPAND 0x32
	HI_ROM_READ_EXPAND 0x33
	HI_ROM_READ_EXPAND 0x34
	HI_ROM_READ_EXPAND 0x35
	HI_ROM_READ_EXPAND 0x36
	HI_ROM_READ_EXPAND 0x37
	HI_ROM_READ_EXPAND 0x38
	HI_ROM_READ_EXPAND 0x39
	HI_ROM_READ_EXPAND 0x3A
	HI_ROM_READ_EXPAND 0x3B
	HI_ROM_READ_EXPAND 0x3C
	HI_ROM_READ_EXPAND 0x3D
	HI_ROM_READ_EXPAND 0x3E
	HI_ROM_READ_EXPAND 0x3F
	HI_ROM_READ_EXPAND 0x40
	HI_ROM_READ_EXPAND 0x41
	HI_ROM_READ_EXPAND 0x42
	HI_ROM_READ_EXPAND 0x43
	HI_ROM_READ_EXPAND 0x44
	HI_ROM_READ_EXPAND 0x45
	HI_ROM_READ_EXPAND 0x46
	HI_ROM_READ_EXPAND 0x47
	HI_ROM_READ_EXPAND 0x48
	HI_ROM_READ_EXPAND 0x49
	HI_ROM_READ_EXPAND 0x4A
	HI_ROM_READ_EXPAND 0x4B
	HI_ROM_READ_EXPAND 0x4C
	HI_ROM_READ_EXPAND 0x4D
	HI_ROM_READ_EXPAND 0x4E
	HI_ROM_READ_EXPAND 0x4F
	HI_ROM_READ_EXPAND 0x50
	HI_ROM_READ_EXPAND 0x51
	HI_ROM_READ_EXPAND 0x52
	HI_ROM_READ_EXPAND 0x53
	HI_ROM_READ_EXPAND 0x54
	HI_ROM_READ_EXPAND 0x55
	HI_ROM_READ_EXPAND 0x56
	HI_ROM_READ_EXPAND 0x57
	HI_ROM_READ_EXPAND 0x58
	HI_ROM_READ_EXPAND 0x59
	HI_ROM_READ_EXPAND 0x5A
	HI_ROM_READ_EXPAND 0x5B
	HI_ROM_READ_EXPAND 0x5C
	HI_ROM_READ_EXPAND 0x5D
	HI_ROM_READ_EXPAND 0x5E
	HI_ROM_READ_EXPAND 0x5F

.balign 16
.globl UNSUPPORTED_READ
UNSUPPORTED_READ:
	movb $0xFF,%al
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message returns what we do! */
	pusha
	call _InvalidHWRead		/* Unmapped hardware address ! */
	popa
#endif
	ret


/* esi - contains the actual address, al is where the info should be stored, edi is free */
/* NB esi is not corrupted! edi is corrupted! */
/* NB eax is not corrupted barring returnvalue in al... e.g. ah should not be used etc! */

.balign 16
.globl LOW_RAM_WRITE
LOW_RAM_WRITE:
	movl _MappedLoRamAddress,%edi
	movw %si,%di
	movb %al,(%edi)
	ret

.balign 16
.globl PPU_2X_WRITE
PPU_2X_WRITE:
	movl %esi,%edi	
	andl $0x0000FF00,%edi
	cmpl $0x00002100,%edi
	je MAP_WRITE_21
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */

	movb %al,_Map_Byte		/* Set up Map Byte so message works */

	pusha
	call _InvalidHWWrite		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl PPU_4X_WRITE
PPU_4X_WRITE:
	movl %esi,%edi	
	andl $0x0000FF00,%edi
	cmpl $0x00004000,%edi
	je MAP_WRITE_40
	cmpl $0x00004200,%edi
	je MAP_WRITE_42
	cmpl $0x00004300,%edi
	je MAP_WRITE_43
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */

	movb %al,_Map_Byte		/* Set up Map Byte so message works */

	pusha
	call _InvalidHWWrite		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl ROM_WRITE
ROM_WRITE:
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */
	movb %al,_Map_Byte		/* Set up Map Byte so message works */
	pusha
	call _InvalidROMWrite;		/* Display write to ROM warning */
	popa
#endif
	ret

.balign 16
.globl NON_MAPPED_WRITE
NON_MAPPED_WRITE:
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */

	movb %al,_Map_Byte		/* Set up Map Byte so message works */

	pusha
	call _InvalidHWWrite		/* Unmapped hardware address ! */
	popa
#endif
	ret

.balign 16
.globl SRAM_WRITE
SRAM_WRITE:
	movl _MappedSaveRamAddress,%edi
	movb %al,(%esi,%edi)
	ret

.balign 16
.globl RAM_WRITE
RAM_WRITE:
	movl _MappedWorkRamAddress,%edi
	movb %al,(%esi,%edi)
	ret

.balign 16
.globl UNSUPPORTED_WRITE
UNSUPPORTED_WRITE:
#ifdef DEBUG
	movl %esi,_Map_Address		/* Set up Map Address so message works! */

	movb %al,_Map_Byte		/* Set up Map Byte so message works */

	pusha
	call _InvalidHWWrite		/* Unmapped hardware address ! */
	popa
#endif
	ret

.macro READ_00_3F num
	.long LOW_RAM_READ		/* Offset 0000-0FFF */
	.long LOW_RAM_READ		/* Offset 1000-1FFF */
	.long PPU_2X_READ		/* Offset 2000-2FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 3000-3FFF */
	.long PPU_4X_READ		/* Offset 4000-4FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 5000-5FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 6000-6FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 7000-7FFF */
	.long ROM_READ\num		/* Offset 8000-8FFF */
	.long ROM_READ\num		/* Offset 9000-9FFF */
	.long ROM_READ\num		/* Offset A000-AFFF */
	.long ROM_READ\num		/* Offset B000-BFFF */
	.long ROM_READ\num		/* Offset C000-CFFF */
	.long ROM_READ\num		/* Offset D000-DFFF */
	.long ROM_READ\num		/* Offset E000-EFFF */
	.long ROM_READ\num		/* Offset F000-FFFF */
.endm

.macro READ_40_5F num			/* V0.15 support for more lorom address space */
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long ROM_READ\num		/* Offset 8000-8FFF */
	.long ROM_READ\num		/* Offset 9000-9FFF */
	.long ROM_READ\num		/* Offset A000-AFFF */
	.long ROM_READ\num		/* Offset B000-BFFF */
	.long ROM_READ\num		/* Offset C000-CFFF */
	.long ROM_READ\num		/* Offset D000-DFFF */
	.long ROM_READ\num		/* Offset E000-EFFF */
	.long ROM_READ\num		/* Offset F000-FFFF */
.endm

.macro READ_60_6F
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long NON_MAPPED_READ		/* Offset 8000-8FFF */
	.long NON_MAPPED_READ		/* Offset 9000-9FFF */
	.long NON_MAPPED_READ		/* Offset A000-AFFF */
	.long NON_MAPPED_READ		/* Offset B000-BFFF */
	.long NON_MAPPED_READ		/* Offset C000-CFFF */
	.long NON_MAPPED_READ		/* Offset D000-DFFF */
	.long NON_MAPPED_READ		/* Offset E000-EFFF */
	.long NON_MAPPED_READ		/* Offset F000-FFFF */
.endm

.macro READ_70_73
	.long SRAM_READ		/* Offset 0000-0FFF */
	.long SRAM_READ		/* Offset 1000-1FFF */
	.long SRAM_READ		/* Offset 2000-2FFF */
	.long SRAM_READ		/* Offset 3000-3FFF */
	.long SRAM_READ		/* Offset 4000-4FFF */
	.long SRAM_READ		/* Offset 5000-5FFF */
	.long SRAM_READ		/* Offset 6000-6FFF */
	.long SRAM_READ		/* Offset 7000-7FFF */
	.long SRAM_READ		/* Offset 8000-8FFF */
	.long SRAM_READ		/* Offset 9000-9FFF */
	.long SRAM_READ		/* Offset A000-AFFF */
	.long SRAM_READ		/* Offset B000-BFFF */
	.long SRAM_READ		/* Offset C000-CFFF */
	.long SRAM_READ		/* Offset D000-DFFF */
	.long SRAM_READ		/* Offset E000-EFFF */
	.long SRAM_READ		/* Offset F000-FFFF */
.endm

.macro READ_74_7D
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long NON_MAPPED_READ		/* Offset 8000-8FFF */
	.long NON_MAPPED_READ		/* Offset 9000-9FFF */
	.long NON_MAPPED_READ		/* Offset A000-AFFF */
	.long NON_MAPPED_READ		/* Offset B000-BFFF */
	.long NON_MAPPED_READ		/* Offset C000-CFFF */
	.long NON_MAPPED_READ		/* Offset D000-DFFF */
	.long NON_MAPPED_READ		/* Offset E000-EFFF */
	.long NON_MAPPED_READ		/* Offset F000-FFFF */
.endm

.macro READ_7E_7F
	.long RAM_READ		/* Offset 0000-0FFF */
	.long RAM_READ		/* Offset 1000-1FFF */
	.long RAM_READ		/* Offset 2000-2FFF */
	.long RAM_READ		/* Offset 3000-3FFF */
	.long RAM_READ		/* Offset 4000-4FFF */
	.long RAM_READ		/* Offset 5000-5FFF */
	.long RAM_READ		/* Offset 6000-6FFF */
	.long RAM_READ		/* Offset 7000-7FFF */
	.long RAM_READ		/* Offset 8000-8FFF */
	.long RAM_READ		/* Offset 9000-9FFF */
	.long RAM_READ		/* Offset A000-AFFF */
	.long RAM_READ		/* Offset B000-BFFF */
	.long RAM_READ		/* Offset C000-CFFF */
	.long RAM_READ		/* Offset D000-DFFF */
	.long RAM_READ		/* Offset E000-EFFF */
	.long RAM_READ		/* Offset F000-FFFF */
.endm

.macro READ_80_BF num
	.long LOW_RAM_READ		/* Offset 0000-0FFF */
	.long LOW_RAM_READ		/* Offset 1000-1FFF */
	.long PPU_2X_READ		/* Offset 2000-2FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 3000-3FFF */
	.long PPU_4X_READ		/* Offset 4000-4FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 5000-5FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 6000-6FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 7000-7FFF */
	.long HI_ROM_READ\num		/* Offset 8000-8FFF */
	.long HI_ROM_READ\num		/* Offset 9000-9FFF */
	.long HI_ROM_READ\num		/* Offset A000-AFFF */
	.long HI_ROM_READ\num		/* Offset B000-BFFF */
	.long HI_ROM_READ\num		/* Offset C000-CFFF */
	.long HI_ROM_READ\num		/* Offset D000-DFFF */
	.long HI_ROM_READ\num		/* Offset E000-EFFF */
	.long HI_ROM_READ\num		/* Offset F000-FFFF */
.endm

.macro READ_C0_DF num			/* V0.15 support for more lorom address space */
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long HI_ROM_READ\num		/* Offset 8000-8FFF */
	.long HI_ROM_READ\num		/* Offset 9000-9FFF */
	.long HI_ROM_READ\num		/* Offset A000-AFFF */
	.long HI_ROM_READ\num		/* Offset B000-BFFF */
	.long HI_ROM_READ\num		/* Offset C000-CFFF */
	.long HI_ROM_READ\num		/* Offset D000-DFFF */
	.long HI_ROM_READ\num		/* Offset E000-EFFF */
	.long HI_ROM_READ\num		/* Offset F000-FFFF */
.endm

.macro READ_E0_FF
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long NON_MAPPED_READ		/* Offset 8000-8FFF */
	.long NON_MAPPED_READ		/* Offset 9000-9FFF */
	.long NON_MAPPED_READ		/* Offset A000-AFFF */
	.long NON_MAPPED_READ		/* Offset B000-BFFF */
	.long NON_MAPPED_READ		/* Offset C000-CFFF */
	.long NON_MAPPED_READ		/* Offset D000-DFFF */
	.long NON_MAPPED_READ		/* Offset E000-EFFF */
	.long NON_MAPPED_READ		/* Offset F000-FFFF */
.endm

.macro WRITE_00_3F
	.long LOW_RAM_WRITE		/* Offset 0000-0FFF */
	.long LOW_RAM_WRITE		/* Offset 1000-1FFF */
	.long PPU_2X_WRITE		/* Offset 2000-2FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 3000-3FFF */
	.long PPU_4X_WRITE		/* Offset 4000-4FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 5000-5FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 6000-6FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 7000-7FFF */
	.long ROM_WRITE   		/* Offset 8000-8FFF */
	.long ROM_WRITE   		/* Offset 9000-9FFF */
	.long ROM_WRITE   		/* Offset A000-AFFF */
	.long ROM_WRITE   		/* Offset B000-BFFF */
	.long ROM_WRITE   		/* Offset C000-CFFF */
	.long ROM_WRITE   		/* Offset D000-DFFF */
	.long ROM_WRITE   		/* Offset E000-EFFF */
	.long ROM_WRITE   		/* Offset F000-FFFF */
.endm

.macro WRITE_40_5F num			/* V0.15 support for more lorom address space */
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long ROM_WRITE			/* Offset 8000-8FFF */
	.long ROM_WRITE			/* Offset 9000-9FFF */
	.long ROM_WRITE			/* Offset A000-AFFF */
	.long ROM_WRITE			/* Offset B000-BFFF */
	.long ROM_WRITE			/* Offset C000-CFFF */
	.long ROM_WRITE			/* Offset D000-DFFF */
	.long ROM_WRITE			/* Offset E000-EFFF */
	.long ROM_WRITE			/* Offset F000-FFFF */
.endm

.macro WRITE_60_6F
	.long NON_MAPPED_WRITE		/* Offset 0000-0FFF */
	.long NON_MAPPED_WRITE		/* Offset 1000-1FFF */
	.long NON_MAPPED_WRITE		/* Offset 2000-2FFF */
	.long NON_MAPPED_WRITE		/* Offset 3000-3FFF */
	.long NON_MAPPED_WRITE		/* Offset 4000-4FFF */
	.long NON_MAPPED_WRITE		/* Offset 5000-5FFF */
	.long NON_MAPPED_WRITE		/* Offset 6000-6FFF */
	.long NON_MAPPED_WRITE		/* Offset 7000-7FFF */
	.long NON_MAPPED_WRITE		/* Offset 8000-8FFF */
	.long NON_MAPPED_WRITE		/* Offset 9000-9FFF */
	.long NON_MAPPED_WRITE		/* Offset A000-AFFF */
	.long NON_MAPPED_WRITE		/* Offset B000-BFFF */
	.long NON_MAPPED_WRITE		/* Offset C000-CFFF */
	.long NON_MAPPED_WRITE		/* Offset D000-DFFF */
	.long NON_MAPPED_WRITE		/* Offset E000-EFFF */
	.long NON_MAPPED_WRITE		/* Offset F000-FFFF */
.endm

.macro WRITE_70_73
	.long SRAM_WRITE	/* Offset 0000-0FFF */
	.long SRAM_WRITE	/* Offset 1000-1FFF */
	.long SRAM_WRITE	/* Offset 2000-2FFF */
	.long SRAM_WRITE	/* Offset 3000-3FFF */
	.long SRAM_WRITE	/* Offset 4000-4FFF */
	.long SRAM_WRITE	/* Offset 5000-5FFF */
	.long SRAM_WRITE	/* Offset 6000-6FFF */
	.long SRAM_WRITE	/* Offset 7000-7FFF */
	.long SRAM_WRITE	/* Offset 8000-8FFF */
	.long SRAM_WRITE	/* Offset 9000-9FFF */
	.long SRAM_WRITE	/* Offset A000-AFFF */
	.long SRAM_WRITE	/* Offset B000-BFFF */
	.long SRAM_WRITE	/* Offset C000-CFFF */
	.long SRAM_WRITE	/* Offset D000-DFFF */
	.long SRAM_WRITE	/* Offset E000-EFFF */
	.long SRAM_WRITE	/* Offset F000-FFFF */
.endm

.macro WRITE_74_7D
	.long NON_MAPPED_WRITE		/* Offset 0000-0FFF */
	.long NON_MAPPED_WRITE		/* Offset 1000-1FFF */
	.long NON_MAPPED_WRITE		/* Offset 2000-2FFF */
	.long NON_MAPPED_WRITE		/* Offset 3000-3FFF */
	.long NON_MAPPED_WRITE		/* Offset 4000-4FFF */
	.long NON_MAPPED_WRITE		/* Offset 5000-5FFF */
	.long NON_MAPPED_WRITE		/* Offset 6000-6FFF */
	.long NON_MAPPED_WRITE		/* Offset 7000-7FFF */
	.long NON_MAPPED_WRITE		/* Offset 8000-8FFF */
	.long NON_MAPPED_WRITE		/* Offset 9000-9FFF */
	.long NON_MAPPED_WRITE		/* Offset A000-AFFF */
	.long NON_MAPPED_WRITE		/* Offset B000-BFFF */
	.long NON_MAPPED_WRITE		/* Offset C000-CFFF */
	.long NON_MAPPED_WRITE		/* Offset D000-DFFF */
	.long NON_MAPPED_WRITE		/* Offset E000-EFFF */
	.long NON_MAPPED_WRITE		/* Offset F000-FFFF */
.endm

.macro WRITE_7E_7F
	.long RAM_WRITE		/* Offset 0000-0FFF */
	.long RAM_WRITE		/* Offset 1000-1FFF */
	.long RAM_WRITE		/* Offset 2000-2FFF */
	.long RAM_WRITE		/* Offset 3000-3FFF */
	.long RAM_WRITE		/* Offset 4000-4FFF */
	.long RAM_WRITE		/* Offset 5000-5FFF */
	.long RAM_WRITE		/* Offset 6000-6FFF */
	.long RAM_WRITE		/* Offset 7000-7FFF */
	.long RAM_WRITE		/* Offset 8000-8FFF */
	.long RAM_WRITE		/* Offset 9000-9FFF */
	.long RAM_WRITE		/* Offset A000-AFFF */
	.long RAM_WRITE		/* Offset B000-BFFF */
	.long RAM_WRITE		/* Offset C000-CFFF */
	.long RAM_WRITE		/* Offset D000-DFFF */
	.long RAM_WRITE		/* Offset E000-EFFF */
	.long RAM_WRITE		/* Offset F000-FFFF */
.endm

.macro WRITE_80_BF
	.long LOW_RAM_WRITE		/* Offset 0000-0FFF */
	.long LOW_RAM_WRITE		/* Offset 1000-1FFF */
	.long PPU_2X_WRITE		/* Offset 2000-2FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 3000-3FFF */
	.long PPU_4X_WRITE		/* Offset 4000-4FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 5000-5FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 6000-6FFF */
	.long PPU_NOT_SUPPORTED		/* Offset 7000-7FFF */
	.long ROM_WRITE    		/* Offset 8000-8FFF */
	.long ROM_WRITE    		/* Offset 9000-9FFF */
	.long ROM_WRITE    		/* Offset A000-AFFF */
	.long ROM_WRITE    		/* Offset B000-BFFF */
	.long ROM_WRITE    		/* Offset C000-CFFF */
	.long ROM_WRITE    		/* Offset D000-DFFF */
	.long ROM_WRITE    		/* Offset E000-EFFF */
	.long ROM_WRITE    		/* Offset F000-FFFF */
.endm

.macro WRITE_C0_DF num			/* V0.15 support for more lorom address space */
	.long NON_MAPPED_READ		/* Offset 0000-0FFF */
	.long NON_MAPPED_READ		/* Offset 1000-1FFF */
	.long NON_MAPPED_READ		/* Offset 2000-2FFF */
	.long NON_MAPPED_READ		/* Offset 3000-3FFF */
	.long NON_MAPPED_READ		/* Offset 4000-4FFF */
	.long NON_MAPPED_READ		/* Offset 5000-5FFF */
	.long NON_MAPPED_READ		/* Offset 6000-6FFF */
	.long NON_MAPPED_READ		/* Offset 7000-7FFF */
	.long ROM_WRITE			/* Offset 8000-8FFF */
	.long ROM_WRITE			/* Offset 9000-9FFF */
	.long ROM_WRITE			/* Offset A000-AFFF */
	.long ROM_WRITE			/* Offset B000-BFFF */
	.long ROM_WRITE			/* Offset C000-CFFF */
	.long ROM_WRITE			/* Offset D000-DFFF */
	.long ROM_WRITE			/* Offset E000-EFFF */
	.long ROM_WRITE			/* Offset F000-FFFF */
.endm

.macro WRITE_E0_FF
	.long NON_MAPPED_WRITE		/* Offset 0000-0FFF */
	.long NON_MAPPED_WRITE		/* Offset 1000-1FFF */
	.long NON_MAPPED_WRITE		/* Offset 2000-2FFF */
	.long NON_MAPPED_WRITE		/* Offset 3000-3FFF */
	.long NON_MAPPED_WRITE		/* Offset 4000-4FFF */
	.long NON_MAPPED_WRITE		/* Offset 5000-5FFF */
	.long NON_MAPPED_WRITE		/* Offset 6000-6FFF */
	.long NON_MAPPED_WRITE		/* Offset 7000-7FFF */
	.long NON_MAPPED_WRITE		/* Offset 8000-8FFF */
	.long NON_MAPPED_WRITE		/* Offset 9000-9FFF */
	.long NON_MAPPED_WRITE		/* Offset A000-AFFF */
	.long NON_MAPPED_WRITE		/* Offset B000-BFFF */
	.long NON_MAPPED_WRITE		/* Offset C000-CFFF */
	.long NON_MAPPED_WRITE		/* Offset D000-DFFF */
	.long NON_MAPPED_WRITE		/* Offset E000-EFFF */
	.long NON_MAPPED_WRITE		/* Offset F000-FFFF */
.endm

.data
.globl Read_BankMapping
Read_BankMapping:

/* Banks 00-3F are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	READ_00_3F 0x00 
	READ_00_3F 0x01 
	READ_00_3F 0x02 
	READ_00_3F 0x03 
	READ_00_3F 0x04 
	READ_00_3F 0x05 
	READ_00_3F 0x06 
	READ_00_3F 0x07 
	READ_00_3F 0x08 
	READ_00_3F 0x09 
	READ_00_3F 0x0A 
	READ_00_3F 0x0B 
	READ_00_3F 0x0C 
	READ_00_3F 0x0D 
	READ_00_3F 0x0E 
	READ_00_3F 0x0F 
	READ_00_3F 0x10 
	READ_00_3F 0x11 
	READ_00_3F 0x12 
	READ_00_3F 0x13
	READ_00_3F 0x14 
	READ_00_3F 0x15 
	READ_00_3F 0x16 
	READ_00_3F 0x17 
	READ_00_3F 0x18 
	READ_00_3F 0x19 
	READ_00_3F 0x1A 
	READ_00_3F 0x1B 
	READ_00_3F 0x1C 
	READ_00_3F 0x1D 
	READ_00_3F 0x1E 
	READ_00_3F 0x1F 
	READ_00_3F 0x20 
	READ_00_3F 0x21 
	READ_00_3F 0x22 
	READ_00_3F 0x23 
	READ_00_3F 0x24 
	READ_00_3F 0x25 
	READ_00_3F 0x26 
	READ_00_3F 0x27 
	READ_00_3F 0x28 
	READ_00_3F 0x29 
	READ_00_3F 0x2A 
	READ_00_3F 0x2B 
	READ_00_3F 0x2C 
	READ_00_3F 0x2D 
	READ_00_3F 0x2E 
	READ_00_3F 0x2F
	READ_00_3F 0x30
	READ_00_3F 0x31
	READ_00_3F 0x32
	READ_00_3F 0x33
	READ_00_3F 0x34
	READ_00_3F 0x35
	READ_00_3F 0x36
	READ_00_3F 0x37
	READ_00_3F 0x38
	READ_00_3F 0x39
	READ_00_3F 0x3A
	READ_00_3F 0x3B
	READ_00_3F 0x3C
	READ_00_3F 0x3D
	READ_00_3F 0x3E
	READ_00_3F 0x3F

/* Banks 40-5F are 0000-7fff RESERVED 8000-ffff ROM */

	READ_40_5F 0x40
	READ_40_5F 0x41
	READ_40_5F 0x42
	READ_40_5F 0x43
	READ_40_5F 0x44
	READ_40_5F 0x45
	READ_40_5F 0x46
	READ_40_5F 0x47
	READ_40_5F 0x48
	READ_40_5F 0x49
	READ_40_5F 0x4A
	READ_40_5F 0x4B
	READ_40_5F 0x4C
	READ_40_5F 0x4D
	READ_40_5F 0x4E
	READ_40_5F 0x4F
	READ_40_5F 0x50
	READ_40_5F 0x51
	READ_40_5F 0x52
	READ_40_5F 0x53
	READ_40_5F 0x54
	READ_40_5F 0x55
	READ_40_5F 0x56
	READ_40_5F 0x57
	READ_40_5F 0x58
	READ_40_5F 0x59
	READ_40_5F 0x5A
	READ_40_5F 0x5B
	READ_40_5F 0x5C
	READ_40_5F 0x5D
	READ_40_5F 0x5E
	READ_40_5F 0x5F

/* Banks 60-6F are not mapped! */

	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F

/* Banks 70-73 are SRAM */

	READ_70_73
	READ_70_73
	READ_70_73
	READ_70_73

/* Banks 74-7d are not mapped! */

	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D

/* Bank  7e-7f is  0000-ffff RAM Nb 7e is used to store that 8KB block thats repeated in mem */

	READ_7E_7F
	READ_7E_7F

/* Banks 80-BF are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	READ_80_BF 0x00 
	READ_80_BF 0x01 
	READ_80_BF 0x02 
	READ_80_BF 0x03 
	READ_80_BF 0x04 
	READ_80_BF 0x05 
	READ_80_BF 0x06 
	READ_80_BF 0x07 
	READ_80_BF 0x08 
	READ_80_BF 0x09 
	READ_80_BF 0x0A 
	READ_80_BF 0x0B 
	READ_80_BF 0x0C 
	READ_80_BF 0x0D 
	READ_80_BF 0x0E 
	READ_80_BF 0x0F 
	READ_80_BF 0x10 
	READ_80_BF 0x11 
	READ_80_BF 0x12 
	READ_80_BF 0x13
	READ_80_BF 0x14 
	READ_80_BF 0x15 
	READ_80_BF 0x16 
	READ_80_BF 0x17 
	READ_80_BF 0x18 
	READ_80_BF 0x19 
	READ_80_BF 0x1A 
	READ_80_BF 0x1B 
	READ_80_BF 0x1C 
	READ_80_BF 0x1D 
	READ_80_BF 0x1E 
	READ_80_BF 0x1F 
	READ_80_BF 0x20 
	READ_80_BF 0x21 
	READ_80_BF 0x22 
	READ_80_BF 0x23 
	READ_80_BF 0x24 
	READ_80_BF 0x25 
	READ_80_BF 0x26 
	READ_80_BF 0x27 
	READ_80_BF 0x28 
	READ_80_BF 0x29 
	READ_80_BF 0x2A 
	READ_80_BF 0x2B 
	READ_80_BF 0x2C 
	READ_80_BF 0x2D 
	READ_80_BF 0x2E 
	READ_80_BF 0x2F
	READ_80_BF 0x30
	READ_80_BF 0x31
	READ_80_BF 0x32
	READ_80_BF 0x33
	READ_80_BF 0x34
	READ_80_BF 0x35
	READ_80_BF 0x36
	READ_80_BF 0x37
	READ_80_BF 0x38
	READ_80_BF 0x39
	READ_80_BF 0x3A
	READ_80_BF 0x3B
	READ_80_BF 0x3C
	READ_80_BF 0x3D
	READ_80_BF 0x3E
	READ_80_BF 0x3F

/* Banks C0-DF are 0000-7fff RESERVED 8000-ffff ROM */

	READ_C0_DF 0x40
	READ_C0_DF 0x41
	READ_C0_DF 0x42
	READ_C0_DF 0x43
	READ_C0_DF 0x44
	READ_C0_DF 0x45
	READ_C0_DF 0x46
	READ_C0_DF 0x47
	READ_C0_DF 0x48
	READ_C0_DF 0x49
	READ_C0_DF 0x4A
	READ_C0_DF 0x4B
	READ_C0_DF 0x4C
	READ_C0_DF 0x4D
	READ_C0_DF 0x4E
	READ_C0_DF 0x4F
	READ_C0_DF 0x50
	READ_C0_DF 0x51
	READ_C0_DF 0x52
	READ_C0_DF 0x53
	READ_C0_DF 0x54
	READ_C0_DF 0x55
	READ_C0_DF 0x56
	READ_C0_DF 0x57
	READ_C0_DF 0x58
	READ_C0_DF 0x59
	READ_C0_DF 0x5A
	READ_C0_DF 0x5B
	READ_C0_DF 0x5C
	READ_C0_DF 0x5D
	READ_C0_DF 0x5E
	READ_C0_DF 0x5F

/* Rest are unmapped */

	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF

.globl Write_BankMapping
Write_BankMapping:

/* Banks 00-3F are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F

/* Banks 40-5F are 0000-7fff RESERVED 8000-ffff ROM */

	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F

/* Banks 60-6F are not mapped! */

	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F

/* Banks 70-73 are SRAM */

	WRITE_70_73
	WRITE_70_73
	WRITE_70_73
	WRITE_70_73
	WRITE_70_73

/* Banks 74-7d are not mapped! */

	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D

/* Bank  7e-7f is  0000-ffff RAM Nb 7e is used to store that 8KB block thats repeated in mem */

	WRITE_7E_7F
	WRITE_7E_7F

/* Banks 80-BF are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF

/* Banks C0-DF are 0000-7fff RESERVED 8000-ffff ROM */

	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF

/* Rest are unmapped */

	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF

.globl LO_ROM_READ
LO_ROM_READ:

/* Banks 00-3F are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	READ_00_3F 0x00 
	READ_00_3F 0x01 
	READ_00_3F 0x02 
	READ_00_3F 0x03 
	READ_00_3F 0x04 
	READ_00_3F 0x05 
	READ_00_3F 0x06 
	READ_00_3F 0x07 
	READ_00_3F 0x08 
	READ_00_3F 0x09 
	READ_00_3F 0x0A 
	READ_00_3F 0x0B 
	READ_00_3F 0x0C 
	READ_00_3F 0x0D 
	READ_00_3F 0x0E 
	READ_00_3F 0x0F 
	READ_00_3F 0x10 
	READ_00_3F 0x11 
	READ_00_3F 0x12 
	READ_00_3F 0x13
	READ_00_3F 0x14 
	READ_00_3F 0x15 
	READ_00_3F 0x16 
	READ_00_3F 0x17 
	READ_00_3F 0x18 
	READ_00_3F 0x19 
	READ_00_3F 0x1A 
	READ_00_3F 0x1B 
	READ_00_3F 0x1C 
	READ_00_3F 0x1D 
	READ_00_3F 0x1E 
	READ_00_3F 0x1F 
	READ_00_3F 0x20 
	READ_00_3F 0x21 
	READ_00_3F 0x22 
	READ_00_3F 0x23 
	READ_00_3F 0x24 
	READ_00_3F 0x25 
	READ_00_3F 0x26 
	READ_00_3F 0x27 
	READ_00_3F 0x28 
	READ_00_3F 0x29 
	READ_00_3F 0x2A 
	READ_00_3F 0x2B 
	READ_00_3F 0x2C 
	READ_00_3F 0x2D 
	READ_00_3F 0x2E 
	READ_00_3F 0x2F
	READ_00_3F 0x30
	READ_00_3F 0x31
	READ_00_3F 0x32
	READ_00_3F 0x33
	READ_00_3F 0x34
	READ_00_3F 0x35
	READ_00_3F 0x36
	READ_00_3F 0x37
	READ_00_3F 0x38
	READ_00_3F 0x39
	READ_00_3F 0x3A
	READ_00_3F 0x3B
	READ_00_3F 0x3C
	READ_00_3F 0x3D
	READ_00_3F 0x3E
	READ_00_3F 0x3F

/* Banks 40-5F are 0000-7fff RESERVED 8000-ffff ROM */

	READ_40_5F 0x40
	READ_40_5F 0x41
	READ_40_5F 0x42
	READ_40_5F 0x43
	READ_40_5F 0x44
	READ_40_5F 0x45
	READ_40_5F 0x46
	READ_40_5F 0x47
	READ_40_5F 0x48
	READ_40_5F 0x49
	READ_40_5F 0x4A
	READ_40_5F 0x4B
	READ_40_5F 0x4C
	READ_40_5F 0x4D
	READ_40_5F 0x4E
	READ_40_5F 0x4F
	READ_40_5F 0x50
	READ_40_5F 0x51
	READ_40_5F 0x52
	READ_40_5F 0x53
	READ_40_5F 0x54
	READ_40_5F 0x55
	READ_40_5F 0x56
	READ_40_5F 0x57
	READ_40_5F 0x58
	READ_40_5F 0x59
	READ_40_5F 0x5A
	READ_40_5F 0x5B
	READ_40_5F 0x5C
	READ_40_5F 0x5D
	READ_40_5F 0x5E
	READ_40_5F 0x5F

/* Banks 60-6F are not mapped! */

	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F
	READ_60_6F

/* Banks 70-73 are SRAM */

	READ_70_73
	READ_70_73
	READ_70_73
	READ_70_73

/* Banks 74-7d are not mapped! */

	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D
	READ_74_7D

/* Bank  7e-7f is  0000-ffff RAM Nb 7e is used to store that 8KB block thats repeated in mem */

	READ_7E_7F
	READ_7E_7F

/* Banks 80-BF are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	READ_80_BF 0x00 
	READ_80_BF 0x01 
	READ_80_BF 0x02 
	READ_80_BF 0x03 
	READ_80_BF 0x04 
	READ_80_BF 0x05 
	READ_80_BF 0x06 
	READ_80_BF 0x07 
	READ_80_BF 0x08 
	READ_80_BF 0x09 
	READ_80_BF 0x0A 
	READ_80_BF 0x0B 
	READ_80_BF 0x0C 
	READ_80_BF 0x0D 
	READ_80_BF 0x0E 
	READ_80_BF 0x0F 
	READ_80_BF 0x10 
	READ_80_BF 0x11 
	READ_80_BF 0x12 
	READ_80_BF 0x13
	READ_80_BF 0x14 
	READ_80_BF 0x15 
	READ_80_BF 0x16 
	READ_80_BF 0x17 
	READ_80_BF 0x18 
	READ_80_BF 0x19 
	READ_80_BF 0x1A 
	READ_80_BF 0x1B 
	READ_80_BF 0x1C 
	READ_80_BF 0x1D 
	READ_80_BF 0x1E 
	READ_80_BF 0x1F 
	READ_80_BF 0x20 
	READ_80_BF 0x21 
	READ_80_BF 0x22 
	READ_80_BF 0x23 
	READ_80_BF 0x24 
	READ_80_BF 0x25 
	READ_80_BF 0x26 
	READ_80_BF 0x27 
	READ_80_BF 0x28 
	READ_80_BF 0x29 
	READ_80_BF 0x2A 
	READ_80_BF 0x2B 
	READ_80_BF 0x2C 
	READ_80_BF 0x2D 
	READ_80_BF 0x2E 
	READ_80_BF 0x2F
	READ_80_BF 0x30
	READ_80_BF 0x31
	READ_80_BF 0x32
	READ_80_BF 0x33
	READ_80_BF 0x34
	READ_80_BF 0x35
	READ_80_BF 0x36
	READ_80_BF 0x37
	READ_80_BF 0x38
	READ_80_BF 0x39
	READ_80_BF 0x3A
	READ_80_BF 0x3B
	READ_80_BF 0x3C
	READ_80_BF 0x3D
	READ_80_BF 0x3E
	READ_80_BF 0x3F

/* Banks C0-DF are 0000-7fff RESERVED 8000-ffff ROM */

	READ_C0_DF 0x40
	READ_C0_DF 0x41
	READ_C0_DF 0x42
	READ_C0_DF 0x43
	READ_C0_DF 0x44
	READ_C0_DF 0x45
	READ_C0_DF 0x46
	READ_C0_DF 0x47
	READ_C0_DF 0x48
	READ_C0_DF 0x49
	READ_C0_DF 0x4A
	READ_C0_DF 0x4B
	READ_C0_DF 0x4C
	READ_C0_DF 0x4D
	READ_C0_DF 0x4E
	READ_C0_DF 0x4F
	READ_C0_DF 0x50
	READ_C0_DF 0x51
	READ_C0_DF 0x52
	READ_C0_DF 0x53
	READ_C0_DF 0x54
	READ_C0_DF 0x55
	READ_C0_DF 0x56
	READ_C0_DF 0x57
	READ_C0_DF 0x58
	READ_C0_DF 0x59
	READ_C0_DF 0x5A
	READ_C0_DF 0x5B
	READ_C0_DF 0x5C
	READ_C0_DF 0x5D
	READ_C0_DF 0x5E
	READ_C0_DF 0x5F

/* Rest are unmapped */

	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF
	READ_E0_FF

.globl LO_ROM_WRITE
LO_ROM_WRITE:

/* Banks 00-3F are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F
	WRITE_00_3F

/* Banks 40-5F are 0000-7fff RESERVED 8000-ffff ROM */

	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F
	WRITE_40_5F

/* Banks 60-6F are not mapped! */

	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F
	WRITE_60_6F

/* Banks 70-73 are SRAM */

	WRITE_70_73
	WRITE_70_73
	WRITE_70_73
	WRITE_70_73
	WRITE_70_73

/* Banks 74-7d are not mapped! */

	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D
	WRITE_74_7D

/* Bank  7e-7f is  0000-ffff RAM Nb 7e is used to store that 8KB block thats repeated in mem */

	WRITE_7E_7F
	WRITE_7E_7F

/* Banks 80-BF are 0000-1fff LOW RAM 2000-2fff PPU 3000-7fff FX/DSP 8000-ffff ROM */

	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF
	WRITE_80_BF

/* Banks C0-DF are 0000-7fff RESERVED 8000-ffff ROM */

	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF
	WRITE_C0_DF

/* Rest are unmapped */

	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF
	WRITE_E0_FF


/*-------------------------------------------------------------------------------------------*/
/*     The following are copied to the lorom versions (above) when hirom mode is needed!     */
/*-------------------------------------------------------------------------------------------*/

/*#include "memhi.s"*/
