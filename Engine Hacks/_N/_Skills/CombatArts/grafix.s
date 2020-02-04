ICON_POS = (0x0202F86)
@ 0801e684
.thumb

    ldr r0, [sp, #0x1C]
    ldr r1, =0x08022D5B
    cmp r0, r1
    bne END
        bl arrow_reset_func
        bl GatherSkill
        cmp r0, #0
        bne start
        mov r0, #0x0
        mov r1, #0
        mov	r2, #0x60
        bl	WrapIcon
        b clear
    start:
        ldr r1, ADDR+4
        mov r0, #1
        strb r0, [r1]
        
        mov r0, #0x0
        mov r1, #2
        neg r1, r1
        mov	r2, #0x60
        bl	WrapIcon
    clear:
        mov r0, #4
        ldr r1, ADDR
        ldrb r1, [r1, #0]
        bl GetColor	@need ID in r1
        bl WrapIcon

        mov r0, #8
        ldr r1, ADDR
        ldrb r1, [r1, #1]
        bl GetColor	@need ID in r1
        bl WrapIcon

        mov r0, #12
        ldr r1, ADDR
        ldrb r1, [r1, #2]
        bl GetColor	@need ID in r1
        bl WrapIcon

        mov r0, #16
        ldr r1, ADDR
        ldrb r1, [r1, #3]
        bl GetColor	@need ID in r1
        bl WrapIcon

        mov r0, #20
        ldr r1, ADDR
        ldrb r1, [r1, #4]
        bl GetColor	@need ID in r1
        bl WrapIcon
        
        mov r0, #24
        ldr r1, ADDR
        ldrb r1, [r1, #5]
        bl GetColor	@need ID in r1
        bl WrapIcon
END:
    pop	{r3, r4, r5}
    mov	r8, r3
    mov	r9, r4
    mov	sl, r5
    pop	{r4, r5, r6, r7}
    pop	{r0}
    bx	r0

SKL_TBL = (ADDR+8)
SKL_TBL_SIZE = (ADDR+12)

GatherSkill:
        push {r4, r5, r6, r7, lr}
        mov r4, r8
        ldr r5, ADDR
        bl JudgeCapture
        cmp r0, #0
        beq endGather

        bl GatherListWeapon	
        bl GatherUnit	@Book and Unitdata
        bl GatherListUC	@Ignore Weapon and Item
    endGather:
        ldr r0, ADDR
        ldrb r0, [r0]
        pop {r4, r5, r6, r7, pc}

GatherUnit:
        push {lr}
        bl BookFunc
        bl UnitDataFunc
        pop {pc}

BookFunc:
        push {lr}
        mov r7, #0
    loopBook:
        cmp r7, #6
        bge endBook
        mov r0, r4
        mov r1, r7
        bl GetBookSkill
        cmp r0, #0
        beq endBook
        bl SetSkill

        add r7, #1
        b loopBook
    endBook:
        pop {pc}

UnitDataFunc:
        push {lr}

        ldr r0, [r4]
        add r0, #0x26
        ldrb r0, [r0]
        cmp r0, #0
        .short 0xD001
        bl SetSkill

    @上級スキルチェック
        ldr r1, [r4, #4]
        ldr r1, [r1, #40]
        ldr r0, =0x100
        and r0, r1
        beq jumpUnit
        ldr r0, [r4]
        add r0, #0x27
        ldrb r0, [r0]
        cmp r0, #0
        .short 0xD001
        bl SetSkill
    jumpUnit:
        pop {pc}	

GatherListWeapon:
        push {lr}
        mov r0, #72
        ldrh r0, [r4, r0]
        lsl r0, r0, #24
        lsr r0, r0, #24
        mov r1, #12
        bl GatherListSkill
        pop {pc}
GatherListUC:
        push {lr}
        ldr r0, [r4]
        ldrb r0, [r0, #4]
        mov r1, #4
        bl GatherListSkill
        ldr r0, [r4, #4]
        ldrb r0, [r0, #4]
        mov r1, #8
        bl GatherListSkill
        pop {pc}


GatherListSkill:
@
@r0 = 検索キー
@r1 = リスト指定(4ユニット8兵種12武器)
@
        push {r4, lr}
        mov r4, r0
        ldr r6, SKL_TBL
        add r6, r1
        mov r7, #0

    loopListSkill:
        add r7, #1
        cmp r7, #255
        bgt endListSkill
        ldr r0, SKL_TBL_SIZE
        add r6, r0

        mov r1, r4
        ldr r2, [r6]
        bl Listfunc
        cmp r0, #0
        beq loopListSkill
        mov r0, r7
        bl SetSkill
        b loopListSkill
    endListSkill:
        pop {r4, pc}


JudgeCapture:
        ldr r0, [r4, #0xC]
        mov r1, #0x10
        and r0, r1
        beq trueCapture         @救出していない
        ldrb r0, [r4, #27]
        cmp r0, #0
        beq falseCapture        @誰も担いでいない
        b trueCapture
    trueCapture:
        mov r0, #1
        bx lr
    falseCapture:
        mov r0, #0
        bx lr

SetSkill:
        push {r6, lr}
        mov r6, r0
        bl DedupSkill
        cmp r0, #1
        beq endSet

        mov r0, r6
        bl JudgeCombatSkill
        cmp r0, #0
        beq endSet

        strb r6, [r5]
        add r5, #1
    endSet:
        pop {r6, pc}

DedupSkill:
        ldr r2, ADDR
    loopDedup:
        cmp r2, r5
        beq falseDedup      @末尾まで到達
        ldrb r1, [r2]
        cmp r0, r1
        beq trueDedup       @重複あり
        add r2, #1
        b loopDedup
    trueDedup:
        mov r0, #1
        bx lr
    falseDedup:
        mov r0, #0
        bx lr

COMBAT_TBL = (ADDR+20)
COMBAT_TBL_SIZE = (ADDR+24)

JudgeCombatSkill:
        push {r6, lr}
        ldr r2, COMBAT_TBL
        ldr r0, COMBAT_TBL_SIZE
        mul r6, r0
        add r6, r2
        ldrb r2, [r6, #6]
        cmp r2, #0
        beq falseCombat

        bl JudgeRange
        cmp r0, #0
        beq falseCombat

        bl MatchWeaponType
        cmp r0, #0
        beq falseCombat

        mov r0, #1
        .short 0xE000
    falseCombat:
        mov r0, #0
        pop {r6, pc}

JudgeRange:
        push {lr}

        ldrb r0, [r6, #6]
        cmp r0, #2
        bne trueRange

        mov r0, r8
        add r0, #72
        ldrh r0, [r0]
        bl GetWeaponRange
        mov r1, #0b00001111
        and r0, r1
        cmp r0, #1
        beq trueRange
        mov r0, #0
        .short 0xE000
trueRange:
        mov r0, #1
        pop {pc}

MatchWeaponType:
        push {r6, lr}

        ldrb r6, [r6, #5]
        cmp r6, #0xFF
        beq trueType

        mov r0, r8
        add r0, #72
        ldrh r0, [r0]
        bl GetWeaponType
        cmp r0, r6
        beq trueType
        mov r0, #0
        .short 0xE000
trueType:
        mov r0, #1
        pop {r6, pc}

GetColor:
    ldr r2, SKL_TBL
    ldr r3, SKL_TBL_SIZE
    mul r3, r1
    add r3, r2
    ldrb r2, [r3, #2]
    mov r3, #1
    and r2, r3
    beq purpleColor
redColor:
    mov	r2, #0x80
    bx lr
purpleColor:
    mov	r2, #0x60
    bx lr

Listfunc:
@r2 = リスト先頭ポインタ
@r1 = 検索キー
    whileLoop:
        ldrb r0, [r2]
        cmp r0, #0
        beq endLoop
        cmp r0, r1
        beq trueLoop
        add r2, #1
        b whileLoop
    trueLoop:
        mov r0, #1
    endLoop:
        bx lr

arrow_reset_func:
    ldr r0, ADDR
    mov r1, #0
    str r1, [r0]
    str r1, [r0, #4]
    str r1, [r0, #8]
    str r1, [r0, #12]
    bx lr

GetBookSkill:
    ldr	r3, ADDR+16
    mov	pc, r3

WrapIcon:
    push {lr}

    add	r0, r4
    add r0, #0x20
    add r0, #0x80
    add r0, #0x80

    add r1, #0x80
    add r1, #0x80

    lsl r2, r2, #7
    bl Icon
    pop {pc}

GetWeaponType:
    ldr r3, =0x080172f0
    mov pc, r3

GetWeaponRange:
    ldr r3, =0x08017448     @武器の射程
    mov pc, r3

Icon:
    ldr r3, =0x08003608
    mov pc, r3
.align
.ltorg
ADDR:
