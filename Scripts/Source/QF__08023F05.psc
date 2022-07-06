;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname QF__08023F05 Extends Quest Hidden

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
int sceneStopEvent = ModEvent.Create("CoL_FG_stopScene")
if sceneStopEvent
    ModEvent.PushForm(sceneStopEvent, Alias_FGParticipant1.GetReference())
    ModEvent.PushForm(sceneStopEvent, Alias_FGParticipant2.GetReference())
    ModEvent.Send(sceneStopEvent)
endif

Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
