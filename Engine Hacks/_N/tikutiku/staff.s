.thumb

push	{lr}
ldr	r1, adr
mov	r2, #0x0

loop:
ldr	r0, [r1, r2]
cmp	r0, #0xFF
beq	end
cmp	r0, #0x0
beq	end
push	{r1}
mov	r1, #0x4A
ldrb	r1, [r4, r1]
cmp	r0, r1
beq	hirou

pop	{r1}
add	r2, r2, #0x8
b	loop

hirou:
pop	{r1}
add	r2, r2, #0x4
ldr	r2, [r1, r2]
.short	0xE000

end:
mov	r2, #0x0
pop	{pc}

.ltorg
.align
adr: