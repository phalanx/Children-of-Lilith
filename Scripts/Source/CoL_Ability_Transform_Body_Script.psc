Scriptname CoL_Ability_Transform_Body_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Faction Property playerWerewolfFaction Auto
Perk Property attractiveDremora Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bool isTransformed = CoL.isTransformed
    Utility.Wait(1)
    if isTransformed
        if CoL.lockTransform
            Debug.Notification("Arousal preventing untransforming")
            return
        endif
        UnTransform()
    else
        Transform()
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Transform - Body - " + msg)
EndFunction

Function Transform()
    Log("Transforming")
    CoL.isTransformed = true

    CoL.transformPlayer(CoL.succuPresetName, CoL.succuRace, CoL.succuHairColor)
    
    if configHandler.transformCrime && !CoL.playerRef.HasPerk(attractiveDremora)
        CoL.playerRef.SetAttackActorOnSight()
        CoL.playerRef.AddToFaction(playerWerewolfFaction)
    endif

    Utility.Wait(2) ; Wait for other scripts to hopefully be finished
EndFunction

Function UnTransform()
    Log("Untransforming")
    CoL.isTransformed = false
    CoL.transformPlayer(CoL.mortalPresetName, CoL.mortalRace, CoL.mortalHairColor)

    Utility.Wait(0.5)
    if configHandler.transformCrime 
        CoL.playerRef.SetAttackActorOnSight(false)
        CoL.playerRef.RemoveFromFaction(playerWerewolfFaction)
    endif

    Utility.Wait(2) ; Wait for other scripts to hopefully be finished
EndFunction

