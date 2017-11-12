long getvect2(long);
#pragma aux getvect2 =   \
        "push    ebx            "\
        "push    ecx            "\
        "mov     ebx,eax        "\
        "mov     eax,ebx        "\
        "and     eax,0x0000FF   "\
        "xor     cl,cl          "\
        "or      ah,35          "\
        "push    es             "\
        "int     21             "\
        "mov     dx,es          "\
        "pop     es             "\
        "mov     eax,ebx        "\
        "pop     ecx            "\
        "pop     ebx            "\
                parm caller [eax]\
                value [edx eax]  \
                modify [eax edx];



