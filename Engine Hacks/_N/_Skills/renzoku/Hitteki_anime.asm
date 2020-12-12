.thumb

@org	0x0802B1C6
	mov	r0, r7
	mov	r1, #0x4C
	ldr	r2, adr
	mov	lr, r2
	.short 0xF800

	ldr	r4, =0x0802b1d8
	mov	pc, r4

.align
.ltorg
adr:

