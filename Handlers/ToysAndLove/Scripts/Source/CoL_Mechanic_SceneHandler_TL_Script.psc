Scriptname CoL_Mechanic_SceneHandler_TL_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
string currentSceneName

Actor[] victims

Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; victims = new Actor[1]
    RegisterForEvents()
EndEvent

Event OnPlayerLoadGame()
    ; victims = new Actor[1]
    RegisterForEvents()
EndEvent

Function RegisterForEvents()
    ; Register for sexlab's player tracking so we know when a scene involving the player starts
    RegisterForModEvent("ToysStartLove", "startScene")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for Toys&Love Player Start Scene Event")
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
            if drainHandle
                ModEvent.pushForm(drainHandle, victims[i])
                ModEvent.PushString(drainHandle, actorName)
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
        Debug.Trace("[CoL] Player involved animation started")
    endif
    
    currentSceneName = strArg;
    RegisterForModEvent("ToysClimaxNPC", "triggerDrainStart")
    RegisterForModEvent("ToysLoveSceneInfo", "sceneInfo")
    RegisterForModEvent("ToysLoveSceneEnd", "endScene")
    if CoL.DebugLogging
        Debug.Trace("[CoL] Registered for TL Events")
    endif
EndEvent

Event sceneInfo(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
    if LoveName != currentSceneName || !PlayerInScene
        return
    endif

    if CoL.DebugLogging
        Debug.Trace("[CoL] Scene Info: ")
    endif

    Actor victim
    if ActInPos1 && ActInPos1 != CoL.playerRef
        victims = PushActor(victims, ActInPos1 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 1: " + (ActInPos1 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos2 && ActInPos2 != CoL.playerRef
        victims = PushActor(victims, ActInPos2 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 2: " +  (ActInPos2 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos3 && ActInPos3 != CoL.playerRef
        victims = PushActor(victims, ActInPos3 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 3: " +  (ActInPos3 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos4 && ActInPos4 != CoL.playerRef
        victims = PushActor(victims, ActInPos4 as Actor)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Victim 4: " +  (ActInPos4 as Actor).GetLeveledActorBase().GetName())
        endif
    endif
    if ActInPos5 && ActInPos5 != CoL.playerRef
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
        Debug.Trace("[CoL] Player involved animation ended")
    endif

    triggerDrainEnd()
    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    ModEvent.Send(sceneEndEvent)
    victims = new Actor[1]
EndEvent