Scriptname CoL_Ability_HealRateBoost_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= Col.healRateBoostCost
        akTarget.ModActorValue("HealRate", CoL.healRateBoostMult)
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < Col.healRateBoostCost
        CoL.Log("Out of Energy")
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
        return
    endif
    CoL.playerEnergyCurrent -= CoL.healRateBoostCost
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    akTarget.ModActorValue("HealRate", 0.0 - CoL.healRateBoostMult)
EndEvent
