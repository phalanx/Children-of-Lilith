Scriptname CoL_Mechanic_Arousal_Transform extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto

; Transform on Toys OverSexed Event
; Register for RegisterForModEvent("OSLA_ActorArousalUpdated", "OnActorArousalUpdated")
; Transform on High Ostim Arousal
; Transform on High Sexlab Arousal

bool slarActive
bool oarousedActive
bool toysActive

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        Maintenance()
    EndEvent
EndState

State Polling
    Event OnBeginState()
        RegisterForSingleUpdate(30)
    EndEvent

    Event OnUpdate()
        float averageArousal = 0
        int i = 0
        if oarousedActive
            averageArousal += CoL.OAroused.GetArousal(CoL.playerRef)
            i += 1
        endif
        if slarActive
            averageArousal += CoL.SLAR.GetActorArousal(CoL.playerRef)
            i += 1
        endif
        if toysActive
            averageArousal += ToysGlobal.GetRousing()
            i += 1
        endif

        CoL.Log("Total arousal: " + averageArousal)
        
        if i > 0
            averageArousal = averageArousal / i
        else
            averageArousal = 0
        endif

        CoL.Log("Average arousal: " + averageArousal)
        CoL.Log("Upper Threshold: " + CoL.transformArousalUpperThreshold)
        CoL.Log("Lower Threshold: " + CoL.transformArousalLowerThreshold)

        if ((CoL.transformArousalUpperThreshold != 0 && averageArousal >= CoL.transformArousalUpperThreshold) || ( CoL.transformArousalLowerThreshold != 0 && averageArousal < CoL.transformArousalLowerThreshold ))
            forceTransform()
        elseif ((CoL.transformArousalUpperThreshold == 0 || averageArousal <= CoL.transformArousalUpperThreshold) && (CoL.transformArousalLowerThreshold == 0 || averageArousal > CoL.transformArousalLowerThreshold))
            forceUntransform()
        endif

        RegisterForSingleUpdate(30)
    EndEvent

    Event OnEndState()
        UnregisterForUpdate()
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        UnregisterForModEvent("CoL_GameLoad")
        if CoL.isTransformed
            CoL.lockTransform = false
        endif
    EndEvent

    Function Maintenance()
        UnregisterForModEvent("CoL_GameLoad")
        UnregisterForUpdate()
    EndFunction
EndState

Function Maintenance()
    RegisterForModEvent("CoL_GameLoad", "Maintenance")

    toysActive = CoL.Toys.IsInterfaceActive()
    slarActive = CoL.SLAR.IsInterfaceActive()
    oarousedActive = CoL.OAroused.IsInterfaceActive()
    if toysActive || slarActive || oarousedActive
        GoToState("Polling")
    endif

EndFunction

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