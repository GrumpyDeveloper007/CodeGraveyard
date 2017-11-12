/* GET_BYTE & GET_WORD now assume esi contains the read address and
  eax the place to store value also corrupts edi*/

.macro	GET_BYTE 			/* Map HW address before getting byte */
	movl %esi,%edi
	shrl $12,%edi			/* Get Bank Part into low word for offsetting*/
	call Read_BankMapping(,%edi,4)
.endm

.macro	GET_WORD			/* Map HW address before getting word */
	GET_BYTE
    movb %al,%ah
	incl %esi
	GET_BYTE
    xchgb %al,%ah
.endm

/* SET_BYTE & SET_WORD now assume esi contains the write address and 
  eax the value to write also corrupts edi */

.macro	SET_BYTE			/* Map HW address before setting byte */
	movl %esi,%edi
	shrl $12,%edi
	call Write_BankMapping(,%edi,4)
.endm

.macro	SET_WORD			/* Map HW address before setting word */
	SET_BYTE
    xchgb %al,%ah
	incl %esi
	SET_BYTE
    xchgb %al,%ah           /* Pre-caution can optimise out later! */
.endm
