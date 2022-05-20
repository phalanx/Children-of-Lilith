Scriptname CoL_UI_Widget_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
iWant_Widgets Property iWidgets Auto

int energyMeter
int Property energyMeterXPos = 640 Auto Hidden
int Property energyMeterYPos = 700 Auto Hidden
int Property energyMeterXScale = 70 Auto Hidden
int Property energyMeterYScale = 70 Auto Hidden

State Initialize
    Event OnBeginState()
        Debug.Trace("[CoL] Initializing Widgets")
        energyMeter = iWidgets.loadMeter(energyMeterXPos, energyMeterYPos, True)
        iWidgets.setZoom(energyMeter, energyMeterXScale, energyMeterYScale)
        iWidgets.setMeterFillDirection(energyMeter, "both")
        iWidgets.setMeterRGB(energyMeter, 255, 207, 242, 255, 157, 227)
        if energyMeter == -1
            Debug.Trace("[CoL] Failed to load energy meter")
            GoToState("")
        else
            GoToState("UpdateMeter")
        endif
    EndEvent
EndState

State Running
    Event OnBeginState()
        RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
    EndEvent

    Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
        GoToState("Initialize") 
    EndEvent
EndState

State UpdateMeter
    Event OnBeginState()
        iWidgets.setMeterPercent(energyMeter, ((CoL.playerEnergyCurrent / CoL.playerEnergyMax) * 100) as int)
        GoToState("Running")
    EndEvent
EndState

State MoveEnergyMeter
    Event OnBeginState()
        iWidgets.setPos(energyMeter, energyMeterXPos, energyMeterYPos)
        iWidgets.setZoom(energyMeter, energyMeterXScale, energyMeterYScale)
    EndEvent
EndState

; Empty Functions for Empty State
Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
EndEvent