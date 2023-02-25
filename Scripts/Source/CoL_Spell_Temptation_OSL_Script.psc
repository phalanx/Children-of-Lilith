Scriptname CoL_Spell_Temptation_OSL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OSL_Script Property OSL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.temptationCost
        return
    endif
    if OSL.IsInterfaceActive()
        int arousalIncrease = (CoL.temptationBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.temptationLevelMult) as int)
        CoL.Log("Increasing target OSL Arousal by " + arousalIncrease) 
        OSL.ModifyArousal(akTarget, arousalIncrease, "Succubus Temptation")
    endif
EndEvent
