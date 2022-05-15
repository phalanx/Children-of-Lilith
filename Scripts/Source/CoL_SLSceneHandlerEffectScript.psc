Scriptname CoL_SLSceneHandlerEffectScript extends activemagiceffect  

SexLabFramework Property SexLab Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    RegisterForEvents()
EndEvent

Event OnPlayerLoadGame()
    RegisterForEvents()
EndEvent

Function RegisterForEvents()
    ; Register for sexlab's player tracking so we know when a scene involving the player starts
    RegisterForModEvent("PlayerTrack_Start", "CoL_SLPlayerStartHandler")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for SexLab Player Start Scene Event")
    endif
EndFunction

Event CoL_SLPlayerStartHandler(Form actorRef, int threadID)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Player involved animation started")
    endif
    sslThreadController thread = SexLab.GetController(threadID)
    thread.SetHook("CoLSLSceneHook")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Added orgasm hook to thread")
    endif
    ; Register for thread specific SL Hooks
    RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for SexLab hook events")
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
            string actorName = actors[i].GetLeveledActorBase().GetName()
            if CoL.DebugLogging
                Debug.Trace("[CoL] Trigger drain start for " + actorName)
            endif
            int drainHandle = ModEvent.Create("CoL_startDrain")
            if drainHandle
                ModEvent.pushForm(drainHandle, actors[i])
                ModEvent.PushString(drainHandle, actorName)
                ModEvent.Send(drainHandle)
                if CoL.DebugLogging
                    Debug.Trace("[CoL] Drain start event sent")
                endif
            endif
        endif
        i += 1
    endwhile
EndEvent

Event CoL_SLAnimationEndHandler(int threadID, bool hasPlayer)
    sslThreadController thread = SexLab.GetController(threadID)
    Actor[] actors = thread.positions
    int i = 0
    while i < actors.Length
        if actors[i] != CoL.playerRef
            if CoL.DebugLogging
                Debug.Trace("[CoL] Trigger drain end for " + actors[i].GetBaseObject().GetName())
            endif
            int drainHandle = ModEvent.Create("CoL_endDrain")
            if drainHandle
                ModEvent.pushForm(drainHandle, actors[i])
                ModEvent.Send(drainHandle)
                if CoL.DebugLogging
                    Debug.Trace("[CoL] Drain end event sent")
                endif
            endif
        endif
        i += 1
    endwhile
EndEvent