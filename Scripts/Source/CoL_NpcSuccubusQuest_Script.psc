Scriptname CoL_NpcSuccubusQuest_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_NPC_DrainHandler_Script Property npcDrainHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto

Actor[] Property succubusList Auto Hidden           ; List of actors that have been turned into a succubus
Spell Property sceneHandler Auto

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        CoL.Log("NPC Quest Initializing")
        GotoState("Running")
    EndEvent
EndState

State Running
    Event OnBeginState()
        Maintenance()
    EndEvent
    
    Function Maintenance()
        CoL.Log("Running NPC Maintenance")
        npcDrainHandler.GoToState("Initialize")
        RegisterForModEvent("CoL_startScene_NPC", "StartSceneNPC")
        RegisterForModEvent("CoL_endSceneNPC", "EndSceneNPC")
        RegisterForModEvent("CoL_GameLoad", "Maintenance")
        configHandler.npcSuccubusEnabled = true
    EndFunction
EndState

State Uninitialize
    Event OnBeginState()
        CoL.Log("Uninitializing NPC Succubus System")
        UnRegisterForModEvent("CoL_startScene_NPC")
        UnRegisterForModEvent("CoL_endSceneNPC")
        UnRegisterForModEvent("CoL_GameLoad")
        configHandler.npcSuccubusEnabled = false
    EndEvent
EndState

Function Maintenance()
EndFunction

Function StartSceneNPC()
    int random = Utility.RandomInt()
    CoL.Log("NPC Scene Start Detected")
    if random < CoL.npcDrainToDeathChance
        npcDrainHandler.GoToState("DrainingToDeath")
        CoL.Log("NPC will Drain to Death")
    else
        npcDrainHandler.GoToState("Draining")
        CoL.Log("NPC will Drain")
    endif
EndFunction

Function RemoveNPC(int index)
    succubusList[index].RemoveSpell(sceneHandler)
    succubusList = PapyrusUtil.RemoveActor(succubusList, succubusList[index])
EndFunction

Function EndSceneNPC()
EndFunction