Scriptname CoL_Interface_OSL_Script extends Quest

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("OSLAroused.esp")
        GoToState("Installed")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction

    float Function GetArousal(Actor target)
        return OSLAroused_ModInterface.GetArousal(target)
    EndFunction

    float function ModifyArousal(Actor target, float value, string reason = "unknown")
        return OSLAroused_ModInterface.ModifyArousal(target, value, reason)
    EndFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

float Function GetArousal(Actor target)
    return -1
EndFunction


float function ModifyArousal(Actor target, float value, string reason = "unknown")
    return -1
EndFunction