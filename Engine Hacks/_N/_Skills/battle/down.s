RAGING_STORM_FLAG     = (2)
COMBAT_HIT            = (1)
@FIRST_ATTACKED_FLAG   = (0)

.thumb

@ 0802bfd8

    cmp	r6, #0
    bne	START
    ldr	r0, =0x0802bfec
    mov	pc, r0
START:
    mov	r0, r6
    mov	r1, r4
        ldr	r2, =0x0802c134
        mov	lr, r2
        .short 0xF800
@攻め側スキル→受け
    ldrb r0, [r7, #19]
    cmp r0, #0
    beq negative	@自分のHP0
    
    mov	r0, r7
    mov	r1, r6
    bl Fury
    
    mov	r0, r7
    mov	r1, r6
    bl DoubleLion	@HP満タンの時だけなので最後
    
    mov	r0, r7
    mov	r1, r6
    bl SavageBlow

    bl CombatArts

    ldrb r0, [r6, #19]
    cmp r0, #0
    beq negative	@相手のHP0

    mov	r0, r7
    mov	r1, r6
    bl Jadoku

    mov	r0, r7
    mov	r1, r6
    bl Counter

    mov	r0, r7
    mov	r1, r6
    bl Mazyo
negative:
@受け側スキル→攻め
    ldrb r0, [r6, #19]
    cmp r0, #0
    beq END	@自分のHP0
    
    mov	r0, r6
    mov	r1, r7
    bl Fury

    mov	r0, r6
    mov	r1, r7    
    bl Mamorite

    mov	r0, r6
    mov	r1, r7
    bl DoubleLion	@HP満タンの時だけなので最後

END:
    mov r0, r7          @r7はユニット直
    bl WarSkill_back

    pop	{r4, r5, r6, r7}
    pop	{r0}
    bx	r0

@
@r5はATK,DEF
@r7はユニット直
@
CombatArts:
        push {lr}
        mov r0, #COMBAT_HIT
        mov r1, #0
        bl IS_TEMP_SKILL_FLAG
        cmp r0, #0
        beq endCombatArts      @当たってないので終了

        bl RagingStorm

endCombatArts:
        pop {pc}

RagingStorm:
        push {lr}

        ldrb r0, [r5, #11]
        mov r2, #0xC0
        and r2, r0
        bne endRagingStorm          @自軍以外はジャンプ(発動できない)
        
        mov r0, r5
        bl HAS_RAGING_STORM
        cmp r0, #0
        beq endRagingStorm

        mov r0, #RAGING_STORM_FLAG        
        mov r1, #0
        bl TURN_ON_TEMP_SKILL_FLAG @saikoudou/mainで回収

    endRagingStorm:
        pop {pc}

DoubleLion:
    push	{r4, lr}
    mov	r4, r0
    
    bl hasDoubleLion
    cmp	r0, #0
    beq falseDouble
    
    ldrb r1, [r4, #18]	@最大HP
    ldrb r0, [r4, #19]	@現在HP
    cmp r0, r1
    blt falseDouble
    sub r0, #6
    bgt LionHPcheck
    mov r0, #1
LionHPcheck:
    strb r0, [r4, #19]
    mov	r0, #1
    b	retDouble
falseDouble:
    mov	r0, #0
retDouble:
    pop	{r4, pc}

WarSkill_back:
    push {lr}
    mov r1, r0

    mov r0, #0
    bl SET_COMBAT_ART
war_end:
    pop {pc}

Counter:
    push	{r4, lr}
    mov r4, r0
    mov r3, r1
@	ldrb r0, [r4, #0x13]
@	cmp r0, #0
@	beq falseCounter		@撃破なら終了
@	ldrb r0, [r3, #0x13]
@	cmp r0, #0
@	beq falseCounter		@撃破なら終了
    
    ldr r0, =0x0203a568
    add r0, #72
    ldrh r0, [r0]
    cmp r0, #0
    bne falseCounter		@武器所持なら終了
    
    
    ldrb r0, [r3, #0xB]
    lsl r0, r0, #24
    bmi isRedCounter

    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bmi startCounter
    b falseCounter	@相手チェック失敗
    
isRedCounter:
    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bpl startCounter
    b falseCounter	@相手チェック失敗
    
startCounter:
    mov r0, r3
    mov r1, r4
        ldr r2, ADR+12
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    beq falseCounter	@相手応撃未所持なら終了
    
        ldr r0, [r4, #0]
        ldr r0, [r0, #40]
        lsr r0, r0, #15		@自分が敵将なら終了
        mov r1, #1
        and r0, r1
	cmp r0, #1
	beq falseCounter

    ldr r1, =0x0203a4d0
    ldrb	r1, [r1, #4]
    cmp r1, #0
    beq falseCounter	@ノーダメージなら終了
@on
    ldrb r0, [r4, #19] @現在19
    sub r0, r1
    bgt hpOkCounter
    mov r0, #1
hpOkCounter:
    strb r0, [r4, #19] @現在19
    
    mov r0, #0xD2	@妥当な音のIDが分からん
    mov r1, #0xB8
        ldr r2, =0x08014B50 @音
        mov lr, r2
        .short 0xF800
    mov	r0, #1
    .short 0xE000
falseCounter:
    mov	r0, #0
    pop	{r4, pc}

SavageBlow:
    push	{r4, r5, lr}
    mov r3, r0
    mov r4, r1

    ldrb r0, [r3, #0xB]
    lsl r0, r0, #24
    bmi isRed2

    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bmi startSavage
    b falseSavage	@相手チェック失敗
    
isRed2:
    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bpl startSavage
    b falseSavage	@相手チェック失敗
    
startSavage:
    mov r0, r3
    mov r1, r4
    ldrb r2, [r1, #19]
    cmp r2, #0
    bne jumpSavege
    mov r1, #0	@相手のHP0なら見切り貫通
jumpSavege:
        ldr r2, HAS_SAVAGE_FUNC
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    beq falseSavage	@死の吐息未所持なら終了

        ldrb r0, [r4, #0xB]
        mov r1, #0xC0
        and r0, r1
        b loopStartSavage

     loopSavage:
        ldrb r0, [r5, #0xB]
    loopStartSavage:
        add r0, #1
        bl Get_Status
        mov r5, r0
        cmp r5, #0
        beq resultSavage

        ldr r0, [r5]
        cmp r0, #0
        beq loopSavage	@死亡判定1
        ldrb r0, [r5, #19] @現在19
        cmp r0, #0
        beq loopSavage	@死亡判定2
        
        ldr r0, [r5, #0xC]
        ldr r1, =0x1002C
        and r0, r1
        bne loopSavage	@居ない判定+救出中

        mov r0, #2	@within 2
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopSavage	@no exist

        ldrb r0, [r5, #19] @現在19
        sub r0, #10
        bgt hpOk2
        mov r0, #1
    hpOk2:
        strb r0, [r5, #19] @現在19
        b loopSavage

resultSavage:
    mov r0, #0xB7	@妥当な音のIDが分からん
    mov r1, #0xB8
        ldr r2, =0x08014B50 @音
        mov lr, r2
        .short 0xF800
    mov	r0, #1
    .short 0xE000
falseSavage:
    mov	r0, #0
    pop	{r4, r5, pc}

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
        b endCheckXY

    falseCheckXY:
        mov r0, #0
    endCheckXY:
        bx lr

Get_Status:
    ldr r1, =0x08019108
    mov pc, r1

Jadoku:
    push	{r4, lr}
    mov r3, r0
    mov r4, r1

    mov r0, #COMBAT_HIT
    mov r1, #0
    bl IS_TEMP_SKILL_FLAG
    cmp r0, #0
    beq falseJadoku         @当たってないので終了

    ldrb r0, [r3, #0xB]
    lsl r0, r0, #24
    bmi isRed

    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bmi startJadoku
    b falseJadoku	@相手チェック失敗
    
isRed:
    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bpl startJadoku
    b falseJadoku	@相手チェック失敗
    
startJadoku:
    mov r0, r3
    mov r1, r4
        ldr r2, ADR+8
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    beq falseJadoku	@蛇毒未所持なら終了

@蛇毒on
    ldrb r0, [r4, #19] @現在19
    sub r0, #10
    bgt hpOk
    mov r0, #1
hpOk:
    strb r0, [r4, #19] @現在19
    
    mov r0, #0xB7	@妥当な音のIDが分からん
    mov r1, #0xB8
        ldr r2, =0x08014B50 @音
        mov lr, r2
        .short 0xF800
    mov	r0, #1
    .short 0xE000
falseJadoku:
    mov	r0, #0
    pop	{r4, pc}
    
Mazyo:
    push	{r4, lr}
    mov r3, r0
    mov r4, r1

    mov r0, #COMBAT_HIT
    mov r1, #0
    bl IS_TEMP_SKILL_FLAG
    cmp r0, #0
    beq falseMazyo         @当たってないので終了

    ldrb r0, [r3, #0xB]
    lsl r0, r0, #24
    bmi isRedMa

    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bmi startMazyo
    b falseMazyo	@相手チェック失敗
    
isRedMa:
    ldrb r0, [r4, #0xB]
    lsl r0, r0, #24
    bpl startMazyo
    b falseMazyo	@相手チェック失敗
    
startMazyo:
    mov r0, r3
    mov r1, r4
        ldr r2, ADR+60
        mov lr, r2
        .short 0xF800
    cmp r0, #0
    beq falseMazyo	@魔女未所持なら終了

    mov r3, #0x22	@スリープ2ターン
    mov r0, #33
    mov r1, #0
    push {r3}
        ldr r3, =0x0802A490
        mov lr, r3
        .short 0xF800
    pop {r3}
    cmp r0, #0
    bne zyoutai
    mov r3, #0x23	@サイレス2ターン
    mov r0, #33
    mov r1, #0
    push {r3}
        ldr r3, =0x0802A490
        mov lr, r3
        .short 0xF800
    pop {r3}
    cmp r0, #0
    bne zyoutai
    mov r3, #0x21	@ポイズン2ターン
    
zyoutai:
	mov	r1, r4
	add	r1, #0x30
	strb	r3, [r1]

    mov r0, #0xB7	@妥当な音のIDが分からん
    mov r1, #0xB8
        ldr r2, =0x08014B50 @音
        mov lr, r2
        .short 0xF800
    mov	r0, #1
    .short 0xE000
falseMazyo:
    mov	r0, #0
    pop	{r4, pc}
    
Fury:
    push	{r4, lr}
    mov	r4, r0
        ldr	r2, ADR+4
        mov	lr, r2
        .short 0xF800
    cmp	r0, #0
    beq falseFury
    ldrb r0, [r4, #19] @現在HP
    sub	r0, #3
    bgt jumpFury
    mov	r0, #1
jumpFury:
    strb	r0, [r4, #19]
    mov	r0, #1
    b	retFury
falseFury:
    mov	r0, #0
retFury:
    pop	{r4, pc}


Mamorite:
        push {r5, lr}
	mov r5, r0
        mov r1, #0
	bl HasMamorite
        cmp r0, #0
        beq endMamoriteDef	@スキルチェック

	ldrb r1, [r4, #0x10]
	ldrb r2, [r5, #0x10]
	sub r1, r1, r2
	cmp r1, #0
	bne hatudoumamo		@護り手が発動してるか

	ldrb r1, [r4, #0x11]
	ldrb r2, [r5, #0x11]
	sub r1, r1, r2
	cmp r1, #0
	beq endMamoriteDef	@護り手未発動なら不可

   hatudoumamo:
	ldrb r0, [r5, #19] @現在HP
	sub r0, #4
	bgt jumpmamo
	mov r0, #1
   jumpmamo:
	strb r0, [r5, #19]
	mov r0, #1
	.short 0xE000
   endMamoriteDef:
	mov r0, #0
        pop {r5, pc}

CanLocate:
@
@r0 = Width
@r1 = Height
@r2 = Unit
@
@[out]r0=0(踏破不可)
@
@refer to 08025398
@
        push {r4, r5, r6, lr}
        mov r4, r0
        mov r5, r1
        mov r6, r2

        ldr r1, =0x0202e4d4
        ldr r1, [r1, #0]
        lsl r2, r5, #2
        add r1, r2, r1
        ldr r1, [r1, #0]
        add r1, r1, r4
        ldrb r1, [r1, #0]
        cmp r1, #0
        bne falseLocate     @人がいる

jumpLocate:
        ldr r1, =0x0202e4d8
        ldr r1, [r1, #0]
        lsl r2, r5, #2
        add r1, r2, r1
        ldr r1, [r1, #0]
        add r1, r1, r4
        ldrb r1, [r1, #0]
        mov r0, r6
            ldr r2, =0x08019174
            mov lr, r2
            .short 0xF800
        .short 0xE000
    falseLocate:
        mov r0, #0
        pop {r4, r5, r6, pc}
CanLocateMinus:
        push {r4, r5, r6, lr}
        mov r4, r0
        mov r5, r1
        mov r6, r2
        b jumpLocate

hasDoubleLion:
    ldr r2, (ADR+16)
    mov pc, r2

HAS_SAVAGE_FUNC = (ADR+20)

FodesFunc:
    ldr r1, (ADR+24)
    mov pc, r1

HAS_LUNGE:
    ldr r2, (ADR+28)
    mov pc, r2
HAS_HIT_AND_RUN:
    ldr r2, (ADR+32)
    mov pc, r2
HAS_KNOCK_BACK:
    ldr r2, (ADR+36)
    mov pc, r2
SET_COMBAT_ART:
    ldr r2, (ADR+40)
    mov pc, r2
HAS_RAGING_STORM:
    ldr r2, (ADR+44)
    mov pc, r2
IS_TEMP_SKILL_FLAG:
    ldr r2, (ADR+48)
    mov pc, r2
TURN_ON_TEMP_SKILL_FLAG:
    ldr r2, (ADR+52)
    mov pc, r2
HasMamorite:
    ldr r2, (ADR+56)
    mov pc, r2

.align
.ltorg
ADR:

