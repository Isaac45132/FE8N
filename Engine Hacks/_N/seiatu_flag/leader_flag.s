.thumb

FlagA = (adr)
FlagB = (adr+4)
UnitA = (adr+8)
UnitB = (adr+12)

@org	0x08033188
push	{r2, r3, r5}
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

pop	{r2, r3, r5}
ldrh	r5, UnitB	@�w�胆�j�b�gID����2
ldrh	r5, [r5, #0]
.short	0xE004

flag1:
pop	{r2, r3, r5}
ldrh	r5, UnitA	@�w�胆�j�b�gID����1
ldrh	r5, [r5, #0]
.short	0xE000

end:
pop	{r2, r3, r5}
ldr	r0, =0x08033194
mov	pc, r0

.ltorg
.align
adr: