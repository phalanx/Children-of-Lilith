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
    if akSpell && CoL.playerRef.HasPerk(CoL.energyForMagickaPerk)
        Debug.Trace("[CoL] Calculating Spell Cost")
        CoL.playerRef.RemovePerk(CoL.energyForMagickaPerk)
        int spellCost = spellCast.GetEffectiveMagickaCost(CoL.playerRef)
        CoL.playerRef.AddPerk(CoL.energyForMagickaPerk)
        Debug.Trace("[CoL] Done Calculating Spell Cost")
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