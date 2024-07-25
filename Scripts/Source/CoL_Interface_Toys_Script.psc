Scriptname CoL_Interface_Toys_Script extends Quest
import PapyrusUtil

Actor Property playerRef Auto
Keyword[] armBinderKeywords
Keyword toysToy

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("Toys.esm")
        GetToysKeywords()
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

Function GetToysKeywords()
    toysToy = Keyword.GetKeyword("ToysToyNoStrip")

    armBinderKeywords = new Keyword[2]
    armBinderKeywords[0] = Keyword.GetKeyword("ToysEffect_ArmBind")
    armBinderKeywords[1] = Keyword.GetKeyword("ToysEffect_YokeBind")
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction

    int Function GetRousing()
        return ToysGlobal.GetRousing()
    EndFunction

    bool Function isBusy()
        return ToysGlobal.isBusy()
    EndFunction

    Function ArousalAdjust(int adjArousal, bool ForceNotify = false )
        ToysGlobal.ArousalAdjust(adjArousal, ForceNotify)
    EndFunction

    Function Caress()
        ToysGlobal.Caress()
    EndFunction

    bool Function IsStrippable(Form itemRef)
        return !itemRef.hasKeyword(toysToy)
    endFunction

    bool Function ArmsBound()
        int i = 0
        while i < armBinderKeywords.Length
            if playerRef.WornHasKeyword(armBinderKeywords[i])
                return true
            endif
            i += 1
        endWhile
        return false
    EndFunction

EndState

int Function GetRousing()
EndFunction

Function ArousalAdjust(int adjArousal, bool ForceNotify = false )
EndFunction

Function Caress()
EndFunction

bool Function isBusy()
    return false
EndFunction

bool Function IsInterfaceActive()
    return false
EndFunction

bool Function IsStrippable(Form itemRef)
    return true
EndFunction

bool Function ArmsBound()
    return false
EndFunction