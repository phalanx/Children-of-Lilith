Scriptname CoL_MCM_Status_Page extends nl_mcm_module

GlobalVariable Property isPlayerSuccubus Auto
Quest Property npcSuccubusQuest Auto

bool profilingEnabled = false

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_ConfigHandler_Script Property configHandler Auto
CoL_NpcSuccubusQuest_Script Property npcQuest Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto

Event OnInit()
    RegisterModule("$COL_STATUSPAGE_NAME", 10)
EndEvent

Event OnPageInit()
    SetModName("$COL_MODNAME")
    SetPersistentMCMPreset("persistence/CoL_Settings")
EndEvent

int Function SaveData()
    return configHandler.SaveConfig()
EndFunction

Function LoadData(int jObj)
    configHandler.LoadConfig(jObj)
EndFunction

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    if isPlayerSuccubus.GetValue() as int == 1
        AddHeaderOption("$COL_STATUSPAGE_HEADER_ONE")
        AddTextOptionST("Text_CurrentLevel", "$COL_STATUSPAGE_CURRENTLEVEL", levelHandler.playerSuccubusLevel.GetValue() as int, OPTION_FLAG_DISABLED)
        AddTextOptionST("Text_CurrentXP", "$COL_STATUSPAGE_CURRENTXP", levelHandler.playerSuccubusXP as int, OPTION_FLAG_DISABLED)
        AddTextOptionST("Text_NextLevelXP", "$COL_STATUSPAGE_NEXTLEVELXP", levelHandler.xpForNextLevel, OPTION_FLAG_DISABLED)
        AddTextOptionST("Text_EnergyCurrent", "$COL_STATUSPAGE_ENERGYCURRENT", energyHandler.playerEnergyCurrent as int, OPTION_FLAG_DISABLED)
        AddTextOptionST("Text_MaxEnergy", "$COL_STATUSPAGE_MAXENERGY", energyHandler.playerEnergyMax, OPTION_FLAG_DISABLED)
        AddMenuOptionST("Menu_FollowedPath", "$COL_STATUSPAGE_FOLLOWEDPATH", configHandler.followedPathOptions[configHandler.selectedPath])
    endif
    SetCursorPosition(1)
    AddHeaderOption("$COL_STATUSPAGE_HEADER_TWO")
    if isPlayerSuccubus.GetValue() as int == 1
        AddTextOptionST("Text_BecomeMortal", "$COL_STATUSPAGE_BECOMEMORTAL", None)
        AddTextOptionST("Text_EnergyRefill", "$COL_STATUSPAGE_REFILLENERGY", None)
        AddTextOptionST("Text_LevelUp", "$COL_STATUSPAGE_LEVELUP", None)
        AddToggleOptionST("Toggle_EnergyScaleTest", "$COL_STATUSPAGE_ENERGYSCALETEST", configHandler.EnergyScaleTestEnabled)
    else
        AddTextOptionST("Text_BecomeSuccubus", "$COL_STATUSPAGE_BECOMESUCCUBUS", None)
    endif
    AddToggleOptionST("Toggle_DebugLogging", "$COL_STATUSPAGE_DEBUGLOGGING", configHandler.DebugLogging)

    if npcSuccubusQuest.GetState() != "" && npcSuccubusQuest.GetState() != "Uninitialize"
        AddTextOptionST("Text_DisableNPCSuccubus", "$COL_STATUSPAGE_DISABLENPCSUCCUBUS", None)
        AddHeaderOption("$COL_STATUSPAGE_NPCHEADER")
        LoadNpcSuccubi()
    else
        AddTextOptionST("Text_EnableNPCSuccubus","$COL_STATUSPAGE_ENABLENPCSUCCUBUS", None)
    endif
EndEvent

Function LoadNpcSuccubi()
    int i = 0
    while i < npcQuest.succubusList.Length
        string npcName = npcQuest.succubusList[i].GetActorBase().GetName()
        AddTextOptionST("Text_NPCSuccubus___" + i, npcName, None)
        i += 1
    endwhile
EndFunction

State Menu_FollowedPath
    Event OnMenuOpenST(string state_id)
        SetMenuDialog(configHandler.followedPathOptions, configHandler.selectedPath, 0)
    EndEvent

    Event OnMenuAcceptST(string state_id, int index)
        configHandler.selectedPath = index
        CoL.UpdatePath()
        SetMenuOptionValueST(configHandler.followedPathOptions[index])
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_FOLLOWEDPATH_HELP")
    EndEvent
EndState



State Text_BecomeSuccubus
    Event OnSelectST(string state_id)
        SetTextOptionValueST("$COL_MCM_EXIT")
        SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "Text_BecomeSuccubus")
        CoL.GoToState("Initialize")
        Utility.Wait(0.5)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_BECOMESUCCUBUS_HELP")
    EndEvent
EndState

State Text_BecomeMortal
    Event OnSelectST(string state_id)
        SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "Text_BecomeMortal")
        CoL.GoToState("Uninitialize")
        SetTextOptionValueST("$COL_MCM_EXIT", false, "Text_BecomeMortal")
        Utility.Wait(0.5)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_BECOMEMORTAL_HELP")
    EndEvent
EndState

State Text_EnergyRefill
    Event OnSelectST(string state_id)
        energyHandler.playerEnergyCurrent = energyHandler.playerEnergyMax
        SetTextOptionValueST(energyHandler.playerEnergyCurrent as int, false, "Text_EnergyCurrent")
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_REFILLENERGY_HELP")
    EndEvent
EndState

State Text_LevelUp
    Event OnSelectST(string state_id)
        levelHandler.playerSuccubusXP = levelHandler.xpForNextLevel + 1
        SetTextOptionValueST(levelHandler.playerSuccubusLevel.GetValueInt(), false, "Text_CurrentLevel")
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_LEVELUP_HELP")
    EndEvent
EndState

State Toggle_DebugLogging
    Event OnSelectST(string state_id)
        configHandler.DebugLogging = !configHandler.DebugLogging
        SetToggleOptionValueST(configHandler.DebugLogging)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_DEBUGLOGGING_HELP")
    EndEvent
EndState

State Toggle_EnergyScaleTest
    Event OnSelectST(string state_id)
        configHandler.EnergyScaleTestEnabled = !configHandler.EnergyScaleTestEnabled
        SetToggleOptionValueST(configHandler.EnergyScaleTestEnabled)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_ENERGYSCALETEST_HELP")
    EndEvent
EndState

State Text_EnableNPCSuccubus
    Event OnSelectST(string state_id)
        SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "Text_EnableNPCSuccubus")
        npcQuest.GoToState("Initialize")
        SetTextOptionValueST("$COL_MCM_EXIT")
        Utility.Wait(0.1)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_ENABLENPCSUCCUBUS_HELP")
    EndEvent
EndState

State Text_DisableNPCSuccubus
        Event OnSelectST(string state_id)
            SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "Text_DisableNPCSuccubus")
            npcQuest.GoToState("Uninitialize")
            SetTextOptionValueST("$COL_MCM_EXIT")
            Utility.Wait(0.1)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_STATUSPAGE_DISABLENPCSUCCUBUS_HELP")
        EndEvent
EndState

State Text_NPCSuccubus
    Event OnSelectST(string state_id)
        npcQuest.RemoveNPC(state_id as int)
        ForcePageReset()
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$COL_STATUSPAGE_NPCHELP")
    EndEvent
EndState
