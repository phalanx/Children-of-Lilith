Scriptname CoL_Global_SLAR_Script Hidden

int function GetActorArousal(Quest SLAR, Actor akRef) Global
        return (SLAR as slaFrameworkScr).GetActorArousal(akRef)
endFunction