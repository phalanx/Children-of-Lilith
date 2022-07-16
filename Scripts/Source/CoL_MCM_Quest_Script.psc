Scriptname CoL_MCM_Quest_Script extends SKI_ConfigBase

import CharGen
import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus

string[] settingsPageEnergyCastingConcStyleOptions
bool meterBarChanged = false
Form[] equippedItems

; String values to make translating the menu easier once I figure out how translation files work
; Page 1 - Status
    string statusPageName = "Status"
    string statusPageHeaderOne = "Current Stats"
    string statusPageCurrentLevel = "Current Succubus Level"
    string statusPageCurrentXP = "Current Succubus Exp"
    string statusPageNextLevelXP = "Exp Required for Next Level"
    string statusPageEnergyCurrent = "Current energy"
    string statusPageEnergyMax = "Maximum energy"
    string statusPageEnergyMaxHelp = "Set Your Maximum Energy. Could be considered a cheat"
    string statusPageBecomeSuccubus = "Become Succubus"
    string statusPageBecomeSuccubusHelp = "Enables the mod, turning you into a succubus"
    string statusPageEndSuccubus = "End Succubus"
    string statusPageEndSuccubusHelp = "Disables the mod, returning you to human/mer"
    string statusPageHeaderTwo = "Debug and Maintenance"
    string statusPageRefillEnergy = "Refill Energy"
    string statusPageRefillEnergyHelp = "Cheat: Refills Energy"
    string statusPageDebugLogging = "Toggle Debug Logging"
    string statusPageDebugLoggingHelp = "Toggles Debug Logging. \n Warning: this can produce a lot of log entries. Only enable for troubleshooting"

; Page 2 - Settings
    string settingsPageName = "Settings"
    string settingsPageDrainHeader = "Drain Settings"
    string settingsPageDrainToggle = "Drain"
    string settingsPageDrainToggleHelp = "Toggle Draining"
    string settingsPageDrainToDeathToggle = "Drain to Death"
    string settingsPageDrainToDeathToggleHelp = "Toggle Drain to Death. Takes precedent over Drain setting"
    string settingsPageDrainDuration = "Drain Duration"
    string settingsPageDrainDurationHelp = "How long the Drain health debuff lasts, in game hours"
    string settingsPageHealthDrainMult = "Health Drain Multiplier"
    string settingsPageHealthDrainMultHelp = "The percentage of health drained from victim \n (Victim Health * [this value]) = Health Drained"
    string settingsPageEnergyConversionRate = "Energy Conversion Rate"
    string settingsPageEnergyConversionRateHelp = "Percentage of Drained Health that is converted to Energy \n (Health Drained * [This Value]) = Energy Gained"
    string settingsPageDrainFeedsVampire = "Drain Feeds Vampires"
    string settingsPageDrainFeedsVampireHelp = "Should drain victims also trigger a vampire feeding"

    string settingsPageLevelHeader = "Leveling Settings"
    string settingsPageLevelXpPerDrain = "XP Per Drain"
    string settingsPageLevelXpPerDrainHelp = "Set XP Gained Per Drain"
    string settingsPageLevelXpDeathMult = "XP Drain to Death Mult"
    string settingsPageLevelXpDeathMultHelp = "Multiplier applied to XP Per Drain when Victim is Drained to Death"
    string settingsPageLevelXpConstant = "XP Constant"
    string settingsPageLevelXpConstantHelp = "Set the XP Constant.\nLower values = more XP required per level\nFormula is (next_level/Constant)^Power"
    string settingsPageLevelXpPower = "XP Power"
    string settingsPageLevelXpPowerHelp = "Set the XP Power. Controls how quickly the required XP per level grows.\n Higher values = larger gaps between levels\nFormula is (next_level/Constant)^Power"
    string settingsPageLevelLevelsPerPerk = "Levels Before Perk"
    string settingsPageLevelLevelsPerPerkHelp = "Set how many levels before recieving a perk point"
    string settingsPageLevelPerksPerLevel = "Perk Points Recieved"
    string settingsPageLevelPerksPerLevelHelp = "Set how many perk points you recieve when you receive them"

    string settingsPageHungerHeader = "Hunger Settings"
    string settingsPageHungerToggle = "Hunger"
    string settingsPageHungerToggleHelp = "Enable Passive Energy Drain. Hunger updates every 30 seconds"
    string settingsPageHungerAmount = "Hunger Amount"
    string settingsPageHungerAmountHelp = "If Hunger is enabled, this sets the amount of Energy lost on a daily basis"
    string settingsPageHungerDamage = "Deadly Hunger"
    string settingsPageHungerDamageHelp = "If Hunger is enabled, this sets whether or not running out of Energy will cause periodic "
    string settingsPageHungerDamageAmount = "Hunger Damage Amount"
    string settingsPageHungerDamageAmountHelp = "If Hunger Damage is enabled, Max Health will be reduced by this amount per Hunger tick (30 seconds)"

    string settingsPagePowerHeader = "Power Settings"
    string settingsPageBecomeEtherealCost = "Become Ethereal Cost"
    string settingsPageBecomeEtherealCostHelp = "Per Second Energy Cost of Succubus Become Ethereal"
    string settingsPageHealRateBoostCost = "HealRate Boost Cost"
    string settingsPageHealRateBoostCostHelp = "Per Second Cost of Succubus Heal Rate Boost"
    string settingsPageHealRateBoostMult = "HealRate Boost Multiplier"
    string settingsPageHealRateBoostMultHelp = "Multiplier applied to HealRate during Succubus Heal Rate Boost"
    string settingsPageEnergyCastingMult = "Energy Casting Cost Multiplier"
    string settingsPageEnergyCastingMultHelp = "Multiplier applied to spells Magicka cost before being removed from Energy Pool \n (Spell Magicka Cost * [This Value]) = Energy Cost of Spell"
    string settingsPageEnergyCastingConcStyle = "Cost Calculation Style"
    string settingsPageEnergyCastingConcStyleHelp = "Select a Concentration Cost Calculation Style \n See Mod Description for more information"
    string settingsPageEnergyCastingConcStyleLeftOnly = "Left Hand Only" 
    string settingsPageEnergyCastingConcStyleBothHands = "Both Hands" 
    string settingsPageEnergyCastingConcStyleRightOnly = "Right Hand Only" 
    string settingsPageEnergyCastingConcStyleNone = "Cheat: Neither" 
