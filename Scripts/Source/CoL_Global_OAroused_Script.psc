Scriptname CoL_Global_OAroused_Script Hidden

float function GetArousal(Quest OAroused, Actor akRef) Global
        return (OAroused as OArousedScript).GetArousal(akRef)
endFunction

float Function ModifyArousal(Quest OAroused, Actor akRef, float val) Global
        return (OAroused as OArousedScript).ModifyArousal(akRef, val)
EndFunction
