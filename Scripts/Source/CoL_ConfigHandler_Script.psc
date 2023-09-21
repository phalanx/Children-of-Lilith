Scriptname CoL_ConfigHandler_Script extends Quest

GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus

float Property baseMaxEnergy = 100.0 Auto Hidden                ; Base line maximum energy, before perks are applied
string[] Property followedPathOptions Auto Hidden               ; Holds available path options
int Property selectedPath = 0 Auto Hidden                       ; Which path is the player following
bool Property DebugLogging = false Auto Hidden                  ; Are debug logs enabled
bool Property EnergyScaleTestEnabled = false Auto Hidden        ; Is the energy scale test enabled

; Player Drain Settings
bool Property lockDrainType = false Auto Hidden                 ; Disable drain type hotkeys
bool Property deadlyDrainWhenTransformed = false Auto Hidden    ; Always deadly drain while transformed
bool Property drainNotificationsEnabled = true Auto Hidden      ; Should notifications play when drain style is changed
float Property forcedDrainMinimum = -1.0 Auto Hidden            ; Minimum energy to always drain
float Property forcedDrainToDeathMinimum = -1.0 Auto Hidden     ; Minimum energy to always drain to death
float Property drainDurationInGameTime = 24.0 Auto Hidden       ; How long, in game hours, does the drain debuff last
float Property healthDrainMult = 0.2 Auto Hidden                ; Percentage of health to drain from victim (Health Drained = Victim Max Health * Mult)
float Property drainArousalMult = 0.1 Auto Hidden               ; Multiplier applied to arousal before being added to drain amount
float Property drainToDeathMult = 2.0 Auto Hidden               ; Multiplier applied energy conversion when victim is drained to death
float Property energyConversionRate = 0.5 Auto Hidden           ; Rate at which drained health is converted to Energy
bool Property drainFeedsVampire = true Auto Hidden              ; Should draining trigger a vampire feeding
float Property minHealthPercent = 0.11 Auto Hidden              ; Minimum percentage of health allowed to be drained

; NPC Drain Settings
int Property npcDrainToDeathChance = 0 Auto Hidden              ; Percentage chance for npc succubi to drain a victim to death

; Levelling Settings
float Property xpConstant = 0.3 Auto Hidden                     ; Effects amount of XP required. Lower = More xp Required
float Property xpPower = 2.0 Auto Hidden                        ; Effects rate xp per level grows. Higher = Larger Gaps
int Property levelsForPerk = 1 Auto Hidden                      ; Levels required before a perk is granted
int Property perkPointsRecieved = 1 Auto Hidden                 ; Number of perks recieved when perks are given
float Property xpPerDrain = 0.0 Auto Hidden                     ; Extra xp given for each drain
float Property xpDrainMult = 0.5 Auto Hidden                    ; Multiplier applied to drained health to convert it to XP
float Property drainToDeathXPMult = 2.0 Auto Hidden             ; Multiplier applied to xp when victim is drained to death

; Hunger Settings
bool Property hungerEnabled = false Auto Hidden         ; Drains energy at a set basis
bool Property hungerIsPercent = false Auto Hidden       ; dailyHungerAmount will be treated as a percentage
float Property dailyHungerAmount = 10.0 Auto Hidden     ; Flat amount of hunger removed per day
bool Property deadlyHunger = false Auto Hidden          ; Running out of energy will deal reduce max health every 30 seconds
float Property hungerDamageAmount = 5.0 Auto Hidden     ; Amount of max health reduced every 30 seconds
bool Property hungerArousalEnabled = false Auto Hidden  ; Running out of energy will cause increasing arousal if a supported framework is installed
float Property hungerArousalAmount = 5.0 Auto Hidden    ; Amount of arousal gained every 30 seconds
int Property hungerThreshold = 10 Auto Hidden           ; Percentage of energy below which hunger effects happen

; Tattoo Fade
bool Property tattooFade = false Auto Hidden            ; Controls tattoo fading based on energy percentage
int Property tattooSlot = 6 Auto Hidden                 ; Body Slot of tattoo to control. Must be reduced by 1 for the actual racemenu slot

; Power Settings
bool Property grantCSFPower = false Auto Hidden         ; Should the CSF Power Menu be given
float Property becomeEtherealCost  = 10.0 Auto Hidden   ; Per second Energy Cost of Succubus Become Ethereal
float Property healRateBoostCost = 5.0 Auto Hidden      ; Per second Energy Cost of Succubus HealRate Boost
float Property healRateBoostAmount = 10.0 Auto Hidden   ; Modify healRate by this amount

float Property energyCastingMult = 1.0 Auto Hidden      ; Modify the energy cost of spells
string[] Property energyCastingConcStyleOptions Auto Hidden ; Holds string values for the concentration calculation style. Initialized in Maintenance()
int Property energyCastingConcStyle = 1 Auto Hidden     ; 0: Calculate only Left hand, ; 1: Both hands ; 2: Right Hand ; Anything else: Don't calculate
bool Property energyCastingFXEnabled = True Auto Hidden ; Enables or disables the screen flash effect of energy casting

int Property excitementCost = 10 Auto Hidden            ; Energy cost of excitement spell
int Property excitementBaseIncrease = 1 Auto Hidden     ; Base arousal increase of excitement
float Property excitementLevelMult = 1.0 Auto Hidden    ; Mult applied to succubus level before being added to base increase

int Property suppressionCost = 10 Auto Hidden           ; Energy cost of suppression spell
int Property suppressionBaseIncrease = 1 Auto Hidden    ; Base Arousal decrease of suppression
float Property suppressionLevelMult = 1.0 Auto Hidden   ; Mult applied to succubus level before being added to base decrease

int Property newTemptationCost = 10 Auto Hidden            ; Energy cost of temptation spell
int Property newTemptationBaseIncrease = 1 Auto Hidden     ; Base Arousal increase of temptation
float Property newTemptationLevelMult = 1.0 Auto Hidden    ; Mult applied to succubus level before being added to the base increase

; Hotkey Settings
int Property toggleDrainHotkey = 29 Auto Hidden            ; Default Toggle Drain key to left shift
int Property toggleDrainToDeathHotkey = 157 Auto Hidden    ; Default Toggle Drain to Death key to right alt
int Property transformHotkey = -1 Auto Hidden              ; Transform hotkey, no default
int Property temptationHotkey = -1 Auto Hidden             ; temptation hotkey, no default
int Property newTemptationHotkey = -1 Auto Hidden             ; temptation hotkey, no default
int Property csfMenuHotkey = -1 Auto Hidden                ; Custom skill framework hotkey, no default

; Widget Settings
int Property energyMeterAlpha = 100 Auto Hidden
int Property energyMeterXPos = 640 Auto Hidden
int Property energyMeterYPos = 700 Auto Hidden
int Property energyMeterXScale = 70 Auto Hidden
int Property energyMeterYScale = 70 Auto Hidden
bool Property autoFade = false Auto Hidden
int Property autoFadeTime = 5 Auto Hidden

; Transform Settings
Form[] Property NoStripList Auto Hidden
bool Property transformAnimation = true Auto Hidden
bool Property transformSwapsEquipment = true Auto Hidden
bool Property transformSavesNiOverrides = false Auto Hidden
float Property transformCost = 1.0 Auto Hidden
bool Property transformCrime = false Auto Hidden
float Property transformArousalUpperThreshold = 0.0 Auto Hidden
float Property transformArousalLowerThreshold = 0.0 Auto Hidden

; Transform Baseline Buffs
bool Property transformBuffsEnabled = false Auto Hidden
float Property transformBaseHealth = 0.0 Auto Hidden
float Property transformBaseStamina = 0.0 Auto Hidden
float Property transformBaseMagicka = 0.0 Auto Hidden
float Property transformBaseCarryWeight = 0.0 Auto Hidden
float Property transformBaseMeleeDamage = 0.0 Auto Hidden
float Property transformBaseArmor = 0.0 Auto Hidden
float Property transformBaseMagicResist = 0.0 Auto Hidden

; Transform Buffs Per Rank
float Property transformHealthPerRank = 10.0 Auto Hidden
float Property transformStaminaPerRank = 10.0 Auto Hidden
float Property transformMagickaPerRank = 10.0 Auto Hidden
float Property transformCarryWeightPerRank = 10.0 Auto Hidden
float Property transformMeleeDamagePerRank = 0.1 Auto Hidden
float Property transformArmorPerRank = 10.0 Auto Hidden
float Property transformMagicResistPerRank = 1.0 Auto Hidden

Event OnInit()
    Maintenance()
EndEvent

