.thumb

FlagA = (adr)
FlagB = (adr+4)
UnitA = (adr+8)
UnitB = (adr+12)

@org	0x08037C24
push	{r2, r3}
ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagA	@�w��t���OID����1
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	flag1		@�t���O�������Ă���Ȃ番��

ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagB	@�w��t���OID����2
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
beq	end		@�t���O�������Ă��Ȃ��Ȃ番��

pop	{r2, r3}
ldrh	r2, UnitB	@�w�胆�j�b�gID����2
ldrh	r2, [r2, #0]
.short	0xE004

flag1:
pop	{r2, r3}
ldr	r2, UnitA	@�w�胆�j�b�gID����1
ldrh	r2, [r2, #0]
.short	0xE000

end:
pop	{r2, r3}
ldr	r1, =0x08037C2C
mov	pc, r1

.ltorg
.align
adr: