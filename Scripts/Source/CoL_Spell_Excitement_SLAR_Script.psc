Scriptname CoL_Spell_Excitement_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.excitementCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarIncrease = (CoL.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.excitementLevelMult) as int)
        CoL.Log("Increasing target SLAR Exposure by " + slarIncrease) ; This gets multiplied by a configurable SLAR value
        SLAR.UpdateActorExposure(akTarget, slarIncrease)
    endif
EndEvent
