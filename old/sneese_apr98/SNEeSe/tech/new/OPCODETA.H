#ifndef __OPCODETABLE_
#define __OPCODETABLE_

static char opcode[256][6]={
"NOP",  "TCALL","SET1","BBS","OR",  "OR",  "OR",  "OR",  "OR",  "OR",  "OR1",  "ASL", "ASL","PUSH","TSET1","BRK",
"BPL",  "TCALL","CLR1","BBC","OR",  "OR",  "OR",  "OR",  "OR",  "OR",  "DECW", "ASL", "ASL","DEC", "CMP",  "JMP",
"CLRP", "TCALL","SET1","BBS","AND", "AND", "AND", "AND", "AND", "AND", "OR1",  "ROL", "ROL","PUSH","CBNE", "BRA",
"BMI",  "TCALL","CLR1","BBC","AND", "AND", "AND", "AND", "AND", "AND", "INCW", "ROL", "ROL","INC", "CMP",  "CALL",
"SETP", "TCALL","SET1","BBS","EOR", "EOR", "EOR", "EOR", "EOR", "EOR", "AND1", "LSR", "LSR","PUSH","TCLR1","PCALL",
"BVC",  "TCALL","CLR1","BBC","EOR", "EOR", "EOR", "EOR", "EOR", "EOR", "CMPW", "LSR", "LSR","MOV", "CMP",  "JMP",
"CLRC", "TCALL","SET1","BBS","CMP", "CMP", "CMP", "CMP", "CMP", "CMP", "AND1", "ROR", "ROR","PUSH","DBNZ", "RET",
"BVS",  "TCALL","CLR1","BBC","CMP", "CMP", "CMP", "CMP", "CMP", "CMP", "ADDW", "ROR", "ROR","MOV", "CMP",  "RETI",
"SETC", "TCALL","SET1","BBS","ADC", "ADC", "ADC", "ADC", "ADC", "ADC", "EOR1", "DEC", "DEC","MOV", "POP",  "MOV",
"BCC",  "TCALL","CLR1","BBC","ADC", "ADC", "ADC", "ADC", "ADC", "ADC", "SUBW", "DEC", "DEC","MOV", "DIV",  "XCN",
"EI",   "TCALL","SET1","BBS","SBC", "SBC", "SBC", "SBC", "SBC", "SBC", "MOV1", "INC", "INC","CMP", "POP",  "MOV",
"BCS",  "TCALL","CLR1","BBC","SBC", "SBC", "SBC", "SBC", "SBC", "SBC", "MOVW", "INC", "INC","MOV", "DAS",  "MOV",
"DI",   "TCALL","SET1","BBS","MOV", "MOV", "MOV", "MOV", "CMP", "MOV", "MOV1", "MOV", "MOV","MOV", "POP",  "MUL",
"BNE",  "TCALL","CLR1","BBC","MOV", "MOV", "MOV", "MOV", "MOV", "MOV", "MOVW", "MOV", "DEC","MOV","CBNE",  "DAA",
"CLRV", "TCALL","SET1","BBS","MOV", "MOV", "MOV", "MOV", "MOV", "MOV", "NOT1", "MOV", "MOV","NOTC","POP", "SLEEP",
"BEQ",  "TCALL","CLR1","BBC","MOV", "MOV", "MOV", "MOV", "MOV", "MOV", "MOV",  "MOV", "INC","MOV","DBNZ", "STOP" };

#endif
