.thumb

FlagA = (adr)
FlagB = (adr+4)

@org	0x080C1E74

mov	r2, lr
push	{r2}
ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagA	@�w��t���OID����1
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasi		@�t���O�������Ă���Ȃ番��

ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagB	@�w��t���OID����2
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
beq	hutuu		@�t���O�������ĂȂ��Ȃ番��

nasi:
mov	r0, #1		@�����o���Ȃ�
.short	0xE000		@���΂�
hutuu:
mov	r0, #0		@���ʂ̋����o��������
pop	{r2}
mov	lr, r2
bx	lr

.ltorg
.align
adr: