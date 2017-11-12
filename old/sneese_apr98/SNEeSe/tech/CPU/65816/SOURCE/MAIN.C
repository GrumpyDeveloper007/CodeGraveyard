#include <externs.h>
#include <headr.h>

#include "f:\emulator\includes\memory.h"
#include <utils.h>
#include <adrsmode.h>
#include <setup.h>


#include <cart.h>

unsigned char it;
int count;

void main()
{	INIT_CPU();
	LOAD_CART();
 	RUN_CART();
 
}

