.thumb
@.org	0x080891C0

	ldrb	r2, [r1, #0x9]	@元の書き込み
	mov	r1, #0x2	@
	bl	DrawDecNumber	@
	
	ldr	r3, =0x0202bcfa
	ldrb	r1, [r3, #0x0]	
	cmp	r1, #0x0	@序章
	beq	end
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
	ldr	r3, [r1, #0x0]	@ロムユニット
	ldrb	r3, [r3, #0x4]	@ユニットID
	ldr	r2, adr+8	@UnitSetting_Fatigue
loop2:
	ldrb	r0, [r2, #0x0]	@UnitSetting_Fatigue一人目
	cmp	r0, #0x0
	beq	endloop2	@設定終了0なら数値描画へ
	cmp	r0, r3
	beq	end		@描画しない
	add	r2, #0x1
	b	loop2		@二人目以降へ繰り返す
endloop2:
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