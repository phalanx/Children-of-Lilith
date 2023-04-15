Scriptname CoL_Mechanic_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
VisualEffect Property drainToDeathVFX Auto
Perk Property gentleDrainer Auto
Perk Property slakeThirst Auto

bool draining_var = false
bool Property draining Hidden
    bool Function Get()
        return draining_var
    EndFunction
    Function Set(bool newVal)
        if draining_var != newVal
            draining_var = newVal
            CheckDraining(configHandler.drainNotificationsEnabled)
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
            CheckDraining(configHandler.drainNotificationsEnabled)
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
    CoL.widgetHandler.UpdateColor()
    CoL.Log("Finished Checking Drain State")
EndFunction

State Draining

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
        
        float drainAmount = CalculateDrainAmount(drainee, arousal)
        applyDrainSpell(drainee, drainAmount)
        float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)

        CoL.playerEnergyCurrent += (drainAmount * energyConversionMult)
        CoL.levelHandler.gainXP(drainAmount, false)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        CoL.Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
    EndEvent
EndState

State DrainingToDeath

    Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        CoL.Log("Recieved Start Drain Event for " + draineeName)
        CoL.Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())

        float drainAmount = CalculateDrainAmount(drainee, arousal)
        if drainee.isEssential()
            CoL.Log("Victim is essential")
            string notifyMsg = drainee.GetBaseObject().GetName() + " is protected by the weave of fate"

            if drainee.IsInFaction(CoL.drainVictimFaction)
                CoL.Log("Victim has been drained")
                notifyMsg = notifyMsg + " and cannot be drained again"
                Debug.Notification(notifyMsg)
                return
            else
                applyDrainSpell(drainee, drainAmount)
            endif
            Debug.Notification(notifyMsg)
        else
            drainToDeathVFX.Play(drainee, 1, (drainerForm as Actor))
        endif
        
        float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)
        
        CoL.playerEnergyCurrent += (drainAmount * energyConversionMult * configHandler.drainToDeathMult)
        CoL.levelHandler.gainXP(drainAmount, true)
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

EndState

Function doVampireDrain(Actor drainee)
    if CoL.playerRef.HasKeyword(vampireKeyword) && configHandler.drainFeedsVampire
        CoL.vampireHandler.Feed(drainee)
    endif
EndFunction

Function applyDrainSpell(Actor drainee, float drainAmount)
    float drainDuration = configHandler.drainDurationInGameTime / 24
    if CoL.playerRef.HasPerk(gentleDrainer)
        drainDuration = drainDuration / 2
    endif
    float removalday = CoL.GameDaysPassed.GetValue() + drainDuration
    StorageUtil.SetFloatValue(drainee, "CoL_drainAmount", drainAmount)
    StorageUtil.SetFloatValue(drainee, "CoL_drainRemovalDay", removalday)
    drainee.AddToFaction(CoL.drainVictimFaction)
    drainee.AddSpell(CoL.drainHealthSpell, false)
EndFunction

float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
    {Returns amount of health to drain from victim}
    float victimHealth = drainVictim.GetBaseActorValue("Health")
    float succubusArousal = 0.0

    if CoL.playerRef.HasPerk(slakeThirst)
        succubusArousal = CoL.GetActorArousal(CoL.playerRef)
        CoL.Log("Succubus Arousal: " + succubusArousal)
    endif

    float drainAmount = ((victimHealth * configHandler.healthDrainMult) + (arousal * configHandler.drainArousalMult) + (succubusArousal * configHandler.drainArousalMult))
    if drainAmount > victimHealth
        drainAmount = victimHealth - 1
    endif
    return drainAmount
EndFunction

Event StartDrain( Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
EndEvent
Event EndDrain(Form drainerForm, Form draineeForm)
EndEvent