Scriptname CoL_MCM_Transform_Page extends nl_mcm_module

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

String Property formSavedMsg = "Form Saved" Auto
String Property formLoadedMsg = "Form Loaded. Exit menu to apply changes" Auto
String Property equipmentSaveMsg = "Exit menu to select equipment" Auto

bool loadEquipment = false
Form[] equippedItems

Event OnInit()
    RegisterModule("$COL_TRANSFORMPAGE_NAME", 70)
EndEvent

Function Log(string msg)
    CoL.Log("MCM - Transform - " + msg)
EndFunction

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_PRESET")
    if CoL.isPlayerSuccubus.GetValueInt() == 0
        AddTextOptionST("Text_initFirst", "$COL_TRANSFORMPAGE_INITFIRST", None)
    else
        AddTextOptionST("Text_saveMortalPreset", "$COL_TRANSFORMPAGE_SAVEMORTALFORM", None)
        if CoL.mortalPresetSaved
            AddTextOptionST("Text_LoadMortalPreset", "$COL_TRANSFORMPAGE_LOADMORTALFORM", None)
        else
            AddTextOptionST("Text_LoadMortalPreset", "$COL_TRANSFORMPAGE_LOADMORTALFORM", None, OPTION_FLAG_DISABLED)
        endif
        AddTextOptionST("Text_SaveSuccuPreset", "$COL_TRANSFORMPAGE_SAVESUCCUBUSFORM", None)
        if CoL.succuPresetSaved
            AddTextOptionST("Text_LoadSuccuPreset", "$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM", None)
        else
            AddTextOptionST("Text_LoadSuccuPreset", "$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM", None, OPTION_FLAG_DISABLED)
        endif
    endif
    AddHeaderOption("")
    AddToggleOptionST("Toggle_TransformAnimation", "$COL_TRANSFORMPAGE_ANIMATION", configHandler.transformAnimation)
    AddToggleOptionST("Toggle_TransformDuringScene", "$COL_TRANSFORMPAGE_DURING_SCENE", configHandler.transformDuringScene)
    if configHandler.transformDuringScene
        AddSliderOptionST("Slider_transformDuringSceneChance", "$COL_TRANSFORMPAGE_DURINGSCENECHANCE", configHandler.transformDuringSceneChance * 100)
        AddSliderOptionST("Slider_transformIfPlayerVictimChance", "$COL_TRANSFORMPAGE_PLAYERVICTIMCHANCE", configHandler.transformIfPlayerVictimChance * 100)
        AddSliderOptionST("Slider_transformIfPlayerAggressorChance", "$COL_TRANSFORMPAGE_PLAYERAGGRESSORCHANCE", configHandler.transformIfPlayerAggressorChance * 100)
    endif
    AddToggleOptionST("Toggle_TransformCrime", "$COL_TRANSFORMPAGE_TRANSFORMCRIME", configHandler.transformCrime)
    AddToggleOptionST("Toggle_TransformEquipment", "$COL_TRANSFORMPAGE_EQUIPMENTSWAP", configHandler.transformSwapsEquipment)
    AddToggleOptionST("Toggle_TransformNiOverrides", "$COL_TRANSFORMPAGE_SAVENIOVERRIDES", configHandler.transformSavesNiOverrides)
    AddSliderOptionST("Slider_TransformCost", "$COL_TRANSFORMPAGE_ENERGYCOST", configHandler.transformCost, "{2}")
    AddToggleOptionST("Toggle_TransformMortalCost", "$COL_TRANSFORMPAGE_MORTALCOST", configHandler.transformMortalCost)
    AddSliderOptionST("Slider_ArousalUpperThreshold", "$COL_TRANSFORMPAGE_AROUSALUPPERTHRESHOLD", configHandler.transformArousalUpperThreshold)
    AddSliderOptionST("Slider_ArousalLowerThreshold", "$COL_TRANSFORMPAGE_AROUSALLOWERTHRESHOLD", configHandler.transformArousalLowerThreshold)
    AddToggleOptionST("Toggle_ArousalUntransform", "$COL_TRANSFORMPAGE_AROUSALUNTRANSFORM", configHandler.arousalUntransform)
    AddToggleOptionST("Toggle_AutoEnergyCasting", "$COL_TRANSFORMPAGE_AUTOENERGYCASTING", configHandler.autoEnergyCasting)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_BUFFS")
    if CoL.isTransformed
        AddTextOptionST("Text_NoTransformBuffChange", "$COL_TRANSFORMPAGE_CANTCHANGEBUFFS_MSQ", None)
    else
        AddToggleOptionST("Toggle_BuffsEnable", "$COL_TRANSFORMPAGE_BUFFSENABLED", configHandler.transformBuffsEnabled)
        int i = 0
        while i < configHandler.transformBaseBuffs.Length
            string formatString = "{0}"
            if i == 4
                formatString = "{1}"
            endif
            AddSliderOptionST("Slider_BaseBuffs___"+i, "$COL_TRANSFORMPAGE_BASEBUFFS_"+i, configHandler.transformBaseBuffs[i], formatString)
            i += 1
        endwhile
    endif
    SetCursorPosition(1)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_EQUIPMENT")
    AddTextOptionST("Text_ActivateEquipmentChest", "$COL_TRANSFORMPAGE_EQUIPMENTSAVE" , None)
    if !loadEquipment
        AddTextOptionST("Text_LoadEquipment", "$COL_TRANSFORMPAGE_LOADEQUIPMENT" , None)
    endif
    if loadEquipment
        LoadEquipmentList()
    endif
EndEvent

Event OnConfigClose()
    equippedItems = new Form[1]
    loadEquipment = false
EndEvent

Function LoadEquipmentList()
    equippedItems = getEquippedItems(CoL.playerRef)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_ADDNOSTRIP")
    ; We copy the NoStripList as an optimization to free up configHandler
    form[] NoStripList = configHandler.NoStripList
    int i = 0
    while i < equippedItems.Length
        if CoL.IsStrippable(equippedItems[i]) ; Make sure it's not a devious device
            if NoStripList.Find(equippedItems[i]) == -1
                string itemName = equippedItems[i].GetName()
                if itemName != "" && itemName != " "
                    AddTextOptionST("Text_AddStrippable___" + i, itemName, None)
                endif
            endif
        endif
        i += 1
    endwhile
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_REMOVENOSTRIP")
    i = 0
    while i < NoStripList.Length
        string itemName = NoStripList[i].GetName()
        AddTextOptionST("Text_RemoveStrippable___" + i, itemName, None)
        i += 1
    endwhile
EndFunction

Form[] function getEquippedItems(Actor actorRef)
	int i = 31
    Form itemRef
	equippedItems = new Form[34]
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30))
		if itemRef
            if CoL.IsStrippable(itemRef)
                equippedItems[i] = itemRef
            endif
		endif
		i -= 1
	endwhile
    equippedItems = PapyrusUtil.ClearNone(equippedItems)
    if PapyrusUtil.GetVersion() >= 40
        equippedItems = PapyrusUtil.RemoveDupeForm(equippedItems)
    else
        ; Deal with SE PapyrusUtils
        equippedItems = PapyrusUtil.MergeFormArray(equippedItems, equippedItems, true)
    endif
	return equippedItems
EndFunction

State Text_saveMortalPreset
    Event OnSelectST(string state_id)
        CoL.mortalRace = CoL.playerRef.GetRace()
        CoL.mortalHairColor = CoL.playerRef.GetActorbase().GetHairColor()
        Debug.MessageBox(formSavedMsg)
        CoL.SavePreset(CoL.mortalPresetName)
        CoL.mortalPresetSaved = true
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_SAVEMORTALFORM_HELP")
    EndEvent
EndState
State Text_LoadMortalPreset
    Event OnSelectST(string state_id)
        Debug.MessageBox(formLoadedMsg)
        Utility.Wait(0.1)
        CoL.transformPlayer(CoL.mortalPresetName, CoL.mortalRace, CoL.mortalHairColor)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_LOADMORTALFORM_HELP")
    EndEvent
EndState
State Text_SaveSuccuPreset
    Event OnSelectST(string state_id)
        CoL.succuRace = CoL.playerRef.GetRace()
        CoL.succuHairColor = CoL.playerRef.GetActorbase().GetHairColor()
        Debug.MessageBox(formSavedMsg)
        CoL.SavePreset(CoL.succuPresetName)
        CoL.succuPresetSaved = True
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_SAVESUCCUBUSFORM_HELP")
    EndEvent
EndState
State Text_LoadSuccuPreset
    Event OnSelectST(string state_id)
        Debug.MessageBox(formLoadedMsg)
        Utility.Wait(0.1)
        CoL.transformPlayer(CoL.succuPresetName, CoL.succuRace, CoL.succuHairColor)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM_HELP")
    EndEvent
EndState
State Text_ActivateEquipmentChest
    Event OnSelectST(string state_id)
        CoL.succuEquipmentChest.Activate(CoL.playerRef)
        Debug.MessageBox(equipmentSaveMsg)
        Utility.Wait(0.1)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EQUIPMENTSAVE_HELP")
    EndEvent
EndState
State Toggle_TransformCrime
    Event OnSelectST(string state_id)
        configHandler.transformCrime = !configHandler.transformCrime
        SetToggleOptionValueST(configHandler.transformCrime)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_TRANSFORMCRIME_HELP")
    EndEvent
EndState
State Toggle_TransformEquipment
    Event OnSelectST(string state_id)
        configHandler.transformSwapsEquipment = !configHandler.transformSwapsEquipment
        SetToggleOptionValueST(configHandler.transformSwapsEquipment)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EQUIPMENTSWAP_HELP")
    EndEvent
EndState
State Toggle_TransformNiOverrides
    Event OnSelectST(string state_id)
        configHandler.transformSavesNiOverrides = !configHandler.transformSavesNiOverrides
        SetToggleOptionValueST(configHandler.transformSavesNiOverrides)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_SAVENIOVERRIDES_HELP")
    EndEvent
EndState
State Toggle_TransformDuringScene
    Event OnSelectST(string state_id)
        configHandler.transformDuringScene = !configHandler.transformDuringScene
        SetToggleOptionValueST(configHandler.transformDuringScene)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_DURING_SCENE_HELP")
    EndEvent
EndState
State Slider_TransformDuringSceneChance
    Event OnSliderOpenST(string state_id)
        SetSliderDialog(configHandler.transformDuringSceneChance * 100, 0.0, 100.0, 1.0, 100.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformDuringSceneChance = value / 100
        SetSliderOptionValueST(configHandler.transformDuringSceneChance * 100)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_DURINGSCENECHANCE_HELP")
    EndEvent
EndState

State Slider_transformIfPlayerVictimChance
    Event OnSliderOpenST(string state_id)
        SetSliderDialog(configHandler.transformIfPlayerVictimChance * 100, 0.0, 100.0, 1.0, 100.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformIfPlayerVictimChance = value / 100
        SetSliderOptionValueST(configHandler.transformIfPlayerVictimChance * 100)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_PLAYERVICTIMCHANCE_HELP")
    EndEvent
EndState

State Slider_transformIfPlayerAggressorChance
    Event OnSliderOpenST(string state_id)
        SetSliderDialog(configHandler.transformIfPlayerAggressorChance * 100, 0.0, 100.0, 1.0, 100.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformIfPlayerAggressorChance = value / 100
        SetSliderOptionValueST(configHandler.transformIfPlayerAggressorChance * 100)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_PLAYERAGGRESSORCHANCE_HELP")
    EndEvent
EndState

State Toggle_TransformAnimation
    Event OnSelectST(string state_id)
        configHandler.transformAnimation = !configHandler.transformAnimation
        SetToggleOptionValueST(configHandler.transformAnimation)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_ANIMATION_HELP")
    EndEvent
EndState
State Slider_TransformCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.transformCost)
        SetSliderDialogDefaultValue(1)
        SetSliderDialogInterval(0.01)
        SetSliderDialogRange(-100, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformCost = value
        SetSliderOptionValueST(configHandler.transformCost, "{2}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_ENERGYCOST_HELP")
    EndEvent
EndState

State Toggle_TransformMortalCost
    Event OnSelectST(string state_id)
        configHandler.transformMortalCost = !configHandler.transformMortalCost
        SetToggleOptionValueST(configHandler.transformMortalCost)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_MORTALCOST_HELP")
    EndEvent
EndState
State Text_LoadEquipment
    Event OnSelectST(string state_id)
        loadEquipment = true
        ForcePageReset()
    EndEvent
EndState
State Toggle_BuffsEnable
    Event OnSelectST(string state_id)
        configHandler.transformBuffsEnabled = !configHandler.transformBuffsEnabled
        SetToggleOptionValueST(configHandler.transformBuffsEnabled)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_BUFFSENABLED_HELP")
    EndEvent
EndState
State Slider_BaseBuffs
    Event OnSliderOpenST(string state_id)
        SetSliderDialog(configHandler.transformBaseBuffs[state_id as int], 0, 1000, 1, 0)
        if state_id == "4"
            SetSliderDialogInterval(0.1)
        endif
        if state_id == "4" || state_id == "6"
            SetSliderDialogRange(0, 100)
        endif
    endEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformBaseBuffs[state_id as int] = value
        SetSliderOptionValueST(configHandler.transformBaseBuffs[state_id as int], "{1}")
    endEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_BASEBUFFS_" + state_id + "_HELP")
    EndEvent
EndState

State Slider_ArousalUpperThreshold
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.transformArousalUpperThreshold)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformArousalUpperThreshold = value
        SetSliderOptionValueST(configHandler.transformArousalUpperThreshold)
        configHandler.SendConfigUpdateEvent()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_AROUSALUPPERTHRESHOLD_HELP")
    EndEvent
EndState
State Slider_ArousalLowerThreshold
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.transformArousalLowerThreshold)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformArousalLowerThreshold = value
        SetSliderOptionValueST(configHandler.transformArousalLowerThreshold)
        configHandler.SendConfigUpdateEvent()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_AROUSALLOWERTHRESHOLD_HELP")
    EndEvent

EndState
State Toggle_ArousalUntransform
    Event OnSelectST(string state_id)
        configHandler.arousalUntransform = !configHandler.arousalUntransform
        SetToggleOptionValueST(configHandler.arousalUntransform)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_AROUSALUNTRANSFORM_HELP")
    EndEvent
EndState
State Toggle_AutoEnergyCasting
    Event OnSelectST(string state_id)
        configHandler.autoEnergyCasting = !configHandler.autoEnergyCasting
        SetToggleOptionValueST(configHandler.autoEnergyCasting)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_AUTOENERGYCASTING_HELP")
    EndEvent
EndState
State Text_AddStrippable
    Event OnSelectST(string state_id)
        int index = state_id as int
        Form itemRef = equippedItems[index]
        configHandler.NoStripList = PapyrusUtil.PushForm(configHandler.NoStripList, itemRef)

        if configHandler.DebugLogging
            Log("Adding " + itemRef.getName())
            int i = 0
            Log("Don't strip list contains:")
            while i < configHandler.NoStripList.Length
                Log(configHandler.NoStripList[i].getName())
                i += 1
            endwhile
        endif

        ForcePageReset()
    EndEvent
EndState
State Text_RemoveStrippable
    Event OnSelectST(string state_id)
        int index = state_id as int
        Form itemRef = configHandler.NoStripList[index]
        configHandler.NoStripList = PapyrusUtil.RemoveForm(configHandler.NoStripList, itemRef)

        if configHandler.DebugLogging
            Log("Removing " + itemRef.GetName())
            int i = 0
            Log("Worn Item List contains:")
            while i < equippedItems.Length
                Log(equippedItems[i].getName())
                i += 1
            endwhile
        endif

        ForcePageReset()
    EndEvent
EndState