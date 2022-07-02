Scriptname CoL_Ability_Transform_Script extends activemagiceffect  

import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
Idle Property IdleVampireTransformation Auto

Form[] originalEquipment
Form[] succubusEquipment

Event OnEffectStart(Actor akTarget, Actor akCaster)
    Utility.Wait(1.5)
    if CoL.isTransformed
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
    ; Equipment Transform
    originalEquipment = StripEquipment(CoL.playerRef)
    int i = 0
    while i < CoL.succuEquipmentChest.GetNumItems()
        succubusEquipment = PushForm(succubusEquipment, CoL.succuEquipmentChest.GetNthForm(i))
        i += 1
    endwhile
    SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, succubusEquipment)
    EquipEquipment(CoL.playerRef, succubusEquipment)
    SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, originalEquipment)
EndFunction

Function UnTransform()
    CoL.isTransformed = false
    ; Body Transform
    CoL.playerRef.SetRace(CoL.mortalRace)
    CoL.playerRef.GetActorbase().SetHairColor(CoL.mortalHairColor)
    Utility.Wait(0.1)
    CharGen.LoadPreset(CoL.mortalPresetName)
    ; Equipment Transform
    succubusEquipment = StripEquipment(CoL.playerRef)
    int i = 0
    while i < CoL.succuEquipmentChest.GetNumItems()
        originalEquipment = PushForm(originalEquipment, CoL.succuEquipmentChest.GetNthForm(i))
        i += 1
    endwhile
    SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, originalEquipment)
    EquipEquipment(CoL.playerRef, originalEquipment)
    SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, succubusEquipment)
EndFunction

Form[] function StripEquipment(Actor actorRef)
    int i = 31
    Form itemRef
    Form[] stripped = new Form[32]
	form[] NoStripList = CoL.NoStripList
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30)) 
		if itemRef 
            if CoL.DebugLogging
                Debug.Trace("[CoL] Checking Item: " + itemRef.GetName())
            endif
			if  NoStripList.Find(itemRef) == -1    ; Make sure list exists and item is not part of no strip list
                if CoL.DebugLogging
                    Debug.Trace("[CoL] Item not found in striplist. List contains:")
                    int x = 0
                    while x < NoStripList.Length
                    	Debug.Trace(NoStripList[x])
                    	x += 1
                    endwhile
                endif
                if !CoL.ddLibs || !itemRef.hasKeyword(CoL.ddLibs) ; Make sure it's not a devious device, if compatibility patch installed
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