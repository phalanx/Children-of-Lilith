Scriptname CoL_Spell_Temptation_Base_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(0.2)
    if CoL.playerEnergyCurrent < CoL.temptationCost
        Debug.Notification("Not enough energy")
    else
        CoL.playerEnergyCurrent -= CoL.temptationCost
    endif
EndEvent