.thumb
@0802a90c
@ステータス画面にも影響がある
@相手が存在するとは限らない(ダミーかもしれない)
    bl AvoidUp
    bl HitUp
    bl fatigue

@闘技場チェック
    bl GetArenaAddr
    ldrh r0, [r0]
    mov r1, #0x20
    and r0, r1
    bne RETURN
@相手が必要ない処理

    ldr r0, [r5, #4]
    cmp r0, #0
    beq gotSkill	@相手いない
    mov r0, r5

    bl HasMikiri

    cmp r0, #0
    bne endNoEnemy	@見切り持ちなら終了
gotSkill:
    bl Shishi
    bl Konshin
    bl Savior	@護り手
    bl Ace
    bl shisen_A
    bl Solo
    bl Fort
    bl Bond
@    bl BladeSession
	bl MagicSword
	bl Frenzy
    bl asUp
    bl Miracle
    bl Agitation
    bl DefenseForce
    bl passion
    bl DefenseForceM
    bl Onnasuki
    bl DoubleLion

endNoEnemy:

@相手の存在をチェック
    ldr r0, [r5, #4]
    cmp r0, #0
    beq endNeedEnemy	@相手いない

    bl WarSkill

    mov	r0, r5
    bl HasMikiri
    cmp r0, #0
    bne endNeedEnemy
    
    bl OtherSideSkill
    bl koroshi
    bl Trample
    bl Calm
    bl Seigai

endNeedEnemy:
	bl MikiriSkills

@マイナス処理
    bl Domination
    cmp r2, #0
    bne RETURN
    bl Daunt
    cmp r2, #0
    bne RETURN
    bl Heartseeker

RETURN:
    pop {r4, r5}
    pop {r0}
    bx r0

Trample:
        push {lr}
@        ldr r0, [r4]
@        ldr r1, [r4, #4]
@        ldr r0, [r0, #40]
@        ldr r1, [r1, #40]
@        orr r0, r1
@        mov r1, #0x1C
@        lsl r1, r1, #8  @0x1C00
@        tst r0, r1
@        beq endTrample  @自分が歩兵なら終了

        ldr r0, [r5]
        ldr r1, [r5, #4]
        ldr r0, [r0, #40]
        ldr r1, [r1, #40]
        orr r0, r1
        mov r1, #0x1C
        lsl r1, r1, #8  @0x1C00
        tst r0, r1
        bne endTrample  @相手が騎兵なら終了

        mov r0, r4
        mov r1, #0
        bl HasTrample
        cmp r0, #0
        beq endTrample

        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #5
        strh r0, [r4, r1]
    endTrample:
        pop {pc}

OtherSideSkill:
        push {lr}
        bl GetAttackerAddr
        ldr r0, [r0]
        ldrb r0, [r0, #0xB]
        
        ldrb r1, [r4, #0xB]
        cmp r0, r1
        bne DefSkill
        bl Kishin
        bl Hien
        bl Bracing
        bl Charge
        bl IchibanSpear
        pop {pc}
    DefSkill:
        bl DistantDef
        bl CloseDef
@        bl ShieldSession
        bl ImpregnableWall
        bl KishinR
        bl HienR
        bl BracingR
        bl KishinBreath
        bl HienBreath
        bl Kazeyoke
        pop {pc}

CriticalUp:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasCriticalUp
        cmp r0, #0
        beq falseCritical    
        mov r1, #102
        ldrh r0, [r4, r1]
        add r0, #15
        strh r0, [r4, r1] @自分
    falseCritical:
        pop {pc}
    
AvoidUp:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasAvoidUp
        cmp r0, #0
        beq falseAvoid    
        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #15
        strh r0, [r4, r1] @自分
    falseAvoid:
        pop {pc}

Miracle:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasMiracle
        cmp r0, #0
        beq falseMiracle
	ldrb r0, [r4, #0x13]	@現在HP
	cmp r0, #9   		@9
	bgt falseMiracle	@より大きいなら終了
        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1] @自分
    falseMiracle:
        pop {pc}

HitUp:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasHitUp
        cmp r0, #0
        beq falseHit    
        mov r1, #96	@命中
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1] @自分
    falseHit:
        pop {pc}

asUp:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasAsUp
        cmp r0, #0
        beq falseasUp    
        mov r1, #94	@攻速
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
    falseasUp:
        pop {pc}


DoubleLion:
        push {lr}
    ldr r0, [r5, #4]
    cmp r0, #0
    beq falseDoubleLion	@相手いない

        bl GetDistance
        ldrb r0, [r0]
        cmp r0, #1
        bne falseDoubleLion       @近距離のみ

        mov r0, r4
        mov r1, #0
        bl HasDoubleLion
        cmp r0, #0
        beq falseDoubleLion
        
        ldrb r1, [r4, #18] @最大HP
        ldrb r0, [r4, #19] @現在HP
        cmp r0, r1
        blt falseDoubleLion @現在が最大よりも小さい場合
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #2
        strh r0, [r4, r1] @自分
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #2
        strh r0, [r4, r1] @自分
    falseDoubleLion:
        mov r0, #0
        pop {pc}

ImpregnableWall:
        push {lr}

        mov r0, r4
        mov r1, #0
        bl HAS_IMPREGNABLE_WALL
        cmp r0, #0
        beq falseImpregnableWall
        mov r0, #0
        mov r1, #98 @回避
        strh r0, [r4, r1]

        mov r0, #1
        .short 0xE000
    falseImpregnableWall:
        mov r0, #0
        pop {pc}

Agitation:
@青は青に対して効く
@赤は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bpl mikata
        mov r6, #0x80
        bl agitation_impl
        b endagitation
    mikata:
        mov r6, #0x00
        bl agitation_impl
    endagitation:
        pop {r4, r5, r6, r7, pc}

agitation_impl:
        push {lr}
        mov r7, #0
    loopagitation:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultagitation	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopagitation	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopagitation	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopagitation
    
        mov r0, #3  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopagitation @近くにいない
    
	ldrb r0, [r5, #0xB]
	ldrb r1, [r4, #0xB]
	cmp r0, r1
	beq loopagitation    @自分自身には無効

        mov r0, r5
        mov r1, r4
        bl Hasagitation
        cmp r0, #0
        beq loopagitation    @相手が扇動未所持
    
        mov r7, #1
        b loopagitation
    
    resultagitation:
	mov r2, #15		@命中回避15
        mul r2, r7

        mov r1, #96 @命中
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1]

        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1]
        pop {pc}

DefenseForce:
@青は青に対して効く
@赤は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bpl mikata2
        mov r6, #0x80
        bl DefenseForce_impl
        b endDefenseForce
    mikata2:
        mov r6, #0x00
        bl DefenseForce_impl
    endDefenseForce:
        pop {r4, r5, r6, r7, pc}

DefenseForce_impl:
        push {lr}
        mov r7, #0
    loopDefenseForce:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultDefenseForce	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopDefenseForce	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopDefenseForce	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopDefenseForce
    
        mov r0, #1  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopDefenseForce @近くにいない
    
	ldrb r0, [r5, #0xB]
	ldrb r1, [r4, #0xB]
	cmp r0, r1
	beq loopDefenseForce    @自分自身には無効

        mov r0, r5
        mov r1, r4
        bl HasDefenseForce
        cmp r0, #0
        beq loopDefenseForce    @相手が守護陣未所持
    
        mov r7, #1
        b loopDefenseForce
    
    resultDefenseForce:
	mov r2, #5		@防御5
        mul r2, r7

        mov r1, #92 @防御
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1]
        pop {pc}

DefenseForceM:
@青は青に対して効く
@赤は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bpl mikata3
        mov r6, #0x80
        bl DefenseForceM_impl
        b endDefenseForceM
    mikata3:
        mov r6, #0x00
        bl DefenseForceM_impl
    endDefenseForceM:
        pop {r4, r5, r6, r7, pc}

DefenseForceM_impl:
        push {lr}
        mov r7, #0
    loopDefenseForceM:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultDefenseForceM	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopDefenseForceM	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopDefenseForceM	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopDefenseForceM
    
        mov r0, #3  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopDefenseForceM @近くにいない
    
	ldrb r0, [r5, #0xB]
	ldrb r1, [r4, #0xB]
	cmp r0, r1
	beq loopDefenseForceM    @自分自身には無効

        mov r0, r5
        mov r1, r4
        bl HasDefenseForceM
        cmp r0, #0
        beq loopDefenseForceM    @相手が守護陣未所持
    
        mov r7, #1
        b loopDefenseForceM
    
    resultDefenseForceM:
	mov r2, #2		@防御2
        mul r2, r7

        mov r1, #92 @防御
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1]
        pop {pc}

Domination:
@青は赤に対して効く
@赤は青と緑に対して効く
@緑は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bmi isRedDomination
        mov r6, #0x80
        bl Domination_impl
        b endDomination
    isRedDomination:
        mov r6, #0x00
        bl Domination_impl
	cmp r2, #0
	bne endDomination
        mov r6, #0x40
        bl Domination_impl
    endDomination:
        pop {r4, r5, r6, r7, pc}

Domination_impl:
        push {lr}
        mov r7, #0
    loopDomination:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultDomination	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopDomination	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopDomination	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopDomination
    
        mov r0, #3  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopDomination @近くにいない
    
        mov r0, r5
        mov r1, r4
        bl HasDomination
        cmp r0, #0
        beq loopDomination    @相手が恐怖未所持
    
        mov r7, #1
        b loopDomination
    
    resultDomination:
        mov r2, #20 @マイナス20
        mul r2, r7
    
        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        sub r0, r0, r2
        bgt limitDomination1
        mov r0, #0
    limitDomination1:
        strh r0, [r4, r1]

        mov r1, #102 @必殺
        ldrh r0, [r4, r1]
        sub r0, r0, r2
        bgt limitDomination2
        mov r0, #0
    limitDomination2:
        strh r0, [r4, r1]
        pop {pc}

Daunt:
@青は赤に対して効く
@赤は青と緑に対して効く
@緑は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bmi isRedDaunt
        mov r6, #0x80
        bl Daunt_impl
        b endDaunt
    isRedDaunt:
        mov r6, #0x00
        bl Daunt_impl
	cmp r2, #0
	bne endDaunt
        mov r6, #0x40
        bl Daunt_impl
    endDaunt:
        pop {r4, r5, r6, r7, pc}

Daunt_impl:
        push {lr}
        mov r7, #0
    loopDaunt:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultDaunt	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopDaunt	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopDaunt	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopDaunt
    
        mov r0, #3  @範囲指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopDaunt @近くにいない
    
        mov r0, r5
        mov r1, r4
        bl HasDaunt
        cmp r0, #0
        beq loopDaunt    @相手が恐怖未所持
    
        mov r7, #1
        b loopDaunt
    
    resultDaunt:
        mov r2, #10 @マイナス10
        mul r2, r7
    
        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        sub r0, r0, r2
        bgt limitDaunt1
        mov r0, #0
    limitDaunt1:
        strh r0, [r4, r1]

        mov r1, #102 @必殺
        ldrh r0, [r4, r1]
        sub r0, r0, r2
        bgt limitDaunt2
        mov r0, #0
    limitDaunt2:
        strh r0, [r4, r1]
        pop {pc}

Heartseeker:
@青は赤に対して効く
@赤は青と緑に対して効く
@緑は赤に対して効く
        push {r4, r5, r6, r7, lr}
    
        ldrb r0, [r4, #0xB]
        lsl r0, r0, #24
        bmi isRedHeartseeker
        mov r6, #0x80
        bl Heartseeker_impl
        b endHeartseeker
    isRedHeartseeker:
        mov r6, #0x00
        bl Heartseeker_impl
	cmp r2, #0
	bne endHeartseeker
        mov r6, #0x40
        bl Heartseeker_impl
    endHeartseeker:
        pop {r4, r5, r6, r7, pc}

Heartseeker_impl:
        push {lr}
        mov r7, #0
    loopHeartseeker:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultHeartseeker	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopHeartseeker	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopHeartseeker	@死亡判定2
    
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1	@居ないフラグ+救出されている
        and r0, r1
        bne loopHeartseeker
    
        mov r0, #1  @1マス指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopHeartseeker @近くにいない
    
        mov r0, r5
        mov r1, r4
        bl HasHeartseeker
        cmp r0, #0
        beq loopHeartseeker    @相手が呪縛未所持
    
        mov r7, #1
        b loopHeartseeker
    
    resultHeartseeker:
        mov r2, #20 @マイナス20
        mul r2, r7
    
        mov r1, #98 @回避
        ldrh r0, [r4, r1]
        sub r0, r0, r2
        bgt limitHeartseeker
        mov r0, #0
    limitHeartseeker:
        strh r0, [r4, r1] @自分
        pop {pc}

WarSkill:
        push {lr}
        bl GetAttackerAddr
        ldr r2, [r0]
        ldrb r2, [r2, #11]
        ldrb r0, [r4, #11]
        cmp r0, r2
        bne endWar

        mov r0, r4
        bl GET_COMBAT_ART
        bl GetWarList
        cmp r0, #0
        beq endWar
        mov r3, r0

@攻撃はここではなく凪の後
        mov r1, #96
        ldrh r0, [r4, r1]
        mov r2, #1
        ldsb r2, [r3, r2]
        add r0, r0, r2
        cmp r0, #0
        bge jumpWar2
        mov r0, #0
    jumpWar2:
        strh r0, [r4, r1] @命中
@@@@@@@@
        mov r1, #98
        ldrh r0, [r4, r1]
        mov r2, #3
        ldsb r2, [r3, r2]
        add r0, r0, r2
        cmp r0, #0
        bge jumpWar3
        mov r0, #0
    jumpWar3:
        strh r0, [r4, r1] @回避
@@@@@@@@
        mov r1, #104
        ldrh r0, [r4, r1]
        add r0, r2
        cmp r0, #0
        bge jumpWarDodge
        mov r0, #0
    jumpWarDodge:
        strh r0, [r4, r1] @必殺回避
@@@@@@@@
        mov r1, #102
        ldrh r0, [r4, r1]
        mov r2, #2
        ldsb r2, [r3, r2]
        add r0, r0, r2
        cmp r0, #0
        bge jumpWar4
        mov r0, #0
    jumpWar4:
        strh r0, [r4, r1] @必殺
    
    endWar:
        pop {pc}

Bond:
        push {r4, r5, r6, r7, lr}
        ldrb r6, [r4, #0xB]
        mov r0, #0xC0
        and r6, r0	@r6に部隊表ID
        
        mov r0, r4
        mov r1, #0
        bl HasBond
        cmp r0, #0
        beq falseBond
        mov r7, #0
    loopBond:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultBond	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopBond	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopBond	@死亡判定2
        ldrb r0, [r4, #0xB]
        ldrb r1, [r5, #0xB]
        cmp r0, r1
        beq loopBond	@自分
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1
        and r0, r1
        bne loopBond
    
    jumpBond:
        mov r0, #1  @1マス指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopBond
        add r7, #1
        b loopBond
    resultBond:
        mov r2, #3
        mul r2, r7
        cmp r2, #7
        ble limitBond
        mov r2, #7
    limitBond:
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1] @自分
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1] @自分
    falseBond:
        pop {r4, r5, r6, r7, pc}


Onnasuki:
        push {r4, r5, r6, r7, lr}
        ldrb r6, [r4, #0xB]
        mov r0, #0xC0
        and r6, r0	@r6に部隊表ID
        
        mov r0, r4
        mov r1, #0
        bl HasOnnasuki
        cmp r0, #0
        beq falseOnnasuki
        mov r7, #0
    loopOnnasuki:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq resultOnnasuki	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopOnnasuki	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopOnnasuki	@死亡判定2
        ldr r1, [r5]
	ldr r1, [r1, #0x28]
	mov r0, #0x40
	lsl r0, r0, #8
	and r0, r1
        beq loopOnnasuki	@女性でない
        ldrb r0, [r4, #0xB]
        ldrb r1, [r5, #0xB]
        cmp r0, r1
        beq loopOnnasuki	@自分
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1
        and r0, r1
        bne loopOnnasuki
    
    jumpOnnasuki:
        mov r0, #2  @2マス指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopOnnasuki
        add r7, #1
        b loopOnnasuki
    resultOnnasuki:
        mov r2, #2
        mul r2, r7
        cmp r2, #2
        ble limitOnnasuki
        mov r2, #2
    limitOnnasuki:
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1] @自分
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, r0, r2
        strh r0, [r4, r1] @自分
    falseOnnasuki:
        pop {r4, r5, r6, r7, pc}


Frenzy:
        push {r4, r5, r6, r7, lr}

        mov r0, r4
        mov r1, #0
        bl HasAce
        cmp	r0, #0
        beq	notAce
        ldrb	r0, [r4, #0x13]	@NOW
        ldrb	r1, [r4, #0x12]	@MAX
        lsl	r0, r0, #1
        cmp	r0, r1
        bls	falseFrenzy
        
    notAce:
        ldrb r6, [r4, #0xB]
        mov r0, #0xC0
        and r6, r0	@r6に部隊表ID
        
        mov r0, r4
        mov r1, #0
        bl HasFrenzy
        cmp r0, #0
        beq falseFrenzy
        mov r7, #0
    loopFrenzy:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq falseFrenzy	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopFrenzy	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopFrenzy	@死亡判定2
        ldrb r0, [r4, #0xB]
        ldrb r1, [r5, #0xB]
        cmp r0, r1
        beq loopFrenzy	@自分
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1
        and r0, r1
        bne loopFrenzy

	push {r1}
        ldrb	r0, [r5, #0x13]	@NOW
        ldrb	r1, [r5, #0x12]	@MAX
        lsl	r0, r0, #1
        cmp	r0, r1
	pop {r1}  
        bgt	loopFrenzy

    jumpFrenzy:
        mov r0, #2  @2マス指定
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #0
        beq loopFrenzy

        mov r1, #90	@攻撃
        ldrh r0, [r4, r1]
        add r0, #5
        strh r0, [r4, r1] @自分

        mov r1, #92	@防御
        ldrh r0, [r4, r1]
        add r0, #5
        strh r0, [r4, r1] @自分

        mov r1, #94	@攻速
        ldrh r0, [r4, r1]
        add r0, #5
        strh r0, [r4, r1] @自分
    falseFrenzy:
        pop {r4, r5, r6, r7, pc}

Fort:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasFort
    
        cmp r0, #0
        beq falseFort
    
        mov r1, r4
        add r1, #90
        ldrh r0, [r1]
        sub r0, #2  @minus 2
        bge jumpFort
        mov r0, #0
    jumpFort:
        strh r0, [r1] @自分
        
        mov r1, r4
        add r1, #92
        ldrh r0, [r1]
        add r0, #4  @plus 4
        strh r0, [r1] @自分
        
        mov r0, #1
        b endFort
    falseFort:
        mov r0, #0
    endFort:
        pop {pc}

passion:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasPassion
        cmp r0, #0
        beq endPassion
        
        ldrb r1, [r4, #18] @最大HP
        ldrb r0, [r4, #19] @現在HP
        cmp r0, r1
        beq endPassion	 @現在が最大と同じなら終了

        add r4, #90
        ldrh r0, [r4]
	mov r2, r0
        mov r1, #2
	mul r0, r1
	mov r1, #10
	swi #6      @2割
	add r0, r2
        strh r0, [r4] @自分
    endPassion:
        pop {pc}


shisen_A:	@自分死線
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasShisen
        cmp r0, #0
        beq falseShisen
        
	mov r1, #0x4C
	ldrb r0, [r4, r1]
	mov r1, #0x80
	and r0, r1
	bne falseShisen

        mov r1, r4
        add r1, #90
        ldrh r0, [r1]
        add r0, #10
        strh r0, [r1] @自分
@       mov r1, r4
@       add r1, #94
@       ldrh r0, [r1]
@       add r0, #10
@       strh r0, [r1] @自分
        mov r0, #1
        b endShisen
    falseShisen:
        mov r0, #0
    endShisen:
        pop {pc}

MagicSword:
        push	{r2, lr}
	mov	r0, #80
	ldrb	r0, [r4, r0]
	cmp	r0, #0		@剣
	bne	endMagicSword

	ldr	r0, [r4, #4]
	ldrb	r0, [r0, #4]
	cmp	r0, #0x29	@マージナイト
	beq	madou
	cmp	r0, #0x2A	@マージナイト
	bne	endMagicSword
madou:
	ldrb	r0, [r4, #20]
	ldrb	r1, [r4, #26]
	cmp	r0, r1
	bpl	endMagicSword
	mov	r2, #90
	ldr	r2, [r4, r2]
	sub	r0, r2, r0
	add	r0, r0, r1
	mov	r2, #90
	strh	r0, [r4, r2]

endMagicSword:
        pop	{r2, pc}

Calm:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasCalm
        cmp r0, #0
        beq falseCalm

        ldrb r1, [r5, #18] @最大HP
        ldrb r0, [r5, #19] @現在HP
        cmp r0, r1
        blt falseCalm @現在が最大よりも小さい場合

        mov r1, r4
        add r1, #96
        ldrh r0, [r1]
        add r0, #10	@命中
        strh r0, [r1]	@自分

        mov r1, r4
        add r1, #102
        ldrh r0, [r1]
        add r0, #10	@必殺
        strh r0, [r1]	@自分
    falseCalm:
        pop {pc}

Seigai:

        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasSeigai
        cmp r0, #0
        beq falseSeigai

        mov r1, #90	@攻撃
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1]
        mov r1, #92	@防御
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1]
    falseSeigai:
        pop {pc}

Solo:
        push {r4, r5, r6, lr}
        ldrb r6, [r4, #0xB]
        mov r0, #0xC0
        and r6, r0	@r6に部隊表ID
        
        mov r0, r4
        mov r1, #0
        bl HasSolo
        cmp r0, #0
        beq falseSolo
        
    loopSolo:
        add r6, #1
        mov r0, r6
        bl Get_Status
        mov r5, r0
        cmp r0, #0
        beq trueSolo	@リスト末尾
        ldr r0, [r5]
        cmp r0, #0
        beq loopSolo	@死亡判定1
        ldrb r0, [r5, #19]
        cmp r0, #0
        beq loopSolo	@死亡判定2
        ldrb r0, [r4, #0xB]
        ldrb r1, [r5, #0xB]
        cmp r0, r1
        beq loopSolo	@自分
        ldr r0, [r5, #0xC]
        bl GetExistFlagR1
        and r0, r1
        bne loopSolo	@居ないフラグ+救出中
        
        mov r0, #2  @2マス以内
        mov r1, r4
        mov r2, r5
        bl CheckXY
        cmp r0, #1
        beq falseSolo
        b loopSolo
    trueSolo:
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
    falseSolo:
        pop {r4, r5, r6, pc}

CheckXY:
@r1とr2がr0マス以内に居るならr0=TRUE
@同座標ならTRUE
@
        push {r0}
        ldrb r0, [r1, #16]
        ldrb r3, [r2, #16]
        sub r3, r0, r3
        bge jump1CheckXY
        neg r3, r3  @絶対値取得
    jump1CheckXY:

        ldrb r1, [r1, #17]
        ldrb r2, [r2, #17]
        sub r2, r1, r2
        bge jump2CheckXY
        neg r2, r2  @絶対値取得
    jump2CheckXY:

        add r2, r2, r3
        pop {r0}
        cmp r2, r0
        bgt falseCheckXY    @r0マス以内に居ない
        mov r0, #1
        bx lr
    falseCheckXY:
        mov r0, #0
        bx lr

GetWalked:
        mov r1, r0
        ldr r2, =0x0202be44
        ldrb r0, [r1, #16]
        ldrb r3, [r2, #0]
        sub r0, r0, r3
        bge jump1Walked
        neg r0, r0  @絶対値取得
    jump1Walked:

        ldrb r1, [r1, #17]
        ldrb r2, [r2, #2]
        sub r2, r1, r2
        bge jump2Walked
        neg r2, r2  @絶対値取得
    jump2Walked:
        add r0, r0, r2
        bx lr

Get_Status:
    ldr r1, =0x08019108
    mov pc, r1

.align
.ltorg

Ace:
        push {lr}
    
        ldrb	r0, [r4, #0x13]	@NOW
        ldrb	r1, [r4, #0x12]	@MAX
        lsl	r0, r0, #1
        cmp	r0, r1
        bgt	endAce
    
        mov r0, r4
        mov r1, #0
        bl HasAce
        cmp	r0, #0
        beq	endAce
    
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #8
        strh r0, [r4, r1] @自分
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #8
        strh r0, [r4, r1] @自分
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #8
        strh r0, [r4, r1] @自分
        
    endAce:
        pop {pc}


DEFENDER_DAMAGE = (6)

Savior:
        push {lr}
        
        ldr r0, [r4, #12]
        mov r1, #0x10
        and r0, r1
        beq endSavior

        ldrb r0, [r4, #27]
        cmp r0, #0
        beq endSavior

        ldrb r1, [r4, #0xB]
        lsr r0, r0, #30
        lsr r1, r1, #30
        cmp r0, r1
        bne endSavior

        mov r0, r4
        mov r1, #0
        bl HasSavior
        cmp r0, #0
        beq endSavior
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #DEFENDER_DAMAGE
        strh r0, [r4, r1]
        mov r0, #1
        .short 0xE000
    endSavior:
        mov r0, #0
        pop {pc}

DistantDef:
        push {lr}
        ldr r0, Range_ADDR
        ldrb r0, [r0] @距離
        cmp r0, #1
        ble endDistantDef
        
        mov r0, r4
        mov r1, #0
        bl HasDistantDef
        cmp r0, #0
        beq endDistantDef
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #6
        strh r0, [r4, r1]
        mov r0, #1
        .short 0xE000
    endDistantDef:
        mov r0, #0
        pop {pc}
        

CloseDef:
        push {lr}
        ldr r0, Range_ADDR
        ldrb r0, [r0] @距離
        cmp r0, #1
        bne endCloseDef
        
        mov r0, r4
        mov r1, #0
        bl HasCloseDef
        cmp r0, #0
        beq endCloseDef
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #6
        strh r0, [r4, r1]
        mov r0, #1
        .short 0xE000
    endCloseDef:
        mov r0, #0
        pop {pc}

koroshi:
        push {lr}
        mov r0, #83
        ldsb r0, [r4, r0]
        cmp r0, #0
@        blt falseKoroshi

        bl breaker_impl
        cmp r0, #0
        beq falseKoroshi
    gotKoroshi:
        bl setKoroshi
        mov r0, #1
        .short 0xE000
    falseKoroshi:
        mov r0, #0
        pop {pc}
        
    setKoroshi:
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #96
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1] @自分
        
        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1] @自分
        bx lr
        
effect_test:
    ldr r3, [r5, #4]
    ldrb r3, [r3, #4]
    b effective_loop
effect_back:
    ldrb r0, [r1, #0]
    cmp r0, r3
    beq effective_true
    add r1, #1
effective_loop:
    ldrb r0, [r1, #0]
    cmp r0, #0
    bne effect_back
    mov r0, #0
    b effective_false
effective_true:
    mov r0, #1
effective_false:
    bx lr    

Shishi:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasShishi
        cmp r0, #0
        beq falseShishi
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
    falseShishi:
        mov r0, #0
        pop {pc}

Konshin:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasKonshin
        cmp r0, #0
        beq falseKonshin
        
        ldrb r1, [r4, #18] @最大HP
        ldrb r0, [r4, #19] @現在HP
        cmp r0, r1
        blt falseKonshin @現在が最大よりも小さい場合
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #3
        strh r0, [r4, r1] @自分
    falseKonshin:
        mov r0, #0
        pop {pc}

Charge:
        push {lr}
        bl GetDistance
        ldrb r0, [r0]
        cmp r0, #1
        bgt endCharge       @遠距離は無効
        mov r0, r4
        mov r1, #0
        bl HAS_CHARGE
        cmp r0, #0
        beq endCharge
        
        mov r0, r4
        bl GetWalked
@        lsl r0, r0, #1
        cmp r0, #10
        ble jumpCharge
        mov r0, #10
    jumpCharge:
        mov r1, #90
        ldrh r2, [r4, r1]
        add r2, r2, r0
        strh r2, [r4, r1] @自分
    endCharge:
        pop {pc}

Kishin:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasKishin
        cmp r0, #0
        beq endKishin
        
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #5 @威力
        strh r0, [r4, r1] @自分
    
        mov r1, #102
        ldrh r0, [r4, r1]
        add r0, #20 @必殺
        strh r0, [r4, r1] @自分
    endKishin:
        pop {pc}

IchibanSpear:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasIchibanSpear
        cmp r0, #0
        beq endIchiban
        
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #2 @威力
        strh r0, [r4, r1] @自分
    
        mov r1, #96
        ldrh r0, [r4, r1]
        add r0, #10 @命中
        strh r0, [r4, r1] @自分
    endIchiban:
        pop {pc}

KishinR:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasKishinR
        cmp r0, #0
        beq endKishin
        
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #6 @威力
        strh r0, [r4, r1] @自分
        b endKishin
KishinBreath:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HAS_FIERCE_BREATH
        cmp r0, #0
        beq endKishin
        
        mov r1, #90
        ldrh r0, [r4, r1]
        add r0, #4 @威力
        strh r0, [r4, r1] @自分
        b endKishin
Bracing:
        push {lr}
        mov r0, r5
        bl IsMagic
        cmp r0, #1
        beq jumpBracing
        bl Kongou
        b endBracing
    jumpBracing:
        bl Meikyou
    endBracing:
        pop {pc}

BracingR:
        push {lr}
        mov r0, r5
        bl IsMagic
        cmp r0, #1
        beq jumpBracingR
        bl KongouR
        b endBracingR
    jumpBracingR:
        bl MeikyouR
    endBracingR:
        pop {pc}

Kongou:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasKongou
        cmp r0, #0
        beq endKongou
    
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #10
        strh r0, [r4, r1]
    endKongou:
        pop {pc}
KongouR:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasKongouR
        cmp r0, #0
        beq endKongou
    
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #6
        strh r0, [r4, r1]
        b endKongou

Meikyou:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasMeikyou
        cmp r0, #0
        beq endMeikyou
    
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #10
        strh r0, [r4, r1]
    endMeikyou:
        pop {pc}
MeikyouR:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasMeikyouR
        cmp r0, #0
        beq endMeikyou
    
        mov r1, #92
        ldrh r0, [r4, r1]
        add r0, #6
        strh r0, [r4, r1]
        b endMeikyou

IsMagic:
        add r0, #80
        ldrb r0, [r0]
        cmp r0, #4
        beq trueMagic
        cmp r0, #5
        beq trueMagic
        cmp r0, #6
        beq trueMagic
        cmp r0, #7
        beq trueMagic
        mov r0, #0
        bx lr
    trueMagic:
        mov r0, #1
        bx lr

Hien:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasHien
        cmp r0, #0
        beq endHien
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #5
        strh r0, [r4, r1]
        
        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #20
        strh r0, [r4, r1]
    endHien:
        pop {pc}
HienR:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HasHienR
        cmp r0, #0
        beq endHien
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #6
        strh r0, [r4, r1]
        b endHien
HienBreath:
        push {lr}
        mov r0, r4
        mov r1, #0
        bl HAS_DARTING_BREATH
        cmp r0, #0
        beq endHien
        
        mov r1, #94
        ldrh r0, [r4, r1]
        add r0, #4
        strh r0, [r4, r1]
        b endHien

Kazeyoke:
        push {lr}
        bl GetDistance
        ldrb r0, [r0]
        cmp r0, #1
        ble endKazeyoke       @遠距離のみ

        mov r0, r4
        mov r1, #0
        bl HasKazeyoke
        cmp r0, #0
        beq endKazeyoke
        
        mov r1, #98
        ldrh r0, [r4, r1]
        add r0, #50
        strh r0, [r4, r1]
    endKazeyoke:
        pop {pc}

breaker_impl:
        push {lr}
        mov r0, r5
        add r0, #74
        ldrh r0, [r0]
        bl GetWeaponSp
        cmp r0, #0
        beq sword
        cmp r0, #1
        beq lance
        cmp r0, #2
        beq axe
        cmp r0, #3
        beq bow
        cmp r0, #4
        beq falseBreaker
        cmp r0, #7
        ble magic
        b falseBreaker
    sword:
        mov r0, r4
        mov r1, #0
        bl HasBreakerSw
        b endBreaker
    lance:
        mov r0, r4
        mov r1, #0
        bl HasBreakerSp
        b endBreaker
    axe:
        mov r0, r4
        mov r1, #0
        bl HasBreakerAx
        b endBreaker
    bow:
        mov r0, r4
        mov r1, #0
        bl HasBreakerBw
        b endBreaker
    magic:
        mov r0, r4
        mov r1, #0
        bl HasBreakerMg
        b endBreaker
    falseBreaker:
        mov r0, #0
    endBreaker:
        pop {pc}

MikiriSkills:
	ldr	r3, addr+248
	mov	pc, r3

fatigue:
        push {r2, r3, r5, lr}
	mov r3, #0x0
	ldr r5, FATIGUESTATUS
fatiguehante:
	mov r0, #0x47
	ldrb r0, [r4, r0]
	cmp r0, #0x1
	beq fatigueloop
	cmp r0, #0x2
	beq fatigue2
	cmp r0, #0x3
	beq fatigue3
	b fatigueend
fatigue2:
	ldr r0, [r5, r3]
	cmp r0, #0x0
	beq fatigueloop2
	add r3, r3, #0x8
	b fatigue2
fatigue3:
	ldr r0, [r5, r3]
	cmp r0, #0x0
	beq fatigue31
	add r3, r3, #0x8
	b fatigue3
fatigue31:
	add r3, r3, #0x8
fatigue32:
	ldr r0, [r5, r3]
	cmp r0, #0x0
	beq fatigueloop2
	add r3, r3, #0x8
	b fatigue32
fatigueloop2:
	add r3, r3, #0x8
fatigueloop:
	ldr r1, [r5, r3] @下げるステータス
	cmp r1, #0x0
	beq fatigueend
	add r3, r3, #0x4
	ldr r2, [r5, r3] @下げる値
        ldrh r0, [r4, r1]
        sub r0, r0, r2
	bpl purasu
	mov r0, #0x0
purasu:
        strh r0, [r4, r1] @自分
	add r3, r3, #0x4
	b fatigueloop
fatigueend:
	pop {r2, r3, r5}
        pop {pc}

.align
Range_ADDR:
.long 0x0203a4d2


SHISHI_ADDR = (addr+4)
SAVIOR_ADDR = (addr+44)
BLADE_SESSION_ADDR = (addr+48)
SHIELD_SESSION_ADDR = (addr+52)
HAS_AVOIDUP_ADDR = (addr+56)
HAS_CRITICALUP_ADDR = (addr+60)
HAS_CHARGE:
    ldr r2, addr+68
    mov pc, r2
@ARMOR_E_ADDR = (addr+72)
@HORSE_E_ADDR = (addr+76)
HasMeikyou:
    ldr r3, (addr+80)
    mov pc, r3
HIEN_ADDR = (addr+84)
ACE_ADDR = (addr+88)
KONSHIN_ADDR = (addr+92)
SOLO_ADDR = (addr+96)
SHISEN_ADDR = (addr+100)
FORT_ADDR = (addr+104)
TRAMPLE_ADDR = (addr+108)
HEARTSEEKER_ADDR = (addr+112)
DAUNT_ADDR = (addr+116)
HAS_BOND_ADDR = (addr+120)
HasMeikyouR:
    ldr r3, (addr+124)
    mov pc, r3
HAS_KISHIN_R = (addr+128)
HAS_KONGOU_R = (addr+132)
HAS_HIEN_R = (addr+136)
COMBAT_TBL = (addr+140)
COMBAT_TBL_SIZE = (addr+144)
GET_COMBAT_ART:
    ldr r2, (addr+148)
    mov pc, r2
HAS_FIERCE_BREATH:
    ldr r2, (addr+152)
    mov pc, r2
HAS_DARTING_BREATH:
    ldr r2, (addr+156)
    mov pc, r2

EXTRA_OFFSET = (addr+160)
DOMINATION_ADDR = (EXTRA_OFFSET+0)
NULLIFY_ADDR = (EXTRA_OFFSET+12)
HITUP_ADDR = (EXTRA_OFFSET+24)
AGITATION_ADDR = (EXTRA_OFFSET+28)
FATIGUESTATUS = (EXTRA_OFFSET+32)
MIRACLE_ADDR = (EXTRA_OFFSET+36)
ICHIBAN_ADDR = (EXTRA_OFFSET+40)
CALM_ADDR = (EXTRA_OFFSET+44)
FRENZY_ADDR = (EXTRA_OFFSET+48)
ASUP_ADDR = (EXTRA_OFFSET+52)
DEFENSEFORSE_ADDR = (EXTRA_OFFSET+56)
PASSION_ADDR = (EXTRA_OFFSET+60)
DEFENSEFORSEM_ADDR = (EXTRA_OFFSET+64)
SEIGAI_ADDR = (EXTRA_OFFSET+68)
KAZEYOKE_ADDR = (EXTRA_OFFSET+72)
YANDERE_ADDR = (EXTRA_OFFSET+76)
ONNASUKI_ADDR = (EXTRA_OFFSET+80)
DOUBLELION_ADDR = (EXTRA_OFFSET+84)

GetWarList:
    ldr r1, COMBAT_TBL_SIZE
    mul r0, r1
    ldr r1, COMBAT_TBL
    add r0, r0, r1
    bx lr

HasTrample:
    ldr r2, TRAMPLE_ADDR
    mov pc, r2

HasKishinR:
    ldr r2, HAS_KISHIN_R
    mov pc, r2
HasKongouR:
    ldr r2, HAS_KONGOU_R
    mov pc, r2
HasHienR:
    ldr r2, HAS_HIEN_R
    mov pc, r2
HasBreakerSw:
    ldr r2, addr+16
    mov pc, r2
HasBreakerSp:
    ldr r2, addr+20
    mov pc, r2
HasBreakerAx:
    ldr r2, addr+24
    mov pc, r2
HasBreakerBw:
    ldr r2, addr+28
    mov pc, r2
HasBreakerMg:
    ldr r2, addr+32
    mov pc, r2
HasHien:
    ldr r2, HIEN_ADDR
    mov pc, r2
HasKongou:
    ldr r2, addr+12
    mov pc, r2
HasKishin:
    ldr r2, addr+8
    mov pc, r2
HasIchibanSpear:
    ldr r2, ICHIBAN_ADDR
    mov pc, r2
HasKonshin:
    ldr r2, KONSHIN_ADDR
    mov pc, r2
HasShishi:
    ldr r2, SHISHI_ADDR
    mov pc, r2
HasDistantDef:
    ldr r2, (addr+40)
    mov pc, r2
HasCloseDef:
    ldr r2, (addr+36)
    mov pc, r2
HasCriticalUp:
    ldr r2, HAS_CRITICALUP_ADDR
    mov pc, r2
HasAvoidUp:
    ldr r2, HAS_AVOIDUP_ADDR
    mov pc, r2
HasAsUp:
    ldr r2, ASUP_ADDR
    mov pc, r2
HasBladeSession:
    ldr r2, BLADE_SESSION_ADDR
    mov pc, r2
HasShieldSession:
    ldr r2, SHIELD_SESSION_ADDR
    mov pc, r2
HAS_IMPREGNABLE_WALL:
    ldr r2, (addr+64)
    mov pc, r2
HasDaunt:
    ldr r2, DAUNT_ADDR
    mov pc, r2
HasHeartseeker:
    ldr r2, HEARTSEEKER_ADDR
    mov pc, r2
HasSavior:
    ldr r2, SAVIOR_ADDR
    mov pc, r2
HasMikiri:
    ldr r1, addr    @見切り
    mov pc, r1
HasAce:
    ldr r3, ACE_ADDR
    mov pc, r3
HasSolo:
    ldr r3, SOLO_ADDR
    mov pc, r3
HasShisen:
    ldr r3, SHISEN_ADDR
    mov pc, r3
HasFort:
    ldr r3, FORT_ADDR
    mov pc, r3
HasBond:
    ldr r3, HAS_BOND_ADDR
    mov pc, r3
HasFrenzy:
    ldr r3, FRENZY_ADDR
    mov pc, r3

Hasagitation:
	ldr r2, AGITATION_ADDR
	mov pc, r2
HasDomination:
	ldr r2, DOMINATION_ADDR
	mov pc, r2
HasNullify:
	ldr r2, NULLIFY_ADDR
	mov pc, r2
HasHitUp:
	ldr r2, HITUP_ADDR
	mov pc, r2
HasMiracle:
	ldr r2, MIRACLE_ADDR
	mov pc, r2
HasCalm:
	ldr r2, CALM_ADDR
	mov pc, r2
HasDefenseForce:
	ldr r2, DEFENSEFORSE_ADDR
	mov pc, r2
HasPassion:
	ldr r2, PASSION_ADDR
	mov pc, r2
HasDefenseForceM:
	ldr r2, DEFENSEFORSEM_ADDR
	mov pc, r2
HasSeigai:
	ldr r2, SEIGAI_ADDR
	mov pc, r2
HasKazeyoke:
	ldr r2, KAZEYOKE_ADDR
	mov pc, r2
HasYandere:
	ldr r2, YANDERE_ADDR
	mov pc, r2
HasOnnasuki:
	ldr r2, ONNASUKI_ADDR
	mov pc, r2
HasDoubleLion:
	ldr r2, DOUBLELION_ADDR
	mov pc, r2

GetAttackerAddr:
    ldr r0, =0x03004df0
    bx lr
GetWeaponSp:
    ldr r1, =0x080172f0
    mov pc, r1
GetArenaAddr:
    ldr r0, =0x0203a4d0
    bx lr
GetDistance:
    ldr r0, =0x0203a4d2
    bx lr
GetExistFlagR1:
    ldr r1, =0x1002C    @居ないフラグ+救出されている
    bx lr
.align
.ltorg
addr:

