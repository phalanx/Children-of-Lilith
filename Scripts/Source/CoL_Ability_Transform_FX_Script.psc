Scriptname CoL_Ability_Transform_FX_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Idle Property SuccubusTransformationIdle Auto
Sound Property SuccubusTransformSound Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    SuccubusTransformSound.Play(akTarget)
    if !CoL.isTransformed
        akTarget.PlayIdle(SuccubusTransformationIdle)
        Utility.Wait(5)
        Debug.SendAnimationEvent(akTarget, "IdleForceDefaultState")
    endif
EndEvent