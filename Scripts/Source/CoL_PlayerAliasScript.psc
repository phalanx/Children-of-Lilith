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
    Actor playerRef = GetReference() as Actor
    if akSpell && CoL.alternativeCasting
        int spellCost = spellCast.GetEffectiveMagickaCost(playerRef)
        if spellCost < CoL.playerEnergyCurrent
            CoL.playerEnergyCurrent -= spellCost
            playerRef.RestoreActorValue("Magicka", spellCost)
        else
            CoL.alternativeCasting = false
            playerRef.RestoreActorValue("Magicka", CoL.playerEnergyCurrent)
            CoL.playerEnergyCurrent = 0
            Debug.Notification("Out of Energy - Disabling Alternative Casting")
        endif
        if CoL.DebugLogging
            Debug.Trace("[CoL] New Energy Level: " + CoL.playerEnergyCurrent)
        endif
    endif
EndEvent