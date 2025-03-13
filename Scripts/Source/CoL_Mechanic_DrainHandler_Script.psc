Scriptname CoL_Mechanic_DrainHandler_Script extends ActiveMagicEffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_Mechanic_VampireHandler_Script Property vampireHandler Auto
CoL_UI_Widget_Script  Property widgetHandler Auto

Spell Property soulTrap Auto

VisualEffect Property drainToDeathVFX Auto
Perk Property gentleDrainer Auto
Perk Property slakeThirst Auto
Perk Property EssenceExtraction Auto
Perk[] Property DeadlyRevelry Auto
Perk[] Property MorbidRecovery Auto

bool drainStarted = false
bool draining = false
bool drainingToDeath = false

Keyword Property vampireKeyword Auto Hidden

Function Log(String msg)
    CoL.Log("Drain Handler - " + msg)
EndFunction

Event OnEffectStart(Actor akCaster, Actor akTarget)
    Log("Started")
    Maintenance()
EndEvent

Event OnEffectFinish(Actor akCaster, Actor akTarget)
    Log("Stopped")
EndEvent

Function Maintenance()
    Log("Maintenance Running")
    vampireKeyword = Keyword.GetKeyword("vampire")
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    RegisterForModEvent("CoL_startDrain", "StartDrain")
    RegisterForModEvent("CoL_endDrain", "EndDrain")
    RegisterForModEvent("CoL_Energy_Updated", "energyUpdated")
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
    RegisterForModEvent("CoL_Transform", "ProcessTransform")
    CheckDraining(false)
EndFunction

Function StartScene()
    RegisterForKey(configHandler.hotkeys[0])
    RegisterForKey(configHandler.hotkeys[1])
EndFunction

Function EndScene()
    UnRegisterForKey(configHandler.hotkeys[0])
    UnRegisterForKey(configHandler.hotkeys[1])
EndFunction

Event OnKeyDown(int keyCode)
    If  CoL_Global_Utils.IsMenuOpen()
        Return
    EndIf
    if keyCode == configHandler.hotkeys[0]
        if configHandler.lockDrainType
            return
        endif
        draining = !draining
    elseif keyCode == configHandler.hotkeys[1]
        if configHandler.lockDrainType
            return
        endif
        drainingToDeath = !drainingToDeath
    endif
    CheckDraining(true)
EndEvent

Function CheckDraining(bool verbose)
    verbose = verbose && configHandler.drainNotificationsEnabled 
    int drainCode = -1
    if drainingToDeath
        if verbose
            Debug.Notification("Draining To Death Enabled")
        endif
        GoToState("DrainingToDeath")
        drainCode = 2
    elseif draining
        if verbose
            Debug.Notification("Draining Enabled")
        endif
        GoToState("Draining")
        drainCode = 1
    else 
        if verbose
            Debug.Notification("Draining Disabled")
        endif
        GoToState("")
        drainCode = 0
    endif
    widgetHandler.UpdateColor(drainCode)
    Log("Finished Checking Drain State")
EndFunction

Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    UnRegisterForKey(configHandler.hotkeys[0])
    UnRegisterForKey(configHandler.hotkeys[1])
    drainStarted = True
    if drainingToDeath
        DrainToDeath(drainerForm, draineeForm, draineeName, arousal)
    elseif draining
        NormalDrain(drainerForm, draineeForm, draineeName, arousal)
    endif
EndEvent

Event EndDrain(Form drainerForm, Form draineeForm)
    if drainingToDeath
        EndDrainToDeath(drainerForm, draineeForm)
    elseif draining
        EndNormalDrain(drainerForm, draineeForm)
    endif
    drainStarted = False
    energyUpdated(energyHandler.playerEnergyCurrent, energyHandler.playerEnergyMax)
EndEvent

Function NormalDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    Actor drainee = draineeForm as Actor

    Log("Recieved Start Drain Event for " + draineeName)
    Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
    Log("Recieved Victim Arousal: " + arousal)

    if drainee.IsInFaction(CoL.drainVictimFaction) 
        Log(draineeName + " has been drained and Drain to Death not enabled")
        Debug.Notification("Draining " + draineeName + " again would kill them")
        return
    endif

    StorageUtil.SetIntValue(drainee, "CoL_activeParticipant", 1)
    float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
    processMorbidRecovery(drainAmounts[0])
    applyDrainSpell(drainee, drainAmounts)
    
    levelHandler.gainXP(drainAmounts[0], false)
    float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)

    energyHandler.playerEnergyCurrent += (drainAmounts[0] * energyConversionMult)
    doVampireDrain(drainee)
EndFunction

Function EndNormalDrain(Form drainerForm, Form draineeForm)
    Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
    StorageUtil.UnsetIntValue(draineeForm, "CoL_activeParticipant")
    (draineeForm as Actor).AddToFaction(CoL.drainVictimFaction)
EndFunction

