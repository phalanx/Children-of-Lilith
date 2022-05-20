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
    string statusPageBecomeSuccubus = "Become Succubus"
    string statusPageEndSuccubus = "End Succubus"

    string statusPageHeaderTwo = "Debug and Maintenance"

; Page 2 - Settings
    string settingsPageName = "Settings"
    string settingsPageHeaderOne = "Drain Settings"
    string settingsPageDrainToggle = "Draining"
    string settingsPageDrainToDeathToggle = "Draining to Death"
    string settingsPageDrainDuration = "Drain Duration"
    string settingsPageHealthDrainMult = "Health Drain Multiplier"
    string settingsPageEnergyConversionRate = "Energy Conversion Rate"

    string settingsPageHeaderTwo = "Power Settings"
    string settingsPageBecomeEtherealCost = "Become Ethereal Per Second Cost"
    string settingsPageHealRateBoostCost = "HealRate Boost Per Second Cost"
    string settingsPageHealRateBoostMult = "HealRate Boost Multiplier"
    string settingsPageEnergyCastingMult = "Energy Casting Cost Multiplier"
    string settingsPageEnergyCastingConcStyle = "Concentration Cost Calculation Style"
    string settingsPageEnergyCastingConcStyleLeftOnly = "Left Hand Only" 
    string settingsPageEnergyCastingConcStyleBothHands = "Both Hands" 
    string settingsPageEnergyCastingConcStyleRightOnly = "Right Hand Only" 
    string settingsPageEnergyCastingConcStyleNone = "Neither" 
; Page 3 - Hotkeys
    string hotkeysPageName = "Hotkeys"
    string hotkeysPageToggleDrainHotkey = "Toggle Drain Key"
    string hotkeysPageToggleDrainToDeathHotkey = "Toggle Drain to Death Key"
; Page 4 - Widgets
    string widgetsPageName = "Widgets"
    string widgetsPageEnergyMeterXPos = "Energy Meter X Position"
    string widgetsPageEnergyMeterYPos = "Energy Meter Y Position"
    string widgetsPageEnergyMeterXScale = "Energy Meter X Scale"
    string widgetsPageEnergyMeterYScale = "Energy Meter Y Scale"

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
            AddTextOptionST("EnergyRefill", "Refill Energy", None)
            AddToggleOptionST("DebugLogging", "Enable Debug Logging", CoL.DebugLogging)
        else
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("BecomeSuccubus", statusPageBecomeSuccubus, None)
        endif
; Page 2
    elseif page == settingsPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        ; Drain Settings
        AddHeaderOption(settingsPageHeaderOne)
        AddToggleOptionST("DrainToggleOption", settingsPageDrainToggle, CoL.drainHandler.draining)
        AddToggleOptionST("DrainToDeathToggleOption", settingsPageDrainToDeathToggle, CoL.drainHandler.drainingToDeath)
        AddSliderOptionST("DrainDurationSlider", settingsPageDrainDuration, CoL.drainDurationInGameTime)
        AddSliderOptionST("HealthDrainMultiSlider", settingsPageHealthDrainMult, CoL.healthDrainMult, "{1}")
        AddSLiderOptionST("HealthConversionRateSlider", settingsPageEnergyConversionRate, CoL.energyConversionRate, "{1}")
        ; Power Settings
        SetCursorPosition(1)
        AddHeaderOption(settingsPageHeaderTwo)
        AddSliderOptionST("BecomeEtherealCostSlider", settingsPageBecomeEtherealCost, CoL.becomeEtherealCost)
        AddEmptyOption()
        AddSliderOptionST("HealRateBoostCostSlider", settingsPageHealRateBoostCost, CoL.healRateBoostCost)
        AddSliderOptionST("HealRateBoostMultSlider", settingsPageHealRateBoostMult, CoL.healRateBoostMult)
        AddEmptyOption()
        AddSliderOptionST("EnergyCastingCostMultSlider", settingsPageEnergyCastingMult, CoL.energyCastingMult, "{1}")
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
            isPlayerSuccubus.SetValue(1.0)
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "BecomeSuccubus")
        EndEvent
    EndState

    State EndSuccubus
        Event OnSelectST()
            isPlayerSuccubus.SetValue(0.0)
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "EndSuccubus")
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
    EndState

    State EnergyRefill
        Event OnSelectST()
            CoL.playerEnergyCurrent = CoL.playerEnergyMax
            SetTextOptionValueST(CoL.playerEnergyCurrent as int, false, "EnergyCurrentTextOption")
        EndEvent
    EndState
    State DebugLogging
        Event OnSelectST()
            CoL.DebugLogging = !CoL.DebugLogging
            SetToggleOptionValueST(CoL.DebugLogging)
        EndEvent
    EndState

; Page 2 State Handlers
    State DrainToggleOption
        Event OnSelectST()
            CoL.drainHandler.draining = !CoL.drainHandler.draining
            SetToggleOptionValueST(CoL.drainHandler.draining)
        EndEvent
    EndState
    State DrainToDeathToggleOption
        Event OnSelectST()
            CoL.drainHandler.drainingToDeath = !CoL.drainHandler.drainingToDeath
            SetToggleOptionValueST(CoL.drainHandler.drainingToDeath)
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
    EndState
    State HealthConversionRateSlider
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
    EndState
    State EnergyCastingCostMultSlider
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
    EndState