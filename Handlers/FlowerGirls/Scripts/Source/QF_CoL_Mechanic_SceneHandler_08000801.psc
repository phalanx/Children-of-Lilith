;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_CoL_Mechanic_SceneHandler_08000801 Extends Quest Hidden

;BEGIN ALIAS PROPERTY FGParticipant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FGParticipant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FGParticipant2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
int sceneStartEvent = ModEvent.Create("CoL_FG_stopScene")
if sceneStartEvent
    ModEvent.PushForm(sceneStartEvent, Alias_FGParticipant1.GetReference())
    ModEvent.PushForm(sceneStartEvent, Alias_FGParticipant2.GetReference())
    ModEvent.Send(sceneStartEvent)
endif

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
