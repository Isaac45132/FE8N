.thumb
@org	0x080403F8

ldr	r0, [SP, #0x14]
cmp	r0, #0
bne	falseStaffAI

str	r7, [SP, #0x14]
mov	r0, SP
add	r0, r0, #0xC
mov	r3, #0
ldsh	r2, [r0, r3]
ldr	r1, =0x08040400
mov	pc, r1
falseStaffAI:
ldr	r2, =0x08040410
mov	pc, r2

.ltorg
.align
adr: