Scriptname CoL_Mechanic_DrainVictim_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
Spell Property drainEffect Auto
GlobalVariable Property timeScale Auto
string drainTargetName

Event OnEffectStart(Actor drainTarget, Actor akCaster)
    CoL.Log(drainTarget.GetActorBase().GetName() + " has been drained")
    drainTargetName = drainTarget.GetLeveledActorBase().GetName()
    
    float removalDay
    if !drainTarget.IsInFaction(CoL.drainVictimFaction) && StorageUtil.GetIntValue(drainTarget, "CoL_activeParticipant") != 1
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

    if removalDay <= CoL.GameDaysPassed.GetValue()
        CoL.Log("Drain duration has elapsed. Removing Drain Victim Effect")
        FinishDrain(drainTarget)
        return
    endif

    float healthDrained = StorageUtil.GetFloatValue(drainTarget, "CoL_drainAmount")
    float drainDuration = ((removalDay - CoL.GameDaysPassed.GetValue()) * 24 * 60 * 60) / timeScale.GetValue()
    CoL.Log("Drain Amount: " + healthDrained)
    CoL.Log("Drain Duration in Real time: " + drainDuration)
    drainEffect.SetNthEffectMagnitude(0, healthDrained)
    drainEffect.SetNthEffectDuration(0, Math.floor(drainDuration))
    drainEffect.Cast(drainTarget)
EndEvent

Function FinishDrain(Actor drainTarget)
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainRemovalDay")
    StorageUtil.UnsetFloatValue(drainTarget, "CoL_drainAmount")
    drainTarget.RemoveFromFaction(CoL.drainVictimFaction)
    drainTarget.RemoveSpell(CoL.DrainHealthSpell)
EndFunction