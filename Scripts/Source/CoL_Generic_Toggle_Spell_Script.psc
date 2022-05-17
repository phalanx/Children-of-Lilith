Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto
string Property displayName Auto
  
Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        Debug.Notification(displayName + " Disabled")
        akTarget.RemoveSpell(SpellToToggle)
    Else
        Debug.Notification(displayName + " Enabled")
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent