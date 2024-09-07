.thumb

FlagA = (adr)
FlagB = (adr+4)

@@org	0x080C1E74
@org	0x08086AD4

push	{r2, r4}
ldr	r3, =0x080860D0	@フラグが立ってるか
mov	lr, r3
ldrh	r0, FlagA	@指定フラグIDその1
ldrh	r0, [r0, #0]
.short	0xF800
pop	{r2, r4}
cmp	r0, #0
bne	end		@フラグが立っているなら分岐

push	{r2, r4}
ldr	r3, =0x080860D0	@フラグが立ってるか
mov	lr, r3
ldrh	r0, FlagB	@指定フラグIDその2
ldrh	r0, [r0, #0]
.short	0xF800
pop	{r2, r4}
cmp	r0, #0
bne	end		@フラグが立っているなら分岐

ldrh r0, [r2]
ldr r1, =0x0000FFFF
cmp r0, r1
beq end

ldr r3, =0x08086ADD
bx r3

end:
ldr r3, =0x08086B1D
bx r3


@mov	r2, lr
@push	{r2}
@ldr	r2, =0x080860D0	@フラグが立ってるか
@mov	lr, r2
@ldrh	r0, FlagA	@指定フラグIDその1
@ldrh	r0, [r0, #0]
@.short	0xF800
@cmp	r0, #0
@bne	nasi		@フラグが立っているなら分岐
@
@ldr	r2, =0x080860D0	@フラグが立ってるか
@mov	lr, r2
@ldrh	r0, FlagB	@指定フラグIDその2
@ldrh	r0, [r0, #0]
@.short	0xF800
@cmp	r0, #0
@beq	hutuu		@フラグが立ってないなら分岐
@
@nasi:
@mov	r0, #1		@強制出撃なし
@.short	0xE000		@一つ飛ばす
@hutuu:
@mov	r0, #0		@普通の強制出撃処理へ
@pop	{r2}
@mov	lr, r2
@bx	lr

.ltorg
.align
adr: