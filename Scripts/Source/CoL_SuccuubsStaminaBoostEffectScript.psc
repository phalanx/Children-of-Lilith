Scriptname CoL_SuccuubsStaminaBoostEffectScript extends activemagiceffect  

float staminaBoosted
CoL_PlayerSuccubusQuestScript Property CoL Auto
Spell Property StaminaBoostSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= Col.staminaBoostCost
        Debug.Notification("Stamina Boost Enabled")
        staminaBoosted = akTarget.GetActorValue("Stamina")
        akTarget.ModActorValue("Stamina", staminaBoosted)
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Not enough energy")
        staminaBoosted = 0.0
        CoL.playerRef.RemoveSpell(StaminaBoostSpell)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < Col.staminaBoostCost
        if CoL.DebugLogging
            Debug.Trace("[CoL] Out of Energy")
        endif
        CoL.playerRef.RemoveSpell(StaminaBoostSpell)
        return
    endif
    CoL.playerEnergyCurrent -= CoL.staminaBoostCost
    if CoL.DebugLogging
        Debug.Trace("[CoL] New Energy Level: " + CoL.playerEnergyCurrent)
    endif
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.Notification("Stamina Boost Disabled")
    akTarget.ModActorValue("Stamina", 0.0 - staminaBoosted)
EndEvent