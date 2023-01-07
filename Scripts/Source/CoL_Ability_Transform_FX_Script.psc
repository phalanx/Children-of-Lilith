Scriptname CoL_Ability_Transform_FX_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Idle Property SuccubusTransformationIdle Auto
Sound Property SuccubusTransformSound Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    SuccubusTransformSound.Play(akTarget)
    if !CoL.isTransformed
        float cost
        if CoL.safeTransformation
            cost = CoL.becomeEtherealCost
            CoL.becomeEtherealCost = 0
            CoL.playerRef.AddSpell(CoL.becomeEthereal, false)
        endif
        if CoL.safeTransformation
            CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
            CoL.becomeEtherealCost = cost
        endif
        if CoL.transformCost > 0
            CoL.transformDrain()
        endif
    endif
EndEvent