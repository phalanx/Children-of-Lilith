Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil
CoL_Mechanic_DrainHandler_Script Property drainHandler Auto
CoL_Mechanic_HungerHandler_Script Property hungerHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Mechanic_VampireHandler_Script Property vampireHandler Auto
CoL_UI_Widget_Script  Property widgetHandler Auto
CoL_Interface_SLAR_Script Property SLAR Auto
CoL_Interface_OAroused_Script Property OAroused Auto

; Keyword Definitions
Keyword Property ddLibs Auto Hidden
Keyword Property toysToy Auto Hidden
Keyword Property BBBNoStrip Auto Hidden

GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus
GlobalVariable Property GameDaysPassed Auto

Actor Property playerRef Auto                       ; The player reference
Spell Property drainHealthSpell Auto                ; The spell that's applied to drain victims
Spell[] Property levelOneSpells Auto                ; Spells granted to player as a level one succubus
Spell[] Property levelTwoSpells Auto                ; Spells granted to player as a level two succubus
Spell[] Property levelFiveSpells Auto                ; Spells granted to player as a level five succubus
Spell[] Property levelTenSpells Auto                ; Spells granted to player as a level ten succubus
bool Property DebugLogging = true Auto Hidden       ; Enable trace logging throughout the scripts

; Hotkeys
int toggleDrainHotKey_var = 29
int Property toggleDrainHotkey Hidden     ; Default Toggle Drain key to left shift
    int Function Get()
        return toggleDrainHotkey_var 
    EndFunction
    Function Set(int newKey)
        UnregisterForKey(toggleDrainHotKey_var)
        toggleDrainHotKey_var = newKey
        RegisterForKey(toggleDrainHotKey_var)
    EndFunction
EndProperty

int toggleDrainToDeathHotKey_var = 157
int Property toggleDrainToDeathHotkey Hidden    ; Default Toggle Drain to Death key to right alt
    int Function Get()
        return toggleDrainToDeathHotkey_var 
    EndFunction
    Function Set(int newKey)
        UnregisterForKey(toggleDrainToDeathHotKey_var)
        toggleDrainToDeathHotKey_var = newKey
        RegisterForKey(toggleDrainToDeathHotKey_var)
    EndFunction
EndProperty

; Energy Properties
float playerEnergyCurrent_var = 50.0
float Property playerEnergyCurrent Hidden
    float Function Get()
        return playerEnergyCurrent_var
    EndFunction
    Function Set(float newVal)
        if newVal > playerEnergyMax
            newVal = playerEnergyMax
        elseif newVal < 0
            newVal = 0
        endif
        playerEnergyCurrent_var = newVal
        if DebugLogging
            Debug.Trace("[CoL] Player Energy is now " + playerEnergyCurrent)
        endif
        widgetHandler.GoToState("UpdateMeter")
    EndFunction
EndProperty
float Property playerEnergyMax = 100.0 Auto Hidden
bool hungerEnabled_var
bool Property hungerEnabled Hidden
    bool Function Get()
        return hungerEnabled_var
    EndFunction
    Function Set(bool newValue)
        hungerEnabled_var = newValue
        if hungerEnabled_var
            hungerHandler.GoToState("HungerEnabled")
        else
            hungerHandler.GoToState("HungerDisabled")
        endif
    EndFunction
EndProperty
float Property dailyHungerAmount = 10.0 Auto Hidden
bool Property hungerDamageEnabled = false Auto Hidden
float Property hungerDamageAmount = 5.0 Auto Hidden

; Drain Properties
float Property drainDurationInGameTime = 24.0 Auto Hidden   ; How long, in game hours, does the drain debuff last
float Property healthDrainMult = 0.2 Auto Hidden            ; Percentage of health to drain from victim (Health Drained = Victim Max Health * Mult)
float Property drainArousalMult = 0.1 Auto Hidden           ; Multiplier applied to arousal before being added to drain amount
float Property drainToDeathMult = 2.0 Auto Hidden           ; Multiplier applied energy conversion when victim is drained to death
float Property energyConversionRate = 0.5 Auto Hidden       ; Rate at which drained health is converted to Energy
bool Property drainFeedsVampire = true Auto Hidden          ; Should draining trigger a vampire feeding
bool Property drainNotificationsEnabled = true Auto Hidden  ; Should notifications play when drain style is changed

