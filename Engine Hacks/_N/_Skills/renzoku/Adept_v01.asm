@thumb
;@org	$0802b004
	push	{r4, lr}
	mov	r4, #0
	ldr	r0, [r0, #76]
	mov	r1, #32
	and	r0, r1
	cmp	r0, #0
	beq skill ;x勇者武器持ってないならジャンプ
Brave:
	ldr	r0, =$0203a604
	ldr	r3, [r0, #0]
	ldr	r2, [r3, #0]
	lsl	r1, r2, #13
	lsr	r1, r1, #13
	mov	r0, #16
	orr	r1, r0
	ldr	r0, =$FFF80000
	and	r0, r2
	orr	r0, r1
	str	r0, [r3, #0]
	mov	r4, #1				;;攻撃回数加算
	b end
;これ以下は新処理
skill:
    mov r0, r6
    mov r1, r8
        @align 4
        ldr r3, [adr+4] ;bolt
        mov lr, r3
        @dcw $F800
    orr r4, r0
    
    mov r0, r8
    mov r1, r6
        @align 4
        ldr r3, [adr+4] ;bolt
        mov lr, r3
        @dcw $F800
    orr r4, r0
    
    cmp r4, #0
    bne Brave
renzoku:
    mov r0, r6
        @align 4
        ldr r1, [adr] ;連続
        mov lr, r1
        @dcw $F800
    cmp r0, #0
    beq end
got:
	mov	r0, #0x15
	ldsb	r0, [r6, r0]
	lsl	r0, r0, #16
	lsr	r0, r0, #16
	mov	r1, #0
ldr	r2, =$0802a490
mov lr, r2
@dcw $F800
	lsl	r0, r0, #24
	asr	r0, r0, #24
	cmp	r0, #1
	bne	end
	ldr	r0, =$0203a604
	ldr	r3, [r0, #0]
	ldr	r2, [r3, #0]
	lsl	r1, r2, #13
	lsr	r1, r1, #13
	mov	r0, #0x80
	lsl	r0, r0, #7
	orr	r1, r0
	ldr	r0, =$FFF80000
	and	r0, r2
	orr	r0, r1
	str	r0, [r3, #0]		;;必的発動の処理（エフェクトの為）
	mov	r4, #1				;;攻撃回数加算
end
	mov	r0, r4
	pop	{r4}
	pop	{pc}
	
@ltorg
adr: