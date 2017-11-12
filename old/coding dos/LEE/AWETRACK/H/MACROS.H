// List of macros used in 3d engine

void PutPixel(int x,int y,unsigned char Col);
#pragma aux PutPixel="mov edi,eax"           \
                     "shl edi,8"             \
                     "shl eax,6"             \  
                     "add edi,eax"           \   
                     "add edi,VirtualScreen" \
                     "add edi,ebx"           \
                     "mov [edi],cl"          \
                     parm [ebx] [eax] [cl]   \
                     modify [edi];

