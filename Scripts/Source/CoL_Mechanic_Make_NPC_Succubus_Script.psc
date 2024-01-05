Scriptname CoL_Mechanic_Make_NPC_Succubus_Script extends ObjectReference

import PapyrusUtil
CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_NpcSuccubusQuest_Script Property npcSuccubusQuest Auto
Spell[] Property sceneHandlerSpells Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    Actor newSuccubus = akNewContainer as Actor
    Actor oldSuccubus = akOldContainer as Actor

    if oldSuccubus != None && oldSuccubus != CoL.playerRef && npcSuccubusQuest.succubusList.Find(oldSuccubus) != -1
        CoL.Log("Succubus Being Removed")
        npcSuccubusQuest.succubusList = RemoveActor(npcSuccubusQuest.succubusList, oldSuccubus)
        int i = 0
        while i < sceneHandlerSpells.Length
            oldSuccubus.RemoveSpell(sceneHandlerSpells[i])
            i += 1
        endwhile
    endif

    if  newSuccubus != None && newSuccubus != CoL.playerRef && npcSuccubusQuest.succubusList.Find(newSuccubus) == -1
        CoL.Log("New Succubus Being Created")
        int i = 0
        while i < sceneHandlerSpells.Length
            newSuccubus.AddSpell(sceneHandlerSpells[i])
            i += 1
        endwhile
        npcSuccubusQuest.succubusList = PushActor(npcSuccubusQuest.succubusList, newSuccubus)
    endif
EndEvent
