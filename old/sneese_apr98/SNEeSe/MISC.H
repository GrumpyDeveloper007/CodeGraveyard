.macro	DUPLICATE vartype, amount, data, from=1
.\vartype \data
.if \amount-\from
DUPLICATE \vartype,\amount,\data,"(\from+1)"
.endif
.endm

