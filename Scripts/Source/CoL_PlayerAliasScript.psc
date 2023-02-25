Scriptname CoL_PlayerAliasScript extends ReferenceAlias

import MiscUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
ImageSpaceModifier Property EnergyCastingIMod Auto

Perk Property VancianMagicPerk = None Auto Hidden
GlobalVariable Property CurrentVancianCharges = None Auto Hidden
Float Property LastVancianCharges = 20.0 Auto Hidden ; memorize the last counted charges to check if the current spell did actually cost a charge or not

Function HandleOrdinatorVancian()
    If Game.GetModByName("Ordinator - Perks of Skyrim.esp") != 255
		VancianMagicPerk = Game.GetFormFromFile(0x02CB20, "Ordinator - Perks of Skyrim.esp") as Perk
		CurrentVancianCharges = Game.GetFormFromFile(0x167A0E, "Ordinator - Perks of Skyrim.esp") as GlobalVariable
		RegisterForSleep()
    Else
        VancianMagicPerk = None
        UnRegisterForSleep()
	EndIf
EndFunction

Event OnInit()
    if CoL.isPlayerSuccubus.GetValueInt() > 0
        CoL.GoToState("Initialize")
    endif
    HandleOrdinatorVancian()
EndEvent

Event OnPlayerLoadGame()
    CoL.Log("Player Loaded Game")
    CoL.Log("isPlayerSuccubus Value:" + CoL.isPlayerSuccubus.GetValueInt())
    HandleOrdinatorVancian()
    if CoL.isPlayerSuccubus.GetValueInt() > 0
        CoL.Log("Maintenance Should Run")
        CoL.Maintenance()
    endif

    int gameLoadEvent = ModEvent.Create("CoL_GameLoad")
    if gameLoadEvent
        ModEvent.Send(gameLoadEvent)
    endif

EndEvent

Event OnSpellCast(Form akSpell)
    Spell spellCast = akSpell as Spell
    if spellCast && CoL.playerRef.HasPerk(CoL.energyCastingPerk) && spellCast != CoL.energyCastingToggleSpell
        if VancianMagicPerk && CoL.playerRef.HasPerk(VancianMagicPerk)
            EnergyCastingIMod.Apply()
            Utility.Wait(0.1)
            if LastVancianCharges != CurrentVancianCharges.GetValue()
                ExpendEnergyVancian()
                Utility.Wait(0.1)
            endif
            EnergyCastingIMod.Remove()
        else
            EnergyCastingIMod.Apply()
            ExpendEnergy(spellCast)
            RegisterForSingleUpdate(0.2)
        endif
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
    if CoL.energyWeaver
        if CoL.isTransformed
            spellCost -= spellCost * 0.5
        else
            spellCost -= spellCost * 0.25
        endif
    endif
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

Function ExpendEnergyVancian()
    LastVancianCharges = CurrentVancianCharges.GetValue()
	float spellCost = 10.0*CoL.energyCastingMult
    if CoL.energyWeaver
        if CoL.isTransformed
            spellCost -= spellCost * 0.5
        else
            spellCost -= spellCost * 0.25
        endif
    endif
	if spellCost < CoL.playerEnergyCurrent
		CoL.playerEnergyCurrent -= spellCost
		LastVancianCharges += 1.0
		CurrentVancianCharges.SetValue(LastVancianCharges)
	else
        CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
		Debug.Notification("Not Enough Energy: Energy Casting Disabled")
	endif
EndFunction

Event OnVampirismStateChanged(bool isVampire)
    CoL.Log("Player vampire status chaged")
    string mortalRaceId = MiscUtil.GetRaceEditorID(CoL.mortalRace)
    string succubusRaceId = MiscUtil.GetRaceEditorID(CoL.succuRace)
    Race newMortalRace
    Race newSuccubusRace
    CoL.Log("Mortal race id before: " + mortalRaceId)
    CoL.Log("Succubus race id before: " + succubusRaceId)
    if isVampire
        CoL.mortalCureRace = CoL.mortalRace
        CoL.succuCureRace = CoL.succuRace
        mortalRaceId += "Vampire"
        succubusRaceId +="Vampire"
        newMortalRace = Race.GetRace(mortalRaceId)
        newSuccubusRace = Race.GetRace(succubusRaceId)
    else
        newMortalRace = CoL.mortalCureRace
        newSuccubusRace = CoL.succuCureRace
        CoL.mortalCureRace = None
        CoL.succuCureRace = None
    endif
    
    if (newMortalRace == None || newSuccubusRace == None)
        Debug.MessageBox("Could not automatically update succubus races.\nProceed with caution")
    else
        CoL.Log("Mortal race id after: " + MiscUtil.GetRaceEditorID(newMortalRace))
        CoL.Log("Succubus race id after: " + MiscUtil.GetRaceEditorID(newSuccubusRace))
        CoL.mortalRace = newMortalRace
        CoL.succuRace = newSuccubusRace
    endif
EndEvent