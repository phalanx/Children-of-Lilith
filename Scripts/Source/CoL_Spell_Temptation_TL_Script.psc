Scriptname CoL_Spell_Temptation_TL_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if CoL.playerEnergyCurrent < configHandler.newTemptationCost
        return
    endif
    CoL.Log("Increasing target Toys-Rousing by Caressing") 
    CoL.Toys.Caress()
EndEvent
