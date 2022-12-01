Scriptname CoL_Global_SLAR_Script Hidden

int function GetActorArousal(Quest SLAR, Actor akRef) Global
        return (SLAR as slaFrameworkScr).GetActorArousal(akRef)
endFunction


Int Function UpdateActorExposure(Quest SLAR, Actor akRef, Int val, String debugMsg = "") Global
        return (SLAR as slaFrameworkScr).UpdateActorExposure(akRef, val, debugMsg)
EndFunction