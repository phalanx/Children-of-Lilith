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

function Transform()
    CoL.Log("Adding additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.ModActorValue("HealRate", (configHandler.healRateBoostAmount / 2))
    endif
    float[] buffs = new float[7]
    int i = 0
    while i < buffs.Length
        buffs[i] = (CoL.transformBuffs[i] * configHandler.transformRankEffects[i])
        i += 1
    endwhile
    if configHandler.transformBuffsEnabled
        buffs[0] = buffs[0] + configHandler.transformBaseHealth
        buffs[1] = buffs[1] + configHandler.transformBaseStamina
        buffs[2] = buffs[2] + configHandler.transformBaseMagicka
        buffs[3] = buffs[3] + configHandler.transformBaseCarryWeight
        buffs[4] = buffs[4] + configHandler.transformBaseMeleeDamage
        buffs[5] = buffs[5] + configHandler.transformBaseArmor
        buffs[6] = buffs[6] + configHandler.transformBaseMagicResist
    endif
    i = 0
    while i < transformBuffSpell.GetNumEffects()
        CoL.Log("Buff Effect " + i + ": " + buffs[i])
        transformBuffSpell.SetNthEffectMagnitude(i, buffs[i])
        i += 1
    endwhile
    CoL.Log("Adding Buff Spell")
    CoL.playerRef.AddSpell(transformBuffSpell, false)
endfunction

function UnTransform()
    CoL.Log("Removing additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.ModActorValue("HealRate", 0.0 - (configHandler.healRateBoostAmount / 2))
    endif
    CoL.playerRef.RemoveSpell(transformBuffSpell)
endfunction