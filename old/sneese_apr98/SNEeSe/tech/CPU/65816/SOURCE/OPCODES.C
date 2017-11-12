#include <externs.h>
#include <headr.h>
#include <instr.h>

void set_instructions()
{
instruction[0x69]=instruction[0x6D]=instruction[0x6F]=instruction[0x65]=instruction[0x71]=instruction[0x77]=ADC;
instruction[0x61]=instruction[0x75]=instruction[0x7D]=instruction[0x7F]=instruction[0x79]=ADC;
instruction[0x72]=instruction[0x67]=instruction[0x63]=instruction[0x73]=ADC;

instruction[0x29]=instruction[0x2D]=instruction[0x2F]=instruction[0x25]=instruction[0x31]=instruction[0x37]=AND65816;
instruction[0x21]=instruction[0x35]=instruction[0x3D]=instruction[0x3F]=instruction[0x39]=instruction[0x32]=AND65816;
instruction[0x27]=instruction[0x23]=instruction[0x33]=AND65816;

instruction[0x0E]=instruction[0x06]=instruction[0x16]=instruction[0x1E]=ASL;
instruction[0x0A]=ASLC;

instruction[0x90]=BCC;
instruction[0xB0]=BCS;
instruction[0xF0]=BEQ;
instruction[0x89]=instruction[0x2C]=instruction[0x24]=instruction[0x34]=instruction[0x3C]=BIT;
instruction[0x30]=BMI;
instruction[0xD0]=BNE;
instruction[0x10]=BPL;
instruction[0x80]=BRA;
instruction[0x0]=BRK;
instruction[0x82]=BRL;
instruction[0x50]=BVC;
instruction[0x70]=BVS;
instruction[0x18]=CLC;
instruction[0xD8]=CLD;
instruction[0x58]=CLI;
instruction[0xB8]=CLV;
instruction[0xC9]=instruction[0xCD]=instruction[0xCF]=instruction[0xC5]=instruction[0xD1]=instruction[0xD7]=CMP;
instruction[0xC1]=instruction[0xD5]=instruction[0xDD]=instruction[0xDF]=instruction[0xD9]=instruction[0xD2]=CMP;
instruction[0xC7]=instruction[0xC3]=instruction[0xD3]=CMP;

/*instruction[0x02]=COP;*/
instruction[0xE0]=instruction[0xEC]=instruction[0xE4]=CPX;
instruction[0xC0]=instruction[0xCC]=instruction[0xC4]=CPY;
instruction[0xCE]=instruction[0xC6]=instruction[0xD6]=instruction[0xDE]=DEC;
instruction[0x3A]=DECC;

instruction[0xCA]=DEX;
instruction[0x88]=DEY;
instruction[0x49]=instruction[0x4D]=instruction[0x4F]=instruction[0x45]=instruction[0x51]=instruction[0x57]=EOR;
instruction[0x41]=instruction[0x55]=instruction[0x5D]=instruction[0x5F]=instruction[0x59]=EOR;
instruction[0x52]=instruction[0x47]=instruction[0x43]=instruction[0x53]=EOR;
instruction[0xEE]=instruction[0xE6]=instruction[0xF6]=instruction[0xFE]=INC;
instruction[0x1A]=INCC;

instruction[0xE8]=INX;
instruction[0xC8]=INY;
instruction[0xDC]=JML;
instruction[0x4C]=instruction[0x6C]=instruction[0x7C]=instruction[0x5C]=JMP;
instruction[0x22]=JSL;
instruction[0x20]=instruction[0xFC]=JSR;
instruction[0xA9]=instruction[0xAD]=instruction[0xAF]=instruction[0xA5]=instruction[0xB1]=instruction[0xB7]=LDA;
instruction[0xA1]=instruction[0xB5]=instruction[0xBD]=instruction[0xBF]=instruction[0xB9]=instruction[0xB2]=LDA;
instruction[0xA7]=instruction[0xA3]=instruction[0xB3]=LDA;

instruction[0xA2]=instruction[0xAE]=instruction[0xA6]=instruction[0xB6]=instruction[0xBE]=LDX;
instruction[0xA0]=instruction[0xAC]=instruction[0xA4]=instruction[0xB4]=instruction[0xBC]=LDY;
instruction[0x4E]=instruction[0x46]=instruction[0x56]=instruction[0x5E]=LSR;
instruction[0x4A]=LSRC;

instruction[0x54]=MVN;
instruction[0x44]=MVP;
instruction[0xEA]=NOP;
instruction[0x09]=instruction[0x0D]=instruction[0x0F]=instruction[0x05]=instruction[0x11]=instruction[0x17]=ORA;
instruction[0x01]=instruction[0x15]=instruction[0x1D]=instruction[0x1F]=instruction[0x19]=instruction[0x12]=ORA;
instruction[0x07]=instruction[0x03]=instruction[0x13]=ORA;
instruction[0xF4]=PEA;
instruction[0xD4]=PEI;
instruction[0x62]=PER;
instruction[0x48]=PHA;
instruction[0x8B]=PHB;
instruction[0x0B]=PHD;
instruction[0x4B]=PHK;
instruction[0x08]=PHP;
instruction[0xDA]=PHX;
instruction[0x5A]=PHY;
instruction[0x68]=PLA;
instruction[0xAB]=PLB;
instruction[0x2B]=PLD;
instruction[0x28]=PLP;
instruction[0xFA]=PLX;
instruction[0x7A]=PLY;
instruction[0xC2]=REP;
instruction[0x2E]=instruction[0x26]=instruction[0x36]=instruction[0x3E]=ROL;
instruction[0x2A]=ROLC;

instruction[0x6E]=instruction[0x66]=instruction[0x76]=instruction[0x7E]=ROR;
instruction[0x6A]=RORC;

instruction[0x40]=RTI;
instruction[0x6B]=RTL;
instruction[0x60]=RTS;
instruction[0xE9]=instruction[0xED]=instruction[0xEF]=instruction[0xE5]=instruction[0xF1]=instruction[0xF7]=SBC;
instruction[0xE1]=instruction[0xF5]=instruction[0xFD]=instruction[0xFF]=instruction[0xF9]=instruction[0xF2]=SBC;
instruction[0xE7]=instruction[0xE3]=instruction[0xF3]=SBC;
instruction[0x38]=SEC;
instruction[0xF8]=SED;
instruction[0x78]=SEI;
instruction[0xE2]=SEP;
instruction[0x8D]=instruction[0x8F]=instruction[0x85]=instruction[0x91]=instruction[0x97]=instruction[0x81]=STA;
instruction[0x95]=instruction[0x9D]=instruction[0x9F]=instruction[0x99]=instruction[0x92]=instruction[0x87]=STA;
instruction[0x83]=instruction[0x93]=STA;
instruction[0xD8]=STP;
instruction[0x8E]=instruction[0x86]=instruction[0x96]=STX;
instruction[0x8C]=instruction[0x84]=instruction[0x94]=STY;
instruction[0x9C]=instruction[0x64]=instruction[0x74]=instruction[0x9E]=STZ;
instruction[0xAA]=TAX;
instruction[0xA8]=TAY;
instruction[0x5B]=TCD;
instruction[0x1B]=TCS;
instruction[0x7B]=TDC;
instruction[0x1C]=instruction[0x14]=TRB;
instruction[0x0C]=instruction[0x04]=TSB;
instruction[0x3B]=TSC;
instruction[0xBA]=TSX;
instruction[0x8A]=TXA;
instruction[0x9A]=TXS;
instruction[0x9B]=TXY;
instruction[0xBB]=TYA;
instruction[0xCB]=WAI;
/*instruction[0x42]=WDM;*/
instruction[0xEB]=XBA;
instruction[0xFB]=XCE;

}