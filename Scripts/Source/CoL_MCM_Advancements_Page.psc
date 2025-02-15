Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

; Single Rank Perk Index Reference
; 0 - Gentle Drainer
; 1 - Energy Weaver
; 2 - Healing Form
; 3 - Safe Transformation
; 4 - Attractive Dremora
; 5 - Slake Thirst
Perk[] Property singleRankPerks Auto

; Path of Dominance Perks
    Perk Property CombatFeedingPerk Auto
    Perk[] Property ReinforcedBody Auto
    Perk[] Property DiamondSkin Auto
    Perk[] Property DominatingStrength Auto
    Perk[] Property DeadlyRevelry Auto
    Perk[] Property MorbidRecovery Auto
    Perk Property EssensceExtraction Auto

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
        
        if !CoL.playerRef.HasPerk(CombatFeedingPerk)
            AddToggleOptionST("Toggle_molagPerk___CombatFeeding", CombatFeedingPerk.GetName(), false)
        else
            AddToggleOptionST("Toggle_molagPerk___CombatFeeding", CombatFeedingPerk.GetName(), true, OPTION_FLAG_DISABLED)
        endif
        printPerkArray(ReinforcedBody,"ReinforcedBody",CombatFeedingPerk)
        printPerkArray(DiamondSkin,"DiamondSkin",ReinforcedBody[0])
        printPerkArray(DominatingStrength,"DomStrength",ReinforcedBody[0])
        printPerkArray(DeadlyRevelry,"DeadlyRevelry",CombatFeedingPerk)
        printPerkArray(MorbidRecovery,"MorbidRecovery",CombatFeedingPerk)
        if !CoL.playerRef.HasPerk(EssensceExtraction)
            AddToggleOptionST("Toggle_molagPerk___EssensceExtraction", EssensceExtraction.GetName(), false)
        else
            AddToggleOptionST("Toggle_molagPerk___EssensceExtraction", EssensceExtraction.GetName(), true, OPTION_FLAG_DISABLED)
        endif
    
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

Function printPerkArray(Perk[] perkArray, string stateName, Perk requiredPerk=None)
    int i = 0
    while i < perkArray.Length
        int previousIndex = i - 1
        string perkName = perkArray[i].GetName() + " " + (i + 1)
        if requiredPerk != None && !CoL.playerRef.HasPerk(requiredPerk)
            AddToggleOptionST("Toggle_"+stateName+"___"+ i, perkName, false, OPTION_FLAG_DISABLED)
        elseif CoL.playerRef.HasPerk(perkArray[i])
            AddToggleOptionST("Toggle_"+stateName+"___"+ i, perkName, true, OPTION_FLAG_DISABLED)
        elseif i == 0 || CoL.playerRef.HasPerk(perkArray[previousIndex])
            AddToggleOptionST("Toggle_"+stateName+"___"+ i, perkName, false)
        else
            AddToggleOptionST("Toggle_"+stateName+"___"+ i, perkName, false, OPTION_FLAG_DISABLED)
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

        restoredPoints += resetPerkArray(singleRankPerks)
        restoredPoints += resetPerkArray(ReinforcedBody)
        restoredPoints += resetPerkArray(DiamondSkin)
        restoredPoints += resetPerkArray(DominatingStrength)
        restoredPoints += resetPerkArray(DeadlyRevelry)
        
        int i = 0
        while i < CoL.transformBuffs.Length
            restoredPoints += CoL.transformBuffs[i]
            CoL.transformBuffs[i] = 0
            i += 1
        endwhile

        if CoL.playerRef.HasPerk(CombatFeedingPerk)
            CoL.playerRef.RemovePerk(CombatFeedingPerk)
            restoredPoints += 1
        endif

        perkPointsAvailable.Mod(restoredPoints)
        CoL.ApplyRankedPerks()
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_RESETPERKS_HELP")
    EndEvent
EndState

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

State Toggle_molagPerk
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            if state_id == "CombatFeeding"
                CoL.playerRef.AddPerk(CombatFeedingPerk)
            elseif state_id == "EssenceExtraction"
                CoL.playerRef.AddPerk(EssensceExtraction)
            endif
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        if state_id == "CombatFeeding"
            SetInfoText("$COL_PERK_MOLAG_" + state_id + "_HELP")
        endif
    EndEvent
EndState
State Toggle_ReinforcedBody
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            CoL.playerRef.AddPerk(ReinforcedBody[state_id as int])
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_RB_HELP" + state_id)
    EndEvent
EndState
State Toggle_DiamondSkin
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            CoL.playerRef.AddPerk(DiamondSkin[state_id as int])
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DS_HELP" + state_id)
    EndEvent
EndState
State Toggle_DomStrength
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            CoL.playerRef.AddPerk(DominatingStrength[state_id as int])
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DST_HELP" + state_id)
    EndEvent
EndState
State Toggle_DeadlyRevelry
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            CoL.playerRef.AddPerk(DeadlyRevelry[state_id as int])
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DEADLYREV_HELP" + state_id)
    EndEvent
EndState
State Toggle_MorbidRecovery
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            perkPointsAvailable.Mod(-1)
            CoL.playerRef.AddPerk(MorbidRecovery[state_id as int])
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_PERK_MOLAG_DEADLYREV_HELP" + state_id)
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