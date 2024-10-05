.thumb
	

	cmp	r3, #0
	bne	Start
	strb	r3, [r6, #8]
	ldr	r0, =0x0801a1ea
	mov	pc, r0


Start:
    push {r3}
    ldrb r0, [r4, #11]	@味方か
    lsr r0, r0, #6
    bne Jump
    ldr r0, =0x0202BCF9	@索敵マップか
    ldrb r1, [r0]
    cmp r1, #0
    bne nonPass
	ldrb r0, [r0, #2]	@味方かつ敵ターン時なら
	cmp r0, #0
	bne nonPass		@終了


@謎のバグ防止
Jump:
    mov r0, r13
    ldr r1, =0x03007d18
    cmp r0, r1
    beq nonPass

@スキルチェック
    mov r0, r4
        .align
        ldr r1, adr @hasNihil
        mov lr, r1
        .short 0xF800
    cmp r0, #0
    bne ouiPass
    
nonPass:
    mov r0, #1
    b Return
ouiPass:
    mov r0, #0
Return:
    pop {r3}
    ldr r1, =0x0801a1e6
    mov pc, r1
.align
.ltorg
adr: