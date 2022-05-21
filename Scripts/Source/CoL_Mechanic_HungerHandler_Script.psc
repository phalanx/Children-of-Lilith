Scriptname CoL_Mechanic_HungerHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
Spell Property starvationSpell Auto

float lastCheckTime = 0.0
int starvationStack = 0
State HungerEnabled
    Event OnBeginState()
        lastCheckTime = CoL.GameDaysPassed.GetValue()
        RegisterForSingleUpdate(30.0)
    EndEvent

    Event OnUpdate()
        float timePassed = CoL.GameDaysPassed.GetValue() - lastCheckTime
        float hungerAmount = CoL.dailyHungerAmount * timePassed
        if CoL.hungerDamageEnabled && CoL.playerEnergyCurrent < hungerAmount
            CoL.playerRef.RemoveSpell(starvationSpell)
            starvationSpell.SetNthEffectMagnitude(0, CoL.hungerDamageAmount * starvationStack)
            CoL.playerRef.AddSpell(starvationSpell, false)
            starvationStack += 1
            if CoL.DebugLogging
                Debug.Trace("[CoL] Starvation Stack: " + starvationStack)
            endif
            CoL.playerEnergyCurrent = 0
        else
            starvationStack = 0
            CoL.playerRef.RemoveSpell(starvationSpell)
            CoL.playerEnergyCurrent -= hungerAmount
        endif
        lastCheckTime = CoL.GameDaysPassed.GetValue()
        RegisterForSingleUpdate(30.0)
    EndEvent
EndState

State HungerDisabled
    Event OnBeginState()
        UnregisterForUpdate()
        CoL.playerRef.RemoveSpell(starvationSpell)
        lastCheckTime = 0.0
        starvationStack = 0
    EndEvent
EndState