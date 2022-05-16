Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil

Actor Property playerRef Auto
Spell Property drainHealthSpell Auto
Spell[] Property levelOneSpells Auto

bool Property DebugLogging = true Auto Hidden

; Energy Properties
float Property playerEnergyCurrent = 100.0 Auto Hidden
float Property playerEnergyMax = 100.0 Auto Hidden

; Drain Properties
Actor[] Property activeDrainVictims Auto Hidden             ; List of active drain victims. Hopefully useful for uninstall process. 
float Property drainDurationInGameTime = 24.0 Auto Hidden   ; How long, in game hours, does the drain debuff last
float Property healthToDrain = 0.2 Auto Hidden              ; Percentage of health to drain from victim
float Property energyConversionRate = 0.5 Auto Hidden       ; Rate at which drained health is converted to Energy

; Tunable Power Values
float Property staminaBoostCost = 5.0 Auto Hidden    ; Per second Energy Cost of Stamina Boost Effect

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        if DebugLogging
            Debug.Trace("[CoL] Initializing")
        endif
        GrantSpells()
        Maintenance()
        GotoState("")
    EndEvent
EndState

Function GrantSpells()
    int i = 0
    while i < levelOneSpells.Length
        playerRef.AddSpell(levelOneSpells[i])
        i += 1
    endwhile
EndFunction

Function Maintenance()
    RegisterForEvents()
EndFunction

Function RegisterForEvents()
    RegisterForModEvent("CoL_startDrain", "StartDrain")
    RegisterForModEvent("CoL_endDrain", "EndDrain")

    if DebugLogging
        Debug.Trace("[CoL] Registered for CoL Drain Events")
    endif
EndFunction

Function AddActiveDrainVictim(Actor drainVictim)
    if DebugLogging
        Debug.Trace("[CoL] Adding Victim to activeDrainList")
    endif

    activeDrainVictims = PushActor(activeDrainVictims, drainVictim)

    if DebugLogging
        Debug.Trace("[CoL] List now contains:")
        int i = 0
        while i < activeDrainVictims.Length
            Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
            i += 1
        endwhile
    endif
EndFunction

Function RemoveActiveDrainVictim(Actor drainVictim)
    if DebugLogging
        Debug.Trace("[CoL] Removing Victim from activeDrainList")
    endif

    activeDrainVictims = RemoveActor(activeDrainVictims, drainVictim)
    
    if DebugLogging
        Debug.Trace("[CoL] List now contains:")
        int i = 0
        while i < activeDrainVictims.Length
            Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
            i += 1
        endwhile
    endif
EndFunction

float Function CalculateDrainAmount(Actor drainVictim)
    float victimHealth = drainVictim.GetActorValue("Health")
    return (victimHealth * healthToDrain)
EndFunction

Event StartDrain(Form draineeForm, string draineeName)
    Actor drainee = draineeForm as Actor

    if DebugLogging
        Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
    endif

    if drainee.HasSpell(DrainHealthSpell)
        if DebugLogging
            Debug.Trace("[CoL] " + draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
        endif

        Debug.Notification("Draining " + draineeName + " again would kill them")
        return
    endif
    drainee.AddSpell(DrainHealthSpell)

    float drainAmount = CalculateDrainAmount(drainee)
    float newPlayerEnergy = PlayerEnergyCurrent + (drainAmount * energyConversionRate)
    if newPlayerEnergy > PlayerEnergyMax
        playerEnergyCurrent = PlayerEnergyMax
    else
        playerEnergyCurrent = newPlayerEnergy
    endif
    if DebugLogging
        Debug.Trace("[CoL] Player Energy is now " + playerEnergyCurrent)
    endif
EndEvent

Event EndDrain(Form draineeForm)
    Actor drainee = draineeForm as Actor

    if DebugLogging
        Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
    endif
EndEvent
