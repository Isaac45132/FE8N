.thumb
RETURN_ADDR  = (0x0808e80e)
RETURN_ADDR2 = (0x0808e814) @何もしない

@0808e79c
    mov r0, #63     @0x3F
    and r0, r6
    cmp r0, #0
    bne dont_need

    bl SetNumber
@    bl Draw_Word
    bl DrawItem
    ldr r0, =RETURN_ADDR
    mov pc, r0
dont_need:
    ldr r0, =RETURN_ADDR2
    mov pc, r0

SetNumber:
        push {lr}
        bl GetFirstNum
        bl NUMBER

        ldr r1, =0x02028e44
        .short 0x7988
        .short 0x3830
        .short 0x1c22
        .short 0x3251       @
        .short 0x7010
        .short 0x79c8
        .short 0x3830
        .short 0x1c21
        .short 0x3152       @
        .short 0x7008

@@@@@@@@
        bl GetSecondNum
        bl NUMBER
        ldr r1, =0x02028e44
        .short 0x7988
        .short 0x3830
        .short 0x1c22
        .short 0x3253       @
        .short 0x7010
        .short 0x79c8
        .short 0x3830
        .short 0x1c21
        .short 0x3154       @
        .short 0x7008
        pop {pc}

GetFirstNum:
        push {lr}
        mov r0, r5
        bl $00018e64
        pop {pc}
GetSecondNum:
        push {lr}
        mov r0, r5
        bl $00018ea4
        pop {pc}

Draw_Word:
        ldr r1, [r4, #64]
        mov r2, #0
        ldr r3, =0x2120
        strh    r3, [r1, #0]
        add r3, #1
        strh    r3, [r1, #2]
        strh    r2, [r1, #4]
        strh    r2, [r1, #6]
        add     r3, #29
        strh    r3, [r1, #8]
        strh    r2, [r1, #10]
        strh    r2, [r1, #12]

    endWord:
        bx lr

DrawItem:
        push {r4, lr}
        ldr r4, [r4, #64]
        sub r4, #2
        ldr r0, =0x210D
        strh    r0, [r4]
        add r4, #2
        add r0, #1
        strh    r0, [r4]
        add r4, #2

        add r0, #1
        strh    r0, [r4]
        add r4, #2
        
        ldrh r0, [r5, #30]
        bl DrawItemIn
        ldrh r0, [r5, #32]
        bl DrawItemIn
        ldrh r0, [r5, #34]
        bl DrawItemIn
        ldrh r0, [r5, #36]
        bl DrawItemIn
        ldrh r0, [r5, #38]
        bl DrawItemIn
        pop {r4, pc}

DrawItemIn:
        push {lr}
        mov r1, #0
        mov r2, #0

        cmp r0, #0
        beq endItem
        bl $000172f0
        mov r1, r0
        ldr r2, =0x2104     @アイテム
        cmp r1, #8
        blt endItem
        mov r1, #8
    endItem:
        add r2, r1
        strh    r2, [r4]
        add r4, #2
        pop {pc}
$000172f0:
    ldr r1, =0x080172f0
    mov pc, r1

NUMBER:
    ldr r1, =0x08003868
    mov pc, r1
$080168d0:
    ldr r1, =0x080168d0
    mov pc, r1
$00018e64:
    ldr r1, =0x08018e64
    mov pc, r1
$00018ea4:
    ldr r1, =0x08018ea4
    mov pc, r1

GET_EX_NUM_MEM_TO_R3:
    ldr r3, ADDR
    bx lr
GET_FLASH_CONFIG:
    ldr r0, ADDR+4
    bx lr

.align
.ltorg
ADDR:
