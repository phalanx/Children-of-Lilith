Scriptname CoL_Spell_Temptation_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if energyHandler.playerEnergyCurrent < configHandler.newTemptationCost
        Debug.Notification("Not enough energy")
    else
        energyHandler.playerEnergyCurrent -= configHandler.newTemptationCost
        if iArousal.IsInterfaceActive()
            int arousalIncrease = (configHandler.excitementBaseIncrease + (levelHandler.playerSuccubusLevel.GetValueInt() * configHandler.excitementLevelMult) as int)
            Log("Increasing "+ akTarget.GetDisplayName() + "'s Arousal by " + arousalIncrease)
            iArousal.ModifyArousal(akTarget, arousalIncrease)
        endif
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Spell - Temptation - " + msg)
EndFunction