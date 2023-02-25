Scriptname CoL_Spell_Excitement_OSL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OSL_Script Property OSL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.excitementCost
        return
    endif
    if OSL.IsInterfaceActive()
        float ArousalIncrease = (CoL.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.excitementLevelMult)) as float
        CoL.Log("Increasing target OSL Arousal by " + ArousalIncrease)
        OSL.ModifyArousal(akTarget, ArousalIncrease, "Succubus Excitement")
    endif
EndEvent

