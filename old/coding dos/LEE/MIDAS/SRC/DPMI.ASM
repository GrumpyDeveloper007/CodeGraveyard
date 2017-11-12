;*      DPMI.ASM
;*
;* DPMI functions for protected mode MIDAS
;*
;* $Id: dpmi.asm,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*

P386
IDEAL
JUMPS


INCLUDE "lang.inc"
INCLUDE "errors.inc"
INCLUDE "dpmi.inc"



CODESEG



;/***************************************************************************\
;*
;* Function:    int dpmiAllocDescriptor(unsigned *descriptor);
;*
;* Description: Allocate LDT descriptor. Use dpmiFreeDescriptor to deallocate.
;*
;* Input:       unsigned *descriptor    pointer to descriptor number
;*
;* Returns:     MIDAS error code. Descriptor number is written to *descriptor.
;*
;\***************************************************************************/

PROC    dpmiAllocDescriptor     _funct  descriptor : _ptr
USES    _bx

        xor     _ax,_ax                 ; DPMI function 0 - alloc LDT descr.
        mov     _cx,1                   ; allocate one descriptor
        int     31h
        jc      @@err

IFDEF __32__
        and     eax,0FFFFh
ENDIF

        LOADPTR es,_bx,[descriptor]     ; write allocated descriptor to
        mov     [_esbx],_ax             ; *descriptor

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiAllocDescriptor

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiFreeDescriptor(unsigned descriptor);
;*
;* Description: Deallocates an LDT descriptor.
;*
;* Input:       unsigned descriptor     descriptor to deallocate
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    dpmiFreeDescriptor      _funct  descriptor : _int
USES    _bx

        mov     _ax,0001h               ; DPMI function 1 - free LDT descr.
        mov     _bx,[descriptor]
        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errInvalidDescriptor
        ERROR   ID_dpmiFreeDescriptor

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiSetSegmentBase(unsigned selector, ulong baseAddr);
;*
;* Description: Changes the 32-bit linear base address of a selector.
;*
;* Input:       unsigned selector       selector number
;*              ulong baseAddr          32-bit linear base address for
;*                                      selector
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    dpmiSetSegmentBase      _funct  selector : _int, baseAddr : _long
USES    _bx

        mov     _ax,0007h               ; DPMI function 7 - set segment base
        mov     _bx,[selector]
IFDEF __32__
        xor     ecx,ecx
        xor     edx,edx
ENDIF
        mov     cx,[word baseAddr+2]    ; cx:dx = new base address
        mov     dx,[word baseAddr]
        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errInvalidDescriptor
        ERROR   ID_dpmiSetSegmentBase

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiGetSegmentBase(unsigned selector, ulong *baseAddr);
;*
;* Description: Reads the 32-bit linear base address of a selector.
;*
;* Input:       unsigned selector       selector number
;*              ulong *baseAddr         pointer to the 32-bit linear base
;*                                      address of the selector
;*
;* Returns:     MIDAS error code. Selector base address is written to
;*              *baseAddr.
;*
;\***************************************************************************/

PROC    dpmiGetSegmentBase      _funct  selector : _int, baseAddr : _ptr
USES    _bx

        mov     _ax,0006h               ; DPMI function 7 - get segment base
        mov     _bx,[selector]
        int     31h
        jc      @@err

        LOADPTR es,_bx,[baseAddr]
        mov     [word _esbx],dx         ; write segment base address to
        mov     [word _esbx+2],cx       ; *baseAddr

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errInvalidDescriptor
        ERROR   ID_dpmiGetSegmentBase

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiSetSegmentLimit(unsigned selector, ulong limit);
;*
;* Description: Changes the limit of a segment selector.
;*
;* Input:       unsigned selector       selector number
;*              ulong limit             32-bit segment limit
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    dpmiSetSegmentLimit     _funct  selector : _int, limit : _long
USES    _bx

        mov     _ax,0008h               ; DPMI function 8 - set segment limit
        mov     _bx,[selector]
IFDEF __32__
        xor     ecx,ecx
        xor     edx,edx
ENDIF
        mov     cx,[word limit+2]       ; cx:dx = new segment limit
        mov     dx,[word limit]
        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiSetSegmentLimit

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiSetSegmentAccessRights(unsigned selector,
;*                  unsigned accessRights);
;*
;* Description: Changes the access rights of a selector
;*
;* Input:       unsigned selector       selector
;*              unsigned accessRights   new access rights for the segment
;*
;* Returns:     MIDAS error code.
;*
;\***************************************************************************/

