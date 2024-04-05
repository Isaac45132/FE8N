.thumb
@org	0x08032878

cmp r7, #0		@敵未撃破なら
beq migekiha

@敵撃破時
ldr r0, [r7, #0xC]
mov r1, #0x80
lsl r1, r1, #0x5	@アイテムドロップフラグ
and r0, r1
cmp r0, #0x0
bne flase

bl WeaponB
cmp r0, #0
beq TreasureHunt
b NewDrop

TreasureHunt:
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
	b NewDrop

@敵未撃破時
migekiha:
bl WeaponB
cmp r0, #0
beq falseTreasureHunt

NewDrop:
ldr r1, =0x0803289C
mov pc, r1

falseTreasureHunt:
ldr r1, =0x080328B4
mov pc, r1

flase:
ldr r1, =0x08032884
mov pc, r1

WeaponB:
	push {r4, lr}
	cmp r7, #0
	beq tekikara
	ldr r0, [r7]		@倒された側
	ldr r1, [r4]		@攻撃された側
	cmp r0, r1
	beq tekikara
	mov r4, r6

   tekikara:
	mov r0, #0x38
        ldrb r0, [r4, r0]
	cmp r0, #1		@ウエポンブレイカーフラグ
	beq tekisyouFlag

	mov r0, #0x38
        ldrb r0, [r6, r0]
	cmp r0, #1		@自分ウエポンブレイカーフラグ
	bne falseWeaponB
	ldrb r0, [r4, #0xB]
	bl Get_Status
	mov r5, r0
	mov r4, r6

   tekisyouFlag:
        ldrb r0, [r4, #0xB]
	cmp r0, #0x80
	ble falseWeaponB

        ldr r0, [r4, #0]
        ldr r0, [r0, #40]
        lsr r0, r0, #15		@敵将には無効
        mov r1, #1
        and r0, r1
	cmp r0, #1
	beq falseWeaponB

	mov r0, #0x4C
	ldrb r0, [r4, r0]
	mov r1, #0x18		@耐久無限または売却不可武器には無効
	and r0, r1
	cmp r0, #0
	bne falseWeaponB
	
	add r4, #0x4A
@	mov r1, #0
	ldrh r0, [r4]
@	sub r4, #2
@	strh r1, [r4]
	.short 0xE000
   falseWeaponB:
	mov r0, #0
	pop {r4, pc}


Get_Status:
    ldr r1, =0x08019108
    mov pc, r1

HAS_TREASURE_FUNC = (adr+0)

HasTreasureHunt:
    ldr r2, HAS_TREASURE_FUNC
    mov pc, r2
.align
.ltorg
adr:
