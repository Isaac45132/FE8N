.thumb

FlagA = (adr)
FlagB = (adr+4)
FlagC = (adr+8)

@org	0x0808568C
mov	r4, r0		@元の処理

ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, FlagA	@指定フラグIDその1
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiA		@フラグが立っているなら分岐

ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, FlagB	@指定フラグIDその2
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiB		@フラグが立っているなら分岐

ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, FlagC	@指定フラグIDその3
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	nasiC		@フラグが立っているなら分岐

mov	r1, #0		@普通の配置処理へ
b	end

nasiA:
mov	r1, #2		@魔物の配置処理へ
ldr	r0, [r4, #0x30]	@魔物の配置1
b	end

nasiB:
mov	r1, #2		@魔物の配置処理へ
ldr	r0, [r4, #0x34]	@魔物の配置2
b	end

nasiC:
mov	r1, #2		@魔物の配置処理へ
ldr	r0, [r4, #0x38]	@魔物の配置3

end:
ldr	r3, =0x08085694
mov	pc, r3

.ltorg
.align
adr: