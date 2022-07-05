;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname QF__08023F05 Extends Quest Hidden

;BEGIN ALIAS PROPERTY FGParticipant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FGParticipant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
CoL_PlayerSuccubusQuestScript CoL = CoLQ as CoL_PlayerSuccubusQuestScript
if CoL.DebugLogging
    Debug.Trace("[CoL] FG Scene End Detected")
endif

int sceneEndEvent = ModEvent.Create("CoL_endScene")
ModEvent.Send(sceneEndEvent)

int drainHandle
Actor victim1 = Alias_FGParticipant1.GetReference() as Actor
Actor victim2 = Alias_FGParticipant2.GetReference() as Actor
Actor playerRef = Alias_playerRef.GetReference() as Actor

if victim1 != playerRef
    drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim1)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent")
        endif
    endif
endif

if victim2 != playerRef
    drainHandle = ModEvent.Create("CoL_endDrain")
    if drainHandle
        ModEvent.pushForm(drainHandle, victim2)
        ModEvent.Send(drainHandle)
        if CoL.DebugLogging
            Debug.Trace("[CoL] Drain end event sent")
        endif
    endif
endif

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CoLQ  Auto  
