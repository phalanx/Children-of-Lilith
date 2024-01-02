Scriptname CoL_MCM_Advancements_Page extends nl_mcm_module

; Single Rank Perk Index Reference
; 0 - Gentle Drainer
; 1 - Energy Weaver
; 2 - Healing Form
; 3 - Safe Transformation
; 4 - Attractive Dremora
; 5 - Slake Thirst
Perk[] Property singleRankPerks Auto
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
            AddToggleOptionST("Toggle_Perk___" + i, "$COL_ADVPAGE_PERK_" + i, false)
        else
            AddToggleOptionST("Toggle_Perk___" + i, "$COL_ADVPAGE_PERK_" + i, true, OPTION_FLAG_DISABLED)
        endif
        i+=1
    endwhile
    SetCursorPosition(1)
    AddHeaderOption("$COL_ADVPAGE_HEADER_CSF")
    AddToggleOptionST("Toggle_grantCsfPower","$COL_ADVPAGE_GRANTCSFPOWER", configHandler.grantCSFPower )
    AddHeaderOption("$COL_ADVPAGE_HEADER_TRANSFORM")
    AddTextOptionST("Text_perkThickSkin", "$COL_ADVPAGE_THICKSKIN", CoL.transformArmor)
    AddTextOptionST("Text_perkSecretPocket", "$COL_ADVPAGE_SECRETPOCKET", CoL.transformCarryWeight)
    AddTextOptionST("Text_perkMasochism", "$COL_ADVPAGE_MASOCHISM", CoL.transformHealth)
    AddTextOptionST("Text_perkEssence", "$COL_ADVPAGE_ESSENCE", CoL.transformMagicka)
    AddTextOptionST("Text_perkDominance", "$COL_ADVPAGE_DOMINANCE", CoL.transformMagicResist)
    AddTextOptionST("Text_perkSadism", "$COL_ADVPAGE_SADISM", CoL.transformMeleeDamage)
    AddTextOptionST("Text_perkEndurance", "$COL_ADVPAGE_ENDURANCE", CoL.transformStamina)
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
        restoredPoints += Col.transformHealth
        CoL.transformHealth = 0
        restoredPoints += CoL.transformStamina
        CoL.transformStamina = 0
        restoredPoints += CoL.transformMagicka
        CoL.transformMagicka = 0
        restoredPoints += CoL.transformCarryWeight
        CoL.transformCarryWeight = 0
        restoredPoints += CoL.transformMeleeDamage
        CoL.transformMeleeDamage = 0
        restoredPoints += CoL.transformArmor
        CoL.transformArmor = 0
        restoredPoints += CoL.transformMagicResist
        CoL.transformMagicResist = 0

        perkPointsAvailable.Mod(restoredPoints)
        CoL.ApplyRankedPerks()
        ForcePageReset()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_RESETPERKS_HELP")
    EndEvent
EndState
State Toggle_Perk
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

State Text_perkThickSkin
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformArmor += 1
            SetTextOptionValueST(CoL.transformArmor)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_THICKSKIN_HELP")
    EndEvent
EndState
State Text_perkSecretPocket
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformCarryWeight += 1
            SetTextOptionValueST(CoL.transformCarryWeight)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_SECRETPOCKET_HELP")
    EndEvent
EndState
State Text_perkMasochism
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformHealth += 1
            SetTextOptionValueST(CoL.transformHealth)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_MASOCHISM_HELP")
    EndEvent
EndState
State Text_perkEssence
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformMagicka += 1
            SetTextOptionValueST(CoL.transformMagicka)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_ESSENCE_HELP")
    EndEvent
EndState
State Text_perkDominance
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformMagicResist += 1
            SetTextOptionValueST(CoL.transformMagicResist)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_DOMINANCE_HELP")
    EndEvent
EndState
State Text_perkSadism
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformMeleeDamage += 1
            SetTextOptionValueST(CoL.transformMeleeDamage)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_SADISM_HELP")
    EndEvent
EndState
State Text_perkEndurance
    Event OnSelectST(string state_id)
        if perkPointsAvailable.GetValue() > 0
            CoL.transformStamina += 1
            SetTextOptionValueST(CoL.transformStamina)
            perkPointsAvailable.Mod(-1)
            ForcePageReset()
        else
            Debug.MessageBox(outOfPointsMessage)
        endif
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$COL_ADVPAGE_ENDURANCE_HELP")
    EndEvent
EndState