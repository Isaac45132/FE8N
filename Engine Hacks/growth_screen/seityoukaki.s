.thumb

@org	0x080896D8

ldr	r3, =0x08089268
mov	lr, r3
.short	0xF800

push	{r0, r1, r2}
ldr	r0, =0x02003BFC
sub	r0, #0x2
ldrb	r0, [r0, #0]
cmp	r0, #0
beq	non
ldr	r0, =0x0300000C
ldrb	r1, [r0, #0]
mov	r2, #5
orr	r1, r2
strb	r1, [r0, #0]
ldr	r0, =0x080DC0F4
mov	lr, r0
ldr	r0, =0x02003D2C
ldr	r1, =0x02022D40
mov	r2, #0x12
mov	r3, #0x12
.short	0xF800
ldr	r0, =0x080DC0F4
mov	lr, r0
ldr	r0, =0x0200472C
ldr	r1, =0x02023D40
mov	r2, #0x12
mov	r3, #0x12
.short	0xF800
ldr	r0, =0x02003BFC
sub	r0, #0x2
mov	r1, #0
strb	r1, [r0, #0]

non:
pop	{r0, r1, r2}
.short	0xB014
pop	{r4, r5, r6, r7}
ldr	r3, =0x080896E1
bx	r3

.ltorg
.align
adr: