.thumb

@org	0x0802a1a8

ldr	r4, =0x0203a568
mov	r0, r4
mov	r1, r7
push	{r0, r1, r2}

ldr	r0, =0x0203a4e8
bl	HasMikiri
cmp	r0, #0
bne	non	@攻撃する側が見切り持ちなら終了

bl	Mamorite
cmp	r0, #0
beq	non

pop	{r0, r1, r2}
push	{r4, r5}
ldrb	r4, [r1, #0x10]
ldrb	r5, [r1, #0x11]
mov	r1, r3
bl	copy
strb	r4, [r1, #0x10]
strb	r5, [r1, #0x11]
pop	{r4, r5}
b	end

non:
pop	{r0, r1, r2}
bl	copy

end:
ldr	r3, =0x0802a1b3
bx	r3

copy:
ldr	r3, =0x0802a4f0
mov	pc, r3
	

Mamorite:
@青は青に対して効く
@緑は緑に対して効く
@赤は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
	mov r4, r7
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bpl doumeiF
        mov r6, #0x80
        bl skillF_impl
        b endskillF
    doumeiF:
        lsl r0, r0, #1
        bpl mikataF
        mov r6, #0x40
        bl skillF_impl
        b endskillF
mikataF:
        mov r6, #0x00
        bl skillF_impl
    endskillF:
        pop {r4, r5, r6, r7, pc}

skillF_impl:
        push {lr}
        mov r7, #0
    loopskillF:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultskillF	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopskillF		@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopskillF		@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopskillF
    
        mov r0, #1  		@範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopskillF		@近くにいない
    
	ldrb r0, [r5, #0xB]
	ldrb r1, [r4, #0xB]
	cmp r0, r1
	beq loopskillF 		@自分自身には無効

        mov r0, r5
        mov r1, r4
        bl HasMamorite
        cmp r0, #0
        beq loopskillF    	@相手がスキルA未所持
    
        mov r0, r6
        bl Get_Status
	mov r3, r0
        mov r0, #1
	.short	0xE000  

    resultskillF:
	mov r0, #0
        pop {pc}

CheckXY:
@r1とr2がr0マス以内に居るならr0=TRUE
@同座標ならTRUE
@
        push {r0}
        ldrb r0, [r1, #16]
        ldrb r3, [r2, #16]
        sub r3, r0, r3
        bge jump1CheckXY
        neg r3, r3  @絶対値取得
    jump1CheckXY:

        ldrb r1, [r1, #17]
        ldrb r2, [r2, #17]
        sub r2, r1, r2
        bge jump2CheckXY
        neg r2, r2  @絶対値取得
    jump2CheckXY:

        add r2, r2, r3
        pop {r0}
        cmp r2, r0
        bgt falseCheckXY    @r0マス以内に居ない
        mov r0, #1
        bx lr
    falseCheckXY:
        mov r0, #0
        bx lr

Get_Status:
    ldr r1, =0x08019108
    mov pc, r1

GetExistFlagR1:
    ldr r1, =0x1002C    @居ないフラグ+救出されている
    bx lr

HasMamorite:
	ldr r1, adr
	mov pc, r1

HasMikiri:
	ldr r1, adr+4    @見切り
	mov pc, r1
	
.ltorg
.align
adr: