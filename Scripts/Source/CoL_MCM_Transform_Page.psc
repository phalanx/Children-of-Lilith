Scriptname CoL_MCM_Transform_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
CoL_PlayerSuccubusQuestScript psq
CoL_ConfigHandler_Script configHandler

bool loadEquipment = false
Form[] equippedItems

Event OnInit()
    RegisterModule("$COL_TRANSFORMPAGE_NAME", 70)
EndEvent

Event OnPageInit()
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    psq = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_PRESET")
    AddTextOptionST("Text_saveMortalPreset", "$COL_TRANSFORMPAGE_SAVEMORTALFORM", None)
    if psq.mortalPresetSaved
        AddTextOptionST("Text_LoadMortalPreset", "$COL_TRANSFORMPAGE_LOADMORTALFORM", None)
    else
        AddTextOptionST("Text_LoadMortalPreset", "$COL_TRANSFORMPAGE_LOADMORTALFORM", None, OPTION_FLAG_DISABLED)
    endif
    AddTextOptionST("Text_SaveSuccuPreset", "$COL_TRANSFORMPAGE_SAVESUCCUBUSFORM", None)
    if psq.succuPresetSaved
        AddTextOptionST("Text_LoadSuccuPreset", "$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM", None)
    else
        AddTextOptionST("Text_LoadSuccuPreset", "$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM", None, OPTION_FLAG_DISABLED)
    endif
    AddToggleOptionST("Toggle_TransformAnimation", "$COL_TRANSFORMPAGE_ANIMATION", configHandler.transformAnimation)
    AddToggleOptionST("Toggle_TransformCrime", "$COL_TRANSFORMPAGE_TRANSFORMCRIME", configHandler.transformCrime)
    AddToggleOptionST("Toggle_TransformEquipment", "$COL_TRANSFORMPAGE_EQUIPMENTSWAP", configHandler.transformSwapsEquipment)
    AddToggleOptionST("Toggle_TransformNiOverrides", "$COL_TRANSFORMPAGE_SAVENIOVERRIDES", configHandler.transformSavesNiOverrides)
    AddSliderOptionST("Slider_TransformCost", "$COL_TRANSFORMPAGE_ENERGYCOST", configHandler.transformCost)
    AddSliderOptionST("Slider_ArousalUpperThreshold", "$COL_TRANSFORMPAGE_AROUSALUPPERTHRESHOLD", configHandler.transformArousalUpperThreshold)
    AddSliderOptionST("Slider_ArousalLowerThreshold", "$COL_TRANSFORMPAGE_AROUSALLOWERTHRESHOLD", configHandler.transformArousalLowerThreshold)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_BUFFS")
    if psq.isTransformed
        AddTextOptionST("Text_NoTransformBuffChange", "$COL_TRANSFORMPAGE_CANTCHANGEBUFFS_MSQ", None)
    else
        AddToggleOptionST("Toggle_BuffsEnable", "$COL_TRANSFORMPAGE_BUFFSENABLED", configHandler.transformBuffsEnabled)
        AddSliderOptionST("Slider_BuffsArmor", "$COL_TRANSFORMPAGE_EXTRAARMOR", configHandler.extraArmor)
        AddSliderOptionST("Slider_BuffsMagicResist", "$COL_TRANSFORMPAGE_EXTRAMAGICRESIST", configHandler.extraMagicResist)
        AddSliderOptionST("Slider_BuffsHealth", "$COL_TRANSFORMPAGE_EXTRAHEALTH", configHandler.extraHealth)
        AddSliderOptionST("Slider_BuffsMagicka", "$COL_TRANSFORMPAGE_EXTRAMAGICKA", configHandler.extraMagicka)
        AddSliderOptionST("Slider_BuffsStamina", "$COL_TRANSFORMPAGE_EXTRASTAMINA", configHandler.extraStamina)
        AddSliderOptionST("Slider_BuffsExtraMeleeDamage", "$COL_TRANSFORMPAGE_EXTRAMELEEDAMAGE", configHandler.extraMeleeDamage, "{1}")
        AddSliderOptionST("Slider_BuffsExtraCarryWeight", "$COL_TRANSFORMPAGE_EXTRACARRYRATE", configHandler.extraCarryWeight)
    endif
    SetCursorPosition(1)
    AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_EQUIPMENT")
    AddTextOptionST("Text_ActivateEquipmentChest", "$COL_TRANSFORMPAGE_EQUIPMENTSAVE" , None)
    if !loadEquipment
        AddTextOptionST("Text_LoadEquipment", "$COL_TRANSFORMPAGE_LOADEQUIPMENT" , None)
    endif
    if loadEquipment
        equippedItems = getEquippedItems(psq.playerRef)
        AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_ADDNOSTRIP")
        int i = 0
        while i < equippedItems.Length
            if !psq.ddLibs || !equippedItems[i].hasKeyword(psq.ddLibs) ; Make sure it's not a devious device
                if configHandler.NoStripList.Find(equippedItems[i]) == -1
                    string itemName = equippedItems[i].GetName()
                    if itemName != "" && itemName != " "
                        AddTextOptionST("transformAddStrippable+" + i, itemName, None)
                    endif
                endif
            endif
            i += 1
        endwhile
        AddHeaderOption("$COL_TRANSFORMPAGE_HEADER_REMOVENOSTRIP")
        i = 0
        while i < configHandler.NoStripList.Length
            string itemName = configHandler.NoStripList[i].GetName()
            AddTextOptionST("transformRemoveStrippable+" + i, itemName, None)
            i += 1
        endwhile
    endif
EndEvent

Form[] function getEquippedItems(Actor actorRef)
	int i = 31
    Form itemRef
	equippedItems = new Form[34]
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30))
		if itemRef
            if psq.IsStrippable(itemRef)
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
        psq.mortalRace = psq.playerRef.GetRace()
        psq.mortalHairColor = psq.playerRef.GetActorbase().GetHairColor()
        Debug.MessageBox("$COL_TRANSFORMPAGE_FORMSAVEDMSG")
        psq.SavePreset(psq.mortalPresetName)
        psq.mortalPresetSaved = true
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_SAVEMORTALFORM_HELP")
    EndEvent
EndState
State Text_LoadMortalPreset
    Event OnSelectST(string state_id)
        Debug.MessageBox("$COL_TRANSFORMPAGE_FORMLOADEDMSG")
        Utility.Wait(0.1)
        psq.transformPlayer(psq.mortalPresetName, psq.mortalRace, psq.mortalHairColor)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_LOADMORTALFORM_HELP")
    EndEvent
EndState
State Text_SaveSuccuPreset
    Event OnSelectST(string state_id)
        psq.succuRace = psq.playerRef.GetRace()
        psq.succuHairColor = psq.playerRef.GetActorbase().GetHairColor()
        Debug.MessageBox("$COL_TRANSFORMPAGE_FORMSAVEDMSG")
        psq.SavePreset(psq.succuPresetName)
        psq.succuPresetSaved = True
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_SAVESUCCUBUSFORM_HELP")
    EndEvent
EndState
State Text_LoadSuccuPreset
    Event OnSelectST(string state_id)
        Debug.MessageBox("$COL_TRANSFORMPAGE_FORMLOADEDMSG")
        Utility.Wait(0.1)
        psq.transformPlayer(psq.succuPresetName, psq.succuRace, psq.succuHairColor)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_LOADSUCCUBUSFORM_HELP")
    EndEvent
EndState
State Text_ActivateEquipmentChest
    Event OnSelectST(string state_id)
        psq.succuEquipmentChest.Activate(psq.playerRef)
        Debug.MessageBox("$COL_TRANSFORMPAGE_EQUIPMENTSAVE_MSG")
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
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.transformCost = value
        SetSliderOptionValueST(configHandler.transformCost)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_ENERGYCOST_HELP")
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
State Slider_BuffsArmor
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraArmor)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1000)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraArmor = value
        SetSliderOptionValueST(configHandler.extraArmor)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRAARMOR_HELP")
    EndEvent
EndState
State Slider_BuffsMagicResist
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraMagicResist)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraMagicResist = value
        SetSliderOptionValueST(configHandler.extraMagicResist)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRAMAGICRESIST_HELP")
    EndEvent
EndState
State Slider_BuffsHealth
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraHealth)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1000)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraHealth = value
        SetSliderOptionValueST(configHandler.extraHealth)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRAHEALTH_HELP")
    EndEvent
EndState
State Slider_BuffsMagicka
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraMagicka)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1000)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraMagicka = value
        SetSliderOptionValueST(configHandler.extraMagicka)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRAMAGICKA_HELP")
    EndEvent
EndState
State Slider_BuffsStamina
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraStamina)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1000)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraStamina = value
        SetSliderOptionValueST(configHandler.extraStamina)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRASTAMINA_HELP")
    EndEvent
EndState
State Slider_BuffsExtraMeleeDamage
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraMeleeDamage)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraMeleeDamage = value
        SetSliderOptionValueST(configHandler.extraMeleeDamage, "{1}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRAMELEEDAMAGE_HELP")
    EndEvent
EndState
State Slider_BuffsExtraCarryWeight
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.extraCarryWeight)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1000)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.extraCarryWeight = value
        SetSliderOptionValueST(configHandler.extraCarryWeight)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_EXTRACARRYRATE_HELP")
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
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_TRANSFORMPAGE_AROUSALLOWERTHRESHOLD_HELP")
    EndEvent

EndState