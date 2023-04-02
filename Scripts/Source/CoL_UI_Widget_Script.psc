Scriptname CoL_UI_Widget_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
iWant_Widgets Property iWidgets Auto

int energyMeter

Function Initialize()
    CoL.Log("Initializing Widgets")
    energyMeter = iWidgets.loadMeter(configHandler.energyMeterXPos, configHandler.energyMeterYPos, True)
    if energyMeter == -1
        CoL.Log("Failed to load energy meter")
        return
    endif
    iWidgets.setMeterFillDirection(energyMeter, "both")
    Maintenance()
EndFunction

Function Maintenance()
    UpdateMeter()
    RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
    RegisterForModEvent("CoL_configUpdated", "Initialize")
EndFunction

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
    Initialize()
EndEvent

Function UpdateMeter()
    MoveEnergyMeter()
    UpdateFill()
    UpdateColor()
    ShowMeter()
EndFunction

Function MoveEnergyMeter()
    iWidgets.setPos(energyMeter, configHandler.energyMeterXPos, configHandler.energyMeterYPos)
    iWidgets.setTransparency(energyMeter, configHandler.energyMeterAlpha)
    iWidgets.setZoom(energyMeter, configHandler.energyMeterXScale, configHandler.energyMeterYScale)
EndFunction

Function UpdateFill()
    iWidgets.setMeterPercent(energyMeter, ((CoL.playerEnergyCurrent / CoL.playerEnergyMax) * 100) as int)
EndFunction

Function UpdateColor()
    int[] color = GetColor()
    iWidgets.setMeterRGB(energyMeter, color[0], color[1], color[2], color[3], color[4], color[5])
EndFunction

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

Function ShowMeter()
    iWidgets.setVisible(energyMeter, 1)
    if configHandler.autofade
        RegisterForSingleUpdate(configHandler.autoFadeTime)
    endif
EndFunction

Event OnUpdate()
    UnRegisterForUpdate()
    if configHandler.autoFade
        iWidgets.setVisible(energyMeter, 0)
    else
        ShowMeter()
    endif
EndEvent

Function Uninitialize()
    CoL.Log("Uninitializing Widgets")
    iWidgets.Destroy(energyMeter)
    UnregisterForModEvent("iWantWidgetsReset")
    UnregisterForModEvent("CoL_configUpdated")
EndFunction