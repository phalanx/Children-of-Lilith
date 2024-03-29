Scriptname CoL_Interface_Ostim_Script extends Quest

Quest OStim

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function OnGameLoad()
    OStim = Quest.GetQuest("OSexIntegrationMainQuest")
    if OStim != None
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

Event OnEndState()
    Utility.Wait(5.0)
EndEvent

State Installed

    bool Function IsInterfaceActive()
        return true
    EndFunction

    bool Function IsPlayerInvolved()
        return CoL_Global_OStim_Script.IsPlayerInvolved(OStim)
    EndFunction
    
    bool Function IsActorActive(Actor actorRef)
        return CoL_Global_Ostim_Script.IsActorActive(OStim, actorRef)
    EndFunction

    Actor[] Function GetActors()
        return CoL_Global_OStim_Script.GetActors(OStim)
    EndFunction

    Actor Function GetMostRecentOrgasmedActor()
        return CoL_Global_OStim_Script.GetMostRecentOrgasmedActor(OStim)
    EndFunction

    bool Function FullyAnimateRedress()
        return CoL_Global_OStim_Script.FullyAnimateRedress(OStim)
    EndFunction

    bool Function IsSceneAggressiveThemed()
        return CoL_Global_OStim_Script.IsSceneAggressiveThemed(OStim)
    EndFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

bool Function IsPlayerInvolved()
    return false
EndFunction

Actor[] Function GetActors()
EndFunction

Actor Function GetMostRecentOrgasmedActor()
EndFunction

bool Function FullyAnimateRedress()
EndFunction

bool Function IsSceneAggressiveThemed()
EndFunction

bool Function IsActorActive(Actor actorRef)
    return false
EndFunction
