Scriptname CoL_PlayerSuccubusQuestScript extends Quest  

import PapyrusUtil
import CharGen

CoL_ConfigHandler_Script Property configHandler Auto 

Spell Property drainHandler Auto
CoL_Mechanic_LevelHandler_Script Property levelHandler Auto
CoL_UI_Widget_Script  Property widgetHandler Auto
CoL_Mechanic_EnergyHandler_Script Property energyHandler Auto
CoL_Interface_Toys_Script Property Toys Auto
CoL_Interface_OStim_Script Property oStim Auto
CoL_Interface_SexLab_Script Property SexLab Auto
CoL_Interface_SlaveTats_Script Property iSlaveTats Auto
CoL_Interface_SLCumOverlay_Script Property iSLCumOverlay Auto
CoL_Uninitialize_Quest_Script Property uninitializeQuest Auto
CoL_NpcSuccubusQuest_Script Property npcSuccubusQuest Auto

; Keyword Definitions
Keyword Property ddLibs Auto Hidden
Keyword Property toysToy Auto Hidden
Keyword Property BBBNoStrip Auto Hidden

GlobalVariable Property isPlayerSuccubus Auto ; Controls if the player is a succubus
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property TimeScale Auto

Faction Property drainVictimFaction Auto

Actor Property playerRef Auto                       ; The player reference
Spell Property showperkMenu Auto                    ; Spell that when cast will open the CSF perk menu
Spell Property simpleTransform Auto                 ; Spell that will provide the vfx and sfx for scene start transform

Spell[] Property sceneHandlerSpells Auto            ; Spells that contain the animation scene handlers
Spell Property hungerSpell Auto                     ; Spell that contains the hunger handler
Spell Property drainHealthSpell Auto                ; The spell that's applied to drain victims
Spell Property StarvationSpell Auto                 ; Spell for stacking hunger effect

Spell[] Property levelOneSpells Auto                ; Spells granted to player as a level one succubus
Spell[] Property levelTwoSpells Auto                ; Spells granted to player as a level two succubus
Spell[] Property levelFiveSpells Auto               ; Spells granted to player as a level five succubus
Spell[] Property levelTenSpells Auto                ; Spells granted to player as a level ten succubus
Spell Property arousalTransformSpell Auto           ; Spell that contains the arousal transform handler
Spell Property temptationSpell Auto                 ; Succubus Temptation spell for hotkey

Spell[] Property sanguineTraits Auto                ; Spells to provide passives for Path of Sanguine
Spell[] Property molagTraits Auto                   ; Spells to provide passives for Path of Molag Bal
Spell[] Property vaerminaTraits Auto                ; Spells to provide passives for Path of Vaermina

; Togglable Spells
    Spell Property becomeEthereal Auto                    ; Spell that contains the stamina boost effect
    Spell Property healRateBoost Auto                   ; Spell that contains the healrate boost effect
    Spell Property energyCastingToggleSpell Auto     ; The spell that toggles energy for magicka perk. Used to resolve a race condition
    Perk Property energyCastingPerk Auto             ; The perk that reduces magicka cost to 0 and gets detected for causing energy drain

bool Property isTransformed Auto Hidden
bool Property isTransforming = false Auto Hidden
; 0: FX
; 1:Body
; 2: Equipment
; 3: Powers
bool[] Property transformReadiness Auto Hidden    

; Transform Stuff
    Spell Property transformSpell Auto
     
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

; Perk Ranks
    int Property efficientFeeder = 0 Auto Hidden         ; Ranked perk that increases health conversion rate
    int Property energyStorage = 0 Auto Hidden           ; Ranked perk that increases max energy amount

; Transform Buff Ranks
; 0 - health
; 1 - stamina
; 2 - magicka
; 3 - carry weight
; 4 - melee damage
; 5 - armor
; 6 - magic resist
int[] Property transformBuffs Auto Hidden

Event OnInit()
    transformBuffs = new int[7]
    transformBuffs[0] = 0
    transformBuffs[1] = 0
    transformBuffs[2] = 0
    transformBuffs[3] = 0
    transformBuffs[4] = 0
    transformBuffs[5] = 0
    transformBuffs[6] = 0
    transformReadiness = new bool[4]
    transformReadiness[0] = true
    transformReadiness[1] = true
    transformReadiness[2] = true
    transformReadiness[3] = true
