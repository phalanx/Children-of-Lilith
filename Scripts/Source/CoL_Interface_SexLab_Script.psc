Scriptname CoL_Interface_SexLab_Script extends Quest

Quest SexLab

Event OnInit()
    Maintenance()
EndEvent

Function OnGameLoad()
    Maintenance()
EndFunction

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    SexLab = Quest.GetQuest("SexLabQuestFramework")
    if SexLab != None
        GoToState("Installed")
    endif
EndFunction

Event OnEndState()
    Utility.Wait(5.0)
EndEvent

State Installed

    bool Function IsInterfaceActive()
        return true
    EndFunction

    Function SetHook(int threadId, string hookName)
        CoL_Global_SexLab_Script.SetHook(SexLab, threadId, hookName)
    EndFunction

    Actor[] Function Positions(int threadId)
        return CoL_Global_SexLab_Script.Positions(SexLab, threadId)
    EndFunction

EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Function SetHook(int threadId, string hookName)
EndFunction

Actor[] Function Positions(int threadId)
EndFunction