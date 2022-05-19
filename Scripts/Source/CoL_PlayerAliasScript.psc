Scriptname CoL_PlayerAliasScript extends ReferenceAlias  

CoL_PlayerSuccubusQuestScript Property CoL Auto
ImageSpaceModifier Property EnergyCastingIMod Auto

Event OnInit()
    CoL.GoToState("Initialize")
EndEvent

Event OnPlayerLoadGame()
    CoL.Maintenance()
EndEvent

Event OnSpellCast(Form akSpell)
    Spell spellCast = akSpell as Spell
    if spellCast && CoL.playerRef.HasPerk(CoL.energyCastingPerk) && spellCast != CoL.energyCastingToggleSpell
        EnergyCastingIMod.Apply()
        RegisterForSingleUpdate(0.2)
        CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
        float spellCost = spellCast.GetEffectiveMagickaCost(CoL.playerRef) * CoL.energyCastingMult
        CoL.playerRef.AddPerk(CoL.energyCastingPerk)
        if spellCost < CoL.playerEnergyCurrent
            CoL.playerEnergyCurrent -= spellCost 
        else
            CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
            CoL.playerEnergyCurrent = 0
            float magickaOverflow = spellCost - CoL.playerEnergyCurrent
            if magickaOverflow < CoL.playerRef.GetActorValue("Magicka")
                CoL.playerRef.DamageActorValue("Magicka", magickaOverflow)
            else
                float currentMagicka = CoL.playerRef.GetActorValue("Magicka")
                float healthOverflow = magickaOverflow - currentMagicka
                CoL.playerRef.DamageActorValue("Magicka", currentMagicka)
                CoL.playerRef.DamageActorValue("Health", healthOverflow) ; Keep players from being able to cast super high level spells without enough energy+magicka+health. Hopefully.
            endif
            Debug.Notification("Out of Energy: Energy Casting Disabled")
        endif
    endif
EndEvent

Event OnUpdate()
    EnergyCastingIMod.Remove()
EndEvent