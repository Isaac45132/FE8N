.thumb

FlagA = (adr)
FlagB = (adr+4)
UnitA = (adr+8)
UnitB = (adr+12)

@org	0x08037C24
push	{r2, r3}
ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, FlagA	@指定フラグIDその1
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
bne	flag1		@フラグが立っているなら分岐

ldr	r2, =0x080860D0	@フラグが立ってるか
mov	lr, r2
ldrh	r0, FlagB	@指定フラグIDその2
ldrh	r0, [r0, #0]
.short	0xF800
cmp	r0, #0
beq	end		@フラグが立っていないなら分岐

pop	{r2, r3}
ldrh	r2, UnitB	@指定ユニットIDその2
ldrh	r2, [r2, #0]
.short	0xE004

flag1:
pop	{r2, r3}
ldr	r2, UnitA	@指定ユニットIDその1
ldrh	r2, [r2, #0]
.short	0xE000

end:
pop	{r2, r3}
ldr	r1, =0x08037C2C
mov	pc, r1

.ltorg
.align
adr: