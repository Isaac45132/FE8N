.thumb
@.org	0x08023A34
	mov	r6, #0
	ldrh	r4, [r2, #0x1E]		@アイテム1
	cmp	r4, #0
	beq	flase

	ldr	r0, addr+4
	mov	lr, r0
	.short	0xF800
	cmp	r0, #0
	beq	end

	mov	r0, #0x43
	ldrb	r0, [r2, r0]
	ldr	r1, addr
	cmp	r0, r1
	bge	flase

end:
	ldr	r1, =0x08023A3C
	mov	pc, r1

flase:
	ldr	r1, =0x08023A82
	mov	pc, r1

.align
.ltorg
addr:
