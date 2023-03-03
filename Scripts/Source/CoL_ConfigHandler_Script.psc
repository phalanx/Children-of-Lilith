Scriptname CoL_ConfigHandler_Script extends Quest

float Property baseMaxEnergy = 100.0 Auto Hidden                ;Base line maximum energy, before perks are applied
string[] Property followedPathOptions Auto Hidden               ;Holds available path options
int Property selectedPath = 0 Auto Hidden                       ;Which path is the player following
bool Property DebugLogging = false Auto Hidden                  ;Are debug logs enabled
bool Property EnergyScaleTestEnabled = false Auto Hidden        ;Is the energy scale test enabled
bool Property npcSuccubusEnabled = false Auto Hidden            ;Are NPC succubi enabled

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
float Property xpConstant = 0.75 Auto Hidden
float Property xpPower = 1.5 Auto Hidden
int Property levelsForPerk = 1 Auto Hidden
int Property perkPointsRecieved = 1 Auto Hidden
float Property xpPerDrain = 1.0 Auto
float Property drainToDeathXPMult = 2.0 Auto

Event OnInit()
    followedPathOptions = new string[3]
    followedPathOptions[0] = "$COL_STATUSPAGE_PATH_SANQUINE"
    followedPathOptions[1] = "$COL_STATUSPAGE_PATH_MOLAG"
    followedPathOptions[2] = "$COL_STATUSPAGE_PATH_VAERMINA"
EndEvent