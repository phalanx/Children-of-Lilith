Scriptname CoL_Mechanic_SceneHandler_SL_Script extends activemagiceffect  

import PapyrusUtil

SexLabFramework Property SexLab Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

bool SLSOInstalled
Actor[] currentVictims

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CheckForAddons()
    RegisterForEvents()
EndEvent

Event OnPlayerLoadGame()
    CheckForAddons()
    RegisterForEvents()
EndEvent

Function RegisterForEvents()
    ; Register for sexlab's player tracking so we know when a scene involving the player starts
    RegisterForModEvent("PlayerTrack_Start", "CoL_SLPlayerStartHandler")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for SexLab Player Start Scene Event")
    endif
EndFunction

Function CheckForAddons()
    SLSOInstalled = Quest.GetQuest("SLSO")
    if CoL.DebugLogging
        if SLSOInstalled
            Debug.Trace("[CoL] SLSO Detected")
        endif
    endif
EndFunction

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
        currentVictims = PushActor(currentVictims, victim)
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    int drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent for " + victim.GetLeveledActorBase().GetName())
        endif
    endif
EndFunction

Event CoL_SLPlayerStartHandler(Form actorRef, int threadID)
    int sceneStartEvent = ModEvent.Create("CoL_startScene")
    ModEvent.Send(sceneStartEvent)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Player involved animation started")
    endif
    sslThreadController thread = SexLab.GetController(threadID)
    thread.SetHook("CoLSLSceneHook")
    ; Register for thread specific SL Hooks
    if SLSOInstalled
        RegisterForModEvent("SexLabOrgasmSeparate", "SLSOOrgasmHandler")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for SLSO Orgasm Event")
        endif
    else
        if CoL.DebugLogging
            Debug.Trace("[CoL] Added orgasm hook to thread")
        endif
        RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    endif
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for SexLab events")
    endif
EndEvent

Event CoL_SLOrgasmHandler(int threadID, bool hasPlayer)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Entered orgasm handler")
    endif
    ; Unregister for thread specific SL Orgasm Hook
    ; This prevents the orgasm event being triggered for every actor in the scene
    UnregisterForModEvent("HookOrgasmEnd_CoLSLSceneHook")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Unregistered for Orgasm Event")
    endif
    sslThreadController thread = SexLab.GetController(threadID)
    Actor[] actors = thread.positions
    int i = 0
    while i < actors.Length
        if actors[i] != CoL.PlayerRef
            triggerDrainStart(actors[i])
        endif
        i += 1
    endwhile
EndEvent

Event CoL_SLAnimationEndHandler(int threadID, bool hasPlayer)

    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    ModEvent.Send(sceneEndEvent)
    sslThreadController thread = SexLab.GetController(threadID)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Player involved animation ended")
    endif
    UnregisterForModEvent("SexLabOrgasmSeparate")
    currentVictims = RemoveDupeActor(currentVictims)
    Actor[] actors = thread.positions
    int i = 0
    while i < actors.Length
        if actors[i] && actors[i] != CoL.playerRef && currentVictims.Find(actors[i]) != -1
            if CoL.DebugLogging
                Debug.Trace("[CoL] Trigger drain end for " + actors[i].GetBaseObject().GetName())
            endif
            triggerDrainEnd(actors[i])
        endif
        i += 1
    endwhile
    currentVictims = new Actor[1]
EndEvent

Event SLSOOrgasmHandler(Form ActorRef, Int threadID)
    Actor akActor = ActorRef as Actor
    string actorName = akActor.GetLeveledActorBase().GetName()
    if CoL.DebugLogging
        Debug.Trace("[CoL] Entered orgasm handler")
    endif
    if akActor != CoL.playerRef
        triggerDrainStart(akActor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Trigger drain start for " + actorName)
        endif
    endif
EndEvent