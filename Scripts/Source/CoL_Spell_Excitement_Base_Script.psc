Scriptname CoL_Spell_Excitement_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.excitementCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= configHandler.excitementCost
        if iArousal.IsInterfaceActive()
            int arousalIncrease = (configHandler.excitementBaseIncrease + (levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
            CoL.Log("Increasing Player Arousal by " + arousalIncrease)
            iArousal.ModifyArousal(akTarget, arousalIncrease)
        endif
    endif
EndEvent