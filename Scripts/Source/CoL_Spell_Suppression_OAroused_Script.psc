Scriptname CoL_Spell_Suppression_OAroused_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_OAroused_Script Property OAroused Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.suppressionCost
        return
    endif
    if OAroused.IsInterfaceActive()
        int ArousalDecrease = (configHandler.suppressionBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.suppressionLevelMult) as int)
        CoL.Log("Decreasing target OAroused Arousal by " + ArousalDecrease)
        OAroused.ModifyArousal(akTarget, (0 - ArousalDecrease))
    endif
EndEvent
