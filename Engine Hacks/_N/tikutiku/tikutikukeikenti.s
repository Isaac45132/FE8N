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
beq	end		@敵の現在ＨＰ0=撃破するなら終了
ldr	r1, =0x0202bcec
ldrb	r1, [r1, #0x14]
mov	r2, #0x40
and	r1, r2
cmp	r1, #0
beq	end		@ハードモードでないなら終了
mov	r1, #0x37
add	r3, r1, r7
ldrb	r1, [r3, #0]
sub	r1, #4		@経験値減算を開始するチクチク値
bmi	saiteiti	@チクチク値が4未満なら終了
add	r1, #1
sub	r0, r0, r1	@獲得経験値

saiteiti:
cmp	r0, #1
bpl	end		@獲得経験値が1以上なら終了
mov	r0, #1		@最低経験値1
ldr	r1, [r4, #0]	@ユニット判定
ldr	r2, [r4, #4]	@クラス判定
ldr	r1, [r1, #0x28]	@ユニット特性
ldr	r2, [r2, #0x28]	@クラス特性
lsr	r1, r1, #24	@特性4
lsr	r2, r2, #24	@特性4
orr	r1, r2
cmp	r1, #1		@虚無の呪い
beq	zero
ldrb	r1, [r3, #0]
cmp	r1, #10
bmi	end

zero:
mov	r0, #0		@10戦目以降は最低経験値0

end:
pop	{r1, r2}
pop	{pc}
.ltorg
.align