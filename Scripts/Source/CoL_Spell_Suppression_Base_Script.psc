Scriptname CoL_Spell_Suppression_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if energyHandler.playerEnergyCurrent < configHandler.suppressionCost
        Debug.Notification("Not enough energy")
    else
        energyHandler.playerEnergyCurrent -= configHandler.suppressionCost
        if iArousal.IsInterfaceActive()
            int arousalDecrease = (configHandler.excitementBaseIncrease + (levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
            CoL.Log("Decreasing Player Arousal by " + arousalDecrease)
            iArousal.ModifyArousal(akTarget, 0 - arousalDecrease)
        endif
    endif
EndEvent