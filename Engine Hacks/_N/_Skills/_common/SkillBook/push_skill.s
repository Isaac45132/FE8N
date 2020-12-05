

.thumb
pushSkill:
@I  r0 = ベースアドレス
@   r1 = BookData
@O  -
@
    push {r4, r5, r6, lr}
    mov r4, r0
    mov r6, r1
    bl pushSkill_impl
    pop {r4, r5, r6, pc}


pushSkill_impl:
@▼本処理
    push {lr}
    mov r5, #0
loop:
    ldr r3, MAX_MANUAL_SKILL_NUM
    cmp r5, r3
    bge END_impl

    mov r0, r4
    mov r1, r5
    bl GET_BOOK
    cmp r0, #0
    beq loop_end
    add r5, #1
    b loop
loop_end:
    mov r2, #0b00111111
    and r2, r6

    mov r0, r4
    mov r1, r5
    bl SET_BOOK
END_impl:
    pop {pc}

GET_BOOK:
    ldr r3, addr+0
    mov pc, r3

SET_BOOK:
    ldr r3, addr+4
    mov pc, r3

MAX_MANUAL_SKILL_NUM = addr+8

.align
.ltorg
addr:

