Scriptname CoL_Mechanic_Make_NPC_Succubus_Script extends ObjectReference

import PapyrusUtil
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Actor newSuccubus = akNewContainer as Actor
    Actor oldSuccubus = akOldContainer as Actor

    if oldSuccubus != None && oldSuccubus != CoL.playerRef && CoL.succubusList.Find(oldSuccubus) != -1
        if CoL.DebugLogging
            Debug.Trace("[CoL] Succubus Being Removed")
        endif
        CoL.succubusList = RemoveActor(CoL.succubusList, oldSuccubus)
        oldSuccubus.RemoveSpell(CoL.sceneHandlerSpell)
    endif

    if  newSuccubus != None && newSuccubus != CoL.playerRef && CoL.succubusList.Find(newSuccubus) == -1
        if CoL.DebugLogging
            Debug.Trace("[CoL] New Succubus Being Created")
        endif
        newSuccubus.AddSpell(CoL.sceneHandlerSpell)
        if CoL.isPlayerSuccubus.GetValueInt() == 0
            CoL.drainHandler.draining = true
            CoL.drainHandler.GoToState("Initialize")
        endif
        CoL.succubusList = PushActor(CoL.succubusList, newSuccubus)
    endif
EndEvent
