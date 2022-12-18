Scriptname CoL_Mechanic_Make_NPC_Succubus_Script extends ObjectReference

import PapyrusUtil
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Actor newSuccubus = akNewContainer as Actor
    Actor oldSuccubus = akOldContainer as Actor

    if oldSuccubus != None && oldSuccubus != CoL.playerRef && CoL.succubusList.Find(oldSuccubus) != -1
        CoL.Log("Succubus Being Removed")
        CoL.succubusList = RemoveActor(CoL.succubusList, oldSuccubus)
        oldSuccubus.RemoveSpell(CoL.sceneHandlerSpell)
    endif

    if  newSuccubus != None && newSuccubus != CoL.playerRef && CoL.succubusList.Find(newSuccubus) == -1
        CoL.Log("New Succubus Being Created")
        newSuccubus.AddSpell(CoL.sceneHandlerSpell)
        if CoL.isPlayerSuccubus.GetValueInt() == 0
            CoL.npcDrainHandler.GoToState("Initialize")
        endif
        CoL.succubusList = PushActor(CoL.succubusList, newSuccubus)
    endif
EndEvent
