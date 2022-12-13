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
        CheckDraining(CoL.drainNotificationsEnabled)
    EndFunction
EndProperty
bool drainingToDeath_var = false
bool Property drainingToDeath Hidden
    bool Function Get()
        return drainingToDeath_var
    EndFunction
    Function Set(bool newVal)
        drainingToDeath_var = newVal
        CheckDraining(CoL.drainNotificationsEnabled)
    EndFunction
EndProperty

Keyword Property vampireKeyword Auto Hidden

State Initialize
    Event OnBeginState()
        Maintenance()
        CheckDraining(false)
    EndEvent
EndState

Function Maintenance()
    vampireKeyword = Keyword.GetKeyword("vampire")
    RegisterForModEvent("CoL_startDrain", "StartDrain")
    RegisterForModEvent("CoL_endDrain", "EndDrain")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for CoL Drain Events")
    endif
EndFunction

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

Function CheckDraining(bool verbose)
    if drainingToDeath
        if verbose
            Debug.Notification("Draining To Death Enabled")
        endif
        GoToState("DrainingToDeath")
    elseif draining
        if verbose
            Debug.Notification("Draining Enabled")
        endif
        GoToState("Draining")
    else 
        if verbose
            Debug.Notification("Draining Disabled")
        endif
        GoToState("")
    endif
    CoL.widgetHandler.GoToState("UpdateMeter")
    Debug.Trace("[CoL] Finished Checking Drain State")
EndFunction

State Draining
    Event OnBeginState()
        CoL.widgetHandler.UpdateColor()
    EndEvent

    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
        float succubusArousal = 0.0

        if CoL.slakeThirst
            if CoL.SLAR.IsInterfaceActive() && CoL.OAroused.IsInterfaceActive()
                succubusArousal = (CoL.SLAR.GetActorArousal(CoL.playerRef) + CoL.OAroused.GetArousal(CoL.playerRef)) / 2
            elseif CoL.OAroused.IsInterfaceActive()
                succubusArousal = CoL.OAroused.GetArousal(CoL.playerRef)
            elseif CoL.SLAR.IsInterfaceActive()
                succubusArousal = CoL.SLAR.GetActorArousal(CoL.playerRef)
            endif
        endif

        float drainAmount = ((victimHealth * CoL.healthDrainMult) + (arousal * CoL.drainArousalMult) + (succubusArousal * CoL.drainArousalMult))
        if drainAmount > victimHealth
            return victimHealth - 1
        else
            return drainAmount
        endif
    EndFunction

    Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
            Debug.Trace("[CoL] Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
            Debug.Trace("[CoL] Recieved Victim Arousal: " + arousal)
        endif

        if drainee.IsInFaction(CoL.drainVictimFaction)
            if CoL.DebugLogging
                Debug.Trace("[CoL] " + draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
            endif

            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif
        
        ; int effectDuration = ((CoL.drainDurationInGameTime * 60 * 60) / CoL.TimeScale.getValueInt()) as int
        ; CoL.drainHealthSpell.SetNthEffectDuration(0, effectDuration)
        ; CoL.drainHealthSpell.SetNthEffectMagnitude(0, drainAmount)
        float drainAmount = CalculateDrainAmount(drainee, arousal)
        drainee.AddSpell(CoL.drainHealthSpell)

        ; if CoL.DebugLogging
        ;     Debug.Trace("[CoL] Drain Amount: " + drainAmount)
        ; endif
        ; CoL.drainHealthSpell.Cast(drainee, drainee)

        if (drainerForm as Actor) != CoL.playerRef
            drainAmount = drainAmount * 0.1
        endif
        CoL.playerEnergyCurrent += drainAmount
        if (drainerForm as Actor) == CoL.playerRef
            CoL.levelHandler.gainXP(false)
            doVampireDrain(drainee)
        endif
    EndEvent

    Event EndDrain(Form draineeForm)
        if CoL.DebugLogging
            Actor drainee = draineeForm as Actor
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
        endif
    EndEvent
EndState

State DrainingToDeath
    Event OnBeginState()
        CoL.widgetHandler.UpdateColor()
    EndEvent
    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
         float succubusArousal = 0.0

        if CoL.slakeThirst
            if CoL.SLAR.IsInterfaceActive() && CoL.OAroused.IsInterfaceActive()
                succubusArousal = (CoL.SLAR.GetActorArousal(CoL.playerRef) + CoL.OAroused.GetArousal(CoL.playerRef)) / 2
            elseif CoL.OAroused.IsInterfaceActive()
                succubusArousal = CoL.OAroused.GetArousal(CoL.playerRef)
            elseif CoL.SLAR.IsInterfaceActive()
                succubusArousal = CoL.SLAR.GetActorArousal(CoL.playerRef)
            endif
        endif

        return ((victimHealth * CoL.healthDrainMult) + (arousal * CoL.drainArousalMult) + (succubusArousal * CoL.drainArousalMult)) * CoL.drainToDeathMult
    EndFunction

    Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
            Debug.Trace("[CoL] Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
        endif

        drainToDeathVFX.Play(drainee, 1)

        float drainAmount = CalculateDrainAmount(drainee, arousal)
        if (drainerForm as Actor) != CoL.playerRef
            drainAmount = drainAmount * 0.1
        endif
        CoL.playerEnergyCurrent += drainAmount 
        if (drainerForm as Actor) == CoL.playerRef
            CoL.levelHandler.gainXP(true)
            doVampireDrain(drainee)
        endif
    EndEvent

    Event EndDrain(Form draineeForm)
        Actor drainee = draineeForm as Actor

        if CoL.DebugLogging
            Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
            Debug.Trace("[CoL] Killing")
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
Event StartDrain( Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
EndEvent
Event EndDrain(Form draineeForm)
EndEvent