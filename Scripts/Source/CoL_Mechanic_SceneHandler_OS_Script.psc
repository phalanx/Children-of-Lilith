Scriptname CoL_Mechanic_SceneHandler_OS_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
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
    if CoL.DebugLogging
        Debug.Trace("[CoL] OStim detected")
    endif

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

    if CoL.DebugLogging
        if oArousedInstalled
            Debug.Trace("[CoL] OAroused Detected")
        endif
        if oDefeatInstalled
            Debug.Trace("[CoL] ODefeat Detected")
        endif
    endif
EndFunction

State Waiting
    Event OnBeginState()

        if CoL.DebugLogging
            Debug.Trace("[CoL] Registered for OStim Events for " + succubusName)
        endif

        RegisterForModEvent("ostim_start", "startScene")
    EndEvent

    Event startScene(string eventName, string strArg, float numArg, Form sender)

        if CoL.DebugLogging
            Debug.Trace("[CoL] " + succubusName + " involved OStim animation started")
        endif

        if !oStim.IsActorActive(succubus)
            return
        endif

        currentPartners = ostim.GetActors()
        currentPartnerArousal = new float[3]
        int i = 0
        while i < currentPartners.Length
            currentPartnerArousal[i] = OAroused.GetArousal(currentPartners[i])
            i += 1
        endwhile

        int sceneStartEvent = ModEvent.Create("CoL_startScene")
        if sceneStartEvent
            Debug.Trace("[CoL] Sending Scene Start Event")
            ModEvent.Send(sceneStartEvent)
        endif

        GoToState("Running")
    EndEvent

    Event OnEndState()
        if CoL.DebugLogging
            Debug.Trace("[CoL] OS Handler Exited Wait")
        endif
        UnregisterForModEvent("ostim_start")
    EndEvent

EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("ostim_orgasm", "orgasmHandler")
        RegisterForModEvent("ostim_totalend", "stopScene")
    EndEvent

    Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
        Actor victim = oStim.GetMostRecentOrgasmedActor()

        if victim == None || victim == succubus || currentPartners.Find(victim) == -1
            if CoL.DebugLogging
                Debug.Trace("[CoL] Detected orgasm not related to " + succubusName + " scene")
            endif
            return
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Entered orgasm handler")
        endif

        if oStim.FullyAnimateRedress() && CoL.drainHandler.DrainingToDeath && !oStim.IsSceneAggressiveThemed()
            Ostim.ClearStrippedGear(victim)
        endif

        triggerDrainStart(victim)
        if currentVictims.Find(victim) == -1
            currentVictims = PushActor(currentVictims, victim)
        endif

    EndEvent

    Event stopScene(string eventName, string strArg, float numArg, Form sender)
        if CoL.DebugLogging
            Debug.Trace("[CoL] " + succubusName + " involved animation ended")
        endif

        int sceneEndEvent = ModEvent.Create("CoL_endScene")
        ModEvent.Send(sceneEndEvent)
        int i = 0
        while i < currentVictims.Length
            if currentVictims[i] != None
                triggerDrainEnd(currentVictims[i])
            endif
                i += 1
        endwhile

        GoToState("Waiting")
    EndEvent

    Event OnEndState()
        UnregisterForModEvent("ostim_orgasm")
        UnregisterForModEvent("ostim_end")
        currentVictims = new Actor[1]
    EndEvent

EndState

Function triggerDrainStart(Actor victim)
    string actorName = victim.GetLeveledActorBase().GetName()
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + actorName)
    endif

    int index = currentPartners.Find(victim)
    float arousal = currentPartnerArousal[index]

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
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain end for " + victim.GetBaseObject().GetName())
    endif

    Utility.Wait(2)
    if oDefeat && CoL.drainHandler.drainingToDeath
        Debug.Trace("[CoL] oDefeat Detected")
        Debug.SendAnimationEvent(victim, "IdleForceDefaultState")
    endif

    int drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent")
        endif
    endif
EndFunction

Event startScene(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event orgasmHandler(string eventName, string strArg, float numArg, Form sender)
EndEvent

Event stopScene(string eventName, string strArg, float numArg, Form sender)
EndEvent
