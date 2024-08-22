Scriptname CoL_Global_SexLab_Script Hidden

sslThreadController Function GetController(Quest SexLab, int threadId) Global
    return (SexLab as SexLabFramework).GetController(threadId)
EndFunction

sslthreadController Function GetControllerByActor(Quest SexLab, Actor actorRef) Global
    return (SexLab as SexLabFramework).GetActorController(actorRef)
EndFunction

Function TrackActor(Quest SexLab, Actor actorRef, string trackName) Global
    (SexLab as SexLabFramework).TrackActor(actorRef, trackName)
EndFunction

Function SetHook(Quest SexLab, int ThreadId, String hookName) Global
    sslThreadController thread = CoL_Global_SexLab_Script.GetController(SexLab, threadId)
    thread.SetHook(hookName)
EndFunction

Actor[] Function Positions(Quest SexLab, int threadId) Global
    sslThreadController thread = CoL_Global_SexLab_Script.GetController(SexLab, threadId)
    return thread.Positions
EndFunction

bool Function IsActorActive(Quest SexLab, Actor actorRef) Global
    return (SexLab as SexLabFramework).IsActorActive(actorRef)
EndFunction

bool Function IsVictim(Quest SexLab, Actor actorRef) Global
    sslThreadController thread = GetControllerByActor(SexLab, actorRef)
    return thread != None && thread.VictimRef != None && thread.VictimRef == actorRef
EndFunction

bool Function IsAggressor(Quest SexLab, Actor actorRef) Global
    sslThreadController thread = GetControllerByActor(SexLab, actorRef)
    return thread != None && thread.VictimRef != None && thread.VictimRef != actorRef
EndFunction

int Function GetVersion(Quest SexLab) Global
    return (SexLab as SexLabFramework).GetVersion()
EndFunction

String Function GetStringVer(Quest SexLab) Global
    return (SexLab as SexLabFramework).GetStringVer()
EndFunction