PROC    dpmiSetSegmentAccessRights      _funct  selector : _int, \
                                                accessRights : _int
USES    _bx

        mov     _ax,0009h               ; DPMI function 9 - set access rights
        mov     _bx,[selector]
        mov     _cx,[accessRights]
        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiSetSegmentAccessRights

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiCreateCodeAlias(unsigned codeSelector,
;*                  unsigned *selector);
;*
;* Description: Creates a data descriptor that has the same base and limit
;*              as a code segment descriptor. Use dpmiFreeDescriptor() to
;*              deallocate data descriptor.
;*
;* Input:       unsigned codeSelector   code segment selector
;*              unsigned *selector      pointer to data segment selector
;*
;* Returns:     MIDAS error code. New data selector is written to *selector.
;*
;\***************************************************************************/

PROC    dpmiCreateCodeAlias     _funct  codeSelector : _int, selector : _ptr
USES    _bx

        mov     _ax,000Ah               ; 000Ah - create code alias descr.
        mov     _bx,[codeSelector]
        int     31h
        jc      @@err

IFDEF __32__
        and     eax,0FFFFh
ENDIF

        LOADPTR es,_bx,[selector]       ; write selector to *selector
        mov     [_esbx],_ax

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiCreateCodeAlias

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiAllocDOSMem(unsigned numParagraphs, unsigned *segment,
;*                  unsigned *selector);
;*
;* Description: Allocates memory from DOS free memory pool, below 1MB. Use
;*              dpmiFreeDOSMem() to deallocate.
;*
;* Input:       unsigned numParagraphs  number of paragraphs to allocate
;*              unsigned *segment       pointer to real mode segment
;*              unsigned *selector      pointer to selector
;*
;* Returns:     MIDAS error code. Real mode segment of allocated block is
;*              written to *segment. Protected mode selector for block is
;*              written to *selector.
;*
;\***************************************************************************/

PROC    dpmiAllocDOSMem         _funct  numParagraphs : _int, \
                                        realSeg : _ptr, selector : _ptr
USES    _bx

        mov     _ax,0100h               ; 0100h - alloc DOS memory block
        mov     _bx,[numParagraphs]
        int     31h
        jnc     @@ok

        cmp     _ax,07h                 ; memory control blocks damaged?
        je      @@mcbDamaged
        cmp     _ax,08h                 ; insufficient memory?
        je      @@nomemory

        mov     _ax,errDPMIFailure
        jmp     @@err

@@mcbDamaged:
        mov     _ax,errHeapCorrupted
        jmp     @@err

@@nomemory:
        mov     _ax,errOutOfMemory
        jmp     @@err

@@ok:
IFDEF __32__
        and     eax,0FFFFh
        and     edx,0FFFFh
ENDIF
        LOADPTR es,_bx,[realSeg]
        mov     [_esbx],_ax             ; write real mode segment to *segment
        LOADPTR es,_bx,[selector]
        mov     [_esbx],_dx             ; write selector to *selector

        xor     _ax,_ax
        jmp     @@done

@@err:
        ERROR   ID_dpmiAllocDOSMem

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    dpmiFreeDOSMem(unsigned selector);
;*
;* Description: Deallocates memory allocated with dpmiAllocDOSMem().
;*
;* Input:       unsigned selector       selector for allocated block
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    dpmiFreeDOSMem          _funct  selector : _int
USES    _bx

        mov     _ax,0101h               ; 0101h - free DOS memory block
        mov     _dx,[selector]
        int     31h
        jc      @@error

        xor     _ax,_ax
        jmp     @@done

@@error:
        cmp     _ax,07h                 ; memory control blocks damaged?
        je      @@mcbDamaged
        cmp     _ax,09h                 ; incorrect segment?
        je      @@badSegment

        mov     _ax,errDPMIFailure
        jmp     @@err

@@mcbDamaged:
        mov     _ax,errHeapCorrupted
        jmp     @@err

@@badSegment:
        mov     _ax,errInvalidDescriptor

