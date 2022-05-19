Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil
CoL_Mechanic_DrainHandler_Script Property drainHandler Auto

Actor Property playerRef Auto                       ; The player reference
Spell Property drainHealthSpell Auto                ; The spell that's applied to drain victims
Actor[] Property activeDrainVictims Auto Hidden     ; List of active drain victims. Hopefully useful for uninstall process. 
Spell[] Property levelOneSpells Auto                ; Spells granted to player as  a level one succubus
bool Property DebugLogging = true Auto Hidden       ; Enable trace logging throughout the scripts

; Hotkeys
int toggleDrainHotKey_var = 29
int Property toggleDrainHotkey     ; Default Toggle Drain key to left shift
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
int Property toggleDrainToDeathHotkey     ; Default Toggle Drain to Death key to right alt
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
float playerEnergyCurrent_var = 0.0
float Property playerEnergyCurrent Hidden
    float Function Get()
        return playerEnergyCurrent_var
    EndFunction
    Function Set(float newVal)
        if newVal > playerEnergyMax
            newVal = playerEnergyMax
        endif
        playerEnergyCurrent_var = newVal
        if DebugLogging
            Debug.Trace("[CoL] Player Energy is now " + playerEnergyCurrent)
        endif
    EndFunction
EndProperty
float Property playerEnergyMax = 100.0 Auto Hidden

; MCM Tunable Drain Properties
float Property drainDurationInGameTime = 24.0 Auto Hidden   ; How long, in game hours, does the drain debuff last
float Property healthDrainMult = 0.2 Auto Hidden            ; Percentage of health to drain from victim (Health Drained = Victim Max Health * Mult)
float Property drainToDeathMult = 2.0 Auto
float Property energyConversionRate = 0.5 Auto Hidden       ; Rate at which drained health is converted to Energy

; MCM Tunable Power Values
float Property becomeEtherealCost  = 10.0 Auto Hidden      ; Per second Energy Cost of Stamina Boost Effect
float Property healRateBoostCost = 5.0 Auto Hidden      ; Per second Energy Cost of Stamina Boost Effect
float Property healRateBoostMult = 10.0 Auto Hidden      ; Multiply HealRate value by this then add it to the max. (New Healrate = Current + Current * Mult)
float Property energyCastingMult = 1.0 Auto

; Togglable Spells
Spell Property becomeEthereal Auto                    ; Spell that contains the stamina boost effect
Spell Property healRateBoost Auto                   ; Spell that contains the healrate boost effect
Spell Property energyCastingToggleSpell Auto     ; The spell that toggles energy for magicka perk. Used to resolve a race condition
Perk Property energyCastingPerk Auto             ; The perk that reduces magicka cost to 0 and gets detected for causing energy drain

Event OnInit()
EndEvent

State Initialize
    Event OnBeginState()
        if DebugLogging
            Debug.Trace("[CoL] Initializing")
        endif
        GrantSpells()
        Maintenance()
        GotoState("")
    EndEvent
EndState

State SceneRunning
    Event OnKeyDown(int keyCode)
        if keyCode == toggleDrainHotkey
            drainHandler.draining = !drainHandler.draining
        elseif keyCode == toggleDrainToDeathHotkey
            drainHandler.drainingToDeath = !drainHandler.drainingToDeath
        endif
    EndEvent
EndState


Function GrantSpells()
    int i = 0
    while i < levelOneSpells.Length
        playerRef.AddSpell(levelOneSpells[i])
        i += 1
    endwhile
EndFunction

Function Maintenance()
    drainHandler.GoToState("Maintenance")
    RegisterForEvents()
EndFunction

Function RegisterForEvents()
    ; Register for Hotkeys
    RegisterForKey(toggleDrainHotKey_var)
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
    if DebugLogging
        Debug.Trace("[CoL] Registered for Hotkeys")
    endif
EndFunction

Function StartScene()
    GoToState("SceneRunning")
EndFunction

Function EndScene()
    GoToState("")
EndFunction

Function AddActiveDrainVictim(Actor drainVictim)
    if DebugLogging
        Debug.Trace("[CoL] Adding Victim to activeDrainList")
    endif

    activeDrainVictims = PushActor(activeDrainVictims, drainVictim)

    if DebugLogging
        Debug.Trace("[CoL] List now contains:")
        int i = 0
        while i < activeDrainVictims.Length
            Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
            i += 1
        endwhile
    endif
EndFunction

Function RemoveActiveDrainVictim(Actor drainVictim)
    if DebugLogging
        Debug.Trace("[CoL] Removing Victim from activeDrainList")
    endif

    activeDrainVictims = RemoveActor(activeDrainVictims, drainVictim)
    
    if DebugLogging
        Debug.Trace("[CoL] List now contains:")
        int i = 0
        while i < activeDrainVictims.Length
            Debug.Trace("[CoL] " + (activeDrainVictims[i].GetBaseObject() as ActorBase).GetName())
            i += 1
        endwhile
    endif
EndFunction

Event OnKeyDown(int keyCode)
EndEvent