Function Maintenance()
    followedPathOptions = new string[3]
    followedPathOptions[0] = "$COL_STATUSPAGE_PATH_SANQUINE"
    followedPathOptions[1] = "$COL_STATUSPAGE_PATH_MOLAG"
    followedPathOptions[2] = "$COL_STATUSPAGE_PATH_VAERMINA"

    energyCastingConcStyleOptions = new string[4]
    energyCastingConcStyleOptions[0] = "$COL_POWERSPAGE_COSTCALCSTYLE_LEFT"
    energyCastingConcStyleOptions[1] = "$COL_POWERSPAGE_COSTCALCSTYLE_BOTH"
    energyCastingConcStyleOptions[2] = "$COL_POWERSPAGE_COSTCALCSTYLE_RIGHT"
    energyCastingConcStyleOptions[3] = "$COL_POWERSPAGE_COSTCALCSTYLE_NONE"
    RegisterForModEvent("CoL_GameLoad", "Maintenance")
EndFunction

Function SendConfigUpdateEvent()
    if isPlayerSuccubus.GetValueInt() != 0
        int handle = ModEvent.Create("CoL_configUpdated")
        if handle
            ModEvent.Send(handle)
        endif
    endif
EndFunction

int Function GetConfigVersion()
    return 4
EndFunction

