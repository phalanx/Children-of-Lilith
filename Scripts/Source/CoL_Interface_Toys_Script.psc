Scriptname CoL_Interface_Toys_Script extends Quest
import PapyrusUtil

Actor Property playerRef Auto
Keyword[] armBinderKeywords
Keyword toysToy

bool sceneInfoSet = false
bool playerSceneRunning = false
bool scenePlayerConsent = true

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

    ; This function accepts all the scene data but only uses part of it
    Function SetPlayerSceneData(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
        playerSceneRunning = true
        Debug.Trace("[CoL] PlayerConsent = " + PlayerConsent )
        scenePlayerConsent = PlayerConsent
        sceneInfoSet = true
    EndFunction

    Function ClearPlayerSceneData()
        playerSceneRunning = false
        scenePlayerConsent = true
        sceneInfoSet = false
    EndFunction

    bool Function isPlayerVictim()
        int i = 0
        while !sceneInfoSet && i < 30
            Utility.Wait(1)
            Debug.Trace("[CoL] Waiting for scene data...")
            i += 1
        endwhile
        return !scenePlayerConsent
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

Function setPlayerSceneData(string LoveName, Bool PlayerInScene, int NumStages, Bool PlayerConsent, Form ActInPos1, Form ActInPos2, Form ActInPos3, Form ActInPos4, Form ActInPos5)
EndFunction

Function ClearPlayerSceneData()
EndFunction

bool Function isPlayerVictim()
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