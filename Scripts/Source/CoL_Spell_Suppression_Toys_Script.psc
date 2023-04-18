Scriptname CoL_Spell_Suppression_Toys_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.suppressionCost
        return
    endif
    Bool ToysInstalled = Quest.GetQuest("toysframework")
    if ToysInstalled
        int rousingDecrease = (configHandler.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.suppressionLevelMult) as int)
        CoL.Log("Decreasing target Toys Rousing by " + rousingDecrease) 
        CoL.Toys.ArousalAdjust(0 - rousingDecrease)
    endif
EndEvent
