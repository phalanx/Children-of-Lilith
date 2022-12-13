Scriptname CoL_Mechanic_SceneHandler_TL_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
; CoL_Interface_SLAR_Script Property SLAR Auto
string currentSceneName

Actor[] victims
Actor succubus
String succubusName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Maintenance()
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    if Game.IsPluginInstalled("Toys.esm")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Toys and Love Detected")
        endif
        succubus = GetTargetActor()
        succubusName = succubus.GetActorBase().GetName()
        RegisterForEvents()
    endif
EndFunction

Function RegisterForEvents()
    ; Register for Toys and Loves's scene tracking so we know when a scene starts
    if succubus == CoL.playerRef
        RegisterForModEvent("ToysStartLove", "startScene")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for Toys&Love Player Start Scene Event")
        endif
    Else
        RegisterForModEvent("ToysStartPlayerlessLove", "startScene")
        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for Toys&Love "+ succubusName +" Start Scene Event")
        endif
    endif
EndFunction

Function triggerDrainStart(string EventName, string strArg, float numArg, Form sender)
    if strArg != currentSceneName
        return
    endif
    int i = 0
    while i < victims.length
        if victims[i] != None
            string actorName = victims[i].GetLeveledActorBase().GetName()
            int drainHandle = ModEvent.Create("CoL_startDrain")
            float arousal = ToysGlobal.GetRousing()
            if drainHandle
                ModEvent.pushForm(drainHandle, succubus)
                ModEvent.pushForm(drainHandle, victims[i])
                ModEvent.PushString(drainHandle, actorName)
                ModEvent.PushFloat(drainHandle, arousal)
                ModEvent.Send(drainHandle)
                if CoL.DebugLogging
                    Debug.Trace("[CoL] Drain start event sent for " + actorName)
                endif
            endif
        endif
        i += 1
    endwhile
EndFunction

Function triggerDrainEnd()
    int i = 0
    while i < victims.length
        if victims[i] != None
            int drainHandle = ModEvent.Create("CoL_endDrain")
            if drainHandle
                ModEvent.pushForm(drainHandle, victims[i])
                ModEvent.Send(drainHandle)
                if CoL.DebugLogging
                    Debug.Trace("[CoL] Drain end event sent for " + victims[i].GetLeveledActorBase().GetName())
                endif
            endif
        endif
        i += 1
    endwhile
EndFunction

Event startScene(string EventName, string strArg, float numArg, Form sender)
    int sceneStartEvent = ModEvent.Create("CoL_startScene")
    ModEvent.Send(sceneStartEvent)
    if CoL.DebugLogging
        Debug.Trace("[CoL] " + succubusName + " involved animation started")
    endif

    currentSceneName = strArg
    RegisterForModEvent("ToysClimaxNPC", "triggerDrainStart")
    RegisterForModEvent("ToysLoveSceneInfo", "sceneInfo")
    RegisterForModEvent("ToysLoveSceneEnd", "endScene")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for TL Events")
    endif
EndEvent

Event sceneInfo(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
    if LoveName != currentSceneName
        return
    endif

    if CoL.DebugLogging
        Debug.Trace("[CoL] Scene Info: ")
    endif

    Actor victim
    if ActInPos1 && ActInPos1 != succubus
        victims = PushActor(victims, ActInPos1 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 1: " + (ActInPos1 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos2 && ActInPos2 != succubus
        victims = PushActor(victims, ActInPos2 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 2: " +  (ActInPos2 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos3 && ActInPos3 != succubus
        victims = PushActor(victims, ActInPos3 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 3: " +  (ActInPos3 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos4 && ActInPos4 != succubus
        victims = PushActor(victims, ActInPos4 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 4: " +  (ActInPos4 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos5 && ActInPos5 != succubus
        victims = PushActor(victims, ActInPos5 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 5: " +  (ActInPos5 as Actor).GetLeveledActorBase().GetName())
        endif
    endif

EndEvent

Event endScene(string eventName, string strArg, float numArg, Form sender)
    if strArg != currentSceneName
        return
    endif

    if CoL.DebugLogging
        Debug.Trace("[CoL] "+ succubusName +" involved animation ended")
    endif

    triggerDrainEnd()
    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    ModEvent.Send(sceneEndEvent)
    victims = new Actor[1]
EndEvent