Scriptname CoL_Mechanic_SceneHandler_FG_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
Keyword Property IsHavingSex Auto Hidden

Actor victim1
float victim1_arousal
Actor victim2
float victim2_arousal
Actor succubus
String succubusName

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Maintenance()
EndEvent

Event OnPlayerLoadGame()
    Maintenance()
EndEvent

Function Maintenance()
    IsHavingSex = Keyword.GetKeyword("dxIsHavingSex")
    if IsHavingSex
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
        if !succubus.HasKeyword(IsHavingSex) 
            return
        endif

        CoL.Log(succubusName + " involved animation started")

        UnRegisterForModEvent("CoL_FG_startScene")

        if participant1 as Actor != succubus
            victim1 = participant1 as Actor
            victim1_arousal = iArousal.GetActorArousal(victim1)
        endif
        if participant2 as Actor != succubus
            victim2 = participant2 as Actor
            victim2_arousal = iArousal.GetActorArousal(victim2)
        endif

        int sceneStartEvent
        if succubus == CoL.playerRef
            sceneStartEvent = ModEvent.Create("CoL_startScene")
        else
            sceneStartEvent = ModEvent.Create("CoL_startScene_NPC")
        endif

        if sceneStartEvent
            ModEvent.Send(sceneStartEvent)
            GoToState("Running")
        endif
    EndEvent

EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("CoL_FG_Climax", "climax")
        if succubus == CoL.playerRef && levelHandler.playerSuccubusLevel.GetValueInt() >= 2
            RegisterForKey(configHandler.newTemptationHotkey)
        endif
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
            triggerDrainStart(victim1, victim1_arousal)    
        endif
        if victim2
            triggerDrainStart(victim2, victim2_arousal)
        endif
        GoToState("Ending")
    EndEvent

    Event OnKeyDown(int keyCode)
        if keyCode == configHandler.newTemptationHotkey
            if levelHandler.playerSuccubusLevel.GetValueInt() < 2
                return
            endif
            if victim1 != None
                CoL.temptationSpell.Cast(CoL.playerRef, victim1)
            endif
            if victim2 != None
                CoL.temptationSpell.Cast(CoL.playerRef, victim2)
            endif
        endif
    EndEvent

    Event OnEndState()
        UnregisterForKey(configHandler.newTemptationHotkey)
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

        CoL.Log(succubusName + " involved animation ended")

        UnregisterForModEvent("CoL_FG_stopScene")

        int sceneEndEvent 
        if succubus == CoL.playerRef
            sceneEndEvent = ModEvent.Create("CoL_endScene")
        else
            sceneEndEvent = ModEvent.Create("CoL_endScene_NPC")
        endif
        if sceneEndEvent
            ModEvent.Send(sceneEndEvent)
        endif

        if victim1
            triggerDrainEnd(victim1)
        endif
        if victim2
            triggerDrainEnd(victim2)
        endif
        
        GoToState("Waiting")
    EndEvent
EndState

Function triggerDrainStart(Actor victim, float arousal)
    if !victim1 && !victim2
        return
    endif
    string actorName = victim.GetLeveledActorBase().GetName()
    CoL.Log("Trigger drain start for " + actorName)
    
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

Event startScene(Form participant1, Form participant2)
EndEvent

Event climax(Form participant1, Form participant2)
EndEvent

Event stopScene(Form participant1, Form participant2)
EndEvent