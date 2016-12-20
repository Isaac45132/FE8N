@thumb
@org	$08089268
	
	push	{r4, r5, r6, r7, lr}
;画像
	mov	r4, #0
	ldr	r0, =$02003DAC
	ldr	r6, =$00007060
	mov	r5, r6	
	ldr	r1, =$000002c2
	add	r2, r0, r1
	add	r6, #8
	mov	r3, r6
	ldr	r6, =$00000302
	add	r1, r0, r6
loopE
	add	r0, r4, r5
	strh	r0, [r2, #0]
	add	r0, r4, r3
	strh	r0, [r1, #0]
	add	r2, #2
	add	r1, #2
	add	r4, #1
	cmp	r4, #7
	ble	loopE
;アイコン
	ldr	r6, =$020040F0	;icon position
	ldr	r7, =$02003B00	;help memory
	mov	r5, #0
	str	r5, [r7]
	str	r5, [r7, #4]
	str	r5, [r7, #8]
	ldr	r5, [adr1+4]
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r4, [r4]
	ldrb	r4, [r4, #4]
	bl	SKILL
	
	ldr	r5, [adr2]
	ldr	r4, =$02003BFC
	ldr	r4, [r4, #12]
	ldr	r4, [r4, #4]
	ldrb	r4, [r4, #4]
	bl	SKILL

	ldr r5, [adr3]
	ldr	r4, =$0203a530
	ldrb	r4, [r4]
	cmp r4, #0
	beq end
	bl	SKILL
end
	pop	{r4, r5, r6, r7, pc}

SKILL
	push	{lr}
	cmp	r5, #0
	bne	test
	pop	{pc}
restart
	mov	r0, r4
	mov	r2, #0x10
loop
	ldrb	r1, [r5, r2]
	cmp	r0, r1
	beq	skiller
	add	r2, #1
	cmp	r2, #0x20
	beq	jump ;limit
	cmp	r1,	#0
	bne	loop
	b	jump
skiller
	ldrh	r1, [r5, #2]
	strh	r1, [r7]
	ldrh	r1, [r5]
	mov	r2, #0xA0
	ldrb	r3, [r5, #4]
	cmp	r3, #0xFF
	bne	nonitem
	sub	r2, #0x20
nonitem
	lsl	r2, r2, #7
	mov	r0, r6
	bl	icon
	add	r6, #6
	add	r7, #2
	
jump
	add	r5, #0x20
test
	ldrb	r0, [r5]
	cmp	r0, #0xFF
	bne	doublecount
	pop	{pc}

doublecount

	ldrh r0, [r5, #2]
	ldr r2 =$02003B00
loopyloopy
	cmp r2, r7
	beq limitter
	ldrh r1, [r2]
	cmp r0, r1
	beq jump
	add r2, #2
	b loopyloopy

limitter
	lsl r0, r7, #24
	lsr r0, r0, #24
	cmp r0, #10
	bne restart
	pop {pc}

icon
	ldr	r3, =$08003608
	mov	pc, r3

@ltorg
adr1
	@DCD	$00000000
adr2
	@DCD	$00000000
adr3
	@DCD	$00000000