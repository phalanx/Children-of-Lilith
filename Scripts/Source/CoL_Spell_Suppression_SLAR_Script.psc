Scriptname CoL_Spell_Suppression_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.suppressionCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarDecrease = (configHandler.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.suppressionLevelMult) as int)
        CoL.Log("Decreasing target SLAR Exposure by " + slarDecrease) ; This gets multiplied by a configurable SLAR value
        SLAR.UpdateActorExposure(akTarget, (0 - slarDecrease))
    endif
EndEvent
