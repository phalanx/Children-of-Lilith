Scriptname CoL_Mechanic_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto

bool draining_var = false
bool Property draining 
    bool Function Get()
        return draining_var
    EndFunction
    Function Set(bool newVal)
        draining_var = newVal
        GoToState("CheckDraining")
    EndFunction
EndProperty
bool drainingToDeath_var = false
bool Property drainingToDeath
    bool Function Get()
        return drainingToDeath_var
    EndFunction
    Function Set(bool newVal)
        drainingToDeath_var = newVal
        GoToState("CheckDraining")
    EndFunction
EndProperty

State Initialize
    Event OnBeginState()
        RegisterForModEvent("CoL_startDrain", "StartDrain")
        RegisterForModEvent("CoL_endDrain", "EndDrain")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for CoL Drain Events")
        endif
        GoToState("CheckDraining")
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        UnregisterForModEvent("CoL_startDrain")
        UnregisterForModEvent("CoL_endDrain")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Unregistered for CoL Drain Events")
        endif
        GoToState("")
    EndEvent
EndState

State CheckDraining
    Event OnBeginState()
        if drainingToDeath
            Debug.Notification("Draining To Death Enabled")
            GoToState("DrainingToDeath")
        elseif draining
            Debug.Notification("Draining Enabled")
            GoToState("Draining")
        else 
            Debug.Notification("Draining Disabled")
            GoToState("")
        endif
    EndEvent
EndState

State Draining
    float Function CalculateDrainAmount(Actor drainVictim)
        float victimHealth = drainVictim.GetActorValue("Health")
        return (victimHealth * CoL.healthDrainMult)
    EndFunction

    Event StartDrain(Form draineeForm, string draineeName)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
        endif

        if drainee.HasSpell(CoL.DrainHealthSpell)
            if CoL.DebugLogging
                Debug.Trace("[CoL] " + draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
            endif

            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif
        drainee.AddSpell(CoL.DrainHealthSpell)

        float drainAmount = CalculateDrainAmount(drainee)
        CoL.playerEnergyCurrent += drainAmount
    EndEvent

    Event EndDrain(Form draineeForm)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
        endif
    EndEvent
EndState

State DrainingToDeath
    float Function CalculateDrainAmount(Actor drainVictim)
        float victimHealth = drainVictim.GetActorValue("Health")
        return (victimHealth * CoL.healthDrainMult) * CoL.drainToDeathMult
    EndFunction

    Event StartDrain(Form draineeForm, string draineeName)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
            Debug.Trace("[CoL] Starting Deferred Kill")
        endif

        drainee.StartDeferredKill()
        drainee.Kill(CoL.playerRef)

        float drainAmount = CalculateDrainAmount(drainee)
        CoL.playerEnergyCurrent += drainAmount 
    EndEvent

    Event EndDrain(Form draineeForm)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
            Debug.Trace("[CoL] Ending Deferred Kill")
        endif

        drainee.EndDeferredKill()
    EndEvent

    Event OnEndState()
        Debug.Notification("Draining To Death Disabled")
    EndEvent
EndState

; Empty Functions for Empty State
float Function CalculateDrainAmount(Actor drainVictim)
EndFunction
Event StartDrain(Form draineeForm, string draineeName)
EndEvent
Event EndDrain(Form draineeForm)
EndEvent