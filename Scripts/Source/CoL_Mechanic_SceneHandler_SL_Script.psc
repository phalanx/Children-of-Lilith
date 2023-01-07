Scriptname CoL_Mechanic_SceneHandler_SL_Script extends activemagiceffect  

import PapyrusUtil

CoL_Interface_SexLab_Script Property SexLab Auto
CoL_Interface_SLAR_Script Property SLAR Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

bool SexLabInstalled
bool SLSOInstalled
bool SLARInstalled
Actor[] currentVictims
Actor[] currentParticipants
Actor succubus
String succubusName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.Log(akTarget.GetDisplayName())
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
    CoL.Log("SexLab detected")

    succubus = GetTargetActor()
    CoL.Log(succubus.GetDisplayName())
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
        CoL.Log("Registered for SexLab Player Start Scene Event")
    elseif succubus != None
        SexLab.TrackActor(succubus,"CoL_" + succubus + "Track")
        RegisterForModEvent("CoL_" + succubus + "Track_Start", "SceneStartHandler")
        CoL.Log("Registered for SexLab " + succubusName + " Start Scene Event")
    endif
EndFunction

Function CheckForAddons()
    SLSOInstalled = Quest.GetQuest("SLSO")
    SLARInstalled = SLAR.IsInterfaceActive()
    if SLSOInstalled
        CoL.Log("SLSO Detected")
    endif
    if SLARInstalled
        CoL.Log("SLAR Detected")
    endif
EndFunction

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    CoL.Log("Trigger drain start for " + actorName)
    float arousal = 0.0
    if SLARInstalled
        arousal = (SLAR.GetActorArousal(victim) as float)
    endif

    int drainHandle
    if succubus == CoL.playerRef
        drainHandle = ModEvent.Create("CoL_startDrain")
    else
        drainHandle = ModEvent.Create("CoL_startDrain_NPC")
    endif
    if drainHandle
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.PushString(drainHandle, actorName)
        ModEvent.PushFloat(drainHandle, arousal)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain start event sent")
        currentVictims = PushActor(currentVictims, victim)
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    int drainHandle
    if succubus == CoL.playerRef
        drainHandle = ModEvent.Create("CoL_endDrain")
    else
        drainHandle = ModEvent.Create("CoL_endDrain_NPC")
    endif
    if drainHandle
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain end event sent for " + victim.GetLeveledActorBase().GetName())
    endif
EndFunction

Event SceneStartHandler(Form actorRef, int threadId)
    int sceneStartEvent
    if succubus == CoL.playerRef
        sceneStartEvent = ModEvent.Create("CoL_startScene")
        RegisterForKey(CoL.temptationHotkey)
    else
        sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
    endif
    ModEvent.Send(sceneStartEvent)
    CoL.Log(succubusName +" involved animation started")

    currentParticipants = SexLab.Positions(threadId)

    SexLab.SetHook(threadId, "CoLSLSceneHook")
    ; Register for thread specific SL Hooks
    if SLSOInstalled
        RegisterForModEvent("SexLabOrgasmSeparate", "SLSOOrgasmHandler")
        CoL.Log("Registered for SLSO Orgasm Event")
    else
        CoL.Log("Registered for SexLab Orgasm Event")
        RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    endif
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    CoL.Log("Registered for SexLab events")
EndEvent

Event OnKeyDown(int keyCode)
    if keyCode == CoL.temptationHotkey
        int i = 0
        while i < currentParticipants.Length
            CoL.temptationSpell.Cast(CoL.playerRef, currentParticipants[i])
            i += 1
            endwhile
    endif
EndEvent

Event CoL_SLOrgasmHandler(int threadId, bool hasPlayer)
    CoL.Log("Entered orgasm handler")
    ; Unregister for thread specific SL Orgasm Hook
    ; This prevents the orgasm event being triggered for every actor in the scene
    UnregisterForModEvent("HookOrgasmEnd_CoLSLSceneHook")
    CoL.Log("Unregistered for Orgasm Event")
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

    int sceneEndEvent
    if succubus == CoL.playerRef
        sceneEndEvent = ModEvent.Create("CoL_endScene")
        UnRegisterForKey(CoL.temptationHotkey)
    else
        sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
    endif
    ModEvent.Send(sceneEndEvent)
    CoL.Log(succubusName +" involved animation ended")
    UnregisterForModEvent("SexLabOrgasmSeparate")
    if PapyrusUtil.GetVersion() >= 40
        currentVictims = RemoveDupeActor(currentVictims)
    else
        ; Deal with SE PapyrusUtils
        currentVictims = MergeActorArray(currentVictims, currentVictims, true)
    endif
    Actor[] actors = SexLab.Positions(threadId)
    int i = 0
    while i < actors.Length
        if actors[i] && actors[i] != succubus && currentVictims.Find(actors[i]) != -1
            CoL.Log("Trigger drain end for " + actors[i].GetBaseObject().GetName())
            triggerDrainEnd(actors[i])
        endif
        i += 1
    endwhile
    currentVictims = new Actor[1]
EndEvent

Event SLSOOrgasmHandler(Form ActorRef, Int threadID)
    Actor akActor = ActorRef as Actor
    string actorName = akActor.GetLeveledActorBase().GetName()
    CoL.Log("Entered orgasm handler")
    if akActor != succubus
        triggerDrainStart(akActor)
        CoL.Log("Trigger drain start for " + actorName)
    endif
EndEvent