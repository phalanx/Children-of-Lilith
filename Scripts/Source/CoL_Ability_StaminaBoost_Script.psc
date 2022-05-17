Scriptname CoL_Ability_StaminaBoost_Script extends activemagiceffect

float staminaBoosted
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if Col.playerEnergyCurrent >= CoL.staminaBoostCost
        staminaBoosted = akTarget.GetActorValue("Stamina") * CoL.staminaBoostMult
        akTarget.ModActorValue("Stamina", staminaBoosted)
        RegisterForSingleUpdate(1.0)
    else
        Debug.Notification("Not enough energy")
        staminaBoosted = 0.0
        CoL.playerRef.RemoveSpell(CoL.StaminaBoost)
    endif
EndEvent

Event OnUpdate()
    if Col.playerEnergyCurrent < Col.staminaBoostCost
        if CoL.DebugLogging
            Debug.Trace("[CoL] Out of Energy")
        endif
        CoL.playerRef.RemoveSpell(CoL.StaminaBoost)
        return
    endif
    CoL.playerEnergyCurrent -= CoL.staminaBoostCost
    if CoL.DebugLogging
        Debug.Trace("[CoL] New Energy Level: " + CoL.playerEnergyCurrent)
    endif
    RegisterForSingleUpdate(1.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    akTarget.ModActorValue("Stamina", 0.0 - staminaBoosted)
EndEvent