@@err:
        ERROR   ID_dpmiFreeDOSMem

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiRealModeInt(unsigned intNum,
;*                  dpmiRealCallRegs *registers);
;*
;* Description: Simulates a real mode interrupt using DPMI service 0x0300.
;*              *register MUST contain appropriate register values for
;*              interrupt (CS:IP is ignored).
;*
;* Input:       unsigned intNum                 interrupt number
;*              dpmiRealCallRegs *registers     DPMI real mode calling struct
;*
;* Returns:     MIDAS error code. Register values returned by the interrupt
;*              are written to *registers.
;*
;\***************************************************************************/

PROC    dpmiRealModeInt         _funct  intNum : _int, registers : _ptr
USES    _di,es,_bx

IFDEF __32__
        mov     ax,ds
        mov     es,ax
        xor     ebx,ebx
        xor     ecx,ecx
ELSE
        xor     cx,cx
ENDIF

        mov     _ax,0300h               ; 0300h - simulate real mode interrupt
        mov     bl,[byte intNum]
        mov     bh,1                    ; reset PIC and A20 line
        LOADPTR es,_di,[registers]
        int     31h
        jc      @@err

        ; es:_di now contains pointer to modified real mode call structure.
        ; The DPMI specs do not clearly state that this is necessarily the
        ; same as the original structure, so for safety we check the pointers
        ; and if they differ copy the data to the original structure:

IFDEF __32__
        mov     ax,es
        mov     dx,ds
        cmp     ax,dx
        jne     @@copyregs
        cmp     edi,[registers]
        jne     @@copyregs
ELSE
        mov     ax,es
        cmp     ax,[word registers+2]
        jne     @@copyregs
        cmp     di,[word registers]
        jne     @@copyregs
ENDIF

        ; es:di points to the original structure - the new register values
        ; are at their place.

        xor     _ax,_ax
        jmp     @@done

@@copyregs:
        ; es:_di has changed - copy the new register structure to the old
        ; place:
        push    ds _si

        mov     _si,_di

IFDEF __32__
        mov     ax,es
        mov     dx,ds
        mov     ds,ax
        mov     es,dx
ELSE
        mov     ax,es                   ; ds:_si = es:_di
        mov     ds,ax
ENDIF
        LOADPTR es,_di,[registers]
        mov     _cx,SIZE dpmiRealCallRegs
        cld
        rep     movsb

        pop     _si ds

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiRealModeInt

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiLockMemory(ulong start, ulong numBytes);
;*
;* Description: Locks a region of memory to prevent it from being paged. The
;*              memory can be unlocked using dpmiUnlockMemory().
;*
;* Input:       ulong start             memory region start address
;*              ulong numBytes          memory region length in bytes
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    dpmiLockMemory          _funct  start : _long, numBytes : _long
USES    _si,_di, _bx

        mov     _ax,0600h               ; 0600h - Lock Linear Region

IFDEF __32__
        xor     ebx,ebx
        xor     ecx,ecx
        xor     esi,esi
        xor     edi,edi
ENDIF

        mov     bx,[word start+2]       ; bx:cx = start address
        mov     cx,[word start]
        mov     si,[word numBytes+2]    ; si:di = number of bytes
        mov     di,[word numBytes]

        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiLockMemory

@@done:
        ret
ENDP




;/***************************************************************************\
;*
;* Function:    int dpmiUnlockMemory(ulong start, ulong numBytes);
;*
;* Description: Unlocks a region of memory locked with dpmiLockMemory().
;*
;* Input:       ulong start             memory region start address
;*              ulong numBytes          memory region length in bytes
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

PROC    dpmiUnlockMemory        _funct  start : _long, numBytes : _long
USES    _si,_di,_bx

        mov     _ax,0600h               ; 0601h - Unlock Linear Region

IFDEF __32__
        xor     ebx,ebx
        xor     ecx,ecx
        xor     esi,esi
        xor     edi,edi
ENDIF

        mov     bx,[word start+2]       ; bx:cx = start address
        mov     cx,[word start]
        mov     si,[word numBytes+2]    ; si:di = number of bytes
        mov     di,[word numBytes]

        int     31h
        jc      @@err

        xor     _ax,_ax
        jmp     @@done

@@err:
        mov     _ax,errDPMIFailure
        ERROR   ID_dpmiUnlockMemory

@@done:
        ret
ENDP



;* $Log: dpmi.asm,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/08/04 11:14:32  pekangas
;* All functions now preserve _bx
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*


END