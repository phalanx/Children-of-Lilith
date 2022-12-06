Scriptname CoL_Spell_Excitement_Toys_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.excitementCost
        return
    endif
    Bool ToysInstalled = Quest.GetQuest("toysframework")
    if ToysInstalled
        int rousingIncrease = (CoL.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.excitementLevelMult) as int)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Increasing target Toys Rousing by " + rousingIncrease) 
        endif
        ToysGlobal.ArousalAdjust(rousingIncrease)
    endif
EndEvent
