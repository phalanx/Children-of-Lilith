Scriptname CoL_Ability_Transform_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Faction Property playerWerewolfFaction Auto

; Transform Buff Settings
Spell Property transformBuffSpell Auto

Form[] originalEquipment
Form[] succubusEquipment

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(1)
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
    CoL.transformPlayer(CoL.succuPresetName, CoL.succuRace, CoL.succuHairColor)
    
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

    if configHandler.deadlyDrainWhenTransformed
        CoL.drainHandler.drainingToDeath = true
    endif

EndFunction

Function UnTransform()
    CoL.isTransformed = false
    ; Body Transform
    CoL.transformPlayer(CoL.mortalPresetName, CoL.mortalRace, CoL.mortalHairColor)

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
    Utility.Wait(0.5)
    RemoveAdditionalPowers()
    if CoL.transformCrime
        CoL.playerRef.SetAttackActorOnSight(false)
        CoL.playerRef.RemoveFromFaction(playerWerewolfFaction)
    endif

    if configHandler.deadlyDrainWhenTransformed
        CoL.drainHandler.drainingToDeath = false
        CoL.drainHandler.draining = true
    endif

EndFunction

function AddAdditionalPowers()
    CoL.Log("Adding additional powers")
    if CoL.healingForm
        CoL.playerRef.ModActorValue("HealRate", (CoL.healRateBoostMult / 2))
    endif
    if CoL.transformBuffsEnabled
        transformBuffSpell.SetNthEffectMagnitude(0, CoL.extraHealth)
        transformBuffSpell.SetNthEffectMagnitude(1, CoL.extraStamina)
        transformBuffSpell.SetNthEffectMagnitude(2, CoL.extraMagicka)
        transformBuffSpell.SetNthEffectMagnitude(3, CoL.extraCarryWeight)
        transformBuffSpell.SetNthEffectMagnitude(4, CoL.extraMeleeDamage)
        transformBuffSpell.SetNthEffectMagnitude(5, CoL.extraArmor)
        transformBuffSpell.SetNthEffectMagnitude(6, CoL.extraMagicResist)
        CoL.playerRef.AddSpell(transformBuffSpell, false)
    endif
endfunction

function RemoveAdditionalPowers()
    CoL.Log("Removing additional powers")
    if CoL.healingForm
        CoL.playerRef.ModActorValue("HealRate", 0.0 - (CoL.healRateBoostMult / 2))
    endif
    if CoL.transformBuffsEnabled
        CoL.playerRef.RemoveSpell(transformBuffSpell)
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
                if configHandler.DebugLogging
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