; Page 3 - Hotkeys
    string hotkeysPageName = "Hotkeys"
    string hotkeysPageToggleDrainHotkey = "Toggle Drain Key"
    string hotkeysPageToggleDrainHotkeyHelp = "Hotkey to Toggle Drain \n Only registers during sex scenes"
    string hotkeysPageToggleDrainToDeathHotkey = "Toggle Drain to Death Key"
    string hotkeysPageToggleDrainToDeathHotkeyHelp = "Hotkey to Toggle Drain to Death \n Only registers during sex scenes"
; Page 4 - Widgets
    string widgetsPageName = "Widgets"
    string widgetsPageEnergyMeterXPos = "Energy Meter X Position"
    string widgetsPageEnergyMeterYPos = "Energy Meter Y Position"
    string widgetsPageEnergyMeterXScale = "Energy Meter X Scale"
    string widgetsPageEnergyMeterXScaleHelp = "Save and reload after changing this or the meter's position will be wrong"
    string widgetsPageEnergyMeterYScale = "Energy Meter Y Scale"
    string widgetsPageEnergyMeterYScaleHelp = "Save and reload after changing this or the meter's position will be wrong"
; Page 5 - Perks
    string perkPageName = "Perks"
    string perkPagePointsHeader = "Perk Points"
    string perkPageAvailablePerkPoints = "Available Perk Points"
    string perkPageAvailablePerkPointsHelp = "Cheat: Click to add a perk point"
    string perkPageResetPerks = "Reset Perks"
    string perkPageResetPerksHelp = "Remove all perks and return perk points"
    string perkPageGeneralHeader = "General Perks"
    string perkPageGentleDrainer = "Gentle Drainer"
    string perkPageGentleDrainerHelp = "Reduce the amount of time the drain debuff lasts by half"
    string perkPageOutOfPerkPoints = "No succubus perk points available"
    string perkpageEfficientFeeder = "Efficient Feeder"
    string perkpageEfficientFeederHelp = "Increase Health Conversion Rate by 10% per Rank"
    string perkpageEnergyStorage = "Energy Storage"
    string perkpageEnergyStorageHelp = "Increase Max Energy by 10 per Rank"
    string perkPageEnergyWeaver = "Energy Weaver"
    string perkPageEnergyWeaverHelp = "Reduce Energy Cost of Spells by 25%(50% while transformed) while using Energy Casting."
    string perkPageHealingForm = "Healing Form"
    string perkPageHealingFormHelp = "Succubus Healing Rate Boost is applied while you are transformed."
    string perkpageSafeTransformation = "Safe Transformation"
    string perkpageSafeTransformationHelp = "Become Ethereal While Transforming"
