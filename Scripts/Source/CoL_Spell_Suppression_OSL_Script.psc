Scriptname CoL_Spell_Suppression_OSL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OSL_Script Property OSL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.suppressionCost
        return
    endif
    if OSL.IsInterfaceActive()
        int arousalDecrease = (CoL.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.suppressionLevelMult) as int)
        CoL.Log("Decreasing target OSL arousal by " + arousalDecrease) 
        OSL.ModifyArousal(akTarget, 0 - arousalDecrease, "Succubus Suppression")
    endif
EndEvent

