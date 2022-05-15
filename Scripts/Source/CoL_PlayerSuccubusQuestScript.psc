Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil

Actor Property PlayerRef Auto
Spell Property DrainHealthSpell Auto

float Property PlayerEnergyCurrent = 0.0 Auto Hidden
float Property PlayerEnergyMax = 100.0 Auto Hidden

Actor[] Property activeDrainVictims Auto Hidden
float Property drainDurationInGameTime = 24.0 Auto

Event OnInit()
    GotoState("Initialize")
EndEvent

; Use Initialize state to exit OnInit asap
; Not much is being done here so probably overkill right now
State Initialize
    Event OnBeginState()
        Debug.Trace("[CoL] Initializing")
        Maintenance()
        GotoState("")
    EndEvent

    Event OnInit()
    EndEvent
EndState

Function Maintenance()
    RegisterForEvents()
EndFunction

Function RegisterForEvents()
    RegisterForModEvent("CoL_startDrain", "StartDrain")
    RegisterForModEvent("CoL_endDrain", "EndDrain")
    Debug.Trace("[CoL] Registered for CoL Drain Events")
EndFunction

Function AddActiveDrainVictim(Actor drainVictim)
    Debug.Trace("[CoL] Adding Victim to activeDrainList")
    activeDrainVictims = PushActor(activeDrainVictims, drainVictim)
    Debug.Trace("[CoL] List now contains:")
    int i = 0
    while i < activeDrainVictims.Length
        Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
        i += 1
    endwhile
EndFunction

Function RemoveActiveDrainVictim(Actor drainVictim)
    Debug.Trace("[CoL] Removing Victim from activeDrainList")
    activeDrainVictims = RemoveActor(activeDrainVictims, drainVictim)
    Debug.Trace("[CoL] List now contains:")
    int i = 0
    while i < activeDrainVictims.Length
        Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
        i += 1
    endwhile
EndFunction

Event StartDrain(Form draineeForm)
    Actor drainee = draineeForm as Actor
    string draineeName = (drainee.GetBaseObject() as Actorbase).GetName()
    Debug.Trace("[CoL] Recieved Start Drain Event for " + draineeName)
    if activeDrainVictims.find(drainee) != -1
        Debug.Trace("[CoL] " + draineeName + " has already been drained and Drain to Death Not Enabled. Bailing...")
        Debug.Notification("Draining " + draineeName + " again would kill them")
        return
    endif
    drainee.AddSpell(DrainHealthSpell)
    float drainAmount = 10.0
    float newPlayerEnergy = PlayerEnergyCurrent + drainAmount
    if newPlayerEnergy > PlayerEnergyMax
        PlayerEnergyCurrent = PlayerEnergyMax
    else
        PlayerEnergyCurrent = newPlayerEnergy
    endif
    Debug.Trace("[CoL] Player Energy is now " + PlayerEnergyCurrent)
EndEvent

Event EndDrain(Form draineeForm)
    Actor drainee = draineeForm as Actor
    Debug.Trace("[CoL] Recieved End Drain Event for " + (drainee.GetBaseObject() as Actorbase).GetName())
EndEvent