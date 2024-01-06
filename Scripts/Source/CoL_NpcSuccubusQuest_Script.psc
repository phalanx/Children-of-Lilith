Scriptname CoL_NpcSuccubusQuest_Script extends Quest  

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_NPC_DrainHandler_Script Property npcDrainHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto

Actor[] Property succubusList Auto Hidden           ; List of actors that have been turned into a succubus
Spell[] Property sceneHandlerSpells Auto

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
        RegisterForModEvent("CoL_endScene_NPC", "EndSceneNPC")
        RegisterForModEvent("CoL_GameLoad", "Maintenance")
    EndFunction
EndState

State Uninitialize
    Event OnBeginState()
        CoL.Log("Uninitializing NPC Succubus System")
        UnRegisterForModEvent("CoL_startScene_NPC")
        UnRegisterForModEvent("CoL_endScene_NPC")
        UnRegisterForModEvent("CoL_GameLoad")
    EndEvent
EndState

Function Maintenance()
EndFunction

Function Log(string msg)
    CoL.Log("NPC Succubus Quest - " + msg)
EndFunction

Function StartSceneNPC(Form drainerForm)
    Log("Scene Start Detected")
    int jDrainMap = JFormMap.object()
    JFormDB.setObj(drainerForm, ".ChildrenOfLilith.drainees", jDrainMap)
EndFunction

Function RemoveNPC(int index)
    int i = 0
    while i < sceneHandlerSpells.Length
        succubusList[index].RemoveSpell(sceneHandlerSpells[i])
        i += 1
    endwhile
    succubusList = PapyrusUtil.RemoveActor(succubusList, succubusList[index])
EndFunction

Function EndSceneNPC(Form drainerForm)
    Utility.Wait(0.5) ; Ensure drain has finished
    Log("Scene End Detected")
    JFormDB.setObj(drainerForm, ".ChildrenOfLilith.drainees", 0)
EndFunction