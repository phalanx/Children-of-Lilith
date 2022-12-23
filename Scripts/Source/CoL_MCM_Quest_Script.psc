Scriptname CoL_MCM_Quest_Script extends SKI_ConfigBase

import CharGen
import PapyrusUtil

CoL_PlayerSuccubusQuestScript Property CoL Auto
GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus

Quest Property oStim_Interfaces Auto
Quest Property SexLab_Interfaces Auto

string[] settingsPageEnergyCastingConcStyleOptions
bool meterBarChanged = false
bool loadEquipment = false
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
    string statusPageBecomeNPCSuccubus = "Become NPC Succubus"
    string statusPageBecomeNPCSuccubusHelp = "Begin NPC Succubus System"
    string statusPageEndNPCSuccubus = "End NPC Succubus"
    string statusPageEndNPCSuccubusHelp = "End NPC Succubus System"
    string statusPageHeaderTwo = "Debug and Maintenance"
    string statusPageRefillEnergy = "Refill Energy"
    string statusPageRefillEnergyHelp = "Cheat: Refills Energy"
    string statusPageLevelUp = "Level Up"
    string statusPageLevelUpHelp = "Cheat: Add Succubus Level"
    string statusPageDebugLogging = "Toggle Debug Logging"
    string statusPageDebugLoggingHelp = "Toggles Debug Logging. \n Warning: this can produce a lot of log entries. Only enable for troubleshooting"
    string statusPageEnergyScaleTest = "Energy Scale Test Enabled"
    string statusPageEnergyScaleTestHelp = "Enable energy scale test\n Push Drain to Death hotkey to run\n Energy will empty, increase to max, then decrease to 0"
    string statusPageNPCHeader = "NPC Succubi"
    string statusPageNPCHelp = "Click on an entry to End Succubus for the NPC"
    string statusPageFollowedPath = "Followed Path"
    string statusPageFollowedPathHelp = "Choose your path. Effects which set of passive bonuses you get"
    string[] statusPageFollowedPathOptions

