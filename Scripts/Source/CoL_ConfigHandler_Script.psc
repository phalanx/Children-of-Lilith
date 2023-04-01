Scriptname CoL_ConfigHandler_Script extends Quest

float Property baseMaxEnergy = 100.0 Auto Hidden                ; Base line maximum energy, before perks are applied
string[] Property followedPathOptions Auto Hidden               ; Holds available path options
int Property selectedPath = 0 Auto Hidden                       ; Which path is the player following
bool Property DebugLogging = false Auto Hidden                  ; Are debug logs enabled
bool Property EnergyScaleTestEnabled = false Auto Hidden        ; Is the energy scale test enabled
bool Property npcSuccubusEnabled = false Auto Hidden            ; Are NPC succubi enabled

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

; NPC Drain Settings
int Property npcDrainToDeathChance = 0 Auto Hidden              ; Percentage chance for npc succubi to drain a victim to death

; Levelling Settings
float Property xpConstant = 0.3 Auto Hidden
float Property xpPower = 1.5 Auto Hidden
int Property levelsForPerk = 1 Auto Hidden
int Property perkPointsRecieved = 1 Auto Hidden
float Property xpPerDrain = 0.0 Auto Hidden
float Property xpDrainMult = 0.5 Auto Hidden
float Property drainToDeathXPMult = 2.0 Auto Hidden
int Property extraXP = 0 Auto Hidden

; Hunger Settings
bool Property hungerEnabled Auto Hidden
bool Property hungerIsPercent = false Auto Hidden
float Property dailyHungerAmount = 10.0 Auto Hidden
bool Property deadlyHunger = false Auto Hidden
float Property hungerDamageAmount = 5.0 Auto Hidden
bool Property hungerArousalEnabled = false Auto Hidden
float Property hungerArousalAmount = 5.0 Auto Hidden
int Property hungerThreshold = 10 Auto Hidden

; Tattoo Fade
bool Property tattooFade = false Auto Hidden
int Property tattooSlot = 6 Auto Hidden

; Power Settings
float Property becomeEtherealCost  = 10.0 Auto Hidden   ; Per second Energy Cost of Succubus Become Ethereal
float Property healRateBoostCost = 5.0 Auto Hidden      ; Per second Energy Cost of Succubus HealRate Boost
float Property healRateBoostAmount = 10.0 Auto Hidden   ; Modify healRate by this amount
float Property energyCastingMult = 1.0 Auto Hidden      ; Modify the energy cost of spells
string[] Property energyCastingConcStyleOptions Auto Hidden
int Property energyCastingConcStyle = 1 Auto Hidden     ; 0: Calculate only Left hand, ; 1: Both hands ; 2: Right Hand ; Anything else: Don't calculate

int Property excitementCost = 10 Auto Hidden
int Property excitementBaseIncrease = 1 Auto Hidden
float Property excitementLevelMult = 1.0 Auto Hidden

int Property suppressionCost = 10 Auto Hidden
int Property suppressionBaseIncrease = 1 Auto Hidden
float Property suppressionLevelMult = 1.0 Auto Hidden

int Property temptationCost = 10 Auto Hidden
int Property temptationBaseIncrease = 1 Auto Hidden
float Property temptationLevelMult = 1.0 Auto Hidden

; Hotkey Settings
int Property toggleDrainHotkey = 29 Auto Hidden     ; Default Toggle Drain key to left shift
int Property toggleDrainToDeathHotkey = 157 Auto Hidden    ; Default Toggle Drain to Death key to right alt
int Property transformHotkey = -1 Auto Hidden    ; Default Toggle Drain to Death key to right alt
int Property temptationHotkey = -1 Auto Hidden    ; Default Toggle Drain to Death key to right alt

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
float Property transformArousalUpperThreshold Auto Hidden
float Property transformArousalLowerThreshold Auto Hidden
bool Property transformBuffsEnabled Auto Hidden

; Transform Baseline Buffs
float Property transformBaseHealth Auto Hidden
float Property transformBaseStamina Auto Hidden
float Property transformBaseMagicka Auto Hidden
float Property transformBaseCarryWeight Auto Hidden
float Property transformBaseMeleeDamage Auto Hidden
float Property transformBaseArmor Auto Hidden
float Property transformBaseMagicResist Auto Hidden

; Transform buffs per rank
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