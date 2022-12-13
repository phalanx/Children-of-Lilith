Scriptname CoL_Mechanic_SceneHandler_SL_Script extends activemagiceffect  

import PapyrusUtil

CoL_Interface_SexLab_Script Property SexLab Auto
CoL_Interface_SLAR_Script Property SLAR Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

bool SexLabInstalled
bool SLSOInstalled
bool SLARInstalled
Actor[] currentVictims
Actor succubus
String succubusName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Maintenance()
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    SexLabInstalled = SexLab.IsInterfaceActive()
    if !SexLabInstalled
        return
    endif
    if CoL.DebugLogging
        Debug.Trace("[CoL] SexLab detected")
    endif

    succubus = GetTargetActor()
    if succubus == None
        Dispel()
    endif
    succubusName = succubus.GetActorBase().GetName()

    CheckForAddons()
    RegisterForEvents()
EndFunction

Function RegisterForEvents()
    ; Register for sexlab's tracking so we know when a scene involving the succubus starts
    if succubus == CoL.playerRef
        RegisterForModEvent("PlayerTrack_Start", "SceneStartHandler")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for SexLab Player Start Scene Event")
        endif
    elseif succubus != None
        SexLab.TrackActor(succubus,"CoL_" + succubusName + "Track")
        RegisterForModEvent("CoL_" + succubusName + "Track_Start", "SceneStartHandler")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for SexLab " + succubusName + " Start Scene Event")
        endif
    endif
EndFunction

Function CheckForAddons()
    SLSOInstalled = Quest.GetQuest("SLSO")
    SLARInstalled = SLAR.IsInterfaceActive()
    if CoL.DebugLogging
        if SLSOInstalled
            Debug.Trace("[CoL] SLSO Detected")
        endif
        if SLARInstalled
            Debug.Trace("[CoL] SLAR Detected")
        endif
    endif
EndFunction

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + actorName)
    endif
    float arousal = 0.0
    if SLARInstalled
        arousal = (SLAR.GetActorArousal(victim) as float)
    endif

    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.PushString(drainHandle, actorName)
        ModEvent.PushFloat(drainHandle, arousal)
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
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain end event sent for " + victim.GetLeveledActorBase().GetName())
    endif
EndFunction

Event SceneStartHandler(Form actorRef, int threadId)
    int sceneStartEvent = ModEvent.Create("CoL_startScene")
    ModEvent.Send(sceneStartEvent)
    if CoL.DebugLogging
        Debug.Trace("[CoL] "+ succubusName +" involved animation started")
    endif
    SexLab.SetHook(threadId, "CoLSLSceneHook")
    ; Register for thread specific SL Hooks
    if SLSOInstalled
        RegisterForModEvent("SexLabOrgasmSeparate", "SLSOOrgasmHandler")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for SLSO Orgasm Event")
        endif
    else
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for SexLab Orgasm Event")
        endif
        RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    endif
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for SexLab events")
    endif
EndEvent

Event CoL_SLOrgasmHandler(int threadId, bool hasPlayer)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Entered orgasm handler")
    endif
    ; Unregister for thread specific SL Orgasm Hook
    ; This prevents the orgasm event being triggered for every actor in the scene
    UnregisterForModEvent("HookOrgasmEnd_CoLSLSceneHook")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Unregistered for Orgasm Event")
    endif
    Actor[] actors = SexLab.Positions(threadId)
    int i = 0
    while i < actors.Length
        if actors[i] != succubus
            triggerDrainStart(actors[i])
        endif
        i += 1
    endwhile
EndEvent

Event CoL_SLAnimationEndHandler(int threadId, bool hasPlayer)

    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    ModEvent.Send(sceneEndEvent)
    if CoL.DebugLogging
        Debug.Trace("[CoL] "+ succubusName +" involved animation ended")
    endif
    UnregisterForModEvent("SexLabOrgasmSeparate")
    currentVictims = RemoveDupeActor(currentVictims)
    Actor[] actors = SexLab.Positions(threadId)
    int i = 0
    while i < actors.Length
        if actors[i] && actors[i] != succubus && currentVictims.Find(actors[i]) != -1
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
    if akActor != succubus
        triggerDrainStart(akActor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Trigger drain start for " + actorName)
        endif
    endif
EndEvent