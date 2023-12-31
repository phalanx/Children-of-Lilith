Scriptname CoL_Generic_Toggle_Spell_Script extends activemagiceffect  

Spell Property SpellToToggle Auto
string Property displayName Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto
; Property to determine which config property to use for magnitude
; -1 = unset
; 0  = healRateBoostAmount
Int Property configIndex = -1 Auto
  
Event OnEffectStart(Actor akTarget, Actor akCaster)
    if akTarget.HasSpell(SpellToToggle)
        Debug.Notification(displayName + " Disabled")
        akTarget.RemoveSpell(SpellToToggle)
    Else
        Debug.Notification(displayName + " Enabled")
        if configIndex == 0
            if Col.playerEnergyCurrent >= configHandler.healRateBoostCost
                SpellToToggle.SetNthEffectMagnitude(1, configHandler.healRateBoostAmount)
            else
                Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
            endif
        endif
        akTarget.AddSpell(SpellToToggle, false)
    endif
EndEvent

; Event OnUpdate()
;     if configIndex == 0
;         if Col.playerEnergyCurrent < configHandler.healRateBoostCost
;             CoL.Log("Out of Energy")
;             Debug.Notification("Out of Energy: Heal Rate Boost Disabled")
;             CoL.playerRef.RemoveSpell(SpellToToggle)
;             return
;         endif
;         CoL.playerEnergyCurrent -= configHandler.healRateBoostCost
;         RegisterForSingleUpdate(1.0)
;     endif
; EndEvent