Scriptname CoL_Spell_Excitement_OAroused_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OAroused_Script Property OAroused Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.excitementCost
        return
    endif
    if OAroused.IsInterfaceActive()
        int ArousalIncrease = (CoL.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.excitementLevelMult) as int)
        CoL.Log("Increasing target OAroused Arousal by " + ArousalIncrease)
        OAroused.ModifyArousal(akTarget, ArousalIncrease)
    endif
EndEvent
