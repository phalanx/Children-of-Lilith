Scriptname CoL_Spell_Excitement_OSL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_OSL_Script Property OSL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.excitementCost
        return
    endif
    if OSL.IsInterfaceActive()
        float ArousalIncrease = (configHandler.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult)) as float
        CoL.Log("Increasing target OSL Arousal by " + ArousalIncrease)
        OSL.ModifyArousal(akTarget, ArousalIncrease, "Succubus Excitement")
    endif
EndEvent

