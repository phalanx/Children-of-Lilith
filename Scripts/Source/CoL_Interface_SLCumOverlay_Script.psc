Scriptname CoL_Interface_SLCumOverlay_Script extends Quest

Quest scoCumHandler 

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function OnGameLoad()
    scoCumHandler = Quest.GetQuest("SCO_CumHandlerQuest")
    if scoCumHandler != None
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

State Installed
    Function reapplySCOEffects(Actor target) 
        CoL_Global_SLCumOverlays_Script.reapplySCOEffects(scoCumHandler, target)
    endFunction

    bool Function IsInterfaceActive()
        return true
    EndFunction
EndState

Function reapplySCOEffects(Actor target) 
EndFunction

bool Function IsInterfaceActive()
    return false
EndFunction