Scriptname CoL_Spell_Temptation_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.temptationCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarIncrease = (CoL.temptationBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.temptationLevelMult) as int)
        CoL.Log("Increasing target SLAR Exposure by " + slarIncrease) ; This gets multiplied by a configurable SLAR value
        SLAR.UpdateActorExposure(akTarget, slarIncrease)
    endif
EndEvent
