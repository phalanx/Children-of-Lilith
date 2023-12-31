Scriptname CoL_Mechanic_NPC_DrainHandler_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script configHandler
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

State Draining
    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
        float drainAmount = ((victimHealth * configHandler.healthDrainMult) + (arousal * configHandler.drainArousalMult))

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
            CoL.Log(draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
            Debug.Notification("Draining " + draineeName + " again would kill them")
            return
        endif
        
        float drainAmount = applyDrainSpell(drainee, arousal) * 0.1
        energyHandler.playerEnergyCurrent += drainAmount
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        CoL.Log("Recieved End Drain Event for " + (draineeForm as Actor).GetActorBase().GetName())
    EndEvent
EndState

State DrainingToDeath
    float Function CalculateDrainAmount(Actor drainVictim, float arousal=0.0)
        float victimHealth = drainVictim.GetActorValue("Health")
        return ((victimHealth * configHandler.healthDrainMult) + (arousal * configHandler.drainArousalMult)) * configHandler.drainToDeathMult
    EndFunction

    Event StartDrain(Form drainerForm, Form draineeForm, string draineeName, float arousal=0.0)
        Actor drainee = draineeForm as Actor

        CoL.Log("Recieved Start Drain Event for " + draineeName)
        CoL.Log("Drained by " + drainee.GetBaseObject().GetName())

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

        drainAmount = drainAmount * 0.1
        energyHandler.playerEnergyCurrent += drainAmount 
    EndEvent

    Event EndDrain(Form drainerForm, Form draineeForm)
        Actor drainee = draineeForm as Actor

        CoL.Log("Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
        CoL.Log("Killing")
        if drainee.isEssential()
            CoL.Log("Can't kill essential. Dealing damage instead")
            drainee.DamageActorValue("Health", drainee.GetActorValue("Health") + 1)
            return
        endif
        drainee.Kill(drainerForm as Actor)
    EndEvent

    Event OnEndState()
    EndEvent
EndState

Float Function applyDrainSpell(Actor drainee, float arousal)
    float drainAmount = CalculateDrainAmount(drainee, arousal)
    float removalday = CoL.GameDaysPassed.GetValue() + (configHandler.drainDurationInGameTime / 24)
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