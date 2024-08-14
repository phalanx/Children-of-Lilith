Scriptname CoL_PlayerAliasScript extends ReferenceAlias

import MiscUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
ImageSpaceModifier Property EnergyCastingIMod Auto
Perk Property energyWeaver Auto

Perk Property VancianMagicPerk = None Auto Hidden
GlobalVariable Property CurrentVancianCharges = None Auto Hidden
Float Property LastVancianCharges = 20.0 Auto Hidden ; memorize the last counted charges to check if the current spell did actually cost a charge or not

String Property vampireErrorMessageBox = "CoL could not automatically update to new vampire races.\nProceed with caution" Auto Hidden

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
    Log("Player Loaded Game")
    Log("isPlayerSuccubus Value: " + CoL.isPlayerSuccubus.GetValueInt())
    HandleOrdinatorVancian()
    if CoL.isPlayerSuccubus.GetValueInt() > 0
        Log("Maintenance Should Run")
        CoL.Maintenance()
    endif

    int gameLoadEvent = ModEvent.Create("CoL_GameLoad")
    if gameLoadEvent
        ModEvent.Send(gameLoadEvent)
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Player Alias - " + msg)
EndFunction

Event OnSpellCast(Form akSpell)
    Spell spellCast = akSpell as Spell
    if spellCast && CoL.playerRef.HasPerk(CoL.energyCastingPerk) && spellCast != CoL.energyCastingToggleSpell
        if VancianMagicPerk && CoL.playerRef.HasPerk(VancianMagicPerk)
            if configHandler.energyCastingFXEnabled
                EnergyCastingIMod.Apply()
            endif
            Utility.Wait(0.1)
            if LastVancianCharges != CurrentVancianCharges.GetValue()
                ExpendEnergyVancian()
                Utility.Wait(0.1)
            endif
            if configHandler.energyCastingFXEnabled
                EnergyCastingIMod.Remove()
            endif
        else
            if configHandler.energyCastingFXEnabled
                EnergyCastingIMod.Apply()
            endif
            ExpendEnergy(spellCast)
            RegisterForSingleUpdate(0.2)
        endif
    endif
EndEvent

Event OnUpdate()
    if configHandler.energyCastingConcStyle == 0 ; if we want to calculate costs using only left hand
        Spell leftHandSpell = CoL.playerRef.GetEquippedSpell(0)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastLeft") && leftHandSpell
            ExpendEnergy(leftHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
            return
        endif

    elseif configHandler.energyCastingConcStyle == 1; if we want to calculate costs using both
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

    elseif configHandler.energyCastingConcStyle == 2; if we want to calculate costs using only right hand
        Spell rightHandSpell = CoL.playerRef.GetEquippedSpell(1)
        if CoL.playerRef.GetAnimationVariableBool("bWantCastRight") && rightHandSpell
            ExpendEnergy(rightHandSpell, 0.2)
            RegisterForSingleUpdate(0.2)
            return
        endif
    endif
    if configHandler.energyCastingFXEnabled
        EnergyCastingIMod.Remove()
    endif
EndEvent

Function ExpendEnergy(Spell spellCast, float costModifier = 1.0)
    CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
    float spellCost = (spellCast.GetEffectiveMagickaCost(CoL.playerRef) * configHandler.energyCastingMult) * costModifier
    if CoL.playerRef.HasPerk(energyWeaver)
        if CoL.isTransformed
            spellCost -= spellCost * 0.5
        else
            spellCost -= spellCost * 0.25
        endif
    endif
    CoL.playerRef.AddPerk(CoL.energyCastingPerk)
    if spellCost < energyHandler.playerEnergyCurrent
        energyHandler.playerEnergyCurrent -= spellCost 
    else
        CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
        energyHandler.playerEnergyCurrent = 0
        float magickaOverflow = spellCost - energyHandler.playerEnergyCurrent
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
	float spellCost = 10.0*configHandler.energyCastingMult
    if CoL.playerRef.HasPerk(energyWeaver)
        if CoL.isTransformed
            spellCost -= spellCost * 0.5
        else
            spellCost -= spellCost * 0.25
        endif
    endif
	if spellCost < energyHandler.playerEnergyCurrent
		energyHandler.playerEnergyCurrent -= spellCost
		LastVancianCharges += 1.0
		CurrentVancianCharges.SetValue(LastVancianCharges)
	else
        CoL.playerRef.RemovePerk(CoL.energyCastingPerk)
		Debug.Notification("Not Enough Energy: Energy Casting Disabled")
	endif
EndFunction

Event OnVampirismStateChanged(bool isVampire)
    Log("Player vampire status changed")
    if CoL.isPlayerSuccubus.GetValueInt() == 0
        Log("Player is not a succubus")
        return
    elseif !CoL.mortalPresetSaved && !CoL.succuPresetSaved
        Log("Forms not configured")
        return
    endif
    string mortalRaceId = MiscUtil.GetRaceEditorID(CoL.mortalRace)
    string succubusRaceId = MiscUtil.GetRaceEditorID(CoL.succuRace)
    Race newMortalRace
    Race newSuccubusRace
    Log("Mortal race id before: " + mortalRaceId)
    Log("Succubus race id before: " + succubusRaceId)

    if isVampire
        Log("Became Vampire")
        if StringUtil.Find(mortalRaceId, "Vampire") == -1
            mortalRaceId += "Vampire"
        else
            Log("WARNING - Mortal race was already a vampire race")
        endif
        newMortalRace = Race.GetRace(mortalRaceId)

        if StringUtil.Find(succubusRaceId, "Vampire") == -1
            succubusRaceId += "Vampire"
        else
            Log("WARNING - Succubus race was already a vampire race")
        endif
        newSuccubusRace = Race.GetRace(succubusRaceId)
    else
        Log("Vampirism Cured")

        int mortalVampireIndex = StringUtil.Find(mortalRaceId, "Vampire")
        if  mortalVampireIndex != -1
            mortalRaceId = StringUtil.Substring(mortalRaceId, 0, mortalVampireIndex)
        else
            Log("WARNING - Mortal race is already not a vampire race.")
        endif
        newMortalRace = Race.GetRace(mortalRaceId)

        int succubusVampireIndex = StringUtil.Find(succubusRaceId, "Vampire")
        if succubusVampireIndex != -1
            succubusRaceId = StringUtil.Substring(succubusRaceId, 0 , succubusVampireIndex)
        else
            Log("WARNING - Succubus race is already not a vampire race.")
        endif
        newSuccubusRace = Race.GetRace(succubusRaceId)
    endif
    
    if (newMortalRace == None || newSuccubusRace == None)
        Log("Error: Race Could Not Be Updated")
        Log("Desired Mortal race id after: " + mortalRaceId)
        Log("Desired Succubus race id after: " + succubusRaceId)
        Debug.MessageBox(vampireErrorMessageBox)
    else
        Log("Mortal race id after: " + MiscUtil.GetRaceEditorID(newMortalRace))
        Log("Succubus race id after: " + MiscUtil.GetRaceEditorID(newSuccubusRace))
        CoL.mortalRace = newMortalRace
        CoL.succuRace = newSuccubusRace
    endif
EndEvent