Scriptname CoL_Mechanic_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
VisualEffect Property drainToDeathVFX Auto

bool draining_var = false
bool Property draining Hidden
    bool Function Get()
        return draining_var
    EndFunction
    Function Set(bool newVal)
        if draining_var != newVal
            draining_var = newVal
            CheckDraining(CoL.drainNotificationsEnabled)
        endif
    EndFunction
EndProperty
bool drainingToDeath_var = false
bool Property drainingToDeath Hidden
    bool Function Get()
        return drainingToDeath_var
    EndFunction
    Function Set(bool newVal)
        if drainingToDeath_var != newVal
            drainingToDeath_var = newVal
            CheckDraining(CoL.drainNotificationsEnabled)
        endif
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
    UnRegisterForModEvent("CoL_startDrain_NPC")
    UnRegisterForModEvent("CoL_endDrain_NPC")
    RegisterForModEvent("CoL_startDrain", "StartDrain")
    RegisterForModEvent("CoL_endDrain", "EndDrain")
    CoL.Log("Registered for CoL Drain Events")
EndFunction

State Uninitialize
    Event OnBeginState()
        UnregisterForModEvent("CoL_startDrain")
        UnregisterForModEvent("CoL_endDrain")
        CoL.Log("Unregistered for CoL Drain Events")
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
    CoL.Log("Finished Checking Drain State")
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

        CoL.Log("Recieved Start Drain Event for " + draineeName)
        CoL.Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
        CoL.Log("Recieved Victim Arousal: " + arousal)

        if drainee.IsInFaction(CoL.drainVictimFaction)
            CoL.Log(draineeName + " has already been drained and Drain to Death not enabled")
            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif
        
        float drainAmount = applyDrainSpell(drainee, arousal)

        CoL.playerEnergyCurrent += drainAmount
        CoL.levelHandler.gainXP(false)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        CoL.Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
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

        CoL.Log("Recieved Start Drain Event for " + draineeName)
        CoL.Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())

        float drainAmount
        if drainee.isEssential()
            CoL.Log("Victim is essential")
            string notifyMsg = drainee.GetBaseObject().GetName() + " is protected by the weave of fate"

            if drainee.IsInFaction(CoL.drainVictimFaction)
                CoL.Log("Victim has been drained")
                notifyMsg = notifyMsg + " and cannot be drained again"
                Debug.Notification(notifyMsg)
                return
            else
                drainAmount = applyDrainSpell(drainee, arousal)
            endif
            Debug.Notification(notifyMsg)
        else
            drainToDeathVFX.Play(drainee, 1, (drainerForm as Actor))
            drainAmount = CalculateDrainAmount(drainee, arousal)
        endif

        CoL.playerEnergyCurrent += drainAmount 
        CoL.levelHandler.gainXP(true)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        Actor drainee = draineeForm as Actor

        CoL.Log("Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
        CoL.Log("Killing")
        if drainee.isEssential()
            CoL.Log("Can't kill essential. Dealing damage instead")
            drainee.DamageActorValue("Health", 10000)
            return
        endif
        drainee.Kill(drainerForm as Actor)

    EndEvent

    Event OnEndState()
    EndEvent
EndState

Function doVampireDrain(Actor drainee)
    if CoL.playerRef.HasKeyword(vampireKeyword) && CoL.drainFeedsVampire
        CoL.vampireHandler.Feed(drainee)
    endif
EndFunction

Float Function applyDrainSpell(Actor drainee, float arousal)
    float drainAmount = CalculateDrainAmount(drainee, arousal)
    float removalday = CoL.GameDaysPassed.GetValue() + (coL.drainDurationInGameTime / 24)
    StorageUtil.SetFloatValue(drainee, "CoL_drainAmount", drainAmount)
    StorageUtil.SetFloatValue(drainee, "CoL_drainRemovalDay", removalday)
    drainee.AddToFaction(CoL.drainVictimFaction)
    drainee.AddSpell(CoL.drainHealthSpell, false)
    return drainAmount
EndFunction

float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
EndFunction
Event StartDrain( Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
EndEvent
Event EndDrain(Form drainerForm, Form draineeForm)
EndEvent