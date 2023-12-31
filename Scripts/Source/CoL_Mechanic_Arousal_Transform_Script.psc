Scriptname CoL_Mechanic_Arousal_Transform_Script extends ActiveMagicEffect

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Interface_Arousal_Script Property iArousal Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    RegisterForSingleUpdate(10)
    CoL.Log("Arousal Transform - Started")
EndEvent

Event OnUpdate()
    float averageArousal = iArousal.GetActorArousal(CoL.playerRef)

    CoL.Log("Average arousal: " + averageArousal)
    CoL.Log("Upper Threshold: " + configHandler.transformArousalUpperThreshold)
    CoL.Log("Lower Threshold: " + configHandler.transformArousalLowerThreshold)

    if ((configHandler.transformArousalUpperThreshold != 0 && averageArousal >= configHandler.transformArousalUpperThreshold) || ( configHandler.transformArousalLowerThreshold != 0 && averageArousal < configHandler.transformArousalLowerThreshold ))
        forceTransform()
    elseif ((configHandler.transformArousalUpperThreshold == 0 || averageArousal <= configHandler.transformArousalUpperThreshold) && (configHandler.transformArousalLowerThreshold == 0 || averageArousal > configHandler.transformArousalLowerThreshold))
        forceUntransform()
    endif

    RegisterForSingleUpdate(10)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    CoL.lockTransform = false
    CoL.Log("Arousal Transform - Stopped")
EndEvent

Function forceTransform()
    if CoL.isBusy()
        CoL.Log("Transform triggered but player is busy")
        return
    elseif CoL.isTransformed
        CoL.Log("Transform triggered but player is already transformed")
        return
    endif
    CoL.transformSpell.Cast(Col.playerRef)
    CoL.lockTransform = true
EndFunction

Function forceUntransform()
    if CoL.isBusy()
        CoL.Log("Untransform triggered but player is busy")
        return
    elseif !CoL.isTransformed
        CoL.Log("Untransform triggered but player is already untransformed")
        return
    endif
    CoL.lockTransform = false
    CoL.transformSpell.Cast(Col.playerRef)
EndFunction