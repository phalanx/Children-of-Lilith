Scriptname CoL_Mechanic_DrainVictim_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

float healthDrained
string drainTargetName

Event OnEffectStart(Actor drainTarget, Actor akCaster)
    
    drainTargetName = drainTarget.GetLeveledActorBase().GetName()
    
    float removalDay
    if !drainTarget.IsInFaction(CoL.drainVictimFaction)
        CoL.Log(drainTarget + " is not in drain victim faction. Removing Drain Victim Effect")
        FinishDrain(drainTarget)
        return
    else
        ; If victim is in a faction, get the removalDay from StorageUtils
        removalDay = StorageUtil.GetFloatValue(drainTarget, "CoL_drainRemovalDay")
        if removalDay == 0.0
            CoL.Log(drainTargetName + " is a member of the drain victim faction but no removal day is set. Removing Drain Victim Effect")
            FinishDrain(drainTarget)
            return
        endif
    endif

    CoL.Log(drainTargetName + " has been drained")
    CoL.Log("Starting Health Value: " + drainTarget.GetActorValue("Health"))

    healthDrained = StorageUtil.GetFloatValue(drainTarget, "CoL_drainAmount")
    drainTarget.ModActorValue("Health", 0.0 - healthDrained)

    CoL.Log("Drain Amount: " + healthDrained)
    CoL.Log("New Health Value: " + drainTarget.GetActorValue("Health"))
    CoL.Log("Drain will last until " + removalDay)
    CoL.Log("Current Game Day: " + CoL.GameDaysPassed.GetValue())

    if removalDay <= CoL.GameDaysPassed.GetValue()
        FinishDrain(drainTarget)
        return
    else
        float drainTime = (removalDay - CoL.GameDaysPassed.GetValue()) * 24
        RegisterForSingleUpdateGameTime(drainTime)
        RegisterForModEvent("CoL_Uninitialize", "FinishDrain")
    endif
EndEvent

Event OnUpdateGameTime()
    FinishDrain(GetTargetActor())
EndEvent

Function FinishDrain(Actor drainTarget)
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainRemovalDay")
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainAmount")
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
