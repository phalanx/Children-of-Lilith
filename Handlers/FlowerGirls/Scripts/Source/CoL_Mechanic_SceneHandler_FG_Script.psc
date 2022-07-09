Scriptname CoL_Mechanic_SceneHandler_FG_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
Keyword Property playerHavingSex Auto

Actor victim1
Actor victim2

Event OnEffectStart(Actor akTarget, Actor akCaster)
    GoToState("Waiting")
EndEvent

Event OnPlayerLoadGame()
    GoToState("Waiting")
EndEvent

State Waiting
    Event OnBeginState()
        victim1 = None
        victim2 = None
        RegisterForModEvent("CoL_FG_startScene", "startScene")
        Debug.Trace("[CoL] Registered for Flower Girl Start Event")
    EndEvent

    Event startScene(Form participant1, Form participant2)
        if !CoL.playerRef.HasKeyword(playerHavingSex) 
            return
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Player involved animation started")
        endif

        UnRegisterForModEvent("CoL_FG_startScene")

        if participant1 as Actor != CoL.playerRef
            victim1 = participant1 as Actor
        endif
        if participant2 as Actor != CoL.playerRef
            victim2 = participant2 as Actor
        endif

        int sceneStartEvent = ModEvent.Create("CoL_startScene")
        if sceneStartEvent
            ModEvent.Send(sceneStartEvent)
            GoToState("Running")
        endif
    EndEvent

EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("CoL_FG_Climax", "climax")
    EndEvent

    Event climax(Form participant1, Form participant2)
        if participant1 != victim1 && participant1 != victim2
            if participant2 != victim1 && participant2 != victim2
                return
            endif
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Entered orgasm handler")
        endif

        UnRegisterForModEvent("CoL_FG_Climax")

        if victim1 
            triggerDrainStart(victim1)    
        endif
        if victim2
            triggerDrainStart(victim2)
        endif
        GoToState("Ending")
    EndEvent

EndState

State Ending
    Event OnBeginState()
        RegisterForModEvent("CoL_FG_stopScene", "stopScene")
    EndEvent

    Event stopScene(Form participant1, Form participant2)
        if participant1 != victim1 && participant1 != victim2
            if participant2 != victim1 && participant2 != victim2
                return
            endif
        endif

        if CoL.DebugLogging
            Debug.Trace("[CoL] Player involved animation ended")
        endif

        UnregisterForModEvent("CoL_FG_stopScene")

        int sceneEndEvent = ModEvent.Create("CoL_endScene")
        ModEvent.Send(sceneEndEvent)

        if victim1
            triggerDrainEnd(victim1)
        endif
        if victim2
            triggerDrainEnd(victim2)
        endif
        
        GoToState("Waiting")
    EndEvent
EndState

Function triggerDrainStart(Actor victim)
    if !victim1 && !victim2
        return
    endif
    string actorName = victim.GetLeveledActorBase().GetName()
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + actorName)
    endif

    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.PushString(drainHandle, actorName)
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

    int drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent")
        endif
    endif
EndFunction

Event startScene(Form participant1, Form participant2)
EndEvent

Event climax(Form participant1, Form participant2)
EndEvent

Event stopScene(Form participant1, Form participant2)
EndEvent