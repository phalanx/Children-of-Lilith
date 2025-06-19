Scriptname CoL_Interface_AnimatedWings extends Quest

CoL_PlayerSuccubusQuestScript Property CoL Auto
CoL_ConfigHandler_Script Property configHandler Auto
Perk Property velvetWings Auto

string[] Property wingsOptions Auto Hidden                      ; Holds available wing options

string wingPluginName = "Animated Wings Ultimate.esp"

Spell selectedWingSpell

Event OnInit()
    RegisterForModEvent("CoL_GameLoad", "OnGameLoad")
    OnGameLoad()
EndEvent

Function Log(string msg)
    CoL.Log("Interface - Animated Wings - " + msg)
EndFunction

Function OnGameLoad()
    Utility.Wait(5)
    wingsOptions = new string[1];
    wingsOptions[0] = "No Wings";
    if Game.IsPluginInstalled(wingPluginName)
        Log("Animated Wings Installed")
        GoToState("Installed")
    else
        Log("Animated Wings Not Installed")
        GoToState("")
    endif
EndFunction

State Installed
    Event OnBeginState()
        Log("Building Wing List")
        wingsOptions = new string[66];
        wingsOptions[0] = "No Wings";
        int i = 1
        while i < wingsOptions.Length
            wingsOptions[i] = GetWings(i).GetNthEffectMagicEffect(0).GetName()
            i += 1
        endWhile
        Log("Done Building Wing List")
        UpdateWings()
    EndEvent

    bool Function IsInterfaceActive()
        return True
    EndFunction

    Spell Function GetWings(int wingId)
        Spell wings = None

        if wingId == 1
            wings = Game.GetFormFromFile(0x9D1, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 2
            wings = Game.GetFormFromFile(0x9D2, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 3
            wings = Game.GetFormFromFile(0x9D3, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 4
            wings = Game.GetFormFromFile(0x9D5, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 5
            wings = Game.GetFormFromFile(0x9D6, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 6
            wings = Game.GetFormFromFile(0x9D7, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 7
            wings = Game.GetFormFromFile(0x9D8, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 8
            wings = Game.GetFormFromFile(0x9D9, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 9
            wings = Game.GetFormFromFile(0x9DA, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 10
            wings = Game.GetFormFromFile(0x9DB, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 11
            wings = Game.GetFormFromFile(0x9DD, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 12
            wings = Game.GetFormFromFile(0x9DE, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 13
            wings = Game.GetFormFromFile(0x9DF, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 14
            wings = Game.GetFormFromFile(0x9E0, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 15
            wings = Game.GetFormFromFile(0x9E1, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 16
            wings = Game.GetFormFromFile(0x9E2, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 17
            wings = Game.GetFormFromFile(0x9E3, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 18
            wings = Game.GetFormFromFile(0x9E4, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 19
            wings = Game.GetFormFromFile(0x9E5, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 20
            wings = Game.GetFormFromFile(0x9E6, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 21
            wings = Game.GetFormFromFile(0x9E7, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 22
            wings = Game.GetFormFromFile(0x9E8, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 23
            wings = Game.GetFormFromFile(0x9E9, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 24
            wings = Game.GetFormFromFile(0x9EB, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 25
            wings = Game.GetFormFromFile(0x9EC, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 26
            wings = Game.GetFormFromFile(0x9EE, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 27
            wings = Game.GetFormFromFile(0x9F6, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 28
            wings = Game.GetFormFromFile(0x9F7, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 29
            wings = Game.GetFormFromFile(0x9F8, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 30
            wings = Game.GetFormFromFile(0x9F9, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 31
            wings = Game.GetFormFromFile(0x9FA, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 32
            wings = Game.GetFormFromFile(0x9FB, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 33
            wings = Game.GetFormFromFile(0x9FC, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 34
            wings = Game.GetFormFromFile(0x9FD, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 35
            wings = Game.GetFormFromFile(0xA01, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 36
            wings = Game.GetFormFromFile(0xA02, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 37
            wings = Game.GetFormFromFile(0xA03, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 38
            wings = Game.GetFormFromFile(0xA04, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 39
            wings = Game.GetFormFromFile(0xA05, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 40
            wings = Game.GetFormFromFile(0xA06, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 41
            wings = Game.GetFormFromFile(0xA12, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 42
            wings = Game.GetFormFromFile(0xA13, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 43
            wings = Game.GetFormFromFile(0xA14, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 44
            wings = Game.GetFormFromFile(0xA20, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 45
            wings = Game.GetFormFromFile(0xA21, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 46
            wings = Game.GetFormFromFile(0xA22, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 47
            wings = Game.GetFormFromFile(0xA23, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 48
            wings = Game.GetFormFromFile(0xA24, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 49
            wings = Game.GetFormFromFile(0xA25, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 50
            wings = Game.GetFormFromFile(0xA26, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 51
            wings = Game.GetFormFromFile(0xA34, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 52
            wings = Game.GetFormFromFile(0xA35, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 53
            wings = Game.GetFormFromFile(0xA36, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 54
            wings = Game.GetFormFromFile(0xA37, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 55
            wings = Game.GetFormFromFile(0xA38, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 56
            wings = Game.GetFormFromFile(0xA39, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 57
            wings = Game.GetFormFromFile(0xA3A, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 58
            wings = Game.GetFormFromFile(0xA3B, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 59
            wings = Game.GetFormFromFile(0xA3C, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 60
            wings = Game.GetFormFromFile(0xA3D, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 61
            wings = Game.GetFormFromFile(0xA3E, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 62
            wings = Game.GetFormFromFile(0xA3F, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 63
            wings = Game.GetFormFromFile(0xA40, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 64
            wings = Game.GetFormFromFile(0xA41, "Animated Wings Ultimate.esp") as Spell
        elseif wingId == 65
            wings = Game.GetFormFromFile(0xA42, "Animated Wings Ultimate.esp") as Spell
        EndIf

        return wings
    EndFunction
    
    Function UpdateWings()
        RemoveWings()
        selectedWingSpell = GetWings(configHandler.selectedWing)
        if CoL.isTransformed
            ApplyWings()
        endif
    EndFunction
    
    Function ApplyWings()
        if selectedWingSpell != None
            if CoL.playerRef.HasPerk(velvetWings) || !configHandler.wingsNeedPerk
                CoL.playerRef.AddSpell(selectedWingSpell, false)
            endif
        endif
    EndFunction

    Function RemoveWings()
        if selectedWingSpell != None
            CoL.playerRef.RemoveSpell(selectedWingSpell)
        endif
    EndFunction
EndState

bool Function IsInterfaceActive()
    return False
EndFunction

Spell Function GetWings(int wingId)
    return None
EndFunction

Function UpdateWings()
EndFunction

Function ApplyWings()
EndFunction

Function RemoveWings()
EndFunction