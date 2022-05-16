Scriptname CoL_PlayerAliasScript extends ReferenceAlias  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    CoL.GoToState("Initialize")
EndEvent

Event OnPlayerLoadGame()
    CoL.Maintenance()
EndEvent