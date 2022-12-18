Scriptname CoL_Spell_Suppression_Toys_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < CoL.suppressionCost
        return
    endif
    Bool ToysInstalled = Quest.GetQuest("toysframework")
    if ToysInstalled
        int rousingDecrease = (CoL.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * CoL.suppressionLevelMult) as int)
        CoL.Log("Decreasing target Toys Rousing by " + rousingDecrease) 
        ToysGlobal.ArousalAdjust(0 - rousingDecrease)
    endif
EndEvent
