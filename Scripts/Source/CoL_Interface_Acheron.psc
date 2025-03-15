Scriptname CoL_Interface_Acheron extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function Log(string msg)
    CoL.Log("Interface - Acheron - " + msg)
EndFunction

Function OnGameLoad()
    Utility.Wait(5)
    if Game.IsPluginInstalled("Acheron.esm")
        Log("Acheron Detected")
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction
    Function defeatActor(Actor akActor)
        Log("Defeating " + akActor.GetDisplayName())
        Acheron.DefeatActor(akActor)
    endFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Function defeatActor(Actor akActor)
endFunction