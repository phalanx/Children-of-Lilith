Scriptname CoL_Spell_Excitement_OAroused_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_OAroused_Script Property OAroused Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.excitementCost
        return
    endif
    if OAroused.IsInterfaceActive()
        int ArousalIncrease = (configHandler.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
        CoL.Log("Increasing target OAroused Arousal by " + ArousalIncrease)
        OAroused.ModifyArousal(akTarget, ArousalIncrease)
    endif
EndEvent
