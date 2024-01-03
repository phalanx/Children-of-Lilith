Scriptname CoL_MCM_Hotkeys_Page extends nl_mcm_module

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto

Event OnInit()
    RegisterModule("$COL_HOTKEYSPAGE_NAME", 40)
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    int i = 0
    while i < configHandler.hotkeys.Length
        AddKeyMapOptionST("CoLKey___"+i, "$COL_HOTKEYSPAGE_"+i, configHandler.hotkeys[i])
        i += 1
    endwhile
EndEvent

State CoLKey
    event OnKeyMapChangeST(string state_id, int keyCode)
        if keyCode == 1
            keyCode = -1
        endif
        configHandler.hotkeys[state_id as int] = keyCode
        SetKeyMapOptionValueST(keyCode, false, "CoLKey___" + state_id)
        configHandler.SendConfigUpdateEvent()
    endEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_HOTKEYSPAGE_"+state_id+"_HELP")
    EndEvent
EndState