.thumb
@ 0802ad3c
@イクリプス等の直前(自分の数値と相手の数値の計算後)
@ステータス画面では呼ばれない
@相手の数値に影響を与える処理群


    push {r4, r5, r6, lr}
    mov r4, r0
    mov r6, r1

    mov	r0, r6
        ldr r1, NIHIL_ADR
        mov lr, r1
        .short 0xF800
    cmp r0, #1
    beq next

    bl Lull
    bl Shisen_B
    
next:
    bl WarSkill
    bl EffectiveBonus
    bl godBless
    bl ChagingLance

Return:
    ldr r5, [r4, #76]
    ldr r0, =0x0802ad44
    mov r15, r0
endZero:
    mov r0, #0
    mov r1, r4
    add r1, #90
    strh r0, [r1] @威力
    
    mov r0, #0x7F
    mov r1, r6
    add r1, #92
    strh r0, [r1] @防御
    pop {r4, r5, r6}
    pop {r0}
    bx r0


FLY_E2_ID = (0x2D)      @てつのゆみ
ARMOR_E2_ID = (0x26)    @ハンマー
HORSE_E2_ID = (0x1B)    @ホースキラー
MONSTER_E2_ID = (0xAA)  @竜石

EffectiveBonus:
        push {lr}
        
        mov r1, r4
        add r1, #72
        ldrh r0, [r1]
        cmp r0, #0
        beq endEffective    @武器がない
        mov r1, r6
        bl $08016994    @特効判定
        cmp r0, #1
        beq endEffective    @特効あり
        
        mov r0, r4
        mov r1, r6
        bl $08016a30 @魔物特効
        cmp r0, #1
        beq endEffective    @魔物特効あり
    @Grounder
        mov r0, #FLY_E2_ID
        ldr r1, FLY_E_ADR
    
        bl effective_impl
        cmp r0, #1
        beq getEffective
    @HelmSplitter
        mov r0, #ARMOR_E2_ID
        ldr r1, ARMOR_E_ADR
    
        bl effective_impl
        cmp r0, #1
        beq getEffective
    @@@@@
        mov r0, #HORSE_E2_ID
        ldr r1, HORSE_E_ADR
        bl effective_impl
        cmp r0, #1
        beq getEffective
    @@@@@
        mov r0, #MONSTER_E2_ID
        ldr r1, MONSTER_E_ADR
        bl effective_impl
        cmp r0, #1
        beq getEffective
    @無惨
        mov r0, r4
        mov r1, #0
        bl HasAtrocity
        cmp r0, #1
        beq getEffective
    
        b endEffective
    getEffective:
        mov r1, r4
        add r1, #72
        ldrh r0, [r1]
        bl $08017384
        mov	r1, r4
        add	r1, #84
        ldrb	r1, [r1, #0]	@武器相性
        lsl	r1, r1, #24
        asr	r1, r1, #24
        add	r1, r1, r0
        mov	r2, r4
        add	r2, #90
        ldrh	r0, [r2]
        add r0, r0, r1
        strh	r0, [r2]
        
    endEffective:
        pop {pc}

effective_impl:
    @r0に特効リストを利用する武器のID
    @r1にとび先
        push {r4, r5, r6, lr}
        mov r5, r6
    
        eor r4, r0
        eor r0, r4
        eor r4, r0
            mov lr, r1
            .short 0xF800
        cmp r0, #0
        beq falseEffective_impl
        mov r0, r4
        bl $08017478
    @r4に装備武器
    @r5に相手アドレス
    @r6に特効リスト
        mov r6, r0
        mov r3, r4
        mov r1, r6
        mov r4, r5
        ldr r2, [r4, #4]
        ldrb r2, [r2, #4]	@r2に相手兵種ID
        ldr r5, =0x080161B8
        ldr r5, [r5]	@r5にアイテムリスト先頭アドレス
        ldr r0, =0x080169c8
        mov pc, r0
    falseEffective_impl:
        mov r0, #0
        pop	{r4, r5, r6}
        pop	{r1}
        bx	r1

$08016994:
    ldr r2, =0x08016994
    mov pc, r2
$08016a30:
    ldr r2, =0x08016a30 @魔物特効
    mov pc, r2
$08017384:
    ldr r1, =0x08017384
    mov pc, r1

$08017478:
    ldr r1, =0x08017478
    mov pc, r1

STR_ADR = (67)	@書き込み先(AI1カウンタ)

WarSkill:
        push {lr}

        ldrb r0, [r4, #11]
        mov r2, #0xC0
        and r2, r0
        bne endWar @自軍以外は終了

        bl GetAttackerAddr
        ldr r2, [r0]
        ldrb r2, [r2, #11]
        ldrb r0, [r4, #11]
        cmp r0, r2
        bne endWar

        mov r0, #STR_ADR
        ldrb r0, [r4, r0]
        bl GetWarList
        cmp r0, #0
        beq endWar
        mov r3, r0
    
        mov r1, #90
        ldrh r0, [r4, r1]
        mov r2, #0
        ldsb r2, [r3, r2]
        add r0, r2
        cmp r0, #0
        bge jumpWar1
        mov r0, #0
    jumpWar1:
        strh r0, [r4, r1] @力
    
    endWar:
        pop {pc}

GetAttackerAddr:
    ldr r0, =0x03004df0
    bx lr

Lull:
        push {lr}
        ldr r0, =0x0203a4d0
        ldrh r0, [r0]
        mov r1, #0x20
        and r0, r1
        bne endLull
        mov r0, r4
        mov r1, #0
        bl HasLull
        cmp r0, #0
        beq endLull
        mov r0, r6
        mov r1, r4
        bl recalcAtk
        mov r0, r6
        mov r1, r4
        bl recalcSpd
        
        mov r1, r6
        add r1, #90
        ldrh r0, [r1]
        sub r0, #2
        bge jumpAtk
        mov r0, #0
    jumpAtk:
        strh r0, [r1] @威力
        
        mov r1, r6
        add r1, #94
        ldrh r0, [r1]
        sub r0, #2
        bge jumpSpd
        mov r0, #0
    jumpSpd:
        strh r0, [r1] @速さ

    endLull:
        pop {pc}


Shisen_B:	@相手強化
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasShisen
        cmp r0, #0
        beq endShisen
        
        mov r1, r6
        add r1, #90
        ldrh r0, [r1]
        add r0, #5
        strh r0, [r1] @相手
    endShisen:
        pop {pc}

godBless:
    push {lr}
    mov r0, r4
        ldr r1, adr+4 @光の加護
        mov lr, r1
        .short 0xF800
    cmp r0, #0
    bne endBless
    
    mov r0, r6
        ldr r1, adr+8 @暗黒の加護
    	mov lr, r1
    	.short 0xF800
    cmp r0, #0
    beq endBless

    mov r1, #90
    ldrh r0, [r4, r1] @威力
    asr r0, r0, #1
    strh r0, [r4, r1] @威力

    mov r0, #1
    .short 0xE000
endBless:
    mov r0, #0
    pop {pc}

ChagingLance:
        push {r5, lr}
        bl GetDistance
        ldrb r0, [r0]
        cmp r0, #1
        bgt endCharge       @遠距離は無効
        mov r0, r4
        mov r1, #0
        bl HAS_CHARGING_LANCE
        cmp r0, #0
        beq endCharge
        
        mov r0, r4
        bl GetWalked
        cmp r0, #8
        ble jumpCharge
        mov r0, #8
    jumpCharge:
        mov r5, r0
        bl GET_CHARGING_COEF
        mul r0, r5
        mov r1, #90
        ldrh r2, [r4, r1]
        add r2, r0
        strh r2, [r4, r1] @自分
    endCharge:
        pop {r5, pc}

GetWalked:
        mov r1, r0
        ldr r2, =0x0202be44
        ldrb r0, [r1, #16]
        ldrb r3, [r2, #0]
        sub r0, r0, r3
        bge jump1Walked
        neg r0, r0  @絶対値取得
    jump1Walked:

        ldrb r1, [r1, #17]
        ldrb r2, [r2, #2]
        sub r2, r1, r2
        bge jump2Walked
        neg r2, r2  @絶対値取得
    jump2Walked:
        add r0, r0, r2
        bx lr
GetDistance:
    ldr r0, =0x0203a4d2
    bx lr

SHISEN_ADR = (adr+0)
NIHIL_ADR = (adr+12)
LULL_ADR = (adr+16)
COMBAT_TBL = (adr+20)
COMBAT_TBL_SIZE = (adr+24)
FLY_E_ADR = (adr+28)
ARMOR_E_ADR = (adr+32)
HORSE_E_ADR = (adr+36)
MONSTER_E_ADR = (adr+40)
HAS_ATROCITY_ADR = (adr+44)


HasAtrocity:
    ldr r2, HAS_ATROCITY_ADR
    mov pc, r2

GetWarList:
    ldr r1, COMBAT_TBL_SIZE
    mul r0, r1
    ldr r1, COMBAT_TBL
    add r0, r1
    bx lr

HasShisen:
    ldr r2, SHISEN_ADR
    mov pc, r2

recalcAtk:
    ldr r2, =0x0802aa28
    mov pc, r2
recalcSpd:
    ldr r2, =0x0802aae4
    mov pc, r2

HasLull:
    ldr r2, LULL_ADR
    mov pc, r2

HAS_CHARGING_LANCE:
    ldr r2, (adr+48)
    mov pc, r2
GET_CHARGING_COEF:
    ldr r0, (adr+52)
    bx lr


.ltorg
.align
adr:

