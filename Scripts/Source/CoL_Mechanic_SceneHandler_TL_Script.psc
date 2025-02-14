Scriptname CoL_Mechanic_SceneHandler_TL_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Interface_Toys_Script Property iToys Auto
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

Function Log(string msg)
    CoL.Log("Scene Handler - TL - " + msg)
EndFunction

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("Toys.esm")
        Log("Toys and Love Detected")
        succubus = GetTargetActor()
        succubusName = succubus.GetActorBase().GetName()
        RegisterForEvents()
    endif
EndFunction

Function RegisterForEvents()
    ; Register for Toys and Loves's scene tracking so we know when a scene starts
    if succubus == CoL.playerRef
        RegisterForModEvent("ToysStartLove", "TL_startScene")
        Log("Registered for Player Start Scene Event")
    Else
        RegisterForModEvent("ToysStartPlayerlessLove", "TL_startScene")
        Log("Registered for "+ succubusName +" Start Scene Event")
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
                Log("Drain start event sent for " + actorName)
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
                Log("Drain end event sent for " + victims[i].GetLeveledActorBase().GetName())
            endif
        endif
        i += 1
    endwhile
EndFunction

Event TL_startScene(string EventName, string strArg, float numArg, Form sender)
    int sceneStartEvent
    if succubus == CoL.playerRef
        sceneStartEvent = ModEvent.Create("CoL_startScene")
        if levelHandler.playerSuccubusLevel.GetValueInt() >= 2
            RegisterForKey(configHandler.hotkeys[3])
        endif
    else
        sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
        ModEvent.PushForm(sceneStartEvent, succubus)
    endif
    if sceneStartEvent
        ModEvent.Send(sceneStartEvent)
        Log(succubusName + " involved animation started")
    endif

    currentSceneName = strArg
    RegisterForModEvent("ToysClimaxNPC", "triggerDrainStart")
    RegisterForModEvent("ToysLoveSceneInfo", "sceneInfo")
    RegisterForModEvent("ToysLoveSceneEnd", "TL_endScene")
    Log("Registered for Scene Events")
EndEvent

Event sceneInfo(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
    if LoveName != currentSceneName
        return
    endif

    UnRegisterForModEvent("ToysLoveSceneInfo")
    if succubus == CoL.playerRef
        iToys.setPlayerSceneData(LoveName, PlayerInScene, NumStages, PlayerConsent, ActInPos1, ActInPos2, ActInPos3, ActInPos4, ActInPos5)
    endif
    Log("Scene Info: ")

    Actor victim
    if ActInPos1 && ActInPos1 != succubus
        victims = PushActor(victims, ActInPos1 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos1 as Actor))
        Log("    Victim 1: " + (ActInPos1 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos2 && ActInPos2 != succubus
        victims = PushActor(victims, ActInPos2 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos2 as Actor))
        Log("    Victim 2: " +  (ActInPos2 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos3 && ActInPos3 != succubus
        victims = PushActor(victims, ActInPos3 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos3 as Actor))
        Log("    Victim 3: " +  (ActInPos3 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos4 && ActInPos4 != succubus
        victims = PushActor(victims, ActInPos4 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos4 as Actor))
        Log("    Victim 4: " +  (ActInPos4 as Actor).GetLeveledActorBase().GetName())
    endif
    if ActInPos5 && ActInPos5 != succubus
        victims = PushActor(victims, ActInPos5 as Actor)
        victimsArousal = PushFloat(victimsArousal, iArousal.GetActorArousal(ActInPos5 as Actor))
        Log("    Victim 5: " +  (ActInPos5 as Actor).GetLeveledActorBase().GetName())
    endif

EndEvent

Event TL_endScene(string eventName, string strArg, float numArg, Form sender)
    if strArg != currentSceneName
        return
    endif

    Log(succubusName +" involved animation ended")
    UnregisterForKey(configHandler.hotkeys[3])

    triggerDrainEnd()
    int sceneEndEvent
    if succubus == CoL.playerRef
        iToys.ClearPlayerSceneData()
        sceneEndEvent = ModEvent.Create("CoL_endScene")
    else
        sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
        ModEvent.PushForm(sceneEndEvent, succubus)
    endif
    if sceneEndEvent
        ModEvent.Send(sceneEndEvent)
    endif
    victims = new Actor[1]
EndEvent

Event OnKeyDown(int keyCode)
    If  CoL_Global_Utils.IsMenuOpen()
        Return
    EndIf
    if keyCode == configHandler.hotkeys[3]
        if levelHandler.playerSuccubusLevel.GetValueInt() < 2
            Debug.Notification("Must be Succubus level 2 to use Temptation")
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