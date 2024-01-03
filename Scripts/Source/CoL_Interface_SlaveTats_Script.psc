Scriptname CoL_Interface_SlaveTats_Script extends Quest

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function OnGameLoad()
    if Game.IsPluginInstalled("SlaveTats.esp")
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction
    Function ReapplySlaveTats(Actor target, bool silent) 
        CoL_Global_SlaveTats_Script.ReapplySlaveTats(target, silent)
    endFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction
Function ReapplySlaveTats(Actor target, bool silent)
endFunction