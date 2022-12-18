Scriptname CoL_Ability_Transform_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
Idle Property IdleVampireTransformation Auto
Faction Property playerWerewolfFaction Auto

; Transform Buff Settings


Form[] originalEquipment
Form[] succubusEquipment

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(1.5)
    if CoL.isTransformed
        if CoL.lockTransform
            Debug.Notification("Arousal preventing untransforming")
            return
        endif
        UnTransform()
    else
        Transform()
    endif
EndEvent

Function Transform()
    CoL.isTransformed = true
    ; Body Transform
    CoL.playerRef.SetRace(CoL.succuRace)
    CoL.playerRef.GetActorbase().SetHairColor(CoL.succuHairColor)
    Utility.Wait(0.1)
    CharGen.LoadPreset(CoL.succuPresetName)
    CoL.UpdateTattoo()
    ; Equipment Transform
    if CoL.transformSwapsEquipment
        originalEquipment = StripEquipment(CoL.playerRef)
        int i = 0
        while i < CoL.succuEquipmentChest.GetNumItems()
            succubusEquipment = PushForm(succubusEquipment, CoL.succuEquipmentChest.GetNthForm(i))
            i += 1
        endwhile
        SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, succubusEquipment)
        EquipEquipment(CoL.playerRef, succubusEquipment)
        SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, originalEquipment)
    endif
    AddAdditionalPowers()
    if CoL.transformCrime
        CoL.playerRef.SetAttackActorOnSight()
        CoL.playerRef.AddToFaction(playerWerewolfFaction)
    endif

EndFunction

Function UnTransform()
    CoL.isTransformed = false
    ; Body Transform
    CoL.playerRef.SetRace(CoL.mortalRace)
    CoL.playerRef.GetActorbase().SetHairColor(CoL.mortalHairColor)
    Utility.Wait(0.1)
    CharGen.LoadPreset(CoL.mortalPresetName)
    ; Equipment Transform
    if CoL.transformSwapsEquipment
        succubusEquipment = StripEquipment(CoL.playerRef)
        int i = 0
        while i < CoL.succuEquipmentChest.GetNumItems()
            originalEquipment = PushForm(originalEquipment, CoL.succuEquipmentChest.GetNthForm(i))
            i += 1
        endwhile
        SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, originalEquipment)
        EquipEquipment(CoL.playerRef, originalEquipment)
        SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, succubusEquipment)
    endif
    RemoveAdditionalPowers()
    if CoL.transformCrime
        CoL.playerRef.SetAttackActorOnSight(false)
        CoL.playerRef.RemoveFromFaction(playerWerewolfFaction)
    endif
EndFunction

function AddAdditionalPowers()
    if CoL.healingForm
        ToggleHealRateBoost(true)
    endif
    if CoL.transformBuffsEnabled
        CoL.playerRef.ModActorValue("Health", CoL.extraHealth)
        CoL.playerRef.ModActorValue("Stamina", CoL.extraStamina)
        CoL.playerRef.ModActorValue("Magicka", CoL.extraMagicka)
        CoL.playerRef.ModActorValue("CarryWeight", CoL.extraCarryWeight)
        CoL.playerRef.ModActorValue("attackDamageMult", CoL.extraMeleeDamage)
        CoL.playerRef.ModActorValue("DamageResist", CoL.extraArmor)
        CoL.playerRef.ModActorValue("MagicResist", CoL.extraMagicResist)
    endif
endfunction

function RemoveAdditionalPowers()
    if CoL.healingForm
        ToggleHealRateBoost(false)
    endif
    if CoL.transformBuffsEnabled
        CoL.playerRef.ModActorValue("Health", 0.0 - CoL.extraHealth)
        CoL.playerRef.ModActorValue("Stamina", 0 - CoL.extraStamina)
        CoL.playerRef.ModActorValue("Magicka", 0 - CoL.extraMagicka)
        CoL.playerRef.ModActorValue("CarryWeight", 0 - CoL.extraCarryWeight)
        CoL.playerRef.ModActorValue("attackDamageMult", 0 - CoL.extraMeleeDamage)
        CoL.playerRef.ModActorValue("DamageResist", 0 - CoL.extraArmor)
        CoL.playerRef.ModActorValue("MagicResist", 0 - CoL.extraMagicResist)
    endif
endfunction

Form[] function StripEquipment(Actor actorRef)
    int i = 31
    Form itemRef
    Form[] stripped = new Form[32]
	form[] NoStripList = CoL.NoStripList
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30)) 
		if itemRef 
            CoL.Log("Checking Item: " + itemRef.GetName())
			if  NoStripList.Find(itemRef) == -1    ; Make sure list exists and item is not part of no strip list
                if CoL.DebugLogging
                    CoL.Log("Item not found in striplist. List contains:")
                    int x = 0
                    while x < NoStripList.Length
                    	CoL.Log(NoStripList[x])
                    	x += 1
                    endwhile
                endif
                if CoL.IsStrippable(itemRef)
                    actorRef.UnequipItemEX(itemRef)
                    stripped[i] = itemRef
                endif
			endif
        endif
        i -= 1
    endwhile
    return PapyrusUtil.ClearNone(stripped)
endfunction

function SwapEquipment(ObjectReference swapFrom, ObjectReference swapTo, Form[] swapList)
	if swapList && swapList.Length > 0
		int i = 0
		while i < swapList.Length
			swapFrom.RemoveItem(swapList[i], 1, true, swapTo)
			i += 1
		endwhile
	endif
endfunction

function EquipEquipment(Actor actorRef, Form[] equipmentList)
	if equipmentList && equipmentList.Length > 0
		int i = 0
		while i < equipmentList.Length
			actorRef.EquipItemEx(equipmentList[i], 0, false)
			i += 1
		endwhile
	endif
endfunction

Function ToggleHealRateBoost(bool enable)
    float healRateBoost
    if CoL.healRateBoostFlat
        healRateBoost = CoL.healRateBoostMult
    else
        healRateBoost = CoL.playerRef.GetBaseActorValue("HealRate") * CoL.healRateBoostMult
    endif
    if enable
        CoL.playerRef.ModActorValue("HealRate", healRateBoost)
    else
        CoL.playerRef.ModActorValue("HealRate", 0.0 - healRateBoost)
    endif
endFunction
