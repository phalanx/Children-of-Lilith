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
        Game.ForceThirdPerson()
        akTarget.PlayIdle(SuccubusTransformationIdle)
        Utility.Wait(5)
        Debug.SendAnimationEvent(akTarget, "IdleForceDefaultState")
        if CoL.safeTransformation
            CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
            CoL.becomeEtherealCost = cost
        endif
    endif
EndEvent