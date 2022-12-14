Scriptname CoL_Mechanic_SceneHandler_FG_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
Keyword Property playerHavingSex Auto Hidden

Actor victim1
Actor victim2
Actor succubus
String succubusName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Maintenance()
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    playerHavingSex = Keyword.GetKeyword("dxIsHavingSex")
    if playerHavingSex
        CoL.Log("Flowergirls Detected")
        succubus = GetTargetActor()
        succubusName = succubus.GetActorBase().GetName()
        GoToState("Waiting")
    endif
EndFunction

State Waiting
    Event OnBeginState()
        victim1 = None
        victim2 = None
        RegisterForModEvent("CoL_FG_startScene", "startScene")
        CoL.Log("Registered for Flower Girl " + succubusName +" Start Event")
    EndEvent

    Event startScene(Form participant1, Form participant2)
        if !Succubus.HasKeyword(playerHavingSex) 
            return
        endif

        CoL.Log("Succubus involved animation started")

        UnRegisterForModEvent("CoL_FG_startScene")

        if participant1 as Actor != succubus
            victim1 = participant1 as Actor
        endif
        if participant2 as Actor != succubus
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

        CoL.Log("Entered orgasm handler")

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

        CoL.Log("[CoL] Succubus involved animation ended")

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
    CoL.Log("Trigger drain start for " + actorName)

    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.PushString(drainHandle, actorName)
        ModEvent.PushFloat(drainHandle, 0.0)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain start event sent")
    endif
EndFunction

Function triggerDrainEnd(Actor victim)
    CoL.Log("Trigger drain end for " + victim.GetBaseObject().GetName())

    int drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, succubus)
        ModEvent.pushForm(drainHandle, victim)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain end event sent")
    endif
EndFunction

Event startScene(Form participant1, Form participant2)
EndEvent

Event climax(Form participant1, Form participant2)
EndEvent

Event stopScene(Form participant1, Form participant2)
EndEvent