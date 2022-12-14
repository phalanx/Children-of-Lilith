Scriptname CoL_Spell_Suppression_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.suppressionCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarDecrease = (CoL.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.suppressionLevelMult) as int)
        CoL.Log("Decreasing target SLAR Exposure by " + slarDecrease) ; This gets multiplied by a configurable SLAR value
        SLAR.UpdateActorExposure(akTarget, (0 - slarDecrease))
    endif
EndEvent
