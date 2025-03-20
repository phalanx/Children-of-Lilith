Scriptname CoL_MCM_Settings_Page extends nl_mcm_module

CoL_ConfigHandler_Script Property configHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_PlayerSuccubusQuestScript Property CoL Auto

Event OnInit()
    RegisterModule("$COL_SETTINGSPAGE_NAME", 20)
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddSliderOptionST("Slider_baseMaxEnergy", "$COL_SETTINGSPAGE_MAXENERGYBASE", configHandler.baseMaxEnergy, "{0}")
    ; Player Drain Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_PLAYERDRAINSETTINGS")
        AddToggleOptionST("Toggle_lockDrain", "$COL_SETTINGSPAGE_LOCKDRAINTYPETOGGLE", configHandler.lockDrainType)
        AddToggleOptionST("Toggle_deadlyWhenTransformed", "$COL_SETTINGSPAGE_DEADLYDRAINWHILETRANSFORMED", configHandler.deadlyDrainWhenTransformed)
        AddToggleOptionST("Toggle_drainVerbosity", "$COL_SETTINGSPAGE_DRAINVERBOSITY", configHandler.drainNotificationsEnabled)
        AddSliderOptionST("Slider_forcedDrainMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM", configHandler.forcedDrainMinimum, "{0}")
        AddSliderOptionST("Slider_forcedDrainToDeathMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM", configHandler.forcedDrainToDeathMinimum, "{0}")
        AddSliderOptionST("Slider_drainDuration", "$COL_SETTINGSPAGE_DRAINDURATION", configHandler.drainDurationInGameTime)
        AddSliderOptionST("Slider_healthDrainMulti", "$COL_SETTINGSPAGE_HEALTHDRAINMULT", configHandler.healthDrainMult, "{2}")
        AddSliderOptionST("Slider_drainArousalMulti", "$COL_SETTINGSPAGE_DRAINAROUSALMULT", configHandler.drainArousalMult, "{1}")
        AddSliderOptionST("Slider_energyConversionRate", "$COL_SETTINGSPAGE_ENERGYCONVERSIONRATE", configHandler.energyConversionRate, "{1}")
        AddSliderOptionST("Slider_minHealthPercent", "$COL_SETTINGSPAGE_MINHEALTHPERCENT", configHandler.minHealthPercent, "{2}")
        AddToggleOptionST("Toggle_drainFeedsVampire", "$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE", configHandler.drainFeedsVampire)
        AddToggleOptionST("Toggle_drainToDeathCrime", "$COL_SETTINGSPAGE_DRAINTODEATHCRIME", configHandler.drainToDeathCrime)
        AddSliderOptionST("Slider_drainToDeathDetectionRange", "$COL_SETTINGSPAGE_CRIMERANGE", configHandler.drainToDeathDetectionRange)
        AddSliderOptionST("Slider_drainToDeathDelay", "$COL_SETTINGSPAGE_DRAINTODEATHDELAY", configHandler.drainToDeathDelay, "{1}")
    ; NPC Drain Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_NPCDRAINSETTINGS")
        int i = 0
        while i <= 4
            AddSliderOptionST("Slider_npcRelationshipDeathChance___" + i, "$COL_SETTINGSPAGE_NPCRELATIONSHIODEATHCHANCE_" + i, configHandler.npcRelationshipDeathChance[i], "{1}")
            i += 1
        endwhile
    ; Tattoo Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_TATTOO")
        AddToggleOptionST("Toggle_tattooFade", "$COL_SETTINGSPAGE_TATTOOFADE", configHandler.tattooFade)
        AddSliderOptionST("Slider_tattooSlot", "$COL_SETTINGSPAGE_TATTOOSLOT", configHandler.tattooSlot)
    ; Levelling Settings
        SetCursorPosition(1)
        AddHeaderOption("$COL_SETTINGSPAGE_LEVELLINGSETTINGS")
        AddSliderOptionST("Slider_xpPerDrain", "$COL_SETTINGSPAGE_XPPERDRAIN", configHandler.xpPerDrain)
        AddSliderOptionST("Slider_xpDrainMult", "$COL_SETTINGSPAGE_XPDRAINMULT", configHandler.xpDrainMult,"{1}")
        AddSliderOptionST("Slider_xpDeathMult", "$COL_SETTINGSPAGE_XPDEATHMULT", configHandler.drainToDeathXPMult)
        AddSliderOptionST("Slider_xpConstant", "$COL_SETTINGSPAGE_XPCONSTANT", configHandler.xpConstant, "{2}")
        AddSliderOptionST("Slider_xpPower", "$COL_SETTINGSPAGE_XPPOWER", configHandler.xpPower, "{2}")
        AddSliderOptionST("Slider_levelsForPerk", "$COL_SETTINGSPAGE_LEVELSFORPERK", configHandler.levelsForPerk)
        AddSliderOptionST("Slider_perksRecieved", "$COL_SETTINGSPAGE_PERKSRECIEVED", configHandler.perkPointsRecieved)
        i = 0
        while i < configHandler.transformRankEffects.Length
            string formatString = "{0}"
            if i == 4
                formatString = "{1}"
            endif
            AddSliderOptionST("Slider_transformRankEffects___"+i, "$COL_SETTINGSPAGE_TRANSFORMRANKEFFECTS_"+i, configHandler.transformRankEffects[i], formatString)
            i += 1
        endwhile
    ; Hunger Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_HUNGER")
        AddToggleOptionST("Toggle_hunger", "$COL_SETTINGSPAGE_HUNGER", configHandler.hungerEnabled)
        AddSliderOptionST("Slider_hungerAmount", "$COL_SETTINGSPAGE_HUNGER_AMOUNT", configHandler.dailyHungerAmount)
        AddToggleOptionST("Toggle_hungerIsPercent", "$COL_SETTINGSPAGE_HUNGERISPERCENT", configHandler.hungerIsPercent)
        AddSliderOptionST("Slider_hungerThreshold", "$COL_SETTINGSPAGE_HUNGERTHRESHOLD", configHandler.hungerThreshold)
        AddToggleOptionST("Toggle_deadlyHunger", "$COL_SETTINGSPAGE_DEADLYHUNGER", configHandler.deadlyHunger)
        AddSliderOptionST("Slider_hungerDamageAmount", "$COL_SETTINGSPAGE_HUNGERDAMAGEAMOUNT", configHandler.hungerDamageAmount)
        AddToggleOptionST("Toggle_hungerArousal", "$COL_SETTINGSPAGE_HUNGERAROUSAL", configHandler.hungerArousalEnabled)
        AddSliderOptionST("Slider_hungerArousalAmount", "$COL_SETTINGSPAGE_HUNGERAROUSALAMOUNT", configHandler.hungerArousalAmount)
