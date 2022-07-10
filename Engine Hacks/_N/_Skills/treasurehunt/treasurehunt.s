.thumb
@org	0x08032878

ldr r0, [r7, #0xC]
mov r1, #0x80
lsl r1, r1, #0x5
and r0, r1
cmp r0, #0x0
bne flase

        mov r0, r5	@r5=unitID
        mov r1, #0
        bl HasTreasureHunt
        cmp r0, #0
        beq falseTreasureHunt

        ldr r0, [r7, #0]
        ldr r1, [r7, #4]
        ldr r0, [r0, #40]
        ldr r1, [r1, #40]
        orr r0, r1
        lsr r0, r0, #24
        mov r1, #1
        and r0, r1
	cmp r0, #1
	beq falseTreasureHunt

    	ldrb r0, adr+8 @@発動率
    	mov r1, #0
        push {r2, r3}
        ldr r3, =0x0802a490 @r0=確率, r1=#0 乱数
        mov lr, r3
        .short  0xF800
        pop {r2, r3}
    	cmp r0, #1
    	bne falseTreasureHunt
    
ldr r0, adr+4		@0176赤の宝玉
ldr r1, =0x0803289C
mov pc, r1

falseTreasureHunt:
ldr r1, =0x080328B4
mov pc, r1

flase:
ldr r1, =0x08032884
mov pc, r1

HAS_TREASURE_FUNC = (adr+0)

HasTreasureHunt:
    ldr r2, HAS_TREASURE_FUNC
    mov pc, r2
.align
.ltorg
adr:
