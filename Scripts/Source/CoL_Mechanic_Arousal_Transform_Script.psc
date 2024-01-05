Scriptname CoL_Mechanic_Arousal_Transform_Script extends ActiveMagicEffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    RegisterForSingleUpdate(10)
    CoL.Log("Started")
EndEvent

Function Log(string msg)
    CoL.Log("Arousal Transform - " + msg)
EndFunction

Event OnUpdate()
    float averageArousal = iArousal.GetActorArousal(CoL.playerRef)

    Log("Average arousal: " + averageArousal)
    Log("Upper Threshold: " + configHandler.transformArousalUpperThreshold)
    Log("Lower Threshold: " + configHandler.transformArousalLowerThreshold)

    if ((configHandler.transformArousalUpperThreshold != 0 && averageArousal >= configHandler.transformArousalUpperThreshold) || ( configHandler.transformArousalLowerThreshold != 0 && averageArousal < configHandler.transformArousalLowerThreshold ))
        forceTransform()
    elseif ((configHandler.transformArousalUpperThreshold == 0 || averageArousal <= configHandler.transformArousalUpperThreshold) && (configHandler.transformArousalLowerThreshold == 0 || averageArousal > configHandler.transformArousalLowerThreshold))
        forceUntransform()
    endif

    RegisterForSingleUpdate(10)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    CoL.lockTransform = false
    Log("Stopped")
EndEvent

Function forceTransform()
    if CoL.isBusy()
        Log("Transform triggered but player is busy")
        return
    elseif CoL.isTransformed
        Log("Transform triggered but player is already transformed")
        return
    endif
    CoL.transformSpell.Cast(Col.playerRef)
    CoL.lockTransform = true
EndFunction

Function forceUntransform()
    if CoL.isBusy()
        Log("Untransform triggered but player is busy")
        return
    elseif !CoL.isTransformed
        Log("Untransform triggered but player is already untransformed")
        return
    endif
    CoL.lockTransform = false
    CoL.transformSpell.Cast(Col.playerRef)
EndFunction