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
    Function ReapplySlaveTats(Actor target, bool silent) 
        CoL_Global_SlaveTats_Script.ReapplySlaveTats(target, silent)
    endFunction
EndState

Function ReapplySlaveTats(Actor target, bool silent)
endFunction