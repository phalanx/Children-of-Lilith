Scriptname CoL_Ability_Transform_Powers_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Perk Property healingForm Auto
Spell Property transformBuffSpell Auto

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
    CoL.Log("Transform - Powers - " + msg)
EndFunction

function Transform()
    Log("Adding additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.ModActorValue("HealRate", (configHandler.healRateBoostAmount / 2))
    endif
    float[] buffs = new float[7]
    int i = 0
    while i < buffs.Length
        buffs[i] = (CoL.transformBuffs[i] * configHandler.transformRankEffects[i])
        if configHandler.transformBuffsEnabled
            buffs[i] = buffs[i] + configHandler.transformBaseBuffs[i]
        endif
        Log("Buff Effect " + i + ": " + buffs[i])
        transformBuffSpell.SetNthEffectMagnitude(i, buffs[i])
        i += 1
    endwhile
    Log("Adding Buff Spell")
    CoL.playerRef.AddSpell(transformBuffSpell, false)
endfunction

function UnTransform()
    Log("Removing additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.ModActorValue("HealRate", 0.0 - (configHandler.healRateBoostAmount / 2))
    endif
    CoL.playerRef.RemoveSpell(transformBuffSpell)
endfunction