Scriptname CoL_Interface_Arousal_Script extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_OSL_Script Property OSL Auto
CoL_Interface_SLAR_Script Property SLAR Auto
CoL_Interface_Toys_Script Property Toys Auto

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function Log(string msg)
    CoL.Log("Interface - Arousal -" + msg)
EndFunction

Function OnGameLoad()
    Utility.Wait(5)
    if OSL.IsInterfaceActive() || SLAR.IsInterfaceActive() || Toys.IsInterfaceActive()
        GoToState("Installed")
    else
        Log("No arousal frameworks installed")
        GoToState("")
    endif
EndFunction

State Installed
    bool Function IsInterfaceActive()
        return True
    EndFunction

    float Function GetActorArousal(Actor target)
        int arousalMods = 0
        float targetArousal = 0.0
        if SLAR.IsInterfaceActive()
            targetArousal += SLAR.GetActorArousal(target)
            arousalMods += 1
        endif
        if OSL.IsInterfaceActive()
            targetArousal += OSL.GetArousal(target)
            arousalMods += 1
        endif
        if Toys.IsInterfaceActive() && target == CoL.playerRef
            targetArousal += Toys.GetRousing()
        endif
        if arousalMods > 0
            targetArousal = targetArousal / arousalMods
        else
            targetArousal = 0.0
        endif
        Log(target.GetDisplayName() + "'s Arousal: " + targetArousal)
        return targetArousal
    EndFunction

    Function ModifyArousal(Actor target, float amount)
        SLAR.UpdateActorExposure(target, (amount as int))
        if target == CoL.playerRef
            Toys.ArousalAdjust(amount as int)
        endif
        OSL.ModifyArousal(target, (amount as int), "CoL")
    EndFunction
EndState

bool Function IsInterfaceActive()
    return False
EndFunction

float Function GetActorArousal(Actor target)
    return 0.0
endFunction

Function ModifyArousal(Actor target, float amount)
endFunction