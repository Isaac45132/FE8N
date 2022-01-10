@thumb
    push {lr}
      push {r0}
;ハード補正
	ldr r1, =$0202BCEC
	ldrb r1, [r1, #0x14]
	mov r0, #0x40
	and r0, r1
	cmp r0, #0
	beq end
	push {r3}
	mov r0, r6	;経験値
	mov r1, #7
	mul r0 ,r1
	mov r1, #10
	swi #6		;7割
	mov r6, r0
	pop {r3}
end
;
        @align 4
	pop {r0}
	push {r0}
        ldr r1, [adr] ;
        mov lr, r1
        @dcw $F800
        mov r1, r0
      pop {r0}
    cmp r1, #0
    bne elite
    ldr r1, [r0]
    ldr r2, [r0, #4]
    ldr r0, [r1, #40]
    ldr r1, [r2, #40]
    ldr r3, =$0802C35E
    mov pc, r3
elite
    ldr r3, =$0802C36C
    mov pc, r3
@ltorg
adr: