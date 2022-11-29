Scriptname CoL_Spell_Temptation_OAroused_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OAroused_Script Property OAroused Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.temptationCost
        return
    endif
    if OAroused.IsInterfaceActive()
        int ArousalIncrease = (CoL.temptationBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.temptationLevelMult) as int)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Increasing player OAroused Arousal by " + ArousalIncrease)
        endif
        OAroused.ModifyArousal(akTarget, ArousalIncrease)
    endif
EndEvent
