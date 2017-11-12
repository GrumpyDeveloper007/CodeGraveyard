;*      DPMI.INC
;*
;* DPMI functions for protected mode MIDAS
;*
;* $Id: dpmi.inc,v 1.3 1997/01/16 18:41:59 pekangas Exp $
;*
;* Copyright 1996,1997 Housemarque Inc.
;*
;* This file is part of the MIDAS Sound System, and may only be
;* used, modified and distributed under the terms of the MIDAS
;* Sound System license, LICENSE.TXT. By continuing to use,
;* modify or distribute this file you indicate that you have
;* read the license and understand and accept it fully.
;*


;/***************************************************************************\
;*       struct dpmiRealCallRegs
;*       -----------------------
;* Description:  Real mode calling register value structure
;\***************************************************************************/

STRUC   dpmiRealCallRegs
        rEDI            DD      ?
        rESI            DD      ?
        rEBP            DD      ?
        reserved        DD      ?
        rEBX            DD      ?
        rEDX            DD      ?
        rECX            DD      ?
        rEAX            DD      ?
        flags           DW      ?
        rES             DW      ?
        rDS             DW      ?
        rFS             DW      ?
        rGS             DW      ?
        rIP             DW      ?
        rCS             DW      ?
        rSP             DW      ?       ; if SS and SP are zero, DPMI will
        rSS             DW      ?       ; provide a small (30 words) stack
ENDS




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

GLOBAL  LANG dpmiAllocDescriptor : _funct




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

GLOBAL  LANG dpmiFreeDescriptor : _funct




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

GLOBAL  LANG dpmiSetSegmentBase : _funct




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

GLOBAL LANG dpmiGetSegmentBase : _funct




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

GLOBAL  LANG dpmiSetSegmentLimit : _funct




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

GLOBAL  LANG dpmiSetSegmentAccessRights : _funct




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

GLOBAL  LANG dpmiCreateCodeAlias : _funct




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

GLOBAL  LANG dpmiAllocDOSMem : _funct




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

GLOBAL  LANG dpmiFreeDOSMem : _funct




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

GLOBAL  LANG dpmiRealModeInt : _funct




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

GLOBAL  LANG dpmiLockMemory : _funct




;/***************************************************************************\
;*
;* Function:    int dpmiUnlockMemory(ulong start, ulong numBytes);
;*
;* Description: Unlocks a region of memory locked with dmpiLockMemory().
;*
;* Input:       ulong start             memory region start address
;*              ulong numBytes          memory region length in bytes
;*
;* Returns:     MIDAS error code
;*
;\***************************************************************************/

GLOBAL  LANG dpmiUnlockMemory : _funct





;/***************************************************************************\
;*      enum dpmiFunctIDs
;*      -----------------
;* Description: ID numbers for DPMI functions
;\***************************************************************************/

ENUM    dpmiFunctIDs \
        ID_dpmiAllocDescriptor = ID_dpmi, \
        ID_dpmiFreeDescriptor, \
        ID_dpmiSetSegmentBase, \
        ID_dpmiSetSegmentLimit, \
        ID_dpmiSetSegmentAccessRights, \
        ID_dpmiCreateCodeAlias, \
        ID_dpmiAllocDOSMem, \
        ID_dpmiFreeDOSMem, \
        ID_dpmiRealModeInt, \
        ID_dpmiGetSegmentBase, \
        ID_dpmiLockMemory, \
        ID_dpmiUnlockMemory


;* $Log: dpmi.inc,v $
;* Revision 1.3  1997/01/16 18:41:59  pekangas
;* Changed copyright messages to Housemarque
;*
;* Revision 1.2  1996/05/30 22:38:46  pekangas
;* no changes?
;*
;* Revision 1.1  1996/05/22 20:49:33  pekangas
;* Initial revision
;*