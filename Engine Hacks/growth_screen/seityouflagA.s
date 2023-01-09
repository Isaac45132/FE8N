.thumb

@org	0x0808AB24
mov	r1, #0x80
lsl	r1, r1, #1
tst	r0, r1
beq	nonR
ldr	r0, =0x08002E74
mov	lr, r0
mov	r0, r5
mov	r1, #0
.short	0xF800
ldr	r0, =0x02003BFC
ldr	r1, =0x0808AB2D
bx	r1

nonR:
ldr	r1, =0x02003BFC
ldrb	r0, [r1, #0]
cmp	r0, #0
bne	nonSL
ldr	r2, [r1, #0xC]
ldrb	r2, [r2, #0xB]
mov	r3, #0xC0
tst	r2, r3
bne	nonSL

sub	r1, #2
mov	r3, #1
strb	r3, [r1, #0]
ldrb	r2, [r1, #1]
mov	r3, #1
eor	r2, r3
strb	r2, [r1, #1]
ldr	r1, =0x08089B58
mov	lr, r1
.short	0xF800

nonSL:
.short	0xB001
pop	{r4, r5, r6, r7}
pop	{r0}
bx	r0

.ltorg
.align
adr: