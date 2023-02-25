Scriptname CoL_Interface_OAroused_Script extends Quest

Quest OAroused
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function OnGameLoad()
    OAroused = Quest.GetQuest("OArousedQuest")
    bool isOSLInstalled = Game.IsPluginInstalled("OSLAroused.esp")
    if OAroused != None && !isOSLInstalled
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

Event OnEndState()
    Utility.Wait(5.0)
EndEvent

State Installed
    float Function GetArousal(Actor akRef)
        return CoL_Global_OAroused_Script.GetArousal(OAroused, akRef)
    EndFunction

    float Function ModifyArousal(Actor akRef, Int val)
        return CoL_Global_OAroused_Script.ModifyArousal(OAroused, akRef, val)
    EndFunction

    bool Function IsInterfaceActive()
        return true
    EndFunction

EndState

bool Function IsInterfaceActive()
    return false
EndFunction

float Function GetArousal(Actor akRef)
    return 0
EndFunction

float Function ModifyArousal(Actor akRef, Int val)
    return 0
EndFunction