@define PULSE_ID 0x0C	;謎の状態異常
;000185f0
@thumb
pulse:
@dcw $1c21
@dcw $3130
@dcw $780b
	lsl r0, r3, #24
	lsr r0, r0, #24
	cmp r0, PULSE_ID
	beq dontHeal

;@dcw $2001
;@dcw $4680
;@dcw $1c21
;@dcw $3130
;@dcw $780b
@dcw $4660
;@dcw $4018
;@dcw $2800
	ldr r2 =$080185fc
	mov pc, r2

dontHeal:
	ldr r2 =$08018630
	mov pc, r2
