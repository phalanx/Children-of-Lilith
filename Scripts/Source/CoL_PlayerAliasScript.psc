Scriptname CoL_PlayerAliasScript extends ReferenceAlias  

CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    CoL.GoToState("Initialize")
EndEvent

Event OnPlayerLoadGame()
    CoL.Maintenance()
EndEvent

Event OnSpellCast(Form akSpell)
    Spell spellCast = akSpell as Spell
    if spellCast && CoL.playerRef.HasPerk(CoL.energyForMagickaPerk) && spellCast != CoL.energyForMagickaToggleSpell
        CoL.playerRef.RemovePerk(CoL.energyForMagickaPerk)
        int spellCost = spellCast.GetEffectiveMagickaCost(CoL.playerRef)
        CoL.playerRef.AddPerk(CoL.energyForMagickaPerk)
        if spellCost < CoL.playerEnergyCurrent
            CoL.playerEnergyCurrent -= spellCost
        else
            CoL.playerRef.RemovePerk(CoL.energyForMagickaPerk)
            CoL.playerEnergyCurrent = 0
            Debug.Notification("Out of Energy - Disabling Energy Casting")
        endif
        if CoL.DebugLogging
            Debug.Trace("[CoL] New Energy Level: " + CoL.playerEnergyCurrent)
        endif
    endif
EndEvent

float currentHealth = 0.0
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
  bool abBashAttack, bool abHitBlocked)
  float newHealth = CoL.playerRef.GetActorValue("Health")
  if currentHealth
    Debug.Trace("[CoL] Health Lost: " + (currentHealth - newHealth) as string)
  endif
  currentHealth = newHealth
EndEvent