Function DrainToDeath(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    Actor drainee = draineeForm as Actor

    Log("Recieved Start Drain To Death Event for " + draineeName)
    Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
    Log("Recieved Victim Arousal: " + arousal)

    float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
    processMorbidRecovery(drainAmounts[0])
    if drainee.isEssential()
        Log("Victim is essential")
        string notifyMsg = drainee.GetBaseObject().GetName() + " is protected by the weave of fate"
        if drainee.IsInFaction(CoL.drainVictimFaction)
            Log("Victim has been drained")
            notifyMsg = notifyMsg + " and cannot be drained again"
            Debug.Notification(notifyMsg)
            return
        else
            StorageUtil.SetIntValue(drainee, "CoL_activeParticipant", 1)
            applyDrainSpell(drainee, drainAmounts)
        endif
        Debug.Notification(notifyMsg)
    else
        drainToDeathVFX.Play(drainee, 1, (drainerForm as Actor))
    endif
    
    float energyConversionMult = configHandler.energyConversionRate + ((0.1 * CoL.efficientFeeder) * configHandler.energyConversionRate)
    
    float finalDrainToDeathMult = configHandler.drainToDeathMult
    if CoL.playerRef.HasPerk(DeadlyRevelry[2])
        finalDrainToDeathMult += configHandler.drainToDeathMult * 1
    elseif CoL.playerRef.HasPerk(DeadlyRevelry[1])
        finalDrainToDeathMult += configHandler.drainToDeathMult * 0.5
    elseif CoL.playerRef.HasPerk(DeadlyRevelry[0])
        finalDrainToDeathMult += configHandler.drainToDeathMult * 0.25
    endif

    energyHandler.playerEnergyCurrent += (drainAmounts[0] * energyConversionMult * finalDrainToDeathMult)
    levelHandler.gainXP(drainAmounts[0], true)
    doVampireDrain(drainee)
EndFunction

Function EndDrainToDeath(Form drainerForm, Form draineeForm)
    Utility.Wait(configHandler.drainToDeathDelay)
    Actor drainee = draineeForm as Actor
    string draineeName = (drainee.GetBaseObject() as Actorbase).GetName()

    if CoL.playerRef.HasPerk(EssenceExtraction)
        soulTrap.Cast(CoL.playerRef, drainee)
    endif

    Log("Recieved End Drain To Death Event for " + draineeName)
    Log("Killing " + draineeName)
    if drainee.isEssential()
        Log("Can't kill essential. Dealing damage instead")
        if drainee.IsInFaction(CoL.drainVictimFaction)
            Log("Victim already drained. Skipping...")
            return
        endif
        Log("Can't kill essential. Dealing damage instead")
        drainee.DamageActorValue("Health", drainee.GetActorValue("Health") + 1)
        StorageUtil.UnsetIntValue(draineeForm, "CoL_activeParticipant")
        (draineeForm as Actor).AddToFaction(CoL.drainVictimFaction)
        return
    endif
    if configHandler.drainToDeathCrime
        drainee.Kill(drainerForm as Actor)
    else
        drainee.Kill()
    endif
EndFunction

Function doVampireDrain(Actor drainee)
    if drainee != None && CoL.playerRef.HasKeyword(vampireKeyword) && configHandler.drainFeedsVampire
        vampireHandler.Feed(drainee)
    endif
EndFunction

Function processMorbidRecovery(float drainAmount)
    float playerHealthMax = CoL.playerRef.GetActorValueMax("Health")
    float playerStaminaMax = CoL.playerRef.GetActorValueMax("Stamina")
    float playerMagickaMax = CoL.playerRef.GetActorValueMax("Magicka")
    if CoL.playerRef.HasPerk(MorbidRecovery[1])
        CoL.playerRef.RestoreActorValue("Health", playerHealthMax)
        CoL.playerRef.RestoreActorValue("Stamina", playerStaminaMax)
        CoL.playerRef.RestoreActorValue("Magicka", playerMagickaMax)
    elseif CoL.playerRef.HasPerk(MorbidRecovery[0])
        CoL.playerRef.RestoreActorValue("Health", playerHealthMax/2)
        CoL.playerRef.RestoreActorValue("Stamina", playerStaminaMax/2)
        CoL.playerRef.RestoreActorValue("Magicka", playerMagickaMax/2)
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
        Log("Succubus Arousal: " + succubusArousal)
    endif

    float drainAmount = ((victimHealth * configHandler.healthDrainMult) + (arousal * configHandler.drainArousalMult) + (succubusArousal * configHandler.drainArousalMult))
    if drainAmount >= (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainAmount = (victimHealth - (victimHealth * configHandler.minHealthPercent))
    endif
    returnValues[0] = drainAmount

    float existingDrain = StorageUtil.GetFloatValue(drainVictim, "CoL_drainAmount")
    if existingDrain > 0
        Log("Existing drain value: " + existingDrain)
        drainAmount += existingDrain
    endif
    if drainAmount >= (victimHealth - (victimHealth * configHandler.minHealthPercent))
        drainAmount = (victimHealth - (victimHealth * configHandler.minHealthPercent)) 
    endif
    returnValues[1] = drainAmount

    Log("Final Drain Amount: " + drainAmount)
    return returnValues
EndFunction

Function energyUpdated(float newEnergy, float maxEnergy)
    if configHandler.deadlyDrainWhenTransformed && CoL.isTransformed
        return
    elseif drainStarted
        return
    endif
    float energyPercentage = ((newEnergy / maxEnergy) * 100) 
    if configHandler.forcedDrainToDeathMinimum != -1 && energyPercentage <= configHandler.forcedDrainToDeathMinimum
        drainingToDeath = true
    elseif configHandler.forcedDrainMinimum != -1 && energyPercentage <= configHandler.forcedDrainMinimum
        drainingToDeath = false
        draining = true
    elseif configHandler.forcedDrainToDeathMinimum != -1 && configHandler.forcedDrainMinimum != -1
        drainingToDeath = false
        draining = false
    endif
    CheckDraining(false)
EndFunction

Function ProcessTransform()
    if configHandler.deadlyDrainWhenTransformed 
        if CoL.isTransformed
            drainingToDeath = true
            CheckDraining(true)
        else
            drainingToDeath = false
            draining = true
            energyUpdated(energyHandler.playerEnergyCurrent, energyHandler.playerEnergyMax)
        endif
    endif
EndFunction