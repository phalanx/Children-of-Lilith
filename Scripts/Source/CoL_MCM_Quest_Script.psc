Scriptname CoL_MCM_Quest_Script extends SKI_ConfigBase

CoL_PlayerSuccubusQuestScript Property CoL Auto
GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus

; String values to make translating the menu easier once I figure out how translation files work
; Page 1
    string statusPageName = "Status"
    string statusPageHeaderOne = "Current Stats"
    string statusPageEnergyCurrent = "Current energy"
    string statusPageEnergyMax = "Maximum energy"
    string statusPageBecomeSuccubus = "Become Succubus"
    string statusPageEndSuccubus = "End Succubus"

    string statusPageHeaderTwo = "Debug and Maintenance"

; Page 2
    string settingsPageName = "Settings"
    string settingsPageHeaderOne = "Drain Settings"
    string settingsPageDrainDuration = "Drain Duration"
    string settingsPageHealthDrainMult = "Health Drain Multiplier"
    string settingsPageEnergyConversionRate = "Energy Conversion Rate"

    string settingsPageHeaderTwo = "Power Settings"
    string settingsPageStaminaBoostCost = "Stamina Boost Per Second Cost"
    string settingsPageStaminaBoostMult = "Stamina Boost Multiplier"
    string settingsPageHealRateBoostCost = "HealRate Boost Per Second Cost"
    string settingsPageHealRateBoostMult = "HealRate Boost Multiplier"
    string settingsPageEnergyCastingMult = "Energy Casting Cost Multiplier"

Event OnConfigInit()
    Pages = new string[2]
    Pages[0] = statusPageName
    Pages[1] = settingsPageName
EndEvent

Event OnPageReset(string page)
    if page == ""
; Page 1
    elseif page == statusPageName
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddHeaderOption(statusPageHeaderOne)
        if isPlayerSuccubus.GetValue() as int == 1
            AddTextOption(statusPageEnergyCurrent+": ", CoL.playerEnergyCurrent as int, OPTION_FLAG_DISABLED)
            AddTextOption(statusPageEnergyMax+": ", CoL.playerEnergyMax as int, OPTION_FLAG_DISABLED)
            SetCursorPosition(1)
            AddHeaderOption(statusPageHeaderTwo)
            AddTextOptionST("EndSuccubus", statusPageEndSuccubus, None)
            AddTextOptionST("EnergyRefill", "Refill Energy", false)
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
        AddSliderOptionST("DrainDurationSlider", settingsPageDrainDuration, CoL.drainDurationInGameTime)
        AddSliderOptionST("HealthDrainMultiSlider", settingsPageHealthDrainMult, CoL.healthDrainMult, "{1}")
        AddSLiderOptionST("HealthConversionRateSlider", settingsPageEnergyConversionRate, CoL.energyConversionRate, "{1}")
        ; Power Settings
        SetCursorPosition(1)
        AddHeaderOption(settingsPageHeaderTwo)
        AddSliderOptionST("StaminaBoostCostSlider", settingsPageStaminaBoostCost, CoL.staminaBoostCost)
        AddSliderOptionST("StaminaBoostMultSlider", settingsPageStaminaBoostMult, CoL.staminaBoostMult)
        AddEmptyOption()
        AddSliderOptionST("HealRateBoostCostSlider", settingsPageHealRateBoostCost, CoL.healRateBoostCost)
        AddSliderOptionST("HealRateBoostMultSlider", settingsPageHealRateBoostMult, CoL.healRateBoostMult)
        AddEmptyOption()
        AddSliderOptionST("EnergyCastingCostMultSlider", settingsPageEnergyCastingMult, CoL.energyCastingMult, "{1}")
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

    State EnergyRefill
        Event OnSelectST()
            CoL.playerEnergyCurrent = CoL.playerEnergyMax
        EndEvent
    EndState

    State DebugLogging
        Event OnSelectST()
            CoL.DebugLogging = !CoL.DebugLogging
            SetToggleOptionValueST(CoL.DebugLogging)
        EndEvent
    EndState

; Page 2 State Handlers
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

    State StaminaBoostCostSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.staminaBoostCost)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.staminaBoostCost = value
            SetSliderOptionValueST(CoL.staminaBoostCost)
        EndEvent
    EndState
    State StaminaBoostMultSlider
        Event OnSliderOpenST()
            SetSliderDialogStartValue(CoL.staminaBoostMult)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent
        Event OnSliderAcceptST(float value)
            CoL.staminaBoostMult = value
            SetSliderOptionValueST(CoL.staminaBoostMult)
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