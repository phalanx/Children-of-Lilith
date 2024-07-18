;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname PF_HSF_SitonLapPkg_0500080C Extends Package Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(Actor akActor)
;BEGIN CODE
    
    CoL.Log("[CoL] ILS Start Detected: " + akActor.GetLeveledActorBase().GetName())  

    int sceneStartEvent = ModEvent.Create("CoL_startScene")
    if sceneStartEvent
        ModEvent.Send(sceneStartEvent)
    endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(Actor akActor)
;BEGIN CODE
    CoL.Log("ILS End Detected: " + akActor.GetLeveledActorBase().GetName())
    int sceneEndEvent = ModEvent.Create("CoL_endScene")
    if sceneEndEvent
        ModEvent.Send(sceneEndEvent)
    endif

    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, CoL.playerRef)
        ModEvent.pushForm(drainHandle, akActor)
        ModEvent.PushString(drainHandle, akActor.GetLeveledActorBase().GetName())
        ModEvent.PushFloat(drainHandle, 0.0)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain start event sent")
    endif
    Utility.Wait(0.5)
    drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, CoL.playerRef)
        ModEvent.pushForm(drainHandle, akActor)
        ModEvent.Send(drainHandle)
        CoL.Log("Drain end event sent")
    endif
    
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
CoL_PlayerSuccubusQuestScript Property CoL Auto