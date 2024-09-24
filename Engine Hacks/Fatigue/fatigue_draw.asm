.thumb
@.org	0x080891C0

	ldrb	r2, [r1, #0x9]	@元の書き込み
	mov	r1, #0x2	@
	bl	DrawDecNumber	@
	
	ldr	r3, =0x0202bcfa
	ldrb	r1, [r3, #0x0]	
	cmp	r1, #0x0	@序章
	beq	end

@20220410
	push	{r1}
	ldr	r2, =0x080860D0	@フラグが立ってるか
	mov	lr, r2
	ldrh	r0, FlagA	@指定フラグID
	.short	0xF800
	pop	{r1}
	cmp	r0, #0
	beq	end		@フラグが立ってないなら終了
@20220410

	ldr	r3, adr+4
loop:
	ldrb	r0, [r3, #0x0]
	cmp	r0, #0x0
	beq	endloop
	cmp	r0, r1
	beq	end
	add	r3, #0x1
	b	loop
endloop:
	ldr	r1, [r7, #0xC]
	mov	r3, #0xB
	ldrb	r3, [r1, r3]
	cmp	r3, #0x40
	bgt	end		@味方以外なら終了
@	ldr	r3, [r1, #0x0]	@ロムユニット
@	ldrb	r3, [r3, #0x4]	@ユニットID

	ldr	r3, [r1, #4]	@クラス
	ldrb	r3, [r3, #4]
	cmp	r3, #0x51	@亡霊戦士
	beq	end

	ldr	r0, adr		@位置
	add	r0, r8		@位置
	mov	r3, #0x43	@AI1カウンター
	ldrb	r2, [r1, r3]	@AI1カウンター値
	mov	r1, #0x2	@桁数？
	bl	DrawDecNumber	@数値描画

end:
	ldr	r3, =0x080891C8
	mov	pc, r3

DrawDecNumber:
	ldr	r3, =0x08004A9C
	mov	pc, r3

FlagA = adr+8

.ltorg
.align
adr: