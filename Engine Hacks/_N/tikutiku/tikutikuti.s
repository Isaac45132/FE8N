.thumb

@org	0x0802c138

mov	r5, r1
bl	tikutiku
ldrb	r0, [r5, #0x8]
strb	r0, [r4, #0x8]
ldrb	r0, [r5, #0x9]
strb	r0, [r4, #0x9]
ldr	r0, =0x0802c142
mov	pc, r0

tikutiku:
push	{r1, lr}
ldrb	r0, [r5, #0xB]
lsl	r0, r0, #24
bmi	teki		@�G�Ȃ番��
lsl	r0, r0, #24
bmi	end		@�����ȊO�Ȃ�I��
mov	r1, #0x43	@AI1�J�E���^�[
.short	0xE000

teki:
mov	r1, #0x37 	@�x���l6�l��
add	r1, r1, r4	@��������G�������ʂ̏���
ldrb	r0, [r1, #0]
cmp	r0, #99		@�`�N�`�N�l���E:99
beq	end
add	r0, #1
strb	r0, [r1, #0]	@�`�N�`�N�l���

end:
pop	{r1}
pop	{pc}

.ltorg
.align