/*

 Sprite Render Functions - In Assembler cos everything else is!

 This code is mostly guess work, and it should not be done like this, I have written this
file :

 A - To make sure I have the idea of how sprites are handled on snes.
 B - To show dale how the sprites are done, so he can deal with 'em!

 Dale the sprite decoding thing, is a nightmare! If you cant follow the code I understand, tell
me what you need to know and I`ll try and explain it!

*/

.balign 16
S_TILE_16x16_4:
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-32,%esi
	addl $(256+128)*8-8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	ret

.balign 16
S_TILE_16x16_4_X:
	addl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-32,%esi
	addl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	ret

.balign 16
S_TILE_16x16_4_Y:
	addl $(256+128)*8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-32,%esi
	subl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	ret

.balign 16
S_TILE_16x16_4_XY:
	addl $(256+128)*8+8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-32,%esi
	subl $(256+128)*8-8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	ret

.balign 16
S_TILE_32x32_4:
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-96,%esi
	addl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-96,%esi
	addl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-96,%esi
	addl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	ret

.balign 16
S_TILE_32x32_4_X:
	addl $24,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-96,%esi
	addl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-96,%esi
	addl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-96,%esi
	addl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	ret

.balign 16
S_TILE_32x32_4_Y:
	addl $(256+128)*8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-96,%esi
	subl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-96,%esi
	subl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-96,%esi
	subl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	ret

.balign 16
S_TILE_32x32_4_XY:
	addl $(256+128)*8+24,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-96,%esi
	subl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-96,%esi
	subl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-96,%esi
	subl $(256+128)*8-24,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	ret

.balign 16
S_TILE_64x64_4:
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $16*32-224,%esi
	addl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile
	ret

.balign 16
S_TILE_64x64_4_X:
	addl $56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $16*32-224,%esi
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_X
	ret

.balign 16
S_TILE_64x64_4_Y:
	addl $(256+128)*8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $16*32-224,%esi
	subl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	addl $32,%esi
	addl $8,%edi
	call PLOT8x8_4BplTile_Y
	ret

.balign 16
S_TILE_64x64_4_XY:
	addl $(256+128)*8+56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $16*32-224,%esi
	subl $(256+128)*8-56,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	addl $32,%esi
	subl $8,%edi
	call PLOT8x8_4BplTile_XY
	ret

SPRITE_NOT_SUPPORTED:		/* This covers special cases or not implemented features! */
	ret

.macro	AddressSetup
	andl	$0x0000CE00,%eax	/* Get Plotver as     YX00 NNN0 0000 0000 */
	pushl	%eax
	shrl	$5,%eax
	orw	$0x8080,%ax
	movb	%al,%ah
	andl	$0xf0f0,%eax
	orw	%ax,ColourBase1
	orw	%ax,ColourBase4
	popl	%eax
	shrl	$14,%eax
.endm

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_8x8_16x16:
	pusha

	movb $8,%cl		/* X MSB bit num for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f

/* 8x8 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup
	
	call	Sprite_Tile_Plot_8x8_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:

/* 16x16 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_16x16_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_8x8_32x32:
	pusha
	movb $8,%cl		/* X MSB bit num for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f

/* 8x8 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup
	
	call	Sprite_Tile_Plot_8x8_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:

/* 32x32 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_32x32_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

/* NB : %cl contains sprite plane req., %ebx contains address of BKG Required */
/* %cl = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_8x8_64x64:
	pusha
	movb $8,%cl		/* X MSB bit num for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f

/* 8x8 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup
	
	call	Sprite_Tile_Plot_8x8_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:

/* 64x64 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_64x64_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_16x16_32x32:
	pusha
	movb $8,%cl		/* X MSB bit num for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f
/* 16x16 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_16x16_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f			/* If not zero (no need to restore etc.) */
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:
/* 32x32 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_32x32_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_16x16_64x64:
	pusha
	movb $8,%cl		/* X bit shift for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f
/* 16x16 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_16x16_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:
/* 64x64 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_64x64_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

/* NB : %ch contains sprite plane req., %ebx contains address of BKG Required */
/* %ch = 0x00 or 0x10 or 0x20 or 0x30 ! */

RENDER_SPRITE_32x32_64x64:
	pusha
	movb $8,%cl		/* X MSB bit num for determining if sprite enabled? */
	movl _OAMAddress,%esi	/* Address containing 4 byte sprite map */
	movl _OAMAddress,%edi	/* Yup using edi as source... need more registers INTEL!!! */
	addl $0x200,%edi 	/* Get 32 byte table after main sprite data */
	movb $128,%dl		/* number of sprites (I think we must loop over all sprites!) */
0:
	movb (%edi),%al
	rolb %cl,%al		/* Is this sprite enabled ? (ie on screen x msb not set!) */
	jc 9f
	dec %cl
	rorb $2,%al		/* What size is this sprite ? 0=first, 1=second */
	jc 1f

