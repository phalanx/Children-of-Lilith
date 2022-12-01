Scriptname CoL_Spell_Suppression_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(0.2)
    if CoL.playerEnergyCurrent < CoL.suppressionCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= CoL.suppressionCost
    endif
EndEvent