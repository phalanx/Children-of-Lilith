Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto
string Property displayName = " " Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
  
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
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent