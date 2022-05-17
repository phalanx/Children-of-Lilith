Scriptname CoL_Generic_Toggle_Perk_Script extends activemagiceffect  

Perk Property PerkToToggle Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasPerk(PerkToToggle)
        Debug.Trace("[CoL] Removing Energy for Magicka Perk")
        akTarget.RemovePerk(PerkToToggle)
    Else
        Debug.Trace("[CoL] Adding Energy for Magicka Perk")
        akTarget.AddPerk(PerkToToggle)
    endif
EndEvent