@
@���������X�L���A�j���[�V�������L�^����
@
.thumb
    push {r4,r5,lr}
	mov r4,r0  @RAMUnit
	mov r5,r1  @SkillID

	@���������X�L��ID���L�^������.
	@�����A�A�j���[�V�����������Ă��Ȃ��X�L��ID�͋L�^�������Ȃ�.
	ldr		r3,	adr	 @SkillAnimation* SkillAnimation[SKILL_ID] skillanimation@
	lsl		r1 ,r5 ,#0x2	@r1=skill_id << 2 (�|�C���^�Q�Ƃ��邽��)
	ldr		r3,[r3,r1]	 @skl_anime_table[skill_id].SkillAnime
	cmp		r3,#0x00
	beq		exit	@�A�j���[�V�����������Ă��Ȃ�

	@�A�j���������Ă���悤�Ȃ̂ŋL�^����
	ldr		r3, =0x0203AB40   @�ێ����Ă���Ɣ��肳�ꂽ�X�L��ID���L�^. �X�L�������̃A�j���[�V�������o�����ɗ��p����

	mov		r2,#0xB
	ldrb	r2,[r4,r2]	@UnitRAMPointer->�����\ID	�F�R+0x40	�G�R+0x80
	cmp		r2,#0x80
	blt		Player		@Player or Ally

Enemy:  @�G�R
	add		r3, #0x02		@�G�R
	@b		Join1

Player:  @���R(�܂��́A�F�R)
	@nop

@Join1
	@�h�q�X�L���ƍU���X�L���̕���
	cmp		r5, #0x01		@�参
	beq		DefenseSkill
	cmp		r5, #0x11		@����
	beq		DefenseSkill
	b		AttackSkill

DefenseSkill:
	add		r3,#0x01	@�h�q�X�L����+1����.
	@b		Join2

AttackSkill:
	@nop

@Join2:
	strb	r5, [r3]		@�X�L��ID�̋L�^
	
	@Player �U���X�L��	0203AB40
	@Player �h�q�X�L��	0203AB41
	@Enemy  �U���X�L��	0203AB42
	@Enemy  �h�q�X�L��	0203AB43
	@�U���X�L���Ɩh�q�X�L���������ɔ������邱�Ƃ�����̂ŕ�����.

exit:
	pop {r4,r5, pc}
.align 4
.ltorg
adr: