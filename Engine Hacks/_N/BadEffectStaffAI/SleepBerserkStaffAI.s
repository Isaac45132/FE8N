.thumb
@org	0x08040580

ldr	r1, [SP, #0x14]
cmp	r1, #0
bne	falseStaffAI

ldsh	r1, [r0, r2]
str	r1, [SP, #0x14]
mov	r0, #2
ldsh	r3, [r4, r0]
ldr	r1, =0x08040588
mov	pc, r1
falseStaffAI:
ldr	r1, =0x08040592
mov	pc, r1

.ltorg
.align
adr: