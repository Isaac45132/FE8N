.thumb

@org	0x080324b0
push	{r0, r1, r2}
mov	r1, #0x43	@AI1�J�E���^�[	
ldrb	r0, [r2, r1]
ldr	r2, adr		@��J�l
add	r0, r0, r2
cmp	r0, #99		@�`�N�`�N�l���E:99
bls	dainyuu
mov	r0, #99
dainyuu:
strb	r0, [r1, #0]	@�`�N�`�N�l���
pop	{r0, r1, r2}

bl	Exp10
bl	ClearMoveUnits
ldr	r0, =0x080324b8
mov	pc, r0

Exp10:
ldr	r1, =0x0802cb70
mov	pc, r1

ClearMoveUnits:
ldr	r1, =0x0807b4b8
mov	pc, r1

.ltorg
.align
adr: