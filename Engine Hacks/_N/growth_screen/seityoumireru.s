.thumb

@org	0x08089480

ldr	r0, =0x02003BFB
ldrb	r0, [r0, #0]
mov	r1, #1
tst	r0, r1
beq	non			@�������\���t���O�����ĂȂ��Ȃ���
ldr	r1, [r5, #0xC]
ldrb	r0, [r1, #0xB]
lsl	r0, r0, #24
bmi	non			@�G�Ȃ���
lsl	r0, r0, #1
bmi	non			@�����Ȃ���

push	{r6}
ldr	r6, =0x02003DF6
ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x1D		@�͐���
ldsb	r2, [r0, r2]
mov	r1, #2
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x33		@���͐���
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x1E		@�Z����
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r6, =0x02003D06
ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x1F		@��������
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x22		@�K�^����
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x20		@�������
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

ldr	r1, [r5, #0xC]
ldr	r0, [r1, #0]
mov	r2, #0x21		@���h����
ldsb	r2, [r0, r2]
mov	r1, #2
add	r6, #0x80
mov	r0, r6
push	{r3}
ldr	r3, =0x08004A9C		@DrawDecNumber
mov	lr, r3
pop	{r3}
.short	0xF800

pop	{r6}
ldr	r3, =0x080895B5
bx	r3

non:
ldr	r0, [r5, #0xC]
bl	GetUnitPower
ldr	r1, [r5, #0xC]
ldr	r3, =0x08089489
bx	r3

GetUnitPower:
ldr	r3, =0x08018EC4
mov	pc, r3


.ltorg
.align
adr: