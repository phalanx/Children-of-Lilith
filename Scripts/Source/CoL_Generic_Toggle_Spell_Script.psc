Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        akTarget.RemoveSpell(SpellToToggle)
    Else
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent