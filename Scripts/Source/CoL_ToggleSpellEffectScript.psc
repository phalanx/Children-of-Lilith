Scriptname CoL_ToggleSpellEffectScript extends activemagiceffect  

Spell Property SpellToToggle Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        akTarget.RemoveSpell(SpellToToggle)
    Else
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent