Scriptname CoL_Ability_Transform_Body_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Faction Property playerWerewolfFaction Auto
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

Function Transform()
    CoL.Log("Transforming Body")
    CoL.isTransformed = true
    ; Body Transform
    CoL.transformPlayer(CoL.succuPresetName, CoL.succuRace, CoL.succuHairColor)
    
    if configHandler.transformCrime
        CoL.playerRef.SetAttackActorOnSight()
        CoL.playerRef.AddToFaction(playerWerewolfFaction)
    endif

    if configHandler.deadlyDrainWhenTransformed
        CoL.drainHandler.drainingToDeath = true
    endif
    Utility.Wait(2) ; Wait for other scripts to hopefully be finished
EndFunction

Function UnTransform()
    CoL.Log("Untransforming Body")
    CoL.isTransformed = false
    ; Body Transform
    CoL.transformPlayer(CoL.mortalPresetName, CoL.mortalRace, CoL.mortalHairColor)

    Utility.Wait(0.5)
    if configHandler.transformCrime
        CoL.playerRef.SetAttackActorOnSight(false)
        CoL.playerRef.RemoveFromFaction(playerWerewolfFaction)
    endif

    if configHandler.deadlyDrainWhenTransformed
        CoL.drainHandler.drainingToDeath = false
        CoL.drainHandler.draining = true
    endif
    Utility.Wait(2) ; Wait for other scripts to hopefully be finished
EndFunction

