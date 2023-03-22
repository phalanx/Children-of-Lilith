Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil
import CharGen

Quest Property playerSuccubusQuest Auto
CoL_ConfigHandler_Script configHandler

CoL_Mechanic_DrainHandler_Script Property drainHandler Auto
CoL_Mechanic_HungerHandler_Script Property hungerHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_Mechanic_VampireHandler_Script Property vampireHandler Auto
CoL_Mechanic_Arousal_Transform Property arousalTransformHandler Auto
CoL_UI_Widget_Script  Property widgetHandler Auto
CoL_Interface_SLAR_Script Property SLAR Auto
CoL_Interface_OAroused_Script Property OAroused Auto
CoL_Interface_Toys_Script Property Toys Auto
CoL_Interface_OStim_Script Property oStim Auto
CoL_Interface_OSL_Script Property OSL Auto
CoL_Interface_SexLab_Script Property SexLab Auto
CoL_Interface_SlaveTats_Script Property iSlaveTats Auto
CoL_Uninitialize_Quest_Script Property uninitializeQuest Auto
CoL_NpcSuccubusQuest_Script Property npcSuccubusQuest Auto

; Advancement Settings
int Property availablePerkPoints = 0 Auto Hidden
bool Property gentleDrainer = false Auto Hidden      ; Perk that reduces base drain duration by half
int Property efficientFeeder = 0 Auto Hidden         ; Ranked perk that increases health conversion rate
int Property energyStorage = 0 Auto Hidden           ; Ranked perk that increases max energy amount
bool Property energyWeaver = false Auto Hidden       ; Perk that reduces cost of Energy Casting. Reduce further when transformed
bool Property healingForm = false Auto Hidden        ; Perk that adds Heal Rate Boost to transformed form
bool Property safeTransformation = false Auto Hidden ; Perk that turns you ethereal while transforming
bool Property slakeThirst = false Auto Hidden        ; Perk that applies succubus arousal to drain amount

; Keyword Definitions
Keyword Property ddLibs Auto Hidden
Keyword Property toysToy Auto Hidden
Keyword Property BBBNoStrip Auto Hidden

GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property TimeScale Auto

Faction Property drainVictimFaction Auto

Actor Property playerRef Auto                       ; The player reference
Spell Property drainHealthSpell Auto                ; The spell that's applied to drain victims

Spell[] Property levelOneSpells Auto                ; Spells granted to player as a level one succubus
Spell[] Property levelTwoSpells Auto                ; Spells granted to player as a level two succubus
Spell[] Property levelFiveSpells Auto               ; Spells granted to player as a level five succubus
Spell[] Property levelTenSpells Auto                ; Spells granted to player as a level ten succubus
Spell Property sceneHandlerSpell Auto               ; Spell that contains the animation scene handlers
Spell Property temptationSpell Auto                 ; Succubus Temptation spell for hotkey

Spell[] Property sanguineTraits Auto                ; Spells to provide passives for Path of Sanguine
Spell[] Property molagTraits Auto                   ; Spells to provide passives for Path of Molag Bal
Spell[] Property vaerminaTraits Auto                ; Spells to provide passives for Path of Vaermina

; Energy Properties
float playerEnergyCurrent_var = 50.0
float Property playerEnergyCurrent Hidden
    float Function Get()
        return playerEnergyCurrent_var
    EndFunction
    Function Set(float newVal)
        if newVal > playerEnergyMax
            newVal = playerEnergyMax as float
        elseif newVal < 0
            newVal = 0
        endif
        playerEnergyCurrent_var = newVal
        Log("Player Energy is now " + playerEnergyCurrent)
        widgetHandler.GoToState("UpdateMeter")
        if configHandler.tattooFade
            UpdateTattoo()
        endif
        float energyPercentage = ((newVal / playerEnergyMax) * 100) 
        if  energyPercentage <= configHandler.forcedDrainToDeathMinimum && configHandler.forcedDrainToDeathMinimum != -1
            drainHandler.draining = false
            drainHandler.drainingToDeath = true
        elseif energyPercentage <= configHandler.forcedDrainMinimum && configHandler.forcedDrainMinimum != -1
            drainHandler.draining = true
            drainHandler.drainingToDeath = false
        elseif configHandler.forcedDrainMinimum != -1 && configHandler.forcedDrainToDeathMinimum != -1
            drainHandler.draining = false
            drainHandler.drainingToDeath = false
        endif
    EndFunction
EndProperty
float Property playerEnergyMax = 100.0 Auto Hidden

; Togglable Spells
Spell Property becomeEthereal Auto                    ; Spell that contains the stamina boost effect
Spell Property healRateBoost Auto                   ; Spell that contains the healrate boost effect
Spell Property energyCastingToggleSpell Auto     ; The spell that toggles energy for magicka perk. Used to resolve a race condition
Perk Property energyCastingPerk Auto             ; The perk that reduces magicka cost to 0 and gets detected for causing energy drain

; Spell Properties

; Perk Stuff

; Transform Stuff
Spell Property transformSpell Auto

bool Property isTransformed Auto Hidden
bool Property lockTransform Auto Hidden
string Property succuPresetName = "CoL_Succubus_Form" Auto Hidden
bool Property succuPresetSaved = false Auto Hidden
Race Property succuRace Auto Hidden
Race Property succuCureRace Auto Hidden
ColorForm Property succuHairColor Auto Hidden
string Property mortalPresetName = "CoL_Mortal_Form" Auto Hidden
bool Property mortalPresetSaved = false Auto Hidden
Race Property mortalRace Auto Hidden
Race Property mortalCureRace Auto Hidden
bool isVampire = false
ColorForm Property mortalHairColor Auto Hidden
ObjectReference Property succuEquipmentChest Auto


; Transform Buffs
bool Property transformBuffsEnabled Auto Hidden
float Property extraArmor Auto Hidden
float Property extraMagicResist Auto Hidden
float Property extraHealth Auto Hidden
float Property extraMagicka Auto Hidden
float Property extraStamina Auto Hidden
float Property extraMeleeDamage Auto Hidden
float Property extraCarryWeight Auto Hidden

Event OnInit()
    configHandler = playerSuccubusQuest as CoL_ConfigHandler_Script
EndEvent

State Initialize
    Event OnBeginState()
        Log("Initializing")
        mortalPresetName = "CoL_Mortal_Form_" + playerRef.GetDisplayName()
        succuPresetName = "CoL_Succubus_Form_" + playerRef.GetDisplayName()
        widgetHandler.GoToState("Initialize")
        levelHandler.GoToState("Initialize")
        isPlayerSuccubus.SetValue(1.0)
        Maintenance()
        GotoState("Running")
    EndEvent
EndState

State Running
    Event OnKeyDown(int keyCode)
        if configHandler.EnergyScaleTestEnabled
            if keyCode == configHandler.toggleDrainToDeathHotKey
                ScaleEnergyTest()
            endif
        endif
        if keyCode == configHandler.transformHotkey
            transformSpell.Cast(playerRef, playerRef)
        endif
    EndEvent
EndState

State SceneRunning
    Event onBeginState()
        Log("Entered SceneRunning State")
    EndEvent

    Event OnKeyDown(int keyCode)
        if keyCode == configHandler.toggleDrainHotkey
            if configHandler.lockDrainType
                return
            endif
            drainHandler.draining = !drainHandler.draining
        elseif keyCode == configHandler.toggleDrainToDeathHotkey
            if configHandler.lockDrainType
                return
            endif
            drainHandler.drainingToDeath = !drainHandler.drainingToDeath
        endif
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        widgetHandler.GoToState("Uninitialize")
        levelHandler.GoToState("Uninitialize")
        drainHandler.GoToState("Uninitialize")
        uninitializeQuest.GoToState("Run")
        UnregisterForEvents()

        RemoveSpells(sanguineTraits)
        RemoveSpells(molagTraits)
        RemoveSpells(VaerminaTraits)

        int uninitEvent = ModEvent.Create("CoL_Uninitialize")
        ModEvent.Send(uninitEvent)
        isPlayerSuccubus.SetValue(0.0)

        GoToState("")
    EndEvent
EndState

