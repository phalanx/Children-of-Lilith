Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto
string Property displayName = " " Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
; Property to determine which config property to use for magnitude
; -1 = unset
; 0  = healRateBoostAmount
Int Property configIndex = -1 Auto
  
Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        if displayName != " "
            Debug.Notification(displayName + " Disabled")
        endif
        akTarget.RemoveSpell(SpellToToggle)
    Else
        if displayName != " "
            Debug.Notification(displayName + " Enabled")
        endif
        if configIndex == 0
            if energyHandler.playerEnergyCurrent >= configHandler.healRateBoostCost
                SpellToToggle.SetNthEffectMagnitude(1, configHandler.healRateBoostMult)
                SpellToToggle.SetNthEffectMagnitude(2, configHandler.healRateBoostAmount)
            else
                Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
            endif
        endif
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent