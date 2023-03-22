Scriptname CoL_Ability_Transform_FX_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Idle Property SuccubusTransformationIdle Auto
Sound Property SuccubusTransformSound Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Game.ForceThirdPerson()
    SuccubusTransformSound.Play(akTarget)
    if !CoL.isTransformed
        float cost
        if CoL.safeTransformation
            cost = configHandler.becomeEtherealCost
            configHandler.becomeEtherealCost = 0
            CoL.playerRef.AddSpell(CoL.becomeEthereal, false)
        endif
        if configHandler.transformAnimation && CoL.succuRace == CoL.mortalRace
            Game.ForceThirdPerson()
            akTarget.PlayIdle(SuccubusTransformationIdle)
            Utility.Wait(5)
            Debug.SendAnimationEvent(akTarget, "IdleForceDefaultState")
        endif
        if CoL.safeTransformation
            CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
            configHandler.becomeEtherealCost = cost
        endif
        if configHandler.transformCost > 0
            CoL.transformDrain()
        endif
    endif
EndEvent