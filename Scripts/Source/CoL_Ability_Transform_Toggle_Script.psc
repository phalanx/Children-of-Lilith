Scriptname CoL_Ability_Transform_Toggle_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Perk Property safeTransformation Auto
Spell Property transformSpell Auto
Spell Property transformCostSpell Auto

float etherealCost
Function Log(string msg)
    CoL.Log("Transform - Toggle - " + msg)
EndFunction

Event OnEffectStart(actor akTarget, actor akCaster)
    if CoL.isBusy()
        Log("Player is busy")
        return
    endif
    if CoL.lockTransform
        Debug.Notification("Arousal preventing transformation")
        return
    endif

    CoL.isTransforming = true
    if CoL.playerRef.HasSpell(transformCostSpell)
        CoL.playerRef.RemoveSpell(transformCostSpell)
    endif
    if CoL.playerRef.HasPerk(safeTransformation)
        etherealCost = configHandler.becomeEtherealCost
        configHandler.becomeEtherealCost = 0
        CoL.playerRef.AddSpell(CoL.becomeEthereal, false)
    endif

    transformSpell.Cast(CoL.playerRef)
    Utility.Wait(1)
    while !(CoL.transformReadiness[0] && CoL.transformReadiness[1] && CoL.transformReadiness[2] && CoL.transformReadiness[3])
        Log("Not Ready")
        Utility.Wait(1)
    endwhile
    Log("Ready")
    CoL.isTransformed = !CoL.isTransformed

    if CoL.playerRef.HasPerk(safeTransformation)
        CoL.playerRef.RemoveSpell(CoL.becomeEthereal)
        configHandler.becomeEtherealCost = etherealCost
    endif

    if CoL.isTransformed
        if !configHandler.transformMortalCost
            CoL.playerRef.AddSpell(transformCostSpell, false)
        endif
    else
        if configHandler.transformMortalCost
            CoL.playerRef.AddSpell(transformCostSpell, false)
        endif
    endif

    CoL.isTransforming = false
EndEvent
