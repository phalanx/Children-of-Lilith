Scriptname CoL_Ability_Transform_Powers_Script extends activemagiceffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Perk Property healingForm Auto
Perk Property terrifyingForm Auto
Perk Property energyCasting Auto

Spell Property healRateSpell Auto
Spell Property healRateMultSpell Auto
Spell Property transformBuffSpell Auto
Spell Property terrifyingFormSpell Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    CoL.transformReadiness[3] = false
    bool isTransformed = CoL.isTransformed
    Utility.Wait(1)
    if isTransformed
        UnTransform()
    else
        Transform()
    endif
    CoL.transformReadiness[3] = true
EndEvent

Function Log(string msg)
    CoL.Log("Transform - Powers - " + msg)
EndFunction

function Transform()
    Log("Adding additional powers")
    ApplyPerks()
    ApplyBuffs()
endfunction

Function ApplyPerks()
    if CoL.playerRef.HasPerk(healingForm)
        healRateSpell.SetNthEffectMagnitude(0, configHandler.healRateBoostAmount)
        healRateMultSpell.SetNthEffectMagnitude(0, configHandler.healRateBoostMult)
        CoL.playerRef.AddSpell(healRateSpell, false)
        CoL.playerRef.AddSpell(healRateMultSpell, false)
    endif
    if CoL.playerRef.HasPerk(terrifyingForm)
        Log("Casting Terrifying Form")
        terrifyingFormSpell.Cast(CoL.playerRef)
    endif
    if configHandler.autoEnergyCasting
        CoL.playerRef.AddPerk(energyCasting)
    endif
EndFunction

Function ApplyBuffs()
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
EndFunction

function UnTransform()
    Log("Removing additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.RemoveSpell(healRateSpell)
        CoL.playerRef.RemoveSpell(healRateMultSpell)
    endif
    if configHandler.autoEnergyCasting
        CoL.playerRef.RemovePerk(energyCasting)
    endif
    CoL.playerRef.RemoveSpell(transformBuffSpell)
endfunction