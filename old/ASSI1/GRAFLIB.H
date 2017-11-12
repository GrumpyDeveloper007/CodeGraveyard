
void VGA400Mode (void);

void ResetVGAMode(void);

void setViewPageAddr(unsigned long addr);

void waitVS(void) ;

void WritePix(int x, int y, int col);

void ClearPage400 (long PageAddr, long col);

void CopyPage400 (long DestPage, char* SrcPage);
