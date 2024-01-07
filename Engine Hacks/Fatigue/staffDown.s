.thumb
	push	{r3}
	bl	staffLvBorns
	pop	{r3}
	add	r4, r0
	cmp	r4, #0x50
	ble	nonMAX
	bl	staffFatigue
	ldr	r1, =0x08016DC5
	bx	r1
nonMAX:
	bl	staffFatigue
	ldr	r1, =0x08016DC7
	bx	r1

staffFatigue:
	push	{r0, r2, lr}
	mov	r1, #0x47
	ldrb	r1, [r3, r1]	@疲労
	cmp	r1, #0
	beq	nonHirou
	cmp	r1, #1
	beq	one
	cmp	r1, #2
	beq	two
three:
	ldr	r1, adr+8
	b	zero
two:
	ldr	r1, adr+4
	b	zero
one:
	ldr	r1, adr
zero:
	sub	r4, r1
	cmp	r4, #0
	bgt	nonHirou
	mov	r4, #1
nonHirou:
	pop	{r0, r2, pc}


staffLvBorns:
	ldr	r1, =0x08018ECC
	mov	pc, r1

.align
.ltorg
adr:
