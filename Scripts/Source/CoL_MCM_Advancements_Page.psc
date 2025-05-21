Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

; Single Rank Perk Index Reference
; 0 - Gentle Drainer
; 1 - Energy Weaver
; 2 - Healing Form
; 3 - Safe Transformation
; 4 - Attractive Dremora
; 5 - Slake Thirst
Perk[] Property singleRankPerks Auto

; Path of Domination Perks
    Perk Property CombatFeedingPerk Auto
    Perk Property EssenceExtraction Auto
    Perk Property NoEscape Auto
    Perk Property BuiltForCombat Auto
    Perk[] Property ReinforcedBody Auto
    Perk[] Property DiamondSkin Auto
    Perk[] Property DominatingStrength Auto
    Perk[] Property DeadlyRevelry Auto
    Perk[] Property MorbidRecovery Auto
    Perk[] Property TerrifyingForm Auto

Spell Property infinitePerkSpell Auto
GlobalVariable Property perkPointsAvailable Auto
CoL_ConfigHandler_Script Property  configHandler Auto
CoL_PlayerSuccubusQuestScript Property  CoL Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_Interface_CustomSkills_Script Property CustomSkillsInterface Auto
String Property outOfPointsMessage = "No succubus perk points available" Auto

Event OnInit()
    RegisterModule("$COL_ADVPAGE_NAME", 60)
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$COL_ADVPAGE_HEADER_POINTS")
    AddTextOptionST("Text_perksAvailable", "$COL_ADVPAGE_AVAILABLEPOINTS", perkPointsAvailable.GetValueInt())
    AddTextOptionST("Text_perkReset", "$COL_ADVPAGE_RESETPERKS", None)
    AddTextOptionST("Text_perkConverter", "$COL_ADVPAGE_PERK_CONVERTER", None)
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

    ; Path of Domination
        AddHeaderOption("$COL_ADVPAGE_HEADER_MOLAG")
        
        printPerk(CombatFeedingPerk, "Toggle_molagPerk___CombatFeeding")
        printRankedPerk(ReinforcedBody,"Toggle_ReinforcedBody", CombatFeedingPerk)
        printRankedPerk(DiamondSkin,"Toggle_DiamondSkin", ReinforcedBody[0])
        printRankedPerk(DominatingStrength,"Toggle_DomStrength", ReinforcedBody[0])
        printRankedPerk(DeadlyRevelry,"Toggle_DeadlyRevelry", CombatFeedingPerk)
        printRankedPerk(MorbidRecovery,"Toggle_MorbidRecovery", DeadlyRevelry[0])
        printPerk(EssenceExtraction,"Toggle_molagPerk___EssenceExtraction", MorbidRecovery[0])
        printRankedPerk(TerrifyingForm, "Toggle_TerrifyingForm", CombatFeedingPerk)
        printPerk(NoEscape,"Toggle_molagPerk___NoEscape", TerrifyingForm[0])
        printPerk(BuiltForCombat,"Toggle_molagPerk___BuiltForCombat",NoEscape)
    
    SetCursorPosition(1)
    AddHeaderOption("$COL_ADVPAGE_HEADER_CSF")
    if CustomSkillsInterface.IsInterfaceActive()
        AddToggleOptionST("Toggle_grantCsfPower","$COL_ADVPAGE_GRANTCSFPOWER", configHandler.grantCSFPower )
        AddTextOptionST("Text_fixCSF", "$COL_ADVPAGE_FIXCSF", None)
    else
        AddTextOptionST("Text_NoCustomSkills", "$COL_ADVPAGE_NOCSF", None, OPTION_FLAG_DISABLED)
    endif
    AddHeaderOption("$COL_ADVPAGE_HEADER_TRANSFORM")
    i = 0
    while i < CoL.transformBuffs.Length
        AddTextOptionST("Text_RankedPerk___" + i, "$COL_ADVPAGE_RANKEDPERK_" + i, CoL.transformBuffs[i])
        i += 1
    endwhile
EndEvent

Function printPerk(Perk perkToPrint, string stateName, Perk requiredPerk=None)
    string perkName = perkToPrint.GetName()
    if requiredPerk != None && !CoL.playerRef.HasPerk(requiredPerk)
        AddToggleOptionST(stateName, perkName, false, OPTION_FLAG_DISABLED)
    elseif CoL.playerRef.HasPerk(perkToPrint)
        AddToggleOptionST(stateName, perkName, true, OPTION_FLAG_DISABLED)
    else
        AddToggleOptionST(stateName, perkName, false)
    endif
EndFunction

Function printRankedPerk(Perk[] perkArray, string stateName, Perk requiredPerk=None)
    int i = 0
    string perkName
    if requiredPerk != None && !CoL.playerRef.HasPerk(requiredPerk)
        perkName = perkArray[i].GetName() + " " + (i+1) + "/" + perkArray.Length
        AddToggleOptionST(stateName+"___"+ i, perkName, false, OPTION_FLAG_DISABLED)
        return
    endif
    while i < perkArray.Length
        if !CoL.playerRef.HasPerk(perkArray[i])
            perkName = perkArray[i].GetName() + " " + (i+1) + "/" + perkArray.Length
            AddToggleOptionST(stateName+"___"+ i, perkName, false)
            return
        endif
        i += 1
    endWhile
    i -= 1
    AddToggleOptionST(stateName+"___"+ i, perkArray[i].GetName() + " " + (i+1) + "/" + perkArray.Length, true, OPTION_FLAG_DISABLED)