EndEvent

State Initialize
    Event OnBeginState()
        _Log("Initializing")
        mortalPresetName = "CoL_Mortal_Form_" + playerRef.GetDisplayName()
        succuPresetName = "CoL_Succubus_Form_" + playerRef.GetDisplayName()
        isPlayerSuccubus.SetValue(1.0)
        playerRef.AddSpell(drainHandler, false)
        GrantSpells(sceneHandlerSpells, false)
        widgetHandler.Initialize()
        levelHandler.GoToState("Initialize")
        Maintenance()
        configHandler.SendConfigUpdateEvent()
        GotoState("Running")
    EndEvent
EndState

State Running
    Event OnKeyDown(int keyCode)
        if keyCode == configHandler.hotkeys[1]
            if configHandler.EnergyScaleTestEnabled
                ScaleEnergyTest()
            endif
        elseif keyCode == configHandler.hotkeys[2]
            transformSpell.Cast(playerRef, playerRef)
        elseif keyCode == configHandler.hotkeys[4]
            showperkMenu.Cast(playerRef)
        endif
    EndEvent
EndState

State SceneRunning
    Event onBeginState()
        _Log("Entered SceneRunning State")
        if configHandler.transformDuringScene
            _Log("Scene Start Transforming")
            if !isTransformed
                simpleTransform.Cast(playerRef)
                Utility.Wait(2)
                transformPlayer(succuPresetName, succuRace, succuHairColor)
            endif
        endif
    EndEvent

    Event onEndState()
        _Log("Exited SceneRunning State")
        if configHandler.transformDuringScene
            if !isTransformed
                _Log("Scene End Untransforming")
                simpleTransform.Cast(playerRef)
                Utility.Wait(2)
                transformPlayer(mortalPresetName, mortalRace, mortalHairColor)
            endif
        endif
    EndEvent
EndState

State Uninitialize
    Event OnBeginState()
        widgetHandler.Uninitialize()
        levelHandler.GoToState("Uninitialize")
        RemoveSpells(sceneHandlerSpells)
        playerRef.RemoveSpell(drainHandler)
        if playerRef.HasSpell(hungerSpell)
            playerRef.RemoveSpell(hungerSpell)
        endif
        if playerRef.HasSpell(starvationSpell)
            playerRef.RemoveSpell(starvationSpell)
        endif
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
    _Log("Maintenance running")
    if Game.IsPluginInstalled("Devious Devices - Assets.esm")
        ddLibs = Game.GetFormFromFile(0x003894, "Devious Devices - Assets.esm") as Keyword
    endif
    if Game.IsPluginInstalled("Toys.esm")
        toysToy = Game.GetFormFromFile(0x000815, "Toys.esm") as Keyword
    endif
    if Game.IsPluginInstalled("3BBB.esp")
        BBBNoStrip = Game.GetFormFromFile(0x000848, "3BBB.esp") as Keyword
    endif
    widgetHandler.Maintenance()
    levelHandler.GoToState("Running")
    RegisterForEvents()
    Utility.Wait(0.5)
    if mortalPresetSaved && succuPresetSaved
        if !isBeastRace()
            if isTransformed
                transformPlayer(succuPresetName, succuRace, succuHairColor)
            else
                transformPlayer(mortalPresetName, mortalRace, mortalHairColor)
            endif
        endif
    endif
    _Log("Maintenance Done")
EndFunction

Function RegisterForHotkeys()
    RegisterForKey(configHandler.hotkeys[1])
    RegisterForKey(configHandler.hotkeys[2])
    RegisterForKey(configHandler.hotkeys[4])
EndFunction

Function RegisterForEvents()
    RegisterForHotkeys()
    RegisterForModEvent("CoL_startScene", "StartScene")
    RegisterForModEvent("CoL_endScene", "EndScene")
    RegisterForModEvent("CoL_configUpdated", "UpdateConfig")
    _Log("Registered for Hotkeys and Events")
EndFunction

Function UnregisterForHotkeys()
    UnRegisterForKey(configHandler.hotkeys[1])
    UnRegisterForKey(configHandler.hotkeys[2])
    UnRegisterForKey(configHandler.hotkeys[4])
EndFunction

Function UnregisterForEvents()
    ; Register for Hotkeys
    UnregisterForHotkeys()
    UnregisterForModEvent("CoL_startScene")
    UnregisterForModEvent("CoL_endScene")
    _Log("Unregistered for Hotkeys and Events")
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