; Power Properties
float Property becomeEtherealCost  = 10.0 Auto Hidden   ; Per second Energy Cost of Stamina Boost Effect
float Property healRateBoostCost = 5.0 Auto Hidden      ; Per second Energy Cost of Stamina Boost Effect
float Property healRateBoostMult = 10.0 Auto Hidden     ; Multiply HealRate value by this then add it to the max. (New Healrate = Current + Current * Mult)
bool Property healRateBoostFlat = false Auto Hidden     ; If true, apply healRateBoostMult as a flat amount instead of a multiplier
float Property energyCastingMult = 1.0 Auto  Hidden     ; Modify the energy cost of spells
int Property energyCastingConcStyle = 1 Auto Hidden     ; 0: Calculate only Left hand, ; 1: Both hands ; 2: Right Hand ; Anything else: Don't calculate

; Togglable Spells
Spell Property becomeEthereal Auto                    ; Spell that contains the stamina boost effect
Spell Property healRateBoost Auto                   ; Spell that contains the healrate boost effect
Spell Property energyCastingToggleSpell Auto     ; The spell that toggles energy for magicka perk. Used to resolve a race condition
Perk Property energyCastingPerk Auto             ; The perk that reduces magicka cost to 0 and gets detected for causing energy drain

; Spell Properties
int Property excitementCost = 10 Auto Hidden
int Property excitementBaseIncrease = 1 Auto Hidden
float Property excitementLevelMult = 1.0 Auto Hidden

int Property suppressionCost = 10 Auto Hidden
int Property suppressionBaseIncrease = 1 Auto Hidden
float Property suppressionLevelMult = 1.0 Auto Hidden

int Property temptationCost = 10 Auto Hidden
int Property temptationBaseIncrease = 1 Auto Hidden
float Property temptationLevelMult = 1.0 Auto Hidden

; Perk Stuff
int Property availablePerkPoints = 0 Auto Hidden
bool Property gentleDrainer = false Auto Hidden      ; Perk that reduces base drain duration by half
int Property efficientFeeder = 0 Auto Hidden         ; Ranked perk that increases health conversion rate
int Property energyStorage = 0 Auto Hidden           ; Ranked perk that increases max energy amount
bool Property energyWeaver = false Auto Hidden       ; Perk that reduces cost of Energy Casting. Reduce further when transformed
bool Property healingForm = false Auto Hidden        ; Perk that adds Heal Rate Boost to transformed form
bool Property safeTransformation = false Auto Hidden ; Perk that turns you ethereal while transforming
bool Property slakeThirst = false Auto Hidden        ; Perk that applies succubus arousal to drain amount

; Transform Stuff
Spell Property transformSpell Auto
bool Property isTransformed Auto Hidden
bool Property transformSwapsEquipment = true Auto Hidden
bool Property succuPresetSaved = false Auto Hidden
string Property succuPresetName = "CoL_Succubus_Form" Auto Hidden
Race Property succuRace Auto Hidden
ColorForm Property succuHairColor Auto Hidden
bool Property transformCrime = false Auto Hidden
bool Property transformAnimation = true Auto Hidden

bool Property mortalPresetSaved = false Auto Hidden
string Property mortalPresetName = "CoL_Mortal_Form" Auto Hidden
Race Property mortalRace Auto Hidden
ColorForm Property mortalHairColor Auto Hidden

Form[] Property NoStripList Auto Hidden
ObjectReference Property succuEquipmentChest Auto

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        if DebugLogging
            Debug.Trace("[CoL] Initializing")
        endif
        widgetHandler.GoToState("Initialize")
        levelHandler.GoToState("Initialize")
        isPlayerSuccubus.SetValue(1.0)
        GotoState("Running")
    EndEvent