/* 32x32 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_32x32_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret	

1:
/* 64x64 */

	pushl %esi
	pushl %edi

	movl $0,%eax
	movb 1(%esi),%al	/* Get verticle position of sprite */
	movl %eax,%edi
	shll $8,%edi			/* Multiply by 256 */
	shll $7,%eax			/* Multiply by 128 */
	addl %eax,%edi
	movb (%esi),%al		/* Get horizontal position of sprite */
	andl $0x000000FF,%eax
	addl %ebx,%edi		/* Setup address of plane to write to */
	addl %eax,%edi		/* Plus horiz/vert offset */

	movb 2(%esi),%al	/* tile number lobyte */
	movb 3(%esi),%ah	/* get attribute info plus tile number msb! */
	movb %ah,%dh		/* Get copy of attribute information */

	andl $0x000001FF,%eax	/* Get tile number */
	shll $5,%eax		/* tile*32 */
	movl %eax,%esi
	movl OBADDR,%eax
	addl %eax,%esi		/* Tile address now setup! At last ;) */

	/* tile address in esi, plane screen in edi */

	movb %dh,%ah		/* Recopy attribute information */
	andb $0x30,%dh
	cmpb %ch,%dh		/* Check sprite priority, if not same dont plot! */
	jne 5f

	AddressSetup

	call	Sprite_Tile_Plot_64x64_4(,%eax,4)	/* got address of tile routine */
	movl	$0x08040201,ColourBase1

5:
	popl %edi
	popl %esi

	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret

9:	decb %cl
	decb %cl
	jnz 8f
	movb $8,%cl
	incl %edi		/* goto next sprite byte */
8:	addl $4,%esi		/* Next sprite */
	decb %dl
	jnz 0b			/* Loop for all sprites */
	popa
	ret


.macro ALL_SPRITES_PLANE_1	/* Plot all sprites to plane 1 of 4 (only plane 1 spr at present)*/
	movb $0x00,%ch		/* plane 1 sprites first */
	movl _BKG,%ebx
	addl $64+(256+2*64)*64,%ebx	/* Screen Address set to visible area */
	movb OBSEL,%al
	shrb $5,%al
	andl $0x00000007,%eax
	call Sprite_Mode(,%eax,4)	/* got address of sprite routines */
.endm

.macro ALL_SPRITES_PLANE_2	/* Plot all sprites to plane 2 of 4 (only plane 2 spr at present)*/
	movb $0x10,%ch		/* plane 2 sprites */
	movl _BKG,%ebx
	addl $64+(256+2*64)*64,%ebx	/* Screen Address set to visible area */
	movb OBSEL,%al
	shrb $5,%al
	andl $0x00000007,%eax
	call Sprite_Mode(,%eax,4)	/* got address of sprite routines */
.endm

.macro ALL_SPRITES_PLANE_3	/* Plot all sprites to plane 3 of 4  (only plane 3 spr at present)*/
	movb $0x20,%ch		/* plane 3 sprites */
	movl _BKG,%ebx
	addl $64+(256+2*64)*64,%ebx	/* Screen Address set to visible area */
	movb OBSEL,%al
	shrb $5,%al
	andl $0x00000007,%eax
	call Sprite_Mode(,%eax,4)	/* got address of sprite routines */
.endm

.macro ALL_SPRITES_PLANE_4	/* Plot all sprites to plane 4 of 4  (only plane 4 spr at present)*/
	movb $0x30,%ch		/* plane 4 sprites */
	movl _BKG,%ebx
	addl $64+(256+2*64)*64,%ebx	/* Screen Address set to visible area */
	movb OBSEL,%al
	shrb $5,%al
	andl $0x00000007,%eax
	call Sprite_Mode(,%eax,4)	/* got address of sprite routines */
.endm

Sprite_Mode:
	.long	RENDER_SPRITE_8x8_16x16		/* 8x8 or 16x16 */
	.long	RENDER_SPRITE_8x8_32x32		/* 8x8 or 32x32 */
	.long	RENDER_SPRITE_8x8_64x64		/* 8x8 or 64x64 */
	.long	RENDER_SPRITE_16x16_32x32	/* 16x16 or 32x32 */
	.long	RENDER_SPRITE_16x16_64x64	/* 16x16 or 64x64 */
	.long	RENDER_SPRITE_32x32_64x64	/* 32x32 or 64x64 */
	.long	SPRITE_NOT_SUPPORTED		/* NOT SUPPORTED BY SUPER NINTENDO! */
	.long	SPRITE_NOT_SUPPORTED		/* NOT SUPPORTED BY SUPER NINTENDO! */

Sprite_Tile_Plot_8x8_4:			/* only 4 plane tiles exist on snes? */
	.long	PLOT8x8_4BplTile
	.long	PLOT8x8_4BplTile_X
	.long	PLOT8x8_4BplTile_Y
	.long	PLOT8x8_4BplTile_XY

Sprite_Tile_Plot_16x16_4:			/* only 4 plane tiles exist on snes? */
	.long	S_TILE_16x16_4
	.long	S_TILE_16x16_4_X
	.long	S_TILE_16x16_4_Y
	.long	S_TILE_16x16_4_XY

Sprite_Tile_Plot_32x32_4:			/* only 4 plane tiles exist on snes? */
	.long	S_TILE_32x32_4
	.long	S_TILE_32x32_4_X
	.long	S_TILE_32x32_4_Y
	.long	S_TILE_32x32_4_XY

Sprite_Tile_Plot_64x64_4:			/* only 4 plane tiles exist on snes? */
	.long	S_TILE_64x64_4
	.long	S_TILE_64x64_4_X
	.long	S_TILE_64x64_4_Y
	.long	S_TILE_64x64_4_XY


