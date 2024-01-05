Scriptname CoL_Mechanic_SceneHandler_SL_Script extends activemagiceffect  

import PapyrusUtil

CoL_Interface_SexLab_Script Property SexLab Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto

bool SLSOInstalled
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

Function Log(string msg)
    CoL.Log("Scene Handler - SL - " + msg)
EndFunction

Function Maintenance()
    if !SexLab.IsInterfaceActive()
        return
    endif
    Log("SexLab detected")

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
        RegisterForModEvent("PlayerTrack_Start", "SL_StartScene")
        Log("Registered for Player Start Scene Events")
    elseif succubus != None
        SexLab.TrackActor(succubus,"CoL_" + succubus + "Track")
        RegisterForModEvent("CoL_" + succubus + "Track_Start", "SL_StartScene")
        Log("Registered for " + succubusName + " Start Scene Event")
    endif
EndFunction

Function CheckForAddons()
    SLSOInstalled = Quest.GetQuest("SLSO")
EndFunction

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    Log("Trigger drain start for " + actorName)
    float arousal = iArousal.GetActorArousal(victim)

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
        Log("Drain start event sent")
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
        Log("Drain end event sent for " + victim.GetLeveledActorBase().GetName())
    endif
EndFunction

Event SL_StartScene(Form actorRef, int threadId)
    int sceneStartEvent
    if succubus == CoL.playerRef
        sceneStartEvent = ModEvent.Create("CoL_startScene")

        RegisterForKey(configHandler.hotkeys[3])
    else
        sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
    endif
    ModEvent.Send(sceneStartEvent)
    Log(succubusName +" involved animation started")

    currentParticipants = SexLab.Positions(threadId)

    SexLab.SetHook(threadId, "CoLSLSceneHook")
    ; Register for thread specific SL Hooks
    if SLSOInstalled
        RegisterForModEvent("SexLabOrgasmSeparate", "SLSOOrgasmHandler")
        Log("Registered for SLSO Orgasm Event")
    else
        Log("Registered for Orgasm Event")
        RegisterForModEvent("HookOrgasmEnd_CoLSLSceneHook", "CoL_SLOrgasmHandler")
    endif
    RegisterForModEvent("HookAnimationEnd_CoLSLSceneHook", "CoL_SLAnimationEndHandler")
    Log("Registered for Scene Events")
EndEvent

Event OnKeyDown(int keyCode)
    if keyCode == configHandler.hotkeys[3]
        if levelHandler.playerSuccubusLevel.GetValueInt() < 2
            Debug.Notification("Must be Succubus level 2 to use Temptation")
            return
        endif
        int i = 0
        while i < currentParticipants.Length
            Log("Casting Tempatation")
            CoL.temptationSpell.Cast(CoL.playerRef, currentParticipants[i])
            i += 1
        endwhile
    endif
EndEvent

Event CoL_SLOrgasmHandler(int threadId, bool hasPlayer)
    Log("Entered orgasm handler")
    ; Unregister for thread specific SL Orgasm Hook
    ; This prevents the orgasm event being triggered for every actor in the scene
    UnregisterForModEvent("HookOrgasmEnd_CoLSLSceneHook")
    Log("Unregistered for Orgasm Event")
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
        UnRegisterForKey(configHandler.hotkeys[3])
    else
        sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
    endif
    ModEvent.Send(sceneEndEvent)
    Log(succubusName +" involved animation ended")
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
            Log("Trigger drain end for " + actors[i].GetBaseObject().GetName())
            triggerDrainEnd(actors[i])
        endif
        i += 1
    endwhile
    currentVictims = new Actor[1]
EndEvent

Event SLSOOrgasmHandler(Form ActorRef, Int threadID)
    Log("Entered orgasm handler")
    Actor akActor = ActorRef as Actor
    Actor[] positions = SexLab.Positions(threadID)
    string actorName = akActor.GetLeveledActorBase().GetName()
    if akActor != succubus && positions.Find(succubus) >= 0
        triggerDrainStart(akActor)
        Log("Trigger drain start for " + actorName)
    endif
EndEvent