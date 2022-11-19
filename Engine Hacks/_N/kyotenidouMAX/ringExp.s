.thumb

Flag_Move = (adr)
Map_Move1 = (adr+4)
Map_Move2 = (adr+8)
Map_Move3 = (adr+12)
ring_exp = (adr+16)

@org	0x0802C558
push	{r0, r1, r2, r4}
ldr	r2, =0x0202BCEC
ldrb	r2, [r2, #0xE]	@現在マップID
ldrb	r0, Map_Move1	@指定マップID1
ldrb	r0, [r0, #0]
cmp	r0, r2
beq	kyotenFlag
ldrb	r0, Map_Move2	@指定マップID2
ldrb	r0, [r0, #0]
cmp	r0, r2
beq	kyotenFlag
ldrb	r0, Map_Move3	@指定マップID3
ldrb	r0, [r0, #0]
cmp	r0, r2
bne	expari

kyotenFlag:
ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, Flag_Move	@指定フラグID
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
beq	expnasi		@フラグが立ってるなら終了

expari:
pop	{r0, r1, r2, r4}
add	r2, #0x6E
mov	r0, #0x1E	@リング経験値
strb	r0, [r2, #0]
mov	r0, r1
add	r0, #0x1E	@リング経験値

ldr	r3, =0x0802C562
mov	pc, r3

expnasi:
pop	{r0, r1, r2, r4}
ldr	r3, =0x0802C56A
mov	pc, r3

.ltorg
.align
adr: