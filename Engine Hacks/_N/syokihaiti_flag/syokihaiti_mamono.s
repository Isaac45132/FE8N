.thumb

FlagA = (adr)
FlagB = (adr+4)
FlagC = (adr+8)

@org	0x0808568C
mov	r4, r0		@���̏���

ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagA	@�w��t���OID����1
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiA		@�t���O�������Ă���Ȃ番��

ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagB	@�w��t���OID����2
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiB		@�t���O�������Ă���Ȃ番��

ldr	r2, =0x080860D0	@�t���O�������Ă邩
mov	lr, r2
ldrh	r0, FlagC	@�w��t���OID����3
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiC		@�t���O�������Ă���Ȃ番��

mov	r1, #0		@���ʂ̔z�u������
b	end

nasiA:
mov	r1, #2		@�����̔z�u������
ldr	r0, [r4, #0x30]	@�����̔z�u1
b	end

nasiB:
mov	r1, #2		@�����̔z�u������
ldr	r0, [r4, #0x34]	@�����̔z�u2
b	end

nasiC:
mov	r1, #2		@�����̔z�u������
ldr	r0, [r4, #0x38]	@�����̔z�u3

end:
ldr	r3, =0x08085694
mov	pc, r3

.ltorg
.align
adr: