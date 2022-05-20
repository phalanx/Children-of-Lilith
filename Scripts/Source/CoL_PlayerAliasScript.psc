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
        ExpendEnergy(spellCast)
        RegisterForSingleUpdate(0.2)
    endif
EndEvent

Event OnUpdate()
    if CoL.energyCastingConcStyle == 0 ; if we want to calculate costs using only left hand
        Spell leftHandSpell = CoL.playerRef.GetEquippedSpell(0)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastLeft") && leftHandSpell
            ExpendEnergy(leftHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
            return
        endif

    elseif Col.energyCastingConcStyle == 1; if we want to calculate costs using both
        Spell leftHandSpell = CoL.playerRef.GetEquippedSpell(0)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastLeft") && leftHandSpell
            ExpendEnergy(leftHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
        endif
        
        Spell rightHandSpell = CoL.playerRef.GetEquippedSpell(1)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastRight") && rightHandSpell
            ExpendEnergy(rightHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
        endif

        if CoL.playerRef.GetAnimationVariableBool("bWantCastLeft") || CoL.playerRef.GetAnimationVariableBool("bWantCastRight")
            return
        endif

    elseif Col.energyCastingConcStyle == 2; if we want to calculate costs using only right hand
        Spell rightHandSpell = CoL.playerRef.GetEquippedSpell(1)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastRight") && rightHandSpell
            ExpendEnergy(rightHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
            return
        endif
    endif
    EnergyCastingIMod.Remove()
EndEvent

Function ExpendEnergy(Spell spellCast, float costModifier = 1.0)
    CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
    float spellCost = (spellCast.GetEffectiveMagickaCost(CoL.playerRef) * CoL.energyCastingMult) * costModifier
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
EndFunction