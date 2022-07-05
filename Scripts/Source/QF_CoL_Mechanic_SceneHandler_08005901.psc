;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname QF_CoL_Mechanic_SceneHandler_08005901 Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FGParticipant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FGParticipant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
CoL_PlayerSuccubusQuestScript CoL = CoLQ as CoL_PlayerSuccubusQuestScript


Actor victim1 = Alias_FGParticipant1.GetReference() as Actor
Actor victim2 = Alias_FGParticipant2.GetReference() as Actor
Actor playerRef = Alias_playerRef.GetReference() as Actor
string victim1Name = victim1.GetLeveledActorBase().GetName()
string victim2Name = victim2.GetLeveledActorBase().GetName()

if CoL.DebugLogging
    Debug.Trace("[CoL] Entered orgasm handler")
    Debug.Trace("[CoL] Participant 1: " + victim1Name)
    Debug.Trace("[CoL] Participant 2: " + victim2Name)
endif

if victim1 != playerRef
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + victim1Name)
    endif
    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim1)
        ModEvent.PushString(drainHandle, victim1Name)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain start event sent")
       endif
    endif
endif

if victim2 != playerRef
    if CoL.DebugLogging
        Debug.Trace("[CoL] Trigger drain start for " + victim2Name)
    endif
    int drainHandle = ModEvent.Create("CoL_startDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim2)
        ModEvent.PushString(drainHandle, victim2Name)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain start event sent")
       endif
    endif
endif

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CoLQ  Auto  
