.thumb
    
    push    {r4, lr}
    mov r4, r0
    mov r1, r4
    add r1, #72
    ldrh    r0, [r1, #0]
    cmp r0, #0
    beq $0002acfa
    bl  $000172f0
    
    mov r1, r0
    cmp r1, #7
    bgt $0002acfa
    mov r0, r4
    add r0, #40
    add r0, r0, r1
    ldrb    r0, [r0, #0]
    cmp r0, #250
    bls $0002acfa
    mov r1, r4
    
    add r1, #96
    ldrh    r0, [r1, #0]
    add r0, #5
    strh    r0, [r1, #0]
    
    add r1, #6
    ldrh    r0, [r1, #0]
    add r0, #5
    strh    r0, [r1, #0]    @必殺
$0002acfa:
    pop {r4}
    pop {r0}
    bx  r0

$000172f0:
    ldr r1, =0x080172f0
    mov pc, r1


