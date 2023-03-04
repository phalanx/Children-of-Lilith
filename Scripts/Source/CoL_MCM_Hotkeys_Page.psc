Scriptname CoL_MCM_Hotkeys_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
CoL_PlayerSuccubusQuestScript psq
CoL_ConfigHandler_Script configHandler

Event OnInit()
    RegisterModule("$COL_HOTKEYSPAGE_NAME", 40)
EndEvent

Event OnPageInit()
    psq = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddKeyMapOptionST("CoLKey___drain", "$COL_HOTKEYSPAGE_TOGGLEDRAIN", configHandler.toggleDrainHotkey)
    AddKeyMapOptionST("CoLKey___drainToDeath", "$COL_HOTKEYSPAGE_TOGGLEDRAINTODEATH", configHandler.toggleDrainToDeathHotkey)
    AddKeyMapOptionST("CoLKey___transform", "$COL_HOTKEYSPAGE_TRANSFORM", configHandler.transformHotkey)
    AddKeyMapOptionST("CoLKey___temptation", "$COL_HOTKEYSPAGE_TEMPTATION", configHandler.temptationHotkey)
EndEvent

State CoLKey
    event OnKeyMapChangeST(string state_id, int keyCode)
        if keyCode == 1
            keyCode = -1
        endif
        if state_id == "drain"
            configHandler.toggleDrainHotkey = keyCode
        elseif state_id == "drainToDeath"
            configHandler.toggleDrainToDeathHotkey = keyCode
        elseif state_id == "transform"
            configHandler.transformHotkey = keyCode
        elseif state_id == "temptation"
            configHandler.temptationHotkey = keyCode
        endif
        SetKeyMapOptionValueST(keyCode, false, "CoLKey___" + state_id)
        psq.UnregisterForHotkeys()
        psq.RegisterForHotkeys()
    endEvent
EndState