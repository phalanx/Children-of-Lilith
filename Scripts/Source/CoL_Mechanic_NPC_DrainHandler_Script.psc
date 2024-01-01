Scriptname CoL_Mechanic_NPC_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

VisualEffect Property drainToDeathVFX Auto

State Initialize
    Event OnBeginState()
        Maintenance()
    EndEvent
EndState

Function Maintenance()
    RegisterForModEvent("CoL_startDrain_NPC", "StartDrain")
    RegisterForModEvent("CoL_endDrain_NPC", "EndDrain")
    CoL.Log("Registered for CoL NPC Drain Events")
EndFunction

State Uninitialize
    Event OnBeginState()
        UnregisterForModEvent("CoL_startDrain_NPC")
        UnregisterForModEvent("CoL_endDrain_NPC")
        CoL.Log("Unregistered for CoL NPC Drain Events")
        GoToState("")
    EndEvent
EndState

Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    int random = Utility.RandomInt()
    int relationship = (drainerForm as Actor).GetRelationshipRank(draineeForm as Actor)
    if relationship < 0
        relationship = 0
    endif
    if relationship > 4
        relationship = 4
    endif
    if random < configHandler.npcRelationshipDeathChance[relationship]
        StorageUtil.SetIntValue(drainerForm,"CoL_NPC_drainType",1)
        DrainToDeath(drainerForm, draineeForm, draineeName, arousal)
    else
        StorageUtil.SetIntValue(drainerForm,"CoL_NPC_drainType",0)
        normalDrain(drainerForm, draineeForm, draineeName, arousal)
    endif
EndEvent

Event EndDrain(Form drainerForm, Form draineeForm)
    if StorageUtil.GetIntValue(drainerForm,"CoL_NPC_drainType") == 1
        EndDrainToDeath(drainerForm, draineeForm)
    else
        EndNormalDrain(drainerForm, draineeForm)
    endif
EndEvent

Function NormalDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    Actor drainee = draineeForm as Actor

    CoL.Log("Recieved Start Drain Event for " + draineeName)
    CoL.Log("Drained by " + (drainerForm as Actor).GetBaseObject().GetName())
    CoL.Log("Recieved Victim Arousal: " + arousal)

    if drainee.IsInFaction(CoL.drainVictimFaction)
        CoL.Log(draineeName + " has already been drained and Drain to Death Not Enabled.")
        return
    endif
    StorageUtil.SetIntValue(drainee, "CoL_activeParticipant", 1)
    float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
    applyDrainSpell(drainee, drainAmounts)
    
    energyHandler.playerEnergyCurrent += (drainAmounts[0] * configHandler.energyConversionRate)
EndFunction

Function EndNormalDrain(Form drainerForm, Form draineeForm)
    CoL.Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
    StorageUtil.UnsetIntValue(draineeForm, "CoL_activeParticipant")
    float drainAmount = StorageUtil.GetFloatValue((draineeForm as Actor), "CoL_drainAmount")
    (draineeForm as Actor).AddToFaction(CoL.drainVictimFaction)
EndFunction

Function DrainToDeath(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
    Actor drainee = draineeForm as Actor

    CoL.Log("Recieved Start Drain Event for " + draineeName)
    CoL.Log("Drained by " + drainee.GetBaseObject().GetName())

    float[] drainAmounts = CalculateDrainAmount(drainee, arousal)
    if drainee.isEssential()
        CoL.Log("Victim is essential")

        if drainee.IsInFaction(CoL.drainVictimFaction)
            CoL.Log("Victim has been drained")
            return
        else
            applyDrainSpell(drainee, drainAmounts)
        endif
    else
        drainToDeathVFX.Play(drainee, 1, (drainerForm as Actor))
    endif

    energyHandler.playerEnergyCurrent += (drainAmounts[0] * configHandler.energyConversionRate * configHandler.drainToDeathMult)
EndFunction

Function EndDrainToDeath(Form drainerForm, Form draineeForm)
    Actor drainee = draineeForm as Actor

    CoL.Log("Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
    CoL.Log("Killing")
    if drainee.isEssential()
        CoL.Log("Can't kill essential. Dealing damage instead")
        drainee.DamageActorValue("Health", drainee.GetActorValue("Health") + 1)
        return
    endif
    drainee.Kill(drainerForm as Actor)
EndFunction

Function applyDrainSpell(Actor drainee, float[] drainAmounts)
    drainee.RemoveSpell(CoL.drainHealthSpell)
    float drainDuration = configHandler.drainDurationInGameTime / 24
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

    float drainAmount = (victimHealth * configHandler.healthDrainMult)
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