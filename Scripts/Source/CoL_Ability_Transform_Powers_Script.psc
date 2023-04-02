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
    float healthBuff = (CoL.transformHealth * configHandler.transformHealthPerRank)
    CoL.Log(CoL.transformStamina + " " + configHandler.transformStaminaPerRank)
    float staminaBuff = (CoL.transformStamina * configHandler.transformStaminaPerRank)
    float magickaBuff = (CoL.transformMagicka * configHandler.transformMagickaPerRank)
    float carryWeightBuff = (CoL.transformCarryWeight * configHandler.transformCarryWeightPerRank)
    float meleeDamageBuff = (CoL.transformMeleeDamage * configHandler.transformMeleeDamagePerRank)
    float armorBuff = (CoL.transformArmor * configHandler.transformArmorPerRank)
    float magicResistBuff = (CoL.transformMagicResist * configHandler.transformMagicResistPerRank)
    if configHandler.transformBuffsEnabled
        healthBuff  += configHandler.transformBaseHealth
        staminaBuff += configHandler.transformBaseStamina
        magickaBuff += configHandler.transformBaseMagicka
        carryWeightBuff += configHandler.transformBaseCarryWeight
        meleeDamageBuff += configHandler.transformBaseMeleeDamage
        armorBuff   += configHandler.transformBaseArmor
        magicResistBuff += configHandler.transformBaseMagicResist
    endif
        CoL.Log("Health Buff: " + healthBuff)
        transformBuffSpell.SetNthEffectMagnitude(0, healthBuff)

        CoL.Log("Stamina Buff: " + staminaBuff)
        transformBuffSpell.SetNthEffectMagnitude(1, staminaBuff)

        CoL.Log("Magicka Buff: " + magickaBuff)
        transformBuffSpell.SetNthEffectMagnitude(2, magickaBuff)

        CoL.Log("Carry Weight Buff: " + carryWeightBuff)
        transformBuffSpell.SetNthEffectMagnitude(3, carryWeightBuff)

        CoL.Log("Melee Damage Buff: " + meleeDamageBuff)
        transformBuffSpell.SetNthEffectMagnitude(4, meleeDamageBuff)
        
        CoL.Log("Armor Buff: " + armorBuff)
        transformBuffSpell.SetNthEffectMagnitude(5, armorBuff)

        CoL.Log("Magic Resist Buff: " + magicResistBuff)
        transformBuffSpell.SetNthEffectMagnitude(6, magicResistBuff)

        CoL.playerRef.AddSpell(transformBuffSpell, false)
endfunction

function UnTransform()
    CoL.Log("Removing additional powers")
    if CoL.playerRef.HasPerk(healingForm)
        CoL.playerRef.ModActorValue("HealRate", 0.0 - (configHandler.healRateBoostAmount / 2))
    endif
    CoL.playerRef.RemoveSpell(transformBuffSpell)
endfunction