Scriptname CoL_Spell_Suppression_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(0.2)
    if CoL.playerEnergyCurrent < configHandler.suppressionCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= configHandler.suppressionCost
    endif
EndEvent