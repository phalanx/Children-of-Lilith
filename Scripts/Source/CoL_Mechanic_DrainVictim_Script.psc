Scriptname CoL_Mechanic_DrainVictim_Script extends activemagiceffect  

import StorageUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto

float healthDrained
string drainTargetName

Event OnEffectStart(Actor drainTarget, Actor akCaster)
    
    drainTargetName = drainTarget.GetLeveledActorBase().GetName()
    
    float drainTime
    if CoL.gentleDrainer
        drainTime = CoL.drainDurationInGameTime/2
    else
        drainTime = CoL.drainDurationInGameTime
    endif
    CoL.Log("Drain will last for " + drainTime +" in game hours")

    float removalDay
    if !drainTarget.IsInFaction(CoL.drainVictimFaction)
        ; If victim not in faction, store the removal day in StorageUtils
        removalday = CoL.GameDaysPassed.GetValue() + (drainTime / 24)
        drainTarget.AddToFaction(CoL.drainVictimFaction)
        SetFloatValue(drainTarget, "CoL_drainRemovalDay", removalday)
    else
        ; If victim is in a faction, get the removalDay from StorageUtils
        removalDay = GetFloatValue(drainTarget, "CoL_drainRemovalDay")
        if removalDay == 0.0
            CoL.Log(drainTargetName + " is a member of the drain faction but no removal day is set. Bailing...")
            return
        endif
    endif

    CoL.Log(drainTargetName + " has been drained")
    CoL.Log("Starting Health Value = " + drainTarget.GetActorValue("Health"))

    healthDrained = CoL.drainHandler.CalculateDrainAmount(drainTarget)
    drainTarget.ModActorValue("Health", 0.0 - healthDrained)

    CoL.Log("New Health Value = " + drainTarget.GetActorValue("Health"))
    CoL.Log("Drain will last until " + removalDay)
    CoL.Log("Current Game Day: " + CoL.GameDaysPassed.GetValue())

    if removalDay <= CoL.GameDaysPassed.GetValue()
        FinishDrain(drainTarget)
    else
        RegisterForSingleUpdateGameTime(drainTime)
        RegisterForModEvent("CoL_Uninitialize", "FinishDrain")
    endif
EndEvent

Event OnUpdateGameTime()
    FinishDrain(GetTargetActor())
EndEvent

Function FinishDrain(Actor drainTarget)
    drainTarget.RemoveSpell(CoL.DrainHealthSpell)
    drainTarget.RemoveFromFaction(CoL.drainVictimFaction)
EndFunction

Event OnEffectFinish(Actor drainTarget, Actor akCaster)
    CoL.Log(drainTargetName + " has finished being drained")
    CoL.Log("Starting Health Value = " + drainTarget.GetActorValue("Health"))
    
    drainTarget.ModActorValue("Health", healthDrained)

    CoL.Log("New Health Value = " + drainTarget.GetActorValue("Health"))
    CoL.Log("Drain Effect Removed")
EndEvent
