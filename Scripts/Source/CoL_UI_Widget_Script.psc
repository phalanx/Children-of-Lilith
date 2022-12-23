Scriptname CoL_UI_Widget_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
iWant_Widgets Property iWidgets Auto

int energyMeter
int Property energyMeterAlpha = 100 Auto Hidden
int Property energyMeterXPos = 640 Auto Hidden
int Property energyMeterYPos = 700 Auto Hidden
int Property energyMeterXScale = 70 Auto Hidden
int Property energyMeterYScale = 70 Auto Hidden
bool Property autoFade = false Auto Hidden
int Property autoFadeTime = 5 Auto Hidden

int[] Function GetColor()
    int[] disabledColor = new int[6]
        disabledColor[0] = 255
        disabledColor[1] = 255
        disabledColor[2] = 255
        disabledColor[3] = 255
        disabledColor[4] = 255
        disabledColor[5] = 255
    int[] drainColor = new int[6]
        drainColor[0] = 255
        drainColor[1] = 207
        drainColor[2] = 242
        drainColor[3] = 255
        drainColor[4] = 157
        drainColor[5] = 227
    int[] deathColor=  new int[6]
        deathColor[0] = 255
        deathColor[1] = 102
        deathColor[2] = 102
        deathColor[3] = 255
        deathColor[4] = 51
        deathColor[5] = 51
    if CoL.drainHandler.GetState() == "Draining"
        return drainColor
    elseif CoL.drainHandler.GetState() == "DrainingToDeath"
        return deathColor
    else
        return disabledColor
    endif
endFunction

Function UpdateColor()
    int[] color = GetColor()
    iWidgets.setMeterRGB(energyMeter, color[0], color[1], color[2], color[3], color[4], color[5])
EndFunction

State Initialize
    Event OnBeginState()
        CoL.Log("Initializing Widgets")
        energyMeter = iWidgets.loadMeter(energyMeterXPos, energyMeterYPos, True)
        iWidgets.setZoom(energyMeter, energyMeterXScale, energyMeterYScale)
        iWidgets.setMeterFillDirection(energyMeter, "both")
        int[] color = GetColor()
        iWidgets.setMeterRGB(energyMeter, color[0], color[1], color[2], color[3], color[4], color[5])
        if energyMeter == -1
            Debug.Trace("[CoL] Failed to load energy meter")
            GoToState("")
        else
            GoToState("MoveEnergyMeter")
        endif
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        CoL.Log("Uninitializing Widgets")
        iWidgets.Destroy(energyMeter)
        UnregisterForModEvent("iWantWidgetsReset")
        GoToState("")
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
        UpdateColor()
        iWidgets.setMeterPercent(energyMeter, ((CoL.playerEnergyCurrent / CoL.playerEnergyMax) * 100) as int)
        ShowMeter()
        GoToState("Running")
    EndEvent
EndState

State MoveEnergyMeter
    Event OnBeginState()
        iWidgets.setPos(energyMeter, energyMeterXPos, energyMeterYPos)
        iWidgets.setTransparency(energyMeter, energyMeterAlpha)
        iWidgets.setZoom(energyMeter, energyMeterXScale, energyMeterYScale)
        GoToState("UpdateMeter")
    EndEvent
EndState

Function OnUpdate()
    UnRegisterForUpdate()
    if autoFade
        iWidgets.setVisible(energyMeter, 0)
    else
        ShowMeter()
    endif
EndFunction

Function ShowMeter()
    iWidgets.setVisible(energyMeter, 1)
    if autofade
        RegisterForSingleUpdate(autoFadeTime)
    endif
EndFunction


; Empty Functions for Empty State
Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
EndEvent