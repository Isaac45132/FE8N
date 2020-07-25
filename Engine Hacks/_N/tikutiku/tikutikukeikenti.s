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
add	r1, r1, r7
ldrb	r1, [r1, #0]
sub	r1, #4		@経験値減算を開始するチクチク値
bmi	end		@チクチク値が4未満なら終了
add	r1, #1
sub	r0, r0, r1	@獲得経験値
bpl	end
mov	r0, #0		@負の値にならないようにする
end:
pop	{r1, r2}
pop	{pc}
.ltorg
.align