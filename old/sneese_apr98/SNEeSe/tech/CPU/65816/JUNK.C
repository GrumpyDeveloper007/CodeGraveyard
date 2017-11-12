void (*instruction[256])();

void wow()
{ printf("OK HERE I AM /n");}

void main()
{  instruction[0]=wow;
   instruction[0]();
 }
 