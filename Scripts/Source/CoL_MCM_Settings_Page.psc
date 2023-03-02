Scriptname CoL_MCM_Settings_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto

CoL_PlayerSuccubusQuestScript psq
CoL_ConfigHandler_Script configHandler
CoL_Mechanic_DrainHandler_Script drainHandler

Event OnInit()
    RegisterModule("$COL_SETTINGSPAGE_NAME", 20)
EndEvent

Event OnPageInit()
    psq = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    drainHandler = playerSuccubusQuest as CoL_Mechanic_DrainHandler_Script
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddSliderOptionST("Slider_maxEnergyBase", "$COL_SETTINGSPAGE_MAXENERGYBASE", configHandler.baseMaxEnergy, "{0}")
    AddHeaderOption("$COL_SETTINGSPAGE_HEADER_ONE")
    if configHandler.lockDrainType
        AddToggleOptionST("Toggle_Drain", "$COL_SETTINGSPAGE_DRAINTOGGLE", drainHandler.draining, OPTION_FLAG_DISABLED)
        AddToggleOptionST("Toggle_DrainToDeath", "$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE", drainHandler.drainingToDeath, OPTION_FLAG_DISABLED)
    else
        AddToggleOptionST("Toggle_Drain", "$COL_SETTINGSPAGE_DRAINTOGGLE", drainHandler.draining)
        AddToggleOptionST("Toggle_DrainToDeath", "$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE", drainHandler.drainingToDeath)
    endif
    AddToggleOptionST("Toggle_lockDrain", "$COL_SETTINGSPAGE_LOCKDRAINTYPETOGGLE", configHandler.lockDrainType)
    AddToggleOptionST("Toggle_deadlyWhenTransformed", "$COL_SETTINGSPAGE_DEADLYDRAINWHILETRANSFORMED", configHandler.deadlyDrainWhenTransformed)
    AddToggleOptionST("Toggle_drainVerbosity", "$COL_SETTINGSPAGE_DRAINVERBOSITY", configHandler.drainNotificationsEnabled)
    AddSliderOptionST("Slider_forcedDrainMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM", configHandler.forcedDrainMinimum, "{0}")
    AddSliderOptionST("Slider_forcedDrainToDeathMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM", configHandler.forcedDrainToDeathMinimum, "{0}")
    AddSliderOptionST("Slider_drainDuration", "$COL_SETTINGSPAGE_DRAINDURATION", configHandler.drainDurationInGameTime)
    AddSliderOptionST("Slider_healthDrainMulti", "$COL_SETTINGSPAGE_HEALTHDRAINMULT", configHandler.healthDrainMult, "{1}")
    AddSliderOptionST("Slider_drainArousalMulti", "$COL_SETTINGSPAGE_DRAINAROUSALMULT", configHandler.drainArousalMult, "{1}")
    AddSliderOptionST("Slider_energyConversionRate", "$COL_SETTINGSPAGE_ENERGYCONVERSIONRATE", configHandler.energyConversionRate, "{1}")
    AddToggleOptionST("Toggle_drainFeedsVampire", "$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE", configHandler.drainFeedsVampire)
EndEvent

State Toggle_Drain
    Event OnSelectST(string state_id)
        drainHandler.draining = !drainHandler.draining
        SetToggleOptionValueST(drainHandler.draining)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINTOGGLE_HELP")
    EndEvent
EndState

State Toggle_DrainToDeath
    Event OnSelectST(string state_id)
        drainHandler.drainingToDeath = !drainHandler.drainingToDeath
        SetToggleOptionValueST(drainHandler.drainingToDeath)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE_HELP")
    EndEvent
EndState

State Toggle_lockDrain
    Event OnSelectST(string state_id)
        configHandler.lockDrainType = !configHandler.lockDrainType
        SetToggleOptionValueST(configHandler.lockDrainType)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_LOCKDRAINTYPETOGGLE_HELP")
    EndEvent
EndState

State Toggle_deadlyWhenTransformed
    Event OnSelectST(string state_id)
        configHandler.deadlyDrainWhenTransformed = !configHandler.deadlyDrainWhenTransformed
        SetToggleOptionValueST(configHandler.deadlyDrainWhenTransformed)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DEADLYDRAINWHILETRANSFORMED_HELP")
    EndEvent
EndState

State Toggle_drainVerbosity
    Event OnSelectST(string state_id)
        configHandler.drainNotificationsEnabled = !configHandler.drainNotificationsEnabled
        SetToggleOptionValueST(configHandler.drainNotificationsEnabled)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINVERBOSITY_HELP")
    EndEvent
EndState

State Slider_forcedDrainMinimum
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.forcedDrainMinimum)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(-1, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.forcedDrainMinimum = value
        SetSliderOptionValueST(configHandler.forcedDrainMinimum,"{0}")
        psq.playerEnergyCurrent = psq.playerEnergyCurrent
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM_HELP")
    EndEvent
EndState

State Slider_forcedDrainToDeathMinimum
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.forcedDrainToDeathMinimum)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(-1, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.forcedDrainToDeathMinimum = value
        SetSliderOptionValueST(configHandler.forcedDrainToDeathMinimum,"{0}")
        psq.playerEnergyCurrent = psq.playerEnergyCurrent
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM_HELP")
    EndEvent
EndState

State Slider_drainDuration
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.drainDurationInGameTime)
        SetSliderDialogDefaultValue(24.0)
        SetSliderDialogInterval(1.0)
        SetSliderDialogRange(1.0, 72.0)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.drainDurationInGameTime = value
        SetSliderOptionValueST(configHandler.drainDurationInGameTime)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINDURATION_HELP")
    EndEvent
EndState

State Slider_healthDrainMulti
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.healthDrainMult)
        SetSliderDialogDefaultValue(0.2)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0.0, 1.0)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.healthDrainMult = value
        SetSliderOptionValueST(configHandler.healthDrainMult,"{1}")
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_HEALTHDRAINMULT_HELP")
    EndEvent
EndState

State Slider_drainArousalMulti
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.drainArousalMult)
        SetSliderDialogDefaultValue(0.1)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0.0, 1.0)
    EndEvent

    Event OnSliderAcceptST(string state_id,float value)
        configHandler.drainArousalMult = value
        SetSliderOptionValueST(configHandler.drainArousalMult,"{1}")
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINAROUSALMULT_HELP")
    EndEvent
EndState

State Slider_maxEnergyBase
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.baseMaxEnergy)
        SetSliderDialogDefaultValue(100)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 1000)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.baseMaxEnergy = value
        psq.ApplyRankedPerks()
        SetSliderOptionValueST(configHandler.baseMaxEnergy)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_MAXENERGYBASE_HELP")
    EndEvent
EndState

State Slider_energyConversionRate
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyConversionRate)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0.0, 1.0)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyConversionRate = value
        psq.ApplyRankedPerks()
        SetSliderOptionValueST(configHandler.energyConversionRate, "{1}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_ENERGYCONVERSIONRATE_HELP")
    EndEvent
EndState

State Toggle_drainFeedsVampire
    Event OnSelectST(string state_id)
        configHandler.drainFeedsVampire = !configHandler.drainFeedsVampire
        SetToggleOptionValueST(configHandler.drainFeedsVampire)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE_HELP")
    EndEvent
EndState