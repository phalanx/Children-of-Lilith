Scriptname CoL_Interface_SexLab_Script extends Quest

Quest SexLab
bool Property PPlus = false auto hidden
CoL_ConfigHandler_Script Property  configHandler Auto

Event OnInit()
    Maintenance()
EndEvent

Function OnGameLoad()
    Maintenance()
EndFunction

Function Log(string msg)
    Debug.Trace("[CoL] Sexlab Interface - " + msg)
EndFunction

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    SexLab = Quest.GetQuest("SexLabQuestFramework")
    if SexLab != None
        if CoL_Global_SexLab_Script.GetVersion(SexLab) >= 20000
            Log("PPlus Detected")
            PPlus = true
        else
            Log("Base Sexlab Detected")
            PPlus = false
        endif
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction


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

    Function TrackActor(Actor actorRef, string trackName)
        CoL_Global_SexLab_Script.TrackActor(SexLab, actorRef, trackName)
    EndFunction

    bool Function IsActorActive(Actor actorRef)
        Return CoL_Global_SexLab_Script.IsActorActive(SexLab, actorRef)
    EndFunction

    bool Function IsVictim(Actor actorRef)
        if PPLus
            return CoL_Global_SexLabPPlus_Script.IsVictim(SexLab, actorRef, configHandler.PPlusTagCheck)
        else
            return CoL_Global_SexLab_Script.IsVictim(SexLab, actorRef)
        endif
    EndFunction

    bool Function IsAggressor(Actor actorRef)
        if PPLus
            return CoL_Global_SexLabPPlus_Script.IsAggressor(SexLab, actorRef, configHandler.PPlusTagCheck)
        else
           return CoL_Global_SexLab_Script.IsAggressor(SexLab, actorRef)
        endif
    EndFunction

EndState

bool Function IsInterfaceActive()
    return false
EndFunction

Function SetHook(int threadId, string hookName)
EndFunction

Function TrackActor(Actor actorRef, string trackName)
EndFunction

Actor[] Function Positions(int threadId)
EndFunction

bool Function IsActorActive(Actor actorRef)
EndFunction

bool Function IsVictim(Actor actorRef)
    return false
EndFunction

bool Function IsAggressor(Actor actorRef)
    return false
EndFunction