; Page 6 - Transformation
    string transformPageName = "Transformation"
    string transformPagePresetHeader = "Preset"
    string transformPageSaveSuccuPreset = "Save Succubus Form"
    string transformPageSaveSuccuPresetHelp = "Save current appearance as Succubus Form"
    string transformPageSaveSuccuPresetMsg = "Succubus Form Saved"
    string transformPageLoadSuccuPreset = "Load Succubus Form"
    string transformPageLoadSuccuPresetHelp = "Change current appearance to Succubus Form."
    string transformPageLoadSuccuPresetMsg = "Succubus Form Loaded\nExit menu to apply changes"
    string transformPageSaveMortalPreset = "Save Human Form"
    string transformPageSaveMortalPresetHelp = "Save current appearance as Human Form."
    string transformPageSaveMortalPresetMsg = "Human Form Saved"
    string transformPageLoadMortalPreset = "Load Human Form"
    string transformPageLoadMortalPresetHelp = "Change current appearance to Human Form"
    string transformPageLoadMortalPresetMsg = "Human Form Loaded\nExit menu to apply changes"
    string transformPageEquipmentHeader = "Equipment"
    string transformPageEquipmentSave = "Select Succubus Equipment"
    string transformPageEquipmentSaveHelp = "Opens a Chest Menu\nPlace the equipment you want to wear in your succubus form within"
    string transformPageEquipmentSaveMsg = "Exit Menu to Select Equipment"
    string transformPageNoStripAddHeader = "Add Items to No Strip List"
    string transformPageNoStripRemoveHeader = "Remove Equipment from Never Strip List"

int Function GetVersion()
    return 4
EndFunction

Event OnVersionUpdate(int newVersion)
    Debug.Trace("[CoL] New Version Detected " + newVersion)
    if newVersion >= 2
        CoL.levelHandler.GoToState("Initialize")
    endif
    if newVersion >= 3
        CoL.Maintenance()
    endif
    if newVersion >= 4
        if CoL.isPlayerSuccubus.GetValue() as Int > 0 && !CoL.playerRef.HasSpell(CoL.transformSpell)
            CoL.playerRef.AddSpell(CoL.transformSpell)
        endif
    endif
    OnConfigInit()
EndEvent

Event OnConfigInit()
    Pages = new string[6]
    Pages[0] = statusPageName
    Pages[1] = settingsPageName
    Pages[2] = hotkeysPageName
    Pages[3] = widgetsPageName
    Pages[4] = perkPageName
    Pages[5] = transformPageName
    
    settingsPageEnergyCastingConcStyleOptions = new string[4]
    settingsPageEnergyCastingConcStyleOptions[0] = settingsPageEnergyCastingConcStyleLeftOnly 
    settingsPageEnergyCastingConcStyleOptions[1] = settingsPageEnergyCastingConcStyleBothHands
    settingsPageEnergyCastingConcStyleOptions[2] = settingsPageEnergyCastingConcStyleRightOnly 
    settingsPageEnergyCastingConcStyleOptions[3] = settingsPageEnergyCastingConcStyleNone
EndEvent

Event OnConfigClose()
    if meterBarChanged
        CoL.widgetHandler.GoToState("MoveEnergyMeter")
        meterBarChanged = false
    endif
EndEvent

Event OnPageReset(string page)
    if page == ""
; Page 1 - Status
    elseif page == statusPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption(statusPageHeaderOne)
        if isPlayerSuccubus.GetValue() as int == 1
            AddTextOptionST("SuccubusCurrentLevel", statusPageCurrentLevel+": ", CoL.levelHandler.playerSuccubusLevel.GetValueInt(), OPTION_FLAG_DISABLED)
            AddTextOptionST("SuccubusCurrentXP", statusPageCurrentXP+": ", (CoL.levelHandler.playerSuccubusXP as int), OPTION_FLAG_DISABLED)
            AddTextOptionST("SuccubusNextLevelXP", statusPageNextLevelXP+": ", (CoL.levelHandler.xpForNextLevel as int), OPTION_FLAG_DISABLED)
            AddTextOptionST("EnergyCurrentTextOption", statusPageEnergyCurrent+": ", CoL.playerEnergyCurrent as int, OPTION_FLAG_DISABLED)
            AddSliderOptionST("EnergyMaxSlider", statusPageEnergyMax+": ", CoL.playerEnergyMax)
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("EndSuccubus", statusPageEndSuccubus, None)
            AddTextOptionST("EnergyRefill", statusPageRefillEnergy, None)
            AddToggleOptionST("DebugLogging", statusPageDebugLogging, CoL.DebugLogging)
        else
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("BecomeSuccubus", statusPageBecomeSuccubus, None)
        endif
; Page 2 - Settings
    elseif page == settingsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        ; Drain Settings
        AddHeaderOption(settingsPageDrainHeader)
        AddToggleOptionST("DrainToggleOption", settingsPageDrainToggle, CoL.drainHandler.draining)
        AddToggleOptionST("DrainToDeathToggleOption", settingsPageDrainToDeathToggle, CoL.drainHandler.drainingToDeath)
        AddSliderOptionST("DrainDurationSlider", settingsPageDrainDuration, CoL.drainDurationInGameTime)
        AddSliderOptionST("HealthDrainMultiSlider", settingsPageHealthDrainMult, CoL.healthDrainMult, "{1}")
        AddSliderOptionST("EnergyConversionRateSlider", settingsPageEnergyConversionRate, CoL.energyConversionRate, "{1}")
        AddToggleOptionST("DrainFeedsVampireOption", settingsPageDrainFeedsVampire, CoL.drainFeedsVampire)
        ; Level Settings
        AddHeaderOption(settingsPageLevelHeader)
        AddSliderOptionST("LevelXpPerDrain", settingsPageLevelXpPerDrain, CoL.levelHandler.xpPerDrain)
        AddSliderOptionST("LevelXpDeathMult", settingsPageLevelXpDeathMult, CoL.levelHandler.drainToDeathXPMult)
        AddSliderOptionST("LevelXpConstant", settingsPageLevelXpConstant, CoL.levelHandler.xpConstant, "{2}")
        AddSliderOptionST("LevelXpPower", settingsPageLevelXpPower, CoL.levelHandler.xpPower, "{2}")
        AddSliderOptionST("LevelLevelsPerPerk", settingsPageLevelLevelsPerPerk, CoL.levelHandler.levelsForPerk)
        AddSliderOptionST("LevelPerksPerLevel", settingsPageLevelPerksPerLevel, CoL.levelHandler.perkPointsOnLevelUp)
        ; Hunger Settings
        AddHeaderOption(settingsPageHungerHeader)
        AddToggleOptionST("HungerToggle", settingsPageHungerToggle, CoL.hungerEnabled)
        AddSliderOptionST("HungerAmountSlider", settingsPageHungerAmount, CoL.dailyHungerAmount)
        AddToggleOptionST("HungerDamageToggle", settingsPageHungerDamage, CoL.hungerDamageEnabled)
        AddSliderOptionST("HungerDamageAmountSlider", settingsPageHungerDamageAmount, CoL.hungerDamageAmount)
        ; Power Settings
        SetCursorPosition(1)
        AddHeaderOption(settingsPagePowerHeader)
        AddSliderOptionST("BecomeEtherealCostSlider", settingsPageBecomeEtherealCost, CoL.becomeEtherealCost)
        AddEmptyOption()
        AddSliderOptionST("HealRateBoostCostSlider", settingsPageHealRateBoostCost, CoL.healRateBoostCost)
        AddSliderOptionST("HealRateBoostMultSlider", settingsPageHealRateBoostMult, CoL.healRateBoostMult)
        AddEmptyOption()
        AddSliderOptionST("EnergyCastingMultSlider", settingsPageEnergyCastingMult, CoL.energyCastingMult, "{1}")
        AddMenuOptionST("EnergyCastingConcStyleMenu", settingsPageEnergyCastingConcStyle, settingsPageEnergyCastingConcStyleOptions[CoL.energyCastingConcStyle])

; Page 3 - Hotkeys
    elseif page == hotkeysPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddKeyMapOptionST("DrainKeyMapOption", hotkeysPageToggleDrainHotkey, CoL.toggleDrainHotkey)
        AddKeyMapOptionST("DrainToDeathKeyMapOption", hotkeysPageToggleDrainToDeathHotkey, CoL.toggleDrainToDeathHotkey)
; Page 4 - Widgets
    elseif page == widgetsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddSliderOptionST("energyMeterXPosSlider", widgetsPageEnergyMeterXPos, CoL.widgetHandler.energyMeterXPos)
        AddSliderOptionST("energyMeterYPosSlider", widgetsPageEnergyMeterYPos, CoL.widgetHandler.energyMeterYPos)
        AddSliderOptionST("energyMeterXScaleSlider", widgetsPageEnergyMeterXScale, CoL.widgetHandler.energyMeterXScale)
        AddSliderOptionST("energyMeterYScaleSlider", widgetsPageEnergyMeterYScale, CoL.widgetHandler.energyMeterYScale)
; Page 5 - Perks
    elseif page == perkPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption(perkPagePointsHeader)
        AddTextOptionST("perksAvailableOption", perkPageAvailablePerkPoints, CoL.availablePerkPoints)
        AddTextOptionST("perkReset", perkPageResetPerks, None)
        AddHeaderOption(perkPageGeneralHeader)
        if !CoL.gentleDrainer
            AddToggleOptionST("perkGentleDrainer", perkPageGentleDrainer, CoL.gentleDrainer)
        else
            AddToggleOptionST("perkGentleDrainer", perkPageGentleDrainer, CoL.gentleDrainer, OPTION_FLAG_DISABLED)
        endif
        AddTextOptionST("perkEfficientFeeder", perkpageEfficientFeeder, CoL.efficientFeeder)
        AddTextOptionST("perkEnergyStorage", perkpageEnergyStorage, CoL.energyStorage)
        if !CoL.energyWeaver
            AddToggleOptionST("perkEnergyWeaver", perkPageEnergyWeaver, CoL.EnergyWeaver)
        else
            AddToggleOptionST("perkEnergyWeaver", perkPageEnergyWeaver, CoL.energyWeaver, OPTION_FLAG_DISABLED)
        endif
        if !CoL.healingForm
            AddToggleOptionST("perkHealingForm", perkPageHealingForm, CoL.HealingForm)
        else
            AddToggleOptionST("perkHealingForm", perkPageHealingForm, CoL.HealingForm, OPTION_FLAG_DISABLED)
        endif
        if !CoL.safeTransformation
            AddToggleOptionST("perkSafeTransformation", perkPagesafeTransformation, CoL.safeTransformation)
        else
            AddToggleOptionST("perkSafeTransformation", perkPagesafeTransformation, CoL.safeTransformation, OPTION_FLAG_DISABLED)
        endif
; Page 6 - Transform
    elseif page == transformPageName
        equippedItems = getEquippedItems(CoL.playerRef)
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption(transformPagePresetHeader)
        AddTextOptionST("transformSaveMortalPreset", transformPageSaveMortalPreset, None)
        if CoL.mortalPresetSaved
            AddTextOptionST("transformLoadMortalPreset", transformPageLoadMortalPreset, None)
        else
            AddTextOptionST("transformLoadMortalPreset", transformPageLoadMortalPreset, None, OPTION_FLAG_DISABLED)
        endif
        AddTextOptionST("transformSaveSuccuPreset", transformPageSaveSuccuPreset, None)
        if CoL.succuPresetSaved
            AddTextOptionST("transformLoadSuccuPreset", transformPageLoadSuccuPreset, None)
        else
            AddTextOptionST("transformLoadSuccuPreset", transformPageLoadSuccuPreset, None, OPTION_FLAG_DISABLED)
        endif
        SetCursorPosition(1)
        AddHeaderOption(transformPageEquipmentHeader)
        AddTextOptionST("transformActivateEquipmentChest", transformPageEquipmentSave , None)
        AddHeaderOption(transformPageNoStripAddHeader)
        int i = 0
		while i < equippedItems.Length
			if !CoL.ddLibs || !equippedItems[i].hasKeyword(CoL.ddLibs) ; Make sure it's not a devious device, if compatibility patch installed
				if CoL.NoStripList.Find(equippedItems[i]) == -1
					string itemName = equippedItems[i].GetName()
					if itemName != "" && itemName != " "
						AddTextOptionST("transformAddStrippable+" + i, itemName, None)
					endif
				endif
			endif
			i += 1
		endwhile
        AddHeaderOption(transformPageNoStripRemoveHeader)
		i = 0
		while i < CoL.NoStripList.Length
			string itemName = CoL.NoStripList[i].GetName()
			AddTextOptionST("transformRemoveStrippable+" + i, itemName, None)
			i += 1
		endwhile
    endif
EndEvent

string[] function getoptions()
	return stringsplit(getstate(), "+")
endfunction

; Page 1 State Handlers
    State BecomeSuccubus
        Event OnSelectST()
            CoL.GoToState("Initialize")
            SetTextOptionValueST("Exit Menu Now")
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "BecomeSuccubus")
            Utility.Wait(0.5)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageBecomeSuccubusHelp)
        EndEvent
    EndState

    State EndSuccubus
        Event OnSelectST()
            CoL.GoToState("Uninitialize")
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EndSuccubus")
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageEndSuccubusHelp)
        EndEvent
    EndState

    State EnergyMaxSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.playerEnergyMax)
            SetSliderDialogDefaultValue(100)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.playerEnergyMax = value
            SetSliderOptionValueST(CoL.playerEnergyMax)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageEnergyMaxHelp)
        EndEvent
    EndState

    State EnergyRefill
        Event OnSelectST()
            CoL.playerEnergyCurrent = CoL.playerEnergyMax
            SetTextOptionValueST(CoL.playerEnergyCurrent as int, false, "EnergyCurrentTextOption")
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageRefillEnergyHelp)
        EndEvent

    EndState

    State DebugLogging
        Event OnSelectST()
            CoL.DebugLogging = !CoL.DebugLogging
            SetToggleOptionValueST(CoL.DebugLogging)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageDebugLoggingHelp)
        EndEvent
    EndState

; Page 2 State Handlers
    State DrainToggleOption
        Event OnSelectST()
            CoL.drainHandler.draining = !CoL.drainHandler.draining
            SetToggleOptionValueST(CoL.drainHandler.draining)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageDrainToggleHelp)
        EndEvent
    EndState
    State DrainToDeathToggleOption
        Event OnSelectST()
            CoL.drainHandler.drainingToDeath = !CoL.drainHandler.drainingToDeath
            SetToggleOptionValueST(CoL.drainHandler.drainingToDeath)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageDrainToDeathToggleHelp)
        EndEvent
    EndState
    State DrainDurationSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.drainDurationInGameTime)
            SetSliderDialogDefaultValue(24.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 72.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.drainDurationInGameTime = value
            SetSliderOptionValueST(CoL.drainDurationInGameTime)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageDrainDurationHelp)
        EndEvent
    EndState
    State HealthDrainMultiSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.healthDrainMult)
            SetSliderDialogDefaultValue(0.2)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.healthDrainMult = value
            SetSliderOptionValueST(CoL.healthDrainMult,"{1}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHealthDrainMultHelp)
        EndEvent
    EndState
    State EnergyConversionRateSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.energyConversionRate)
            SetSliderDialogDefaultValue(0.5)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.energyConversionRate = value
            SetSliderOptionValueST(CoL.energyConversionRate, "{1}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageEnergyConversionRateHelp)
        EndEvent
    EndState
    State DrainFeedsVampireOption
        Event OnSelectST()
            CoL.drainFeedsVampire = !CoL.drainFeedsVampire
            SetToggleOptionValueST(CoL.drainFeedsVampire)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageDrainFeedsVampireHelp)
        EndEvent
    EndState

    State LevelXpPerDrain
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.xpPerDrain)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.xpPerDrain = value
            SetSliderOptionValueST(CoL.levelhandler.xpPerDrain)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingspageLevelXpPerDrainHelp)
        EndEvent
    EndState
    State LevelXpDeathMult
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.drainToDeathXPMult)
            SetSliderDialogDefaultValue(2.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.drainToDeathXPMult = value
            SetSliderOptionValueST(CoL.levelhandler.drainToDeathXPMult)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageLevelXpDeathMultHelp)
        EndEvent
    EndState
    State LevelXpConstant
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.xpConstant)
            SetSliderDialogDefaultValue(0.75)
            SetSliderDialogInterval(0.01)
            SetSliderDialogRange(0.01, 5.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.xpConstant = value
            SetSliderOptionValueST(CoL.levelhandler.xpConstant, "{2}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageLevelXpConstantHelp)
        EndEvent
    EndState
    State LevelXpPower
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.xpPower)
            SetSliderDialogDefaultValue(1.5)
            SetSliderDialogInterval(0.01)
            SetSliderDialogRange(0.01, 5.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.xpPower = value
            SetSliderOptionValueST(CoL.levelhandler.xpPower,"{2}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageLevelXpPowerHelp)
        EndEvent
    EndState
    State LevelLevelsPerPerk
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.levelsForPerk)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.levelsForPerk = value as int
            SetSliderOptionValueST(CoL.levelhandler.levelsForPerk)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageLevelLevelsPerPerkHelp)
        EndEvent
    EndState
    State LevelPerksPerLevel
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.levelHandler.perkPointsOnLevelUp)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.levelHandler.perkPointsOnLevelUp = value as int
            SetSliderOptionValueST(CoL.levelhandler.perkPointsOnLevelUp)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageLevelPerksPerLevelHelp)
        EndEvent
    EndState

    State HungerToggle
        Event OnSelectST()
            CoL.hungerEnabled = !CoL.hungerEnabled
            SetToggleOptionValueST(CoL.hungerEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerToggleHelp)
        EndEvent
    EndState
    State HungerAmountSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.dailyHungerAmount)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.dailyHungerAmount = value
            SetSliderOptionValueST(CoL.dailyHungerAmount)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerAmountHelp)
        EndEvent
    EndState
    State HungerDamageToggle
        Event OnSelectST()
            CoL.hungerDamageEnabled = !CoL.hungerDamageEnabled
            SetToggleOptionValueST(CoL.hungerDamageEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerDamageHelp)
        EndEvent
    EndState
    State HungerDamageAmountSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.hungerDamageAmount)
            SetSliderDialogDefaultValue(5.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.hungerDamageAmount = value
            SetSliderOptionValueST(CoL.hungerDamageAmount)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerDamageAmountHelp)
        EndEvent
    EndState

    State BecomeEtherealCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.becomeEtherealCost)
            SetSliderDialogDefaultValue(10)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.becomeEtherealCost = value
            SetSliderOptionValueST(CoL.becomeEtherealCost)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageBecomeEtherealCostHelp)
        EndEvent
    EndState
    State HealRateBoostCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.healRateBoostCost)
            SetSliderDialogDefaultValue(5)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.healRateBoostCost = value
            SetSliderOptionValueST(CoL.healRateBoostCost)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHealRateBoostCostHelp)
        EndEvent
    EndState
    State HealRateBoostMultSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.healRateBoostMult)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 20.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.healRateBoostMult = value
            SetSliderOptionValueST(CoL.healRateBoostMult)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHealRateBoostMultHelp)
        EndEvent
    EndState
    State EnergyCastingMultSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.energyCastingMult)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.1, 10.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.energyCastingMult = value
            SetSliderOptionValueST(CoL.energyCastingMult, "{1}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageEnergyCastingMultHelp)
        EndEvent
    EndState
    State EnergyCastingConcStyleMenu
        Event OnMenuOpenST() 
            SetMenuDialogOptions(settingsPageEnergyCastingConcStyleOptions)
            SetMenuDialogStartIndex(CoL.energyCastingConcStyle)
            SetMenuDialogDefaultIndex(1)
        EndEvent
        Event OnMenuAcceptST(int newVal)
            CoL.energyCastingConcStyle = newVal
            SetMenuOptionValueST(settingsPageEnergyCastingConcStyleOptions[CoL.energyCastingConcStyle])
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageEnergyCastingConcStyleHelp)
        EndEvent
    EndState


; Page 3 State Handlers
    State DrainKeyMapOption
        Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
            bool continue = true
            if (conflictControl != "")
                string msg
                if (conflictName != "")
                    msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
                else
                    msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
                endIf

                continue = ShowMessage(msg, true, "$Yes", "$No")
            endIf

            if (continue)
                CoL.toggleDrainHotkey = keyCode
                SetKeyMapOptionValueST(keyCode)
            endIf
        EndEvent
        Event OnHighlightST()
            SetInfoText(hotkeysPageToggleDrainHotkeyHelp)
        EndEvent
    EndState
    State DrainToDeathKeyMapOption
        Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
            bool continue = true
            if (conflictControl != "")
                string msg
                if (conflictName != "")
                    msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
                else
                    msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
                endIf

                continue = ShowMessage(msg, true, "$Yes", "$No")
            endIf

            if (continue)
                CoL.toggleDrainToDeathHotkey = keyCode
                SetKeyMapOptionValueST(keyCode)
            endIf
        EndEvent
        Event OnHighlightST()
            SetInfoText(hotkeysPageToggleDrainToDeathHotkeyHelp)
        EndEvent
    EndState
; Page 4 State Handlers
    State energyMeterXPosSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.energyMeterXPos)
            SetSliderDialogDefaultValue(640)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1279)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.energyMeterXPos = value as int
            SetSliderOptionValueST(CoL.widgetHandler.energyMeterXPos)
            meterBarChanged = true
        EndEvent
    EndState
    State energyMeterYPosSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.energyMeterYPos)
            SetSliderDialogDefaultValue(700)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 719)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.energyMeterYPos = value as int
            SetSliderOptionValueST(CoL.widgetHandler.energyMeterYPos)
            meterBarChanged = true
        EndEvent
    EndState
    State energyMeterXScaleSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.energyMeterXScale)
            SetSliderDialogDefaultValue(70)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 200)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.energyMeterXScale = value as int
            SetSliderOptionValueST(CoL.widgetHandler.energyMeterXScale)
            meterBarChanged = true
        EndEvent
        Event OnHighlightST()
            SetInfoText(widgetsPageEnergyMeterXScaleHelp)
        EndEvent
    EndState
    State energyMeterYScaleSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.energyMeterYScale)
            SetSliderDialogDefaultValue(70)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 200)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.energyMeterYScale = value as int
            SetSliderOptionValueST(CoL.widgetHandler.energyMeterYScale)
            meterBarChanged = true
        EndEvent
        Event OnHighlightST()
            SetInfoText(widgetsPageEnergyMeterYScaleHelp)
        EndEvent
    EndState
; Page 5 State Handlers
    State perksAvailableOption
        Event OnSelectST()
            CoL.availablePerkPoints += 1
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkPageAvailablePerkPointsHelp)
        EndEvent
    EndState
    State perkReset
        Event OnSelectST()
            if CoL.gentleDrainer
                CoL.gentleDrainer = false
                ; SetToggleOptionValueST(CoL.gentleDrainer, true, "perkGentleDrainer")
                CoL.availablePerkPoints += 1
            endif
            if CoL.efficientFeeder > 0
                int i = 0
                while i < CoL.efficientFeeder
                    CoL.availablePerkPoints += 1
                    CoL.efficientFeeder -= 1
                endwhile
            endif
            if CoL.energyStorage > 0
                int i = 0
                while i < CoL.energyStorage
                    CoL.availablePerkPoints += 1
                    CoL.energyStorage -= 1
                    CoL.playerEnergyMax -= 10
                endwhile
            endif
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkPageResetPerksHelp)
        EndEvent
    EndState
    State perkGentleDrainer
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.gentleDrainer = !CoL.gentleDrainer
                SetToggleOptionValueST(CoL.gentleDrainer)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkPageGentleDrainerHelp)
        EndEvent
    EndState
    State perkEfficientFeeder
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.efficientFeeder += 1
                CoL.energyConversionRate += 0.1
                SetTextOptionValueST(CoL.efficientFeeder)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkpageEfficientFeederHelp)
        EndEvent
    EndState
    State perkEnergyStorage
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.energyStorage += 1
                CoL.playerEnergyMax += 10
                SetTextOptionValueST(CoL.energyStorage)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkpageEnergyStorageHelp)
        EndEvent
    EndState
    State perkEnergyWeaver
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.energyWeaver = !CoL.energyWeaver
                SetToggleOptionValueST(CoL.energyWeaver)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkPageEnergyWeaverHelp)
        EndEvent
    EndState
    State perkHealingForm
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.healingForm = !CoL.healingForm
                SetToggleOptionValueST(CoL.healingForm)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkPageHealingFormHelp)
        EndEvent
    EndState
    State perkSafeTransformation
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.safeTransformation = !CoL.safeTransformation
                SetToggleOptionValueST(CoL.safeTransformation)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkpageSafeTransformationHelp)
        EndEvent
    EndState
; Page 6 State Handlers
    State transformSaveMortalPreset
        Event OnSelectST()
            CoL.mortalRace = CoL.playerRef.GetRace()
            CoL.mortalHairColor = CoL.playerRef.GetActorbase().GetHairColor()
            CharGen.SavePreset(CoL.mortalPresetName)
            CoL.mortalPresetSaved = True
            Debug.MessageBox(transformPageSaveMortalPresetMsg)
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageSaveMortalPresetHelp)
        EndEvent
    EndState
    State transformLoadMortalPreset
        Event OnSelectST()
            CoL.playerRef.SetRace(CoL.mortalRace)
            CoL.playerRef.GetActorbase().SetHairColor(CoL.mortalHairColor)
            Debug.MessageBox(transformPageLoadMortalPresetMsg)
            Utility.Wait(0.1)
            CharGen.LoadPreset(CoL.mortalPresetName)
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageLoadMortalPresetHelp)
        EndEvent
    EndState
    State transformSaveSuccuPreset
        Event OnSelectST()
            CoL.succuRace = CoL.playerRef.GetRace()
            CoL.succuHairColor = CoL.playerRef.GetActorbase().GetHairColor()
            CharGen.SavePreset(CoL.succuPresetName)
            CoL.succuPresetSaved = True
            Debug.MessageBox(transformPageSaveSuccuPresetMsg)
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageSaveSuccuPresetHelp)
        EndEvent
    EndState
    State transformLoadSuccuPreset
        Event OnSelectST()
            CoL.playerRef.SetRace(CoL.succuRace)
            CoL.playerRef.GetActorbase().SetHairColor(CoL.succuHairColor)
            Debug.MessageBox(transformPageLoadSuccuPresetMsg)
            Utility.Wait(0.1)
            CharGen.LoadPreset(CoL.succuPresetName)
            ForcePageReset()
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageLoadSuccuPresetHelp)
        EndEvent
    EndState
    State transformActivateEquipmentChest
        Event OnSelectST()
            CoL.succuEquipmentChest.Activate(CoL.playerRef)
            Debug.MessageBox(transformPageEquipmentSaveMsg)
            Utility.Wait(0.1)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageEquipmentSaveHelp)
        EndEvent
    EndState
    Event OnSelectST()
        string[] options = getOptions()
        string option = options[0]
        if option == "transformRemoveStrippable"
            int index = options[1] as int
            Form itemRef = CoL.NoStripList[index]
            CoL.NoStripList = RemoveForm(CoL.NoStripList, itemRef)

            if CoL.DebugLogging
                Debug.trace("Removing " + itemRef.GetName())
                int i = 0
                Debug.trace("Worn Item List contains:")
                while i < equippedItems.Length
                    Debug.trace(equippedItems[i].getName())
                    i += 1
                endwhile
            endif

            ForcePageReset()
        elseif option == "transformAddStrippable"
            int index = options[1] as int
            Form itemRef = equippedItems[index]
            CoL.NoStripList = PushForm(CoL.NoStripList, itemRef)

            if CoL.DebugLogging
                Debug.trace("Adding " + itemRef.getName())
                int i = 0
                Debug.trace("Don't strip list contains:")
                while i < CoL.NoStripList.Length
                    Debug.trace(CoL.NoStripList[i].getName())
                    i += 1
                endwhile
            endif

            ForcePageReset()
        endif
    EndEvent

Form[] function getEquippedItems(Actor actorRef)
	int i = 31
    Form itemRef
	equippedItems = new Form[34]
    while i >= 0
        itemRef = actorRef.GetWornForm(Armor.GetMaskForSlot(i+30))
		if itemRef 
			equippedItems[i] = itemRef
		endif
		i -= 1
	endwhile
	; return ClearNone(equippedItems)
	; equippedItems = ClearNone(equippedItems)
	return RemoveDupeForm(ClearNone(equippedItems))
EndFunction