EndFunction

Function printPerkArray(Perk[] perkArray, string stateName, Perk requiredPerk=None)
    int i = 0
    while i < perkArray.Length
        int previousIndex = i - 1
        string perkName = perkArray[i].GetName() + " " + (i + 1)
        if requiredPerk != None && !CoL.playerRef.HasPerk(requiredPerk)
            AddToggleOptionST(stateName+"___"+ i, perkName, false, OPTION_FLAG_DISABLED)
        elseif CoL.playerRef.HasPerk(perkArray[i])
            AddToggleOptionST(stateName+"___"+ i, perkName, true, OPTION_FLAG_DISABLED)
        elseif i == 0 || CoL.playerRef.HasPerk(perkArray[previousIndex])
            AddToggleOptionST(stateName+"___"+ i, perkName, false)
        else
            AddToggleOptionST(stateName+"___"+ i, perkName, false, OPTION_FLAG_DISABLED)
        endif
        i += 1
    endWhile
EndFunction

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
        int restoredPoints = CoL.efficientFeeder
        CoL.efficientFeeder = 0
        restoredPoints += CoL.energyStorage
        CoL.energyStorage = 0

        restoredPoints += resetPerk(CombatFeedingPerk)
        restoredPoints += resetPerk(EssenceExtraction)
        restoredPoints += resetPerk(NoEscape)
        restoredPoints += resetPerk(BuiltForCombat)

        restoredPoints += resetPerkArray(singleRankPerks)
        restoredPoints += resetPerkArray(ReinforcedBody)
        restoredPoints += resetPerkArray(DiamondSkin)
        restoredPoints += resetPerkArray(DominatingStrength)
        restoredPoints += resetPerkArray(DeadlyRevelry)
        restoredPoints += resetPerkArray(MorbidRecovery)
        restoredPoints += resetPerkArray(TerrifyingForm)
        
        int i = 0
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

int Function resetPerk(Perk perkToReset)
    if CoL.playerRef.HasPerk(perkToReset)
        CoL.playerRef.RemovePerk(perkToReset)
        return 1
    endif
    return 0
EndFunction

int Function resetPerkArray(Perk[] perkArray)
    int restoredPoints = 0
    int i = 0
    while i < perkArray.Length
        if CoL.playerRef.HasPerk(perkArray[i])
            CoL.playerRef.RemovePerk(perkArray[i])
            restoredPoints += 1
        endif
        i += 1
    endwhile
    return restoredPoints
EndFunction

Function GivePerk(Perk perkToGive)
    if perkPointsAvailable.GetValue() > 0
        perkPointsAvailable.Mod(-1)
        CoL.playerRef.AddPerk(perkToGive)
        ForcePageReset()
    else
        Debug.MessageBox(outOfPointsMessage)
    endif
EndFunction

State Text_perkConverter
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            Game.AddPerkPoints(1) 
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_PERK_CONVERTER_HELP")
    EndEvent
EndState
State Toggle_singlePerk
    Event OnSelectST(string state_id)
        GivePerk(singleRankPerks[state_id as int])
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

State Toggle_molagPerk
    Event OnSelectST(string state_id)
        if state_id == "CombatFeeding"
            GivePerk(CombatFeedingPerk)
        elseif state_id == "EssenceExtraction"
            GivePerk(EssenceExtraction)
        elseif state_id == "NoEscape"
            GivePerk(NoEscape)
        elseif state_id == "BuiltForCombat"
            GivePerk(BuiltForCombat)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_" + state_id + "_HELP")
    EndEvent
EndState
State Toggle_ReinforcedBody
    Event OnSelectST(string state_id)
        GivePerk(ReinforcedBody[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_RB_HELP" + state_id)
    EndEvent
EndState
State Toggle_DiamondSkin
    Event OnSelectST(string state_id)
        GivePerk(DiamondSkin[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DS_HELP" + state_id)
    EndEvent
EndState
State Toggle_DomStrength
    Event OnSelectST(string state_id)
        GivePerk(DominatingStrength[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DST_HELP" + state_id)
    EndEvent
EndState
State Toggle_DeadlyRevelry
    Event OnSelectST(string state_id)
        GivePerk(DeadlyRevelry[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DEADLYREV_HELP" + state_id)
    EndEvent
EndState
State Toggle_MorbidRecovery
    Event OnSelectST(string state_id)
        GivePerk(MorbidRecovery[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_MORBIDRECOVERY_HELP" + state_id)
    EndEvent
EndState
State Toggle_TerrifyingForm
    Event OnSelectST(string state_id)
        GivePerk(TerrifyingForm[state_id as int])
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_TERRIFYINGFORM_HELP" + state_id)
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