; Page 2 - Settings
    string settingsPageName = "Settings"
    string settingsPageDrainHeader = "Drain Settings"
    string settingsPageDrainToggle = "Drain"
    string settingsPageDrainToggleHelp = "Toggle Draining"
    string settingsPageDrainToDeathToggle = "Drain to Death"
    string settingsPageDrainToDeathToggleHelp = "Toggle Drain to Death. Takes precedent over Drain setting"
    string settingsPageDrainVerbosity = "Enable Drain Notifications"
    string settingsPageDrainVerbosityHelp = "Should switching drain modes trigger a notification in the top left"
    string settingsPageDrainDuration = "Drain Duration"
    string settingsPageDrainDurationHelp = "How long the Drain health debuff lasts, in game hours"
    string settingsPageHealthDrainMult = "Health Drain Multiplier"
    string settingsPageHealthDrainMultHelp = "The percentage of health drained from victim \n (Victim Health * [this value]) = Health Drained"
    string settingsPageDrainArousalMult = "Drain Arousal Multiplier"
    string settingsPageDrainArousalMultHelp = "Value to Multiply arousal by before adding it to the amount of energy gained \n Only has an effect if a supported Arousal Framework is installed"
    string settingsPageEnergyConversionRate = "Energy Conversion Rate"
    string settingsPageEnergyConversionRateHelp = "Percentage of Drained Health that is converted to Energy \n (Health Drained * [This Value]) = Energy Gained"
    string settingsPageDrainFeedsVampire = "Drain Feeds Vampires"
    string settingsPageDrainFeedsVampireHelp = "Should drain victims also trigger a vampire feeding"
    string settingsPageNpcDrainHeader = "NPC Drain Settings"
    string settingsPageNpcDeathChance = "NPC Drain to Death Chance"
    string settingsPageNpcDeathChanceHelp = "Percentage Chance NPC drains victim to death"

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
    string settingsPageHungerThreshold = "Hunger Threshold"
    string settingsPageHungerThresholdHelp = "When Energy falls this below this percentage, activate Hunger effects"
    string settingsPageHungerAmount = "Hunger Amount"
    string settingsPageHungerAmountHelp = "If Hunger is enabled, this sets the amount of Energy lost on a daily basis"
    string settingsPageHungerDamage = "Deadly Hunger"
    string settingsPageHungerDamageHelp = "If Hunger is enabled, this sets whether or not running out of Energy will periodically reduce Max Health"
    string settingsPageHungerDamageAmount = "Hunger Damage Amount"
    string settingsPageHungerDamageAmountHelp = "If Hunger Damage is enabled, Max Health will be reduced by this amount per Hunger tick (30 seconds)"
    string settingsPageHungerArousal = "Hunger Arousal Enabled"
    string settingsPageHungerArousalHelp = "If Hunger is enabled, this sets whether or not running out of Energy will cause Increasing Arousal"
    string settingsPageHungerArousalAmount = "Hunger Arousal Amount"
    string settingsPageHungerArousalAmountHelp = "If Hunger Arousal is enabled, arousal will increase by this amount per Hunger tick (30 seconds)"

    string settingsPageTattooHeader = "Tattoo Settings"
    string settingsPageTattooFade = "Tattoo Fade"
    string settingsPageTattooFadeHelp = "Enable tattoo fading based on percentage of current energy"
    string settingsPageTattooSlot = "Tattoo Body Slot"
    string settingsPageTattooSlotHelp = "Body slot the tattoo you want to fade occupies"

    string settingsPagePowerHeader = "Power Settings"
    string settingsPageBecomeEtherealCost = "Become Ethereal Cost"
    string settingsPageBecomeEtherealCostHelp = "Per Second Energy Cost of Succubus Become Ethereal"
    string settingsPageHealRateBoostCost = "HealRate Boost Cost"
    string settingsPageHealRateBoostCostHelp = "Per Second Cost of Succubus Heal Rate Boost"
    string settingsPageHealRateBoostMult = "HealRate Boost Multiplier"
    string settingsPageHealRateBoostMultHelp = "Multiplier applied to HealRate during Succubus Heal Rate Boost"
    string settingsPageHealRateBoostFlat = "Enable Flat Regen Boost"
    string settingsPageHealRateBoostFlatHelp = "Instead of a Multiplier, HealRate Boost Multiplier gets applied as a flat amount of Health Regen\n Useful if you use other mods which remove your base regen\n Set HealRate Boost Multiplier to 7 to match the current default"
    string settingsPageEnergyCastingMult = "Energy Casting Cost Multiplier"
    string settingsPageEnergyCastingMultHelp = "Multiplier applied to spells Magicka cost before being removed from Energy Pool \n (Spell Magicka Cost * [This Value]) = Energy Cost of Spell"
    string settingsPageEnergyCastingConcStyle = "Cost Calculation Style"
    string settingsPageEnergyCastingConcStyleHelp = "Select a Concentration Cost Calculation Style \n See Mod Description for more information"
    string settingsPageEnergyCastingConcStyleLeftOnly = "Left Hand Only" 
    string settingsPageEnergyCastingConcStyleBothHands = "Both Hands" 
    string settingsPageEnergyCastingConcStyleRightOnly = "Right Hand Only" 
    string settingsPageEnergyCastingConcStyleNone = "Cheat: Neither" 
    string settingsPageTemptationCost = "Temptation Cost"
    string settingsPageTemptationCostHelp = "Energy Cost of Succubus Temptation"
    string settingsPageTemptationBaseIncrease = "Temptation Base Arousal Increase"
    string settingsPageTemptationBaseIncreaseHelp = "Base Arousal Increase of Temptation"
    string settingsPageTemptationLevelMult = "Temptation Level Multiplier"
    string settingsPageTemptationLevelMultHelp = "Multiplier applied to succubus level before being added to Temptation Base arousal increase"
    string settingsPageExcitementCost = "Excitement Cost"
    string settingsPageExcitementCostHelp = "Energy Cost of Succubus Excitement"
    string settingsPageExcitementBaseIncrease = "Excitement Base Arousal Increase"
    string settingsPageExcitementBaseIncreaseHelp = "Base Arousal Increase of Excitement"
    string settingsPageExcitementLevelMult = "Excitement Level Multiplier"
    string settingsPageExcitementLevelMultHelp = "Multiplier applied to succubus level before being added to Excitement Base arousal increase"
    string settingsPageSuppressionCost = "Suppression Cost"
    string settingsPageSuppressionCostHelp = "Energy Cost of Succubus Suppression"
    string settingsPageSuppressionBaseIncrease = "Suppression Base Arousal Increase"
    string settingsPageSuppressionBaseIncreaseHelp = "Base Arousal Increase of Suppression"
    string settingsPageSuppressionLevelMult = "Suppression Level Multiplier"
    string settingsPageSuppressionLevelMultHelp = "Multiplier applied to succubus level before being added to Suppression Base arousal increase"
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
    string widgetsPageEnergyMeterAlpha = "Energy Meter Transparency"
    string widgetsPageEnergyMeterAutoHide = "Energy Meter AutoHides"
    string widgetsPageEnergyMeterAutoHideHelp = "Energy Meter will disappear after some time"
    string widgetsPageEnergyMeterAutoHideTime = "Energy Meter AutoHide Timer"
    string widgetsPageEnergyMeterAutoHideTimeHelp = "Time until the Energy Meter disappears"
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
    string perkpageSlakeThirst = "Slake Thirst"
    string perkpageSlakeThirstHelp = "Add Succubus Arousal Level to Drain Amount\nIf multiple arousal frameworks detected, uses the average\nMultiplied by Drain Arousal Multiplier"
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
    string transformPageLoadEquipment = "Load Equipment Strip Options"
    string transformPageEquipmentSave = "Select Succubus Equipment"
    string transformPageEquipmentSaveHelp = "Opens a Chest Menu\nPlace the equipment you want to wear in your succubus form within"
    string transformPageEquipmentSaveMsg = "Exit Menu to Select Equipment"
    string transformPageNoStripAddHeader = "Add Items to No Strip List"
    string transformPageNoStripRemoveHeader = "Remove Equipment from Never Strip List"
    string transformPageTransformCrime = "Transformation is a Crime"
    string transformPageTransformCrimeHelp = "Should Transformation be a Crime"
    string transformPageEquipmentSwap = "Transform Swaps Equipment"
    string transformPageEquipmentSwapHelp = "Should transformation also swap equipment"
    string transformPageTransformAnimation = "Play Transformation Animation"
    string transformPageTransformAnimationHelp = "Should an animation play when you transform\n the smoke effect will play either way"
    string transformPageTransformCost = "Transform Energy Cost"
    string transformPageTransformCostHelp = "Per second energy cost of being transformed"
    string transformPageTransformArousalUpperThreshold = "Transform Upper Threshold"
    string transformPageTransformArousalUpperThresholdHelp = "Force transform when above this threshold \n Set to 0 to disable"
    string transformPageTransformArousalLowerThreshold = "Transform Lower Threshold"
    string transformPageTransformArousalLowerThresholdHelp = "Force transform when below this threshold \n Set to 0 to disable"
    ; Buffs
    string transformPageBuffsHeader = "Transform Buffs"
    string transformPageBuffsEnabled = "Enable Transform Buffs"
    string transformPageBuffsArmor = "Extra Armor"
    string transformPageBuffsArmorHelp = "Increases Armor Rating by this amount"
    string transformPageBuffsMagicResist = "Extra Magic Resist"
    string transformPageBuffsMagicResistHelp = "Increases percentage of Magic Resistance by this amount"
    string transformPageBuffsHealth = "Extra Health"
    string transformPageBuffsHealthHelp = "Increaes Health by this amount"
    string transformPageBuffsMagicka = "Extra Magicka"
    string transformPageBuffsMagickaHelp = "Increases Magicka by this amount"
    string transformPageBuffsStamina = "Extra Stamina"
    string transformPageBuffsStaminaHelp = "Increases Stamina by this amount"
    string transformPageBuffsExtraMeleeDamage = "Extra Melee Damage"
    string transformPageBuffsExtraMeleeDamageHelp = "Multiplier to increase damage"
    string transformPageBuffsExtraCarryWeight = "Extra Carry Weight"
    string transformPageBuffsExtraCarryWeightHelp = "Increase carry weight by this amount"

int Function GetVersion()
    return 8
EndFunction

Event OnVersionUpdate(int newVersion)
    Debug.Trace("[CoL] New Version Detected " + newVersion)
    if isPlayerSuccubus.GetValueInt() > 0
        Utility.Wait(1)
        CoL.GoToState("Uninitialize")
        Utility.Wait(1)
        CoL.GoToState("Initialize")
        Utility.Wait(1)
        CoL.transformArousalLowerThreshold = CoL.transformArousalLowerThreshold
        CoL.transformArousalUpperThreshold = CoL.transformArousalUpperThreshold
    endif
    OnConfigInit()
EndEvent

Event OnConfigInit()
    Pages = new string[7]
    Pages[0] = statusPageName
    Pages[1] = settingsPageName
    Pages[2] = hotkeysPageName
    Pages[3] = widgetsPageName
    Pages[4] = perkPageName
    Pages[5] = transformPageName
    Pages[6] = "Compatibility Checks"
    
    settingsPageEnergyCastingConcStyleOptions = new string[4]
    settingsPageEnergyCastingConcStyleOptions[0] = settingsPageEnergyCastingConcStyleLeftOnly 
    settingsPageEnergyCastingConcStyleOptions[1] = settingsPageEnergyCastingConcStyleBothHands
    settingsPageEnergyCastingConcStyleOptions[2] = settingsPageEnergyCastingConcStyleRightOnly 
    settingsPageEnergyCastingConcStyleOptions[3] = settingsPageEnergyCastingConcStyleNone

    statusPageFollowedPathOptions = new string[3]
    statusPageFollowedPathOptions[0] = "Path of Sanguine"
    statusPageFollowedPathOptions[1] = "Path of Molag Bal"
    statusPageFollowedPathOptions[2] = "Path of Vaermina"
EndEvent

Event OnConfigClose()
    loadEquipment = false
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
            AddMenuOptionST("PathMenu", statusPageFollowedPath, statusPageFollowedPathOptions[CoL.followedPath])
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("EndSuccubus", statusPageEndSuccubus, None)
            if CoL.npcSuccubusQuest.GetState() == "Running"
                AddTextOptionST("EndNPCSuccubus", statusPageEndNPCSuccubus, None)
            else
                AddTextOptionST("BecomeNPCSuccubus", statusPageBecomeNPCSuccubus, None)
            endif
            AddTextOptionST("EnergyRefill", statusPageRefillEnergy, None)
            AddTextOptionST("LevelUp", statusPageLevelUp, None)
            AddToggleOptionST("DebugLogging", statusPageDebugLogging, CoL.DebugLogging)
            AddToggleOptionST("EnergyScaleTest", statusPageEnergyScaleTest, CoL.EnergyScaleTestEnabled)
            AddHeaderOption(statusPageNPCHeader)
            int i = 0
            while i < CoL.succubusList.Length
                string npcName = CoL.succubusList[i].GetActorBase().GetName()
                AddTextOptionST("statusPageNPC+" + i, npcName, None)
                i += 1
            endwhile
        else
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("BecomeSuccubus", statusPageBecomeSuccubus, None)
            if CoL.npcSuccubusQuest.GetState() == "Running"
                AddTextOptionST("EndNPCSuccubus", statusPageEndNPCSuccubus, None)
            else
                AddTextOptionST("BecomeNPCSuccubus", statusPageBecomeNPCSuccubus, None)
            endif
            AddHeaderOption(statusPageNPCHeader)
            int i = 0
            while i < CoL.succubusList.Length
                string npcName = CoL.succubusList[i].GetActorBase().GetName()
                AddTextOptionST("statusPageNPC+" + i, npcName, None)
                i += 1
            endwhile
        endif
; Page 2 - Settings
    elseif page == settingsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        ; Drain Settings
        AddHeaderOption(settingsPageDrainHeader)
        AddToggleOptionST("DrainToggleOption", settingsPageDrainToggle, CoL.drainHandler.draining)
        AddToggleOptionST("DrainToDeathToggleOption", settingsPageDrainToDeathToggle, CoL.drainHandler.drainingToDeath)
        AddToggleOptionST("DrainVerbosityToggleOption", settingsPageDrainVerbosity, CoL.drainNotificationsEnabled)
        AddSliderOptionST("DrainDurationSlider", settingsPageDrainDuration, CoL.drainDurationInGameTime)
        AddSliderOptionST("HealthDrainMultiSlider", settingsPageHealthDrainMult, CoL.healthDrainMult, "{1}")
        AddSliderOptionST("DrainArousalMultiSlider", settingsPageDrainArousalMult, CoL.drainArousalMult, "{1}")
        AddSliderOptionST("EnergyConversionRateSlider", settingsPageEnergyConversionRate, CoL.energyConversionRate, "{1}")
        AddToggleOptionST("DrainFeedsVampireOption", settingsPageDrainFeedsVampire, CoL.drainFeedsVampire)
        ; NPC Drain Settings
        AddHeaderOption(settingsPageNpcDrainHeader)
        AddSliderOptionST("npcDeathChanceSlider", settingsPageNpcDeathChance, CoL.npcDrainToDeathChance, "{1}")
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
        AddSliderOptionST("HungerThresholdSlider", settingsPageHungerThreshold, CoL.hungerThreshold)
        AddSliderOptionST("HungerAmountSlider", settingsPageHungerAmount, CoL.dailyHungerAmount)
        AddToggleOptionST("HungerDamageToggle", settingsPageHungerDamage, CoL.hungerDamageEnabled)
        AddSliderOptionST("HungerDamageAmountSlider", settingsPageHungerDamageAmount, CoL.hungerDamageAmount)
        AddToggleOptionST("HungerArousalToggle", settingsPageHungerArousal, CoL.hungerArousalEnabled)
        AddSliderOptionST("HungerArousalAmountSlider", settingsPageHungerArousalAmount, CoL.hungerArousalAmount)
        ; Tattoo Settings
        SetCursorPosition(1)
        AddHeaderOption(settingsPageTattooHeader)
        AddToggleOptionST("tattooFade", settingsPageTattooFade, CoL.tattooFade)
        AddSliderOptionST("tattooSlot", settingsPageTattooSlot, CoL.tattooSlot)
        ; Power Settings
        AddHeaderOption(settingsPagePowerHeader)
        AddSliderOptionST("BecomeEtherealCostSlider", settingsPageBecomeEtherealCost, CoL.becomeEtherealCost)
        AddEmptyOption()
        AddSliderOptionST("HealRateBoostCostSlider", settingsPageHealRateBoostCost, CoL.healRateBoostCost)
        AddSliderOptionST("HealRateBoostMultSlider", settingsPageHealRateBoostMult, CoL.healRateBoostMult)
        AddToggleOptionST("HealRateBoostFlat", settingsPageHealRateBoostFlat, CoL.healRateBoostFlat)
        AddEmptyOption()
        AddSliderOptionST("EnergyCastingMultSlider", settingsPageEnergyCastingMult, CoL.energyCastingMult, "{1}")
        AddMenuOptionST("EnergyCastingConcStyleMenu", settingsPageEnergyCastingConcStyle, settingsPageEnergyCastingConcStyleOptions[CoL.energyCastingConcStyle])
        AddEmptyOption()
        AddSliderOptionST("TemptationCostSlider", settingsPageTemptationCost, CoL.temptationCost)
        AddSliderOptionST("TemptationBaseIncreaseSlider", settingsPageTemptationBaseIncrease, CoL.temptationBaseIncrease)
        AddSliderOptionST("TemptationLevelMultSlider", settingsPageTemptationLevelMult, CoL.temptationLevelMult)
        AddEmptyOption()
        AddSliderOptionST("ExcitementCostSlider", settingsPageExcitementCost, CoL.excitementCost)
        AddSliderOptionST("ExcitementBaseIncreaseSlider", settingsPageExcitementBaseIncrease, CoL.excitementBaseIncrease)
        AddSliderOptionST("ExcitementLevelMultSlider", settingsPageExcitementLevelMult, CoL.excitementLevelMult)
        AddEmptyOption()
        AddSliderOptionST("SuppressionCostSlider", settingsPageSuppressionCost, CoL.suppressionCost)
        AddSliderOptionST("SuppressionBaseIncreaseSlider", settingsPageSuppressionBaseIncrease, CoL.suppressionBaseIncrease)
        AddSliderOptionST("SuppressionLevelMultSlider", settingsPageSuppressionLevelMult, CoL.suppressionLevelMult)
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
        AddSliderOptionST("energyMeterAlphaSlider", widgetsPageEnergyMeterAlpha, CoL.widgetHandler.energyMeterAlpha)
        AddToggleOptionST("energyMeterAutoHideToggle", widgetsPageEnergyMeterAutoHide, CoL.widgetHandler.autoFade)
        AddSliderOptionST("energyMeterAutoHideTimerSlider", widgetsPageEnergyMeterAutoHideTime, CoL.widgetHandler.autoFadeTime)
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
        if !CoL.slakeThirst
            AddToggleOptionST("perkSlakeThirst", perkPageSlakeThirst, CoL.slakeThirst)
        else
            AddToggleOptionST("perkSlakeThirst", perkPageSlakeThirst, CoL.slakeThirst, OPTION_FLAG_DISABLED)
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
        AddToggleOptionST("transformCrime", transformPageTransformCrime, CoL.transformCrime)
        AddToggleOptionST("transformEquipment", transformPageEquipmentSwap, CoL.transformSwapsEquipment)
        AddToggleOptionST("transformAnimation", transformPageTransformAnimation, CoL.transformAnimation)
        AddSliderOptionST("transformCost", transformPageTransformCost, CoL.transformCost)
        AddSliderOptionST("transformArousalUpperThreshold", transformPageTransformArousalUpperThreshold, CoL.transformArousalUpperThreshold)
        AddSliderOptionST("transformArousalLowerThreshold", transformPageTransformArousalLowerThreshold, CoL.transformArousalLowerThreshold)
        AddHeaderOption(transformPageBuffsHeader)
        AddToggleOptionST("transformBuffsEnable", transformPageBuffsEnabled, CoL.transformBuffsEnabled)
        AddSliderOptionST("transformBuffsArmor", transformPageBuffsArmor, CoL.extraArmor)
        AddSliderOptionST("transformBuffsMagicResist", transformPageBuffsMagicResist, CoL.extraMagicResist)
        AddSliderOptionST("transformBuffsHealth", transformPageBuffsHealth, CoL.extraHealth)
        AddSliderOptionST("transformBuffsMagicka", transformPageBuffsMagicka, CoL.extraMagicka)
        AddSliderOptionST("transformBuffsStamina", transformPageBuffsStamina, CoL.extraStamina)
        AddSliderOptionST("transformBuffsExtraMeleeDamage", transformPageBuffsExtraMeleeDamage, CoL.extraMeleeDamage, "{1}")
        AddSliderOptionST("transformBuffsExtraCarryWeight", transformPageBuffsExtraCarryWeight, CoL.extraCarryWeight)
        SetCursorPosition(1)
        AddHeaderOption(transformPageEquipmentHeader)
        AddTextOptionST("transformActivateEquipmentChest", transformPageEquipmentSave , None)
        if !loadEquipment
            AddTextOptionST("transformLoadEquipment", transformPageLoadEquipment , None)
        endif
        if loadEquipment
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
; Page 7 - Compatibilities
    elseif page == "Compatibility Checks"
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption("OStim")
        AddToggleOptionST("OStim", "OStim", (oStim_Interfaces as CoL_Interface_Ostim_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
        AddToggleOptionST("OAroused", "OAroused", (oStim_Interfaces as CoL_Interface_OAroused_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
        AddHeaderOption("SexLab")
        AddToggleOptionST("SexLab", "SexLab", (SexLab_Interfaces as CoL_Interface_SexLab_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
        AddToggleOptionST("SLSO", "SexLab Separate Orgasms", Quest.GetQuest("SLSO"), OPTION_FLAG_DISABLED)
        AddToggleOptionST("SLAR", "SexLab Aroused", (SexLab_Interfaces as CoL_Interface_SLAR_Script).IsInterfaceActive(), OPTION_FLAG_DISABLED)
        AddHeaderOption("Toys & Love")
        AddToggleOptionST("TL", "Toys & Love", Game.IsPluginInstalled("Toys.esm"), OPTION_FLAG_DISABLED)

    endif
EndEvent

string[] function getoptions()
	return stringsplit(getstate(), "+")
endfunction

; Page 1 State Handlers
    State BecomeSuccubus
        Event OnSelectST()
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "BecomeSuccubus")
            CoL.GoToState("Initialize")
            SetTextOptionValueST("Exit Menu Now")
            Utility.Wait(0.5)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageBecomeSuccubusHelp)
        EndEvent
    EndState

    State EndSuccubus
        Event OnSelectST()
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EndSuccubus")
            CoL.GoToState("Uninitialize")
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageEndSuccubusHelp)
        EndEvent
    EndState

    State BecomeNPCSuccubus
        Event OnSelectST()
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "BecomeNPCSuccubus")
            CoL.npcSuccubusQuest.GoToState("Initialize")
            SetTextOptionValueST("Exit Menu Now")
            Utility.Wait(0.5)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageBecomeNPCSuccubusHelp)
        EndEvent
    EndState

    State EndNPCSuccubus
        Event OnSelectST()
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EndNPCSuccubus")
            CoL.npcSuccubusQuest.GoToState("Uninitialize")
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageEndNPCSuccubusHelp)
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

    State PathMenu
        Event OnMenuOpenST()
            SetMenuDialogOptions(statusPageFollowedPathOptions)
            SetMenuDialogStartIndex(CoL.followedPath)
            SetMenuDialogDefaultIndex(0)
        EndEvent
        Event OnMenuAcceptST(int index)
            CoL.followedPath = index
            SetMenuOptionValueST(statusPageFollowedPathOptions[index])
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageFollowedPathHelp)
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

    State LevelUp
        Event OnSelectST()
            CoL.levelHandler.playerSuccubusXP = CoL.levelHandler.xpForNextLevel + 1
            SetTextOptionValueST(CoL.levelHandler.playerSuccubusLevel.GetValueInt(), false, "SuccubusCurrentLevel")
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageLevelUpHelp)
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

    State EnergyScaleTest
        Event OnSelectST()
            CoL.EnergyScaleTestEnabled = !CoL.EnergyScaleTestEnabled
            SetToggleOptionValueST(CoL.EnergyScaleTestEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(statusPageEnergyScaleTestHelp)
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
    State DrainVerbosityToggleOption
        Event OnSelectST()
            CoL.drainNotificationsEnabled = !CoL.drainNotificationsEnabled
            SetToggleOptionValueST(CoL.drainNotificationsEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageDrainVerbosityHelp)
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
    State DrainArousalMultiSlide
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.drainArousalMult)
            SetSliderDialogDefaultValue(0.1)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.healthDrainMult = value
            SetSliderOptionValueST(CoL.drainArousalMult,"{1}")
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
    State NpcDeathChanceSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.npcDrainToDeathChance)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.npcDrainToDeathChance = value as int
            SetSliderOptionValueST(CoL.npcDrainToDeathChance,"{1}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageNpcDeathChanceHelp)
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
    State HungerThresholdSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.hungerThreshold as float)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.hungerThreshold = value as int
            SetSliderOptionValueST(CoL.hungerThreshold as float)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerThresholdHelp)
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
    State HungerArousalToggle
        Event OnSelectST()
            CoL.hungerArousalEnabled = !CoL.hungerArousalEnabled
            SetToggleOptionValueST(CoL.hungerArousalEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerArousalHelp)
        EndEvent
    EndState
    State HungerArousalAmountSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.hungerArousalAmount)
            SetSliderDialogDefaultValue(5.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0.0, 100.0)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.hungerArousalAmount = value
            SetSliderOptionValueST(CoL.hungerArousalAmount)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHungerArousalAmountHelp)
        EndEvent
    EndState

    State tattooFade
        Event OnSelectST()
            CoL.tattooFade = !CoL.tattooFade
            SetToggleOptionValueST(CoL.tattooFade)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageTattooFadeHelp)
        EndEvent
    EndState
    State tattooSlot
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.tattooSlot)
            SetSliderDialogDefaultValue(6)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 6)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.tattooSlot = value as int
            SetSliderOptionValueST(CoL.tattooSlot)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageTattooSlotHelp)
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
    State HealRateBoostFlat
        Event OnSelectST()
            CoL.healRateBoostFlat = !CoL.hungerEnabled
            SetToggleOptionValueST(CoL.healRateBoostFlat)
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageHealRateBoostFlatHelp)
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

    State TemptationCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.temptationCost)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.temptationCost = value as int
            SetSliderOptionValueST(CoL.temptationCost, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageTemptationCostHelp)
        EndEvent
    EndState
    State TemptationBaseIncreaseSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.temptationBaseIncrease)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.temptationBaseIncrease = value as int
            SetSliderOptionValueST(CoL.temptationBaseIncrease, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageTemptationBaseIncreaseHelp)
        EndEvent
    EndState
    State TemptationLevelMultSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.temptationLevelMult)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.temptationLevelMult = value as int
            SetSliderOptionValueST(CoL.temptationLevelMult, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageTemptationLevelMultHelp)
        EndEvent
    EndState

    State ExcitementCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.excitementCost)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.excitementCost = value as int
            SetSliderOptionValueST(CoL.excitementCost, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageExcitementCostHelp)
        EndEvent
    EndState
    State ExcitementBaseIncreaseSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.excitementBaseIncrease)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.excitementBaseIncrease = value as int
            SetSliderOptionValueST(CoL.excitementBaseIncrease, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageExcitementBaseIncreaseHelp)
        EndEvent
    EndState
    State ExcitementLevelMultSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.excitementLevelMult)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.excitementLevelMult = value as int
            SetSliderOptionValueST(CoL.excitementLevelMult, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageExcitementLevelMultHelp)
        EndEvent
    EndState

    State SuppressionCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.suppressionCost)
            SetSliderDialogDefaultValue(10.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.suppressionCost = value as int
            SetSliderOptionValueST(CoL.suppressionCost, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageSuppressionCostHelp)
        EndEvent
    EndState
    State SuppressionBaseIncreaseSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.suppressionBaseIncrease)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.suppressionBaseIncrease = value as int
            SetSliderOptionValueST(CoL.suppressionBaseIncrease, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageSuppressionBaseIncreaseHelp)
        EndEvent
    EndState
    State SuppressionLevelMultSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.suppressionLevelMult)
            SetSliderDialogDefaultValue(1.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.suppressionLevelMult = value as int
            SetSliderOptionValueST(CoL.suppressionLevelMult, "{0}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(settingsPageSuppressionLevelMultHelp)
        EndEvent
    EndState

; Page 3 State Handlers
    State DrainKeyMapOption
        Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
            if keyCode == 1
                CoL.toggleDrainHotkey = -1
                SetKeyMapOptionValueST(-1)
                return
            endif
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
            if keyCode == 1
                CoL.toggleDrainHotkey = -1
                SetKeyMapOptionValueST(-1)
                return
            endif
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
    State energyMeterAlphaSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.energyMeterAlpha)
            SetSliderDialogDefaultValue(100)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.energyMeterAlpha = value as int
            SetSliderOptionValueST(CoL.widgetHandler.energyMeterAlpha)
            meterBarChanged = true
        EndEvent
        Event OnHighlightST()
            SetInfoText(widgetsPageEnergyMeterYScaleHelp)
        EndEvent
    EndState
    State energyMeterAutoHideToggle
        Event OnSelectST()
            CoL.widgetHandler.autoFade = !CoL.widgetHandler.autoFade
            SetToggleOptionValueST(CoL.widgetHandler.autoFade)
            CoL.widgetHandler.ShowMeter()
            meterBarChanged = true
        EndEvent
        Event OnHighlightST()
            SetInfoText(widgetsPageEnergyMeterAutoHideHelp)
        EndEvent
    EndState
   State energyMeterAutoHideTimerSlider 
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.widgetHandler.autoFadeTime)
            SetSliderDialogDefaultValue(10)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 30)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.widgetHandler.autoFadeTime = value as int
            SetSliderOptionValueST(CoL.widgetHandler.autoFadeTime)
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
    State perkSlakeThirst
        Event OnSelectST()
            if CoL.availablePerkPoints > 0
                CoL.slakeThirst = !CoL.slakeThirst
                SetToggleOptionValueST(CoL.slakeThirst)
                CoL.availablePerkPoints -= 1
                ForcePageReset()
            else
                Debug.MessageBox(perkPageOutOfPerkPoints)
            endif
        EndEvent
        Event OnHighlightST()
            SetInfoText(perkpageSlakeThirstHelp)
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
    State transformCrime
        Event OnSelectST()
            CoL.transformCrime = !CoL.transformCrime
            SetToggleOptionValueST(CoL.transformCrime)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageTransformCrimeHelp)
        EndEvent
    EndState
    State transformEquipment
        Event OnSelectST()
            CoL.transformSwapsEquipment = !CoL.transformSwapsEquipment
            SetToggleOptionValueST(CoL.transformSwapsEquipment)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageEquipmentSwap)
        EndEvent
    EndState
    State transformAnimation
        Event OnSelectST()
            CoL.transformAnimation = !CoL.transformAnimation
            SetToggleOptionValueST(CoL.transformAnimation)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageTransformAnimationHelp)
        EndEvent
    EndState
    State transformCost
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.transformCost)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.transformCost = value
            SetSliderOptionValueST(CoL.transformCost)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageTransformCostHelp)
        EndEvent
    EndState
    State transformLoadEquipment
        Event OnSelectST()
            loadEquipment = true
            ForcePageReset()
        EndEvent
    EndState
    State transformBuffsEnable
        Event OnSelectST()
            CoL.transformBuffsEnabled = !CoL.transformBuffsEnabled
            SetToggleOptionValueST(CoL.transformBuffsEnabled)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsEnabled)
        EndEvent
    EndState
    State transformBuffsArmor
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraArmor)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraArmor = value
            SetSliderOptionValueST(CoL.extraArmor)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsArmorHelp)
        EndEvent
    EndState
    State transformBuffsMagicResist
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraMagicResist)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraMagicResist = value
            SetSliderOptionValueST(CoL.extraMagicResist)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsMagicResistHelp)
        EndEvent
    EndState
    State transformBuffsHealth
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraHealth)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraHealth = value
            SetSliderOptionValueST(CoL.extraHealth)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsHealthHelp)
        EndEvent
    EndState
    State transformBuffsMagicka
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraMagicka)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraMagicka = value
            SetSliderOptionValueST(CoL.extraMagicka)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsMagickaHelp)
        EndEvent
    EndState
    State transformBuffsStamina
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraStamina)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraStamina = value
            SetSliderOptionValueST(CoL.extraStamina)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsStaminaHelp)
        EndEvent
    EndState
    State transformBuffsExtraMeleeDamage
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraMeleeDamage)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraMeleeDamage = value
            SetSliderOptionValueST(CoL.extraMeleeDamage, "{1}")
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsExtraMeleeDamageHelp)
        EndEvent
    EndState
    State transformBuffsExtraCarryWeight
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.extraCarryWeight)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 1000)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.extraCarryWeight = value
            SetSliderOptionValueST(CoL.extraCarryWeight)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPageBuffsExtraCarryWeightHelp)
        EndEvent
    EndState
    State transformArousalUpperThreshold
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.transformArousalUpperThreshold)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.transformArousalUpperThreshold = value
            SetSliderOptionValueST(CoL.transformArousalUpperThreshold)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPagetransformArousalUpperThreshold)
        EndEvent
    EndState
    State transformArousalLowerThreshold
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.transformArousalLowerThreshold)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.transformArousalLowerThreshold = value
            SetSliderOptionValueST(CoL.transformArousalLowerThreshold)
        EndEvent
        Event OnHighlightST()
            SetInfoText(transformPagetransformArousalLowerThreshold)
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
               CoL.Log("Removing " + itemRef.GetName())
                int i = 0
                CoL.Log("Worn Item List contains:")
                while i < equippedItems.Length
                    CoL.Log(equippedItems[i].getName())
                    i += 1
                endwhile
            endif

            ForcePageReset()
        elseif option == "transformAddStrippable"
            int index = options[1] as int
            Form itemRef = equippedItems[index]
            CoL.NoStripList = PushForm(CoL.NoStripList, itemRef)

            if CoL.DebugLogging
                CoL.Log("Adding " + itemRef.getName())
                int i = 0
                CoL.Log("Don't strip list contains:")
                while i < CoL.NoStripList.Length
                    CoL.Log(CoL.NoStripList[i].getName())
                    i += 1
                endwhile
            endif

            ForcePageReset()
        elseif option == "statusPageNPC"
            int index = options[1] as int
            CoL.succubusList[index].RemoveSpell(CoL.sceneHandlerSpell)
            CoL.succubusList = RemoveActor(CoL.succubusList, CoL.succubusList[index])
            ForcePageReset()
        endif
    EndEvent
    Event OnHighlightST()
        string[] options = getOptions()
        string option = options[0]
        if option == "statusPageNPC"
            SetInfoText(statusPageNPCHelp)
        endif
    EndEvent

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
    equippedItems = ClearNone(equippedItems)
    if PapyrusUtil.GetVersion() >= 40
        equippedItems = RemoveDupeForm(equippedItems)
    else
        ; Deal with SE PapyrusUtils
        equippedItems = MergeFormArray(equippedItems, equippedItems, true)
    endif
	return equippedItems
EndFunction