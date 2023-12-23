Scriptname CoL_Ability_HealRateBoost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= configHandler.healRateBoostCost
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < configHandler.healRateBoostCost
        CoL.Log("Out of Energy")
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
        return
    endif
    CoL.playerEnergyCurrent -= configHandler.healRateBoostCost
    RegisterForSingleUpdate(1.0)
EndEvent