Function GrantSpells(Spell[] spellList, bool verbose = true)
    int i = 0
    while i < spellList.Length
        playerRef.AddSpell(spellList[i], verbose)
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
    Log("Maintenance running")
    if Game.IsPluginInstalled("Devious Devices - Assets.esm")
        ddLibs = Game.GetFormFromFile(0x003894, "Devious Devices - Assets.esm") as Keyword
    endif
    if Game.IsPluginInstalled("Toys.esm")
        toysToy = Game.GetFormFromFile(0x000815, "Toys.esm") as Keyword
    endif
    if Game.IsPluginInstalled("3BBB.esp")
        BBBNoStrip = Game.GetFormFromFile(0x000848, "3BBB.esp") as Keyword
    endif
    widgetHandler.GoToState("Running")
    drainHandler.GoToState("Initialize")
    levelHandler.GoToState("Running")
    RegisterForEvents()
EndFunction

Function RegisterForHotkeys()
    RegisterForKey(configHandler.toggleDrainHotKey)
    RegisterForKey(configHandler.toggleDrainToDeathHotKey)
    RegisterForKey(configHandler.transformHotkey)
EndFunction

Function RegisterForEvents()
    ; Register for Events
    RegisterForHotkeys()
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
    Log("Registered for Hotkeys and Events")
EndFunction

Function UnregisterForHotkeys()
    UnregisterForKey(configHandler.toggleDrainHotKey)
    UnregisterForKey(configHandler.toggleDrainToDeathHotKey)
    UnregisterForKey(configHandler.transformHotkey)
EndFunction

Function UnregisterForEvents()
    ; Register for Hotkeys
    UnregisterForHotkeys()
    UnregisterForModEvent("CoL_startScene")
    UnregisterForModEvent("CoL_endScene")
    Log("Unregistered for Hotkeys and Events")
EndFunction

Function StartScene()
    GoToState("SceneRunning")
EndFunction

Function EndScene()
    GoToState("Running")
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

Function UpdateTattoo()
    Float newAlpha = playerEnergyCurrent/playerEnergyMax
    int correctedSlot = configHandler.tattooSlot - 1
    string bodySlot = "Body [Ovl" + correctedSlot + "]"
    NiOverride.AddNodeOverrideFloat(playerRef, true, bodySlot, 8, -1, newAlpha, true)
EndFunction

Function ScaleEnergyTest()
    float currentEnergy = playerEnergyCurrent
    playerEnergyCurrent = 0
    while playerEnergyCurrent < playerEnergyMax
        playerEnergyCurrent += 10
        Utility.Wait(0.1)
    endwhile
    while playerEnergyCurrent > 0
        playerEnergyCurrent -= 10
        Utility.Wait(0.1)
    endwhile
    playerEnergyCurrent = currentEnergy
EndFunction

Function Log(string msg)
    if configHandler.DebugLogging
        Debug.Trace("[CoL] " + msg)
    endif
EndFunction

Function transformDrain()
    RegisterForSingleUpdate(1)
EndFunction

Event OnUpdate()
    if isTransformed && configHandler.transformCost > 0
        if playerEnergyCurrent > configHandler.transformCost
            playerEnergyCurrent -= configHandler.transformCost
            RegisterForSingleUpdate(1)
        elseif !lockTransform
            playerEnergyCurrent = 0
            Debug.Notification("Out of Energy")
            transformSpell.Cast(playerRef, playerRef)
        endif
    endif
EndEvent

bool Function isBusy()
	if GetState() == "SceneRunning" || Toys.isBusy() || oStim.IsActorActive(playerRef) || SexLab.IsActorActive(playerRef)
		return True
	elseIf playerRef.IsInCombat()
		return True
	elseIf UI.IsMenuOpen("Dialogue Menu")
		return True
	elseIf !Game.IsFightingControlsEnabled() || !Game.IsMovementControlsEnabled() || UI.IsMenuOpen("Crafting Menu") || !playerRef.Is3DLoaded() || StorageUtil.GetIntValue(playerRef, "DCUR_SceneRunning")==1
		return True
	elseIf (Game.GetCameraState() == 10 || playerRef.GetSitState() != 0 || Game.GetCameraState() == 12 || playerRef.IsSwimming())  ;horse/in furniture/dragon/Swimming
		return True
	endIf
	return False
EndFunction

Function savePreset(string presetName)
    if CharGen.IsExternalEnabled()
        CharGen.SaveExternalCharacter(presetName)
    else
        CharGen.SaveCharacter(presetName)
    endif
    CharGen.SavePreset(presetName)
    Log("Finished Saving Preset")
