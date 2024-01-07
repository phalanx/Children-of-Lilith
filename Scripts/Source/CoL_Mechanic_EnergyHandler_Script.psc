Scriptname CoL_Mechanic_EnergyHandler_Script extends Quest

CoL_ConfigHandler_Script Property configHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

float playerEnergyCurrent_var = 50.0
float Property playerEnergyCurrent Hidden
    float Function Get()
        return playerEnergyCurrent_var
    EndFunction
    Function Set(float newVal)
        if newVal > playerEnergyMax
            newVal = playerEnergyMax as float
        elseif newVal < 0
            newVal = 0
        endif
        playerEnergyCurrent_var = newVal
        Log("Player Energy is now " + playerEnergyCurrent)
        int energyUpdateEvent = ModEvent.Create("CoL_Energy_Updated")
        if (energyUpdateEvent)
            ModEvent.PushFloat(energyUpdateEvent, playerEnergyCurrent_var)
            ModEvent.PushFloat(energyUpdateEvent, playerEnergyMax)
            ModEvent.Send(energyUpdateEvent)
        endif
        if configHandler.tattooFade
            CoL.UpdateTattoo()
        endif
    EndFunction
EndProperty
float playerEnergyMax_var = 100.0
float Property playerEnergyMax Hidden
    float Function Get()
        return playerEnergyMax_var
    EndFunction
    Function Set(float newVal)
        if newVal > 0.0
            playerEnergyMax_var = newVal
        endif
        if playerEnergyCurrent > playerEnergyMax_var
            playerEnergyCurrent = playerEnergyMax_var
        endif
        int energyUpdateEvent = ModEvent.Create("CoL_Energy_Updated")
        if (energyUpdateEvent)
            ModEvent.PushFloat(energyUpdateEvent, playerEnergyCurrent_var)
            ModEvent.PushFloat(energyUpdateEvent, playerEnergyMax)
            ModEvent.Send(energyUpdateEvent)
        endif
    EndFunction
EndProperty

Function Log(string msg)
    CoL.Log("Energy Handler - " + msg)
EndFunction