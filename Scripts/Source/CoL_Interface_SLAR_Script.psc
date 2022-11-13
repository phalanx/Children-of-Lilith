Scriptname CoL_Interface_SLAR_Script extends Quest

Quest SLAR
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function OnGameLoad()
    SLAR = Quest.GetQuest("sla_Framework")
    if SLAR != None
        GoToState("Installed")
    endif
EndFunction

Event OnEndState()
    Utility.Wait(5.0)
EndEvent

State Installed
    Int Function GetActorArousal(Actor akRef)
        return CoL_Global_SLAR_Script.GetActorArousal(SLAR, akRef)
    EndFunction

    Int Function UpdateActorExposure(Actor akRef, Int val, String debugMsg = "")
        return CoL_Global_SLAR_Script.UpdateActorExposure(SLAR, akRef, val, debugMsg)
    EndFunction

    bool Function IsInterfaceActive()
        return true
    EndFunction

EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Int Function GetActorArousal(Actor akRef)
    return 0
EndFunction

Int Function UpdateActorExposure(Actor akRef, Int val, String debugMsg = "")
    return 0
EndFunction