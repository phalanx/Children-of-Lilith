Scriptname CoL_Global_Ostim_Script Hidden

bool Function IsPlayerInvolved(Quest OStim) Global
    return (Ostim as OSexIntegrationMain).IsPlayerInvolved()
EndFunction

Actor[] Function GetActors(Quest OStim) Global
    return (OStim as OSexIntegrationMain).GetActors()
EndFunction

Actor Function GetMostRecentOrgasmedActor(Quest OStim) Global
    return (OStim as OSexIntegrationMain).GetMostRecentOrgasmedActor()
EndFunction

bool Function FullyAnimateRedress(Quest OStim) Global
    return (OStim as OSexIntegrationMain).FullyAnimateRedress
EndFunction

bool Function IsSceneAggressiveThemed(Quest OStim) Global
    return (OStim as OSexIntegrationMain).IsSceneAggressiveThemed()
EndFunction

Function ClearStrippedGear(Quest OStim, Actor victim) Global
    OUndressScript oUndress = (OStim as OSexIntegrationMain).GetUndressScript()
    Actor[] actors = CoL_Global_OStim_Script.GetActors(OStim)
    if victim == actors[0]
        ;Dom
        oUndress.DomEquipmentDrops = new ObjectReference[1]
        oUndress.DomEquipmentForms = new Form[1]
    elseif victim == actors[1]
        ;Sub
        oUndress.SubEquipmentDrops = new ObjectReference[1]
        oUndress.SubEquipmentForms = new Form[1]
    elseif victim == actors[2]
        ;Third
        oUndress.ThirdEquipmentDrops = new ObjectReference[1]
        oUndress.ThirdEquipmentForms = new Form[1]
    endif
EndFunction