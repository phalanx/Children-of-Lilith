Scriptname CoL_Spell_Temptation_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(0.2)
    if CoL.playerEnergyCurrent < configHandler.temptationCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= configHandler.temptationCost
    endif
EndEvent