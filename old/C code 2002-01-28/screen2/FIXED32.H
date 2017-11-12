// Fixedpoint multiply and divide functions
// Watcom C/C++ 10.0 callable

typedef long Fixed;          // 16.16 range +/- 32768 int +/-32768 floaty

#define Int2Fixed(x) ((x) << 16)
#define Fixed2Int(x) ((x) >> 16)
#define Float2Fixed(x) ((Fixed)((x) * 65536.0))
#define Fixed2Float(x) ((float)((x) / 65536.0))

Fixed FixedMul(Fixed num1, Fixed num2)
{
 return (Float2Fixed(Fixed2Float(num1)*Fixed2Float(num2)))
}

Fixed FixedDiv(Fixed numer, Fixed denom)  // No rounding!
{
 return (Float2Fixed(Fixed2Float(num1)/Fixed2Float(num2)))
}


