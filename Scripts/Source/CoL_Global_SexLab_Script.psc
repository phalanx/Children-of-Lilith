Scriptname CoL_Global_SexLab_Script Hidden

sslThreadController Function GetController(Quest SexLab, int threadId) Global
    return (SexLab as SexLabFramework).GetController(threadId)
EndFunction

Function SetHook(Quest SexLab, int ThreadId, String hookName) Global
    sslThreadController thread = CoL_Global_SexLab_Script.GetController(SexLab, threadId)
    thread.SetHook(hookName)
EndFunction

Actor[] Function Positions(Quest SexLab, int threadId) Global
    sslThreadController thread = CoL_Global_SexLab_Script.GetController(SexLab, threadId)
    return thread.Positions
EndFunction