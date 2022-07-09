Scriptname CoL_Mechanic_SceneHandler_OS_Script extends activemagiceffect

OSexIntegrationMain Property oStim Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

import PapyrusUtil

Actor[] currentVictims ;List of victims in current scene that have been drained

Event OnEffectStart(Actor akTarget, Actor akCaster)
    currentVictims = new Actor[1]
    GoToState("Waiting")
EndEvent

Event OnPlayerLoadGame()
    currentVictims = new Actor[1]
    GoToState("Waiting")
EndEvent

State Waiting
    Event OnBeginState()

        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for OStim Events")
        endif

        RegisterForModEvent("ostim_start", "startScene")
    EndEvent

    Event startScene(string eventName, string strArg, float numArg, Form sender)

        if CoL.DebugLogging
            Debug.Trace("[CoL] OStim animation started")
        endif

        if !oStim.IsPlayerInvolved()
            return
        endif

        int sceneStartEvent = ModEvent.Create("CoL_startScene")
        if sceneStartEvent
            Debug.Trace("[CoL] Sending Scene Start Event")
            ModEvent.Send(sceneStartEvent)
        endif

        GoToState("Running")
    EndEvent

    Event OnEndState()
        UnregisterForModEvent("ostim_start")
    EndEvent

EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("ostim_orgasm", "orgasmHandler")
        RegisterForModEvent("ostim_totalend", "stopScene")
    EndEvent

    Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
        Actor victim = oStim.GetMostRecentOrgasmedActor()

        if victim == CoL.playerRef
            return
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Entered orgasm handler")
        endif
        
        triggerDrainStart(victim)
        if currentVictims.Find(victim) == -1
            currentVictims = PushActor(currentVictims, victim)
        endif

    EndEvent

    Event stopScene(string eventName, string strArg, float numArg, Form sender)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Player involved animation ended")
        endif

        int i = 0
        while i < currentVictims.Length
            triggerDrainEnd(currentVictims[i])
            i += 1
        endwhile

        GoToState("Waiting")
    EndEvent

    Event OnEndState()
        UnregisterForModEvent("ostim_orgasm")
        UnregisterForModEvent("ostim_totalend")
        currentVictims = new Actor[1]
    EndEvent

EndState

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + actorName)
    endif

    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.PushString(drainHandle, actorName)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain start event sent")
        endif
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain end for " + victim.GetBaseObject().GetName())
    endif

    int drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent")
        endif
    endif
EndFunction

Event startScene(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event stopScene(string eventName, string strArg, float numArg, Form sender)
EndEvent