EndEvent

; Drain States
    State Toggle_lockDrain
        Event OnSelectST(string state_id)
            configHandler.lockDrainType = !configHandler.lockDrainType
            SetToggleOptionValueST(configHandler.lockDrainType)
            ForcePageReset()
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_LOCKDRAINTYPETOGGLE_HELP")
        EndEvent
    EndState

    State Toggle_deadlyWhenTransformed
        Event OnSelectST(string state_id)
            configHandler.deadlyDrainWhenTransformed = !configHandler.deadlyDrainWhenTransformed
            SetToggleOptionValueST(configHandler.deadlyDrainWhenTransformed)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DEADLYDRAINWHILETRANSFORMED_HELP")
        EndEvent
    EndState

    State Toggle_drainVerbosity
        Event OnSelectST(string state_id)
            configHandler.drainNotificationsEnabled = !configHandler.drainNotificationsEnabled
            SetToggleOptionValueST(configHandler.drainNotificationsEnabled)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINVERBOSITY_HELP")
        EndEvent
    EndState

    State Slider_forcedDrainMinimum
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.forcedDrainMinimum, -1, 100, 1, 0)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.forcedDrainMinimum = value
            SetSliderOptionValueST(configHandler.forcedDrainMinimum,"{0}")
            energyHandler.playerEnergyCurrent = energyHandler.playerEnergyCurrent
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM_HELP")
        EndEvent
    EndState

    State Slider_forcedDrainToDeathMinimum
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.forcedDrainToDeathMinimum, -1, 100, 1, 0)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.forcedDrainToDeathMinimum = value
            SetSliderOptionValueST(configHandler.forcedDrainToDeathMinimum,"{0}")
            energyHandler.playerEnergyCurrent = energyHandler.playerEnergyCurrent
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM_HELP")
        EndEvent
    EndState

    State Slider_drainDuration
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.drainDurationInGameTime, 1, 72, 1, 24)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.drainDurationInGameTime = value
            SetSliderOptionValueST(configHandler.drainDurationInGameTime)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINDURATION_HELP")
        EndEvent
    EndState

    State Slider_healthDrainMulti
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.healthDrainMult, 0, 0.99, 0.01, 0.20)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.healthDrainMult = value
            SetSliderOptionValueST(configHandler.healthDrainMult,"{2}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HEALTHDRAINMULT_HELP")
        EndEvent
    EndState

    State Slider_drainToDeathDelay
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.drainToDeathDelay, 0, 60, 0.1, 0)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.drainToDeathDelay = value
            SetSliderOptionValueST(configHandler.drainToDeathDelay,"{1}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINTODEATHDELAY_HELP")
        EndEvent
    EndState

    State Slider_drainArousalMulti
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.drainArousalMult, 0, 1, 0.1, 0.1)
        EndEvent

        Event OnSliderAcceptST(string state_id,float value)
            configHandler.drainArousalMult = value
            SetSliderOptionValueST(configHandler.drainArousalMult,"{1}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINAROUSALMULT_HELP")
        EndEvent
    EndState

    State Slider_baseMaxEnergy
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.baseMaxEnergy, 1, 1000, 1, 100)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.baseMaxEnergy = value
            CoL.ApplyRankedPerks()
            SetSliderOptionValueST(configHandler.baseMaxEnergy)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_MAXENERGYBASE_HELP")
        EndEvent
    EndState

    State Slider_energyConversionRate
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.energyConversionRate, 0, 1, 0.1, 0.5)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.energyConversionRate = value
            CoL.ApplyRankedPerks()
            SetSliderOptionValueST(configHandler.energyConversionRate, "{1}")
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_ENERGYCONVERSIONRATE_HELP")
        EndEvent
    EndState
    
    State Slider_minHealthPercent
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.minHealthPercent, 0, 1, 0.01, 0.10)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.minHealthPercent = value
            SetSliderOptionValueST(configHandler.minHealthPercent, "{2}")
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_MINHEALTHPERCENT_HELP")
        EndEvent
    EndState

    State Toggle_drainFeedsVampire
        Event OnSelectST(string state_id)
            configHandler.drainFeedsVampire = !configHandler.drainFeedsVampire
            SetToggleOptionValueST(configHandler.drainFeedsVampire)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE_HELP")
        EndEvent
    EndState

    State Toggle_drainToDeathCrime
        Event OnSelectST(string state_id)
            configHandler.drainToDeathCrime = !configHandler.drainToDeathCrime
            SetToggleOptionValueST(configHandler.drainToDeathCrime)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINTODEATHCRIME_HELP")
        EndEvent
    EndState

    State Slider_drainToDeathDetectioNRange
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.drainToDeathDetectionRange, 0, 5000, 100, 1000)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.drainToDeathDetectionRange = value as int
            SetSliderOptionValueST(configHandler.drainToDeathDetectionRange)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_CRIMERANGE_HELP")
        EndEvent
    EndState

    State Slider_npcRelationshipDeathChance
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.npcRelationshipDeathChance[state_id as int], 0, 100, 1, 0)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.npcRelationshipDeathChance[state_id as int] = value as int
            SetSliderOptionValueST(configHandler.npcRelationshipDeathChance[state_id as int],"{1}")
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_NPCRELATIONSHIPDEATHCHANCE_HELP")
        EndEvent
    EndState
; Leveling States
    State Slider_xpPerDrain
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.xpPerDrain, 0, 100, 1, 0)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.xpPerDrain = value
            SetSliderOptionValueST(configHandler.xpPerDrain)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPPERDRAIN_HELP")
        EndEvent
    EndState
    State Slider_xpDrainMult
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.xpDrainMult, 0, 100, 0.1, 0.5)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.xpDrainMult = value
            SetSliderOptionValueST(configHandler.xpDrainMult, "{1}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPDRAINMULT_HELP")
        EndEvent
    EndState
    State Slider_xpDeathMult
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.drainToDeathXPMult, 1, 100, 1, 2)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.drainToDeathXPMult = value
            SetSliderOptionValueST(configHandler.drainToDeathXPMult)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPDEATHMULT_HELP")
        EndEvent
    EndState
    State Slider_xpConstant
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.xpConstant, 0.01, 5, 0.01, 0.3)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.xpConstant = value
            SetSliderOptionValueST(configHandler.xpConstant, "{2}")
            levelHandler.calculateXpForNextLevel()
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPCONSTANT_HELP")
        EndEvent
    EndState
    State Slider_xpPower
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.xpPower, 0.01, 5, 0.01, 2)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.xpPower = value
            SetSliderOptionValueST(configHandler.xpPower,"{2}")
            levelHandler.calculateXpForNextLevel()
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPPOWER_HELP")
        EndEvent
    EndState
    State Slider_levelsForPerk
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.levelsForPerk, 1, 10, 1, 1)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.levelsForPerk = value as int
            SetSliderOptionValueST(configHandler.levelsForPerk)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_LEVELSFORPERK_HELP")
        EndEvent
    EndState
    State Slider_perksRecieved
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.perkPointsRecieved, 1, 10, 1, 1)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.perkPointsRecieved = value as int
            SetSliderOptionValueST(configHandler.perkPointsRecieved)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_PERKSRECIEVED_HELP")
        EndEvent
    EndState
    State Slider_transformRankEffects
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.transformRankEffects[state_id as int])
            if state_id == "4" ; Melee damage bonus
                SetSliderDialogDefaultValue(0.1)
                SetSliderDialogInterval(0.1)
                SetSliderDialogRange(0.1, 10)
            elseif state_id == "6" ; Magic resist bonus
                SetSliderDialogDefaultValue(1)
                SetSliderDialogInterval(1)
                SetSliderDialogRange(1, 100)
            else
                SetSliderDialogDefaultValue(10)
                SetSliderDialogInterval(1)
                SetSliderDialogRange(1, 100)
            endif
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.transformRankEffects[state_id as int] = value
            if state_id == "4" ; Melee damage Bonus
                SetSliderOptionValueST(configHandler.transformRankEffects[state_id as int], "{1}")
            else
                SetSliderOptionValueST(configHandler.transformRankEffects[state_id as int])
            endif
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_TRANSFORMRANKEFFECTS_"+state_id+"_HELP")
        EndEvent
    EndState
; Hunger States
    State Toggle_hunger
        Event OnSelectST(string state_id)
            configHandler.hungerEnabled = !configHandler.hungerEnabled
            SetToggleOptionValueST(configHandler.hungerEnabled)
            configHandler.SendConfigUpdateEvent()
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGER_HELP")
        EndEvent
    EndState

    State Slider_hungerAmount
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.dailyHungerAmount, -1, 100, 1, 10)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.dailyHungerAmount = value
            SetSliderOptionValueST(configHandler.dailyHungerAmount)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGER_AMOUNT_HELP")
        EndEvent
    EndState

    State Toggle_hungerIsPercent
        Event OnSelectST(string state_id)
            configHandler.hungerIsPercent = !configHandler.hungerIsPercent
            SetToggleOptionValueST(configHandler.hungerIsPercent)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGERISPERCENT_HELP")
        EndEvent
    EndState

    State Slider_hungerThreshold
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.hungerThreshold, -1, 100, 1, 10)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.hungerThreshold = value as int
            SetSliderOptionValueST(configHandler.hungerThreshold as float)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGERTHRESHOLD_HELP")
        EndEvent
    EndState

    State Toggle_deadlyHunger
        Event OnSelectST(string state_id)
            configHandler.deadlyHunger = !configHandler.deadlyHunger
            SetToggleOptionValueST(configHandler.deadlyHunger)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DEADLYHUNGER_HELP")
        EndEvent
    EndState

    State Slider_hungerDamageAmount
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.hungerDamageAmount, -1, 100, 1, 5)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.hungerDamageAmount = value
            SetSliderOptionValueST(configHandler.hungerDamageAmount)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGERDAMAGEAMOUNT_HELP")
        EndEvent
    EndState

    State Toggle_hungerArousal
        Event OnSelectST(string state_id)
            configHandler.hungerArousalEnabled = !configHandler.hungerArousalEnabled
            SetToggleOptionValueST(configHandler.hungerArousalEnabled)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGERAROUSAL_HELP")
        EndEvent
    EndState

    State Slider_hungerArousalAmount
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.hungerArousalAmount, -1, 100, 1, 5)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.hungerArousalAmount = value
            SetSliderOptionValueST(configHandler.hungerArousalAmount)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGERAROUSALAMOUNT_HELP")
        EndEvent
    EndState

; Tattoo States
    State Toggle_tattooFade
        Event OnSelectST(string state_id)
            configHandler.tattooFade = !configHandler.tattooFade
            SetToggleOptionValueST(configHandler.tattooFade)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_TATTOOFADE_HELP")
        EndEvent
    EndState

    State Slider_tattooSlot
        Event OnSliderOpenST(string state_id)
            SetSliderDialog(configHandler.tattooSlot, 1, 6, 1, 6)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.tattooSlot = value as int
            SetSliderOptionValueST(configHandler.tattooSlot)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_TATTOOSLOT_HELP")
        EndEvent
    EndState
