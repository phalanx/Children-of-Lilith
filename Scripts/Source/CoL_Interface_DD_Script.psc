Scriptname CoL_Interface_DD_Script extends Quest
import PapyrusUtil

Actor Property playerRef Auto
Keyword[] armBinderKeywords
Keyword zadLockable

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
    if Game.IsPluginInstalled("Devious Devices - Assets.esm")
        GetDDKeywords()
        GoToState("Installed")
    else
        GoToState("")
    endif
EndFunction

Function GetDDKeywords()
    zadLockable = Keyword.GetKeyword("zad_Lockable")

    armBinderKeywords = new Keyword[9]
    armbinderKeywords[0] = Keyword.GetKeyword("zad_DeviousArmbinder")
    armbinderKeywords[1] = Keyword.GetKeyword("zad_DeviousArmbinderElbow")
    armbinderKeywords[2] = Keyword.GetKeyword("zad_DeviousStraitJacket")
    armbinderKeywords[3] = Keyword.GetKeyword("zad_DeviousYoke")
    armbinderKeywords[4] = Keyword.GetKeyword("zad_DeviousYokeBB")
    armbinderKeywords[5] = Keyword.GetKeyword("zad_DeviousElbowTie")
    armbinderKeywords[6] = Keyword.GetKeyword("zad_DeviousYoke")
    armbinderKeywords[7] = Keyword.GetKeyword("zad_DeviousYoke")
    armbinderKeywords[8] = Keyword.GetKeyword("zad_DeviousYoke")
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return true
    EndFunction

    bool Function IsStrippable(Form itemRef)
        return !itemRef.hasKeyword(zadLockable)
    endFunction

    bool Function ArmsBound()
        int i = 0
        while i < armBinderKeywords.Length
            if playerRef.WornHasKeyword(armBinderKeywords[i])
                Debug.Trace("[CoL] DD Interfaces - Item has Keyword: " + armBinderKeywords[i].GetString())
                return true
            endif
            i += 1
        endWhile
        Debug.Trace("[CoL] DD Interfaces - Item is not a DD armbinder")
        return false
    EndFunction
EndState

bool Function IsInterfaceActive()
    return false
EndFunction

bool Function IsStrippable(Form itemRef)
    return true
endFunction

bool Function ArmsBound()
    return false
endFunction