int Function SaveConfig()
    int jObj = JMap.object()
    ; Save Base Settings
        JMap.setInt(jObj, "version", GetConfigVersion())
        JMap.setFlt(jObj, "baseMaxEnergy", baseMaxEnergy)
        JMap.setInt(jObj, "selectedPath", selectedPath)
        JMap.setInt(jObj, "DebugLogging", DebugLogging as int)
        JMap.setInt(jObj, "EnergyScaleTestEnabled", EnergyScaleTestEnabled as int)
    ; Save Drain Settings
        JMap.setInt(jObj, "lockDrainType", lockDrainType as int)
        JMap.setInt(jObj, "deadlyDrainWhenTransformed", deadlyDrainWhenTransformed as int)
        JMap.setInt(jObj, "drainNotificationsEnabled", drainNotificationsEnabled as int)
        JMap.setFlt(jObj, "forcedDrainMinimum", forcedDrainMinimum)
        JMap.setFlt(jObj, "forcedDrainToDeathMinimum", forcedDrainToDeathMinimum)
        JMap.setFlt(jObj, "drainDurationInGameTime", drainDurationInGameTime)
        JMap.setFlt(jObj, "healthDrainMult", healthDrainMult)
        JMap.setFlt(jObj, "drainArousalMult", drainArousalMult)
        JMap.setFlt(jObj, "drainToDeathMult", drainToDeathMult)
        JMap.setFlt(jObj, "energyConversionRate", energyConversionRate)
        JMap.setInt(jObj, "drainFeedsVampire", drainFeedsVampire as int)
        JMap.setInt(jObj, "npcDrainToDeathChance", npcDrainToDeathChance)
        JMap.setFlt(jObj, "minHealthPercent", minHealthPercent)
    ; Save Levelling Settings
        JMap.setFlt(jObj, "xpConstant", xpConstant)
        JMap.setFlt(jObj, "xpPower", xpPower)
        JMap.setInt(jObj, "levelsForPerk", levelsForPerk)
        JMap.setInt(jObj, "perkPointsRecieved", perkPointsRecieved)
        JMap.setFlt(jObj, "xpPerDrain", xpPerDrain)
        JMap.setFlt(jObj, "xpDrainMult", xpDrainMult)
        JMap.setFlt(jObj, "drainToDeathXPMult", drainToDeathXPMult)
    ; Save Hunger Settings
        JMap.setInt(jObj, "hungerEnabled", hungerEnabled as int)
        JMap.setInt(jObj, "hungerIsPercent", hungerIsPercent as int)
        JMap.setFlt(jObj, "dailyHungerAmount", dailyHungerAmount)
        JMap.setInt(jObj, "deadlyHunger", deadlyHunger as int)
        JMap.setFlt(jObj, "hungerDamageAmount", hungerDamageAmount)
        JMap.setInt(jObj, "hungerArousalEnabled", hungerArousalEnabled as int)
        JMap.setFlt(jObj, "hungerArousalAmount", hungerArousalAmount)
        JMap.setInt(jObj, "hungerThreshold", hungerThreshold)
    ; Save Tattoo Fade Settings
        JMap.setInt(jObj, "tattooFade", tattooFade as int)
        JMap.setInt(jObj, "hungerThreshold", tattooSlot)
    ; Save Power Settings
        JMap.setInt(jObj, "grantCSFPower", grantCSFPower as int)
        JMap.setFlt(jObj, "becomeEtherealCost", becomeEtherealCost)
        JMap.setFlt(jObj, "healRateBoostCost", healRateBoostCost)
        JMap.setFlt(jObj, "healRateBoostAmount", healRateBoostAmount)
        JMap.setFlt(jObj, "energyCastingMult", energyCastingMult)
        JMap.setInt(jObj, "energyCastingConcStyle", energyCastingConcStyle)
        JMap.setInt(jObj, "energyCastingFX", energyCastingFXEnabled as int)
        JMap.setInt(jObj, "excitementCost", excitementCost)
        JMap.setInt(jObj, "excitementBaseIncrease", excitementBaseIncrease)
        JMap.setFlt(jObj, "excitementLevelMult", excitementLevelMult)
        JMap.setInt(jObj, "suppressionCost", suppressionCost)
        JMap.setInt(jObj, "suppressionBaseIncrease", suppressionBaseIncrease)
        JMap.setFlt(jObj, "suppressionLevelMult", suppressionLevelMult)
        JMap.setInt(jObj, "newTemptationCost", newTemptationCost)
        JMap.setInt(jObj, "newTemptationBaseIncrease", newTemptationBaseIncrease)
        JMap.setFlt(jObj, "newTemptationLevelMult", newTemptationLevelMult)
    ; Save Hotkey Settings
        JMap.setInt(jObj, "toggleDrainHotkey", toggleDrainHotkey)
        JMap.setInt(jObj, "toggleDrainToDeathHotkey", toggleDrainToDeathHotkey)
        JMap.setInt(jObj, "transformHotkey", transformHotkey)
        JMap.setInt(jObj, "temptationHotkey", newTemptationHotkey)
        JMap.setInt(jObj, "csfMenuHotkey", csfMenuHotkey)
    ; Save Widget Settings
        JMap.setInt(jObj, "energyMeterAlpha", energyMeterAlpha)
        JMap.setInt(jObj, "energyMeterXPos", energyMeterXPos)
        JMap.setInt(jObj, "energyMeterYPos", energyMeterYPos)
        JMap.setInt(jObj, "energyMeterXScale", energyMeterXScale)
        JMap.setInt(jObj, "energyMeterYScale", energyMeterYScale)
        JMap.setInt(jObj, "autoFade", autoFade as int)
        JMap.setInt(jObj, "autoFadeTime", autoFadeTime)
    ; Save Transform Settings
        JMap.setInt(jObj, "transformAnimation", transformAnimation as int)
        JMap.setInt(jObj, "transformSwapsEquipment", transformSwapsEquipment as int)
        JMap.setInt(jObj, "transformSavesNiOverrides", transformSavesNiOverrides as int)
        JMap.setFlt(jObj, "transformCost", transformCost)
        JMap.setInt(jObj, "transformCrime", transformCrime as int)
        JMap.setFlt(jObj, "transformArousalUpperThreshold", transformArousalUpperThreshold)
        JMap.setFlt(jObj, "transformArousalLowerThreshold", transformArousalLowerThreshold)
    ; Save Transform Baseline Buffs
        JMap.setInt(jObj, "transformBuffsEnabled", transformBuffsEnabled as int)
        JMap.setFlt(jObj, "transformBaseHealth", transformBaseHealth)
        JMap.setFlt(jObj, "transformBaseStamina", transformBaseStamina)
        JMap.setFlt(jObj, "transformBaseMagicka", transformBaseMagicka)
        JMap.setFlt(jObj, "transformBaseCarryWeight", transformBaseCarryWeight)
        JMap.setFlt(jObj, "transformBaseMeleeDamage", transformBaseMeleeDamage)
        JMap.setFlt(jObj, "transformBaseArmor", transformBaseArmor)
        JMap.setFlt(jObj, "transformBaseMagicResist", transformBaseMagicResist)
    ; Save Transform Buffs Per Rank
        JMap.setFlt(jObj, "transformHealthPerRank", transformHealthPerRank)
        JMap.setFlt(jObj, "transformStaminaPerRank", transformStaminaPerRank)
        JMap.setFlt(jObj, "transformMagickaPerRank", transformMagickaPerRank)
        JMap.setFlt(jObj, "transformCarryWeightPerRank", transformCarryWeightPerRank)
        JMap.setFlt(jObj, "transformMeleeDamagePerRank", transformMeleeDamagePerRank)
        JMap.setFlt(jObj, "transformArmorPerRank", transformArmorPerRank)
        JMap.setFlt(jObj, "transformMagicResistPerRank", transformMagicResistPerRank)
    return jObj
EndFunction

Function LoadConfig(int jObj)
    JValue.retain(jObj)
    int configVersion = JMap.getInt(jObj, "version")
    ; Load Base Settings
        baseMaxEnergy = JMap.getFlt(jObj, "baseMaxEnergy")
        selectedPath = JMap.getInt(jObj, "selectedPath")
        DebugLogging = JMap.getInt(jObj, "DebugLogging") as bool
        EnergyScaleTestEnabled = JMap.getInt(jObj, "EnergyScaleTestEnabled") as bool
    ; Load Drain Settings
        lockDrainType = JMap.getInt(jObj, "lockDrainType") as bool
        deadlyDrainWhenTransformed = JMap.getInt(jObj, "deadlyDrainWhenTransformed") as bool
        drainNotificationsEnabled = JMap.getInt(jObj, "drainNotificationsEnabled") as bool
        forcedDrainMinimum = JMap.getFlt(jObj, "forcedDrainMinimum")
        forcedDrainToDeathMinimum = JMap.getFlt(jObj, "forcedDrainToDeathMinimum")
        drainDurationInGameTime = JMap.getFlt(jObj, "drainDurationInGameTime")
        healthDrainMult = JMap.getFlt(jObj, "healthDrainMult")
        drainArousalMult = JMap.getFlt(jObj, "drainArousalMult")
        drainToDeathMult = JMap.getFlt(jObj, "drainToDeathMult")
        energyConversionRate = JMap.getFlt(jObj, "energyConversionRate")
        drainFeedsVampire = JMap.getInt(jObj, "drainFeedsVampire") as bool
        npcDrainToDeathChance = JMap.getInt(jObj, "npcDrainToDeathChance")
        if configVersion >= 3
            minHealthPercent = JMap.getFlt(jObj, "minHealthPercent")
        endif
    ; Load Levelling Settings
        xpConstant = JMap.getFlt(jObj, "xpConstant")
        xpPower = JMap.getFlt(jObj, "xpPower")
        levelsForPerk = JMap.getInt(jObj, "levelsForPerk")
        perkPointsRecieved = JMap.getInt(jObj, "perkPointsRecieved")
        xpPerDrain = JMap.getFlt(jObj, "xpPerDrain")
        xpDrainMult = JMap.getFlt(jObj, "xpDrainMult")
        drainToDeathMult = JMap.getFlt(jObj, "drainToDeathMult")
    ; Load Hunger Settings
        hungerEnabled = JMap.getInt(jObj, "hungerEnabled") as bool
        hungerIsPercent = JMap.getInt(jObj, "hungerIsPercent") as bool
        dailyHungerAmount = JMap.getFlt(jObj, "dailyHungerAmount")
        deadlyHunger = JMap.getInt(jObj, "deadlyHunger") as bool
        hungerDamageAmount = JMap.getFlt(jObj, "hungerDamageAmount")
        hungerArousalEnabled = JMap.getInt(jObj, "hungerArousalEnabled") as bool
        hungerArousalAmount = JMap.getFlt(jObj, "hungerArousalAmount")
        hungerThreshold = JMap.getInt(jObj, "hungerThreshold")
    ; Load Tattoo Fade Settings
        tattooFade = JMap.getInt(jObj, "tattooFade") as bool
        tattooSlot = JMap.getInt(jObj, "tattooSlot")
    ; Load Power Settings
        grantCSFPower = JMap.getInt(jObj, "grantCSFPower") as bool
        becomeEtherealCost = JMap.getFlt(jObj, "becomeEtherealCost")
        healRateBoostCost = JMap.getFlt(jObj, "healRateBoostCost")
        healRateBoostAmount = JMap.getFlt(jObj, "healRateBoostAmount")
        energyCastingMult = JMap.getFlt(jObj, "energyCastingMult")
        energyCastingConcStyle = JMap.getInt(jObj, "energyCastingConcStyle")
        if configVersion >= 4
            energyCastingFXEnabled = JMap.getInt(jObj, "energyCastingFX")
        endif
        excitementCost = JMap.getInt(jObj, "excitementCost")
        excitementBaseIncrease = JMap.getInt(jObj, "excitementBaseIncrease")
        excitementLevelMult = JMap.getFlt(jObj, "excitementLevelMult")
        suppressionCost = JMap.getInt(jObj, "suppressionCost")
        suppressionBaseIncrease = JMap.getInt(jObj, "suppressionBaseIncrease")
        suppressionLevelMult = JMap.getFlt(jObj, "suppressionLevelMult")
        if configVersion >= 2
            newTemptationCost = JMap.getInt(jObj, "newTemptationCost")
            newTemptationBaseIncrease = JMap.getInt(jObj, "newTemptationBaseIncrease")
            newTemptationLevelMult = JMap.getFlt(jObj, "newTemptationLevelMult")
        endif
    ; Load Hotkey Settings
        toggleDrainHotkey = JMap.getInt(jObj, "toggleDrainHotkey")
        toggleDrainToDeathHotkey = JMap.getInt(jObj, "toggleDrainToDeathHotkey")
        transformHotkey = JMap.getInt(jObj, "transformHotkey")
        newTemptationHotkey = JMap.getInt(jObj, "temptationHotkey")
        csfMenuHotkey = JMap.getInt(jObj, "csfMenuHotkey")
    ; Load Widget Setting
        energyMeterAlpha = JMap.getInt(jObj, "energyMeterAlpha")
        energyMeterXPos = JMap.getInt(jObj, "energyMeterXPos")
        energyMeterYPos = JMap.getInt(jObj, "energyMeterYPos")
        energyMeterXScale = JMap.getInt(jObj, "energyMeterXScale")
        energyMeterYScale = JMap.getInt(jObj, "energyMeterYScale")
        autoFade = JMap.getInt(jObj, "autoFade") as bool
        autoFadeTime = JMap.getInt(jObj, "autoFadeTime")
    ; Load Transform Settings
        transformAnimation = JMap.getInt(jObj, "transformAnimation") as bool
        transformSwapsEquipment = JMap.getInt(jObj, "transformSwapsEquipment") as bool
        transformSavesNiOverrides = JMap.getInt(jObj, "transformSavesNiOverrides") as bool
        transformCost = JMap.getFlt(jObj, "transformCost")
        transformCrime = JMap.getInt(jObj, "transformCrime") as bool
        transformArousalUpperThreshold = JMap.getFlt(jObj, "transformArousalUpperThreshold")
        transformArousalLowerThreshold = JMap.getFlt(jObj, "transformArousalLowerThreshold")
    ; Load Transform Baseline Buffs
        transformBuffsEnabled = JMap.getInt(jObj, "transformBuffsEnabled") as bool
        transformBaseHealth = JMap.getFlt(jObj, "transformBaseHealth")
        transformBaseStamina = JMap.getFlt(jObj, "transformBaseStamina")
        transformBaseMagicka = JMap.getFlt(jObj, "transformBaseMagicka")
        transformBaseCarryWeight = JMap.getFlt(jObj, "transformBaseCarryWeight")
        transformBaseMeleeDamage = JMap.getFlt(jObj, "transformBaseMeleeDamage")
        transformBaseArmor = JMap.getFlt(jObj, "transformBaseArmor")
        transformBaseMagicResist = JMap.getFlt(jObj, "transformBaseMagicResist")
    ; Save Transform Buffs Per Rank
        transformHealthPerRank = JMap.getFlt(jObj, "transformHealthPerRank")
        transformStaminaPerRank = JMap.getFlt(jObj, "transformStaminaPerRank")
        transformMagickaPerRank = JMap.getFlt(jObj, "transformMagickaPerRank")
        transformCarryWeightPerRank = JMap.getFlt(jObj, "transformCarryWeightPerRank")
        transformMeleeDamagePerRank = JMap.getFlt(jObj, "transformMeleeDamagePerRank")
        transformArmorPerRank = JMap.getFlt(jObj, "transformArmorPerRank")
        transformMagicResistPerRank = JMap.getFlt(jObj, "transformMagicResistPerRank")
    JValue.release(jObj)
    SendConfigUpdateEvent()
EndFunction