Function ScaleEnergyTest()
    float currentEnergy = energyHandler.playerEnergyCurrent
    energyHandler.playerEnergyCurrent = 0
    while energyHandler.playerEnergyCurrent < energyHandler.playerEnergyMax
        energyHandler.playerEnergyCurrent += 10
        Utility.Wait(0.1)
    endwhile
    while energyHandler.playerEnergyCurrent > 0
        energyHandler.playerEnergyCurrent -= 10
        Utility.Wait(0.1)
    endwhile
    energyHandler.playerEnergyCurrent = currentEnergy
EndFunction

Function _Log(string msg)
    Log("Player Succubus Quest - " + msg)
EndFunction

Function Log(string msg)
    if configHandler.DebugLogging
        Debug.Trace("[CoL] " + msg)
    endif
EndFunction

bool Function isBeastRace()
    Race currentRace = playerRef.GetRace()
    if MiscUtil.GetRaceEditorID(currentRace) == "WerewolfBeastRace" || MiscUtil.GetRaceEditorID(currentRace) == "DLC1VampireBeastRace"
        return True
    else
        return False
    endif
EndFunction

bool Function isBusy()
    if isBeastRace()
        return True
    endif
    if isTransforming
        return true
    endif
	if GetState() == "SceneRunning" || Toys.isBusy() || oStim.IsActorActive(playerRef) || SexLab.IsActorActive(playerRef)
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
    _Log("Finished Saving Preset")
EndFunction

Function transformPlayer(string presetName, Race presetRace, ColorForm presetHairColor)
    _Log("Transforming Player")
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
    if iSLCumOverlay.IsInterfaceActive()
        iSLCumOverlay.reapplySCOEffects(playerRef)
    endif
    _Log("Finished Transforming Player")
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
            if listmorphKeys[lmk] != "XPMSE.esp" && listmorphKeys[lmk] != "RaceMenuMorphsCBBE.esp"
                JMap.setFlt(jkeys, listmorphKeys[lmk], NiOverride.GetBodyMorph(playerRef, listmorphNames[lmn], listmorphKeys[lmk]))
            endif
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
            _Log(jmkey + " | " + jkkey + " :=: " + v)
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
    energyHandler.playerEnergyMax = configHandler.baseMaxEnergy
    while i < energyStorage
        energyHandler.playerEnergyMax += 10
        i += 1
    endwhile
EndFunction

Function UpdateTattoo()
    Float newAlpha = energyHandler.playerEnergyCurrent/energyHandler.playerEnergyMax
    int correctedSlot = configHandler.tattooSlot - 1
    string bodySlot = "Body [Ovl" + correctedSlot + "]"
    NiOverride.AddNodeOverrideFloat(playerRef, true, bodySlot, 8, -1, newAlpha, true)
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

Function UpdateCSFPower()
    if configHandler.grantCSFPower
        playerRef.AddSpell(showperkMenu)
    else
        playerRef.RemoveSpell(showperkMenu)
    endif
EndFunction

Function UpdateArousalThresholds()
    _Log("Updating Arousal Thresholds")
    if configHandler.transformArousalLowerThreshold == 0 && configHandler.transformArousalUpperThreshold ==0
        if playerRef.HasSpell(arousalTransformSpell)
            playerRef.RemoveSpell(arousalTransformSpell)
        endif
    else
        if !playerRef.HasSpell(arousalTransformSpell)
            playerRef.AddSpell(arousalTransformSpell, false)
        endif
    endif
EndFunction

Function UpdateHunger()
    _Log("Updating Hunger Thresholds")
    if configHandler.hungerEnabled
        playerRef.AddSpell(hungerSpell, false)
    else
        playerRef.RemoveSpell(hungerSpell)
    endif
EndFunction

Function UpdateConfig()
    _Log("Recieved Config Update")
    if isPlayerSuccubus.GetValueInt() != 0
        UnregisterForHotkeys()
        RegisterForHotkeys()
        energyHandler.playerEnergyCurrent = energyHandler.playerEnergyCurrent
        ApplyRankedPerks()
        UpdatePath()
        UpdateCSFPower()
        UpdateArousalThresholds()
        UpdateHunger()
        widgetHandler.UpdateMeter()
    endif
EndFunction