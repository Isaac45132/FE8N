.thumb

@org	0x0808ABDC

ldr	r2, =0x02003BFC
mov	r6, #0
mov	r3, #0
strh	r3, [r2, #0x4]
strh	r3, [r2, #0x6]

ldr	r5, =0x02003BFB
strb	r3, [r5, #0]

ldr	r3, =0x0808ABE5
bx	r3


.ltorg
.align
adr: