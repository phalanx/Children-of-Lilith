Scriptname CoL_Ability_Transform_Equipment_Script extends activemagiceffect  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Form[] originalEquipment
Form[] succubusEquipment

Event OnEffectStart(Actor akTarget, Actor akCaster)
    bool isTransformed = CoL.isTransformed
    Utility.Wait(1)
    if isTransformed
        if CoL.lockTransform
            Debug.Notification("Arousal preventing untransforming")
            return
        endif
        UnTransform()
    else
        Transform()
    endif
EndEvent

Function Log(string msg)
    CoL.Log("Transform - Equipment - " + msg)
EndFunction

Function Transform()
    if configHandler.transformSwapsEquipment
        Log("Transforming")
        originalEquipment = StripEquipment(CoL.playerRef)
        int i = 0
        while i < CoL.succuEquipmentChest.GetNumItems()
            succubusEquipment = PapyrusUtil.PushForm(succubusEquipment, CoL.succuEquipmentChest.GetNthForm(i))
            i += 1
        endwhile
        SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, succubusEquipment)
        EquipEquipment(CoL.playerRef, succubusEquipment)
        SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, originalEquipment)
    endif
EndFunction

Function UnTransform()
    if configHandler.transformSwapsEquipment
        Log("Untransforming")
        succubusEquipment = StripEquipment(CoL.playerRef)
        int i = 0
        while i < CoL.succuEquipmentChest.GetNumItems()
            originalEquipment = PapyrusUtil.PushForm(originalEquipment, CoL.succuEquipmentChest.GetNthForm(i))
            i += 1
        endwhile
        SwapEquipment(CoL.succuEquipmentChest, CoL.playerRef, originalEquipment)
        EquipEquipment(CoL.playerRef, originalEquipment)
        SwapEquipment(CoL.playerRef, CoL.succuEquipmentChest, succubusEquipment)
    endif
EndFunction

Form[] function StripEquipment(Actor actorRef)
    int i = 31
    Form itemRef
    Form[] stripped = new Form[32]
	form[] NoStripList = configHandler.NoStripList
    Log("No Strip List Contains:")
    int x = 0
    while x < NoStripList.Length
        Log("    " + NoStripList[x])
        x += 1
    endwhile
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30)) 
		if itemRef 
            Log("Checking Item: " + itemRef.GetName())
			if  NoStripList.Find(itemRef) == -1    ; Make sure list exists and item is not part of no strip list
                if configHandler.DebugLogging
                    Log("Item not found in striplist")
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