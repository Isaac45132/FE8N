@ 08036784

.thumb
    push {r2, r3}

	bl HasCharge
	cmp r0, #1
	beq end		@突撃発動時は連続攻撃不可

    ldr r0, [r4, #76]
    mov r1, #32
    and r0, r1
    cmp r0, #0
    bne got
    bl adept
    cmp r0, #1
    beq got
end:
    ldr r0, =0x0803679a @end
    .short 0xE000
got:
    ldr r0, =0x0803678e @continue
    pop {r2, r3}
    mov pc, r0

adept:
        mov r0, r4
        ldr r1, =0x0203a568
        cmp r0, r1
        bne jump
        ldr r1, =0x0203a4e8
    jump:
        mov r2, #1  @獅子連判定用
        ldr r3, addr
        mov pc, r3

HasCharge:
        push {r2, lr}
	ldr r1, =0x0203a4e8
	cmp r1, r4
	bne mikataC
	ldr r1, =0x0203a568
mikataC:
        mov r2, #94
        ldsh r0, [r4, r2]
        ldsh r2, [r1, r2]
        cmp r0, r2
        ble notCharge @速さが足りない！
        ldrb r0, [r4, #0x13]
        ldrb r2, [r1, #0x13]
        cmp r0, r2
        ble notCharge @HPが足りない！
    
        mov r0, r4
            ldr r2, addr+4 @突撃
            mov lr, r2
            .short 0xF800
        cmp r0, #0
        beq notCharge
        mov r0, #1
        b endCharge
    notCharge:
        mov r0, #0
    endCharge:
        pop {r2, pc}

.align
.ltorg
addr:

