Scriptname CoL_Ability_HealRateBoost_Script extends activemagiceffect  

float healRateBoosted
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= Col.healRateBoostCost
        healRateBoosted = akTarget.GetActorValue("HealRate") * CoL.healRateBoostMult
        akTarget.ModActorValue("HealRate", healRateBoosted)
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        healRateBoosted = 0.0
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < Col.healRateBoostCost
        if CoL.DebugLogging
            Debug.Trace("[CoL] Out of Energy")
        endif
        Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
        CoL.playerRef.RemoveSpell(CoL.HealRateBoost)
        return
    endif
    CoL.playerEnergyCurrent -= CoL.healRateBoostCost
    if CoL.DebugLogging
        Debug.Trace("[CoL] New Energy Level: " + CoL.playerEnergyCurrent)
    endif
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    akTarget.ModActorValue("HealRate", 0.0 - healRateBoosted)
EndEvent
