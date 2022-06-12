.thumb

VALID_BIT =         0b0011

        ldr r0, =0x02003bfc
        ldr r0, [r0, #12]
        add r0, #71
        ldrb r0, [r0]
        mov r1, #VALID_BIT
        and r0, r1

@@@変更ここから
        cmp r0, #3
	beq fatigue3
	cmp r0, #2
	beq fatigue2
	cmp r0, #1
	beq fatigue1
        b fresh
fatigue3:
        ldr r0, addr+8
        b return
fatigue2:
        ldr r0, addr+4
        b return
fatigue1:
        ldr r0, addr
        b return
@@@ここまで

    fresh:
        ldr r0, =0x0808ad20
        ldr r0, [r0]
    return:
        mov r1, r2
        add r1, #76
        ldr r3, =0x0808ad88
        mov pc, r3
.align
.ltorg
addr:
