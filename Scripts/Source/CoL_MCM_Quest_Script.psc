Scriptname CoL_MCM_Quest_Script extends SKI_ConfigBase

CoL_PlayerSuccubusQuestScript Property CoL Auto
GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus

string[] settingsPageEnergyCastingConcStyleOptions
bool meterBarChanged = false

; String values to make translating the menu easier once I figure out how translation files work
; Page 1 - Status
    string statusPageName = "Status"
    string statusPageHeaderOne = "Current Stats"
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

Event OnConfigInit()
    Pages = new string[4]
    Pages[0] = statusPageName
    Pages[1] = settingsPageName
    Pages[2] = hotkeysPageName
    Pages[3] = widgetsPageName
    
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
; Page 1
    elseif page == statusPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption(statusPageHeaderOne)
        if isPlayerSuccubus.GetValue() as int == 1
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
; Page 2
    elseif page == settingsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        ; Drain Settings
        AddHeaderOption(settingsPageDrainHeader)
        AddToggleOptionST("DrainToggleOption", settingsPageDrainToggle, CoL.drainHandler.draining)
        AddToggleOptionST("DrainToDeathToggleOption", settingsPageDrainToDeathToggle, CoL.drainHandler.drainingToDeath)
        AddSliderOptionST("DrainDurationSlider", settingsPageDrainDuration, CoL.drainDurationInGameTime)
        AddSliderOptionST("HealthDrainMultiSlider", settingsPageHealthDrainMult, CoL.healthDrainMult, "{1}")
        AddSliderOptionST("EnergyConversionRateSlider", settingsPageEnergyConversionRate, CoL.energyConversionRate, "{1}")
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

; Page 3
    elseif page == hotkeysPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddKeyMapOptionST("DrainKeyMapOption", hotkeysPageToggleDrainHotkey, CoL.toggleDrainHotkey)
        AddKeyMapOptionST("DrainToDeathKeyMapOption", hotkeysPageToggleDrainToDeathHotkey, CoL.toggleDrainToDeathHotkey)
    elseif page == widgetsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddSliderOptionST("energyMeterXPosSlider", widgetsPageEnergyMeterXPos, CoL.widgetHandler.energyMeterXPos)
        AddSliderOptionST("energyMeterYPosSlider", widgetsPageEnergyMeterYPos, CoL.widgetHandler.energyMeterYPos)
        AddSliderOptionST("energyMeterXScaleSlider", widgetsPageEnergyMeterXScale, CoL.widgetHandler.energyMeterXScale)
        AddSliderOptionST("energyMeterYScaleSlider", widgetsPageEnergyMeterYScale, CoL.widgetHandler.energyMeterYScale)
    endif
EndEvent

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