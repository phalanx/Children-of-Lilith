Scriptname CoL_Spell_Temptation_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.newTemptationCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= configHandler.newTemptationCost
        if iArousal.IsInterfaceActive()
            int arousalIncrease = (configHandler.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
            CoL.Log("Increasing "+ akTarget.GetDisplayName() + "'s Arousal by " + arousalIncrease)
            iArousal.ModifyArousal(akTarget, arousalIncrease)
        endif
    endif
EndEvent