.thumb
@
	push {lr}
    ldr r0, [r5, #4]
    cmp r0, #0
    beq nonEnemy	@相手いない
	bl tubame	@見切りでも発動
	bl ouzya	@見切りでも発動

nonEnemy:
	bl Yandere	@見切りでも発動
	bl Koigata	@見切りでも発動
	pop {pc}

tubame:
        push {lr}	
	mov r0, r5
        bl HasNullify	@相手練達
	cmp r0, #0
	bne falseTubame

gotTubame:
	mov r0, r4
	bl HasTubame
	cmp r0, #0
	beq falseTubame
	bl TUBAME_TOKKOU
	bl effect_test
	cmp r0, #0
	beq falseTubame
    
        mov r1, #96
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1] @命中

        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1] @回避
falseTubame:
        pop {pc}

ouzya:
        push {lr}	
	mov r0, r5
        bl HasNullify	@相手練達
	cmp r0, #0
	bne falseOuzya

gotOuzya:
	mov r0, r4
	bl HasOuzya
	cmp r0, #0
	beq falseOuzya
	bl OUZYA_TOKKOU
	bl effect_test
	cmp r0, #0
	beq falseOuzya
    
        mov r1, #96
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1] @命中

        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1] @回避
falseOuzya:
        pop {pc}

effect_test:
    ldr r3, [r5, #4]
    ldrb r3, [r3, #4]
    b effective_loop
effect_back:
    ldrb r0, [r1, #0]
    cmp r0, r3
    beq effective_true
    add r1, #1
effective_loop:
    ldrb r0, [r1, #0]
    cmp r0, #0
    bne effect_back
    mov r0, #0
    b effective_false
effective_true:
    mov r0, #1
effective_false:
    bx lr    

Yandere:
        push {r4, r5, r6, lr}
        mov r0, r4
        mov r1, #0
        bl HasYandere
        cmp r0, #0
        beq endYandere    @スキル未所持

        mov r6, #0
    loopYandere:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq endYandere		@リスト末尾
	ldr r0, [r5]
	ldrb r0, [r0, #4]
        cmp r0, #1
        bne loopYandere		@アイザック判定
        ldr r0, [r5]
        cmp r0, #0
        beq loopYandere		@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopYandere		@死亡判定2
    
        ldr r0, [r5, #0xC]
	ldr r1, =0x1000C	@居ないフラグ@救出されてても発動
        and r0, r1
        bne loopYandere
    
        mov r0, #1  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopYandere		@近くにいない
    
        mov r1, #102 @必殺
        ldrh r0, [r4, r1]
        add r0, #10
        strh r0, [r4, r1]

        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        add r0, #30
        strh r0, [r4, r1]
    endYandere:
        pop {r4, r5, r6, pc}

Koigata:
        push {r4, r5, r6, lr}
        mov r0, r4
        mov r1, #0
        bl HasKoigata
        cmp r0, #0
        beq endKoigata    @スキル未所持

        mov r6, #0
    loopKoigata:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq endKoigata		@リスト末尾
	ldr r0, [r5]
	ldrb r0, [r0, #4]
        cmp r0, #0xF		@味方リディ
        beq nextKoigata		
        cmp r0, #0xD4		@大人リディ
        bne loopKoigata		
    nextKoigata:
        ldr r0, [r5]
        cmp r0, #0
        beq loopKoigata		@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopKoigata		@死亡判定2
    
        ldr r0, [r5, #0xC]
	ldr r1, =0x1000C	@居ないフラグ@救出されてても発動
        and r0, r1
        bne loopKoigata
    
        mov r0, #1  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopKoigata		@近くにいない
    
        mov r1, #102 @必殺
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1]

        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1]
    endKoigata:
        pop {r4, r5, r6, pc}

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

TUBAME_ADDR = (addr)
OUZYA_ADDR = (addr+4)
TUBAME_TOKKOU:
ldr r1, (addr+8)
bx lr
OUZYA_TOKKOU:
ldr r1, (addr+12)
bx lr
NULLIFY_ADDR = (addr+16)
YANDERE_ADDR = (addr+20)
KOIGATAKI_ADDR = (addr+24)

HasTubame:
	ldr r2, TUBAME_ADDR
	mov pc, r2
HasOuzya:
	ldr r2, OUZYA_ADDR
	mov pc, r2
HasNullify:
	ldr r2, NULLIFY_ADDR
	mov pc, r2
HasYandere:
	ldr r2, YANDERE_ADDR
	mov pc, r2
HasKoigata:
	ldr r2, KOIGATAKI_ADDR
	mov pc, r2

.ltorg
.align
addr:

