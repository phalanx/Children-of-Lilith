Scriptname CoL_Mechanic_HungerHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Spell Property starvationSpell Auto

float lastCheckTime = 0.0
int starvationStack = 0

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    RegisterForModEvent("CoL_configUpdated", "UpdateConfig")
EndFunction

State HungerEnabled
    Event OnBeginState()
        lastCheckTime = CoL.GameDaysPassed.GetValue()
        RegisterForSingleUpdate(30.0)
    EndEvent

    Event OnUpdate()
        float timePassed = CoL.GameDaysPassed.GetValue() - lastCheckTime
        float hungerAmount
        if configHandler.hungerIsPercent
            hungerAmount = (CoL.playerEnergyMax * (configHandler.dailyHungerAmount / 100)) * timePassed
        else
            hungerAmount = configHandler.dailyHungerAmount * timePassed
        endif
        if ((CoL.playerEnergyCurrent/CoL.playerEnergyMax ) * 100) < configHandler.hungerThreshold
            if configHandler.deadlyHunger
                CoL.playerRef.RemoveSpell(starvationSpell)
                starvationSpell.SetNthEffectMagnitude(0, configHandler.hungerDamageAmount * starvationStack)
                CoL.playerRef.AddSpell(starvationSpell, false)
                starvationStack += 1
            endif
            if configHandler.hungerArousalEnabled
                CoL.SLAR.UpdateActorExposure(CoL.playerRef, (configHandler.hungerArousalAmount as int))
                CoL.OAroused.ModifyArousal(CoL.playerRef, (configHandler.hungerArousalAmount as int))
                CoL.Toys.ArousalAdjust(configHandler.hungerArousalAmount as int)
                CoL.OSL.ModifyArousal(CoL.playerRef, configHandler.hungerArousalAmount as int, "Succubus Hunger")
            endif
            CoL.playerEnergyCurrent = 0
            CoL.Log("Starvation Stack: " + starvationStack)
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

Function UpdateConfig()
    if configHandler.hungerEnabled
        GoToState("HungerEnabled")
    else
        GoToState("HungerDisabled")
    endif
EndFunction