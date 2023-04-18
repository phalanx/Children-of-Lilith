Scriptname CoL_Global_Ostim_Script Hidden

bool Function IsPlayerInvolved(Quest OStim_Quest) Global
    return (OStim_Quest as OSexIntegrationMain).IsPlayerInvolved()
EndFunction

bool Function IsActorActive(Quest OStim_Quest, Actor actorRef) Global
    return (OStim_Quest as OSexIntegrationMain).IsActorActive(actorRef)
EndFunction

Actor[] Function GetActors(Quest OStim_Quest) Global
    return (OStim_Quest as OSexIntegrationMain).GetActors()
EndFunction

Actor Function GetMostRecentOrgasmedActor(Quest OStim_Quest) Global
    return (OStim_Quest as OSexIntegrationMain).GetMostRecentOrgasmedActor()
EndFunction

bool Function FullyAnimateRedress(Quest OStim_Quest) Global
    return (OStim_Quest as OSexIntegrationMain).FullyAnimateRedress
EndFunction

bool Function IsSceneAggressiveThemed(Quest OStim_Quest) Global
    return (OStim_Quest as OSexIntegrationMain).IsSceneAggressiveThemed()
EndFunction