.thumb
@.org	0x080243A4
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
	ldr	r0, [r2, #0xC]
	ldr	r0, =0x080243AC
	mov	pc, r0

flase:
	ldr	r0, =0x0802440C
	mov	pc, r0

.align
.ltorg
addr:
