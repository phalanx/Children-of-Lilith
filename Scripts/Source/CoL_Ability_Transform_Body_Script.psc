Scriptname CoL_Ability_Transform_Body_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Interface_AnimatedWings Property iAnimatedWings Auto

Faction Property playerWerewolfFaction Auto
Perk Property attractiveDremora Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.transformReadiness[1] = false
    bool isTransformed = CoL.isTransformed
    Utility.Wait(1)
    if isTransformed
        UnTransform()
    else
        Transform()
    endif
    CoL.transformReadiness[1] = true
EndEvent

Function Log(string msg)
    CoL.Log("Transform - Body - " + msg)
EndFunction

Function Transform()
    Log("Transforming")

    CoL.transformPlayer(CoL.succuPresetName, CoL.succuRace, CoL.succuHairColor)
    iAnimatedWings.applyWings()
    
    if configHandler.transformCrime && !CoL.playerRef.HasPerk(attractiveDremora)
        CoL.playerRef.SetAttackActorOnSight()
        CoL.playerRef.AddToFaction(playerWerewolfFaction)
    endif
EndFunction

Function UnTransform()
    Log("Untransforming")
    CoL.transformPlayer(CoL.mortalPresetName, CoL.mortalRace, CoL.mortalHairColor)
    iAnimatedWings.RemoveWings()

    Utility.Wait(0.5)
    if configHandler.transformCrime 
        CoL.playerRef.SetAttackActorOnSight(false)
        CoL.playerRef.RemoveFromFaction(playerWerewolfFaction)
    endif
EndFunction

