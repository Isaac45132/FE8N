.thumb

@org	0x0802b8a4

bl	exp
bl	tikutiku
mov	r6, r5
add	r6, #0x6E
strb	r0, [r6, #0]
ldr	r0, =0x0802b8ae
mov	pc, r0

exp:
ldr	r3, =0x0802c46c
mov	pc, r3

tikutiku:
push	{r1, r2, lr}
ldrb	r1, [r4, #0x13]
cmp	r1, #0
beq	end		@�G�̌��݂g�o0=���j����Ȃ�I��
ldr	r1, =0x0202bcec
ldrb	r1, [r1, #0x14]
mov	r2, #0x40
and	r1, r2
cmp	r1, #0
beq	end		@�n�[�h���[�h�łȂ��Ȃ�I��
mov	r1, #0x37
add	r3, r1, r7
ldrb	r1, [r3, #0]
sub	r1, #4		@�o���l���Z���J�n����`�N�`�N�l
bmi	saiteiti	@�`�N�`�N�l��4�����Ȃ�I��
add	r1, #1
sub	r0, r0, r1	@�l���o���l

saiteiti:
cmp	r0, #1
bpl	end		@�l���o���l��1�ȏ�Ȃ�I��
mov	r0, #1		@�Œ�o���l1
ldr	r1, [r4, #0]	@���j�b�g����
ldr	r2, [r4, #4]	@�N���X����
ldr	r1, [r1, #0x28]	@���j�b�g����
ldr	r2, [r2, #0x28]	@�N���X����
lsr	r1, r1, #24	@����4
lsr	r2, r2, #24	@����4
orr	r1, r2
cmp	r1, #1		@�����̎�
beq	zero
ldrb	r1, [r3, #0]
cmp	r1, #10
bmi	end

zero:
mov	r0, #0		@10��ڈȍ~�͍Œ�o���l0

end:
pop	{r1, r2}
pop	{pc}
.ltorg
.align