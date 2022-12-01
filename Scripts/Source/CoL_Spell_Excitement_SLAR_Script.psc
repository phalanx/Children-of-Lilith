Scriptname CoL_Spell_Excitement_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.excitementCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarIncrease = (CoL.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.excitementLevelMult) as int)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Increasing target SLAR Exposure by " + slarIncrease) ; This gets multiplied by a configurable SLAR value
        endif
        SLAR.UpdateActorExposure(akTarget, slarIncrease)
    endif
EndEvent
