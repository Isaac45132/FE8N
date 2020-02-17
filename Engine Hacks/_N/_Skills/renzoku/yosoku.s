.thumb
    push {r2, r3}

    ldr r0, [r4, #76]
    mov r1, #32
    and r0, r1
    cmp r0, #0
    bne got
    bl adept
    cmp r0, #0
    beq non
    
got:
    ldr r0, =0x0803678e @continue
    .short 0xE000
non:
    ldr r0, =0x0803679a @end
    pop {r2, r3}
    mov pc, r0

adept:
        mov r0, r4
        ldr r1, =0x0203a568
        ldr r2, addr
        mov pc, r2

.align
.ltorg
addr:

