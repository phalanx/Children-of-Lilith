Scriptname CoL_Spell_Excitement_Toys_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.excitementCost
        return
    endif
    Bool ToysInstalled = Quest.GetQuest("toysframework")
    if ToysInstalled
        int rousingIncrease = (configHandler.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
        CoL.Log("Increasing target Toys Rousing by " + rousingIncrease) 
        ToysGlobal.ArousalAdjust(rousingIncrease)
    endif
EndEvent
