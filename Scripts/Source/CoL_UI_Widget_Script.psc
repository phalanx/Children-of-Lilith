Scriptname CoL_UI_Widget_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
iWant_Widgets Property iWidgets Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

int energyMeter
int[] lastColor

Function Initialize()
    CoL.Log("Initializing Widgets")
    energyMeter = iWidgets.loadMeter(configHandler.energyMeterXPos, configHandler.energyMeterYPos, True)
    if energyMeter == -1
        CoL.Log("Failed to load energy meter")
        return
    endif
    lastColor = GetColor(0)
    iWidgets.setMeterFillDirection(energyMeter, "both")
    Maintenance()
EndFunction

Function Maintenance()
    UpdateMeter()
    RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
    RegisterForModEvent("CoL_Energy_Updated", "UpdateFill")
EndFunction

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
    Initialize()
EndEvent

Function UpdateMeter()
    CoL.Log("Updating Meter")
    if CoL.isPlayerSuccubus.GetValueInt() != 1
        Uninitialize()
    endif
    MoveEnergyMeter()
    UpdateColor()
    UpdateFill(energyHandler.playerEnergyCurrent, energyHandler.playerEnergyMax)
    ShowMeter()
EndFunction

Function MoveEnergyMeter()
    iWidgets.setPos(energyMeter, configHandler.energyMeterXPos, configHandler.energyMeterYPos)
    iWidgets.setTransparency(energyMeter, configHandler.energyMeterAlpha)
    iWidgets.setZoom(energyMeter, configHandler.energyMeterXScale, configHandler.energyMeterYScale)
EndFunction

Function UpdateFill(float newEnergy, float maxEnergy)
    iWidgets.setMeterPercent(energyMeter, ((newEnergy / maxEnergy) * 100) as int)
EndFunction

; drainCodes
; 0 - Not Draining
; 1 - Draining
; 2 - Draining To Death
Function UpdateColor(int drainCode=-1)
    int[] color = GetColor(drainCode)
    iWidgets.setMeterRGB(energyMeter, color[0], color[1], color[2], color[3], color[4], color[5])
    lastColor = color
EndFunction

int[] Function GetColor(int drainCode=-1)
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
    if drainCode == 0
         return disabledColor
    elseif drainCode == 1
        return drainColor
    elseif drainCode == 2
        return deathColor
    elseif lastColor.Length > 0
        return lastColor
    else
        CoL.Log("Couldn't get widget color")
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
        int i = 100
        while i > 0
            iWidgets.setTransparency(energyMeter, i)
            i -= 1
        endwhile
        iWidgets.setVisible(energyMeter, 0)
    else
        ShowMeter()
    endif
EndEvent

Function Uninitialize()
    CoL.Log("Uninitializing Widgets")
    iWidgets.Destroy(energyMeter)
    UnregisterForModEvent("iWantWidgetsReset")
EndFunction