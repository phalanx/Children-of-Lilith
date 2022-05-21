Scriptname CoL_Mechanic_DrainVictim_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

float healthDrained
Actor drainCaster
Actor drainTarget
string drainTargetName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    drainTarget = akTarget
    drainCaster = akCaster

    if CoL.DebugLogging
        drainTargetName = drainTarget.GetLeveledActorBase().GetName()
        Debug.Trace("[CoL] " + drainTargetName + " has been drained")
        Debug.Trace("[CoL] Starting Health Value = " + drainTarget.GetActorValue("Health"))
    endif

    healthDrained = CoL.drainHandler.CalculateDrainAmount(drainTarget)
    drainTarget.ModActorValue("Health", 0.0 - healthDrained)
    RegisterforModEvent("CoL_Uninitialize", "OnCoLUninitialize")
    RegisterForSingleUpdateGameTime(CoL.drainDurationInGameTime)

    if CoL.DebugLogging
        Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
        Debug.Trace("[CoL] Drain will last for " + CoL.drainDurationInGameTime +" in game hours")
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

    if CoL.DebugLogging
        Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
        Debug.Trace("[CoL] Drain Effect Removed")
    endif
EndEvent

Event OnCoLUninitialize()
    Dispel()
EndEvent