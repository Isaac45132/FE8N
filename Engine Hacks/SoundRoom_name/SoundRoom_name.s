.thumb

@org	0x080B4CAC
push	{r4, lr}
mov	r10, r0
mov	r7, r1
bl	aaa
pop	{r0, r1}
ldr	r0, =0x080B4CB7
bx	r0
pop	{r4}
pop	{r0}
bx	r0
bx	r3
bx	r7

aaa:
push	{r3, r4, r5, r6, r7, lr}
ldr	r5, =0x02028E58
lsl	r0, r5, #0
ldr	r3, =0x08003C69
bl	bbb
mov	r0, #0
ldr	r3, =0x08003C25
bl	bbb
ldr	r4, =0x0201F160
mov	r1, #0x10
lsl	r0, r4, #0
ldr	r3, =0x08003C8D
ldrh	r6, [r5, #0x12]
bl	bbb
lsl	r0, r4, #0
ldr	r3, =0x08003CF9
bl	bbb
bl	ddd
ldr	r3, =0x08009FA9
bl	bbb
mov	r2, #0
lsl	r3, r0, #0
lsl	r1, r2, #0
lsl	r0, r4, #0
ldr	r7, =0x080043B9
bl	ccc
lsl	r0, r4, #0
ldr	r1, =0x02022E40
ldr	r3, =0x08003DA1
bl	bbb
strh	r6, [r5, #0x12]
pop	{r3, r4, r5, r6, r7}
pop	{r0}
bx	r0

ddd:
ldr	r3, adr
push	{r4, lr}
mov	r0, r3
ldr	r3, =0x08002DED
bl	bbb
add	r0, #0x35
ldrb	r3, [r0, #0]
ldr	r2, =0x08F2FA48
lsl	r3, r3, #4
ldr	r0, [r3, r2]
bl	eee
pop	{r4}
pop	{r1}
bx	r1

eee:
lsl	r2, r0, #0
ldr	r3, adr+4
loop:
ldr	r1, [r3, #0]
ldrh	r0, [r3, #4]
cmp	r1, #0
beq	fff
add	r3, #8
cmp	r1, r2
bne	loop
bx	lr

fff:
mov	r0, #1
bx	lr

bbb:
bx	r3
ccc:
bx	r7


.ltorg
.align
adr: