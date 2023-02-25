Scriptname CoL_Generic_Toggle_Perk_Script extends activemagiceffect  

Perk Property PerkToToggle Auto
string Property displayName Auto
bool Property verbose = true Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasPerk(PerkToToggle)
        if verbose
            Debug.Notification(displayName + " Disabled")
        endif
        akTarget.RemovePerk(PerkToToggle)
    Else
        akTarget.AddPerk(PerkToToggle)
        if verbose
            Debug.Notification(displayName + " Enabled")
        endif
    endif
EndEvent