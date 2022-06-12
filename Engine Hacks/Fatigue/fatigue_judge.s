.thumb
	push	{r1, r2, lr}
	ldr	r2, =0x080860D0	@フラグが立ってるか
	mov	lr, r2
	ldrh	r0, addr	@指定フラグID
	.short	0xF800
	cmp	r0, #0
	beq	end		@フラグが立ってないなら終了
	
	ldr	r0, =0x0202BCEC
	ldrb	r0, [r0, #0xE]	@現在マップID
	cmp	r0, #0
	beq	end		@序章は無視

        ldr	r2, addr+4	@疲労しないマップ
        bl	Listfunc
	cmp	r0, #1
	beq	end		@疲労しない章は無視

	mov	r0, #1		@疲労あり
	.short 0xE000
end:
	mov	r0, #0		@疲労なし
	pop	{r1, r2, pc}

Listfunc:
@r2 = リスト先頭ポインタ
@r1 = 検索キー
	push {lr}
	push {r1}
    whileLoop:
        ldrb r1, [r2]
        cmp r1, #0
        beq endLoop
        cmp r1, r0
        beq trueLoop
        add r2, #1
        b whileLoop
    trueLoop:
        mov r0, #1
	.short 0xE000
    endLoop:
	mov r0, #0
	pop {r1}
        pop {pc}

.align
.ltorg
addr:
