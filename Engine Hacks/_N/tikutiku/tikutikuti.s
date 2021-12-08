.thumb

@org	0x0802c138

mov	r5, r1
bl	tikutiku
ldrb	r0, [r5, #0x8]
strb	r0, [r4, #0x8]
ldrb	r0, [r5, #0x9]
strb	r0, [r4, #0x9]
ldr	r0, =0x0802c142
mov	pc, r0

tikutiku:
push	{r1, lr}
ldrb	r0, [r5, #0xB]
lsl	r1, r0, #24
bmi	teki		@敵なら分岐
lsl	r1, r0, #25
bmi	end		@味方以外なら終了
bl	syurui
mov	r1, #0x43	@AI1カウンター
.short	0xE001

teki:
mov	r1, #0x37 	@支援値6人目
mov	r2, #1		@敵はどんな時でも+1
add	r1, r1, r4	@ここから敵味方共通の処理
ldrb	r0, [r1, #0]
add	r0, r2
cmp	r0, #99		@チクチク値限界:99
bls	dainyuu
mov	r0, #99
dainyuu:
strb	r0, [r1, #0]	@チクチク値代入

end:
pop	{r1}
pop	{pc}

syurui:
push	{r4, r5 ,lr}
ldr	r4, =0x0203a4e8	@味方
ldr	r5, =0x0203a568	@味方
ldrb	r0, [r4, #0xB]
cmp	r0, #0x81
blt	odori
ldr	r5, =0x0203a4e8	@敵
ldr	r4, =0x0203a568	@敵

odori:
@踊り
ldr	r0, =0x0203a4d0
ldrb	r0, [r0, #0x0]
mov	r1, #0x40
and	r0, r1
beq	tue
@踊り時
ldr	r2, adr
b	owari

tue:
@杖
mov	r0, #0x50
ldrb	r0, [r4, r0]
cmp	r0, #0x4
bne	miss
@杖時
bl	table		@杖指定
cmp	r2, #0x0
bne	owari
ldr	r2, adr+4
b	owari

miss:
@攻撃ミスか
mov	r0, r4
add	r0, #0x7c
ldrb	r0, [r0, #0]
lsl	r0, r0, #0x18
asr	r0, r0, #0x18
cmp	r0, #0x0
bne	migekiha
@ミス時
ldr	r2, adr+8
b	owari

migekiha:
@未撃破、撃破
mov	r0, #0x13
ldsb	r0, [r5, r0]	@敵の現在HP
cmp	r0, #0x0
beq	gekiha

@未撃破時
ldr	r2, adr+12
b	owari

gekiha:
@撃破時
ldr	r2, adr+16
owari:
pop	{r4, r5}
pop	{pc}

table:
ldr	r1, adr+20
cmp	r1, #0x0
beq	nasi
mov	pc, r1
nasi:
mov	r2, #0x0
mov	pc, lr

.ltorg
.align
adr: