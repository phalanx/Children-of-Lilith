Scriptname CoL_Mechanic_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
VisualEffect Property drainToDeathVFX Auto

bool draining_var = false
bool Property draining Hidden
    bool Function Get()
        return draining_var
    EndFunction
    Function Set(bool newVal)
        draining_var = newVal
        GoToState("CheckDraining")
    EndFunction
EndProperty
bool drainingToDeath_var = false
bool Property drainingToDeath Hidden
    bool Function Get()
        return drainingToDeath_var
    EndFunction
    Function Set(bool newVal)
        drainingToDeath_var = newVal
        GoToState("CheckDraining")
    EndFunction
EndProperty

Keyword Property vampireKeyword Auto Hidden

State Initialize
    Event OnBeginState()
        vampireKeyword = Keyword.GetKeyword("vampire")
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
            Debug.Notification("Draining To Death Disabled")
            Debug.Notification("Draining Enabled")
            GoToState("Draining")
        else 
            Debug.Notification("Draining To Death Disabled")
            Debug.Notification("Draining Disabled")
            GoToState("")
        endif
    EndEvent
EndState

State Draining
    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
        return ((victimHealth * CoL.healthDrainMult) + (arousal * CoL.drainArousalMult))
    EndFunction

    Event StartDrain(Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
            Debug.Trace("[CoL] Recieved Victim Arousal: " + arousal)
        endif

        if drainee.HasSpell(CoL.DrainHealthSpell)
            if CoL.DebugLogging
                Debug.Trace("[CoL] " + draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
            endif

            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif
        drainee.AddSpell(CoL.DrainHealthSpell)

        float drainAmount = CalculateDrainAmount(drainee, arousal)
        CoL.playerEnergyCurrent += drainAmount
        CoL.levelHandler.gainXP(false)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form draineeForm)
        if CoL.DebugLogging
            Actor drainee = draineeForm as Actor
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
        endif
    EndEvent
EndState

State DrainingToDeath
    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
        return ((victimHealth * CoL.healthDrainMult) + (arousal * CoL.drainArousalMult)) * CoL.drainToDeathMult
    EndFunction

    Event StartDrain(Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
            Debug.Trace("[CoL] Starting Deferred Kill")
        endif

        drainToDeathVFX.Play(drainee, 1)

        float drainAmount = CalculateDrainAmount(drainee, arousal)
        CoL.playerEnergyCurrent += drainAmount 
        CoL.levelHandler.gainXP(true)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form draineeForm)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
            Debug.Trace("[CoL] Ending Deferred Kill")
        endif

        drainee.Kill(CoL.playerRef)
    EndEvent

    Event OnEndState()
    EndEvent
EndState

Function doVampireDrain(Actor drainee)
    if CoL.playerRef.HasKeyword(vampireKeyword) && CoL.drainFeedsVampire
        CoL.vampireHandler.Feed(drainee)
    endif
EndFunction

; Empty Functions for Empty State
float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
EndFunction
Event StartDrain(Form draineeForm, string draineeName, float arousal=0.0)
EndEvent
Event EndDrain(Form draineeForm)
EndEvent