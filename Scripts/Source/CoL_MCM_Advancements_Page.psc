Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto
CoL_ConfigHandler_Script configHandler
CoL_PlayerSuccubusQuestScript psq

Event OnInit()
    RegisterModule("$COL_ADVANCEMENTPAGE_NAME", 60)
EndEvent

Event OnPageInit()
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    psq = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_ADVANCEMENTPAGE_HEADER_POINTS")
    AddTextOptionST("Text_perksAvailable", "$COL_ADVANCEMENTPAGE_AVAILABLEPOINTS", psq.availablePerkPoints)
    AddTextOptionST("Text_perkReset", "$COL_ADVANCEMENTPAGE_RESETPERKS", None)
    AddHeaderOption("$COL_ADVANCEMENTPAGE_HEADER_GENERAL")
    if !psq.gentleDrainer
        AddToggleOptionST("Toggle_perkGentleDrainer", "$COL_ADVANCEMENTPAGE_GENTLEDRAINER", psq.gentleDrainer)
    else
        AddToggleOptionST("Toggle_perkGentleDrainer", "$COL_ADVANCEMENTPAGE_GENTLEDRAINER", psq.gentleDrainer, OPTION_FLAG_DISABLED)
    endif
    AddTextOptionST("Text_perkEfficientFeeder", "$COL_ADVANCEMENTPAGE_EFFICIENTFEEDER", psq.efficientFeeder)
    AddTextOptionST("Text_perkEnergyStorage", "$COL_ADVANCEMENTPAGE_ENERGYSTORAGE", psq.energyStorage)
    if !psq.energyWeaver
        AddToggleOptionST("Toggle_perkEnergyWeaver", "$COL_ADVANCEMENTPAGE_ENERGYWEAVER", psq.EnergyWeaver)
    else
        AddToggleOptionST("Toggle_perkEnergyWeaver", "$COL_ADVANCEMENTPAGE_ENERGYWEAVER", psq.energyWeaver, OPTION_FLAG_DISABLED)
    endif
    if !psq.healingForm
        AddToggleOptionST("Toggle_perkHealingForm", "$COL_ADVANCEMENTPAGE_HEALINGFORM", psq.HealingForm)
    else
        AddToggleOptionST("Toggle_perkHealingForm", "$COL_ADVANCEMENTPAGE_HEALINGFORM", psq.HealingForm, OPTION_FLAG_DISABLED)
    endif
    if !psq.safeTransformation
        AddToggleOptionST("Toggle_perkSafeTransformation", "$COL_ADVANCEMENTPAGE_SAFETRANSFORMATION", psq.safeTransformation)
    else
        AddToggleOptionST("Toggle_perkSafeTransformation", "$COL_ADVANCEMENTPAGE_SAFETRANSFORMATION", psq.safeTransformation, OPTION_FLAG_DISABLED)
    endif
    if !psq.slakeThirst
        AddToggleOptionST("Toggle_perkSlakeThirst", "$COL_ADVANCEMENTPAGE_SLAKETHIRST", psq.slakeThirst)
    else
        AddToggleOptionST("Toggle_perkSlakeThirst", "$COL_ADVANCEMENTPAGE_SLAKETHIRST", psq.slakeThirst, OPTION_FLAG_DISABLED)
    endif
EndEvent
    
State Text_perksAvailable
    Event OnSelectST(string state_id)
        psq.availablePerkPoints += 1
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_AVAILABLEPOINTS_HELP")
    EndEvent
EndState

State Text_perkReset
    Event OnSelectST(string state_id)
        if psq.gentleDrainer
            psq.gentleDrainer = false
            psq.availablePerkPoints += 1
        endif
        if psq.efficientFeeder > 0
            int i = 0
            while i < psq.efficientFeeder
                psq.availablePerkPoints += 1
                psq.efficientFeeder -= 1
            endwhile
        endif
        if psq.energyStorage > 0
            int i = 0
            while i < psq.energyStorage
                psq.availablePerkPoints += 1
                psq.energyStorage -= 1
                psq.playerEnergyMax -= 10
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
        if psq.availablePerkPoints > 0
            psq.gentleDrainer = !psq.gentleDrainer
            SetToggleOptionValueST(psq.gentleDrainer)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.efficientFeeder += 1
            SetTextOptionValueST(psq.efficientFeeder)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.energyStorage += 1
            psq.playerEnergyMax += 10
            SetTextOptionValueST(psq.energyStorage)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.energyWeaver = !psq.energyWeaver
            SetToggleOptionValueST(psq.energyWeaver)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.healingForm = !psq.healingForm
            SetToggleOptionValueST(psq.healingForm)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.safeTransformation = !psq.safeTransformation
            SetToggleOptionValueST(psq.safeTransformation)
            psq.availablePerkPoints -= 1
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
        if psq.availablePerkPoints > 0
            psq.slakeThirst = !psq.slakeThirst
            SetToggleOptionValueST(psq.slakeThirst)
            psq.availablePerkPoints -= 1
            ForcePageReset()
        else
            Debug.MessageBox("$COL_ADVANCEMENTPAGE_OUTOFPOINTS")
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVANCEMENTPAGE_SLAKETHIRST_HELP")
    EndEvent
EndState