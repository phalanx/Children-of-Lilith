Scriptname CoL_Generic_Toggle_Perk_Script extends activemagiceffect  

Perk Property PerkToToggle Auto
string Property displayName Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasPerk(PerkToToggle)
        Debug.Notification(displayName + " Disabled")
        akTarget.RemovePerk(PerkToToggle)
    Else
        akTarget.AddPerk(PerkToToggle)
        Debug.Notification(displayName + " Enabled")
    endif
EndEvent