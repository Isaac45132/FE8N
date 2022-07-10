.thumb

Flag_Move = (adr)
Map_Move1 = (adr+4)
Map_Move2 = (adr+8)
Map_Move3 = (adr+12)
MOVEUP_ADDR = (adr+16)
HITANDRUNB_ADDR = (adr+20)

@org	0x08089878

mov	r3, lr
ldrb	r2, [r0, #0x1D]	@移動補正値読み込み
add	r1, r1, r2	@クラス移動＋移動補正

bl	moveup		@スキル移動アップ

bl	hirou		@疲労3の時移動半減
			@無効にしたいなら@マークを先頭につける

bl	zinrai		@疾風迅雷の移動半減

bl	hitandrunB	@一撃離脱の移動7

bl	kyotenMap	@拠点で移動15
mov	lr, r3
ldrb	r2, [r0, #0xB]	@部隊表ID
lsl	r2, r2, #0x18
lsr	r2, r2, #0x1E
beq	MovEnd		@味方なら終了
ldr	r3, =0x08089884
mov	pc, r3

MovEnd:
ldr	r2, =0x080898A0
mov	pc, r2

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
mov	r1, #15		@移動15が限界
.short	0xE000

NoMove:
pop	{r0, r1, r2, r3}
pop	{pc}

moveup:
        push {lr}
	push {r0, r1, r2, r3}
        mov r1, #0
        bl HasMoveUp
        cmp r0, #0
        beq falsemove
	pop	{r0, r1, r2}
	mov	r3, #0x2	@移動+2
	add	r1, r1, r3
	pop	{r3}
        .short 0xE000
    falsemove:
	pop {r0, r1, r2, r3}
        pop {pc}

hirou:
push	{lr}
ldr	r2, [r0, #0]	@ロムユニット
ldrb	r2, [r2, #0x4]	@ユニットID
cmp	r2, #0x1	@アイザック
beq	nohirou		@なら分岐

mov	r2, #0x47
ldrb	r2, [r0, r2]
cmp	r2, #0x3
bne	nohirou
lsr	r1, r1, #0x1
nohirou:
pop	{pc}

HasMoveUp:
	ldr r2, MOVEUP_ADDR
	mov pc, r2

DEFEATED = (0b01000000) @迅雷済みフラグ

zinrai:
	push	{lr}
        ldrb	r2, [r0, #0xB]
        lsr	r2, r2, #6
        bne	endzinrai         @自軍以外なら終了
        mov	r2, #69
        ldrb	r2, [r0, r2]

	push	{r1}
        mov	r1, #DEFEATED
        and	r2, r1
	pop	{r1}
        beq	endzinrai
        lsr	r1, r1, #1

endzinrai:
	pop	{pc}

hitandrunB:
	push	{lr}
	push	{r0, r1, r3}
	ldr	r1, [r0, #0xC]
	ldr	r2, =0x80000000
	tst	r1, r2
	beq	endrun

        ldr	r2, HITANDRUNB_ADDR
        mov	lr, r2
        .short	0xF800
        cmp	r0, #0
        beq	endrun

	pop	{r0, r1, r3}
	push	{r0, r1, r3}
	ldr	r3, =0x0203AD70
	ldrb	r2, [r3, #0]
	mov	r0, #0
	strb	r0, [r3, #0]
	sub	r2, r1, r2
	cmp	r2, #8
	bge	endrun

	pop	{r0, r1, r3}
	mov	r1, #7
        .short	0xE000
endrun:
	pop	{r0, r1, r3}
	pop	{pc}

.ltorg
.align
adr: