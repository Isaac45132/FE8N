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
lsl	r1, r0, #24
bmi	teki		@�G�Ȃ番��
lsl	r1, r0, #25
bmi	end		@�����ȊO�Ȃ�I��
bl	syurui
mov	r1, #0x43	@AI1�J�E���^�[
.short	0xE001

teki:
mov	r1, #0x37 	@�x���l6�l��
mov	r2, #1		@�G�͂ǂ�Ȏ��ł�+1
add	r1, r1, r4	@��������G�������ʂ̏���
ldrb	r0, [r1, #0]
add	r0, r2
cmp	r0, #99		@�`�N�`�N�l���E:99
bls	dainyuu
mov	r0, #99
dainyuu:
strb	r0, [r1, #0]	@�`�N�`�N�l���

end:
pop	{r1}
pop	{pc}

syurui:
push	{r4, r5 ,lr}
ldr	r4, =0x0203a4e8	@����
ldr	r5, =0x0203a568	@����
ldrb	r0, [r4, #0xB]
cmp	r0, #0x81
blt	odori
ldr	r5, =0x0203a4e8	@�G
ldr	r4, =0x0203a568	@�G

odori:
@�x��
ldr	r0, =0x0203a4d0
ldrb	r0, [r0, #0x0]
mov	r1, #0x40
and	r0, r1
beq	tue
@�x�莞
ldr	r2, adr
b	owari

tue:
@��
mov	r0, #0x50
ldrb	r0, [r4, r0]
cmp	r0, #0x4
bne	miss
@��
bl	table		@��w��
cmp	r2, #0x0
bne	owari
ldr	r2, adr+4
b	owari

miss:
@�U���~�X��
mov	r0, r4
add	r0, #0x7c
ldrb	r0, [r0, #0]
lsl	r0, r0, #0x18
asr	r0, r0, #0x18
cmp	r0, #0x0
bne	migekiha
@�~�X��
ldr	r2, adr+8
b	owari

migekiha:
@�����j�A���j
mov	r0, #0x13
ldsb	r0, [r5, r0]	@�G�̌���HP
cmp	r0, #0x0
beq	gekiha

@�����j��
ldr	r2, adr+12
b	owari

gekiha:
@���j��
ldr	r2, adr+16
owari:
pop	{r4, r5}
pop	{pc}

table:
ldr	r1, adr+20
cmp	r1, #0x0
beq	nasi
mov	pc, r1
nasi:
mov	r2, #0x0
mov	pc, lr

.ltorg
.align
adr: