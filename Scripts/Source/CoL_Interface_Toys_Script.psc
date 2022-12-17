Scriptname CoL_Interface_Toys_Script extends Quest

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("Toys.esm")
        GoToState("Installed")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction

    int Function GetRousing()
        return ToysGlobal.GetRousing()
    EndFunction

    bool Function isBusy()
        return ToysGlobal.isBusy()
    EndFunction
EndState

int Function GetRousing()
EndFunction

bool Function isBusy()
    return false
EndFunction

bool Function IsInterfaceActive()
    return false
EndFunction