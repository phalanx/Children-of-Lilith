Scriptname CoL_Interface_Toys_Script extends Quest

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("Toys.esm")
        GoToState("Installed")
    else
        GoToState("")
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

    Function ArousalAdjust(int adjArousal, bool ForceNotify = false )
        ToysGlobal.ArousalAdjust(adjArousal, ForceNotify)
    EndFunction

    Function Caress()
        ToysGlobal.Caress()
    EndFunction
EndState

int Function GetRousing()
EndFunction

Function ArousalAdjust(int adjArousal, bool ForceNotify = false )
EndFunction

Function Caress()
EndFunction

bool Function isBusy()
    return false
EndFunction

bool Function IsInterfaceActive()
    return false
EndFunction