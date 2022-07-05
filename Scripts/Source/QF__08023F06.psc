;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname QF__08023F06 Extends Quest Hidden

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

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
CoL_PlayerSuccubusQuestScript CoL = CoLQ as CoL_PlayerSuccubusQuestScript
if CoL.DebugLogging
    Debug.Trace("[CoL] FG Scene Start Detected")

    Actor victim1 = Alias_FGParticipant1.GetReference() as Actor
    Actor victim2 = Alias_FGParticipant2.GetReference() as Actor

    string victim1Name = victim1.GetLeveledActorBase().GetName()
    string victim2Name = victim2.GetLeveledActorBase().GetName()
    Debug.Trace("[CoL] Participant 1: " + victim1Name)
    Debug.Trace("[CoL] Participant 2: " + victim2Name)
endif

int sceneStartEvent = ModEvent.Create("CoL_startScene")
ModEvent.Send(sceneStartEvent)


Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CoLQ  Auto  
