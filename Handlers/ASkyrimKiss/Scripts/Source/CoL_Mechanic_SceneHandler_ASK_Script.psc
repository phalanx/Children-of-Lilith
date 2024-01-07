Scriptname CoL_Mechanic_SceneHandler_ASK_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto

keyword property ActorTypeNPC auto
actor draineeRef

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Float forward = 150 as Float
	Float xoff = forward * math.sin(CoL.PlayerRef.getAngleZ())
	Float yoff = forward * math.cos(CoL.PlayerRef.getAngleZ())
	draineeRef = game.FindClosestActor(CoL.PlayerRef.GetPositionX() + xoff, CoL.PlayerRef.GetPositionY() + yoff, CoL.PlayerRef.GetPositionZ(), forward)
	if !draineeRef || !draineeRef.GetLeveledActorBase().GetRace().HasKeyword(ActorTypeNPC) || draineeRef == CoL.playerRef || draineeRef.IsOnMount() || draineeRef.IsSneaking() || draineeRef.IsChild() || draineeRef.IsDead()
        Log("No victim detected")
        draineeRef = None
        return
    else
        Log("Trigger drain start for " + draineeRef.GetLeveledActorBase().GetName())
        int sceneStartEvent = ModEvent.Create("CoL_startScene")
        ModEvent.Send(sceneStartEvent)
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if !draineeRef
        return
    endif
    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    ModEvent.Send(sceneEndEvent)
    Log("Trigger drain end for " + draineeRef.GetBaseObject().GetName())
    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, akCaster)
        ModEvent.pushForm(drainHandle, draineeRef)
        ModEvent.PushString(drainHandle, draineeRef.GetLeveledActorBase().GetName())
        ModEvent.PushFloat(drainHandle, 0.0)
        ModEvent.Send(drainHandle)
        Log("Drain start event sent")
    endif
    Utility.Wait(0.5)
    drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, akCaster)
        ModEvent.pushForm(drainHandle, draineeRef)
        ModEvent.Send(drainHandle)
        Log("Drain end event sent")
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Scene Handler - ASK - " + msg)
EndFunction