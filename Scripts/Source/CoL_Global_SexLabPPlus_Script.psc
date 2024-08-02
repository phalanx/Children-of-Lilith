Scriptname CoL_Global_SexLabPPlus_Script Hidden

SexLabThread Function GetThread(Quest SexLab, int tid) Global
    return (SexLab as SexLabFramework).GetThread(tid)
endFunction

SexLabThread Function GetThreadByActor(Quest SexLab, Actor actorRef) Global
    return (SexLab as SexLabFramework).GetThreadByActor(actorRef)
endFunction

bool Function IsVictim(Quest SexLab, Actor actorRef) Global
    SexLabThread thread = GetThreadByActor(SexLab, actorRef)
    if thread != None && IsNonCon(SexLab, thread)
        return thread.GetSubmissive(actorRef)
    endif
    return false
EndFunction

bool Function IsAggressor(Quest SexLab, Actor actorRef) Global
    SexLabThread thread = GetThreadByActor(SexLab, actorRef)
    if thread != None && IsNonCon(SexLab, thread)
        return !thread.GetSubmissive(actorRef)
    endif
    return false
EndFunction

bool Function IsNonCon(Quest SexLab, SexLabThread thread) Global
    ; Not enough mods use PPlus's contextual tagging yet, so for now this will hopefully work
    return !thread.IsConsent() || thread.HasTag("Aggressive") || thread.HasTag("aggressive") || thread.HasTag("Forced") || thread.HasTag("forced")
EndFunction