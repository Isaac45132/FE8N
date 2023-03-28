.thumb

@org	0802b004
    push {r4, lr}
    mov r4, #0

	bl HasCharge
	cmp r2, #1
	beq endBrave	@突撃発動時は連続攻撃不可

    ldr r0, [r0, #76]
    mov r1, #32
    and r0, r1
    cmp r0, #0
    bne Brave @x勇者武器持ってるなら

    bl Addition
    cmp r0, #0
    beq endBrave
Brave:
    ldr r0, =0x0203a604
    ldr r3, [r0, #0]
    ldr r2, [r3, #0]
    lsl r1, r2, #13
    lsr r1, r1, #13
    mov r0, #16
    orr r1, r0
    ldr r0, =0xFFF80000
    and r0, r2
    orr r0, r1
    str r0, [r3, #0]
    mov r4, #1				@攻撃回数加算

endBrave:
    mov r0, r4
    pop {r4}
    pop {pc}

Addition:
    mov r0, r6
    mov r1, r8
    mov r2, #0  @獅子連判定用
    ldr r3, ADDRESS
    mov pc, r3

HasCharge:
        push {r0, r4, lr}
        mov r4, r0
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
            ldr r2, ADDRESS+4 @突撃
            mov lr, r2
            .short 0xF800
        cmp r0, #0
        beq notCharge
        mov r2, #1
        b endCharge
    notCharge:
        mov r2, #0
    endCharge:
        pop {r0, r4, pc}


.align
.ltorg
ADDRESS:

