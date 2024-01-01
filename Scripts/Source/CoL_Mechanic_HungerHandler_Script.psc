Scriptname CoL_Mechanic_HungerHandler_Script extends ActiveMagicEffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
Spell Property starvationSpell Auto

float lastCheckTime = 0.0
int starvationStack = 0

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.Log("Hunger Effect - Started")
    lastCheckTime = CoL.GameDaysPassed.GetValue()
    Maintenance()
EndEvent

Function Maintenance()
    CoL.Log("Hunger Effect - Registering for Events")
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    RegisterForModEvent("CoL_configUpdated", "UpdateConfig")
    RegisterForSingleUpdate(30.0)
EndFunction

Event OnUpdate()
    float timePassed = CoL.GameDaysPassed.GetValue() - lastCheckTime
    float hungerAmount
    if configHandler.hungerIsPercent
        hungerAmount = (energyHandler.playerEnergyMax * (configHandler.dailyHungerAmount / 100)) * timePassed
    else
        hungerAmount = configHandler.dailyHungerAmount * timePassed
    endif
    if ((energyHandler.playerEnergyCurrent/energyHandler.playerEnergyMax ) * 100) < configHandler.hungerThreshold
        if configHandler.deadlyHunger
            CoL.playerRef.RemoveSpell(starvationSpell)
            starvationSpell.SetNthEffectMagnitude(0, configHandler.hungerDamageAmount * starvationStack)
            CoL.playerRef.AddSpell(starvationSpell, false)
            starvationStack += 1
        elseif CoL.playerRef.HasSpell(starvationSpell)
            CoL.playerRef.RemoveSpell(starvationSpell)
        endif
        if configHandler.hungerArousalEnabled
            iArousal.ModifyArousal(CoL.playerRef, configHandler.hungerArousalAmount)
        endif
        energyHandler.playerEnergyCurrent = 0
        CoL.Log("Starvation Stack: " + starvationStack)
    else
        starvationStack = 0
        CoL.playerRef.RemoveSpell(starvationSpell)
        energyHandler.playerEnergyCurrent -= hungerAmount
    endif
    lastCheckTime = CoL.GameDaysPassed.GetValue()
    RegisterForSingleUpdate(30.0)
EndEvent

Function OnEffectFinish(Actor akTarget, Actor akCaster)
    UnregisterForUpdate()
    CoL.playerRef.RemoveSpell(starvationSpell)
    CoL.Log("Hunger Effect - Stopped")
EndFunction