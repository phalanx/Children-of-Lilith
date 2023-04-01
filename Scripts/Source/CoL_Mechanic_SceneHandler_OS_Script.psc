Scriptname CoL_Mechanic_SceneHandler_OS_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_OStim_Script Property oStim Auto
CoL_Interface_OAroused_Script Property OAroused Auto
Quest Property oDefeat Auto Hidden

bool oStimInstalled = False
bool oDefeatInstalled = False
bool oArousedInstalled = False
Actor succubus
String succubusName

import PapyrusUtil

Actor[] currentVictims  ;List of victims in current scene that have been drained
Actor[] currentPartners ;List of partners in current scene (drained or not)
float[] currentPartnerArousal

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Maintenance()
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    oStimInstalled = oStim.IsInterfaceActive()
    if !oStimInstalled
        return
    endif
    CoL.Log("OStim detected")

    succubus = GetTargetActor()
    if succubus == None
        Dispel()
    endif
    succubusName = succubus.GetActorBase().GetName()

    currentVictims = new Actor[1]
    CheckForAddons()
    GoToState("Waiting")
EndFunction

Function CheckForAddons()
    oDefeat = Quest.GetQuest("ODefeatMainQuest")
    if oDefeat != None
        oDefeatInstalled = True
    endif
    oArousedInstalled = OAroused.IsInterfaceActive()

    if oArousedInstalled
       CoL.Log("OAroused Detected")
    endif
    if oDefeatInstalled
        CoL.Log("ODefeat Detected")
    endif
EndFunction

State Waiting
    Event OnBeginState()
        CoL.Log("Registered for OStim Events for " + succubusName)
        RegisterForModEvent("ostim_start", "startScene")
    EndEvent

    Event startScene(string eventName, string strArg, float numArg, Form sender)

        CoL.Log(succubusName + " involved OStim animation started")

        if !oStim.IsActorActive(succubus)
            return
        endif

        currentPartners = ostim.GetActors()
        currentPartnerArousal = new float[3]
        int i = 0
        while i < currentPartners.Length
            currentPartnerArousal[i] = CoL.GetActorArousal(currentPartners[i])
            i += 1
        endwhile

        int sceneStartEvent
        if succubus == CoL.playerRef
            sceneStartEvent = ModEvent.Create("CoL_startScene")
        else
            sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
        endif
        if sceneStartEvent
            CoL.Log("Sending Scene Start Event")
            ModEvent.Send(sceneStartEvent)
        endif

        GoToState("Running")
    EndEvent

    Event OnEndState()
        CoL.Log("OS Handler Exited Wait")
        UnregisterForModEvent("ostim_start")
    EndEvent

EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("ostim_orgasm", "orgasmHandler")
        RegisterForModEvent("ostim_totalend", "stopScene")
        if succubus == CoL.playerRef && CoL.levelHandler.playerSuccubusLevel.GetValueInt() >= 2
            RegisterForKey(configHandler.temptationHotkey)
        endif
    EndEvent

    Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
        Actor victim = oStim.GetMostRecentOrgasmedActor()

        if victim == None || victim == succubus || currentPartners.Find(victim) == -1
            CoL.Log("Detected orgasm not related to " + succubusName + " scene")
            return
        endif

        CoL.Log("Entered orgasm handler")

        if oStim.FullyAnimateRedress() && CoL.drainHandler.DrainingToDeath && !oStim.IsSceneAggressiveThemed()
            Ostim.ClearStrippedGear(victim)
        endif

        triggerDrainStart(victim)
        if currentVictims.Find(victim) == -1
            currentVictims = PushActor(currentVictims, victim)
        endif

    EndEvent

    Event stopScene(string eventName, string strArg, float numArg, Form sender)
        CoL.Log(succubusName + " involved animation ended")

        int sceneEndEvent
        if succubus == CoL.playerRef
            sceneEndEvent = ModEvent.Create("CoL_endScene")
        else
            sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
        endif
        if sceneEndEvent
            ModEvent.Send(sceneEndEvent)
        endif
        int i = 0
        while i < currentVictims.Length
            if currentVictims[i] != None
                triggerDrainEnd(currentVictims[i])
            endif
                i += 1
        endwhile

        GoToState("Waiting")
    EndEvent

    Event OnKeyDown(int keyCode)
        if keyCode == configHandler.temptationHotkey
            if CoL.levelHandler.playerSuccubusLevel.GetValueInt() < 2
                return
            endif
            int i = 0
            while i < currentPartners.Length
                CoL.temptationSpell.Cast(CoL.playerRef, currentPartners[i])
                i += 1
            endwhile
        endif
    EndEvent

    Event OnEndState()
        UnregisterForModEvent("ostim_orgasm")
        UnregisterForModEvent("ostim_end")
        UnregisterForKey(configHandler.temptationHotkey)
        currentVictims = new Actor[1]
    EndEvent

EndState

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    CoL.Log("Trigger drain start for " + actorName)

    int index = currentPartners.Find(victim)
    float arousal = currentPartnerArousal[index]

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
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    CoL.Log("Trigger drain end for " + victim.GetBaseObject().GetName())

    Utility.Wait(2)
    if oDefeat && CoL.drainHandler.drainingToDeath
        CoL.Log("oDefeat Detected")
        Debug.SendAnimationEvent(victim, "IdleForceDefaultState")
    endif

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
        CoL.Log("Drain end event sent")
    endif
EndFunction

Event startScene(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event stopScene(string eventName, string strArg, float numArg, Form sender)
EndEvent
