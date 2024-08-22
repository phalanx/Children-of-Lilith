Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

; Single Rank Perk Index Reference
; 0 - Gentle Drainer
; 1 - Energy Weaver
; 2 - Healing Form
; 3 - Safe Transformation
; 4 - Attractive Dremora
; 5 - Slake Thirst
Perk[] Property singleRankPerks Auto
Spell Property infinitePerkSpell Auto
GlobalVariable Property perkPointsAvailable Auto
CoL_ConfigHandler_Script Property  configHandler Auto
CoL_PlayerSuccubusQuestScript Property  CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
String Property outOfPointsMessage = "No succubus perk points available" Auto

Event OnInit()
    RegisterModule("$COL_ADVPAGE_NAME", 60)
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_ADVPAGE_HEADER_POINTS")
    AddTextOptionST("Text_perksAvailable", "$COL_ADVPAGE_AVAILABLEPOINTS", perkPointsAvailable.GetValueInt())
    AddTextOptionST("Text_perkReset", "$COL_ADVPAGE_RESETPERKS", None)
    AddHeaderOption("$COL_ADVPAGE_HEADER_GENERAL")
    AddTextOptionST("Text_perkEfficientFeeder", "$COL_ADVPAGE_PERK_EFFICIENTFEEDER", CoL.efficientFeeder)
    AddTextOptionST("Text_perkEnergyStorage", "$COL_ADVPAGE_PERK_ENERGYSTORAGE", CoL.energyStorage)
    int i = 0
    while i < singleRankPerks.Length
        if !CoL.playerRef.HasPerk(singleRankPerks[i])
            AddToggleOptionST("Toggle_singlePerk___" + i, "$COL_ADVPAGE_PERK_" + i, false)
        else
            AddToggleOptionST("Toggle_singlePerk___" + i, "$COL_ADVPAGE_PERK_" + i, true, OPTION_FLAG_DISABLED)
        endif
        i+=1
    endwhile
    SetCursorPosition(1)
    AddHeaderOption("$COL_ADVPAGE_HEADER_CSF")
    AddToggleOptionST("Toggle_grantCsfPower","$COL_ADVPAGE_GRANTCSFPOWER", configHandler.grantCSFPower )
    AddTextOptionST("Text_fixCSF", "$COL_ADVPAGE_FIXCSF", None)
    AddHeaderOption("$COL_ADVPAGE_HEADER_TRANSFORM")
    i = 0
    while i < CoL.transformBuffs.Length
        AddTextOptionST("Text_RankedPerk___" + i, "$COL_ADVPAGE_RANKEDPERK_" + i, CoL.transformBuffs[i])
        i += 1
    endwhile
EndEvent
    
State Text_perksAvailable
    Event OnSelectST(string state_id)
        perkPointsAvailable.Mod(1)
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_AVAILABLEPOINTS_HELP")
    EndEvent
EndState
State Text_perkReset
    Event OnSelectST(string state_id)
        int i = 0
        while i < singleRankPerks.Length
            if CoL.playerRef.HasPerk(singleRankPerks[i])
                CoL.playerRef.RemovePerk(singleRankPerks[i])
                perkPointsAvailable.Mod(1)
            endif
            i += 1
        endwhile

        int restoredPoints = CoL.efficientFeeder
        CoL.efficientFeeder = 0
        restoredPoints += CoL.energyStorage
        CoL.energyStorage = 0
        i = 0
        while i < CoL.transformBuffs.Length
            restoredPoints += CoL.transformBuffs[i]
            CoL.transformBuffs[i] = 0
            i += 1
        endwhile
        perkPointsAvailable.Mod(restoredPoints)
        CoL.ApplyRankedPerks()
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_RESETPERKS_HELP")
    EndEvent
EndState
State Toggle_singlePerk
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.playerRef.AddPerk(singleRankPerks[state_id as int])
            SetToggleOptionValueST(singleRankPerks[state_id as int])
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_PERK_"+state_id+"_HELP")
    EndEvent
EndState
State Text_rankedPerk
    Event OnSelectST(string state_id)
        int index = state_id as int
        if perkPointsAvailable.GetValue() > 0
            CoL.transformBuffs[index] = CoL.transformBuffs[index] + 1
            SetTextOptionValueST(CoL.transformBuffs[index])
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_RANKEDPERK_"+state_id+"_HELP")
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
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_PERK_EFFICIENTFEEDER_HELP")
    EndEvent
EndState
State Text_perkEnergyStorage
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.energyStorage += 1
            energyHandler.playerEnergyMax += 10
            SetTextOptionValueST(CoL.energyStorage)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_PERK_ENERGYSTORAGE_HELP")
    EndEvent
EndState

State Toggle_grantCsfPower
    Event OnSelectST(string state_id)
        configHandler.grantCSFPower = !configHandler.grantCSFPower
        SetToggleOptionValueST(configHandler.grantCSFPower)
        CoL.UpdateCSFPower()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_GRANTCSFPOWER_HELP")
    EndEvent
EndState
State Text_fixCSF
    Event OnSelectST(string state_id)
        SetOptionFlagsST(OPTION_FLAG_DISABLED, false, "Text_fixCSF")
        CoL.playerRef.RemoveSpell(infinitePerkSpell)
        CoL.playerRef.AddSpell(infinitePerkSpell, false)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_FIXCSF_HELP")
    EndEvent
EndState