struct CART_HEADER {
	short PAGE_COUNTS;
	char  EMULATION_MODE;
	char  filler[5];
	char  FILEID_A;
	char  FILEID_B;
	char  GAME_SYS;
	char  other[501];
};


int LOAD_CART();
void RUN_CART();
void LOWROM_CART();