EndFunction

Function transformPlayer(string presetName, Race presetRace, ColorForm presetHairColor)
    Log("Transforming Player")
    int jmorphs
    if configHandler.transformSavesNiOverrides
        jmorphs = __saveBodyMorphs()
    endif
    Race currentRace = playerRef.GetRace()
    if mortalCureRace != None && !isVampire
        isVampire = true
    endif
 
    __Transform(presetName, presetRace, presetHairColor, currentRace)
    Utility.Wait(0.1)
    __Transform(presetName, presetRace, presetHairColor, currentRace)
    Utility.Wait(0.1)

    if configHandler.transformSavesNiOverrides
        __restoreBodyMorphs(jmorphs)
    endif

    iSlaveTats.ReapplySlaveTats(playerRef, true)
    UpdateTattoo()
    Log("Finished Transforming Player")
EndFunction

Function __Transform(string presetName, Race presetRace, ColorForm presetHairColor, Race currentRace)
    playerRef.GetActorbase().SetHairColor(presetHairColor)
   
    if currentRace != presetRace
        playerRef.SetRace(presetRace)
        Utility.Wait(0.1)
        playerRef.SetRace(currentRace)
        Utility.Wait(0.1)
        playerRef.SetRace(presetRace)
        Utility.Wait(0.1)
    endif
    CharGen.LoadPreset(presetName)

    if Chargen.IsExternalEnabled()
        CharGen.LoadExternalCharacter(playerRef, presetRace, presetName)
    else
        CharGen.LoadCharacter(playerRef, presetRace, presetName)
    endif
EndFunction

int function __saveBodyMorphs()
    int jmorphs = JMap.object()
    string[] listmorphNames = NiOverride.GetMorphNames(playerRef)
    int lmn = 0
    while (lmn < listmorphNames.Length)
        int jkeys = JMap.object()
        JMap.setObj(jmorphs, listmorphNames[lmn], jkeys)
        string[] listmorphKeys = NiOverride.GetMorphKeys(playerRef, listmorphNames[lmn])
        int lmk = 0
        while (lmk < listmorphKeys.Length)
            JMap.setFlt(jkeys, listmorphKeys[lmk], NiOverride.GetBodyMorph(playerRef, listmorphNames[lmn], listmorphKeys[lmk]))
            lmk += 1
        endWhile
        lmn += 1
    endWhile
    return jmorphs
endfunction

function __restoreBodyMorphs(int jmorphs)
    string jmkey = JMap.nextKey(jmorphs, previousKey="", endKey="")
    bool restored = false
    while jmkey != ""
        int jkeys = JMap.getObj(jmorphs, jmkey)
        string jkkey = JMap.nextKey(jkeys, previousKey="", endKey="")
        while jkkey != ""
            float v = JMap.getFlt(jkeys, jkkey)
            Log(jmkey + " | " + jkkey + " :=: " + v)
            NiOverride.SetBodyMorph(playerRef, jmkey, jkkey, v)
            restored = true
            jkkey = JMap.nextKey(jkeys, jkkey, endKey="")
        endwhile
        jmkey = JMap.nextKey(jmorphs, jmkey, endKey="")
    endwhile
    JValue.release(jmorphs)
    if (restored)
        NiOverride.UpdateModelWeight(playerRef)
    endif
endfunction

Function ApplyRankedPerks()
    int i = 0
    while i < efficientFeeder
        configHandler.energyConversionRate += 0.1
        i += 1
    endwhile

    i = 0
    playerEnergyMax = configHandler.baseMaxEnergy
    while i < energyStorage
        playerEnergyMax += 10
        i += 1
    endwhile
EndFunction

Function UpdatePath()
    RemoveSpells(sanguineTraits)
    RemoveSpells(molagTraits)
    RemoveSpells(VaerminaTraits)
    if configHandler.selectedPath == 0
        GrantSpells(sanguineTraits, false)
        Debug.Notification("Path of Sanguine added")
    elseif configHandler.selectedPath == 1
        GrantSpells(molagTraits, false)
        Debug.Notification("Path of Molag Bal added")
    elseif configHandler.selectedPath == 2
        GrantSpells(VaerminaTraits, false)
        Debug.Notification("Path of Vaermina added")
    endif
EndFunction