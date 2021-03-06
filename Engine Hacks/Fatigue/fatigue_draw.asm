.thumb
@.org	0x080891C0

	ldrb	r2, [r1, #0x9]	@元の書き込み
	mov	r1, #0x2	@
	bl	DrawDecNumber	@
	
	ldr	r1, [r7, #0xC]
	ldr	r3, [r1, #0x0]	@ロムユニット
	ldrb	r3, [r3, #0x4]	@ユニットID
	cmp	r3, #0x1	@アイザック
	bne	end		@アイザック以外なら終了

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

.ltorg
.align
adr: