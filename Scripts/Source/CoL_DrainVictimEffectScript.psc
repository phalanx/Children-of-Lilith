Scriptname CoL_DrainVictimEffectScript extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

float healthDrained
Actor drainCaster
Actor drainTarget
string drainTargetName

; Consider registering for an event to allow for removal of all active effects
; This way I don't have to add the target to an array etc. for uninstall
Event OnEffectStart(Actor akTarget, Actor akCaster)
    drainTarget = akTarget
    drainCaster = akCaster

    if CoL.DebugLogging
        drainTargetName = drainTarget.GetLeveledActorBase().GetName()
        Debug.Trace("[CoL] " + drainTargetName + " has been drained")
        Debug.Trace("[CoL] Starting Health Value = " + drainTarget.GetActorValue("Health"))
    endif

    healthDrained = CoL.CalculateDrainAmount(drainTarget)
    drainTarget.ModActorValue("Health", 0.0 - healthDrained)
    CoL.AddActiveDrainVictim(drainTarget)
    RegisterForSingleUpdateGameTime(CoL.drainDurationInGameTime)

    if CoL.DebugLogging
        Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
    endif
EndEvent

Event OnUpdateGameTime()
    drainTarget.RemoveSpell(CoL.drainHealthSpell)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if CoL.DebugLogging
        Debug.Trace("[CoL] " + drainTargetName + " has finished being drained")
        Debug.Trace("[CoL] Starting Health Value = " + drainTarget.GetActorValue("Health"))
    endif
    
    drainTarget.ModActorValue("Health", healthDrained)
    CoL.RemoveActiveDrainVictim(drainTarget)

    if CoL.DebugLogging
        Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
        Debug.Trace("[CoL] Drain Effect Removed")
    endif
EndEvent