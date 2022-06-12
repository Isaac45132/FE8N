.thumb
@.org	0x08023170
	and	r0, r1
	cmp	r0, #0
	beq	flase

	ldr	r0, addr+4
	mov	lr, r0
	.short	0xF800
	cmp	r0, #0
	beq	end

	ldr	r1, =0x03004DF0
	ldr	r1, [r1, #0]
	mov	r0, #0x43
	ldrb	r0, [r1, r0]
	ldr	r1, addr
	cmp	r0, r1
	bge	flase

end:
	ldr	r1, =0x0202BCAC
	ldr	r0, =0x08023178
	mov	pc, r0

flase:
	ldr	r0, =0x08023190
	mov	pc, r0

.align
.ltorg
addr:
