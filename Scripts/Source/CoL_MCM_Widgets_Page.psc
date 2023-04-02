Scriptname CoL_MCM_Widgets_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
CoL_ConfigHandler_Script configHandler
CoL_UI_Widget_Script widgetHandler

bool meterBarChanged = false

Event OnInit()
    RegisterModule("$COL_WIDGETSPAGE_NAME", 50)
EndEvent

Event OnPageInit()
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    widgetHandler = playerSuccubusQuest as CoL_UI_Widget_Script
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddSliderOptionST("Slider_energyMeterXPos", "$COL_WIDGETSPAGE_ENERGYMETER_XPOS", configHandler.energyMeterXPos)
    AddSliderOptionST("Slider_energyMeterYPos", "$COL_WIDGETSPAGE_ENERGYMETER_YPOS", configHandler.energyMeterYPos)
    AddSliderOptionST("Slider_energyMeterXScale", "$COL_WIDGETSPAGE_ENERGYMETER_XSCALE", configHandler.energyMeterXScale)
    AddSliderOptionST("Slider_energyMeterYScale", "$COL_WIDGETSPAGE_ENERGYMETER_YSCALE", configHandler.energyMeterYScale)
    AddSliderOptionST("Slider_energyMeterAlpha", "$COL_WIDGETSPAGE_ENERGYMETER_ALPHA", configHandler.energyMeterAlpha)
    AddToggleOptionST("Toggle_energyMeterAutoHide", "$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDE", configHandler.autoFade)
    AddSliderOptionST("Slider_energyMeterAutoHideTime", "$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDETIME", configHandler.autoFadeTime)
EndEvent

Event OnConfigClose()
    if meterBarChanged
        widgetHandler.UpdateMeter()
        meterBarChanged = false
    endif
EndEvent

State Slider_energyMeterXPos
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyMeterXPos)
        SetSliderDialogDefaultValue(640)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 1279)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyMeterXPos = value as int
        SetSliderOptionValueST(configHandler.energyMeterXPos)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_XPOS_HELP")
    EndEvent
EndState

State Slider_energyMeterYPos
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyMeterYPos)
        SetSliderDialogDefaultValue(700)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 719)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyMeterYPos = value as int
        SetSliderOptionValueST(configHandler.energyMeterYPos)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_YPOS_HELP")
    EndEvent
EndState

State Slider_energyMeterXScale
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyMeterXScale)
        SetSliderDialogDefaultValue(70)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 200)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyMeterXScale = value as int
        SetSliderOptionValueST(configHandler.energyMeterXScale)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_XSCALE_HELP")
    EndEvent
EndState

State Slider_energyMeterYScale
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyMeterYScale)
        SetSliderDialogDefaultValue(70)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 200)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyMeterYScale = value as int
        SetSliderOptionValueST(configHandler.energyMeterYScale)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_YSCALE_HELP")
    EndEvent
EndState

State Slider_energyMeterAlpha
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.energyMeterAlpha)
        SetSliderDialogDefaultValue(100)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 100)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.energyMeterAlpha = value as int
        SetSliderOptionValueST(configHandler.energyMeterAlpha)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_ALPHA_HELP")
    EndEvent
EndState

State Toggle_energyMeterAutoHide
    Event OnSelectST(string state_id)
        configHandler.autoFade = !configHandler.autoFade
        SetToggleOptionValueST(configHandler.autoFade)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDE")
    EndEvent
EndState

State Slider_energyMeterAutoHideTime
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(configHandler.autoFadeTime)
        SetSliderDialogDefaultValue(10)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 30)
    EndEvent

    Event OnSliderAcceptST(string state_id, float value)
        configHandler.autoFadeTime = value as int
        SetSliderOptionValueST(configHandler.autoFadeTime)
        meterBarChanged = true
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDETIME_HELP")
    EndEvent
EndState