Scriptname CoL_Spell_Suppression_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.suppressionCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= configHandler.suppressionCost
        if iArousal.IsInterfaceActive()
            int arousalDecrease = (configHandler.excitementBaseIncrease + (CoL.levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
            CoL.Log("Decreasing Player Arousal by " + arousalDecrease)
            iArousal.ModifyArousal(akTarget, 0 - arousalDecrease)
        endif
    endif
EndEvent