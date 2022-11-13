Scriptname CoL_Mechanic_SceneHandler_OS_Script extends activemagiceffect

OSexIntegrationMain Property oStim Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OAroused_Script Property OAroused Auto
Quest Property oDefeat Auto Hidden

OUndressScript oUndress

bool oDefeatInstalled = False
bool oArousedInstalled = False

import PapyrusUtil

Actor[] currentVictims  ;List of victims in current scene that have been drained
Actor[] currentPartners ;List of partners in current scene (drained or not)
float[] currentPartnerArousal

Event OnEffectStart(Actor akTarget, Actor akCaster)
    currentVictims = new Actor[1]
    oDefeat = Quest.GetQuest("ODefeatMainQuest")
    oUndress = oStim.GetUndressScript()
    CheckForAddons()
    GoToState("Waiting")
EndEvent

Event OnPlayerLoadGame()
    currentVictims = new Actor[1]
    oUndress = oStim.GetUndressScript()
    CheckForAddons()
    GoToState("Waiting")
EndEvent

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
            Debug.Trace("[CoL] Registered for OStim Events")
        endif

        RegisterForModEvent("ostim_start", "startScene")
    EndEvent

    Event startScene(string eventName, string strArg, float numArg, Form sender)

        if CoL.DebugLogging
            Debug.Trace("[CoL] OStim animation started")
        endif

        if !oStim.IsPlayerInvolved()
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

        if victim == None || victim == CoL.playerRef 
            return
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Entered orgasm handler")
        endif
        if oStim.FullyAnimateRedress && CoL.drainHandler.DrainingToDeath && !oStim.IsSceneAggressiveThemed()
            Actor[] actors = oStim.GetActors()
            if victim == actors[0]
                ;Dom
                oUndress.DomEquipmentDrops = new ObjectReference[1]
                oUndress.DomEquipmentForms = new Form[1]
            elseif victim == actors[1]
                ;Sub
                oUndress.SubEquipmentDrops = new ObjectReference[1]
                oUndress.SubEquipmentForms = new Form[1]
            elseif victim == actors[2]
                ;Third
                oUndress.ThirdEquipmentDrops = new ObjectReference[1]
                oUndress.ThirdEquipmentForms = new Form[1]
            endif
        endif
        triggerDrainStart(victim)
        if currentVictims.Find(victim) == -1
            currentVictims = PushActor(currentVictims, victim)
        endif

    EndEvent

    Event stopScene(string eventName, string strArg, float numArg, Form sender)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Player involved animation ended")
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
