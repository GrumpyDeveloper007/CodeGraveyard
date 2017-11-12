// Fixedpoint multiply and divide functions
// Watcom C/C++ 10.0 callable

typedef long Fixed;          // 16.16 range +/- 32768 int +/-32768 floaty

#define Int2Fixed(x) ((x) << 16)
#define Fixed2Int(x) ((x) >> 16)
#define Float2Fixed(x) ((Fixed)((x) * 65536.0))
#define Fixed2Float(x) ((float)((x) / 65536.0))

Fixed FixedMul(Fixed num1, Fixed num2);
#pragma aux FixedMul =   \
		"imul edx"              \
		"add eax, 8000h"        \
		"adc edx, 0"            \
		"shrd eax, edx, 16"     \
		parm caller [eax] [edx] \
		value [eax]             \
		modify [eax edx];

Fixed FixedDiv(Fixed numer, Fixed denom);  // No rounding!
#pragma aux FixedDiv =   \
		"xor eax, eax"          \
		"shrd eax, edx, 16"     \
		"sar edx, 16"           \
		"idiv ebx"              \
		parm caller [edx] [ebx] \
		value [eax]             \
		modify [eax ebx edx];


