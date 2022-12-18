Scriptname CoL_Spell_Suppression_OAroused_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OAroused_Script Property OAroused Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.suppressionCost
        return
    endif
    if OAroused.IsInterfaceActive()
        int ArousalDecrease = (CoL.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.suppressionLevelMult) as int)
        CoL.Log("Decreasing target OAroused Arousal by " + ArousalDecrease)
        OAroused.ModifyArousal(akTarget, (0 - ArousalDecrease))
    endif
EndEvent
