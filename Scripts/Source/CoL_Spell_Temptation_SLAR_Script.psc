Scriptname CoL_Spell_Temptation_SLAR_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_SLAR_Script Property SLAR Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.newTemptationCost
        return
    endif
    if SLAR.IsInterfaceActive()
        int slarIncrease = (configHandler.newTemptationBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.newTemptationLevelMult) as int)
        CoL.Log("Increasing target SLAR Exposure by " + slarIncrease) ; This gets multiplied by a configurable SLAR value
        SLAR.UpdateActorExposure(akTarget, slarIncrease)
    endif
EndEvent
