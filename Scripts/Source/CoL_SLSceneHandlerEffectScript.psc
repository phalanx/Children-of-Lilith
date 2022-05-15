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
    Debug.Trace("[CoL] Registered for SexLab Player Start Scene Event")

EndFunction

Event CoL_SLPlayerStartHandler(Form actorRef, int threadID)
    Debug.Trace("[CoL] Player involved animation started")
    sslThreadController thread = SexLab.GetController(threadID)
    thread.SetHook("CoLSLSceneHook")
    Debug.Trace("[CoL] Added orgasm hook to thread")
    ; Register for thread specific SL Hooks
    RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    Debug.Trace("[CoL] Registered for SexLab hook events")
EndEvent

Event CoL_SLOrgasmHandler(int threadID, bool hasPlayer)
    Debug.Trace("[CoL] Entered orgasm handler")
    ; Unregister for thread specific SL Orgasm Hook
    ; This prevents the orgasm event being triggered for every actor in the scene
    UnregisterForModEvent("HookOrgasmEnd_CoLSLSceneHook")
    Debug.Trace("[CoL] Unregistered for Orgasm Event")
    sslThreadController thread = SexLab.GetController(threadID)
    Actor[] actors = thread.positions
    int i = 0
    while i < actors.Length
        if actors[i] != CoL.PlayerRef
            Debug.Trace("[CoL] Trigger drain start for " + actors[i].GetBaseObject().GetName())
            int drainHandle = ModEvent.Create("CoL_startDrain")
            if drainHandle
                ModEvent.pushForm(drainHandle, actors[i])
                ModEvent.Send(drainHandle)
                Debug.Trace("[CoL] Drain start event sent")
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
        if actors[i] != CoL.PlayerRef
            Debug.Trace("[CoL] Trigger drain end for " + actors[i].GetBaseObject().GetName())
            int drainHandle = ModEvent.Create("CoL_endDrain")
            if drainHandle
                ModEvent.pushForm(drainHandle, actors[i])
                ModEvent.Send(drainHandle)
                Debug.Trace("[CoL] Drain end event sent")
            endif
        endif
        i += 1
    endwhile
EndEvent