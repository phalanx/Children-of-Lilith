Scriptname CoL_Mechanic_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
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
            CoL.Log(draineeName + " has been drained and Drain to Death not enabled")
            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif

        StorageUtil.SetIntValue(drainee, "CoL_activeParticipant", 1)
        float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
        applyDrainSpell(drainee, drainAmounts)
        
        CoL.levelHandler.gainXP(drainAmounts[0], false)
        float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)

        CoL.playerEnergyCurrent += (drainAmounts[0] * energyConversionMult)
        doVampireDrain(drainee)
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        CoL.Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
        StorageUtil.UnsetIntValue(draineeForm, "CoL_activeParticipant")
        float drainAmount = StorageUtil.GetFloatValue((draineeForm as Actor), "CoL_drainAmount")
        (draineeForm as Actor).AddToFaction(CoL.drainVictimFaction)
    EndEvent
EndState

State DrainingToDeath

    Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        CoL.Log("Recieved Start Drain Event for " + draineeName)
        CoL.Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())

        float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
        if drainee.isEssential()
            CoL.Log("Victim is essential")
            string notifyMsg = drainee.GetBaseObject().GetName() + " is protected by the weave of fate"

            if drainee.IsInFaction(CoL.drainVictimFaction)
                CoL.Log("Victim has been drained")
                notifyMsg = notifyMsg + " and cannot be drained again"
                Debug.Notification(notifyMsg)
                return
            else
                applyDrainSpell(drainee, drainAmounts)
            endif
            Debug.Notification(notifyMsg)
        else
            drainToDeathVFX.Play(drainee, 1, (drainerForm as Actor))
        endif
        
        float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)
        
        CoL.playerEnergyCurrent += (drainAmounts[0] * energyConversionMult * configHandler.drainToDeathMult)
        CoL.levelHandler.gainXP(drainAmounts[0], true)
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

Function applyDrainSpell(Actor drainee, float[] drainAmounts)
    drainee.RemoveSpell(CoL.drainHealthSpell)
    float drainDuration = configHandler.drainDurationInGameTime / 24
    if CoL.playerRef.HasPerk(gentleDrainer)
        drainDuration = drainDuration / 2
    endif
    float removalday = CoL.GameDaysPassed.GetValue() + drainDuration
    StorageUtil.SetFloatValue(drainee, "CoL_drainAmount", drainAmounts[1])
    StorageUtil.SetFloatValue(drainee, "CoL_drainRemovalDay", removalday)
    drainee.RestoreActorValue("Health", drainAmounts[0]) ; Ensure victim isn't going to die
    drainee.AddSpell(CoL.drainHealthSpell, false)
EndFunction

float[] Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
    {
        Returns a two element array. The first element is the drain amount without
        any existing value. The second is with any existing value.
    }
    float[] returnValues = new float[2]
    float victimHealth = drainVictim.GetBaseActorValue("Health")
    float victimCurrentHealth = drainVictim.GetActorValue("Health")
    float succubusArousal = 0.0

    if CoL.playerRef.HasPerk(slakeThirst)
        succubusArousal = iArousal.GetActorArousal(CoL.playerRef)
        CoL.Log("Succubus Arousal: " + succubusArousal)
    endif

    float drainAmount = ((victimHealth * configHandler.healthDrainMult) + (arousal * configHandler.drainArousalMult) + (succubusArousal * configHandler.drainArousalMult))
    if drainAmount >= (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainAmount = (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainVictim.AddToFaction(CoL.drainVictimFaction)
    endif
    returnValues[0] = drainAmount

    float existingDrain = StorageUtil.GetFloatValue(drainVictim, "CoL_drainAmount")
    if existingDrain > 0
        CoL.Log("Existing drain value: " + existingDrain)
        drainAmount += existingDrain
    endif
    if drainAmount >= (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainAmount = (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainVictim.AddToFaction(CoL.drainVictimFaction)
    endif
    returnValues[1] = drainAmount

    CoL.Log("Final Drain Amount: " + drainAmount)
    return returnValues
EndFunction

Event StartDrain( Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
EndEvent
Event EndDrain(Form drainerForm, Form draineeForm)
EndEvent