EndState

State Running
    Event OnBeginState()
        Maintenance()
    EndEvent
    
    Function Maintenance()
        if DebugLogging
            Debug.Trace("[CoL] Maintenance running")
        endif
        if Game.IsPluginInstalled("Devious Devices - Assets.esm")
            ddLibs = Game.GetFormFromFile(0x003894, "Devious Devices - Assets.esm") as Keyword
        endif
        if Game.IsPluginInstalled("Toys.esm")
            toysToy = Game.GetFormFromFile(0x000815, "Toys.esm") as Keyword
        endif
        if Game.IsPluginInstalled("3BBB.esp")
            BBBNoStrip = Game.GetFormFromFile(0x000848, "3BBB.esp") as Keyword
        endif
        Debug.Trace(BBBNoStrip)
        widgetHandler.GoToState("Running")
        drainHandler.GoToState("Initialize")
        levelHandler.GoToState("Running")
        RegisterForEvents()
    EndFunction

EndState

State SceneRunning
    Event onBeginState()
        if DebugLogging
            Debug.Trace("[CoL] Entered SceneRunning State")
        endif
    EndEvent
    Event OnKeyDown(int keyCode)
        if DebugLogging
            Debug.Trace("[CoL] KeyDown Detected")
            Debug.Trace("[CoL] Detected Key: " + keyCode)
        endif
        if keyCode == toggleDrainHotkey
            drainHandler.draining = !drainHandler.draining
        elseif keyCode == toggleDrainToDeathHotkey
            drainHandler.drainingToDeath = !drainHandler.drainingToDeath
        endif
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        widgetHandler.GoToState("Uninitialize")
        levelHandler.GoToState("Uninitialize")
        drainHandler.GoToState("Uninitialize")
        UnregisterForEvents()

        int uninitEvent = ModEvent.Create("CoL_Uninitialize")
        ModEvent.Send(uninitEvent)
        isPlayerSuccubus.SetValue(0.0)
        GoToState("")
    EndEvent
EndState

Function GrantSpells(Spell[] spellList)
    int i = 0
    while i < spellList.Length
        playerRef.AddSpell(spellList[i])
        i += 1
    endwhile
EndFunction

Function RemoveSpells(Spell[] spellList)
    int i = 0
    while i < spellList.Length
        playerRef.RemoveSpell(spellList[i])
        i += 1
    endwhile
EndFunction

Function Maintenance()
EndFunction

Function RegisterForEvents()
    ; Register for Hotkeys
    RegisterForKey(toggleDrainHotKey)
    RegisterForKey(toggleDrainToDeathHotKey)
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
    if DebugLogging
        Debug.Trace("[CoL] Registered for Hotkeys and Events")
    endif
EndFunction

Function UnregisterForEvents()
    ; Register for Hotkeys
    UnregisterForKey(toggleDrainHotKey_var)
    UnregisterForModEvent("CoL_startScene")
    UnregisterForModEvent("CoL_endScene")
    if DebugLogging
        Debug.Trace("[CoL] Unregistered for Hotkeys and Events")
    endif
EndFunction

Function StartScene()
    GoToState("SceneRunning")
EndFunction

Function EndScene()
    GoToState("")
EndFunction

bool Function IsStrippable(Form itemRef)
    if !ddLibs || !itemRef.hasKeyword(ddLibs) ; Make sure it's not a devious device
        if !toysToy || !itemRef.hasKeyword(toysToy) ; Make sure it's not a Toys Framework toy
            if !BBBNoStrip || !itemRef.hasKeyword(BBBNoStrip) ; Make sure it doesn't have 3BBB's NoStrip Keyword
                return True
            endif
        endif
    endif
    return false
endFunction

Event OnKeyDown(int keyCode)
EndEvent