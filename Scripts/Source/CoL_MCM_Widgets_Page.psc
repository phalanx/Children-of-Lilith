Scriptname CoL_MCM_Widgets_Page extends nl_mcm_module

CoL_ConfigHandler_Script Property configHandler Auto
CoL_UI_Widget_Script Property widgetHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

bool meterBarChanged = false
string[] fillDirOptions

Event OnInit()
    RegisterModule("$COL_WIDGETSPAGE_NAME", 50)
EndEvent

Event OnPageDraw()
    fillDirOptions = new string[3]
    fillDirOptions[0] = "$COL_WIDGETSPAGE_ENERGYMETER_FILLDIR_0"
    fillDirOptions[1] = "$COL_WIDGETSPAGE_ENERGYMETER_FILLDIR_1"
    fillDirOptions[2] = "$COL_WIDGETSPAGE_ENERGYMETER_FILLDIR_2"
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddSliderOptionST("Slider_energyMeterXPos", "$COL_WIDGETSPAGE_ENERGYMETER_XPOS", configHandler.energyMeterXPos)
    AddSliderOptionST("Slider_energyMeterYPos", "$COL_WIDGETSPAGE_ENERGYMETER_YPOS", configHandler.energyMeterYPos)
    AddSliderOptionST("Slider_energyMeterXScale", "$COL_WIDGETSPAGE_ENERGYMETER_XSCALE", configHandler.energyMeterXScale)
    AddSliderOptionST("Slider_energyMeterYScale", "$COL_WIDGETSPAGE_ENERGYMETER_YSCALE", configHandler.energyMeterYScale)
    AddSliderOptionST("Slider_energyMeterAlpha", "$COL_WIDGETSPAGE_ENERGYMETER_ALPHA", configHandler.energyMeterAlpha)
    AddToggleOptionST("Toggle_energyMeterAutoHide", "$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDE", configHandler.autoFade)
    AddSliderOptionST("Slider_energyMeterAutoHideTime", "$COL_WIDGETSPAGE_ENERGYMETER_AUTOHIDETIME", configHandler.autoFadeTime)
    AddMenuOptionST("Menu_meterFillDirection", "$COL_WIDGETSPAGE_ENERGYMETER_FILLDIR", fillDirOptions[configHandler.meterFillDirection])
EndEvent

Event OnConfigClose()
    if meterBarChanged
        widgetHandler.UpdateMeter()
        meterBarChanged = false
    endif
EndEvent

State Slider_energyMeterXPos
    Event OnSliderOpenST(string state_id)
        SetSliderDialog(configHandler.energyMeterXPos, 0, 1279, 1, 640)
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
        SetSliderDialog(configHandler.energyMeterYPos, 0, 719, 1, 700)
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
        SetSliderDialog(configHandler.energyMeterXScale, 0, 200, 1, 70)
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
        SetSliderDialog(configHandler.energyMeterYScale, 0, 200, 1, 70)
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
        SetSliderDialog(configHandler.energyMeterAlpha, 0, 100, 1, 100)
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
        SetSliderDialog(configHandler.autoFadeTime, 0, 30, 1, 10)
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

State Menu_meterFillDirection
    Event OnMenuOpenST(string state_id)
        SetMenuDialog(fillDirOptions, configHandler.meterFillDirection)
    EndEvent
    Event OnMenuAcceptST(string state_id, int newVal)
        configHandler.meterFillDirection = newVal
        SetMenuOptionValueST(fillDirOptions[newVal])
        meterBarChanged = true
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_WIDGETSPAGE_ENERGYMETER_FILLDIR_HELP")
    EndEvent
EndState