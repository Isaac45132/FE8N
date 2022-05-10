.thumb

@org	0x0802FB70

ldr	r1, [r0, #0xC]
ldr	r2, =0xFFFFFBBD
and	r1, r1, r2
str	r1, [r0, #0xC]

mov	r1, r5
mov	r2, #0x1
bl	WriteUnitStatusDuration

ldr	r1, =0x0802FB78
mov	pc, r1

WriteUnitStatusDuration:
ldr	r5, =0x0801769C
mov	pc, r5

.ltorg
.align
adr: