.thumb

Flag_Move = (adr)
Map_Move1 = (adr+4)
Map_Move2 = (adr+8)
Map_Move3 = (adr+12)
MOVEUP_ADDR = (adr+16)

@org	0x08032D6C

ldrb	r3, [r1, #0x1D]	@移動補正値読み込み
add	r0, r0, r3	@クラス移動＋移動補正

bl	moveup		@スキル移動アップ

bl	hirou		@疲労3の時移動半減
			@無効にしたいなら@マークを先頭につける

bl	kyotenMap
ldr	r1, =0x0203a954
ldrb	r1, [r1, #0x10]
ldr	r3, =0x08032D74
mov	pc, r3

kyotenMap:
push	{r0, r1, r2, r3, lr}
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
bne	NoMove

kyotenFlag:
ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, Flag_Move	@指定フラグID
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	NoMove		@フラグが立ってるなら終了
pop	{r0, r1, r2, r3}
mov	r0, #15		@移動15が限界
.short	0xE000

NoMove:
pop	{r0, r1, r2, r3}
pop	{pc}

moveup:
        push {lr}
	push {r0, r1, r2, r3}
	mov r0, r1
        mov r1, #0
        bl HasMoveUp
        cmp r0, #0
        beq falsemove
	pop	{r0, r1, r2}
	mov	r3, #0x2	@移動+2
	add	r0, r0, r3
	pop	{r3}
        .short 0xE000
    falsemove:
	pop {r0, r1, r2, r3}
        pop {pc}

hirou:
push	{r2, lr}
ldr	r2, [r1, #0]	@ロムユニット
ldrb	r2, [r2, #0x4]	@ユニットID
cmp	r2, #0x1	@アイザック
beq	nohirou		@なら分岐

mov	r2, #0x47
ldrb	r2, [r1, r2]
cmp	r2, #0x3
bne	nohirou
lsr	r0, r0, #0x1
nohirou:
pop	{r2}
pop	{pc}

HasMoveUp:
	ldr r2, MOVEUP_ADDR
	mov pc, r2
.ltorg
.align
adr: