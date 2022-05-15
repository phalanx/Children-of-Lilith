Scriptname CoL_DrainVictimEffectScript extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

float healthDrained
Actor drainCaster
Actor drainTarget

Event OnEffectStart(Actor akTarget, Actor akCaster)
    drainTarget = akTarget
    drainCaster = akCaster

    Debug.Trace("[CoL] "+ (drainTarget.GetBaseObject() as Actorbase).GetName() + " has been drained")
    Debug.Trace("[CoL] Starting Health Value = " + drainTarget.GetActorValue("Health"))

    healthDrained = 10.0
    drainTarget.ModActorValue("Health", 0.0 - healthDrained)
    CoL.AddActiveDrainVictim(drainTarget)
    RegisterForSingleUpdateGameTime(CoL.drainDurationInGameTime)

    Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
EndEvent

Event OnUpdateGameTime()
    Debug.Trace("[CoL] " + (drainTarget.GetBaseObject() as Actorbase).GetName() + " has finished being drained")
    Debug.Trace("[CoL] Starting Health Value = " + drainTarget.GetActorValue("Health"))
    
    drainTarget.ModActorValue("Health", healthDrained)
    drainTarget.RemoveSpell(CoL.DrainHealthSpell)
    CoL.RemoveActiveDrainVictim(drainTarget)

    Debug.Trace("[CoL] New Health Value = " + drainTarget.GetActorValue("Health"))
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Debug.Trace("[CoL] Drain Effect Removed")
EndEvent