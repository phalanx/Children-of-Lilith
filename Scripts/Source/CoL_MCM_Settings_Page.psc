Scriptname CoL_MCM_Settings_Page extends nl_mcm_module

Quest Property playerSuccubusQuest Auto

CoL_PlayerSuccubusQuestScript CoL
CoL_ConfigHandler_Script configHandler
CoL_Mechanic_DrainHandler_Script drainHandler
CoL_Mechanic_LevelHandler_Script levelHandler
CoL_Mechanic_HungerHandler_Script hungerHandler

Event OnInit()
    RegisterModule("$COL_SETTINGSPAGE_NAME", 20)
EndEvent

Event OnPageInit()
    CoL = playerSuccubusQuest as CoL_PlayerSuccubusQuestScript
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
    drainHandler = playerSuccubusQuest as CoL_Mechanic_DrainHandler_Script
    levelHandler = playerSuccubusQuest as CoL_Mechanic_LevelHandler_Script
    hungerHandler = playerSuccubusQuest as CoL_Mechanic_HungerHandler_Script
EndEvent

Event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddSliderOptionST("Slider_maxEnergyBase", "$COL_SETTINGSPAGE_MAXENERGYBASE", configHandler.baseMaxEnergy, "{0}")
    ; Player Drain Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_PLAYERDRAINSETTINGS")
        if configHandler.lockDrainType
            AddToggleOptionST("Toggle_Drain", "$COL_SETTINGSPAGE_DRAINTOGGLE", drainHandler.draining, OPTION_FLAG_DISABLED)
            AddToggleOptionST("Toggle_DrainToDeath", "$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE", drainHandler.drainingToDeath, OPTION_FLAG_DISABLED)
        else
            AddToggleOptionST("Toggle_Drain", "$COL_SETTINGSPAGE_DRAINTOGGLE", drainHandler.draining)
            AddToggleOptionST("Toggle_DrainToDeath", "$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE", drainHandler.drainingToDeath)
        endif
        AddToggleOptionST("Toggle_lockDrain", "$COL_SETTINGSPAGE_LOCKDRAINTYPETOGGLE", configHandler.lockDrainType)
        AddToggleOptionST("Toggle_deadlyWhenTransformed", "$COL_SETTINGSPAGE_DEADLYDRAINWHILETRANSFORMED", configHandler.deadlyDrainWhenTransformed)
        AddToggleOptionST("Toggle_drainVerbosity", "$COL_SETTINGSPAGE_DRAINVERBOSITY", configHandler.drainNotificationsEnabled)
        AddSliderOptionST("Slider_forcedDrainMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM", configHandler.forcedDrainMinimum, "{0}")
        AddSliderOptionST("Slider_forcedDrainToDeathMinimum", "$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM", configHandler.forcedDrainToDeathMinimum, "{0}")
        AddSliderOptionST("Slider_drainDuration", "$COL_SETTINGSPAGE_DRAINDURATION", configHandler.drainDurationInGameTime)
        AddSliderOptionST("Slider_healthDrainMulti", "$COL_SETTINGSPAGE_HEALTHDRAINMULT", configHandler.healthDrainMult, "{1}")
        AddSliderOptionST("Slider_drainArousalMulti", "$COL_SETTINGSPAGE_DRAINAROUSALMULT", configHandler.drainArousalMult, "{1}")
        AddSliderOptionST("Slider_energyConversionRate", "$COL_SETTINGSPAGE_ENERGYCONVERSIONRATE", configHandler.energyConversionRate, "{1}")
        AddToggleOptionST("Toggle_drainFeedsVampire", "$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE", configHandler.drainFeedsVampire)
    ; NPC Drain Settings
        AddHeaderOption("$COL_SETTINGSPAGE_HEADER_NPCDRAINSETTINGS")
        AddSliderOptionST("Slider_npcDeathChance", "$COL_SETTINGSPAGE_NPCDEATHCHANCE", configHandler.npcDrainToDeathChance, "{1}")
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
    State Toggle_Drain
        Event OnSelectST(string state_id)
            drainHandler.draining = !drainHandler.draining
            SetToggleOptionValueST(drainHandler.draining)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINTOGGLE_HELP")
        EndEvent
    EndState

    State Toggle_DrainToDeath
        Event OnSelectST(string state_id)
            drainHandler.drainingToDeath = !drainHandler.drainingToDeath
            SetToggleOptionValueST(drainHandler.drainingToDeath)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINTODEATHTOGGLE_HELP")
        EndEvent
    EndState

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
            SetSliderDialogStartValue(configHandler.forcedDrainMinimum)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(-1, 100)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.forcedDrainMinimum = value
            SetSliderOptionValueST(configHandler.forcedDrainMinimum,"{0}")
            CoL.playerEnergyCurrent = CoL.playerEnergyCurrent
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINMINIMUM_HELP")
        EndEvent
    EndState

    State Slider_forcedDrainToDeathMinimum
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.forcedDrainToDeathMinimum)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(-1, 100)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.forcedDrainToDeathMinimum = value
            SetSliderOptionValueST(configHandler.forcedDrainToDeathMinimum,"{0}")
            CoL.playerEnergyCurrent = CoL.playerEnergyCurrent
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_FORCEDDRAINTODEATHMINIMUM_HELP")
        EndEvent
    EndState

    State Slider_drainDuration
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.drainDurationInGameTime)
            SetSliderDialogDefaultValue(24.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 72.0)
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
            SetSliderDialogStartValue(configHandler.healthDrainMult)
            SetSliderDialogDefaultValue(0.2)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.healthDrainMult = value
            SetSliderOptionValueST(configHandler.healthDrainMult,"{1}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HEALTHDRAINMULT_HELP")
        EndEvent
    EndState

    State Slider_drainArousalMulti
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.drainArousalMult)
            SetSliderDialogDefaultValue(0.1)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
        EndEvent

        Event OnSliderAcceptST(string state_id,float value)
            configHandler.drainArousalMult = value
            SetSliderOptionValueST(configHandler.drainArousalMult,"{1}")
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINAROUSALMULT_HELP")
        EndEvent
    EndState

    State Slider_maxEnergyBase
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.baseMaxEnergy)
            SetSliderDialogDefaultValue(100)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 1000)
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
            SetSliderDialogStartValue(configHandler.energyConversionRate)
            SetSliderDialogDefaultValue(0.5)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 1.0)
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

    State Toggle_drainFeedsVampire
        Event OnSelectST(string state_id)
            configHandler.drainFeedsVampire = !configHandler.drainFeedsVampire
            SetToggleOptionValueST(configHandler.drainFeedsVampire)
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_DRAINFEEDSVAMPIRE_HELP")
        EndEvent
    EndState

    State Slider_npcDeathChance
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.npcDrainToDeathChance)
            SetSliderDialogDefaultValue(0)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(0, 100)
        EndEvent
        Event OnSliderAcceptST(string state_id, float value)
            configHandler.npcDrainToDeathChance = value as int
            SetSliderOptionValueST(configHandler.npcDrainToDeathChance,"{1}")
        EndEvent
        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_NPCDEATHCHANCE_HELP")
        EndEvent
    EndState

; Levelling States
    State Slider_xpPerDrain
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.xpPerDrain)
            SetSliderDialogDefaultValue(0.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(0.0, 100.0)
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
            SetSliderDialogStartValue(configHandler.xpDrainMult)
            SetSliderDialogDefaultValue(0.5)
            SetSliderDialogInterval(0.1)
            SetSliderDialogRange(0.0, 100.0)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.xpDrainMult = value
            SetSliderOptionValueST(configHandler.xpDrainMult)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_XPDRAINMULT_HELP")
        EndEvent
    EndState

    State Slider_xpDeathMult
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.drainToDeathXPMult)
            SetSliderDialogDefaultValue(2.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(1.0, 100.0)
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
            SetSliderDialogStartValue(configHandler.xpConstant)
            SetSliderDialogDefaultValue(0.75)
            SetSliderDialogInterval(0.01)
            SetSliderDialogRange(0.01, 5.0)
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
            SetSliderDialogStartValue(configHandler.xpPower)
            SetSliderDialogDefaultValue(1.5)
            SetSliderDialogInterval(0.01)
            SetSliderDialogRange(0.01, 5.0)
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
            SetSliderDialogStartValue(configHandler.levelsForPerk)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
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
            SetSliderDialogStartValue(configHandler.perkPointsRecieved)
            SetSliderDialogDefaultValue(1)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 10)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.perkPointsRecieved = value as int
            SetSliderOptionValueST(configHandler.perkPointsRecieved)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_PERKSRECIEVED_HELP")
        EndEvent
    EndState

; Hunger States
    State Toggle_hunger
        Event OnSelectST(string state_id)
            configHandler.hungerEnabled = !configHandler.hungerEnabled
            SetToggleOptionValueST(configHandler.hungerEnabled)
            hungerHandler.UpdateConfig()
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_HUNGER_HELP")
        EndEvent
    EndState

    State Slider_hungerAmount
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.dailyHungerAmount)
            SetSliderDialogDefaultValue(9.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(-1.0, 100.0)
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
            SetSliderDialogStartValue(configHandler.hungerThreshold as float)
            SetSliderDialogDefaultValue(9.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(-1.0, 100.0)
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
            SetInfoText("$COL_SETTINGSPAGE_DEADLYHUNGER")
        EndEvent
    EndState

    State Slider_hungerDamageAmount
        Event OnSliderOpenST(string state_id)
            SetSliderDialogStartValue(configHandler.hungerDamageAmount)
            SetSliderDialogDefaultValue(4.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(-1.0, 100.0)
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
            SetSliderDialogStartValue(configHandler.hungerArousalAmount)
            SetSliderDialogDefaultValue(4.0)
            SetSliderDialogInterval(1.0)
            SetSliderDialogRange(-1.0, 100.0)
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
            SetSliderDialogStartValue(configHandler.tattooSlot)
            SetSliderDialogDefaultValue(6)
            SetSliderDialogInterval(1)
            SetSliderDialogRange(1, 6)
        EndEvent

        Event OnSliderAcceptST(string state_id, float value)
            configHandler.tattooSlot = value as int
            SetSliderOptionValueST(configHandler.tattooSlot)
        EndEvent

        Event OnHighlightST(string state_id)
            SetInfoText("$COL_SETTINGSPAGE_TATTOOSLOT_HELP")
        EndEvent
    EndState
