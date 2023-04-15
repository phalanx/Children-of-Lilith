Scriptname CoL_MCM_Powers_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnInit()
    RegisterModule("$COL_POWERSPAGE_NAME", 30)
EndEvent

Event OnPageInit()
    ; configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_POWERSPAGE_HEADER_POWER")
    AddSliderOptionST("Slider_becomeEtherealCost", "$COL_POWERSPAGE_BECOMEETHEREALCOST", configHandler.becomeEtherealCost)
    AddEmptyOption()
    AddSliderOptionST("Slider_healRateBoostCost", "$COL_POWERSPAGE_HEALRATEBOOSTCOST", configHandler.healRateBoostCost)
    AddSliderOptionST("Slider_healRateBoostAmount", "$COL_POWERSPAGE_HEALRATEBOOSTAMOUNT", configHandler.healRateBoostAmount)
    AddEmptyOption()
    AddSliderOptionST("Slider_energyCastingMult", "$COL_POWERSPAGE_ENERGYCASTINGMULT", configHandler.energyCastingMult, "{0}")
    AddMenuOptionST("Menu_energyCastingConcStyle", "$COL_POWERSPAGE_COSTCALCSTYLE", configHandler.energyCastingConcStyleOptions[configHandler.energyCastingConcStyle])
    SetCursorPosition(1)
    AddSliderOptionST("Slider_temptationCost", "$COL_POWERSPAGE_TEMPTATIONCOST", configHandler.newTemptationCost)
    AddSliderOptionST("Slider_temptationBaseIncrease", "$COL_POWERSPAGE_TEMPTATIONBASE", configHandler.newTemptationBaseIncrease)
    AddSliderOptionST("Slider_temptationLevelMult", "$COL_POWERSPAGE_TEMPTATIONLEVELMULT", configHandler.newTemptationLevelMult)
    AddEmptyOption()
    AddSliderOptionST("Slider_excitementCost", "$COL_POWERSPAGE_EXCITEMENTCOST", configHandler.excitementCost)
    AddSliderOptionST("Slider_excitementBaseIncrease", "$COL_POWERSPAGE_EXCITEMENTBASE", configHandler.excitementBaseIncrease)
    AddSliderOptionST("Slider_excitementLevelMult", "$COL_POWERSPAGE_EXCITEMENTLEVELMULT", configHandler.excitementLevelMult)
    AddEmptyOption()
    AddSliderOptionST("Slider_suppressionCost", "$COL_POWERSPAGE_SUPPRESSIONCOST", configHandler.suppressionCost)
    AddSliderOptionST("Slider_suppressionBaseIncrease", "$COL_POWERSPAGE_SUPPRESSIONBASE", configHandler.suppressionBaseIncrease)
    AddSliderOptionST("Slider_suppressionLevelMult", "$COL_POWERSPAGE_SUPPRESSIONLEVELMULT", configHandler.suppressionLevelMult)
EndEvent

State Slider_becomeEtherealCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.becomeEtherealCost)
        SetSliderDialogDefaultValue(10)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 10)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.becomeEtherealCost = value
        SetSliderOptionValueST(configHandler.becomeEtherealCost)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_BECOMEETHEREALCOST_HELP")
    EndEvent
EndState
State Slider_healRateBoostCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.healRateBoostCost)
        SetSliderDialogDefaultValue(5)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 10)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.healRateBoostCost = value
        SetSliderOptionValueST(configHandler.healRateBoostCost)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_HEALRATEBOOSTCOST_HELP")
    EndEvent
EndState
State Slider_healRateBoostAmount
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.healRateBoostAmount)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(1.0, 20.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.healRateBoostAmount = value
        SetSliderOptionValueST(configHandler.healRateBoostAmount)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_HEALRATEBOOSTAMOUNT_HELP")
    EndEvent
EndState

State Slider_energyCastingMult
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyCastingMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0.1, 10.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyCastingMult = value
        SetSliderOptionValueST(configHandler.energyCastingMult, "{1}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_ENERGYCASTINGMULT_HELP")
    EndEvent
EndState
State Menu_energyCastingConcStyle
    Event OnMenuOpenST(string state_id) 
        SetMenuDialogOptions(configHandler.energyCastingConcStyleOptions)
        SetMenuDialogStartIndex(configHandler.energyCastingConcStyle)
        SetMenuDialogDefaultIndex(1)
    EndEvent
    Event OnMenuAcceptST(string state_id, int newVal)
        configHandler.energyCastingConcStyle = newVal
        SetMenuOptionValueST(configHandler.energyCastingConcStyleOptions[configHandler.energyCastingConcStyle])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_COSTCALCSTYLE_HELP")
    EndEvent
EndState

State Slider_temptationCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.newTemptationCost)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.newTemptationCost = value as int
        SetSliderOptionValueST(configHandler.newTemptationCost, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_TEMPTATIONCOST_HELP")
    EndEvent
EndState
State Slider_temptationBaseIncrease
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.newTemptationBaseIncrease)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.newTemptationBaseIncrease = value as int
        SetSliderOptionValueST(configHandler.newTemptationBaseIncrease, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_TEMPTATIONBASE_HELP")
    EndEvent
EndState
State Slider_temptationLevelMult
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.newTemptationLevelMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.newTemptationLevelMult = value as int
        SetSliderOptionValueST(configHandler.newTemptationLevelMult, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_TEMPTATIONLEVELMULT_HELP")
    EndEvent
EndState

State Slider_excitementCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.excitementCost)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.excitementCost = value as int
        SetSliderOptionValueST(configHandler.excitementCost, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_EXCITEMENTCOST_HELP")
    EndEvent
EndState
State Slider_excitementBaseIncrease
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.excitementBaseIncrease)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.excitementBaseIncrease = value as int
        SetSliderOptionValueST(configHandler.excitementBaseIncrease, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_EXCITEMENTBASE_HELP")
    EndEvent
EndState
State Slider_excitementLevelMult
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.excitementLevelMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.excitementLevelMult = value as int
        SetSliderOptionValueST(configHandler.excitementLevelMult, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_EXCITEMENTLEVELMULT_HELP")
    EndEvent
EndState

State Slider_suppressionCost
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.suppressionCost)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.suppressionCost = value as int
        SetSliderOptionValueST(configHandler.suppressionCost, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_SUPPRESSIONCOST_HELP")
    EndEvent
EndState
State Slider_suppressionBaseIncrease 
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.suppressionBaseIncrease)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.suppressionBaseIncrease = value as int
        SetSliderOptionValueST(configHandler.suppressionBaseIncrease, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_SUPPRESSIONBASE_HELP")
    EndEvent
EndState
State Slider_suppressionLevelMult
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.suppressionLevelMult)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(0, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.suppressionLevelMult = value as int
        SetSliderOptionValueST(configHandler.suppressionLevelMult, "{0}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_POWERSPAGE_SUPPRESSIONLEVELMULT_HELP")
    EndEvent
EndState