Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto
String Property displayName Auto
CoL_ConfigHandler_Script Property configHandler Auto
; This value is to choose which value to pull from the configHandler for magnitude
; -1 = Unset
; 0 = healRateBoostAmount
Int Property magnitudeConfigValue = -1 Auto
  
Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        Debug.Notification(displayName + " Disabled")
        akTarget.RemoveSpell(SpellToToggle)
    Else
        Debug.Notification(displayName + " Enabled")
        if magnitudeConfigValue == 0
            SpellToToggle.SetNthEffectMagnitude(1, configHandler.healRateBoostAmount)
        endif
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent