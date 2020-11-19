.thumb
RETURN_ADDR  = (0x0808e80e)
RETURN_ADDR2 = (0x0808e814) @何もしない

@0808e79c
    mov r0, #63     @0x3F
    and r0, r6
    cmp r0, #0
    bne dont_need

    bl Draw_Word
    ldr r0, =RETURN_ADDR
    mov pc, r0
dont_need:
    ldr r0, =RETURN_ADDR2
    mov pc, r0



Draw_Word:
        ldr r1, [r4, #64]
        mov r2, #0
        ldr r3, =0x216B
        strh    r3, [r1, #0]
        add r3, #1
        strh    r3, [r1, #2]
        add r3, #1
        strh    r3, [r1, #4]
        add r3, #1
        strh    r3, [r1, #6]
        strh    r2, [r1, #8]
        ldr r3, =0x2163
        strh    r3, [r1, #10]
        add r3, #1
        strh    r3, [r1, #12]

    endWord:
        bx lr



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
