ATK = (0x0203a4e8)
DEF = (0x0203a568)

TARGET_UNIT = (0x03004df0)
WEAPON_SP_ADDR = (0x080172f0)

DEFEAT   = (0b10000000) @撃破フラグ
DEFEATED = (0b01000000) @迅雷済みフラグ
STORM    = (0b00100000) @狂嵐フラグ

DEFEAT2 = (0xC0)

@0801cea8
.thumb
    push {r4, r5, lr}
    mov r5, r0
    ldr r4, =TARGET_UNIT
    ldr r4, [r4]
@    ldr r4, =ATK
    
    mov r0, r4
    ldrb	r1, [r0, #0x13]
    cmp r1, #0
    beq FALSE   @自分のHPゼロなら何もせずに終了
    
    mov r0, r4
    ldrb r1, [r0, #11]
    mov r2, #192
    and r2, r1
    bne FALSE @自軍以外は終了
    ldr r0, [r4, #12]
    ldr r1, =0x80000000
    tst r0, r1
    bne clearFALSE          @再移動済み

    bl JudgeAhead
    cmp r0, #0
    .short 0xD000
    b CantoHurry             @全力移動

    ldr r0, =0x0203a954
    ldrb r0, [r0, #17]
    cmp r0, #1
    beq StanceSkill         @待機選択なら終了



    ldr r0, [r4, #12]
    ldr r1, =0x0801cf04
    ldr r1, [r1]
    and r0, r1
    cmp r0, #0
    bne FALSE               @死亡・待機(or再行動済)・??状態

    ldr r0, =0x0203a954
    ldrb r0, [r0, #17]
    cmp r0, #17
    beq clearFALSE          @制圧選択なら終了

    mov r0, r4
    ldr r1, =DEF
    bl kaifuku

    mov r0, r4
    ldr r1, =DEF
    bl RagingStorm
    cmp r0, #1
    beq Sound
@疾風迅雷・神風招来判定
    mov r0, r4
    add r0, #69
    ldrb r1, [r0]

    mov r2, #DEFEATED
    and r2, r1
    bne next    @再行動済み

    mov r2, #DEFEAT
    and r2, r1
    bne pattern1
    b pattern2

StanceSkill:
    bl AlertStance
    bl DefensiveStance
    bl Catnap

clearFALSE:
    bl clear_defeat
FALSE:
    ldr r4, =TARGET_UNIT
    ldr r3, =0x0801cefc
    mov pc, r3


pattern1:
@再行動なし撃破
@
    bl shippuJinrai
    cmp r0, #0
    beq next
@一回目撃破(再行動済みフラグ)をオン
    mov r0, #69
    ldrb r1, [r4, r0]

    mov r2, #DEFEATED
    orr r1, r2

    strb r1, [r4, r0] @撃破済み
    
    b Sound	@再行動

pattern2:
@再行動なし未撃破
@
    ldr r0, =DEF
    ldr r1, [r0, #4]
    cmp r1, #0      @相手がいない
    beq next        @
    
    bl jinpuShourai	@神風招来
    cmp r0, #0
    beq next
@一回目撃破(再行動済みフラグ)をオン
    mov r0, #69
    ldrb r1, [r4, r0]

    mov r2, #DEFEATED
    orr r1, r2

    strb r1, [r4, r0] @撃破済み
    
    b Sound	@再行動
nop
nop

next:
    bl clear_defeat
@スキル再移動による再移動化
    bl JudgeCanto
    cmp r0, #0
    beq FALSE
    b Canto

CantoHurry:
    ldr r0, [r4, #12]
    ldr r1, =0x40000000
    orr r0, r1
    str r0, [r4, #12]

    ldrb r0, [r4, #29]
    add r0, #2
    strb r0, [r4, #29]
Canto:
    ldr r0, [r4, #12]
    ldr r1, =0x80000000
    orr r0, r1
    str r0, [r4, #12]

    ldr r4, =TARGET_UNIT
    ldr r3, =0x0801cece
    mov pc, r3

Sound:	
    bl clear_defeat
@再行動
    ldr	r0, =0x0202bcec
    add	r0, #65
    ldrb	r0, [r0, #0]
    lsl	r0, r0, #30
    bmi	end
    mov	r0, #97
    ldr	r2, =0x080d4ef4
    mov	lr, r2
    .short 0xf800
end:
    mov r0, #0
    pop {r4, r5}
    pop {r1}
    bx r1


clear_defeat:
        ldr r0, [r4, #12]
        ldr r1, =0x80000000
        bic r0, r1
        str r0, [r4, #12]
@@@@
        ldr r0, [r4, #12]
        ldr r1, =0x40000000
        tst r0, r1
        beq jumpClear
        bic r0, r1
        str r0, [r4, #12]
        ldrb r0, [r4, #29]
        sub r0, #2
        strb r0, [r4, #29]
    jumpClear:
@@@@
        mov r1, r4
        add r1, #69
        ldrb r0, [r1]

        mov r2, #DEFEAT
        bic r0, r2

@再行動済みは消さない

        mov r2, #STORM
        bic r0, r2

        strb r0, [r1]
        bx lr

    
@狂嵐
@
RagingStorm:
        push {r4, lr}
        mov r4, r0

        mov r0, #69
        ldrb r1, [r4, r0]
    
        mov r2, #STORM
        and r1, r2
        beq falseStorm

        mov	r0, r4
        ldr	r1, [r0, #12]	@行動済み等の状態
        ldr	r2, =0xfffffbbd
        and	r1, r2
        str	r1, [r0, #12]
        
        mov	r0, #1
        .short 0xE000
    falseStorm:
        mov	r0, #0
        pop	{r4, pc}

@疾風迅雷
@
shippuJinrai:
        push {lr}
        mov r0, r4
            ldr r2, hasGaleforce
            mov lr, r2
            .short 0xF800
        cmp r0, #0
        beq falseJinrai
        mov	r0, r4
        ldr	r1, [r0, #12]	@行動済み等の状態
        ldr	r2, =0xfffffbbd
        and	r1, r2
        str	r1, [r0, #12]
        
        mov	r0, #1
        .short 0xE000
    falseJinrai:
        mov	r0, #0
        pop	{pc}

@神風招来
@
jinpuShourai:
        push {lr}
        mov	r0, r4
            ldr r2, hasGaleCause
            mov lr, r2
            .short 0xF800
        cmp r0, #0
        beq falseShourai
        
        mov r0, r4
        ldr r1, =ATK
        ldrb r0, [r0, #0xB]
        ldrb r2, [r1, #0xB]
        cmp r0, r2
        bne falseShourai
        add r1, #0x48
        ldrh r0, [r1]
            ldr r2, =WEAPON_SP_ADDR
            mov lr, r2
            .short 0xF800
        cmp r0, #4		@杖
        bne falseShourai

        mov	r0, r4
        ldr	r1, [r0, #12]	@行動済み等の状態
        ldr	r2, =0xfffffbbd
        and	r1, r2
        str	r1, [r0, #12]
        
        mov	r0, #1
        .short 0xE000
    falseShourai:
        mov	r0, #0
        pop	{pc}

@生命吸収
kaifuku:
        push {lr}
        mov r0, r4
            ldr r2, addr+8
            mov lr, r2
            .short 0xF800
        cmp r0, #0
        beq non_hp

        mov r0, r4
        add r0, #69
        ldrb r1, [r0]
        mov r2, #DEFEAT
        and r1, r2
        beq non_hp  @撃破フラグがオフ

        mov	r2, r4
        ldrb r0, [r2, #19] @現在19
        ldrb r1, [r2, #18] @最大18
        asr r1, r1, #1
        add r0, r0, r1

        ldrb r1, [r2, #18] @最大18
        cmp r0, r1
        ble jump_hp
        mov r0, r1
    jump_hp:
        strb r0, [r2, #19] @現在19

        mov r0, #0x89
        mov r1, #0xB8
            ldr r2, =0x08014B50 @音
            mov lr, r2
            .short 0xF800
        mov	r0, #1
        .short 0xE000
    non_hp:
        mov	r0, #0
        pop	{pc}

JudgeAhead:
        push {lr}
        ldr r1, =0x0203a954
        ldrb r0, [r1, #17]
        cmp r0, #1
        bne falseAhead      @待機じゃない
        ldrb r0, [r1, #16]
        cmp r0, #0
        bne falseAhead      @移動済み

        mov	r0, r4
        mov r1, #0
        bl HAS_FULL_SPEED_AHEAD
        .short 0xE000

    falseAhead:
        mov r0, #0
        pop {pc}

JudgeCanto:
        push {lr}
        ldr r0, [r4, #0]
        ldr r1, [r4, #4]
        ldr r0, [r0, #40]
        ldr r1, [r1, #40]
        orr r0, r1
        mov r1, #2
        tst r0, r1
        bne trueCanto

        mov r0, r4
        mov r1, #0
            ldr r2, addr+12 @再移動
            mov lr, r2
            .short 0xF800
        .short 0xE000
    trueCanto:
        mov r0, #1
        pop {pc}

AlertStance:
        push {lr}
        mov r0, #48
        ldrb r0, [r4, r0]
        cmp r0, #0
        bne endAlertStance

        mov	r0, r4
        mov r1, #0
        bl HAS_ALERT_STANCE
        cmp r0, #0
        beq endAlertStance

        mov r1, #0x18
        mov r0, #48
        strb r1, [r4, r0]

    endAlertStance:
        pop {pc}

DefensiveStance:
        push {lr}
        mov r0, #48
        ldrb r0, [r4, r0]
        cmp r0, #0
        bne endDefensiveStance

        mov	r0, r4
        mov r1, #0
        bl HAS_DEFENSIVE_STANCE
        cmp r0, #0
        beq endDefensiveStance

        mov r1, #0x16
        mov r0, #48
        strb r1, [r4, r0]

    endDefensiveStance:
        pop {pc}

Catnap:
        push {lr}

        mov	r0, r4
        mov r1, #0
        bl HAS_CATNAP
        cmp r0, #0
        beq endCatnap

        ldrb r0, [r4, #19]
        ldrb r1, [r4, #18]
        add r0, #5
        cmp r0, r1
        blt jumpCatnap
        mov r0, r1
    jumpCatnap:
        strb r0, [r4, #19]

        mov r0, #0x89
        mov r1, #0xB8
            ldr r2, =0x08014B50 @音
            mov lr, r2
            .short 0xF800

    endCatnap:
        pop {pc}

HAS_FULL_SPEED_AHEAD:
    ldr r2, addr+0
    mov pc, r2
hasGaleforce = (addr+4)
hasLifetaker = (addr+8)
hasCantoPlus = (addr+12)
hasGaleCause = (addr+16)
HAS_ALERT_STANCE:
    ldr r2, addr+20
    mov pc, r2
HAS_DEFENSIVE_STANCE:
    ldr r2, addr+24
    mov pc, r2
HAS_CATNAP:
    ldr r2, addr+28
    mov pc, r2


.align
.ltorg
addr:
