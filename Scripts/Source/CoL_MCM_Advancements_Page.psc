Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
Perk Property gentleDrainer Auto
Perk Property energyWeaver Auto
Perk Property healingForm Auto
Perk Property safeTransformation Auto
Perk Property slakeThirst Auto
GlobalVariable Property perkPointsAvailable Auto
CoL_ConfigHandler_Script configHandler
CoL_PlayerSuccubusQuestScript CoL

Event OnInit()
    RegisterModule("$COL_ADVANCEMENTPAGE_NAME", 60)
EndEvent

Event OnPageInit()
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    CoL = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_ADVANCEMENTPAGE_HEADER_POINTS")
    AddTextOptionST("Text_perksAvailable", "$COL_ADVANCEMENTPAGE_AVAILABLEPOINTS", perkPointsAvailable.GetValueInt())
    AddTextOptionST("Text_perkReset", "$COL_ADVANCEMENTPAGE_RESETPERKS", None)
    AddHeaderOption("$COL_ADVANCEMENTPAGE_HEADER_GENERAL")
    if !CoL.playerRef.HasPerk(gentleDrainer)
        AddToggleOptionST("Toggle_perkGentleDrainer", "$COL_ADVANCEMENTPAGE_GENTLEDRAINER", CoL.playerRef.HasPerk(gentleDrainer))
    else
        AddToggleOptionST("Toggle_perkGentleDrainer", "$COL_ADVANCEMENTPAGE_GENTLEDRAINER", CoL.playerRef.HasPerk(gentleDrainer), OPTION_FLAG_DISABLED)
    endif
    AddTextOptionST("Text_perkEfficientFeeder", "$COL_ADVANCEMENTPAGE_EFFICIENTFEEDER", CoL.efficientFeeder)
    AddTextOptionST("Text_perkEnergyStorage", "$COL_ADVANCEMENTPAGE_ENERGYSTORAGE", CoL.energyStorage)
    if !CoL.playerRef.HasPerk(energyWeaver)
        AddToggleOptionST("Toggle_perkEnergyWeaver", "$COL_ADVANCEMENTPAGE_ENERGYWEAVER", CoL.playerRef.HasPerk(energyWeaver))
    else
        AddToggleOptionST("Toggle_perkEnergyWeaver", "$COL_ADVANCEMENTPAGE_ENERGYWEAVER", CoL.playerRef.HasPerk(energyWeaver), OPTION_FLAG_DISABLED)
    endif
    if !CoL.playerRef.HasPerk(healingForm)
        AddToggleOptionST("Toggle_perkHealingForm", "$COL_ADVANCEMENTPAGE_HEALINGFORM", CoL.playerRef.HasPerk(healingForm))
    else
        AddToggleOptionST("Toggle_perkHealingForm", "$COL_ADVANCEMENTPAGE_HEALINGFORM", CoL.playerRef.HasPerk(healingForm), OPTION_FLAG_DISABLED)
    endif
    if !CoL.playerRef.HasPerk(safeTransformation)
        AddToggleOptionST("Toggle_perkSafeTransformation", "$COL_ADVANCEMENTPAGE_SAFETRANSFORMATION", CoL.playerRef.HasPerk(safeTransformation))
    else
        AddToggleOptionST("Toggle_perkSafeTransformation", "$COL_ADVANCEMENTPAGE_SAFETRANSFORMATION", CoL.playerRef.HasPerk(safeTransformation), OPTION_FLAG_DISABLED)
    endif
    if !CoL.playerRef.HasPerk(slakeThirst)
        AddToggleOptionST("Toggle_perkSlakeThirst", "$COL_ADVANCEMENTPAGE_SLAKETHIRST", CoL.playerRef.HasPerk(slakeThirst))
    else
        AddToggleOptionST("Toggle_perkSlakeThirst", "$COL_ADVANCEMENTPAGE_SLAKETHIRST", CoL.playerRef.HasPerk(slakeThirst), OPTION_FLAG_DISABLED)
    endif
    SetCursorPosition(1)
    AddHeaderOption("$COL_ADVANCEMENTPAGE_HEADER_CSF")
    AddToggleOptionST("Toggle_grantCsfPower","$COL_ADVANCEMENTPAGE_GRANTCSFPOWER", configHandler.grantCSFPower )
EndEvent
    
State Text_perksAvailable
    Event OnSelectST(string state_id)
        perkPointsAvailable.Mod(1)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_AVAILABLEPOINTS_HELP")
    EndEvent
EndState

State Text_perkReset
    Event OnSelectST(string state_id)
        if CoL.playerRef.HasPerk(gentleDrainer)
            CoL.playerRef.RemovePerk(gentleDrainer)
            perkPointsAvailable.Mod(1)
        endif
        if CoL.efficientFeeder > 0
            int i = 0
            while i < CoL.efficientFeeder
                perkPointsAvailable.Mod(1)
                CoL.efficientFeeder -= 1
            endwhile
        endif
        if CoL.energyStorage > 0
            int i = 0
            while i < CoL.energyStorage
                perkPointsAvailable.Mod(1)
                CoL.energyStorage -= 1
                CoL.playerEnergyMax -= 10
            endwhile
        endif
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_RESETPERKS_HELP")
    EndEvent
EndState

State Toggle_perkGentleDrainer
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(gentleDrainer)
            SetToggleOptionValueST(CoL.playerRef.HasPerk(gentleDrainer))
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_GENTLEDRAINER_HELP")
    EndEvent
EndState

State Text_perkEfficientFeeder
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.efficientFeeder += 1
            SetTextOptionValueST(CoL.efficientFeeder)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_EFFICIENTFEEDER_HELP")
    EndEvent
EndState

State Text_perkEnergyStorage
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.energyStorage += 1
            CoL.playerEnergyMax += 10
            SetTextOptionValueST(CoL.energyStorage)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_ENERGYSTORAGE")
    EndEvent
EndState

State Toggle_perkEnergyWeaver
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(energyWeaver)
            SetToggleOptionValueST(true)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_ENERGYWEAVER_HELP")
    EndEvent
EndState
State Toggle_perkHealingForm
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(healingForm)
            SetToggleOptionValueST(true)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_HEALINGFORM_HELP")
    EndEvent
EndState
State Toggle_perkSafeTransformation
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(safeTransformation)
            SetToggleOptionValueST(true)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_SAFETRANSFORMATION_HELP")
    EndEvent
EndState
State Toggle_perkSlakeThirst
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(slakeThirst)
            SetToggleOptionValueST(true)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_SLAKETHIRST_HELP")
    EndEvent
EndState

State Toggle_grantCsfPower
    Event OnSelectST(string state_id)
        if configHandler.grantCSFPower
            configHandler.grantCSFPower = false
            CoL.playerRef.RemoveSpell(CoL.showperkMenu)
            SetToggleOptionValueST(false)
        else
            CoL.playerRef.AddSpell(CoL.showperkMenu)
            configHandler.grantCSFPower = true
            SetToggleOptionValueST(true)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_GRANTCSFPOWER_HELP")
    EndEvent
EndState