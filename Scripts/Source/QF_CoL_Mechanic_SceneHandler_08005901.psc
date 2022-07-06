;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_CoL_Mechanic_SceneHandler_08005901 Extends Quest Hidden

;BEGIN ALIAS PROPERTY FGParticipant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FGParticipant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant1 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
int sceneClimaxEvent = ModEvent.Create("CoL_FG_Climax")
if sceneClimaxEvent
    ModEvent.PushForm(sceneClimaxEvent, Alias_FGParticipant1.GetReference())
    ModEvent.PushForm(sceneClimaxEvent, Alias_FGParticipant2.GetReference())
    ModEvent.Send(sceneClimaxEvent)
endif

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
