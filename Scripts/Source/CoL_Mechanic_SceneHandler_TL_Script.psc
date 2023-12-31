Scriptname CoL_Mechanic_SceneHandler_TL_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
string currentSceneName

Actor[] victims
float[] victimsArousal
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
        CoL.Log("Toys and Love Detected")
        succubus = GetTargetActor()
        succubusName = succubus.GetActorBase().GetName()
        RegisterForEvents()
    endif
EndFunction

Function RegisterForEvents()
    ; Register for Toys and Loves's scene tracking so we know when a scene starts
    if succubus == CoL.playerRef
        RegisterForModEvent("ToysStartLove", "startScene")
        CoL.Log("Registered for Toys&Love Player Start Scene Event")
    Else
        RegisterForModEvent("ToysStartPlayerlessLove", "startScene")
        CoL.Log("Registered for Toys&Love "+ succubusName +" Start Scene Event")
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
            float arousal = victimsArousal[i]
            int drainHandle 
            if succubus == CoL.playerRef
                drainHandle = ModEvent.Create("CoL_startDrain")
            else
                drainHandle = ModEvent.Create("CoL_startDrain_NPC")
            endif
            if drainHandle
                ModEvent.pushForm(drainHandle, succubus)
                ModEvent.pushForm(drainHandle, victims[i])
                ModEvent.PushString(drainHandle, actorName)
                ModEvent.PushFloat(drainHandle, arousal)
                ModEvent.Send(drainHandle)
                CoL.Log("Drain start event sent for " + actorName)
            endif
        endif
        i += 1
    endwhile
EndFunction

Function triggerDrainEnd()
    int i = 0
    while i < victims.length
        if victims[i] != None
            int drainHandle
            if succubus == CoL.playerRef
                drainHandle = ModEvent.Create("CoL_endDrain")
            else
                drainHandle = ModEvent.Create("CoL_endDrain_NPC")
            endif
            if drainHandle
                ModEvent.pushForm(drainHandle, succubus)
                ModEvent.pushForm(drainHandle, victims[i])
                ModEvent.Send(drainHandle)
                CoL.Log("Drain end event sent for " + victims[i].GetLeveledActorBase().GetName())
            endif
        endif
        i += 1
    endwhile
EndFunction

Event startScene(string EventName, string strArg, float numArg, Form sender)
    int sceneStartEvent
    if succubus == CoL.playerRef
        sceneStartEvent = ModEvent.Create("CoL_startScene")
        if levelHandler.playerSuccubusLevel.GetValueInt() >= 2
            RegisterForKey(configHandler.newTemptationHotkey)
        endif
    else
        sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
    endif
    if sceneStartEvent
        ModEvent.Send(sceneStartEvent)
        CoL.Log(succubusName + " involved animation started")
    endif

    currentSceneName = strArg
    RegisterForModEvent("ToysClimaxNPC", "triggerDrainStart")
    RegisterForModEvent("ToysLoveSceneInfo", "sceneInfo")
    RegisterForModEvent("ToysLoveSceneEnd", "endScene")
    CoL.Log("Registered for TL Scene Events")
EndEvent

Event sceneInfo(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
    if LoveName != currentSceneName
        return
    endif

    UnRegisterForModEvent("ToysLoveSceneInfo")
    CoL.Log("Scene Info: ")

    Actor victim
    if ActInPos1 && ActInPos1 != succubus
        victims = PushActor(victims, ActInPos1 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos1 as Actor))
        CoL.Log("    Victim 1: " + (ActInPos1 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos2 && ActInPos2 != succubus
        victims = PushActor(victims, ActInPos2 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos2 as Actor))
        CoL.Log("    Victim 2: " +  (ActInPos2 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos3 && ActInPos3 != succubus
        victims = PushActor(victims, ActInPos3 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos3 as Actor))
        CoL.Log("    Victim 3: " +  (ActInPos3 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos4 && ActInPos4 != succubus
        victims = PushActor(victims, ActInPos4 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos4 as Actor))
        CoL.Log("    Victim 4: " +  (ActInPos4 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos5 && ActInPos5 != succubus
        victims = PushActor(victims, ActInPos5 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos5 as Actor))
        CoL.Log("    Victim 5: " +  (ActInPos5 as Actor).GetLeveledActorBase().GetName())
    endif

EndEvent

Event endScene(string eventName, string strArg, float numArg, Form sender)
    if strArg != currentSceneName
        return
    endif

    CoL.Log(succubusName +" involved animation ended")
    UnregisterForKey(configHandler.newTemptationHotkey)

    triggerDrainEnd()
    int sceneEndEvent
    if succubus == CoL.playerRef
        sceneEndEvent = ModEvent.Create("CoL_endScene")
    else
        sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
    endif
    if sceneEndEvent
        ModEvent.Send(sceneEndEvent)
    endif
    victims = new Actor[1]
EndEvent

Event OnKeyDown(int keyCode)
    if keyCode == configHandler.newTemptationHotkey
        if levelHandler.playerSuccubusLevel.GetValueInt() < 2
            return
        endif
        int i = 0
        while i < victims.Length
            if victims[i] != succubus
                CoL.temptationSpell.Cast(CoL.playerRef, victims[i])
            endif
            i += 1
        endwhile
    endif
EndEvent